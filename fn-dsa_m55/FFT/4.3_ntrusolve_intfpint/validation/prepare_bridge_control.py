#!/usr/bin/env python3
"""Freeze TW stage-11 controls for a measurement-only, same-ELF comparison.

Namespacing and measurement-only workspace placement change. No arithmetic or
code-generation selector is introduced into either production candidate.
--check verifies that both transformations reverse to the original source.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
M55 = ROOT.parents[2]
SOURCE = M55 / "function_compare/twfalcon/integration_candidate"
DEST = ROOT / "bridge_control"
NAMES = ("tw32_api.h", "triple_float.h", "tw32_gm_ds32.h",
         "tw32_gm_ds32.c", "tw32_fft_mve.c", "tw32_bridge.c",
         "tw32_primitives_cm55.s")
TOKEN = re.compile(r"\b(?:tw32\w*|ds32\w*|tw_gm\w*)\b")
PRIVATE_WORKSPACE = "static control_tw32_fft workspace;"
SHARED_WORKSPACE = ('#include "../bridge_workspace.h"\n'
                    '#define workspace bridge_shared_workspace.poly.tw')


def renamed(text):
    return TOKEN.sub(lambda m: "control_" + m[0], text)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if not args.check:
        DEST.mkdir(exist_ok=True)
    records = {}
    for name in NAMES:
        source = SOURCE / name
        target = DEST / renamed(name)
        raw = source.read_bytes()
        transformed = renamed(raw.decode())
        if name == "tw32_bridge.c":
            assert transformed.count(PRIVATE_WORKSPACE) == 1
            transformed = transformed.replace(PRIVATE_WORKSPACE, SHARED_WORKSPACE)
        transformed = transformed.encode()
        if args.check:
            assert target.read_bytes() == transformed, target
        else:
            target.write_bytes(transformed)
        # Prefix reversal cannot alter the numerical program.
        restored = transformed.decode().replace(SHARED_WORKSPACE, PRIVATE_WORKSPACE)
        assert restored.replace("control_", "") == raw.decode()
        records[name] = dict(source=str(source), source_sha256=sha(raw),
                             target=target.name, target_sha256=sha(transformed))
    # Exact fixed FFT bodies and the original Q32 constants are used locally.
    original = M55 / "M55_ref/kgen_fxp.c"
    candidate = ROOT.parent / "kgen_fxp.c"
    reftext, curtext = original.read_text(), candidate.read_text()
    for name in ("vect_FFT", "vect_iFFT"):
        pattern = re.compile(r"^" + name + r"\(.*?^\}", re.M | re.S)
        assert pattern.search(reftext)[0] == pattern.search(curtext)[0], name
    assert reftext[:reftext.index("/* see kgen_inner.h */\nvoid\nvect_FFT(")] == curtext[:curtext.index("/* see kgen_inner.h */\nvoid\nvect_FFT(")]
    report = dict(purpose="measurement-only TW control, namespacing and shared DTCM workspace only",
                  records=records, fixed_fft_bodies_and_roots_identical=True,
                  m55_ref_fxp_sha256=sha(original.read_bytes()))
    manifest = DEST / "origin.json"
    if args.check:
        assert json.loads(manifest.read_text()) == report
    else:
        manifest.write_text(json.dumps(report, indent=2) + "\n")
    print("BRIDGE_CONTROL_AUDIT PASS files=7 fixed_fft_bodies=2")


if __name__ == "__main__":
    main()
