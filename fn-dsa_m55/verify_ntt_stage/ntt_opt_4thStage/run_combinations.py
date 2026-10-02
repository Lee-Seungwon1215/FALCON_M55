#!/usr/bin/env python3
"""Validate complete, directly written combination sources on the M55 board.

This selects an already linked firmware, never composes assembly fragments.
"""
import run_stage4

runner = run_stage4.runner
ROOT = run_stage4.ROOT
MEAS = ROOT.parent / "measurement_mlkem_native"
runner.ROOT = ROOT / "combinations"
runner.CANDIDATES = {
    "baseline": run_stage4.STAGE3_BASELINE,
}
for s1 in "AB":
    for s2 in "AB":
        for s3 in "ABC":
            name = f"S1{s1}_S2{s2}_S3{s3}"
            runner.CANDIDATES[name] = (
                ROOT / "combinations" / name,
                MEAS / ("build-combo-" + name.lower().replace("_", "-")),
            )
for name in ("S1B_S2B_S3B", "S1B_S2B_S3C"):
    before = ROOT / "combinations" / "revision_before" / name
    runner.CANDIDATES["before_" + name] = (before / "source", before / "build")

if __name__ == "__main__":
    raise SystemExit(runner.main())
