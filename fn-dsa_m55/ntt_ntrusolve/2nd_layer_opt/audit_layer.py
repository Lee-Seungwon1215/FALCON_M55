#!/usr/bin/env python3
"""Reproducible structural checks; not a formal constant-time proof."""
import hashlib
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parent
MEAS = ROOT.parents[1] / "measurement_mlkem_native"
BIN = MEAS / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin"

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def tool(name, *args):
    return subprocess.check_output([str(BIN / ("arm-none-eabi-" + name)),
                                   *map(str, args)], text=True)

def main():
    before = ROOT / "L2_two_layer"
    after = ROOT / "L3_three_layer"
    stage1 = ROOT.parent / "1st_mod_opt/M1_improve"
    names = sorted(p.name for p in before.iterdir() if p.suffix in (".c", ".h", ".s"))
    assert names == sorted(p.name for p in after.iterdir() if p.suffix in (".c", ".h", ".s"))
    assert all(sha(before / n) == sha(stage1 / n) for n in names)
    changed = [n for n in names if sha(before / n) != sha(after / n)]
    assert changed == ["kgen_mp31_cm55.s"], changed
    out = ROOT / "results/static_audit"
    out.mkdir(parents=True, exist_ok=True)
    result = {"changed_crypto_sources": changed,
              "l2_equals_m1_improve": True,
              "l3_assembly_sha256": sha(after / changed[0]),
              "formal_constant_time_proof": False,
              "dynamic_timing_leakage_test": False,
              "binaries": {}}
    for candidate in ("l2", "l3"):
        build = MEAS / ("build-ntru-stage2-" + candidate)
        elf = build / "zephyr/zephyr.elf"
        nm = tool("nm", "-S", elf)
        assert "fndsa_mp31_monty4_probe" not in nm
        record = {"elf_sha256": sha(elf), "symbols": {}}
        for symbol in ("fndsa_mp_NTT", "fndsa_mp_iNTT"):
            dis = tool("objdump", "-d", "--disassemble=" + symbol, elf)
            (out / (candidate + "_" + symbol + ".txt")).write_text(dis)
            instructions = re.findall(r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+)+([a-z][a-z0-9.]*)\s*([^\n]*)", dis, re.M)
            assert instructions
            prohibited = [(pc, op) for pc, op, _ in instructions
                          if op in ("bl", "blx", "udiv", "sdiv")
                          or op.startswith(("vdiv", "vcvt"))]
            assert not prohibited, prohibited
            assert (symbol + "_c>") in dis, "missing small-logn C fallback"
            branches = [(pc, op, args.strip()) for pc, op, args in instructions
                        if re.fullmatch(r"b(?:eq|ne|lo|cc|hs|cs|hi|ls|ge|gt|le|lt)?(?:\.w|\.n)?", op)]
            core_flags = [(pc, op, args.strip()) for pc, op, args in instructions
                          if op in ("cmp", "cmp.w", "subs", "subs.w", "adds", "adds.w")]
            vec_stack = [(pc, op, args) for pc, op, args in instructions
                         if op.startswith(("vstr", "vldr")) and "[sp" in args]
            assert not vec_stack, "unexpected vector coefficient stack spills"
            addr, size = re.search(rf"^([0-9a-f]+) ([0-9a-f]+) [Tt] {symbol}$", nm, re.M).groups()
            record["symbols"][symbol] = {
                "address": "0x" + addr, "bytes": int(size, 16),
                "scalar_branches_for_manual_review": branches,
                "core_flag_writers_for_manual_review": core_flags,
                "vector_stack_spills_beyond_abi_save": len(vec_stack),
                "instruction_count_static": len(instructions),
            }
        sections = tool("size", "-A", elf)
        (out / (candidate + "_sections.txt")).write_text(sections)
        itcm = dtcm = 0
        for size, address in re.findall(r"^\S+\s+(\d+)\s+(\d+)$", sections, re.M):
            size, address = int(size), int(address)
            if 0x10000000 <= address < 0x10040000:
                itcm = max(itcm, address + size - 0x10000000)
            if 0x30000000 <= address < 0x30040000:
                dtcm = max(dtcm, address + size - 0x30000000)
        record.update(itcm_bytes=itcm, dtcm_bytes=dtcm,
                      itcm_remaining=262144-itcm, dtcm_remaining=262144-dtcm,
                      linker_text_limit=131072,
                      text_remaining_to_linker_limit=131072-itcm)
        assert 0 < itcm <= 131072 and 0 < dtcm <= 262144
        result["binaries"][candidate] = record
    configs = [(MEAS / ("build-ntru-stage2-"+c) / "zephyr/.config").read_bytes()
               for c in ("l2", "l3")]
    assert configs[0] == configs[1], "production board config differs"
    result["production_kconfig_byte_identical"] = True
    (out / "audit.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({k: v for k, v in result.items() if k != "binaries"}, indent=2))
    for candidate, r in result["binaries"].items():
        print(candidate, "ITCM", r["itcm_bytes"], "DTCM", r["dtcm_bytes"])

if __name__ == "__main__":
    main()
