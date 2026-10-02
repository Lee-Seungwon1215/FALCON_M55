#!/usr/bin/env python3
"""Host AddressSanitizer, complementary to the real-board stack watermark."""
import os,json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parent;SRC=ROOT.parent
OUT=ROOT/'build/asan';OUT.mkdir(parents=True,exist_ok=True)
names='codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy'.split()
flags=['-O3','-ffp-contract=off','-fno-fast-math','-fno-strict-aliasing','-DFNDSA_AVX2=0','-DFNDSA_UNALIGNED_64=0','-DFNDSA_UNALIGNED_16=0','-fsanitize=address','-fno-omit-frame-pointer']
env=os.environ.copy();env['ASAN_OPTIONS']='detect_leaks=0:halt_on_error=1'
summary=[]
def save():
    (OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')

# Check the sanitizer runtime before interpreting a crypto-test abort. The
# empty program cannot exercise the implementation under test.
smoke=OUT/'runtime_smoke'
subprocess.run(['clang','-x','c','-fsanitize=address','-o',str(smoke),'-'],
    input='int main(void) { return 0; }\n',text=True,check=True)
with (OUT/'runtime_smoke.log').open('w') as log:
    probe=subprocess.run([str(smoke)],env=env,stdout=log,stderr=subprocess.STDOUT)
if probe.returncode:
    summary.append(dict(test='runtime_smoke',status='UNAVAILABLE',returncode=probe.returncode,
        reason='ASan runtime failed for an empty program; crypto ASan tests are not passed.'))
    save()
    print(json.dumps(summary,indent=2),flush=True)
    raise SystemExit(1)

for test in ('kat_audit','benchmark'):
    exe=OUT/test
    subprocess.run(['clang',*flags,'-DBENCH_HOST','-I'+str(SRC),*[str(SRC/(n+'.c')) for n in names],str(ROOT/(test+'.c')),'-lm','-o',str(exe)],check=True)
    with (OUT/(test+'.log')).open('w') as log:
        run=subprocess.run([str(exe)],env=env,stdout=log,stderr=subprocess.STDOUT)
    if run.returncode:
        summary.append(dict(test=test,status='FAIL',returncode=run.returncode))
        save()
        raise SystemExit(1)
    text=(OUT/(test+'.log')).read_text()
    assert ('KEY_KAT_SUMMARY count=300 mismatches=0' in text) if test=='kat_audit' else ('signature_and_tamper=PASS' in text)
    summary.append(dict(test=test,status='PASS',scope='All host C translation units; no board ASM; leak detection disabled'))
    print(test,'ASan PASS',flush=True)
save()
