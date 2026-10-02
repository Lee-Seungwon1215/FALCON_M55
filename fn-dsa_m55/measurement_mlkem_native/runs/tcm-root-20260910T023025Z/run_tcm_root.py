#!/usr/bin/env python3
"""M55 root-cause controls, CPU-written TCM kernels/data; no benchmark edits."""
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(Path(os.environ['MLKEM_NATIVE_PINNED_ROOT']) /
                       'test/zephyr/nucleo_n657x0_q'))
from nucleo_host.flexmem_configure import run_openocd_config
from nucleo_host.openocd_tools import runtime_gdbserver_cmd

def main():
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    dest = ROOT / 'runs' / f'tcm-root-{stamp}'
    dest.mkdir()
    compiler = Path(os.environ['GNUARMEMB_TOOLCHAIN_PATH']) / 'bin'
    for p in [HERE / 'tcm_probe.s', HERE / 'tcm_root_kernels.s', Path(__file__)]:
        (dest / p.name).write_bytes(p.read_bytes())
    elf = dest / 'root.elf'
    subprocess.run([str(compiler / 'arm-none-eabi-gcc'), '-mcpu=cortex-m55',
        '-mthumb', '-nostdlib', '-Wl,-Ttext=0x34080000', '-Wl,-e,probe_init',
        str(HERE/'tcm_probe.s'), str(HERE/'tcm_root_kernels.s'), '-o', str(elf)], check=True)
    nm = subprocess.check_output([str(compiler/'arm-none-eabi-nm'), '-n', str(elf)], text=True)
    sym = {p[2]: int(p[0],16) for l in nm.splitlines() if len(p:=l.split())==3}
    (dest/'disassembly.txt').write_text(subprocess.check_output(
        [str(compiler/'arm-none-eabi-objdump'), '-d', str(elf)], text=True))
    os.environ.update(json.loads((ROOT/'runs/pilot-20260910T011210Z/run.json').read_text())['environment'])
    os.environ.update(OPENOCD_SERIAL='003C00223335510735383531', OPENOCD_TRANSPORT='swd')
    kernels = ['root_ldm_copy','root_ldm_sum','root_ldr_sum','root_ldrd_sum','root_ldr_barrier_sum']
    cases = []
    for name in kernels:
        for code, data in [(0x34081000,0x10024000),(0x10001000,0x10024000),
                           (0x1001302c,0x10024000),(0x1002302c,0x10024000),
                           (0x1001302c,0x30008000)]:
            cases.append(dict(kernel=name, code=code, data=data, length=128))
    print(f'RUN_DIR={dest}', flush=True)
    if run_openocd_config(5):
        raise RuntimeError('M55 FLEXMEM configuration failed')
    cmd = runtime_gdbserver_cmd(openocd=os.environ['OPENOCD'],port=3349,
                               serial=os.environ['OPENOCD_SERIAL'])
    results=[]
    for i,c in enumerate(cases):
        script=[ 'set pagination off','set confirm off','target remote localhost:3349',
            'load','set $control=0','set $basepri=0','set $faultmask=0',
            'set $msplim_s=0','set $psplim_s=0','set $msp=0x340bf000','set $psp=0x340be000',
            'set {unsigned int}0x56028a78=1',
            'set {unsigned int}0x56028a54=0x1000',
            'echo SYSCFG_TCMCR_RESETCR:\\n','x/wx 0x56008008','x/wx 0x56008018',
            'echo RAMCFG_FLEX:\\n','x/8wx 0x52023500',
            'echo CLOCK_CACHE_BOOT:\\n','x/2wx 0x56028020','x/wx 0x56028048','x/wx 0xe000ed14',
            'echo TEBR_PRE:\\n','x/4wx 0xe001e120',
            'set {unsigned int}0xe001e120=0','set {unsigned int}0xe001e128=0',
            f"hbreak *0x{sym['probe_ready']:x}",f"hbreak *0x{sym['root_ready']:x}",
            f"hbreak *0x{sym['probe_fault']:x}",f"hbreak *0x{sym['probe_done']:x}",
            f"jump *0x{sym['probe_init']|1:x}",
            f"if $pc != 0x{sym['probe_ready']:x}", 'echo INIT_FAILED\\n',
            'monitor reset_config none','monitor reset run','quit 2','end',
            f"set $r4=0x{c['code']:x}",f"set $r6=0x{sym[c['kernel']]:x}",
            f"set $r7={sym[c['kernel']+'_end']-sym[c['kernel']]}",f"set $r8=0x{c['data']:x}",
            f"jump *0x{sym['root_prepare']|1:x}",
            f"if $pc != 0x{sym['root_ready']:x}", 'echo PREP_FAILED\\n',
            'monitor reset_config none','monitor reset run','quit 3','end',
            f"dump binary memory {dest/f'code-{i}.bin'} 0x{c['code']:x} 0x{c['code']+sym[c['kernel']+'_end']-sym[c['kernel']]:x}",
            f"dump binary memory {dest/f'input-{i}.bin'} 0x{c['data']:x} 0x{c['data']+128:x}",
            'echo PRE_RUN_ECC:\\n','x/6wx 0xe001e000','x/4wx 0xe001e120',
            'set $r0=0x34082000',f"set $r1=0x{c['data']:x}",f"set $r2={c['length']}",
            f"set $r4=0x{c['code']|1:x}",f"jump *0x{sym['root_call']|1:x}",
            f'printf "CASE id={i} pc=0x%x r0=0x%x cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\\n", $pc,$r0,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38',
            'info registers','x/8wx $msp','x/4wx 0xe001e120',
            f"dump binary memory {dest/f'output-{i}.bin'} 0x34082000 0x34082080",
            'monitor reset_config none','monitor reset run','detach','quit 0']
        gdbscript=dest/f'case-{i}.gdb'; gdbscript.write_text('\n'.join(script)+'\n')
        with (dest/f'openocd-{i}.log').open('w') as slog, (dest/f'case-{i}.log').open('w') as log:
            server=subprocess.Popen(cmd,stdout=slog,stderr=subprocess.STDOUT)
            try:
                time.sleep(0.8)
                proc=subprocess.Popen([str(compiler/'arm-none-eabi-gdb'),'--batch','-x',str(gdbscript),str(elf)],stdout=log,stderr=subprocess.STDOUT)
                try: rc=proc.wait(timeout=20)
                except subprocess.TimeoutExpired:
                    proc.send_signal(2)
                    try: proc.wait(timeout=5)
                    except subprocess.TimeoutExpired: proc.terminate(); proc.wait(timeout=5)
                    raise
            finally:
                server.terminate(); server.wait(timeout=5)
        raw=(dest/f'case-{i}.log').read_text()
        match=re.search(r'^CASE (.+)$',raw,re.M)
        if rc or not match: raise RuntimeError(f'case {i} harness failed: {raw[-2000:]}')
        fields={k:int(v,0) for k,v in re.findall(r'(\w+)=(0x[\da-f]+|\d+)',match[1])}
        expected=b''.join(((c['data']+j)^0x5a5aa5a5).to_bytes(4,'little') for j in range(0,128,4))
        assert (dest/f'input-{i}.bin').read_bytes()==expected
        checksum=sum(int.from_bytes(expected[j:j+4],'little') for j in range(0,128,4))&0xffffffff
        correct=((dest/f'output-{i}.bin').read_bytes()==expected if c['kernel']=='root_ldm_copy' else fields['r0']==checksum)
        passed=fields['pc']==sym['probe_done'] and not any(fields[k] for k in ['cfsr','hfsr','afsr']) and correct
        results.append(dict(**c,**fields,passed=passed,correct_output=correct))
        print(json.dumps(results[-1]),flush=True)
        (dest/'results.json').write_text(json.dumps(dict(cases=results,symbols=sym,probe=os.environ['OPENOCD_SERIAL'],complete=len(results)==len(cases)),indent=2)+'\n')
    return 0
if __name__=='__main__': raise SystemExit(main())
