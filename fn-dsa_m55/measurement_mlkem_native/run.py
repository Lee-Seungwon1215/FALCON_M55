#!/usr/bin/env python3
"""Run pinned upstream RAM/SWO behavior with early fault capture; retain logs."""
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


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def validate_measurements(raw, pilot):
    """Validate the exact grid and recompute every reported statistic."""
    nbatch, niter = (1, 1) if pilot else (10, 10)
    batch_re = (r"^BATCH degree=(\d+) batch=(\d+) op=(\d+) "
                r"total=(\d+) per_call=(\d+)$")
    samples = [dict(zip(("degree", "batch", "operation", "total", "per_call"),
                       map(int, m))) for m in re.findall(batch_re, raw, re.M)]
    expected = {(d, b, op) for d in (512, 1024)
                for b in range(nbatch) for op in range(3)}
    observed = [(s["degree"], s["batch"], s["operation"]) for s in samples]
    errors = []
    if set(observed) != expected or len(observed) != len(expected):
        errors.append("missing/duplicate/unexpected BATCH coordinates")
    if any(s["total"] <= 0 or s["per_call"] != s["total"] // niter for s in samples):
        errors.append("invalid cycle total or per_call division")
    summary_lines = re.findall(r"^SUMMARY (.+)$", raw, re.M)
    seen = set()
    for line in summary_lines:
        fields = dict(re.findall(r"(\w+)=(\d+)", line))
        if "degree" not in fields or "op" not in fields:
            errors.append("malformed SUMMARY")
            continue
        d, op = int(fields["degree"]), int(fields["op"])
        key = (d, op)
        if key in seen:
            errors.append("duplicate SUMMARY")
        seen.add(key)
        totals = sorted(s["total"] for s in samples
                        if s["degree"] == d and s["operation"] == op)
        if len(totals) != nbatch:
            errors.append("SUMMARY sample count mismatch")
            continue
        calculated = {"degree": d, "op": op, "upper_median": totals[nbatch >> 1] // niter}
        calculated.update({f"p{p}": totals[nbatch * p // 100] // niter
                           for p in (1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 99)})
        if {k: int(v) for k, v in fields.items()} != calculated:
            errors.append("SUMMARY differs from raw BATCH statistics")
    if seen != {(d, op) for d in (512, 1024) for op in range(3)}:
        errors.append("missing/unexpected SUMMARY coordinates")
    begin = (f"FNDSA_BEGIN mode={'pilot' if pilot else 'full'} batches={nbatch} "
             f"warmups={niter} iterations={niter}")
    if raw.splitlines().count(begin) != 1:
        errors.append("missing/incorrect benchmark mode or counts")
    return samples, errors


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mode", choices=("pilot", "full"))
    ap.add_argument("--loader", choices=("upstream", "cpu-copy"), default="upstream",
                    help="cpu-copy is diagnostic only and can never validate")
    args = ap.parse_args()
    if args.loader == 'cpu-copy':
        raise RuntimeError('Historical CPU-copy diagnostic only supports the archived '
                           'contiguous build/ ELF, not the new sparse build-dtcm/ ELF')
    if args.mode == 'full' and args.loader != 'upstream':
        raise RuntimeError('Experimental loaders are not accepted for full measurement')
    upstream = Path(os.environ["MLKEM_NATIVE_PINNED_ROOT"])
    compiler = Path(os.environ["GNUARMEMB_TOOLCHAIN_PATH"]) / "bin"
    elf = ROOT / "build-dtcm/zephyr/zephyr.elf"
    elf_sha = sha(elf)
    loader_adapter_sha = sha(ROOT / 'exec_with_tcm_init.py')
    audit = json.loads((ROOT / "audit-dtcm/build_manifest.json").read_text())
    if audit["elf_sha256"] != elf_sha:
        raise RuntimeError("Run audit_build.py for the exact ELF first")
    for name, value in audit["sources"].items():
        if sha(ROOT.parent / "ref" / name) != value["m55_sha256"]:
            raise RuntimeError(f"Source changed since build audit: {name}")
    if args.mode == "full":
        approved = json.loads((ROOT / "pilot_validated.json").read_text())
        if (approved["elf_sha256"] != elf_sha or not approved["valid"] or
                approved.get('loader_mode') != args.loader or
                approved.get('loader_adapter_sha256') != loader_adapter_sha):
            raise RuntimeError("The exact ELF and loader must pass the pilot before the full run")
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    run_dir = ROOT / "runs" / f"{args.mode}-{stamp}"
    run_dir.mkdir(parents=True, exist_ok=False)
    env = os.environ.copy()
    env.update({
        "FNDSA_LOADER_MODE": args.loader,
        "OPENOCD": str(ROOT / "env/openocd-4e9b167/bin/openocd"),
        "OPENOCD_SERIAL": "003C00223335510735383531",
        "OPENOCD_SPEED": "8000", "OPENOCD_TRANSPORT": "swd",
        "OPENOCD_SCRIPTS": str(ROOT / "env/openocd-4e9b167/share/openocd/scripts"),
        "OPENOCD_INTERFACE": env.get("OPENOCD_INTERFACE", "interface/stlink.cfg"),
        "OPENOCD_TARGET": env.get("OPENOCD_TARGET", "target/stm32n6x.cfg"),
        "GDB_PORT": "3349", "GDB_RUN_TIMEOUT": "1800",
        "SWO_TRACECLK": "100000000", "SWO_PIN_FREQ": "1000000",
        "SWO_FORMATTER": "0", "GDB": str(compiler / "arm-none-eabi-gdb"),
        "NM": str(compiler / "arm-none-eabi-nm"),
        "READELF": str(compiler / "arm-none-eabi-readelf"),
    })
    cmd = [sys.executable, str(ROOT / "exec_with_tcm_init.py"),
           "--verbose", str(elf)]
    if args.mode == "pilot":
        cmd.append("--pilot")
    meta = {"started_utc": now(), "mode": args.mode,
            "elf_sha256": elf_sha, "command": cmd,
            "loader_mode": args.loader,
            "loader_helper_sha256": sha(ROOT / "loader/loader_tcm_init.bin"),
            "loader_adapter_sha256": loader_adapter_sha,
            "probe": env["OPENOCD_SERIAL"],
            "environment": {k: env[k] for k in (
                "GDB_PORT", "OPENOCD", "OPENOCD_SPEED", "SWO_TRACECLK",
                "SWO_PIN_FREQ", "GDB", "NM", "READELF", "OPENOCD_SCRIPTS",
                "OPENOCD_TARGET", "OPENOCD_INTERFACE")},
            "source_manifest_sha256": sha(ROOT / "audit-dtcm/build_manifest.json"),
            "host_expected_log_sha256": sha(ROOT / "host" / f"{args.mode}.log")}
    (run_dir / "run.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(f"RUN_DIR={run_dir}", flush=True)
    with (run_dir / "raw.log").open("w") as log:
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, text=True, env=env)
        for line in proc.stdout:
            log.write(line)
            log.flush()
            print(line, end="", flush=True)
        rc = proc.wait()
    raw = (run_dir / "raw.log").read_text()
    host = (ROOT / "host" / f"{args.mode}.log").read_text()
    pat = r"^(?:DIGEST|AUDIT) degree=.+$"
    expected = re.findall(pat, host, re.M)
    observed = re.findall(pat, raw, re.M)
    total_batches = 2 if args.mode == "pilot" else 20
    samples, validation_errors = validate_measurements(raw, args.mode == "pilot")
    mscr = re.findall(r'^TCM_MSCR_(START|END)=(0x[0-9a-f]+)$', raw, re.M)
    if ([k for k, _ in mscr] != ['START', 'END'] or
            any(int(v, 16) & 0x12 != 0x2 for _, v in mscr)):
        validation_errors.append('missing or disabled TCM ECC enable/check state')
    for reg in ('CFSR', 'HFSR', 'AFSR'):
        values = re.findall(rf'^{reg}=(0x[0-9a-f]+)$', raw, re.M)
        if values != ['0x0']:
            validation_errors.append(f'{reg} missing or nonzero at completion')
    valid = (args.loader == 'upstream' and rc == 0 and observed == expected
             and len(expected) == total_batches + 2
             and not validation_errors
             and "FNDSA_DONE correctness=PASS tamper_rejection=PASS" in raw
             and "FNDSA_FAILURE" not in raw)
    meta.update({"ended_utc": now(), "returncode": rc, "valid": valid,
                 "host_digests_match": observed == expected,
                 "measurement_validation_errors": validation_errors,
                 "samples": samples, "raw_log_sha256": sha(run_dir / "raw.log")})
    (run_dir / "run.json").write_text(json.dumps(meta, indent=2) + "\n")
    if valid:
        (ROOT / f"{args.mode}_validated.json").write_text(
            json.dumps({"valid": True, "elf_sha256": elf_sha,
                        "loader_mode": args.loader,
                        "loader_adapter_sha256": loader_adapter_sha,
                        "run_directory": str(run_dir), "ended_utc": meta["ended_utc"]},
                       indent=2) + "\n")
    print(f"VALIDATED={valid} RUN_DIR={run_dir}", flush=True)
    return 0 if valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
