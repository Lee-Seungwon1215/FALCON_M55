"""Extract a self-contained FFT implementation from archived compiler output.

No build-time import: output .s is checked into this candidate and compiled as
ordinary source. The GCC input, extracted baseline and schedule manifest stay
under validation. Review and apply the scheduled output explicitly.
"""
from pathlib import Path
import re,sys
src=Path(sys.argv[1]).read_text()
names=['fp64e_cmul_prepared','fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact']
parts=[]
for name in names:
    pattern=r'\t\.section\s+\.text\.'+re.escape(name)+r',.*?\n.*?\t\.size\s+'+re.escape(name)+r',[^\n]+\n'
    m=re.search(pattern,src,re.S);assert m,name
    lines=[]
    for line in m[0].splitlines():
        s=line.strip()
        if s.startswith(('.loc ','.loc\t','.cfi_','.file ')) or re.match(r'\.L(VL|VU|FB|FE|BB|BE)\d+:',s):continue
        if s.startswith('@') or s.startswith('#'):continue
        if '.word\tGM_TAB' in line:line=line.replace('GM_TAB','fndsa_kgen_GM_TAB')
        lines.append(line)
    parts.append('\n'.join(lines))
header='/* Offline GCC 15.2.1 extraction; exact two-layer FP64 FFT. */\n.syntax unified\n.arch armv8.1-m.main\n.fpu fpv5-d16\n.thumb\n'
text=header+'\n'.join(parts)+'\n.section .note.GNU-stack,"",%progbits\n'
Path(sys.argv[2]).write_text(text)
print('Extracted',names,'lines',len(text.splitlines()))
