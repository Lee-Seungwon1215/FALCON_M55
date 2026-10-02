#!/usr/bin/env python3
"""Relink the exact previously measured objects; never rebuild or edit sources.

Only linker text placement and output paths change. A control relink must first
reproduce the original ELF byte for byte. Original build directories are inputs.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shlex
import subprocess

ROOT = Path(__file__).resolve().parent
STAGE = ROOT.parent
MEAS = STAGE.parent / "measurement_mlkem_native"
NAMES = ("A_low", "B_low", "A_high", "B_high")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def layout(original, where):
    old = ''' __text_region_start = .;
 *(.text)
 *(".text.*")
 *(.gnu.linkonce.t.*)
 *(.glue_7t) *(.glue_7) *(.vfp11_veneer) *(.v4_bx)
 . = ALIGN(4);'''
    select = '*sign_fpoly.c.obj(.text .text.* .gnu.linkonce.t.*)'
    new = f''' __text_region_start = .;
 /* Fixed slots: all addresses below are absolute instruction addresses. */
 . = 0x10000400 - 0x10000330;
 __diag_fpoly_low_start = .;
 {select if where == 'low' else ''}
 __diag_fpoly_low_used_end = .;
 . = 0x10001400 - 0x10000330;
 __diag_mq_start = .;
 *mq_cm55.s.obj(.text .text.* .gnu.linkonce.t.*)
 __diag_mq_used_end = .;
 . = 0x10005400 - 0x10000330;
 __diag_common_start = .;
 *(EXCLUDE_FILE (*mq_cm55.s.obj *sign_fpoly.c.obj) .text)
 *(EXCLUDE_FILE (*mq_cm55.s.obj *sign_fpoly.c.obj) .text.*)
 *(EXCLUDE_FILE (*mq_cm55.s.obj *sign_fpoly.c.obj) .gnu.linkonce.t.*)
 *(.glue_7t) *(.glue_7) *(.vfp11_veneer) *(.v4_bx)
 __diag_common_used_end = .;
 . = 0x1001c000 - 0x10000330;
 __diag_fpoly_high_start = .;
 {select if where == 'high' else ''}
 __diag_fpoly_high_used_end = .;
 . = 0x1001d000 - 0x10000330;'''
    assert original.count(old) == 1
    result = original.replace(old, new)
    result += '''
ASSERT(ADDR(text) == 0x10000330, "unexpected vector/text alignment")
ASSERT(__diag_fpoly_low_used_end <= 0x10001400, "low fpoly slot overflow")
ASSERT(__diag_mq_used_end <= 0x10005400, "mq slot overflow")
ASSERT(__diag_common_used_end <= 0x1001c000, "common slot overflow")
ASSERT(__diag_fpoly_high_used_end <= 0x1001d000, "high fpoly slot overflow")
'''
    return result


def build(name):
    variant, where = name.split('_')
    source = STAGE / ('slothy' + variant)
    original_build = STAGE / 'build' / source.name
    out = ROOT / 'build' / name / 'zephyr'
    out.mkdir(parents=True, exist_ok=True)
    ninja = MEAS / 'env/build-venv/bin/ninja'
    commands = subprocess.check_output(
        [str(ninja), '-C', str(original_build), '-t', 'commands', 'zephyr/zephyr.elf'],
        text=True).splitlines()
    final = commands[-1].split(' && ')
    assert final[0] == ':'
    command = shlex.split(final[1])
    assert Path(command[0]).name == 'arm-none-eabi-gcc'
    assert command[command.index('-o') + 1] == 'zephyr/zephyr.elf'
    assert command[command.index('-T') + 1] == 'zephyr/linker.cmd'
    # Record every explicit object/archive and the compiler runtime archive.
    inputs = {str(original_build / x): sha(original_build / x)
              for x in command if x.endswith(('.obj', '.a'))}
    libgcc = subprocess.check_output([command[0], '-mcpu=cortex-m55',
        '-mthumb', '-mfpu=fpv5-sp-d16', '-mfloat-abi=hard', '-print-libgcc-file-name'],
        text=True).strip()
    inputs[libgcc] = sha(Path(libgcc))
    original_elf = original_build / 'zephyr/zephyr.elf'
    original_hash = sha(original_elf)
    original_linker = original_build / 'zephyr/linker.cmd'

    def relink(linker, stem):
        args = command.copy()
        args[args.index('-o') + 1] = str(out / (stem + '.elf'))
        args[args.index('-T') + 1] = str(linker)
        args = [('-Wl,-Map,' + str(out / (stem + '.map')))
                if x.startswith('-Wl,-Map,') else x for x in args]
        result = subprocess.run(args, cwd=original_build, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        (out / (stem + '.link.log')).write_text(result.stdout)
        if result.returncode:
            raise RuntimeError(result.stdout)
        return args

    control_command = relink(original_linker, 'original_layout_control')
    assert sha(out / 'original_layout_control.elf') == original_hash, 'control relink differs'
    diagnostic_linker = out / 'linker.cmd'
    diagnostic_linker.write_text(layout(original_linker.read_text(), where))
    diagnostic_command = relink(diagnostic_linker, 'zephyr')
    assert sha(original_elf) == original_hash
    assert all(sha(Path(p)) == h for p, h in inputs.items())
    record = dict(candidate=name, source=str(source), original_build=str(original_build),
                  input_sha256=inputs, compiler_sha256=sha(Path(command[0])),
                  original_elf_sha256=original_hash, control_elf_identical=True,
                  original_linker_sha256=sha(original_linker),
                  diagnostic_linker_sha256=sha(diagnostic_linker),
                  elf_sha256=sha(out / 'zephyr.elf'),
                  config_sha256=sha(original_build / 'zephyr/.config'),
                  compile_commands_sha256=sha(original_build / 'compile_commands.json'),
                  original_command=command, control_command=control_command,
                  diagnostic_command=diagnostic_command)
    (out.parent / 'provenance.json').write_text(json.dumps(record, indent=2) + '\n')
    print(name, 'control relink byte-identical; diagnostic link PASS', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('candidate', choices=(*NAMES, 'all'))
    args = parser.parse_args()
    for candidate in NAMES if args.candidate == 'all' else (args.candidate,):
        build(candidate)
