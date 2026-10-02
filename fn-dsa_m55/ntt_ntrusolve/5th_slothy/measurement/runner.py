#!/usr/bin/env python3
"""Run and validate the three stage-3 NUCLEO-N657X0-Q candidates."""

import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[2]
MEAS = WORK / "measurement_mlkem_native"
# Preserve the historical stage-3 source/ELF pair after ntt_opt is promoted.
# This selects complete archived sources, never assembly fragments.
NTT_OPT_ARCHIVE = ROOT.parent / "ntt_opt_4thStage/integration/before"
NTT_OPT_BASELINE = (
    (NTT_OPT_ARCHIVE / "source", NTT_OPT_ARCHIVE / "build")
    if (NTT_OPT_ARCHIVE / "build/zephyr/zephyr.elf").exists()
    else (WORK / "fn-dsa_m55/ntt_opt", MEAS / "build-ntt-opt")
)
CANDIDATES = {
    "ntt_opt": NTT_OPT_BASELINE,
    "ref": (ROOT / "ref", MEAS / "build-stage3-ref"),
    "m1": (ROOT / "m1_3instruction_montgomery", MEAS / "build-stage3-m1"),
    "b1": (ROOT / "b1_3instruction_Barrett", MEAS / "build-stage3-b1"),
}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tree_sha(source: Path) -> str:
    digest = hashlib.sha256()
    for path in sorted(source.iterdir()):
        if path.suffix not in (".c", ".h", ".s"):
            continue
        digest.update(path.name.encode())
        digest.update(b"\0")
        digest.update(path.read_bytes())
        digest.update(b"\0")
    return digest.hexdigest()


