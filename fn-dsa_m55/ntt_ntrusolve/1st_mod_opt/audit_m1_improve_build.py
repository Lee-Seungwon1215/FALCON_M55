#!/usr/bin/env python3
"""Structural M1-to-M1-improve audit; not a formal CT proof."""

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
M1 = ROOT / "M1_rounding_montgomery"
IMPROVE = ROOT / "M1_improve"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tool(name, *args):
    return subprocess.check_output(
        [str(BIN / ("arm-none-eabi-" + name)), *map(str, args)], text=True)


def instructions(elf, symbol):
    output = tool("objdump", "-d", "--disassemble=" + symbol, elf)
    return re.findall(r"^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+"
                      r"([a-z][a-z0-9.]*)\s*([^\n]*)", output, re.M)


def stable_operands(items):
    normalized = []
    for op, operand in items:
        operand = operand.split("@")[0].strip()
        # Removing 80 bytes from iNTT moves the C fallback and the shared
        # stride literal.  Those PC-relative immediates therefore change even
        # though the forward instruction sequence and literal contents do not.
        if op.startswith("b"):
            operand = "<target>"
        elif op == "addw" and re.match(r"r0,\s*pc,", operand):
            operand = "r0, pc, <literal>"
        normalized.append((op, operand))
    return normalized


def main():
    files = sorted(p.name for p in M1.iterdir()
                   if p.suffix in (".c", ".h", ".s"))
    changed = [name for name in files if sha(M1 / name) != sha(IMPROVE / name)]
    assert changed == ["kgen_mp31_cm55.s"], changed

    elf1 = MEAS / "build-ntru-m1/zephyr/zephyr.elf"
    elfi = MEAS / "build-ntru-m1-improve/zephyr/zephyr.elf"
    audit = MEAS / "build-ntru-m1-improve-audit/zephyr/zephyr.elf"
    assert "fndsa_mp31_monty4_probe" not in tool("nm", elfi)
    assert "fndsa_mp31_monty4_probe" in tool("nm", audit)

    ntt1 = instructions(elf1, "fndsa_mp_NTT")
    ntti = instructions(elfi, "fndsa_mp_NTT")
    assert stable_operands(ntt1) == stable_operands(ntti)

    intt1 = instructions(elf1, "fndsa_mp_iNTT")
    intti = instructions(elfi, "fndsa_mp_iNTT")
    old = Counter(op for op, _ in intt1)
    new = Counter(op for op, _ in intti)
    assert old["vpt.s32"] - new["vpt.s32"] == 9
    assert old["vaddt.i32"] - new["vaddt.i32"] == 9
    for opcode in ("vsub.i32", "vqrdmulh.s32", "vhadd.s32", "vmul.i32"):
        assert old[opcode] == new[opcode]

    branches = lambda ins: [op for op, _ in ins if op.startswith("b")]
    memory = lambda ins: [(op, operand.split("@")[0].strip())
                          for op, operand in ins
                          if op.startswith(("ldr", "str", "vldr", "vstr",
                                            "vld4", "vst4"))]
    assert branches(intt1) == branches(intti)
    assert memory(intt1) == memory(intti)

    print(json.dumps({
        "changed_crypto_sources": changed,
        "m1_elf_sha256": sha(elf1),
        "m1_improve_elf_sha256": sha(elfi),
        "m1_improve_audit_elf_sha256": sha(audit),
        "assembly_sha256": sha(IMPROVE / "kgen_mp31_cm55.s"),
        "forward_ntt_instruction_sequence_unchanged": True,
        "forward_ntt_byte_identity": False,
        "inverse_removed_vpt": old["vpt.s32"] - new["vpt.s32"],
        "inverse_removed_vaddt": old["vaddt.i32"] - new["vaddt.i32"],
        "inverse_scalar_branch_opcodes_unchanged": True,
        "inverse_memory_operands_unchanged": True,
        "test_probe_removed_from_performance_elf": True,
        "formal_constant_time_proof": False,
        "dynamic_timing_leakage_test": False,
    }, indent=2))


if __name__ == "__main__":
    main()
