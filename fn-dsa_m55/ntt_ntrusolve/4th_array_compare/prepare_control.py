#!/usr/bin/env python3
"""Reproduce a complete D0 tree with unreachable padding matching D1 v1.

This is a measurement control, NOT a cryptographic implementation selector.
The original D0 tree is read-only. Existing conflicting outputs are refused.
"""
import hashlib
import json
from pathlib import Path
import re
import shutil

ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "D0_vst4_previous"
DEST = ROOT / "experiments/d0_layout/source"
PADS = {"fndsa_mp_NTT": 0x490, "fndsa_mp_iNTT": 0x6EA,
        "fndsa_mp_NTT_small": 0x408}


def padded(text):
    assert text.count(".org fndsa_mp_NTT_small + 0x2d8, 0") == 1
    text = text.replace(".org fndsa_mp_NTT_small + 0x2d8, 0",
                        ".org fndsa_mp_NTT_small + 0x408, 0")
    for name in ("fndsa_mp_NTT", "fndsa_mp_iNTT"):
        needle = f"\t.size {name}, .-{name}\n"
        assert text.count(needle) == 1
        text = text.replace(needle, needle +
                            f"\t.org {name} + 0x{PADS[name]:x}, 0\n")
    return text


def main():
    DEST.mkdir(parents=True, exist_ok=True)
    hashes = {}
    for path in sorted(SOURCE.iterdir()):
        if path.suffix not in (".c", ".h", ".s"):
            continue
        assert path.is_file() and not path.is_symlink()
        raw = path.read_bytes()
        data = padded(raw.decode()).encode() if path.name == "kgen_mp31_cm55.s" else raw
        target = DEST / path.name
        if target.exists():
            assert target.read_bytes() == data, f"conflicting control: {target}"
        elif data == raw:
            shutil.copy2(path, target)
        else:
            target.write_bytes(data)
        hashes[path.name] = {"d0": hashlib.sha256(raw).hexdigest(),
                            "control": hashlib.sha256(data).hexdigest()}
    assert len(hashes) == 31
    report = {"padding": PADS, "source_hashes": hashes,
              "only_unreachable_padding_changed": True}
    (DEST.parent / "provenance.json").write_text(json.dumps(report, indent=2) + "\n")
    print("D0 layout control prepared:", DEST)


if __name__ == "__main__":
    main()
