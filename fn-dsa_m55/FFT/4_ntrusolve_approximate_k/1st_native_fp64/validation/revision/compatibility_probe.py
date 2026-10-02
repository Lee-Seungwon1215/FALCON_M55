#!/usr/bin/env python3
"""Diagnostic only: keep the original reciprocal preparation, native reduction.
Never installs this mixed-arithmetic candidate into production sources.
"""
import hashlib,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT.parent))
import host
out=ROOT/'compatibility';out.mkdir(exist_ok=True)
text=(host.SOURCE/'kgen_ntru.c').read_text()
old='''\tpoly_big_to_fp64(logn, rt3, ftb, rlen, scdiff);

\t/* rt3 <- adj(f)/(f*adj(f))  (FFT)  */
\tvect_FFT_fp64(logn, rt3);
\tvect_inv_mul2e_fft_fp64(logn, rt3, scale_t);'''
new='''\t/* EXPERIMENT ONLY: original fixed reciprocal, native repeated path. */
\tpoly_big_to_fixed(logn, (fxr *)rt3, ftb, rlen, scdiff);
\tvect_FFT(logn, (fxr *)rt3);
\tvect_inv_mul2e_fft(logn, (fxr *)rt3, scale_t);
\tfor (size_t i = 0; i < n; i ++) {
\t\tuint64_t word; memcpy(&word, rt3+i, 8);
\t\trt3[i] = (double)(int32_t)(word >> 32) + (double)(uint32_t)word * 0x1p-32;
\t}'''
assert text.count(old)==1
(out/'kgen_ntru.c').write_text(text.replace(old,new))
sources=[str(host.SOURCE/(n+'.c')) for n in host.NAMES if n!='kgen_ntru']
subprocess.run(['clang',*host.FLAGS,'-I'+str(host.SOURCE),*sources,str(out/'kgen_ntru.c'),str(ROOT.parent/'kat_audit.c'),'-lm','-o',str(out/'kat')],check=True)
with (out/'kat.log').open('w') as log:r=subprocess.run([str(out/'kat')],stdout=log,stderr=subprocess.STDOUT)
print('Diagnostic mixed-path KAT exit:',r.returncode)
print('\n'.join(x for x in (out/'kat.log').read_text().splitlines() if 'SUMMARY' in x or 'KAT-hash:' in x))
assert r.returncode in (0,1,2)
(out/'manifest.json').write_text(json.dumps(dict(
 diagnostic_only=True,returncode=r.returncode,
 generated_ntru_sha256=hashlib.sha256((out/'kgen_ntru.c').read_bytes()).hexdigest(),
 source={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in host.SOURCE.iterdir() if p.suffix in ('.c','.h','.s')}),indent=2)+'\n')
