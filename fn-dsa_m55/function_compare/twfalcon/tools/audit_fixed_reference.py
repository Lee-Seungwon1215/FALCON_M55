#!/usr/bin/env python3
"""Verify the integrated benchmark's fixed baseline against M55_ref bodies."""
from pathlib import Path
import hashlib
import json
from audit_layers import body

ROOT = Path(__file__).resolve().parents[1]
REF = ROOT.parents[1] / "M55_ref"
LOCAL = ROOT / "integration_candidate"
checks = {}
for filename, names in (("kgen_fxp.c", ("vect_FFT", "vect_iFFT")),
                        ("kgen_inner.h", ("fxr_add", "fxr_sub", "fxr_mul", "fxr_div2e", "fxc_mul"))):
    a, b = (REF / filename).read_text(), (LOCAL / filename).read_text()
    for name in names:
        checks[name] = body(a, name) == body(b, name+"_fixed" if filename.endswith(".c") else name)
assert all(checks.values()), checks
print(json.dumps({"status": "PASS", "exact_function_body_matches": checks,
                  "sha256": {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
                             for root in (REF, LOCAL)
                             for p in (root/"kgen_fxp.c", root/"kgen_inner.h")},
                  "scope": "Bodies/helpers match M55_ref; benchmark compiles both paths in one image, not the historical whole firmware"}, indent=2))
