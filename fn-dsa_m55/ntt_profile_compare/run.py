#!/usr/bin/env python3
"""Run one instrumented firmware and strictly validate its board log."""
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
}
EXPECTED_CALLS = {"keygen": 10, "sign": 100, "verify": 100}
CATEGORIES = [
    "other", "shake", "codec", "hash_to_point", "message_hash",
    "fft_fixed", "fft_fpr", "ntt_q", "ntt_modp", "keygen_other",
    "key_preparation", "ntru_other", "crt", "ldl_ffsampling",
    "sampler_other", "gaussian_fg", "gaussian0", "berexp", "norm",
    "sign_other", "verify_other",
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_sha(source):
    h = hashlib.sha256()
    for path in sorted(source.iterdir()):
        if path.suffix not in (".c", ".h", ".s"):
            continue
        h.update(path.name.encode()); h.update(b"\0")
        h.update(path.read_bytes()); h.update(b"\0")
    return h.hexdigest()


def validate(raw, candidate):
    errors = []
    if raw.splitlines().count(
            f"PROFILE_BEGIN candidate={candidate} keygen_runs=10 sign_runs=100 verify_runs=100") != 1:
        errors.append("bad PROFILE_BEGIN")
    hw = re.search(r"^PROFILE_HW cpu=(\d+) ccr=([0-9a-f]+) itcmcr=([0-9a-f]+) "
                   r"dtcmcr=([0-9a-f]+) control=([0-9a-f]+)$", raw, re.M)
    if (not hw or int(hw[1]) != 800000000 or int(hw[2], 16) & 0x30000
            or int(hw[3], 16) & 0x79 != 0x49 or int(hw[4], 16) & 0x79 != 0x49
            or int(hw[5], 16) != 0x99):
        errors.append("hardware condition mismatch")
    total_pattern = (r"^PROFILE_TOTAL degree=(\d+) operation=(\w+) calls=(\d+) "
                     r"total=(\d+) min=(\d+) max=(\d+)$")
    totals = {}
    for d, op, calls, total, minimum, maximum in re.findall(total_pattern, raw, re.M):
        key = (int(d), op)
        if key in totals:
            errors.append("duplicate PROFILE_TOTAL")
        totals[key] = {"calls": int(calls), "total": int(total),
                       "minimum": int(minimum), "maximum": int(maximum)}
    expected = {(d, op) for d in (512, 1024) for op in EXPECTED_CALLS}
    if set(totals) != expected:
        errors.append("missing/unexpected PROFILE_TOTAL")
    categories = {}
    pattern = (r"^PROFILE_CATEGORY degree=(\d+) operation=(\w+) category=(\w+) "
               r"cycles=(\d+) entries=(\d+)$")
    for d, op, category, cycles, entries in re.findall(pattern, raw, re.M):
        key = (int(d), op, category)
        if key in categories:
            errors.append("duplicate PROFILE_CATEGORY")
        categories[key] = {"cycles": int(cycles), "entries": int(entries)}
    expected_categories = {(d, op, c) for d in (512, 1024)
                           for op in EXPECTED_CALLS for c in CATEGORIES}
    if set(categories) != expected_categories:
        errors.append("missing/unexpected PROFILE_CATEGORY")
    for key, value in totals.items():
        if value["calls"] != EXPECTED_CALLS[key[1]] or value["total"] <= 0:
            errors.append(f"bad calls/total {key}")
        if value["minimum"] <= 0 or value["maximum"] < value["minimum"]:
            errors.append(f"bad min/max {key}")
        if sum(categories[(key[0], key[1], c)]["cycles"] for c in CATEGORIES) != value["total"]:
            errors.append(f"categories do not sum to total {key}")
    if (set(categories) == expected_categories
            and any(categories[(d, op, "ntt_q")]["entries"] == 0 for d, op in expected)):
        errors.append("assembly NTT/iNTT wrapper was not reached")
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
    for reg in ("CFSR", "HFSR", "AFSR"):
        if re.findall(rf"^{reg}=(0x[0-9a-f]+)$", raw, re.M) != ["0x0"]:
            errors.append(f"{reg} missing/nonzero")
    return totals, categories, fingerprints, errors


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in CANDIDATES:
        raise SystemExit("usage: run.py before|after")
    candidate = sys.argv[1]
    source, build, mq_asm = CANDIDATES[candidate]
    elf = build / "zephyr/zephyr.elf"
    if not elf.exists():
        raise SystemExit(f"missing build: {elf}")
    manifest = json.loads((build / "generated/manifest.json").read_text())
    for name, meta in manifest["files"].items():
        if meta["sha256"] != sha(source / name):
            raise SystemExit(f"stale generated source: {name}")
    compile_commands = json.loads((build / "compile_commands.json").read_text())
    asm_entries = [e for e in compile_commands if Path(e["file"]).name == mq_asm]
    if len(asm_entries) != 1 or Path(asm_entries[0]["file"]).parent != source:
        raise SystemExit("wrong mq assembly input")
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    run_dir = ROOT / "results" / candidate / "runs" / stamp
    run_dir.mkdir(parents=True)
    toolchain = COMMON / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi"
    env = os.environ.copy()
    env.update({
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
    command = [sys.executable, str(WORK / "ntt_opt_slothy/measurement/exec_board.py"),
               "--verbose", str(elf)]
    meta = {"candidate": candidate, "started_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
            "command": command, "source_tree_sha256": tree_sha(source), "elf_sha256": sha(elf),
            "mq_assembly": str(source / mq_asm), "probe": env["OPENOCD_SERIAL"]}
    (run_dir / "run.json").write_text(json.dumps(meta, indent=2) + "\n")
    with (run_dir / "raw.log").open("w") as log:
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                   text=True, env=env)
        assert process.stdout is not None
        for line in process.stdout:
            log.write(line); log.flush(); print(line, end="", flush=True)
        returncode = process.wait()
    raw = re.sub(r"Info : [^\n]*\n", "", (run_dir / "raw.log").read_text())
    totals, categories, fingerprints, errors = validate(raw, candidate)
    valid = returncode == 0 and not errors
    meta.update({"ended_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
                 "returncode": returncode, "valid": valid, "validation_errors": errors,
                 "totals": {f"{d}_{op}": v for (d, op), v in totals.items()},
                 "categories": {f"{d}_{op}_{c}": v for (d, op, c), v in categories.items()},
                 "fingerprints": fingerprints, "raw_log_sha256": sha(run_dir / "raw.log")})
    (run_dir / "run.json").write_text(json.dumps(meta, indent=2) + "\n")
    if valid:
        record = {k: meta[k] for k in ("candidate", "source_tree_sha256", "elf_sha256",
                  "mq_assembly", "fingerprints", "raw_log_sha256", "ended_utc")}
        record.update({"valid": True, "run_directory": str(run_dir)})
        out = ROOT / "results" / candidate / "validated.json"
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(json.dumps(record, indent=2) + "\n")
    print(f"VALIDATED={valid} ERRORS={errors} RUN_DIR={run_dir}")
    return 0 if valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
