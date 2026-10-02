#!/usr/bin/env python3
"""Run and validate one NTRU-internal profile firmware on the M55 board."""
from __future__ import annotations

import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import shutil


sys.dont_write_bytecode = True
TASK = Path(__file__).resolve().parent
WORK = TASK.parents[3]
STAGE = TASK.parents[1]
COMMON = WORK / "measurement_mlkem_native"
C_NAMES = ("codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 "
           "kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly "
           "sign_fpr sign_sampler vrfy").split()
S_NAMES = ("codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 kgen_mp31_cm55").split()
BUILD_MANIFEST = "provenance.json"
BUILD_ARTIFACTS = ("zephyr/zephyr.elf", "zephyr/zephyr.map", "zephyr/.config",
                   "compile_commands.json", "CMakeCache.txt", "generated/manifest.json")
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


def require(condition, message):
	if not condition:
		raise RuntimeError(message)


def write_json(path, data):
	path.write_text(json.dumps(data, indent=2) + "\n")


def source_hashes(source):
	paths = sorted(p for p in source.iterdir() if p.suffix in (".c", ".h", ".s"))
	require(all(p.is_file() and not p.is_symlink() for p in paths),
		"crypto sources must be local regular files")
	result = {p.name: sha(p) for p in paths}
	required = {n + ".c" for n in C_NAMES} | {n + ".s" for n in S_NAMES}
	require(required <= result.keys(), "missing crypto sources")
	return result


def support_hashes():
	# Also bind the generated-source producer and diagnostic harness to this build.
	paths = [TASK / "build.sh", TASK / "CMakeLists.txt"]
	paths += [WORK / "ntru_profile" / n for n in
		("instrument.py", "profile.h", "profile.c", "benchmark.c")]
	paths += [COMMON / "app" / n for n in
		("dtcm_startup.s", "generate_dtcm_linker.py", "fndsa.conf")]
	return {str(p): sha(p) for p in paths}


def artifact_hashes(build):
	paths = list(BUILD_ARTIFACTS) + ["generated/" + n + ".c" for n in C_NAMES]
	return {n: sha(build / n) for n in paths}


def prepare_build(source, build):
	build.mkdir(parents=True, exist_ok=True)
	# Invalidate the previous successful build BEFORE any compilation begins.
	manifest = {"schema": 1, "ready": False, "source_dir": str(source), "mode": "control"}
	write_json(build / BUILD_MANIFEST, manifest)
	manifest.update(sources=source_hashes(source), support=support_hashes())
	write_json(build / BUILD_MANIFEST, manifest)


def inspect_inputs(source, build, sources):
	generated = json.loads((build / "generated/manifest.json").read_text())
	require(generated["mode"] == "control" and generated["source"] == str(source),
		"wrong instrumentation source/mode")
	require(set(generated["files"]) == {n + ".c" for n in C_NAMES},
		"incomplete generated C manifest")
	for name, metadata in generated["files"].items():
		require(metadata["sha256"] == sources[name], "stale generated source: " + name)
		expected_hooks = {"solve_NTRU": "total"} if name == "kgen_ntru.c" else {}
		require(metadata["hooks"] == expected_hooks, "wrong instrumentation hooks: " + name)
	expected = {build / "generated" / (n + ".c") for n in C_NAMES}
	expected |= {source / (n + ".s") for n in S_NAMES}
	seen = set()
	for row in json.loads((build / "compile_commands.json").read_text()):
		path = Path(row["file"])
		if not path.is_absolute():
			path = Path(row["directory"]) / path
		path = path.resolve()
		if path in expected:
			require(path not in seen, "duplicate crypto compile command")
			args = row.get("arguments") or shlex.split(row["command"])
			opts = [a for a in args if re.fullmatch(r"-O(?:[0-3sgz]|fast)", a)]
			require(opts and opts[-1] == "-O3", "last crypto optimization is not -O3")
			require("-DFNDSA_MVE_MP31=1" in args, "MVE mp31 not enabled")
			seen.add(path)
		elif path.parent in (source, build / "generated"):
			raise RuntimeError("unexpected crypto compile input: " + str(path))
	require(seen == expected, "missing crypto compile inputs")


def record_build(source, build):
	manifest = json.loads((build / BUILD_MANIFEST).read_text())
	require(manifest.get("schema") == 1 and manifest.get("ready") is False
		and manifest["source_dir"] == str(source) and manifest["mode"] == "control",
		"prepare the build first")
	require(manifest["sources"] == source_hashes(source)
		and manifest["support"] == support_hashes(), "inputs changed while building; rebuild")
	inspect_inputs(source, build, manifest["sources"])
	manifest.update(artifacts=artifact_hashes(build), ready=True)
	write_json(build / BUILD_MANIFEST, manifest)
	return manifest


