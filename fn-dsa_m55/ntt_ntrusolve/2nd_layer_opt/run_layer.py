#!/usr/bin/env python3
"""Board runner with archived actual assembly and strict RNS audit checks."""
import argparse
import importlib.util
import json
from pathlib import Path
import re
import shutil
import sys

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[1]
MEAS = WORK / "measurement_mlkem_native"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("candidate", choices=("l2", "l2_audit", "l3", "l3_audit"))
    parser.add_argument("mode", choices=("pilot", "full"))
    parser.add_argument("--label", default="final")
    args = parser.parse_args()
    if not re.fullmatch(r"[a-z0-9_-]+", args.label):
        parser.error("label must contain only lowercase letters, digits, _ or -")
    out = ROOT if args.label == "final" else ROOT / "experiments" / args.label
    source = ROOT / ("L2_two_layer" if args.candidate.startswith("l2") else "L3_three_layer")
    spec = importlib.util.spec_from_file_location("stage2_common", WORK / "ntt_opt_3rdStage/run_stage3.py")
    runner = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    runner.ROOT = out
    runner.CANDIDATES = {args.candidate: (source, MEAS / ("build-ntru-stage2-" + args.candidate))}
    sys.argv = [sys.argv[0], args.candidate, args.mode]
    rc = runner.main()
    if rc:
        return rc
    record = json.loads((out / "results" / args.candidate / (args.mode + "_validated.json")).read_text())
    run = Path(record["run_directory"])
    (run / "kgen_mp31_cm55.s").write_bytes((source / "kgen_mp31_cm55.s").read_bytes())
    built = MEAS / ("build-ntru-stage2-" + args.candidate) / "zephyr"
    for name in ("zephyr.elf", "zephyr.map", ".config"):
        shutil.copy2(built / name, run / name)
    raw = (run / "raw.log").read_text()
    if args.candidate.endswith("_audit"):
        exact = re.search(r"^MP31_EXACT (.+)$", raw, re.M)
        rounding = re.search(r"^MP31_ROUNDING (.+)$", raw, re.M)
        assert exact and rounding, "missing arithmetic audit output"
        fields = dict(re.findall(r"(\w+)=(\d+)", exact[1]))
        assert fields["primes"] == "308", fields
        for key, value in fields.items():
            if "mismatch" in key or "error" in key:
                assert value == "0", fields
        assert "mismatches=0 range_errors=0" in rounding[1], rounding[1]
        cycles = re.findall(r"^MP31_CYCLES logn=(\d+) direction=(\w+) batch=(\d+) calls=(\d+) total=(\d+) per_call=(\d+) twiddle_prepare=included$", raw, re.M)
        assert len(cycles) == 140, ("cycle batch count", len(cycles))
        (run / "rns_audit.json").write_text(json.dumps({"exact": fields, "rounding": rounding[1], "cycle_batches": cycles}, indent=2) + "\n")
    print("STAGE2_ARCHIVE=" + str(run), flush=True)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
