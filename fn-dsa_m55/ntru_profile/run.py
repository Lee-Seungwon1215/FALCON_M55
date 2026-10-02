#!/usr/bin/env python3
"""Run and validate one NTRU-internal profile firmware on the M55 board."""
from __future__ import annotations

import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent
WORK = ROOT.parent
SOURCE = WORK / "ntt_opt_slothy"
COMMON = WORK / "measurement_mlkem_native"
CANDIDATES = ("control", "detailed", "logn", "ntt_opt_control", "ntt_opt_fft")
PHASES = [
	"orchestration", "deepest", "intermediate_d1", "intermediate_d2",
	"intermediate_d3", "intermediate_d4", "intermediate_d5",
	"intermediate_d6", "intermediate_d7", "intermediate_d8",
	"intermediate_d9", "depth0",
]
KERNELS = [
	"other", "mp_ntt", "mp_intt", "twiddle", "crt", "bezout", "fft",
	"ifft", "fxp_spectral", "fixed_convert", "sub_ntt", "sub_depth1",
	"sub_plain",
]


def sha(path: Path) -> str:
	return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_sha(source: Path) -> str:
	h = hashlib.sha256()
	for path in sorted(source.iterdir()):
		if path.suffix not in (".c", ".h", ".s"):
			continue
		h.update(path.name.encode())
		h.update(b"\0")
		h.update(path.read_bytes())
		h.update(b"\0")
	return h.hexdigest()


