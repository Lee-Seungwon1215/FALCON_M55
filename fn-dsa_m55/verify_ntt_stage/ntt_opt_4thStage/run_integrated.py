#!/usr/bin/env python3
"""Measure the promoted ntt_opt source, keeping all earlier results intact."""
import importlib.util
from pathlib import Path
import sys

STAGE4 = Path(__file__).resolve().parent
ROOT = STAGE4 / "integration"
SOURCE = STAGE4.parent / "ntt_opt"
BUILD = STAGE4.parent / "measurement_mlkem_native/build-ntt-opt-stage4"
spec = importlib.util.spec_from_file_location(
    "stage4_integrated_runner", STAGE4.parent / "ntt_opt_3rdStage/run_stage3.py")
if spec is None or spec.loader is None:
    raise RuntimeError("cannot load validation runner")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {"integrated": (SOURCE, BUILD)}

if __name__ == "__main__":
    sys.argv.insert(1, "integrated")
    raise SystemExit(runner.main())