def check_build(source, build, expected=None):
	path = build / BUILD_MANIFEST
	require(path.is_file(), "missing build provenance; rerun build.sh (no legacy bypass)")
	manifest = json.loads(path.read_text())
	require(manifest.get("schema") == 1 and manifest.get("ready") is True
		and manifest["source_dir"] == str(source) and manifest["mode"] == "control",
		"no completed build for this source path; rebuild")
	require(manifest["sources"] == source_hashes(source), "C/H/S changed since build; rebuild")
	require(manifest["support"] == support_hashes(), "diagnostic inputs changed; rebuild")
	require(manifest["artifacts"] == artifact_hashes(build), "build artifacts changed; rebuild")
	if expected is not None:
		require(manifest == expected, "build changed during measurement")
	return manifest


def archive_build(source, build, run_dir, manifest):
	check_build(source, build, manifest)
	archive = run_dir / "source"
	archive.mkdir()
	for name in manifest["sources"]:
		shutil.copy2(source / name, archive / name)
	for name in ("zephyr.elf", "zephyr.map", ".config"):
		shutil.copy2(build / "zephyr" / name, run_dir / name)
	shutil.copy2(build / "generated/manifest.json", run_dir / "instrumentation.json")
	shutil.copy2(build / BUILD_MANIFEST, run_dir / BUILD_MANIFEST)
	check_build(source, build, manifest)
	require(source_hashes(archive) == manifest["sources"], "archived sources differ from build")
	for name in ("zephyr.elf", "zephyr.map", ".config"):
		require(sha(run_dir / name) == manifest["artifacts"]["zephyr/" + name],
			"archived artifact differs from build: " + name)
	require(sha(run_dir / "instrumentation.json") == manifest["artifacts"]["generated/manifest.json"],
		"archived instrumentation differs from build")
	require(json.loads((run_dir / BUILD_MANIFEST).read_text()) == manifest,
		"archived build provenance differs")


def validate(raw: str, candidate: str) -> tuple[dict, dict, dict, dict, dict, list[str]]:
	errors: list[str] = []
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
			if candidate == "detailed":
				for p in ("deepest", "intermediate_d1", "depth0"):
					if phase_data[(degree, p)]["cycles"] == 0:
						errors.append(f"inactive phase {degree} {p}")
				for k in ("mp_ntt", "mp_intt", "twiddle", "crt", "bezout", "fft", "ifft"):
					if kernel_data[(degree, k)]["cycles"] == 0:
						errors.append(f"inactive kernel {degree} {k}")
			else:
				if any(phase_data[(degree, p)]["cycles"] for p in PHASES if p != "orchestration"):
					errors.append(f"control phase hooks active {degree}")
				if any(kernel_data[(degree, k)]["cycles"] for k in KERNELS if k != "other"):
					errors.append(f"control kernel hooks active {degree}")
			if candidate == "logn":
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
	parser = argparse.ArgumentParser(description=__doc__)
	parser.add_argument("subject", choices=("h0_layout", "h1"))
	group = parser.add_mutually_exclusive_group()
	group.add_argument("--prepare-build", action="store_true", help="internal build.sh step; no board I/O")
	group.add_argument("--record-build", action="store_true", help="internal build.sh step; no board I/O")
	group.add_argument("--check-build", action="store_true", help="read-only checks; no board I/O")
	args = parser.parse_args()
	ROOT = TASK / args.subject
	SOURCE = STAGE / ("H1_final_scaling" if args.subject == "h1" else "experiments/h0_layout/source")
	candidate = "control"
	build = ROOT / "build" / candidate
	elf = build / "zephyr/zephyr.elf"
	if args.prepare_build or args.record_build or args.check_build:
		action = prepare_build if args.prepare_build else record_build if args.record_build else check_build
		action(SOURCE, build)
		print(f"BUILD_CHECK=PASS subject={args.subject}")
		return 0
	manifest = check_build(SOURCE, build)
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
	command = [sys.executable, str(WORK / "ntt_opt_slothy/measurement/exec_board.py"),
		"--verbose", str(elf)]
	metadata = {
		"candidate": candidate,
		"subject": args.subject, "build_provenance": manifest,
		"started_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
		"command": command, "source_tree_sha256": tree_sha(SOURCE),
		"elf_sha256": sha(elf), "mq_assembly": str(SOURCE / "mq_cm55.s"),
		"probe": environment["OPENOCD_SERIAL"],
	}
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
	try:
		check_build(SOURCE, build, manifest)
		if returncode == 0 and not errors:
			archive_build(SOURCE, build, run_dir, manifest)
	except (RuntimeError, OSError, ValueError, KeyError) as exc:
		errors.append("build provenance failure: " + str(exc))
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
		record.update({"valid": True, "run_directory": str(run_dir),
			"subject": args.subject, "build_provenance_sha256": sha(run_dir / BUILD_MANIFEST)})
		validated = ROOT / "results" / candidate / "validated.json"
		validated.parent.mkdir(parents=True, exist_ok=True)
		validated.write_text(json.dumps(record, indent=2) + "\n")
	print(f"VALIDATED={valid} ERRORS={errors} RUN_DIR={run_dir}")
	return 0 if valid else 1


if __name__ == "__main__":
	try:
		raise SystemExit(main())
	except (RuntimeError, OSError, ValueError, KeyError) as exc:
		print("NTRU_ERROR: " + str(exc), file=sys.stderr)
		raise SystemExit(1)
