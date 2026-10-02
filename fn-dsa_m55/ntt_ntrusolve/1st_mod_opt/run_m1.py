#!/usr/bin/env python3
"""Use the existing pinned board runner; archive M1 separately from M0."""
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[1]
MEAS = WORK / "measurement_mlkem_native"
spec = importlib.util.spec_from_file_location(
    "m1_common_runner", WORK / "ntt_opt_3rdStage/run_stage3.py")
if spec is None or spec.loader is None:
    raise RuntimeError("cannot load the common NUCLEO validation runner")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {
    "m1": (ROOT / "M1_rounding_montgomery", MEAS / "build-ntru-m1"),
    "m1_audit": (ROOT / "M1_rounding_montgomery", MEAS / "build-ntru-m1-audit"),
}
if __name__ == "__main__":
    raise SystemExit(runner.main())
