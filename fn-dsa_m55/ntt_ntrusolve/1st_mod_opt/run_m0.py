#!/usr/bin/env python3
"""Validate and benchmark the pre-Slothy NTRU-NTT baseline and M0."""

import importlib.util
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[1]
MEAS = WORK / "measurement_mlkem_native"
RUNNER_PATH = WORK / "ntt_opt_3rdStage/run_stage3.py"

spec = importlib.util.spec_from_file_location("m0_common_runner", RUNNER_PATH)
if spec is None or spec.loader is None:
    raise RuntimeError("cannot load the common NUCLEO validation runner")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {
    "ref": (ROOT.parent / "ref_preslothy", MEAS / "build-ntru-ref"),
    "m0": (ROOT / "M0_general_montgomery", MEAS / "build-ntru-m0"),
    "m0_audit": (ROOT / "M0_general_montgomery",
                 MEAS / "build-ntru-m0-audit"),
}

if __name__ == "__main__":
    raise SystemExit(runner.main())
