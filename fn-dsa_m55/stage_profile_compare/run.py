#!/usr/bin/env python3
"""Run and strictly validate one stage-profile firmware on the M55 board."""
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
COMMON = WORK / "measurement_mlkem_native"
CANDIDATES = {
	"before": (WORK / "ref", ROOT / "build/before", "mq_cm4.s"),
	"after": (WORK / "ntt_opt_slothy", ROOT / "build/after", "mq_cm55.s"),
	"preslothy": (WORK / "ntt_ntrusolve/ref_preslothy", ROOT / "build/preslothy", "mq_cm55.s"),
	"ntt_opt": (WORK / "ntt_opt", ROOT / "build/ntt_opt", "mq_cm55.s"),
}
EXPECTED_CALLS = {"keygen": 10, "sign": 100, "verify": 100}
CATEGORIES = [
	"other",
	"kg_generate", "kg_check", "kg_ntru", "kg_sk_complete", "kg_pk_compute",
	"sg_message_hash", "sg_key_prep", "sg_hash_to_point", "sg_fft_basis",
	"sg_ldl_ffsampling", "sg_gaussian_berexp", "sg_recon_norm", "sg_encode",
	"vr_message_hash", "vr_decode", "vr_ntt", "vr_hash_to_point",
	"vr_poly", "vr_norm",
]
EXPECTED_ACTIVE = {
	"keygen": {"kg_generate", "kg_check", "kg_ntru", "kg_sk_complete", "kg_pk_compute"},
	"sign": {"sg_message_hash", "sg_key_prep", "sg_hash_to_point", "sg_fft_basis",
		"sg_ldl_ffsampling", "sg_gaussian_berexp", "sg_recon_norm", "sg_encode"},
	"verify": {"vr_message_hash", "vr_decode", "vr_ntt", "vr_hash_to_point",
		"vr_poly", "vr_norm"},
}


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


def validate(raw: str, candidate: str) -> tuple[dict, dict, dict, list[str]]:
	errors: list[str] = []
	begin = f"PROFILE_BEGIN candidate={candidate} keygen_runs=10 sign_runs=100 verify_runs=100"
	if raw.splitlines().count(begin) != 1:
		errors.append("bad PROFILE_BEGIN")
	hw = re.search(r"^PROFILE_HW cpu=(\d+) ccr=([0-9a-f]+) itcmcr=([0-9a-f]+) "
		r"dtcmcr=([0-9a-f]+) control=([0-9a-f]+)$", raw, re.M)
	if (not hw or int(hw[1]) != 800000000 or int(hw[2], 16) & 0x30000
			or int(hw[3], 16) & 0x79 != 0x49 or int(hw[4], 16) & 0x79 != 0x49
			or int(hw[5], 16) != 0x99):
		errors.append("hardware condition mismatch")

	total_pattern = (r"^PROFILE_TOTAL degree=(\d+) operation=(\w+) calls=(\d+) "
		r"total=(\d+) min=(\d+) max=(\d+)$")
	totals: dict[tuple[int, str], dict] = {}
	for degree, operation, calls, total, minimum, maximum in re.findall(total_pattern, raw, re.M):
		key = (int(degree), operation)
		if key in totals:
			errors.append("duplicate PROFILE_TOTAL")
		totals[key] = {"calls": int(calls), "total": int(total),
			"minimum": int(minimum), "maximum": int(maximum)}
	expected_totals = {(d, op) for d in (512, 1024) for op in EXPECTED_CALLS}
	if set(totals) != expected_totals:
		errors.append("missing/unexpected PROFILE_TOTAL")

	category_pattern = (r"^PROFILE_CATEGORY degree=(\d+) operation=(\w+) category=(\w+) "
		r"cycles=(\d+) entries=(\d+)$")
	categories: dict[tuple[int, str, str], dict] = {}
	for degree, operation, category, cycles, entries in re.findall(category_pattern, raw, re.M):
		key = (int(degree), operation, category)
		if key in categories:
			errors.append("duplicate PROFILE_CATEGORY")
		categories[key] = {"cycles": int(cycles), "entries": int(entries)}
	expected_categories = {(d, op, c) for d in (512, 1024)
		for op in EXPECTED_CALLS for c in CATEGORIES}
	if set(categories) != expected_categories:
		errors.append("missing/unexpected PROFILE_CATEGORY")

	if set(totals) == expected_totals and set(categories) == expected_categories:
		for key, total in totals.items():
			degree, operation = key
			if total["calls"] != EXPECTED_CALLS[operation] or total["total"] <= 0:
				errors.append(f"bad calls/total {key}")
			if total["minimum"] <= 0 or total["maximum"] < total["minimum"]:
				errors.append(f"bad min/max {key}")
			if sum(categories[(degree, operation, c)]["cycles"] for c in CATEGORIES) != total["total"]:
				errors.append(f"categories do not sum to total {key}")
			for category in CATEGORIES:
				entry = categories[(degree, operation, category)]
				if category in EXPECTED_ACTIVE[operation]:
					if entry["entries"] == 0 or entry["cycles"] == 0:
						errors.append(f"inactive expected phase {(degree, operation, category)}")
				elif category != "other" and (entry["entries"] != 0 or entry["cycles"] != 0):
					errors.append(f"cross-operation phase {(degree, operation, category)}")

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
	if [x[0] for x in mscr] != ["START", "END"] or any(int(x[1], 16) & 0x12 != 2 for x in mscr):
		errors.append("TCM ECC missing/disabled")
	for register in ("CFSR", "HFSR", "AFSR"):
		if re.findall(rf"^{register}=(0x[0-9a-f]+)$", raw, re.M) != ["0x0"]:
			errors.append(f"{register} missing/nonzero")
	return totals, categories, fingerprints, errors


