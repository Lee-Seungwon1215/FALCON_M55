#!/usr/bin/env python3
"""Board-equivalent digests plus targeted UBSan checks on changed FP64 TUs.

The local Apple ASan runtime aborts before main (also outside the sandbox).
The failed ASan logs are retained; this script does not claim ASan coverage.
Full-program UBSan also stops in unchanged mq.c NEON signed accumulation.
Sanitize the three changed C translation units (including the inline header)
and diagnostic code, while retaining
unsanitized upstream mq/sign/etc. This is NOT full-program UBSan coverage.
"""
import json
import os
from pathlib import Path
import subprocess
import host
ROOT=Path(__file__).resolve().parent
out=ROOT/'build/host'
for label,source in [('ref',host.BASE),('fp64',host.SOURCE)]:
    flags=host.FLAGS.copy()
    # Exercise the upstream portable SHAKE loads on the host: its optional
    # unaligned pointer casts trigger alignment UBSan independently of FP64.
    # No sanitizer category is disabled; board firmware is unchanged.
    flags += ['-DFNDSA_UNALIGNED_64=0', '-DFNDSA_UNALIGNED_16=0']
    source_list=[str(source/(n+'.c')) for n in host.NAMES]
    if os.environ.get('BASELINE_UBSAN') and label=='fp64':
        continue
    if label=='fp64':
        original=(source/'kgen_ntru.c').read_text()
        old='k[i] = fp64_round_i32_checked(rt1[i], &round_ok);'
        assert original.count(old)==1
        text='#include <stdint.h>\nextern int32_t audited_round(unsigned,double,uint32_t*);\nextern uint32_t audited_update(unsigned,const int32_t*);\n'+original.replace(old,'k[i] = audited_round(logn,rt1[i], &round_ok);')
        text=text.replace('round_ok &= fp64_k_update_ok(logn, k);','round_ok &= audited_update(logn, k);')
        generated=out/'range_ntru.c';generated.write_text(text)
        source_list=[s for s in source_list if not s.endswith('/kgen_ntru.c')]
        source_list += [str(generated),str(ROOT/'round_audit.c')]
        fxp=(source/'kgen_fxp.c').read_text()
        old='double re = a[i], im = -a[i + hn];'
        assert fxp.count(old)==1
        fxp='extern void audit_div_operand(double,double);\n'+fxp.replace(old,old+'\n\t\taudit_div_operand(re,im);')
        fpfile=out/'range_fxp.c';fpfile.write_text(fxp)
        source_list=[s for s in source_list if not s.endswith('/kgen_fxp.c')]+[str(fpfile)]
    source_list.append(str(ROOT/'benchmark.c'))
    objects=[]
    objdir=out/('objects-'+label);objdir.mkdir(exist_ok=True)
    for src in source_list:
        selected=(label=='fp64' and Path(src).name in ('range_ntru.c','range_fxp.c','kgen_poly.c','round_audit.c')) or (bool(os.environ.get('BASELINE_UBSAN')) and Path(src).name in ('kgen_ntru.c','kgen_fxp.c','kgen_poly.c'))
        opts=flags if not selected else ['-O1',*flags[1:],'-g','-fsanitize=undefined,float-cast-overflow','-fno-sanitize-recover=all']
        obj=objdir/(Path(src).stem+'.o');objects.append(str(obj))
        subprocess.run(['clang',*opts,'-DBENCH_HOST','-I'+str(source),'-I'+str(ROOT),'-c',src,'-o',str(obj)],check=True)
    command=['clang',*objects,'-fsanitize=undefined,float-cast-overflow','-lm','-o',str(out/('bench-'+label))]
    subprocess.run(command,check=True)
    with (out/('bench-'+label+'.log')).open('w') as log:
        result=subprocess.run([str(out/('bench-'+label))],stdout=log,stderr=subprocess.STDOUT)
    assert result.returncode==0,(label,result.returncode)
    print(label,'100 keys/signatures per degree PASS',flush=True)
