#!/usr/bin/env python3
"""Sequential board access for matched candidate runs; stop on any failure."""
import argparse
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
p = argparse.ArgumentParser()
p.add_argument("--label", required=True)
p.add_argument("--reverse", action="store_true")
p.add_argument("--audit-only", action="store_true")
a = p.parse_args()
order = ["baseline", "slothyA", "slothyB"]
if a.reverse: order.reverse()
for variant in order:
    actions = [("audit", "pilot")] if a.audit_only else [("perf", "pilot"), ("perf", "full")]
    for kind, mode in actions:
        print("START", variant, kind, mode, a.label, flush=True)
        path = ROOT / "results" / (variant+"-"+kind+"-"+a.label+"-"+mode+".console.log")
        path.parent.mkdir(exist_ok=True)
        with path.open("x") as f:
            rc = subprocess.call([sys.executable, str(ROOT/"run.py"), variant, kind, mode, "--label",a.label],stdout=f,stderr=subprocess.STDOUT)
        print("END",variant,kind,mode,"returncode",rc,"log",path,flush=True)
        if rc: raise SystemExit(rc)
