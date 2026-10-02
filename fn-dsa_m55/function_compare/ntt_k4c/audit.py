#!/usr/bin/env python3
"""Fail closed on changed extracts, foreign crypto sources, stale builds/layouts."""
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
import sys
ROOT=Path(__file__).resolve().parent
ENV=ROOT.parents[1]/'measurement_mlkem_native/env'
BIN=ENV/'arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
KERNELS=['orig_mqpoly_int_to_ntt','orig_mqpoly_ntt_to_int',
         'opt_mqpoly_int_to_ntt','opt_mqpoly_ntt_to_int',
         'orig_mp_NTT','orig_mp_iNTT','opt_mp_NTT','opt_mp_iNTT']
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def sources():
    manifest=json.loads((ROOT/'extraction.json').read_text())
    for name,digest in manifest['inputs'].items():
        assert sha(ROOT.parents[1]/name)==digest, 'reference source changed: '+name
    for name,digest in manifest['outputs'].items():
        p=ROOT/name
        assert p.is_file() and not p.is_symlink() and sha(p)==digest, 'changed extraction: '+name
    paths=[p for p in ROOT.rglob('*') if p.is_file() and
           (p.relative_to(ROOT).parts[0] in ('original','optimized','bench','board') or
            p.name in ('extraction.json','extract.py','CMakeLists.txt','build.sh')) and
           p.suffix in ('.c','.h','.s','.py','.sh','.txt','.conf','.overlay','.json')]
    return {str(p.relative_to(ROOT)):sha(p) for p in sorted(paths)}
def inspect(layout):
    build=ROOT/'build'/layout
    commands=json.loads((build/'compile_commands.json').read_text())
    seen=[]
    for row in commands:
        p=Path(row['file']).resolve()
        if ROOT in p.parents and build not in p.parents:
            args=row.get('arguments') or shlex.split(row['command'])
            opts=[x for x in args if re.fullmatch(r'-O[0-3sgz]|-Ofast',x)]
            assert opts and opts[-1]=='-O3', (p,opts)
            assert '-fno-reorder-functions' in args
            seen.append(str(p.relative_to(ROOT)))
        else:
            assert ENV in p.parents or build in p.parents, 'foreign source '+str(p)
    assert len(seen)==11,seen
    elf=build/'zephyr/zephyr.elf'
    nm=subprocess.check_output([str(BIN/'arm-none-eabi-nm'),'-n','-S',str(elf)],text=True)
    syms={}
    for line in nm.splitlines():
        parts=line.split()
        if len(parts)==4: syms[parts[3]]={'address':int(parts[0],16),'size':int(parts[1],16),'type':parts[2]}
        elif len(parts)==3: syms[parts[2]]={'address':int(parts[0],16),'size':0,'type':parts[1]}
    for name in KERNELS:
        assert name in syms and 0x10000000<=syms[name]['address']<0x10010000,(name,syms.get(name))
    for name in ('ga','gb','qa','qb','gm','igm','igm_full','PRIMES','orig_mq_GM','opt_mq_barrett3_GM'):
        assert 0x30000000<=syms[name]['address']<0x30040000,(name,syms.get(name))
    assert not any(name.startswith(('fndsa_','mp_div','solve_NTRU')) for name in syms)
    dis=subprocess.check_output([str(BIN/'arm-none-eabi-objdump'),'-d',str(elf)],text=True)
    (build/'firmware.dis').write_text(dis)
    assert 'vqrdmulh.s16' in dis and 'vqrdmulh.s32' in dis
    assert 'umull' in dis and 'umlal' in dis
    artifacts=['zephyr/zephyr.elf','zephyr/zephyr.map','zephyr/.config','compile_commands.json','compare_linker.ld']
    return {'layout':layout,'sources':sources(),'compiled_local_sources':sorted(seen),
            'artifacts':{name:sha(build/name) for name in artifacts},
            'symbols':syms,'disassembly_sha256':sha(build/'firmware.dis')}
def check(layout):
    before=json.loads((ROOT/'build'/layout/'manifest.json').read_text())
    now=inspect(layout)
    assert before==now,'stale build; rebuild first'
    return now
def layouts():
    a=check('ab'); b=check('ba')
    assert a['sources']==b['sources']
    assert a['artifacts']['zephyr/.config']==b['artifacts']['zephyr/.config']
    changed=[]
    for name,s in a['symbols'].items():
        t=b['symbols'].get(name)
        if t and (s['address']!=t['address']):
            changed.append(name)
            assert name.startswith(('orig_mqpoly_','opt_mqpoly_','orig_mp_NTT','orig_mp_iNTT','opt_mp_NTT','opt_mp_iNTT')),name
    assert all(name in changed for name in KERNELS)
    return {'status':'PASS','moved_symbols':changed,
            'meaning':'kernel slots swapped; all other named code/data addresses identical'}
if __name__=='__main__':
    mode=sys.argv[1]
    if mode=='sources': print('PASS local sources:',len(sources()))
    elif mode=='record':
        result=inspect(sys.argv[2]); (ROOT/'build'/sys.argv[2]/'manifest.json').write_text(json.dumps(result,indent=2)+'\n')
        print('PASS build audit:',sys.argv[2])
    elif mode=='check': check(sys.argv[2]); print('PASS current build')
    elif mode=='layouts':
        result=layouts(); (ROOT/'results').mkdir(exist_ok=True)
        (ROOT/'results/layout_audit.json').write_text(json.dumps(result,indent=2)+'\n'); print(result)
    else: raise SystemExit('sources | record/check ab/ba | layouts')
