#!/usr/bin/env python3
"""Reproducible structural checks, NOT a formal constant-time proof."""
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parent
MEAS = ROOT.parents[1] / "measurement_mlkem_native"
BIN = Path(os.environ["GNUARMEMB_TOOLCHAIN_PATH"]) / "bin"
M0 = ROOT / "M0_general_montgomery"
M1 = ROOT / "M1_rounding_montgomery"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tool(name, *args):
    return subprocess.check_output([str(BIN / ("arm-none-eabi-" + name)),
                                    *map(str, args)], text=True)


def instructions(elf, symbol):
    text = tool("objdump", "-d", "--disassemble=" + symbol, elf)
    return re.findall(r"^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+"
                      r"([a-z][a-z0-9.]*)\s*([^\n]*)", text, re.M)


def main():
    files = sorted(p.name for p in M0.iterdir() if p.suffix in (".c", ".h", ".s"))
    changed = [name for name in files if sha(M0 / name) != sha(M1 / name)]
    assert changed == ["kgen_mp31_cm55.s"], changed
    elf0 = MEAS / "build-ntru-m0/zephyr/zephyr.elf"
    elf1 = MEAS / "build-ntru-m1/zephyr/zephyr.elf"
    audit = MEAS / "build-ntru-m1-audit/zephyr/zephyr.elf"
    assert "fndsa_mp31_monty4_probe" not in tool("nm", elf1)
    assert "fndsa_mp31_monty4_probe" in tool("nm", audit)
    result = dict(changed_crypto_sources=changed, file_count=len(files),
                  m0_elf_sha256=sha(elf0), m1_elf_sha256=sha(elf1),
                  m1_audit_elf_sha256=sha(audit),
                  assembly_sha256=sha(M1 / "kgen_mp31_cm55.s"),
                  benchmark_source_sha256=sha(MEAS / "app/benchmark.c"),
                  test_probe_removed_from_performance_elf=True, functions={})
    for symbol in ("fndsa_mp_NTT", "fndsa_mp_iNTT"):
        old, new = instructions(elf0, symbol), instructions(elf1, symbol)
        counts = Counter(op for op, _ in new)
        assert counts["vqrdmulh.s32"] == 18 and counts["vhadd.s32"] == 9
        assert not any(op.startswith(("vqrdml", "vmulh", "bl"))
                       for op, _ in new)
        # Scalar branch opcode sequence is unchanged; review its public loop
        # bounds in the .s file. This is not an information-flow analyzer.
        branches = lambda ins: [op for op, _ in ins if op.startswith("b")]
        assert branches(old) == branches(new)
        # Addresses are still computed by the same scalar/gather instructions.
        # Ignore disassembler PC-relative annotations, whose addresses moved.
        memory = lambda ins: [(op, operand.split("@")[0].strip())
                              for op, operand in ins
                              if op.startswith(("ldr", "str", "vldr", "vstr",
                                                "vld4", "vst4"))]
        assert memory(old) == memory(new)
        result["functions"][symbol] = dict(
            mve_body_instruction_count=sum(n for op, n in counts.items()
                if op.startswith("v") and op not in ("vpush", "vpop")),
            rounding_high=counts["vqrdmulh.s32"], halving_add=counts["vhadd.s32"],
            predicated_normalizations=counts["vpt.s32"],
            scalar_branch_opcodes=branches(new), memory_operands_unchanged=True)
    result["formal_constant_time_proof"] = False
    result["dynamic_timing_leakage_test"] = False
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
