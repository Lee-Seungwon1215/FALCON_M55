#!/usr/bin/env python3
"""Load only RAM on the fixed M55 probe; preserve full raw logs; fail closed."""
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import socket
from audit import ROOT, ENV, BIN, check, sha

def parse(raw):
    raw=re.sub(r'Info : [^\n]*\n','',raw)
    assert raw.splitlines().count('COMPARE_BEGIN batches=10 calls=100 primes=308 patterns=8')==1,'begin missing/duplicate'
    assert 'COMPARE_FAIL' not in raw,'board test failed'
    hw=re.findall(r'^HW cpu=(\d+) sysclk=(\d+) hclk=(\d+) ccr=([0-9a-f]+) itcmcr=([0-9a-f]+) dtcmcr=([0-9a-f]+)$',raw,re.M)
    assert len(hw)==1 and list(map(int,hw[0][:3]))==[800000000,400000000,200000000]
    assert int(hw[0][3],16)&0x30000==0
    assert all(int(v,16)&0x79==0x49 for v in hw[0][4:])
    timer=re.findall(r'^TIMER wait_us=1000 cycles=(\d+)$',raw,re.M)
    assert len(timer)==1 and 790000<=int(timer[0])<=820000
    for line in ['CHECK family=mq cases=72 mismatches=0 range_errors=0 canary_errors=0',
                 'CHECK family=mp cases=27104 mismatches=0 range_errors=0 canary_errors=0',
                 'AUDIT_DONE cases=27176 independent_dft=1548',
                 'COMPARE_DONE records=4316 correctness=PASS timed_outputs=PASS']:
        assert raw.splitlines().count(line)==1,'missing/duplicate '+line
    rows={}
    for line in raw.splitlines():
        if not line.startswith('BENCH'): continue
        m=re.fullmatch(r'BENCH family=(mq|mp) logn=(\d+) pi=(\d+) dir=([01]) calls=100 old=([0-9,]+) opt=([0-9,]+)',line)
        assert m,'malformed BENCH: '+line
        family,logn,pi,direction,old,opt=m.groups()
        key=(family,int(logn),int(pi),int(direction))
        assert key not in rows,'duplicate result'
        values=[list(map(int,v.split(','))) for v in (old,opt)]
        assert all(len(v)==10 and all(0<x<1000000000 for x in v) for v in values),'invalid timing'
        rows[key]={'family':family,'logn':int(logn),'pi':int(pi),'direction':int(direction),
                   'calls':100,'original_totals':values[0],'optimized_totals':values[1]}
    expected={('mq',l,0,d) for l in (9,10) for d in (0,1)}|{('mp',l,p,d) for l in range(4,11) for p in range(308) for d in (0,1)}
    assert set(rows)==expected,'missing/unexpected kernel measurement'
    for name in ('CFSR','HFSR','AFSR'):
        assert re.findall(r'^'+name+r'=(0x[0-9a-f]+)$',raw,re.M)==['0x0'],name
    for phase in ('START','END'):
        vals=re.findall(r'^TCM_MSCR_'+phase+r'=(0x[0-9a-f]+)$',raw,re.M)
        assert len(vals)==1 and int(vals[0],16)&0x12==2,'ECC'
        assert re.findall(r'^TCM_CONTROL_'+phase+r'=(0x[0-9a-f]+)$',raw,re.M)==['0x99'],'TCM layout'
    return list(rows.values())

def main():
    if len(sys.argv)!=2 or sys.argv[1] not in ('ab','ba'): raise SystemExit('usage: run.py ab|ba')
    layout=sys.argv[1]; build=ROOT/'build'/layout; manifest=check(layout)
    (ROOT/'results').mkdir(exist_ok=True)
    lock=(ROOT/'results/board.lock').open('a')
    try: fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
    except BlockingIOError: raise SystemExit('another NTT board run is active')
    with socket.socket() as probe:
        try: probe.bind(('127.0.0.1',3351))
        except OSError: raise SystemExit('GDB port 3351 is busy; do not access the board concurrently')
    stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    out=ROOT/'results'/layout/stamp; out.mkdir(parents=True,exist_ok=False)
    env=os.environ.copy(); env.update({
      'FNDSA_LOADER_MODE':'upstream','MLKEM_NATIVE_PINNED_ROOT':str(ENV/'mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f'),
      'OPENOCD':str(ENV/'openocd-4e9b167/bin/openocd'),'OPENOCD_SERIAL':'003C00223335510735383531',
      'OPENOCD_SPEED':'8000','OPENOCD_TRANSPORT':'swd','OPENOCD_SCRIPTS':str(ENV/'openocd-4e9b167/share/openocd/scripts'),
      'OPENOCD_INTERFACE':'interface/stlink.cfg','OPENOCD_TARGET':'target/stm32n6x.cfg','GDB_PORT':'3351','GDB_RUN_TIMEOUT':'2400',
      'SWO_TRACECLK':'100000000','SWO_PIN_FREQ':'1000000','SWO_FORMATTER':'0',
      'GDB':str(BIN/'arm-none-eabi-gdb'),'NM':str(BIN/'arm-none-eabi-nm'),'READELF':str(BIN/'arm-none-eabi-readelf'),
      'PYTHONDONTWRITEBYTECODE':'1'})
    # Reuse only the established board loader, never another candidate's crypto.
    loader=ROOT.parents[1]/'ntt_opt_slothy/measurement/exec_board.py'
    command=[str(ENV/'build-venv/bin/python'),str(loader),'--verbose',str(build/'zephyr/zephyr.elf')]
    meta={'layout':layout,'command':command,'started_utc':stamp,'build_manifest':manifest,
          'runner_sha256':sha(Path(__file__)),'loader_sha256':sha(loader),'status':'running'}
    (out/'run.json').write_text(json.dumps(meta,indent=2)+'\n')
    print('RUN',layout,out,flush=True)
    with (out/'raw.log').open('w') as log:
        proc=subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,env=env)
        try:
            for line in proc.stdout:
                log.write(line); log.flush()
                if re.search(r'COMPARE_|PROGRESS|AUDIT_DONE|CHECK family|^HW |^TIMER|ERROR|Error|FAULT|TCM_|CFSR=|HFSR=|AFSR=',line):
                    print(line,end='',flush=True)
            code=proc.wait()
        except BaseException:
            proc.terminate(); proc.wait(); raise
    meta.update(returncode=code,raw_sha256=sha(out/'raw.log'),ended_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
    try:
        assert code==0,'loader failed'
        rows=parse((out/'raw.log').read_text())
        meta['status']='PASS'; meta['records']=len(rows)
        (out/'measurements.json').write_text(json.dumps(rows,indent=2)+'\n')
        (ROOT/'results'/layout/'validated.json').write_text(json.dumps({'run_dir':str(out),'raw_sha256':meta['raw_sha256'],'elf_sha256':manifest['artifacts']['zephyr/zephyr.elf']},indent=2)+'\n')
    except Exception as exc:
        meta['status']='FAIL'; meta['error']=str(exc)
    (out/'run.json').write_text(json.dumps(meta,indent=2)+'\n')
    print('RESULT',meta['status'],out,meta.get('error',''),flush=True)
    return 0 if meta['status']=='PASS' else 1
if __name__=='__main__': raise SystemExit(main())
