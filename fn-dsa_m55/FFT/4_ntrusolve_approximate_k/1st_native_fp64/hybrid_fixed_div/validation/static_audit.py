"""Conservative checks of this exact GCC/M55 divider binary, not a CT proof."""
from pathlib import Path
import hashlib
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parent
TOOL = ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
OUT = ROOT/'results/static'
OUT.mkdir(parents=True, exist_ok=True)
rows = []
for label in ('hybrid-perf', 'hybrid-profile', 'kernels', 'kat'):
    elf = ROOT/'build'/label/'zephyr/zephyr.elf'
    asm = subprocess.check_output([str(TOOL), '-d', '--disassemble=fxr_div_fp64_exact', str(elf)], text=True)
    assert '<fxr_div_fp64_exact>:' in asm
    instructions = []
    for line in asm.splitlines():
        m = re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+\s*([a-z][a-z0-9.]*)\s*(.*)', line)
        if m:
            instructions.append(m.groups())
    assert len(instructions) > 100
    forbidden = [i for i in instructions if re.fullmatch(r'it[te]*', i[0]) or
                 re.fullmatch(r'(b|bl|blx|bx|b(eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le)|cbz|cbnz)(\.w|\.n)?', i[0])]
    assert not forbidden, (label, forbidden)
    divs = [i for i in instructions if i[0].startswith('vdiv')]
    assert len(divs) == 1 and divs[0][0] == 'vdiv.f64'
    assert not any(i[0].startswith(('vfma', 'vfms', 'sdiv', 'udiv')) for i in instructions)
    accesses = [i for i in instructions if '[' in i[1]]
    assert accesses and all(re.search(r'\[(sp|pc)(?:\]|,\s*#-?\d+\])', i[1]) for i in accesses), accesses
    (OUT/(label+'.asm')).write_text(asm)
    rows.append(dict(label=label, elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),
                     instructions=len(instructions), conditional_instructions=0, calls_or_branches=0,
                     vdiv_f64=1, indexed_memory='fixed stack / PC literal offsets only'))
(OUT/'summary.json').write_text(json.dumps(rows, indent=2)+'\n')
print(json.dumps(rows, indent=2))
