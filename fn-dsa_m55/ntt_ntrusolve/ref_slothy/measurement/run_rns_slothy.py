#!/usr/bin/env python3
"""Measure this ref_slothy source tree with the matched RNS harness."""
from pathlib import Path
import subprocess
import sys
tool=Path(__file__).resolve().parents[2]/"5th_slothy/measurement/run.py"
raise SystemExit(subprocess.call([sys.executable,str(tool),"ref_slothy",*sys.argv[1:]]))