def validate(raw: str, candidate: str) -> tuple[dict, dict, dict, dict, dict, list[str]]:
	errors: list[str] = []
	mode = candidate.removeprefix("ntt_opt_")
	begin = f"PROFILE_BEGIN candidate={candidate} keygen_runs=10"
	if raw.splitlines().count(begin) != 1:
		errors.append("bad PROFILE_BEGIN")

	hw = re.search(r"^PROFILE_HW cpu=(\d+) ccr=([0-9a-f]+) itcmcr=([0-9a-f]+) "
		r"dtcmcr=([0-9a-f]+) control=([0-9a-f]+)$", raw, re.M)
	if (not hw or int(hw[1]) != 800000000 or int(hw[2], 16) & 0x30000
			or int(hw[3], 16) & 0x79 != 0x49 or int(hw[4], 16) & 0x79 != 0x49
			or int(hw[5], 16) != 0x99):
		errors.append("hardware condition mismatch")

	totals: dict[int, dict] = {}
	for degree, calls, total, minimum, maximum in re.findall(
		r"^NTRU_TOTAL degree=(\d+) calls=(\d+) total=(\d+) min=(\d+) max=(\d+)$",
		raw, re.M):
		degree_i = int(degree)
		if degree_i in totals:
			errors.append("duplicate NTRU_TOTAL")
		totals[degree_i] = {
			"calls": int(calls), "total": int(total), "minimum": int(minimum),
			"maximum": int(maximum),
		}

	phase_data: dict[tuple[int, str], dict] = {}
	for degree, name, cycles, entries in re.findall(
		r"^NTRU_PHASE degree=(\d+) phase=(\w+) cycles=(\d+) entries=(\d+)$",
		raw, re.M):
		key = (int(degree), name)
		if key in phase_data:
			errors.append("duplicate NTRU_PHASE")
		phase_data[key] = {"cycles": int(cycles), "entries": int(entries)}

	kernel_data: dict[tuple[int, str], dict] = {}
	for degree, name, cycles, entries in re.findall(
		r"^NTRU_KERNEL degree=(\d+) kernel=(\w+) cycles=(\d+) entries=(\d+)$",
		raw, re.M):
		key = (int(degree), name)
		if key in kernel_data:
			errors.append("duplicate NTRU_KERNEL")
		kernel_data[key] = {"cycles": int(cycles), "entries": int(entries)}

	ntt_logn_data: dict[tuple[int, str, int], dict] = {}
	for degree, direction, logn, cycles, entries in re.findall(
		r"^NTRU_NTT_LOGN degree=(\d+) direction=(forward|inverse) "
		r"logn=(\d+) cycles=(\d+) entries=(\d+)$", raw, re.M):
		key = (int(degree), direction, int(logn))
		if key in ntt_logn_data:
			errors.append("duplicate NTRU_NTT_LOGN")
		ntt_logn_data[key] = {"cycles": int(cycles), "entries": int(entries)}

	if set(totals) != {512, 1024}:
		errors.append("missing/unexpected totals")
	if set(phase_data) != {(d, p) for d in (512, 1024) for p in PHASES}:
		errors.append("missing/unexpected phases")
	if set(kernel_data) != {(d, k) for d in (512, 1024) for k in KERNELS}:
		errors.append("missing/unexpected kernels")
	if set(ntt_logn_data) != {
			(d, direction, logn) for d in (512, 1024)
			for direction in ("forward", "inverse") for logn in range(11)}:
		errors.append("missing/unexpected NTT logn data")

	if set(totals) == {512, 1024} and len(phase_data) == 2 * len(PHASES) \
			and len(kernel_data) == 2 * len(KERNELS):
		for degree in (512, 1024):
			t = totals[degree]
			if t["calls"] < 10 or t["total"] <= 0 or t["minimum"] <= 0 \
					or t["maximum"] < t["minimum"]:
				errors.append(f"invalid total {degree}")
			if sum(phase_data[(degree, p)]["cycles"] for p in PHASES) != t["total"]:
				errors.append(f"phase sum mismatch {degree}")
			if sum(kernel_data[(degree, k)]["cycles"] for k in KERNELS) != t["total"]:
				errors.append(f"kernel sum mismatch {degree}")
			if mode == "detailed":
				for p in ("deepest", "intermediate_d1", "depth0"):
					if phase_data[(degree, p)]["cycles"] == 0:
						errors.append(f"inactive phase {degree} {p}")
				for k in ("mp_ntt", "mp_intt", "twiddle", "crt", "bezout", "fft", "ifft"):
					if kernel_data[(degree, k)]["cycles"] == 0:
						errors.append(f"inactive kernel {degree} {k}")
			elif mode == "fft":
				if any(phase_data[(degree, p)]["cycles"] for p in PHASES if p != "orchestration"):
					errors.append(f"unexpected phase hook {degree}")
				active_kernels = {"fft", "ifft", "fxp_spectral", "fixed_convert"}
				for k in KERNELS:
					entry = kernel_data[(degree, k)]
					if k in active_kernels and (entry["cycles"] <= 0 or entry["entries"] <= 0):
						errors.append(f"inactive FFT kernel {degree} {k}")
					if k not in active_kernels | {"other"} and (entry["cycles"] or entry["entries"]):
						errors.append(f"unexpected kernel hook {degree} {k}")
			else:
				if any(phase_data[(degree, p)]["cycles"] for p in PHASES if p != "orchestration"):
					errors.append(f"control phase hooks active {degree}")
				if any(kernel_data[(degree, k)]["cycles"] for k in KERNELS if k != "other"):
					errors.append(f"control kernel hooks active {degree}")
			if mode == "logn":
				maximum_logn = 9 if degree == 512 else 10
				for direction in ("forward", "inverse"):
					for logn in range(1, maximum_logn + 1):
						entry = ntt_logn_data[(degree, direction, logn)]
						if entry["cycles"] == 0 or entry["entries"] == 0:
							errors.append(
								f"inactive NTT logn {degree} {direction} {logn}")
			elif any(v["cycles"] or v["entries"] for v in ntt_logn_data.values()):
				errors.append(f"NTT logn hooks unexpectedly active in {candidate}")

	keygen_calls = {int(d): int(c) for d, c in re.findall(
		r"^PROFILE_KEYGEN degree=(512|1024) calls=(\d+)$", raw, re.M)}
	if keygen_calls != {512: 10, 1024: 10}:
		errors.append("keygen call count mismatch")
	fingerprints = {int(d): value for d, value in re.findall(
		r"^PROFILE_FINGERPRINT degree=(512|1024) fnv1a=([0-9a-f]{8})$", raw, re.M)}
	if set(fingerprints) != {512, 1024}:
		errors.append("fingerprints missing")
	if "PROFILE_STATUS error=0 result=0" not in raw:
		errors.append("profiler or operation error")
	if "PROFILE_DONE correctness=PASS tamper_rejection=PASS" not in raw:
		errors.append("correctness/tamper test failed")
	if re.findall(r"^TCM_CONTROL_(START|END)=(0x[0-9a-f]+)$", raw, re.M) != [
			("START", "0x99"), ("END", "0x99")]:
		errors.append("TCM control mismatch")
	mscr = re.findall(r"^TCM_MSCR_(START|END)=(0x[0-9a-f]+)$", raw, re.M)
	if [x[0] for x in mscr] != ["START", "END"] or any(
			int(x[1], 16) & 0x12 != 2 for x in mscr):
		errors.append("TCM ECC missing/disabled")
	for register in ("CFSR", "HFSR", "AFSR"):
		if re.findall(rf"^{register}=(0x[0-9a-f]+)$", raw, re.M) != ["0x0"]:
			errors.append(f"{register} missing/nonzero")
	return totals, phase_data, kernel_data, ntt_logn_data, fingerprints, errors


