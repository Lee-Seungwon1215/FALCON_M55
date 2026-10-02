#!/usr/bin/env python3
"""Provenance, executable-layout and strict on-board audit for this source tree."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shlex
import struct
import subprocess
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent
SOURCE = ROOT.parent
BASE = SOURCE.parent
STAGE = BASE / 'ntt_opt_5thStage'
CHOSEN = STAGE / 'slothyA'
CHOSEN_BUILD = STAGE / 'build/slothyA'
OUT = ROOT / 'results'
sys.path.insert(0, str(BASE / 'ntt_opt_4thStage'))
import audit_combinations as shared
spec = importlib.util.spec_from_file_location('integrated_slothy_measurement', ROOT / 'run.py')
current = importlib.util.module_from_spec(spec)
spec.loader.exec_module(current)


def allocated_contents(path):
    data = path.read_bytes()
    assert data[:6] == b'\x7fELF\x01\x01'
    header = struct.unpack_from('<16sHHIIIIIHHHHHH', data)
    sections = [struct.unpack_from('<IIIIIIIIII', data, header[6] + i * header[11])
                for i in range(header[12])]
    strings = sections[header[13]]
    names = data[strings[4]:strings[4] + strings[5]]
    result = {}
    for s in sections:
        if not s[2] & 2 or not s[5]:
            continue
        name = names[s[0]:names.index(0, s[0])].decode()
        payload = b'' if s[1] == 8 else data[s[4]:s[4] + s[5]]
        result[name] = (s[1], s[2], s[3], s[5], payload)
    return result


def sources(path):
    return {p.name: shared.sha(p) for p in path.iterdir() if p.suffix in ('.c', '.h', '.s')}


def commands(build, source):
    entries = json.loads((build / 'compile_commands.json').read_text())
    result = {}
    for e in entries:
        if Path(e['file']).parent != source:
            continue
        # The new build is nested under SOURCE, unlike the historical A build.
        result[Path(e['file']).name] = e['command'].replace(str(build), 'BUILD').replace(str(source), 'SOURCE')
    return result


def static_audit():
    OUT.mkdir(parents=True, exist_ok=True)
    before, chosen, integrated = sources(BASE / 'ntt_opt'), sources(CHOSEN), sources(SOURCE)
    assert integrated == chosen and len(integrated) == 30
    assert [n for n in before if before[n] != integrated[n]] == ['mq_cm55.s']
    for name in ('Makefile', 'Makefile.cm4', 'Makefile.win32', 'profiling/Makefile'):
        assert (SOURCE / name).read_bytes() == (BASE / 'ntt_opt' / name).read_bytes()
    asm = (SOURCE / 'mq_cm55.s').read_text()
    assert not (SOURCE / 'mq_cm55.s').is_symlink()
    assert not re.search(r'^\s*(?:\.include|#include)', asm, re.M)
    approved = json.loads((STAGE / 'results/slothyA/full_validated.json').read_text())
    tree_hash = current.runner.tree_sha(SOURCE)
    assert tree_hash == approved['source_tree_sha256']
    elf, reference = current.BUILD / 'zephyr/zephyr.elf', CHOSEN_BUILD / 'zephyr/zephyr.elf'
    assert shared.sha(reference) == approved['elf_sha256']
    left, right = allocated_contents(reference), allocated_contents(elf)
    assert left == right, 'loaded instructions, data, or layout differs from selected A'
    nf, ns, _ = shared.elf32(elf)
    rf, rs, _ = shared.elf32(reference)
    assert nf == rf and all(ns[f] == rs[f] for f in nf)
    assert commands(current.BUILD, SOURCE) == commands(CHOSEN_BUILD, CHOSEN)
    entries = json.loads((current.BUILD / 'compile_commands.json').read_text())
    source_entries = [e for e in entries if Path(e['file']).parent == SOURCE]
    assert len(source_entries) == 23, 'not all crypto sources are from integrated tree'
    assert all(str(CHOSEN) not in e['command'] for e in entries)
    assert any(Path(e['file']) == SOURCE / 'mq_cm55.s' for e in source_entries)
    assert all([a for a in shlex.split(e['command']) if re.fullmatch(r'-O(?:[0-3gsz]|fast)', a)][-1] == '-O3'
               for e in source_entries)
    config = current.BUILD / 'zephyr/.config'
    assert config.read_bytes() == (CHOSEN_BUILD / 'zephyr/.config').read_bytes()
    assert (current.BUILD / 'zephyr/linker.cmd').read_bytes() == (CHOSEN_BUILD / 'zephyr/linker.cmd').read_bytes()
    previous = json.loads((STAGE / 'results/slothyA/static_audit.json').read_text())
    assert previous['valid'] and previous['assembly_sha256'] == integrated['mq_cm55.s']
    model = json.loads((STAGE / 'tooling/logs/instruction_model.json').read_text())
    assert model['status'] == 'PASS' and model['cases'] == 816
    assert model['manifest_sha256'] == shared.sha(STAGE / 'tooling/logs/manifest.json')
    old_code, new_code = shared.source_instructions((BASE / 'ntt_opt/mq_cm55.s').read_text()), shared.source_instructions(asm)
    normalize = lambda b: [re.sub(r'^(\w+)\.[nw] ', r'\1 ', s) for s in b]
    assert shared.stack(old_code) == shared.stack(new_code)
    assert normalize(shared.control(old_code)) == normalize(shared.control(new_code))
    entry = next(e for e in source_entries if Path(e['file']).name == 'mq_cm55.s')
    objdump = Path(shlex.split(entry['command'])[0]).with_name('arm-none-eabi-objdump')
    (OUT / 'firmware.dis').write_text(subprocess.check_output([str(objdump), '-d', str(elf)], text=True))
    tracked = {str(p): shared.sha(p) for p in [ROOT / 'build.sh', ROOT / 'run.py', ROOT / 'exec_board.py',
        current.runner.MEAS / 'app/benchmark.c', current.runner.MEAS / 'app/CMakeLists.txt',
        current.runner.MEAS / 'app/dtcm_startup.s', current.runner.MEAS / 'app/generate_dtcm_linker.py',
        current.runner.MEAS / 'host/pilot.log', current.runner.MEAS / 'host/full.log']}
    report = dict(valid=True, source_directory=str(SOURCE), build_directory=str(current.BUILD),
        source_tree_sha256=tree_hash, assembly_sha256=integrated['mq_cm55.s'],
        elf_sha256=shared.sha(elf), selected_elf_sha256=shared.sha(reference),
        all_30_crypto_sources_equal_A=True, all_23_compiled_crypto_inputs_from_new_path=True,
        changed_crypto_files_vs_before=['mq_cm55.s'], allocated_sections_byte_identical_to_A=True,
        function_bytes_and_addresses_identical_to_A=True, compiler_options_equal_A=True,
        zephyr_config_equal_A=True, linker_script_equal_A=True, zephyr_config_sha256=shared.sha(config),
        compiler_commands_sha256=shared.sha(current.BUILD / 'compile_commands.json'),
        prior_instruction_model_cases=816, stack_and_branch_structure_equal=True,
        itcm_code_bytes=ns['__rom_region_size'], dtcm_reserved_bytes=ns['_image_ram_size'],
        function_addresses={n: hex(ns[n] & ~1) for n in sorted(nf)},
        sections=[dict(name=n, address=hex(s[2]), bytes=s[3], payload_sha256=hashlib.sha256(s[4]).hexdigest()) for n, s in right.items()],
        supporting_file_sha256=tracked,
        limitations='Static CT regression and identical machine code; not formal CT proof, dudect or TVLA. Hardware KAT means project fixed-input regression, not certification.')
    (OUT / 'static_audit.json').write_text(json.dumps(report, indent=2) + '\n')
    print('STATIC PASS: all new-path sources, compiler options, allocated ELF bytes and addresses match A.', flush=True)
    print('ELF', report['elf_sha256'], 'ITCM', report['itcm_code_bytes'], 'DTCM', report['dtcm_reserved_bytes'], flush=True)
    return report


def board(name, results, source, build):
    shared.RESULTS = results
    shared.runs.runner = current.runner
    current.runner.CANDIDATES[name] = (source, build)
    return shared.board_summary(name)


def paired(old, new):
    baseline = {(s['degree'], s['operation'], s['batch']): s['total'] for s in old['samples']}
    deltas = {}
    for s in new['samples']:
        key = (s['degree'], s['operation'], s['batch'])
        label = str(s['degree']) + '_' + ('keygen', 'sign', 'verify')[s['operation']]
        deltas.setdefault(label, []).append((s['total'] - baseline[key]) / 10)
    return {k: dict(new_minus_reference_cycles=v, mean_delta=sum(v)/len(v),
                    upper_median_delta=sorted(v)[len(v)//2], min_delta=min(v), max_delta=max(v)) for k,v in deltas.items()}


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--require-full', action='store_true')
    args = p.parse_args()
    static = static_audit()
    if not args.require_full:
        return
    measured = board('integrated', OUT, SOURCE, current.BUILD)
    assert measured is not None
    raw = Path(measured['run_directory'], 'raw.log').read_text()
    assert re.findall(r'^TCM_CONTROL_(START|END)=(0x[0-9a-f]+)$', raw, re.M) == [('START', '0x99'), ('END', '0x99')]
    # Historical logs predate the extra control-register capture. Their original
    # validators are used unchanged; new runs must pass the stricter wrapper.
    current.runner.validate_measurements = current.original_validate
    chosen = board('slothyA', STAGE / 'results', CHOSEN, CHOSEN_BUILD)
    before = board('ref', STAGE / 'results', STAGE / 'ref', STAGE / 'build/ref')
    assert chosen is not None and before is not None
    assert sources(BASE / 'ntt_opt') == sources(STAGE / 'ref')
    result = dict(complete=True, static=static, integrated=measured, selected_A=chosen,
        before_slothy=before, historical_comparison_not_same_session=True,
        tcm_control_start_end=['0x99', '0x99'],
        integrated_minus_A_cycles={k: v-chosen['upper_median'][k] for k,v in measured['upper_median'].items()},
        before_to_integrated_reduction_percent={k:100*(v-measured['upper_median'][k])/v for k,v in before['upper_median'].items()},
        paired_vs_A=paired(chosen, measured), paired_vs_before=paired(before, measured))
    (OUT / 'comparison.json').write_text(json.dumps(result, indent=2) + '\n')
    print('FULL PASS:', measured['upper_median'])
    print('New path minus selected A:', result['integrated_minus_A_cycles'])


if __name__ == '__main__':
    main()
