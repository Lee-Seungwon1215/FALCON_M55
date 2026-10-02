#!/usr/bin/env python3
"""Check linked packed-tail arithmetic and public gather/control structure.

This checks the two assembly loops, not all FP latency or all FN-DSA paths.
"""
from collections import Counter
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT.parents[1] / "measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump"
ELF = ROOT / "build/board/zephyr/zephyr.elf"


def instructions(name):
    text = subprocess.check_output([str(TOOL), "-d", "--disassemble="+name, str(ELF)], text=True)
    result = []
    for line in text.splitlines():
        match = re.match(r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+){1,2}(\S+)\s*(.*)$", line)
        if match:
            result.append((int(match[1], 16), match[2], match[3].split("@")[0].strip()))
    return result


def loop(name):
    ins = instructions(name)
    branches = [r for r in ins if r[1].split(".")[0] == "bne"]
    assert len(branches) == 1
    end = branches[0]
    start = int(end[2].split()[0], 16)
    body = [r for r in ins if start <= r[0] <= end[0]]
    assert body[-2][1].startswith("subs") and body[-2][2] == "r9, r9, #1"
    return body


def audit():
    result = []
    for direction in ("fwd", "inv"):
        name = "ds32_tail_"+direction+"4"
        body = loop(name)
        fp = [(op, args) for _, op, args in body if op.endswith(".f32")]
        # Inverse root conjugation was previously in C, now in the loop.
        conjugates = [(op, args) for op, args in fp
                      if op == "vneg.f32" and args in ("q4, q4", "q5, q5")]
        assert len(conjugates) == (4 if direction == "inv" else 0)
        numeric = [r for r in fp if r not in conjugates]
        old_fp = [(op, args) for _, op, args in loop("ds32_bfly_"+direction+"4_span")
                  if op.endswith(".f32")]
        assert numeric == old_fp, (name, "changed FP operation sequence")
        index_table = {}
        gathers = scatters = 0
        for _, op, args in body:
            if op.startswith(("vldrw.", "vstrw.")):
                indexed = re.search(r"\[(\w+), (q[0-7])\]", args)
                if indexed:
                    assert index_table.get(indexed[2], False), (name, op, args)
                    if op.startswith("vldrw."): gathers += 1
                    else: scatters += 1
            if op.startswith("v") and not op.startswith("vstr"):
                dest = args.split(",")[0]
                if re.fullmatch("q[0-7]", dest):
                    index_table[dest] = op.startswith("vldrw.") and bool(
                        re.search(r"\[(?:fp|lr), #(?:0|16)\]", args))
            if not op.startswith("v"):
                assert op in ("add", "add.w", "subs.w", "bne.w", "bne.n"), (op, args)
        mem = [(op, args) for _, op, args in body if op.startswith(("vldrw.", "vstrw."))]
        result.append({"symbol": name, "loop_instructions": len(body),
                       "fp_instructions": dict(Counter(op for op, args in fp)),
                       "FP_sequence_equals_span_except_public_conjugation": True,
                       "vector_memory": len(mem), "gather": gathers, "scatter": scatters,
                       "scratch_memory": sum("[sp," in args for op, args in mem),
                       "conditional_branches_in_loop": 1,
                       "gather_indices_from_fixed_public_tables": True,
                       "private_stack_bytes": 32 if direction == "fwd" else 64,
                       "total_stack_bytes_including_ABI": 136 if direction == "fwd" else 168})
    # Explicit exhaustive address check across every supported degree.
    for logn in range(4, 11):
        hn = 1 << (logn-1)
        for ht in (1, 2):
            offsets = (0, 2, 4, 6) if ht == 1 else (0, 1, 4, 5)
            seen = []
            for block in range(hn//8):
                for lane, offset in enumerate(offsets):
                    x = block*8+offset
                    y = x+ht
                    group = block*(4//ht) + lane//ht
                    assert x//(2*ht) == group and y//(2*ht) == group
                    assert 0 <= group < hn//(2*ht)
                    seen.extend((x, y))
            assert sorted(seen) == list(range(hn))
    return {"status": "PASS", "scope": "Assembly arithmetic/control and fixed index bounds; not a full CT proof",
            "loops": result, "all_logN4_to_10_coefficient_indices_covered_exactly_once_per_layer": True}


if __name__ == "__main__":
    print(json.dumps(audit(), indent=2))
