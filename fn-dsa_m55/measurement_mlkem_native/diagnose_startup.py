#!/usr/bin/env python3
"""Stop a pinned upstream test ELF before main; never a performance result."""
import datetime
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent


def startup_script(**kw):
    lines = [
        "set pagination off", "set confirm off",
        f"target remote localhost:{kw['port']}",
        "load", f"hbreak {kw['hardfault_break']}",
        f"thbreak {kw['bootargs_break']}",
        f"jump {kw['reset_handler_jump']}",
        f"if $pc == {kw['bootargs_break'].lstrip('*')}",
        "echo [[STARTUP-PASS]]\\n", "else",
        "echo [[STARTUP-FAULT]]\\n", "end",
        "info registers", "x/8wx $psp", "x/8wx $msp",
        "x/6wx 0xE000ED28", "x/6wx 0xE001E000",
        "monitor reset_config none", "monitor reset run", "quit 0",
    ]
    if os.environ.get('DIAG_RELOCATE_MEMCPY') == '1':
        # This exact, disassembled ELF's memcpy has only internal PC-relative
        # branches and no literal pools/external calls. Copy its bytes, not a
        # recompiled replacement. Diagnostic stops before main in either case.
        at = lines.index('load') + 1
        lines[at:at] = [
            f"dump binary memory {ROOT / 'loader/diagnostic_memcpy.bin'} 0x1001302c 0x100131a4",
            f"restore {ROOT / 'loader/diagnostic_memcpy.bin'} binary 0x34080000",
            "hbreak *0x1001302c", "commands", "silent",
            "echo [[DIAGNOSTIC-MEMCPY-AXISRAM]]\\n",
            "set $pc = 0x34080000", "continue", "end",
        ]
        at = lines.index('x/6wx 0xE000ED28')
        lines[at:at] = ["x/8i *(unsigned int*)($psp+24)"]
    return lines


def main():
    if sys.argv[1] == "--worker":
        sys.path.insert(0, str(Path(os.environ['MLKEM_NATIVE_PINNED_ROOT']) /
                               'test/zephyr/nucleo_n657x0_q'))
        import exec_wrapper
        exec_wrapper.build_run_script = startup_script
        sys.argv = [sys.argv[0], '--verbose', sys.argv[2]]
        return exec_wrapper.main()
    elf = Path(sys.argv[1]).resolve()
    relocate = '--relocate-startup-memcpy' in sys.argv[2:]
    is_fndsa = elf == ROOT / 'build/zephyr/zephyr.elf'
    if not elf.is_relative_to(ROOT / 'env/upstream-build-opt1') and not is_fndsa:
        raise RuntimeError('Only the pinned upstream OPT1 or audited B ELF is allowed')
    if relocate and (not is_fndsa or hashlib.sha256(elf.read_bytes()).hexdigest() !=
                     '44e351780ce356112a9d53d577a5a5b5c2831de1b43d4cec39b0b267763aabdb'):
        raise RuntimeError('Relocation addresses are specific to the audited B ELF')
    meta = json.loads((ROOT / 'runs/pilot-20260910T011210Z/run.json').read_text())
    env = os.environ.copy()
    env.update(meta['environment'])
    env.update(OPENOCD_SERIAL='003C00223335510735383531',
               OPENOCD_TRANSPORT='swd', SWO_FORMATTER='0', GDB_RUN_TIMEOUT='30')
    env['DIAG_RELOCATE_MEMCPY'] = '1' if relocate else '0'
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    label = 'fndsa-memcpy-axi-startup' if relocate else 'upstream-startup'
    dest = ROOT / 'runs' / f'{label}-{stamp}'
    dest.mkdir()
    print(f'DIAGNOSTIC_DIR={dest}', flush=True)
    command = [sys.executable, str(Path(__file__).resolve()), '--worker', str(elf)]
    with (dest / 'raw.log').open('w') as log:
        proc = subprocess.Popen(command, env=env, text=True, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT)
        for line in proc.stdout:
            log.write(line)
            log.flush()
            print(line, end='', flush=True)
        rc = proc.wait()
    raw = (dest / 'raw.log').read_text()
    passed = '[[STARTUP-PASS]]' in raw.splitlines()
    record = dict(elf=str(elf), elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),
                  command=command, probe=env['OPENOCD_SERIAL'],
                  diagnostic_memcpy_in_axisram=relocate,
                  startup_reached_get_bootargs=passed, wrapper_returncode=rc,
                  note='Startup-only diagnostic; main and benchmark not executed. '
                       'Wrapper may reject the intentionally absent done marker.')
    (dest / 'diagnostic.json').write_text(json.dumps(record, indent=2) + '\n')
    print(json.dumps(record, indent=2))
    return 0 if passed else 1


if __name__ == '__main__':
    raise SystemExit(main())
