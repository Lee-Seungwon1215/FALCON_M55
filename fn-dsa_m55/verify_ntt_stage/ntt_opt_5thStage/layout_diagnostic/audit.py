#!/usr/bin/env python3
"""Audit fixed execution addresses, exact relink inputs, and hardware logs."""
import argparse
import importlib.util
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent
STAGE = ROOT.parent
sys.path.insert(0, str(STAGE.parent / 'ntt_opt_4thStage'))
import audit_combinations as shared
spec = importlib.util.spec_from_file_location('layout_runs', ROOT / 'run.py')
runs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runs)
shared.RESULTS = ROOT / 'results'
shared.runs.runner = runs.runner
NAMES = tuple(runs.runner.CANDIDATES)


def audit_layout():
    images = {n: shared.elf32(ROOT / 'build' / n / 'zephyr/zephyr.elf') for n in NAMES}
    fpoly = {f for f in images['A_low'][0] if f.startswith('fndsa_fpoly_')}
    assert len(fpoly) == 13
    mq_shifted = {'fndsa_mqpoly_ntt_to_int', 'fndsa_stage3_mul_probe'}
    records = {}
    for name, (funcs, syms, sections) in images.items():
        build = ROOT / 'build' / name
        record = json.loads((build / 'provenance.json').read_text())
        original_build = Path(record['original_build'])
        original_elf = original_build / 'zephyr/zephyr.elf'
        prior = json.loads((STAGE / 'results' / ('slothy' + name[0]) / 'full_validated.json').read_text())
        assert shared.sha(original_elf) == record['original_elf_sha256'] == prior['elf_sha256']
        assert runs.runner.tree_sha(Path(record['source'])) == prior['source_tree_sha256']
        assert shared.sha(build / 'zephyr/zephyr.elf') == record['elf_sha256']
        assert shared.sha(build / 'zephyr/original_layout_control.elf') == prior['elf_sha256']
        assert shared.sha(build / 'zephyr/linker.cmd') == record['diagnostic_linker_sha256']
        assert all(shared.sha(Path(p)) == h for p, h in record['input_sha256'].items())
        assert shared.sha(original_build / 'zephyr/.config') == record['config_sha256']
        assert shared.sha(original_build / 'compile_commands.json') == record['compile_commands_sha256']
        assert funcs.keys() == shared.elf32(original_elf)[0].keys(), 'changed function set/veneer'
        assert syms['__rom_region_size'] == 118784 and syms['_image_ram_size'] == 225728
        lo, hi = (0x10000400, 0x10001400) if name.endswith('low') else (0x1001c000, 0x1001d000)
        assert all(lo <= (syms[f] & ~1) and (syms[f] & ~1) + len(funcs[f]) <= hi for f in fpoly)
        assert all((0x10000000 <= s['address'] and s['address'] + s['size'] <= 0x10020000)
                   or (0x30000000 <= s['address'] and s['address'] + s['size'] <= 0x30040000)
                   for s in sections if s['flags'] & 2 and s['size'])
        records[name] = dict(elf_sha256=record['elf_sha256'], source_tree_sha256=prior['source_tree_sha256'],
                            original_relink_byte_identical=True, original_objects_unchanged=True,
                            function_addresses={f: hex(syms[f] & ~1) for f in sorted(funcs)},
                            fpoly_addresses={f: hex(syms[f] & ~1) for f in sorted(fpoly)},
                            itcm_span_bytes=118784, dtcm_reserved_bytes=225728)
    for where in ('low', 'high'):
        af, aa, _ = images['A_' + where]
        bf, ba, _ = images['B_' + where]
        assert af.keys() == bf.keys()
        assert {f for f in af if aa[f] != ba[f]} == mq_shifted
        assert all(af[f] == bf[f] for f in fpoly), 'fpoly machine code differs between A and B'
    for variant in ('A', 'B'):
        lf, la, _ = images[variant + '_low']
        hf, ha, _ = images[variant + '_high']
        assert {f for f in lf if la[f] != ha[f]} == fpoly
        assert all(ha[f] - la[f] == 0x1bc00 for f in fpoly)
        assert all(lf[f] == hf[f] for f in ('fndsa_mqpoly_int_to_ntt', 'fndsa_mqpoly_ntt_to_int'))
    base = images['A_low'][1]
    data = {s: a for s, a in base.items() if 0x30000000 <= a <= 0x30040000}
    assert all(all(syms.get(s) == a for s, a in data.items()) for _, syms, _ in images.values())
    configs = [json.loads((ROOT / 'build' / n / 'provenance.json').read_text())['config_sha256'] for n in NAMES]
    assert len(set(configs)) == 1
    return dict(valid=True, fixed_fpoly_function_count=len(fpoly),
                fpoly_AB_addresses_and_bytes_identical=True,
                other_functions_fixed_except=sorted(mq_shifted),
                MQ_NTT_bytes_identical_between_low_high=True,
                all_dtcm_symbol_addresses_identical=True,
                dtcm_symbol_count=len(data), all_configurations_identical=True,
                records=records)


def paired(first, second):
    """Positive delta = second costs more cycles than first (same seed batch)."""
    index = {(x['degree'], x['operation'], x['batch']): x['total'] for x in first['samples']}
    groups = {}
    for x in second['samples']:
        key = (x['degree'], x['operation'], x['batch'])
        label = str(x['degree']) + '_' + ('keygen', 'sign', 'verify')[x['operation']]
        groups.setdefault(label, []).append((x['total'] - index[key]) / 10)
    return {k: dict(second_minus_first_cycles=v, mean_delta=sum(v) / len(v),
                    upper_median_delta=sorted(v)[len(v)//2], min_delta=min(v), max_delta=max(v),
                    second_slower=sum(d > 0 for d in v), second_faster=sum(d < 0 for d in v))
            for k, v in groups.items()}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--require-full', action='store_true')
    args = parser.parse_args()
    layout = audit_layout()
    measurements = {n: shared.board_summary(n) for n in NAMES}
    if args.require_full:
        assert all(measurements.values()), 'four full runs required'
    comparisons = {}
    for a, b in [('A_low', 'B_low'), ('A_high', 'B_high'), ('A_low', 'A_high'), ('B_low', 'B_high')]:
        if measurements[a] and measurements[b]:
            comparisons[a + '_to_' + b] = paired(measurements[a], measurements[b])
    for name, result in measurements.items():
        if not result:
            continue
        raw = Path(result['run_directory'], 'raw.log').read_text()
        values = re.findall(r'^TCM_CONTROL_(START|END)=(0x[0-9a-f]+)$', raw, re.M)
        assert values == [('START', '0x99'), ('END', '0x99')]
        result['tcm_control_start_end'] = values
    output = dict(complete=all(measurements.values()), layout=layout,
                  measurements=measurements, paired_comparisons=comparisons,
                  limitations='Layout-only intervention; no direct wait-state-toggle test; static CT regression, not formal CT/TVLA.')
    (ROOT / 'results').mkdir(exist_ok=True)
    (ROOT / 'results/comparison.json').write_text(json.dumps(output, indent=2) + '\n')
    print('LAYOUT PASS; full measurements', sum(bool(x) for x in measurements.values()), '/ 4')
    for name, result in measurements.items():
        if result:
            print(name, result['upper_median'])
    print(json.dumps(comparisons, indent=2))


if __name__ == '__main__':
    main()
