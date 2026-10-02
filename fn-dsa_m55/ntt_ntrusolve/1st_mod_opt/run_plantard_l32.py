#!/usr/bin/env python3
"""Run the independent original-Plantard l=32 candidates on NUCLEO-N657X0-Q."""

import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[1]
MEAS = WORK / "measurement_mlkem_native"
COMMON = WORK / "ntt_opt_3rdStage/run_stage3.py"

spec = importlib.util.spec_from_file_location("plantard_l32_runner", COMMON)
if spec is None or spec.loader is None:
    raise RuntimeError("cannot load the common NUCLEO validation runner")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {
    "p1_l32_scalar_audit": (
        ROOT / "P1_original_l32_scalar",
        MEAS / "build-ntru-p1-l32-audit"),
    "p1_l32_scalar": (
        ROOT / "P1_original_l32_scalar",
        MEAS / "build-ntru-p1-l32"),
    "p2_l32_full_audit": (
        ROOT / "P2_l32_fullMVE",
        MEAS / "build-ntru-p2-l32-full-audit"),
    "p2_l32_full": (
        ROOT / "P2_l32_fullMVE",
        MEAS / "build-ntru-p2-l32-full"),
    "p2_l32_hybrid_audit": (
        ROOT / "P2_l32_hybridMVE",
        MEAS / "build-ntru-p2-l32-hybrid-audit"),
    "p2_l32_hybrid": (
        ROOT / "P2_l32_hybridMVE",
        MEAS / "build-ntru-p2-l32-hybrid"),
}


if __name__ == "__main__":
    raise SystemExit(runner.main())
