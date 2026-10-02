"""Audit the exact M55 multiplication core; retain transform loop disassembly."""
from pathlib import Path
import hashlib,json,re,subprocess
ROOT=Path(__file__).resolve().parent
TOOL=ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
OUT=ROOT/'results/static';OUT.mkdir(parents=True,exist_ok=True)
summary=[]
for label in ('kernels','kat','compat-perf','compat-profile'):
    elf=ROOT/'build'/label/'zephyr/zephyr.elf'
    rows=[]
    for name in ('fp64q_mul','fndsa_vect_FFT_fp64q','fndsa_vect_iFFT_fp64q','fndsa_vect_mul_fft_fp64q'):
        asm=subprocess.check_output([str(TOOL),'-d','--disassemble='+name,str(elf)],text=True)
        assert '<'+name+'>:' in asm,(label,name)
        (OUT/(label+'-'+name+'.asm')).write_text(asm)
        instructions=[]
        for line in asm.splitlines():
            m=re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+\s*([a-z][a-z0-9.]*)\s*(.*)',line)
            if m:instructions.append(m.groups())
        assert not any(re.fullmatch(r'it[te]*',op) for op,_ in instructions),(label,name,'IT')
        assert not any(op.startswith(('vfma','vfms','vdiv')) for op,_ in instructions)
        if name=='fp64q_mul':
            assert not any(re.fullmatch(r'(b|bl|blx|bx|b(eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le)|cbz|cbnz)(\.w|\.n)?',op) for op,_ in instructions)
            access=[operands for _,operands in instructions if '[' in operands]
            assert all(re.search(r'\[(sp|pc|r0)(?:\]|,\s*#-?\d+\])',a) for a in access),access
        rows.append(dict(function=name,instructions=len(instructions),IT_blocks=0,
                         fp64_multiply=sum(op=='vmul.f64' for op,_ in instructions)))
    summary.append(dict(label=label,elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),functions=rows,
       scope='core has no branch/call and only fixed stack/PC/ABI output offsets; transform public loops inspected separately; not a whole-program CT proof'))
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
