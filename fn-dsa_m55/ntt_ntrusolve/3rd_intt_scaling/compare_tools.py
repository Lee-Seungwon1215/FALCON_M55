#!/usr/bin/env python3
"""Use the same measurement checks for complete H0 source trees.

This selects whole measurement subjects, never cryptographic fragments.
H1's implementation remains in H1_final_scaling/kgen_mp31_cm55.s.
"""
import argparse
import importlib.util
from pathlib import Path
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("candidate", choices=("h0", "h0_layout"))
    parser.add_argument("command", choices=("prepare", "record", "check", "run"))
    parser.add_argument("kind", choices=("perf", "audit"))
    parser.add_argument("mode", nargs="?", choices=("pilot", "full"))
    parser.add_argument("--label")
    args = parser.parse_args()
    spec = importlib.util.spec_from_file_location("scaling_common", ROOT / "H1_final_scaling/profiling/m55.py")
    tools = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tools)
    if args.candidate == "h0":
        tools.SOURCE = ROOT / "H0_stagewise_half"
        tools.PROFILE = tools.SOURCE / "profiling"
    else:
        tools.SOURCE = ROOT / "experiments/h0_layout/source"
        tools.PROFILE = ROOT / "experiments/h0_layout/profiling"
    tools.CANDIDATE_PREFIX = args.candidate
    if args.command == "run":
        if not args.mode or not args.label:
            parser.error("run requires mode and --label")
        return tools.run(args.kind, args.mode, args.label)
    if args.command == "prepare":
        tools.prepare(args.kind)
    elif args.command == "record":
        tools.record(args.kind)
    else:
        tools.check_built(args.kind)
    print(args.candidate, args.command, args.kind, "PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
