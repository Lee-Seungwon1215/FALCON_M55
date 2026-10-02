#!/usr/bin/env python3
"""Validate and summarize the exclusive per-function signing profile."""
import hashlib
import json
from pathlib import Path
import re
import sys

detail_dir, control_dir = map(Path, sys.argv[1:])

def load(directory):
    manifest = json.loads((directory / 'manifest.json').read_text())
    assert manifest['valid_measurement'] and not manifest['errors']
    raw = (directory / 'raw.log').read_bytes()
    assert hashlib.sha256(raw).hexdigest() == manifest['raw_sha256']
    return re.sub(r'Info : [^\n]*\n', '', raw.decode())

detail = load(detail_dir)
control = load(control_dir)
names = {
    'sg_fft': 'fpoly_FFT', 'sg_ifft': 'fpoly_iFFT', 'sg_ldl': 'fpoly_LDL_fft',
    'sg_split': 'fpoly_split_fft', 'sg_split_selfadj': 'fpoly_split_selfadj_fft',
    'sg_merge': 'fpoly_merge_fft', 'sg_mul': 'fpoly_mul_fft',
    'sg_add': 'fpoly_add', 'sg_sub': 'fpoly_sub', 'sg_deepest': 'ffsamp_fft_deepest',
}
summary = {'detail_run': str(detail_dir), 'control_run': str(control_dir), 'degrees': {}}
for n, fingerprint in ((512, '9895079d'), (1024, 'a020dd02')):
    fp_line = f'PROFILE_FINGERPRINT degree={n} fnv1a={fingerprint}'
    assert fp_line in detail and fp_line in control
    def total(text):
        match = re.search(rf'^PROFILE_TOTAL degree={n} operation=sign calls=100 total=(\d+) ', text, re.M)
        assert match
        return int(match[1])
    ticks, control_ticks = total(detail), total(control)
    cats = {m[1]: {'cycles': int(m[2]), 'calls': int(m[3])} for m in re.finditer(
        rf'^PROFILE_CATEGORY degree={n} operation=sign category=(\w+) cycles=(\d+) entries=(\d+)$', detail, re.M)}
    assert len(cats) == 32 and sum(row['cycles'] for row in cats.values()) == ticks
    nodes = n // 2 - 1
    expected = {'sg_fft': 5, 'sg_ifft': 2, 'sg_ldl': nodes, 'sg_split': 2*nodes,
        'sg_split_selfadj': 2*nodes, 'sg_merge': 2*nodes, 'sg_mul': nodes+2,
        'sg_add': nodes, 'sg_sub': nodes, 'sg_deepest': n//2, 'sg_gaussian_berexp': 2*n,
        'sg_gram': 1, 'sg_target': 1, 'sg_ldl_ffsampling': 1}
    for cat, count in expected.items():
        assert cats[cat]['calls'] == count * 100, (n, cat, cats[cat], count)
    selected = sum(cats[cat]['cycles'] for cat in names)
    rows = []
    for cat, name in names.items():
        row = cats[cat]
        rows.append(dict(function=name, cycles_per_sign=row['cycles']/100,
            calls_per_sign=row['calls']/100, cycles_per_call=row['cycles']/row['calls'],
            percent_sign=100*row['cycles']/ticks,
            percent_selected=100*row['cycles']/selected))
    summary['degrees'][str(n)] = dict(
        mean_sign_cycles=ticks/100, mean_control_cycles=control_ticks/100,
        profile_delta_percent=100*(ticks/control_ticks-1),
        selected_percent=100*selected/ticks, other_percent=100*(ticks-selected)/ticks,
        deepest_inclusive_percent=100*(cats['sg_deepest']['cycles']+cats['sg_gaussian_berexp']['cycles'])/ticks,
        fingerprint=fingerprint, rows=rows,
        categories={k: dict(v, percent_sign=100*v['cycles']/ticks) for k,v in cats.items()})
output = Path(__file__).parent / 'detail_data.json'
output.write_text(json.dumps(summary, indent=2) + '\n')
for n, degree in summary['degrees'].items():
    print('DEGREE', n, 'mean', degree['mean_sign_cycles'], 'control', degree['mean_control_cycles'],
        'delta_percent', degree['profile_delta_percent'], 'selected_percent', degree['selected_percent'])
    for row in degree['rows']:
        print(row['function'], 'cycles/sign', f"{row['cycles_per_sign']:.2f}",
            'calls/sign', row['calls_per_sign'], '%sign', f"{row['percent_sign']:.6f}",
            '%selected', f"{row['percent_selected']:.6f}")
    print('deepest inclusive %', degree['deepest_inclusive_percent'])
    for cat in ('sg_gaussian_berexp', 'sg_gram', 'sg_target', 'sg_ldl_ffsampling'):
        print(cat, degree['categories'][cat]['percent_sign'])
