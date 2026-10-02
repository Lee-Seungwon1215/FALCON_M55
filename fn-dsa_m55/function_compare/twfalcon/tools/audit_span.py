#!/usr/bin/env python3
"""Audit the actual linked span loops, not macro source line counts.

Vector memory counts exclude the prologue/epilogue and twiddle preload.
The only conditional branch is the public block counter's back edge.
This is a structural audit, not a proof of data-independent FP latency.
"""
from collections import Counter
from pathlib import Path
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
TOOL = ROOT.parents[1] / "measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump"
ELF = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "build/board/zephyr/zephyr.elf"
report = []
for name, expected in (("ds32_stage7_fwd4_span", (84, 68)),
                       ("ds32_stage7_inv4_span", (84, 68)),
                       ("ds32_stage8_fwd4_span", (52, 28)),
                       ("ds32_stage8_inv4_span", (52, 28)),
                       ("ds32_bfly_fwd4_span", (36, 4)),
                       ("ds32_bfly_inv4_span", (44, 12))):
    raw = subprocess.check_output([str(TOOL), "-d", "--disassemble=" + name,
                                   str(ELF)], text=True)
    ins = []
    for line in raw.splitlines():
        m = re.match(r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+){1,2}(\S+)\s*(.*)$", line)
        if m:
            ins.append((int(m[1], 16), m[2], m[3]))
    branches = [i for i in ins if i[1].split('.')[0] == 'bne']
    assert len(branches) == 1, (name, branches)
    back = branches[0]
    start = int(back[2].split()[0], 16)
    body = [i for i in ins if start <= i[0] <= back[0]]
    mem = [i for i in body if i[1].startswith(('vldrw.', 'vstrw.'))]
    stack = [i for i in mem if '[sp,' in i[2] or '[sp]' in i[2]]
    twiddle = [i for i in mem if re.search(r'\[(?:r8|sl),', i[2])]
    conditional = [i for i in body if i[1].startswith(('b', 'cb', 'it', 'vpst'))]
    assert conditional == [back], (name, conditional)
    assert body[-2][1].startswith('subs') and body[-2][2] == 'r9, r9, #1'
    assert (len(mem), len(stack)) == expected, (name, len(mem), len(stack))
    # No secret coefficient is ever transferred into an address register.
    for _, op, operands in body:
        if op.startswith(('vldrw.', 'vstrw.')):
            assert re.search(r'\[(?:sp|ip|sl|r[0-8])(?:, #\d+)?\]', operands), operands
        elif not op.startswith('v'):
            assert op in ('add.w', 'subs.w', 'bne.w', 'bne.n'), (op, operands)
    fp = Counter(op for _, op, _ in body if op.endswith('.f32'))
    report.append(dict(symbol=name, loop_start=hex(start), loop_end=hex(back[0]),
        instructions=len(body), vector_memory=len(mem), scratch_memory=len(stack),
        twiddle_memory=len(twiddle), coefficient_memory=len(mem)-len(stack)-len(twiddle),
        fp_instructions=dict(sorted(fp.items())),
        public_loop_counter='r9', conditional_branches=1))
assert report[0]['fp_instructions'] == report[2]['fp_instructions']
assert report[1]['fp_instructions'] == report[3]['fp_instructions']
assert report[0]['fp_instructions'] == report[4]['fp_instructions']
assert report[1]['fp_instructions'] == report[5]['fp_instructions']
print(json.dumps(dict(elf=str(ELF), scope='full-span loop only', loops=report,
    fp_instruction_multisets_unchanged=True, structural_control_check='PASS'), indent=2))
