#!/usr/bin/env python3
"""Retain current ELF disassembly and mechanically flag CT review targets."""
from pathlib import Path
import hashlib,json,re,subprocess
ROOT=Path(__file__).resolve().parent
TOOL=ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
OUT=ROOT/'results/static';OUT.mkdir(parents=True,exist_ok=True)
allrows=[]
for label in ('kernels','kat','compat-perf','compat-profile'):
    elf=ROOT/'build'/label/'zephyr/zephyr.elf'
    symbols=subprocess.check_output([str(TOOL),'-t',str(elf)],text=True)
    rows=[]
    for name in ('fndsa_fp64e_mul','fxr_div_fp64_exact','fp64e_cmul','fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact','fndsa_vect_mul_fft_fp64_exact','fndsa_vect_inv_mul2e_fft_fp64_exact','fndsa_poly_big_to_fp64_exact'):
        matches=[line.split()[-1] for line in symbols.splitlines() if line.split() and (line.split()[-1]==name or line.split()[-1].startswith(name+'.'))]
        actual=next((x for x in matches if x==name),matches[0] if matches else name)
        asm=subprocess.check_output([str(TOOL),'-d','--disassemble='+actual,str(elf)],text=True)
        if '<'+actual+'>:' not in asm:
            # Some private helpers are inlined; not counted as audited bodies.
            assert name=='fp64e_cmul' or label=='kernels',(label,name)
            rows.append(dict(function=name,symbol=None,instructions=0,IT=[],conditional_branches=[],calls=[],FP64_ops=0,
                note='No separate symbol: inlined or not retained. Reviewed separately in standalone production TUs, not claimed as a separately audited kernel body.'))
            continue
        (OUT/(label+'-'+name+'.asm')).write_text(asm)
        ins=[]
        for line in asm.splitlines():
            m=re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+\s*([a-z][a-z0-9.]*)\s*(.*)',line)
            if m:ins.append(m.groups())
        it=[x for x in ins if re.fullmatch(r'it[te]*',x[0])]
        branches=[x for x in ins if re.fullmatch(r'(b(eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le)|cbz|cbnz)(\.w|\.n)?',x[0])]
        calls=[x for x in ins if re.fullmatch(r'bl(x)?(\.w|\.n)?',x[0])]
        assert not any(op.startswith(('vfma','vfms','vfnma','vfnms')) for op,_ in ins)
        assert '__aeabi_d' not in asm
        assert not re.search(r'<fndsa_vect_(FFT|iFFT|mul_fft|inv_mul2e_fft)>',asm),'legacy fallback'
        if name=='fndsa_fp64e_mul':
            assert not it and not branches and not calls,(label,name,it,branches,calls)
            assert not any(re.fullmatch(r'(mul|muls|mla|mls|umull|smull|smlal|umlal|umaal)(\.w)?',op) for op,_ in ins)
        if name=='fxr_div_fp64_exact':
            assert not it and not branches and not calls,(label,name,it,branches,calls)
        rows.append(dict(function=name,symbol=actual,instructions=len(ins),IT=it,conditional_branches=branches,calls=calls,
            FP64_ops=sum('.f64' in op for op,_ in ins)))
    allrows.append(dict(label=label,elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),functions=rows))
(OUT/'summary.json').write_text(json.dumps(allrows,indent=2)+'\n')
print(json.dumps([dict(label=x['label'],functions=[dict(name=f['function'],IT=f['IT'],branches=len(f['conditional_branches']),FP64_ops=f['FP64_ops']) for f in x['functions']]) for x in allrows],indent=2))
