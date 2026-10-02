#!/usr/bin/env python3
"""Prove source-body equality after stripping only measurement hooks."""
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = ROOT / "tw32_mve/fft_tw32_mve.c"
PROFILE = ROOT / "tests/ds32_layer_profile.c"
BASELINE = ROOT / "tests/stage9_snapshot/fft_tw32_mve.c"


def body(text, name):
    match = re.search(r"\b" + re.escape(name) + r"\([^;]*?\)\s*\{", text)
    assert match, name
    start = text.index("{", match.start())
    depth = 0
    for end in range(start, len(text)):
        if text[end] == "{":
            depth += 1
        elif text[end] == "}":
            depth -= 1
            if depth == 0:
                return text[start:end+1]
    raise AssertionError("Unclosed function " + name)


def audit():
    original, profile = ORIGINAL.read_text(), PROFILE.read_text()
    baseline = BASELINE.read_text()
    checked = []
    for name in ("q32_tw", "ds_splat4", "ds_load_tail", "ds_store_tail", "ds_final_scale"):
        assert body(original, name) == body(profile, name), name
        checked.append(name)
    assert body(original, "tw32_init_twiddles") == body(profile, "ds32_layer_init")
    for direction in ("fft", "ifft"):
        name = "ds32_" + direction + "_mve"
        assert body(baseline, name) == body(profile, "ds32_layer_control_" + direction)
        instrumented = body(profile, "ds32_layer_profile_" + direction)
        normalized = "\n".join(line for line in instrumented.split("\n")
                               if "/* PROFILE_" not in line)
        assert body(original, name) == normalized, name
        checked.append(name)
    return {
        "status": "PASS",
        "method": "Exact function-body comparison; remove only PROFILE_ timestamp lines",
        "checked_functions": checked + ["tw32_init_twiddles"],
        "sha256": {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                   for p in (ORIGINAL, PROFILE, BASELINE, ROOT / "tw32_mve/tw32_primitives_cm55.s")},
        "scope": "Control equals frozen stage9, profile equals current stage10 after hook removal; no timing equivalence claim"
    }


if __name__ == "__main__":
    print(json.dumps(audit(), indent=2))
