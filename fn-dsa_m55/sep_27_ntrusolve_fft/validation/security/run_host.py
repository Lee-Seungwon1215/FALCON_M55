#!/usr/bin/env python3
"""Archive a host numerical/sanitizer run; never substitute it for ARM tests."""
import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

root=Path(__file__).resolve().parents[2]
mode=sys.argv[1] if len(sys.argv)>1 else 'ubsan'
assert mode in ('plain','ubsan','asan','asan_probe','witness')
out=root/'validation/security/results'/('host_'+mode+'_'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'))
out.mkdir(parents=True)
src=root/'A_tw_bridge'
files=[root/'validation/security/invnorm_audit.c']+[src/n for n in ('kgen_fxp.c','kgen_gauss.c','sha3.c')]
if mode=='asan_probe':files=[root/'validation/security/asan_probe.c']
if mode=='witness':files[0]=root/'validation/security/numeric_witness.c'
cmd=['clang','-O1','-g','-ffunction-sections','-fdata-sections','-ffp-contract=off','-fno-fast-math',
     '-DFNDSA_AVX2=0','-DFNDSA_ASM_CORTEXM4=0','-DFNDSA_ASM_CORTEXM55=0','-DAUDIT_BOARD=0','-I'+str(src)]
if mode!='plain':
    cmd+=['-fsanitize='+('address,' if mode.startswith('asan') else '')+'undefined,float-cast-overflow','-fno-sanitize-recover=all']
cmd += [str(f) for f in files]+['-Wl,-dead_strip','-o',str(out/'audit')]
print('HOST_START',out,flush=True)
build=subprocess.run(cmd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
(out/'build.log').write_text(build.stdout)
run=subprocess.run([str(out/'audit')],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True) if build.returncode==0 else None
raw=run.stdout if run else ''
(out/'raw.log').write_text(raw)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest={'command':cmd,'build_returncode':build.returncode,'run_returncode':run.returncode if run else None,
 'claim':'Host C-path numerical and sanitizer evidence only, not M55 assembly or complete security',
 'sources':{str(f):sha(f) for f in files+list(src.glob('*.h'))},
 'raw_sha256':sha(out/'raw.log'),'pass':run is not None and run.returncode==0 and
 ('ASAN_RUNTIME_PROBE_REACHED_MAIN' if mode=='asan_probe' else
  'SEC_WITNESS_DONE' if mode=='witness' else 'SEC_DONE failures=0') in raw}
(out/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(raw,flush=True)
print('HOST_END',out,'pass=',manifest['pass'],flush=True)
sys.exit(not manifest['pass'])