def now() -> str:
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def validate_measurements(raw: str, pilot: bool):
    nbatch, niter = (1, 1) if pilot else (10, 10)
    pattern = (r"^BATCH degree=(\d+) batch=(\d+) op=(\d+) "
               r"total=(\d+) per_call=(\d+)$")
    names = ("degree", "batch", "operation", "total", "per_call")
    samples = [dict(zip(names, map(int, match)))
               for match in re.findall(pattern, raw, re.M)]
    expected = {(degree, batch, operation)
                for degree in (512, 1024)
                for batch in range(nbatch) for operation in range(3)}
    observed = [(x["degree"], x["batch"], x["operation"])
                for x in samples]
    errors = []
    if len(observed) != len(expected) or set(observed) != expected:
        errors.append("missing/duplicate/unexpected BATCH coordinates")
    if any(x["total"] <= 0 or x["per_call"] != x["total"] // niter
           for x in samples):
        errors.append("invalid cycle total or per-call division")
    summary_seen = set()
    for line in re.findall(r"^SUMMARY (.+)$", raw, re.M):
        fields = dict(re.findall(r"(\w+)=(\d+)", line))
        if "degree" not in fields or "op" not in fields:
            errors.append("malformed SUMMARY")
            continue
        degree, operation = int(fields["degree"]), int(fields["op"])
        summary_seen.add((degree, operation))
        totals = sorted(x["total"] for x in samples
                        if x["degree"] == degree
                        and x["operation"] == operation)
        if len(totals) != nbatch:
            errors.append("SUMMARY sample count mismatch")
            continue
        calculated = {
            "degree": degree, "op": operation,
            "upper_median": totals[nbatch >> 1] // niter,
        }
        for percentile in (1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 99):
            calculated[f"p{percentile}"] = (
                totals[nbatch * percentile // 100] // niter)
        if {key: int(value) for key, value in fields.items()} != calculated:
            errors.append("SUMMARY differs from BATCH records")
    if summary_seen != {(degree, operation) for degree in (512, 1024)
                        for operation in range(3)}:
        errors.append("missing/unexpected SUMMARY coordinates")
    mode = "pilot" if pilot else "full"
    begin = (f"FNDSA_BEGIN mode={mode} batches={nbatch} "
             f"warmups={niter} iterations={niter}")
    if raw.splitlines().count(begin) != 1:
        errors.append("incorrect mode/count banner")
    return samples, errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("candidate", choices=CANDIDATES)
    parser.add_argument("mode", choices=("pilot", "full"))
    args = parser.parse_args()
    source, build = CANDIDATES[args.candidate]
    elf = build / "zephyr" / "zephyr.elf"
    if not elf.exists():
        raise RuntimeError(f"candidate is not built: {elf}")
    elf_hash = sha(elf)
    source_hash = tree_sha(source)
    output_root = ROOT / "results" / args.candidate
    output_root.mkdir(parents=True, exist_ok=True)
    pilot_record = output_root / "pilot_validated.json"
    if args.mode == "full":
        approved = json.loads(pilot_record.read_text())
        if (not approved["valid"] or approved["elf_sha256"] != elf_hash
                or approved["source_tree_sha256"] != source_hash):
            raise RuntimeError("exact ELF and sources must pass pilot first")

    stamp = datetime.datetime.now(datetime.timezone.utc).strftime(
        "%Y%m%dT%H%M%SZ")
    run_dir = output_root / "runs" / f"{args.mode}-{stamp}"
    run_dir.mkdir(parents=True, exist_ok=False)
    toolchain = Path(os.environ.get(
        "GNUARMEMB_TOOLCHAIN_PATH",
        str(MEAS / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi")))
    compiler = toolchain / "bin"
    env = os.environ.copy()
    env.update({
        "FNDSA_LOADER_MODE": "upstream",
        "MLKEM_NATIVE_PINNED_ROOT": str(
            MEAS / "env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f"),
        "OPENOCD": str(MEAS / "env/openocd-4e9b167/bin/openocd"),
        "OPENOCD_SERIAL": "003C00223335510735383531",
        "OPENOCD_SPEED": "8000",
        "OPENOCD_TRANSPORT": "swd",
        "OPENOCD_SCRIPTS": str(MEAS / "env/openocd-4e9b167/share/openocd/scripts"),
        "OPENOCD_INTERFACE": "interface/stlink.cfg",
        "OPENOCD_TARGET": "target/stm32n6x.cfg",
        "GDB_PORT": "3349",
        "GDB_RUN_TIMEOUT": "1800",
        "SWO_TRACECLK": "100000000",
        "SWO_PIN_FREQ": "1000000",
        "SWO_FORMATTER": "0",
        "GDB": str(compiler / "arm-none-eabi-gdb"),
        "NM": str(compiler / "arm-none-eabi-nm"),
        "READELF": str(compiler / "arm-none-eabi-readelf"),
    })
    command = [sys.executable, str(MEAS / "exec_with_tcm_init.py"),
               "--verbose", str(elf)]
    if args.mode == "pilot":
        command.append("--pilot")
    meta = {
        "candidate": args.candidate,
        "mode": args.mode,
        "started_utc": now(),
        "command": command,
        "elf_sha256": elf_hash,
        "source_tree_sha256": source_hash,
        "probe": env["OPENOCD_SERIAL"],
    }
    (run_dir / "run.json").write_text(json.dumps(meta, indent=2) + "\n")
    with (run_dir / "raw.log").open("w") as log:
        process = subprocess.Popen(command, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT, text=True, env=env)
        assert process.stdout is not None
        for line in process.stdout:
            log.write(line)
            log.flush()
            print(line, end="", flush=True)
        returncode = process.wait()

    raw = (run_dir / "raw.log").read_text()
    # OpenOCD diagnostics and SWO share one captured stream.  An asynchronous
    # "Info : ..." line can land in the middle of one SWO digest line; remove
    # only those debugger diagnostics before parsing, while retaining raw.log.
    parsed = re.sub(r"Info : [^\n]*\n", "", raw)
    host = (MEAS / "host" / f"{args.mode}.log").read_text()
    digest_pattern = r"^(?:DIGEST|AUDIT) degree=.+$"
    expected_digests = re.findall(digest_pattern, host, re.M)
    observed_digests = re.findall(digest_pattern, parsed, re.M)
    samples, errors = validate_measurements(parsed, args.mode == "pilot")
    mscr = re.findall(r"^TCM_MSCR_(START|END)=(0x[0-9a-f]+)$", parsed, re.M)
    if ([kind for kind, _ in mscr] != ["START", "END"]
            or any(int(value, 16) & 0x12 != 0x2 for _, value in mscr)):
        errors.append("TCM ECC state missing or disabled")
    for register in ("CFSR", "HFSR", "AFSR"):
        if re.findall(rf"^{register}=(0x[0-9a-f]+)$", parsed, re.M) != ["0x0"]:
            errors.append(f"{register} missing or nonzero")
    expected_digest_count = 4 if args.mode == "pilot" else 22
    valid = (returncode == 0 and not errors
             and expected_digests == observed_digests
             and len(expected_digests) == expected_digest_count
             and "FNDSA_DONE correctness=PASS tamper_rejection=PASS" in parsed
             and "FNDSA_FAILURE" not in parsed)
    meta.update({
        "ended_utc": now(), "returncode": returncode, "valid": valid,
        "host_digests_match": expected_digests == observed_digests,
        "validation_errors": errors, "samples": samples,
        "raw_log_sha256": sha(run_dir / "raw.log"),
    })
    (run_dir / "run.json").write_text(json.dumps(meta, indent=2) + "\n")
    if valid:
        record = {
            "valid": True, "candidate": args.candidate,
            "elf_sha256": elf_hash, "source_tree_sha256": source_hash,
            "run_directory": str(run_dir), "ended_utc": meta["ended_utc"],
        }
        (output_root / f"{args.mode}_validated.json").write_text(
            json.dumps(record, indent=2) + "\n")
    print(f"VALIDATED={valid} RUN_DIR={run_dir}", flush=True)
    return 0 if valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
