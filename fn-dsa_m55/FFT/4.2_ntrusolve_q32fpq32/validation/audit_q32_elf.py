#!/usr/bin/env python3
"""Local ELF audit: instruction evidence, not a constant-time proof."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
root=Path(__file__).resolve().parent.parent
m55=root.parents[1]
elf=root/'validation/build'/sys.argv[1]/'zephyr/zephyr.elf'
tool=m55/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
text=subprocess.check_output([tool,'-d',elf],text=True)
blocks={}
for part in re.split(r'\n(?=[0-9a-f]+ <)',text):
    match=re.match(r'[0-9a-f]+ <([^>]+)>:',part)
    if match: blocks[match[1]]=part
report={'elf':str(elf),'elf_sha256':hashlib.sha256(elf.read_bytes()).hexdigest(),
 'scope':'branch screening only; predication, operand timing and whole keygen not proven','symbols':{}}
for name in ['qd_raw_floor','qd_mul','fndsa_inner_fxr_div','fndsa_ds_reciprocal',
             'fndsa_ds_mul','fndsa_ds_div_selfadj','fndsa_ds_div_real','fndsa_ds_inverse']:
    if name not in blocks:continue
    block=blocks[name]
    report['symbols'][name]={
      'conditional_branches':[s.strip() for s in block.splitlines() if re.search(
        r'\t(b(?:eq|ne|cc|cs|hi|ls|ge|gt|le|lt|mi|pl|vs|vc)(?:\.[nw])?|cbn?z)\s',s)],
      'it_blocks':[s.strip() for s in block.splitlines() if re.search(r'\tit[te]*\s',s)],
      'fp32_arithmetic':len(re.findall(r'\tv(?:add|sub|mul|fma|fms)\.f32',block))}
for name in ['qd_raw_floor','qd_mul']:
    assert name in report['symbols']
    assert not report['symbols'][name]['conditional_branches'],name
print(json.dumps(report,indent=2))
