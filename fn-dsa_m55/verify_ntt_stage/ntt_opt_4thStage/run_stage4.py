#!/usr/bin/env python3
"""Run the stage-4 NUCLEO-N657X0-Q scheduling candidates."""

import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parent
BASE_RUNNER = ROOT.parent / "ntt_opt_3rdStage" / "run_stage3.py"

spec = importlib.util.spec_from_file_location("fndsa_stage3_runner", BASE_RUNNER)
if spec is None or spec.loader is None:
    raise RuntimeError(f"cannot load validation runner: {BASE_RUNNER}")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)

measurement = ROOT.parent / "measurement_mlkem_native"
STAGE3_BASELINE = runner.CANDIDATES["ntt_opt"]
runner.ROOT = ROOT
runner.CANDIDATES = {
    "baseline": STAGE3_BASELINE,
    "s1a": (ROOT / "S1-A_staggered", measurement / "build-stage4-s1a"),
    "s1b": (ROOT / "S1-B_phase-grouped", measurement / "build-stage4-s1b"),
    "s2a": (ROOT / "S2-A_same-layer", measurement / "build-stage4-s2a"),
    "s2b": (ROOT / "S2-B_cross_layer", measurement / "build-stage4-s2b"),
    "s3a": (ROOT / "S3-A_twiddle-preload", measurement / "build-stage4-s3a"),
    "s3b": (ROOT / "S3-B_early-load-late-store", measurement / "build-stage4-s3b"),
    "s3c": (ROOT / "S3-C_cross-iteration", measurement / "build-stage4-s3c"),
}


if __name__ == "__main__":
    raise SystemExit(runner.main())
