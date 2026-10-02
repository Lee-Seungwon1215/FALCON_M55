#!/usr/bin/env python3
"""Check forward-only changes and address-controlled comparison binaries."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess

ROOT = Path(__file__).resolve().parent
MEAS = ROOT.parents[1] / "measurement_mlkem_native"
BIN = MEAS / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin"

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def sections(p):
    b = p.read_bytes()
    assert b[:6] == b"\x7fELF\x01\x01", "expected little-endian ELF32"
    off = struct.unpack_from("<I", b, 32)[0]
    size, num, index = struct.unpack_from("<HHH", b, 46)
    headers = [struct.unpack_from("<10I", b, off + i*size) for i in range(num)]
    h = headers[index]
    names = b[h[4]:h[4]+h[5]]
    return {names[h[0]:].split(b"\0", 1)[0].decode():
            (h[3], h[5], b"" if h[1] == 8 else b[h[4]:h[4]+h[5]])
            for h in headers if h[2] & 2}

def main():
    p = argparse.ArgumentParser()
    p.add_argument("label")
    p.add_argument("--production", action="store_true")
    args = p.parse_args()
    assert re.fullmatch("[a-z0-9_-]+", args.label)
    candidate = "l3" if args.production else "l3_audit"
    if args.production:
        record = ROOT / "results/l3/full_validated.json"
    else:
        record = ROOT / "experiments/ntt_before/results/l3_audit/pilot_validated.json"
    previous = Path(json.loads(record.read_text())["run_directory"])
    old = previous / "zephyr.elf"
    new = MEAS / ("build-ntru-stage2-"+candidate) / "zephyr/zephyr.elf"
    a, b = sections(old), sections(new)
    assert a.keys() == b.keys()
    for name in a:
        assert a[name][:2] == b[name][:2], (name, "address/size changed")
        if name == "text":
            assert a[name][0] == 0x10000330
            assert a[name][2][0x5da:] == b[name][2][0x5da:], "final CT2 or later text changed"
        else:
            assert a[name][2] == b[name][2], (name, "contents changed")
    current = ROOT / "L3_three_layer/kgen_mp31_cm55.s"
    source = current.read_text()
    old_source = (previous / current.name).read_text()
    dispatch_checked = False
    if ".Lntt_l3_start_masks:" in source:
        values = re.search(r"\.Lntt_l3_start_masks:\s*\.hword\s+([^\n]+)", source)[1]
        masks = [int(x.strip(), 0) for x in values.split(",")]
        expected = {4:[2,2], 5:[3,2], 6:[2,2,2], 7:[2,3,2],
                    8:[3,3,2], 9:[2,2,3,2], 10:[2,3,3,2]}
        for logn, plan in expected.items():
            lm = 0
            actual = []
            while lm+3 < logn:
                width = 3 if (masks[logn] >> lm) & 1 else 2
                actual.append(width)
                lm += width
            actual.append(2)
            assert actual == plan and sum(actual) == logn
        dispatch_checked = True
    assert source.split("fndsa_mp_iNTT:\n", 1)[1] == old_source.split("fndsa_mp_iNTT:\n", 1)[1]
    for macro in ("MP31_ROOT", "MP31_MONT", "MP31_ADD", "MP31_SUB", "MP31_HALF", "MP31_CT", "MP31_GS", "MP31_SMONT", "MP31_SGS", "MP31_PLAN_I", "MP31_AT"):
        pattern = rf"^\s*\.macro {macro}\b.*?^\s*\.endm"
        assert re.search(pattern, source, re.M|re.S)[0] == re.search(pattern, old_source, re.M|re.S)[0], macro
    baseline = ROOT / "L2_two_layer"
    changed = [q.name for q in baseline.iterdir() if q.suffix in (".c", ".h", ".s")
               and q.read_bytes() != (current.parent / q.name).read_bytes()]
    assert changed == ["kgen_mp31_cm55.s"], changed
    dis = subprocess.check_output([str(BIN / "arm-none-eabi-objdump"), "-d",
                                   "--disassemble=fndsa_mp_NTT", str(new)], text=True)
    assert not re.search(r"\s(?:bl|blx|sdiv|udiv|vdiv\.[a-z0-9]+|vcvt\.[a-z0-9.]+)\s", dis)
    assert not re.search(r"\sv(?:ldr|str)\S*\s+[^\n]*\[sp", dis)
    out = ROOT / "experiments" / args.label
    out.mkdir(parents=True, exist_ok=True)
    mode = "production" if args.production else "audit"
    (out / (mode + "_ntt_disassembly.txt")).write_text(dis)
    result = {
        "old_elf": str(old), "old_elf_sha256": sha(old), "new_elf_sha256": sha(new),
        "source_sha256": sha(current), "changed_crypto_sources": changed,
        "final_ct2_address": "0x1000090a", "intt_address": "0x10000a64",
        "all_allocated_section_addresses_sizes_preserved": True,
        "final_ct2_and_all_later_text_byte_identical": True,
        "other_loaded_sections_byte_identical": True,
        "intt_source_and_arithmetic_macros_unchanged": True,
        "public_mask_plans_checked": dispatch_checked,
        "new_calls_divisions_fp_conversions_or_vector_stack_spills": False,
        "formal_constant_time_proof": False, "dynamic_leakage_test": False,
    }
    (out / (mode+"_layout_audit.json")).write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps(result, indent=2))

if __name__ == "__main__":
    main()
