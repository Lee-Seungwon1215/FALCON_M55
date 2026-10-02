"""Mechanical CT checks; retain bodies for manual public-loop/address review."""
from pathlib import Path
import hashlib,json,re,subprocess,sys
has_root=len(sys.argv)>1 and Path(sys.argv[1]).is_dir()
ROOT=Path(sys.argv[1]).resolve() if has_root else Path(__file__).resolve().parent
TOOL=ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
OUT=ROOT/'results/static';OUT.mkdir(parents=True,exist_ok=True)
labels=sys.argv[2 if has_root else 1:] or ['kernels','kat','asm-perf']
rows=[]
for label in labels:
    elf=ROOT/'build'/label/'zephyr/zephyr.elf'
    full=subprocess.check_output([str(TOOL),'-d',str(elf)],text=True)
    bodies=re.findall(r'^([0-9a-f]+) <([^>]+)>:\n(.*?)(?=^[0-9a-f]+ <|\Z)',full,re.M|re.S)
    targets=[]
    for address,name,body in bodies:
        if not name.startswith(('fndsa_fp64e_mul','fp64e_cmul','fp64e_mul32','fxr_div_fp64_exact',
            'fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact','fndsa_vect_mul_fft_fp64_exact',
            'fndsa_vect_inv_mul2e_fft_fp64_exact','fndsa_poly_big_to_fp64_exact')):continue
        (OUT/(label+'-'+name+'.asm')).write_text(address+' <'+name+'>:\n'+body)
        ins=[]
        for line in body.splitlines():
            m=re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+\s*([a-z][a-z0-9.]*)\s*(.*)',line)
            if m:ins.append(m.groups())
        it=[x for x in ins if re.fullmatch(r'it[te]*',x[0])]
        branches=[x for x in ins if re.fullmatch(r'(b(eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le)|cbz|cbnz)(\.w|\.n)?',x[0])]
        calls=[x for x in ins if re.fullmatch(r'bl(x)?(\.w|\.n)?',x[0])]
        assert '__aeabi_d' not in body,(label,name,'software FP64')
        assert not re.search(r'<fndsa_vect_(FFT|iFFT|mul_fft|inv_mul2e_fft)>',body),(label,name,'fixed fallback')
        # FFT wrappers may predicate the public logn==2 small-size path.
        # Retain these sites for manual review; arithmetic helpers stay strict.
        if not name.startswith(('fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact')):
            assert not it,(label,name,it)
        if name.startswith(('fndsa_fp64e_mul','fp64e_cmul','fp64e_mul32','fxr_div_fp64_exact')):
            assert not branches,(label,name,branches)
        targets.append(dict(name=name,address=address,instructions=len(ins),IT=it,branches=branches,calls=calls,
            explicit_FMA=sum(op.startswith(('vfma','vfms','vfnma','vfnms')) for op,_ in ins),
            FP64=sum('.f64' in op for op,_ in ins),memory_instructions=[x for x in ins if x[0].startswith(('ldr','str','vldr','vstr','ldm','stm','vldm','vstm'))]))
    assert any(x['name'].startswith('fndsa_vect_FFT_fp64_exact') for x in targets)
    assert any(x['explicit_FMA'] for x in targets)
    rows.append(dict(label=label,elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),functions=targets))
(OUT/'audit.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps([dict(label=x['label'],functions=len(x['functions']),FMA=sum(y['explicit_FMA'] for y in x['functions'])) for x in rows]))