def main() -> int:
	if len(sys.argv) != 2 or sys.argv[1] not in CANDIDATES:
		raise SystemExit("usage: run.py control|detailed|logn|ntt_opt_control|ntt_opt_fft")
	candidate = sys.argv[1]
	mode = candidate.removeprefix("ntt_opt_")
	source = WORK / "ntt_opt" if candidate.startswith("ntt_opt_") else SOURCE
	build = ROOT / "build" / candidate
	elf = build / "zephyr/zephyr.elf"
	if not elf.exists():
		raise SystemExit(f"missing build: {elf}")
	manifest = json.loads((build / "generated/manifest.json").read_text())
	if manifest["mode"] != mode:
		raise SystemExit("wrong instrumentation mode")
	for name, metadata in manifest["files"].items():
		if metadata["sha256"] != sha(source / name):
			raise SystemExit(f"stale generated source: {name}")
	compile_commands = json.loads((build / "compile_commands.json").read_text())
	asm_entries = [entry for entry in compile_commands
		if Path(entry["file"]).name == "mq_cm55.s"]
	if len(asm_entries) != 1 or Path(asm_entries[0]["file"]).parent != source:
		raise SystemExit("wrong mq assembly input")
	provenance = None
	if candidate.startswith("ntt_opt_"):
		from latest import check
		provenance = check(candidate)

	stamp = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
	run_dir = ROOT / "results" / candidate / "runs" / stamp
	run_dir.mkdir(parents=True)
	toolchain = COMMON / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi"
	environment = os.environ.copy()
	environment.update({
		"FNDSA_LOADER_MODE": "upstream",
		"MLKEM_NATIVE_PINNED_ROOT": str(COMMON / "env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f"),
		"OPENOCD": str(COMMON / "env/openocd-4e9b167/bin/openocd"),
		"OPENOCD_SERIAL": "003C00223335510735383531",
		"OPENOCD_SPEED": "8000", "OPENOCD_TRANSPORT": "swd",
		"OPENOCD_SCRIPTS": str(COMMON / "env/openocd-4e9b167/share/openocd/scripts"),
		"OPENOCD_INTERFACE": "interface/stlink.cfg",
		"OPENOCD_TARGET": "target/stm32n6x.cfg", "GDB_PORT": "3349",
		"GDB_RUN_TIMEOUT": "1800", "SWO_TRACECLK": "100000000",
		"SWO_PIN_FREQ": "1000000", "SWO_FORMATTER": "0",
		"GDB": str(toolchain / "bin/arm-none-eabi-gdb"),
		"NM": str(toolchain / "bin/arm-none-eabi-nm"),
		"READELF": str(toolchain / "bin/arm-none-eabi-readelf"),
		"PYTHONDONTWRITEBYTECODE": "1",
	})
	loader = source / "measurement/exec_board.py"
	if provenance is not None:
		loader = WORK / "ntt_final_compare/exec_board.py"
	command = [sys.executable, str(loader),
		"--verbose", str(elf)]
	metadata = {
		"candidate": candidate,
		"started_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
		"command": command, "source_tree_sha256": tree_sha(source),
		"elf_sha256": sha(elf), "mq_assembly": str(source / "mq_cm55.s"),
		"probe": environment["OPENOCD_SERIAL"],
	}
	if provenance is not None:
		metadata["build_provenance"] = provenance
	(run_dir / "run.json").write_text(json.dumps(metadata, indent=2) + "\n")
	with (run_dir / "raw.log").open("w") as log:
		process = subprocess.Popen(command, stdout=subprocess.PIPE,
			stderr=subprocess.STDOUT, text=True, env=environment)
		assert process.stdout is not None
		for line in process.stdout:
			log.write(line)
			log.flush()
			print(line, end="", flush=True)
		returncode = process.wait()
	raw = re.sub(r"Info : [^\n]*\n", "", (run_dir / "raw.log").read_text())
	totals, phases, kernels, ntt_logn, fingerprints, errors = validate(raw, candidate)
	if provenance is not None:
		try:
			if check(candidate) != provenance:
				errors.append("source or build changed during measurement")
		except (RuntimeError, OSError, ValueError) as exc:
			errors.append(str(exc))
		baseline = json.loads((ROOT / "results/control/validated.json").read_text())
		if {str(d): value for d, value in fingerprints.items()} != baseline["fingerprints"]:
			errors.append("key fingerprints differ from deterministic reference")
	valid = returncode == 0 and not errors
	metadata.update({
		"ended_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
		"returncode": returncode, "valid": valid, "validation_errors": errors,
		"totals": {str(k): v for k, v in totals.items()},
		"phases": {f"{d}_{n}": v for (d, n), v in phases.items()},
		"kernels": {f"{d}_{n}": v for (d, n), v in kernels.items()},
		"ntt_logn": {f"{d}_{direction}_{logn}": v
			for (d, direction, logn), v in ntt_logn.items()},
		"fingerprints": fingerprints, "raw_log_sha256": sha(run_dir / "raw.log"),
	})
	(run_dir / "run.json").write_text(json.dumps(metadata, indent=2) + "\n")
	if valid:
		record = {key: metadata[key] for key in (
			"candidate", "source_tree_sha256", "elf_sha256", "mq_assembly",
			"fingerprints", "raw_log_sha256", "ended_utc")}
		record.update({"valid": True, "run_directory": str(run_dir)})
		validated = ROOT / "results" / candidate / "validated.json"
		validated.parent.mkdir(parents=True, exist_ok=True)
		validated.write_text(json.dumps(record, indent=2) + "\n")
	print(f"VALIDATED={valid} ERRORS={errors} RUN_DIR={run_dir}")
	return 0 if valid else 1


if __name__ == "__main__":
	raise SystemExit(main())
