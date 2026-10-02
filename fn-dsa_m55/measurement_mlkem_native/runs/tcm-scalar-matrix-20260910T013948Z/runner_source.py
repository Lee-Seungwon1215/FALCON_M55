#!/usr/bin/env python3
"""M55-only reset-isolated scalar access matrix; diagnostic, never benchmark."""
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
    dest = ROOT / 'runs' / f'tcm-scalar-matrix-{stamp}'
    dest.mkdir()
    (dest / 'probe_source.s').write_bytes((HERE / 'tcm_probe.s').read_bytes())
    (dest / 'runner_source.py').write_bytes(Path(__file__).read_bytes())
    branch = '--branch' in sys.argv[1:]
    scalarcopy = '--scalar-copy' in sys.argv[1:]
    memcpy = '--memcpy' in sys.argv[1:] or scalarcopy
    data_dtcm = '--data-dtcm' in sys.argv[1:]
    compiler = Path(os.environ['GNUARMEMB_TOOLCHAIN_PATH']) / 'bin'
    elf = dest / 'tcm_probe.elf'
    subprocess.run([str(compiler / 'arm-none-eabi-gcc'), '-mcpu=cortex-m55',
                    '-mthumb', '-nostdlib', '-x', 'assembler-with-cpp',
                    *(['-DPROBE_BRANCH=1'] if branch else []), '-Wl,-Ttext=0x34080000',
                    '-Wl,-e,probe_init', str(HERE / 'tcm_probe.s'), '-o', str(elf)], check=True)
    nm = subprocess.check_output([str(compiler / 'arm-none-eabi-nm'), '-n', str(elf)], text=True)
    symbols = {p[2]: int(p[0], 16) for line in nm.splitlines()
               if len(p := line.split()) == 3}
    (dest / 'disassembly.txt').write_text(subprocess.check_output(
        [str(compiler / 'arm-none-eabi-objdump'), '-d', str(elf)], text=True))
    meta = json.loads((ROOT / 'runs/pilot-20260910T011210Z/run.json').read_text())
    os.environ.update(meta['environment'])
    os.environ.update(OPENOCD_SERIAL='003C00223335510735383531', OPENOCD_TRANSPORT='swd')
    # First include same-window/cross-window scalar reads, with AXISRAM and
    # DTCM controls. Fresh reset and full TCM initialization before every case.
    codes = [symbols['probe_body']] + [0x10001000 + i*0x10000 for i in range(4)]
    data = [0x34080800] + [0x10000800 + i*0x10000 for i in range(4)] + [
        0x30000800, 0x30020800]
    cases = [(c, d) for c in codes for d in data]
    if memcpy:
        cases = [(c, 0x30008000 if data_dtcm else 0x100243b8) for c in
                 (0x34081000, 0x10001000, 0x1001302c, 0x10021000, 0x10031000)]
        crypto_elf = ROOT / 'build/zephyr/zephyr.elf'
        if hashlib.sha256(crypto_elf.read_bytes()).hexdigest() != \
                '44e351780ce356112a9d53d577a5a5b5c2831de1b43d4cec39b0b267763aabdb':
            raise RuntimeError('memcpy addresses require the audited unchanged ELF')
    scripts = []
    for index, (code, source) in enumerate(cases):
        target = ((source - 0x800 + 0x1008) if 0x10000000 <= source < 0x10040000
                  else (code + 8))
        lines = ['set pagination off', 'set confirm off', 'target remote localhost:3349',
                  'load', 'set $control=0', 'set $basepri=0',
                  'set $faultmask=0', 'set $msplim_s=0', 'set $psplim_s=0',
                  'set $msp=0x340bf000', 'set $psp=0x340be000',
                  'x/2wx 0x56028020', 'x/wx 0x56028048',
                  'x/wx 0xe000ed14',
                  'set {unsigned int}0x56028a54=0x1000', 'x/8wx 0x52023500',
                  f"hbreak *0x{symbols['probe_ready']:x}",
                  f"hbreak *0x{symbols['probe_fault']:x}",
                  f"hbreak *0x{symbols['probe_done']:x}",
                  f"hbreak *0x{symbols['probe_mismatch']:x}",
                  f"jump *0x{symbols['probe_init'] | 1:x}",
                  f"if $pc != 0x{symbols['probe_ready']:x}",
                  'echo [[PROBE-INIT-FAIL]]\\n', 'info registers',
                  'x/8wx $msp', 'x/6wx 0xe000ed28', 'x/6wx 0xe001e000',
                  'monitor reset_config none', 'monitor reset run', 'quit 2', 'end',
                  f'set $r4=0x{code|1:x}', f'set $r1=0x{source:x}',
                  f'set $r7=0x{target|1:x}', 'set $r5=10000',
                  f"jump *0x{symbols['probe_call'] | 1:x}",
                  f'printf "CASE id={index} code=0x{code:x} data=0x{source:x} pc=0x%x r0=0x%x left=%u cfsr=0x%x hfsr=0x%x afsr=0x%x bfar=0x%x\\n", $pc,$r0,$r5,*(unsigned*)0xe000ed28,*(unsigned*)0xe000ed2c,*(unsigned*)0xe000ed3c,*(unsigned*)0xe000ed38',
                  'x/8wx $msp', 'x/8wx 0xe001e120', 'x/6wx 0xe001e000']
        if memcpy:
            copy_start = symbols['probe_scalarcopy'] if scalarcopy else 0x1001302c
            copy_end = symbols['probe_scalarcopy_end'] if scalarcopy else 0x100131a4
            at = lines.index(f'set $r4=0x{code|1:x}')
            lines[at:at] = [f'load {crypto_elf}',
                *([f'dump binary memory {dest / "input.bin"} 0x100243b8 0x10024444',
                   f'restore {dest / "input.bin"} binary 0x30008000'] if data_dtcm else []),
                f'dump binary memory {dest / "memcpy.bin"} 0x{copy_start:x} 0x{copy_end:x}',
                *([f'restore {dest / "memcpy.bin"} binary 0x{code:x}']
                  if scalarcopy or code != 0x1001302c else []),
                'set {unsigned int}0xe000ed88=0x00500000', 'set $fpscr=0x40000',
                'set $r0=0x30000000', 'set $r2=140']
            at = lines.index(f"jump *0x{symbols['probe_call'] | 1:x}")
            lines[at] = f"jump *0x{symbols['probe_memcpy_call'] | 1:x}"
            lines += ['x/36wx 0x30000000', 'x/36wx 0x100243b8',
                      f'dump binary memory {dest / f"copied-{index}.bin"} 0x30000000 0x3000008c']
        lines += ['monitor reset_config none', 'monitor reset run', 'detach', 'quit 0']
        script = dest / f'probe-{index:02d}.gdb'
        script.write_text('\n'.join(lines) + '\n')
        scripts.append(script)
    print(f'DIAGNOSTIC_DIR={dest}', flush=True)
    rc = run_openocd_config(5)
    if rc:
        raise RuntimeError(f'FLEXMEM setup failed: {rc}')
    cmd = runtime_gdbserver_cmd(openocd=os.environ['OPENOCD'], port=3349,
                               serial=os.environ['OPENOCD_SERIAL'])
    with (dest / 'openocd.log').open('w') as server_log:
        for index, script in enumerate(scripts):
            server = subprocess.Popen(cmd, stdout=server_log, stderr=subprocess.STDOUT)
            try:
                time.sleep(0.8)
                with (dest / 'raw.log').open('a') as log:
                    proc = subprocess.Popen([str(compiler / 'arm-none-eabi-gdb'), '--batch',
                                             '-x', str(script), str(elf)], stdout=log,
                                            stderr=subprocess.STDOUT)
                    try:
                        rc = proc.wait(timeout=15)
                    except subprocess.TimeoutExpired:
                        proc.terminate()
                        proc.wait(timeout=5)
                        raise
            finally:
                server.terminate()
                server.wait(timeout=5)
            print(f'CASE_FINISHED={index} gdb_rc={rc}', flush=True)
            if rc:
                break
    raw = (dest / 'raw.log').read_text()
    expected_bytes = None
    if memcpy:
        from elftools.elf.elffile import ELFFile
        with crypto_elf.open('rb') as f:
            e = ELFFile(f)
            expected_bytes = b''.join(e.get_section_by_name(n).data() for n in
                                      ('datas', 'device_states', 'k_mutex_area'))
    records = []
    for line in raw.splitlines():
        if line.startswith('CASE '):
            fields = {k: int(v, 0) for k, v in re.findall(r'(\w+)=(0x[\da-f]+|\d+)', line)}
            fields['pass'] = (fields['pc'] == symbols['probe_done'] and
                              (memcpy or fields['left'] == 0) and
                              fields['r0'] == (0x30000000 if memcpy else fields['data']) and fields['cfsr'] == 0
                              and fields['afsr'] == 0)
            if memcpy:
                copied = dest / f"copied-{fields['id']}.bin"
                fields['copied_bytes_match_elf'] = copied.exists() and copied.read_bytes() == expected_bytes
                fields['pass'] = fields['pass'] and fields['copied_bytes_match_elf']
            records.append(fields)
            print(line + f" pass={fields['pass']}")
    result = dict(returncode=rc, expected_cases=len(cases), observed_cases=len(records),
                  data_pattern='source address', branch_to_data_window=branch,
                  actual_zephyr_memcpy=memcpy and not scalarcopy,
                  scalar_copy_control=scalarcopy,
                  diagnostic_input_in_dtcm=data_dtcm,
                  cases=records, symbols=symbols, iterations=1 if memcpy else 10000,
                  crypto_elf_sha256=(hashlib.sha256(crypto_elf.read_bytes()).hexdigest()
                                     if memcpy else None),
                  source_sha256=hashlib.sha256((HERE / 'tcm_probe.s').read_bytes()).hexdigest(),
                  probe=os.environ['OPENOCD_SERIAL'], no_crypto_no_benchmark=True,
                  elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest())
    (dest / 'results.json').write_text(json.dumps(result, indent=2) + '\n')
    print(f'COMPLETE={rc == 0 and len(records) == len(cases)}')
    if rc or len(records) != len(cases):
        print(raw[-5000:])
    return rc


if __name__ == '__main__':
    raise SystemExit(main())
