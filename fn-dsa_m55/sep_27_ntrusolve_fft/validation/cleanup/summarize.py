#!/usr/bin/env python3
"""Archive cleanup regression measurements with current-source provenance."""
import hashlib
import json
import re
import subprocess
import sys
import tarfile
from pathlib import Path
from check import check, ROOT, SOURCE, OUT, SNAPSHOTS

sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
scope = check()
expected = {str(SOURCE / n): h for n, h in scope['sha256'].items()}
runs = {}
modes = ('keygen', 'kat', 'extra', 'sigkat', 'kernel', 'profile', 'fixed_input',
         'input_pair', 'input_predicate', 'fixed_division', 'fixed_fft', 'rootmul',
         'invnorm', 'security_api', 'security_invnorm')
for mode in modes:
    for manifest in sorted((ROOT / 'validation/results/A_tw_bridge' / mode).glob('*/manifest.json'), reverse=True):
        m = json.loads(manifest.read_text())
        if not all(m['source_sha256'].get(n) == h for n, h in expected.items()):
            continue
        assert m['valid_measurement'] and not m['errors'], manifest
        d = manifest.parent
        assert sha(d/'raw.log') == m['raw_sha256'] and sha(d/'benchmark.elf') == m['elf_sha256']
        runs[mode] = {'directory': str(d.relative_to(ROOT)), 'run': d.name}
        break
    assert mode in runs, ('Missing current-source run', mode)

subprocess.run([sys.executable, '-B', str(ROOT/'validation/security/analyze.py'),
                runs['security_invnorm']['run'], runs['security_api']['run'],
                'validation/cleanup/security'], check=True)


def means(directory):
    raw = (directory/'raw.log').read_text()
    return {int(n): int(total)/int(calls) for n, calls, total in
            re.findall(r'^KEYGEN_SUMMARY degree=(\d+) calls=(\d+) total=(\d+)', raw, re.M)}


before = ROOT/'validation/results/A_tw_bridge/keygen/20260928T033015Z'
after = ROOT/runs['keygen']['directory']
old_mean, new_mean = means(before), means(after)
data = json.loads((ROOT/'validation/summary.json').read_text())
baseline = [v for v in data if v['candidate'] == 'baseline_m55' and v['mode'] == 'keygen'][-1]
baseline_dir = (ROOT/'validation'/baseline['manifest']).parent
base_mean = means(baseline_dir)
for directory in (before, baseline_dir):
    manifest = json.loads((directory/'manifest.json').read_text())
    assert manifest['valid_measurement'] and not manifest['errors']
    assert sha(directory/'raw.log') == manifest['raw_sha256']
    assert sha(directory/'benchmark.elf') == manifest['elf_sha256']
speed = {n: {'before': old_mean[n], 'after': new_mean[n],
             'change_percent': (new_mean[n]/old_mean[n]-1)*100,
             'm55_ref_speedup': base_mean[n]/new_mean[n]} for n in (512, 1024)}

nm = ROOT.parent/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-nm'
old_symbols = subprocess.check_output([str(nm), '-S', str(before/'benchmark.elf')], text=True)
new_symbols = subprocess.check_output([str(nm), '-S', str(after/'benchmark.elf')], text=True)
assert re.search(r'\b00000040 T fndsa_stage3_mul_probe$', old_symbols, re.M)
for name in ('fndsa_stage3_mul_probe', 'fndsa_mp31_monty4_probe', 'fndsa_ntru_q32_rootmul4'):
    assert name not in new_symbols


def sections(directory):
    tool = nm.with_name('arm-none-eabi-size')
    output = subprocess.check_output([str(tool), '-A', str(directory/'benchmark.elf')], text=True)
    return {name: int(size) for name, size in
            re.findall(r'^(text|rodata|datas|bss|noinit)\s+(\d+)\s+', output, re.M)}


memory = {'before': sections(before), 'after': sections(after)}
assert memory['before']['text'] - memory['after']['text'] == 64
assert all(memory['before'][n] == memory['after'][n] for n in ('rodata', 'datas', 'bss', 'noinit'))

with tarfile.open(SNAPSHOTS/'A17_fp64_invnorm.tar.gz') as archive:
    old_files = {Path(m.name).name: archive.extractfile(m).read()
                 for m in archive.getmembers() if m.isfile() and Path(m.name).suffix in ('.c', '.h', '.s')}
new_files = {p.name: p.read_bytes() for p in SOURCE.glob('*') if p.suffix in ('.c', '.h', '.s')}
size = {'before_source_bytes': sum(map(len, old_files.values())),
        'after_source_bytes': sum(map(len, new_files.values())),
        'before_source_lines': sum(x.count(b'\n') for x in old_files.values()),
        'after_source_lines': sum(x.count(b'\n') for x in new_files.values()),
        'removed_diagnostic_bytes': 64}
security = json.loads((OUT/'security/summary.json').read_text())
assert security['decision_mismatches'] == 0
assert security['api']['failures'] == security['api']['guards'] == 0
assert not any(x['flag_abs_t_ge_5'] for x in security['welch'])
result = {'status': 'REQUESTED_FIVE_CHECKS_COMPLETE_WITH_REPORTED_LIMITATIONS',
          'claim': 'Cleanup regression, not security certification or all-input equivalence',
          'runs': runs, 'speed': speed, 'size': size,
          'elf_sections': memory,
          'before_keygen': str(before.relative_to(ROOT)),
          'baseline_keygen': str(baseline_dir.relative_to(ROOT)),
          'max_abs_welch_t': max(abs(x['t']) for x in security['welch']),
          'scope_check': 'scope.json', 'security_analysis': 'security/summary.json'}
(OUT/'summary.json').write_text(json.dumps(result, indent=2)+'\n')
print(json.dumps(result, indent=2))
