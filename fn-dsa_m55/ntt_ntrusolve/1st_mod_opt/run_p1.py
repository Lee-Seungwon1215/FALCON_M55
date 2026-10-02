#!/usr/bin/env python3
"""Validate and benchmark the correctness-first l=64 Plantard candidate."""

import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[1]
MEAS = WORK / "measurement_mlkem_native"
RUNNER_PATH = WORK / "ntt_opt_3rdStage/run_stage3.py"

spec = importlib.util.spec_from_file_location("p1_common_runner", RUNNER_PATH)
if spec is None or spec.loader is None:
    raise RuntimeError("cannot load the common NUCLEO validation runner")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {
    "p1": (ROOT / "P1_improved_l64_scalar",
           MEAS / "build-ntru-p1-plantard64"),
    "p1_audit": (ROOT / "P1_improved_l64_scalar",
                 MEAS / "build-ntru-p1-plantard64-audit"),
}

if __name__ == "__main__":
    raise SystemExit(runner.main())