def main() -> int:
	if len(sys.argv) != 2 or sys.argv[1] not in CANDIDATES:
		raise SystemExit("usage: run.py before|after|preslothy|ntt_opt")
	candidate = sys.argv[1]
	source, build, mq_asm = CANDIDATES[candidate]
	elf = build / "zephyr/zephyr.elf"
	if not elf.exists():
		raise SystemExit(f"missing build: {elf}")
	manifest = json.loads((build / "generated/manifest.json").read_text())
	for name, metadata in manifest["files"].items():
		if metadata["sha256"] != sha(source / name):
			raise SystemExit(f"stale generated source: {name}")
	compile_commands = json.loads((build / "compile_commands.json").read_text())
	asm_entries = [entry for entry in compile_commands if Path(entry["file"]).name == mq_asm]
	if len(asm_entries) != 1 or Path(asm_entries[0]["file"]).parent != source:
		raise SystemExit("wrong mq assembly input")
	provenance = None
	if candidate == "preslothy":
		from provenance import check
		provenance = check()
	elif candidate == "ntt_opt":
		from ntt_opt_audit import check
		provenance = check()

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
		"OPENOCD_INTERFACE": "interface/stlink.cfg", "OPENOCD_TARGET": "target/stm32n6x.cfg",
		"GDB_PORT": "3349", "GDB_RUN_TIMEOUT": "1800",
		"SWO_TRACECLK": "100000000", "SWO_PIN_FREQ": "1000000", "SWO_FORMATTER": "0",
		"GDB": str(toolchain / "bin/arm-none-eabi-gdb"),
		"NM": str(toolchain / "bin/arm-none-eabi-nm"),
		"READELF": str(toolchain / "bin/arm-none-eabi-readelf"),
		"PYTHONDONTWRITEBYTECODE": "1",
	})
	loader = WORK / "ntt_opt_slothy/measurement/exec_board.py"
	if candidate == "ntt_opt":
		loader = WORK / "ntt_final_compare/exec_board.py"
	command = [sys.executable, str(loader),
		"--verbose", str(elf)]
	metadata = {
		"candidate": candidate,
		"started_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
		"command": command, "source_tree_sha256": tree_sha(source),
		"elf_sha256": sha(elf), "mq_assembly": str(source / mq_asm),
		"probe": environment["OPENOCD_SERIAL"],
	}
	if provenance is not None:
		metadata["build_provenance"] = provenance
	(run_dir / "run.json").write_text(json.dumps(metadata, indent=2) + "\n")
	with (run_dir / "raw.log").open("w") as log:
		process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
			text=True, env=environment)
		assert process.stdout is not None
		for line in process.stdout:
			log.write(line)
			log.flush()
			print(line, end="", flush=True)
		returncode = process.wait()
	raw = re.sub(r"Info : [^\n]*\n", "", (run_dir / "raw.log").read_text())
	totals, categories, fingerprints, errors = validate(raw, candidate)
	if candidate == "ntt_opt" and not errors:
		baseline = json.loads((ROOT / "results/before/validated.json").read_text())
		baseline_run = json.loads((Path(baseline["run_directory"]) / "run.json").read_text())
		if {str(d): value for d, value in fingerprints.items()} != baseline_run["fingerprints"]:
			errors.append("output fingerprints differ from deterministic baseline")
		for (d, op, c), entry in categories.items():
			if entry["entries"] != baseline_run["categories"][f"{d}_{op}_{c}"]["entries"]:
				errors.append(f"phase entry count differs: {d} {op} {c}")
	if provenance is not None:
		try:
			if check() != provenance:
				errors.append("build provenance changed during measurement")
		except (RuntimeError, OSError, ValueError) as exc:
			errors.append(f"build provenance check failed: {exc}")
	valid = returncode == 0 and not errors
	metadata.update({
		"ended_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
		"returncode": returncode, "valid": valid, "validation_errors": errors,
		"totals": {f"{d}_{op}": value for (d, op), value in totals.items()},
		"categories": {f"{d}_{op}_{c}": value for (d, op, c), value in categories.items()},
		"fingerprints": fingerprints, "raw_log_sha256": sha(run_dir / "raw.log"),
	})
	(run_dir / "run.json").write_text(json.dumps(metadata, indent=2) + "\n")
	if valid:
		record = {key: metadata[key] for key in ("candidate", "source_tree_sha256", "elf_sha256",
			"mq_assembly", "fingerprints", "raw_log_sha256", "ended_utc")}
		record.update({"valid": True, "run_directory": str(run_dir)})
		output = ROOT / "results" / candidate / "validated.json"
		output.parent.mkdir(parents=True, exist_ok=True)
		output.write_text(json.dumps(record, indent=2) + "\n")
	print(f"VALIDATED={valid} ERRORS={errors} RUN_DIR={run_dir}")
	return 0 if valid else 1


if __name__ == "__main__":
	raise SystemExit(main())
