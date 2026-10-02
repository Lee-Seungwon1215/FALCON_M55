#!/usr/bin/env python3
"""Locate the first arithmetic divergence on each of the 26 mismatching seeds."""
from pathlib import Path
import hashlib,json,subprocess,sys
from decimal import Decimal as D,localcontext,ROUND_FLOOR
ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT.parent))
import host
out=ROOT/'diagnosis';out.mkdir(exist_ok=True)
text=(host.BASE/'kgen_ntru.c').read_text()
start=text.index('solve_NTRU_intermediate(');end=text.index('\n#if FNDSA_AVX2',start)
part=text[start:end]
for old,new in [
 ('\tvect_FFT(logn, rt3);','\tshadow_f(logn,rt3,scale_t);\n\tvect_FFT(logn, rt3);'),
 ('\t\tvect_FFT(logn, rt1);','\t\tshadow_F(logn,rt1);\n\t\tvect_FFT(logn, rt1);'),
 ('\t\t/* k <- round(rt1)','\t\tshadow_round(logn,depth,rt1);\n\t\t/* k <- round(rt1)')]:
 assert part.count(old)==1,old
 part=part.replace(old,new)
text='#include "kgen_inner.h"\nextern void shadow_f(unsigned,const fxr*,unsigned);\nextern void shadow_F(unsigned,const fxr*);\nextern void shadow_round(unsigned,unsigned,const fxr*);\n'+text[:start]+part+text[end:]
(out/'shadow_ntru.c').write_text(text)
sources=[str(host.SOURCE/(n+'.c')) for n in host.NAMES if n!='kgen_ntru']
subprocess.run(['clang',*host.FLAGS,'-I'+str(host.SOURCE),*sources,str(out/'shadow_ntru.c'),str(ROOT/'shadow.c'),'-lm','-o',str(out/'shadow')],check=True)
kat=json.loads((host.BUILD/'summary.json').read_text())['kat']['fp64']['mismatches']
summary=[]
for case in kat:
 degree=case['degree'];seed=case['seed'];l=degree.bit_length()-1
 raw=subprocess.check_output([str(out/'shadow'),str(l),seed],text=True)
 row=json.loads(raw);assert row['differences']>0
 row.update(case)
 with localcontext() as ctx:
  ctx.prec=80
  f=[D(float.fromhex(x)) for x in row['f']];a=[D(float.fromhex(x)) for x in row['F']]
  gm=host.roots();host.fft(f,gm);hn=len(f)//2
  for i in range(hn):
   re,im=f[i],-f[i+hn];z=re*re+im*im
   f[i]=re*(D(2)**row['e'])/z;f[i+hn]=im*(D(2)**row['e'])/z
  host.fft(a,gm)
  for i in range(hn):a[i],a[i+hn]=host.mul((a[i],a[i+hn]),(f[i],f[i+hn]))
  host.fft(a,gm,True)
  rnd=lambda x:int((x+D('0.5')).to_integral_value(rounding=ROUND_FLOOR))
  kd=[rnd(D(float.fromhex(x))) for x in row['fp64_x']]
  ko=[rnd(x) for x in a]
  row['oracle_k']=ko;row['fp64_oracle_k_differences']=sum(x!=y for x,y in zip(kd,ko))
  row['oracle_max_error']=str(max(abs(D(float.fromhex(x))-y) for x,y in zip(row['fp64_x'],a)))
 (out/f'{degree}-{seed}.json').write_text(json.dumps(row,indent=2)+'\n')
 summary.append({k:row[k] for k in ['degree','seed','round','logn','depth','differences','fixed_inverse_residual','fp64_oracle_k_differences','oracle_max_error']})
 print(summary[-1],flush=True)
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
(out/'manifest.json').write_text(json.dumps(dict(
 source={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in host.SOURCE.iterdir() if p.suffix in ('.c','.h','.s')},
 baseline_ntru_sha256=hashlib.sha256((host.BASE/'kgen_ntru.c').read_bytes()).hexdigest(),
 method='Unchanged baseline state until the first different rounded k; shadow native arithmetic; Decimal 80-digit oracle'),indent=2)+'\n')
