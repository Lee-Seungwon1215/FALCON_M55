#!/usr/bin/env python3
"""Run the established, hash-checked M55 pilot/full benchmark for stage 5."""
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location(
    "stage5_board_runner", ROOT.parent / "ntt_opt_3rdStage/run_stage3.py")
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
runner.ROOT = ROOT
runner.CANDIDATES = {name: (ROOT / name, ROOT / "build" / name)
                     for name in ("ref", "slothyA", "slothyB")}

if __name__ == "__main__":
    raise SystemExit(runner.main())
