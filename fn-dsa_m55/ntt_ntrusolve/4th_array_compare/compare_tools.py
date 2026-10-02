#!/usr/bin/env python3
"""Provenance and board runner for the complete, padded D0 control tree."""
import argparse
import importlib.util
from pathlib import Path
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("command", choices=("prepare", "record", "check", "run"))
    p.add_argument("kind", choices=("perf", "audit"))
    p.add_argument("mode", nargs="?", choices=("pilot", "full"))
    p.add_argument("--label")
    args = p.parse_args()
    spec = importlib.util.spec_from_file_location("d1_measurement", ROOT / "D1_vld4_last/profiling/m55.py")
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    m.SOURCE = ROOT / "experiments/d0_layout/source"
    m.PROFILE = ROOT / "experiments/d0_layout/profiling"
    m.CANDIDATE_PREFIX = "d0_layout"
    if args.command == "run":
        if not args.mode or not args.label:
            p.error("run requires mode and --label")
        return m.run(args.kind, args.mode, args.label)
    {"prepare": m.prepare, "record": m.record, "check": m.check_built}[args.command](args.kind)
    print("d0_layout", args.command, args.kind, "PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
