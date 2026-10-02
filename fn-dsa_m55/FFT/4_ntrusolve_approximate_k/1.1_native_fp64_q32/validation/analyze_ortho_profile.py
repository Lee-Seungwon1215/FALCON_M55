#!/usr/bin/env python3
"""Report candidate-check and whole-keygen denominators without mixing them."""
import argparse
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser()
for name in ('detail', 'control', 'repeat'):
    parser.add_argument('--'+name, type=Path, required=True)
args = parser.parse_args()
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
crypto = {p.name: sha(p) for p in ROOT.glob('*.[chs]')}
origin = json.loads((ROOT/'validation/origin_manifest.json').read_text())
assert crypto == origin['crypto_sha256'], 'Cryptographic source changed'

def rows(text, tag):
    result = []
    for line in text.splitlines():
        if line.startswith(tag+' '):
            pairs = dict(v.split('=', 1) for v in line.split()[1:])
            result.append({k: int(v) if v.isdigit() else v for k, v in pairs.items()})
    return result

def keymap(text, tag):
    data = rows(text, tag)
    assert len(data) == 200 and all(r['match'] == 1 and r['equation'] == 'PASS' for r in data)
    mapped = {(r['degree'], r['index']): r['actual'] for r in data}
    assert set(mapped) == {(d, i) for d in (512, 1024) for i in range(100)}
    return mapped

data, evidence = {}, {}
for label, path in vars(args).items():
    run = json.loads((path/'run.json').read_text())
    assert run['valid_measurement'] and not run['errors']
    assert run['source_root'] == str(ROOT) and run['local_crypto_translation_units'] == 24
    assert run['kind'] == ('orthocontrol' if label == 'control' else 'orthoprofile')
    assert all(sha(Path(p)) == h for p, h in run['source'].items())
    assert sha(path/'raw.log') == run['raw_sha256']
    build = ROOT/'validation/build'/run['kind']
    assert sha(build/'zephyr/zephyr.elf') == run['elf_sha256']
    assert sha(build/'compile_commands.json') == run['compile_commands_sha256']
    generated = (build/'generated/kgen_ntru.c').read_text()
    assert re.sub(r'/\* OPRO_INSERT \*/.*?/\* OPRO_END \*/', '', generated, flags=re.S) == (ROOT/'kgen_ntru.c').read_text()
    text = re.sub(r'Info : [^\n]*\n', '', (path/'raw.log').read_text())
    data[label] = dict(keys=keymap(text, 'OPRO_KEY'),
        totals={r['degree']: r for r in rows(text, 'OPRO_TOTAL')},
        counters={d: {r['op']: r for r in rows(text, 'OPRO') if r['degree'] == d}
                  for d in (512, 1024)}, empty=rows(text, 'OPRO_EMPTY'))
    evidence[label] = dict(path=str(path.resolve()), run=run)
assert data['detail']['keys'] == data['control']['keys'] == data['repeat']['keys']
assert evidence['detail']['run']['elf_sha256'] == evidence['repeat']['run']['elf_sha256']
prior = ROOT/'validation/results/ntruprofile/20260923T132002Z'
prior_run = json.loads((prior/'run.json').read_text())
assert prior_run['valid_measurement'] and sha(prior/'raw.log') == prior_run['raw_sha256']
assert all(prior_run['source'][str(ROOT/name)] == h for name, h in crypto.items())
assert data['detail']['keys'] == keymap((prior/'raw.log').read_text(), 'NPRO_KEY')

order = ('vect_set', 'vect_FFT', 'vect_invnorm_fft', 'vect_adj_fft',
         'vect_mul_realconst', 'vect_mul_selfadj_fft', 'vect_iFFT',
         'norm_sum', 'ortho_other', 'key_other')
requested = ('vect_invnorm_fft', 'vect_adj_fft', 'vect_mul_selfadj_fft', 'vect_mul_realconst')
degrees = {}
for d in (512, 1024):
    total = data['detail']['totals'][d]
    control = data['control']['totals'][d]
    repeat = data['repeat']['totals'][d]
    c = data['detail']['counters'][d]
    rc = data['repeat']['counters'][d]
    cc = data['control']['counters'][d]
    assert set(c) == set(rc) == set(cc) == set(order)
    assert all(t['keys'] == 100 and t['errors'] == 0 and t['attempts'] == total['attempts']
               for t in (total, control, repeat))
    for label in data:
        t = data[label]['totals'][d]
        counts = data[label]['counters'][d]
        assert sum(r['cycles'] for r in counts.values()) == t['key_cycles']
        assert sum(r['cycles'] for op, r in counts.items() if op != 'key_other') == t['ortho_cycles']
        assert 0 < t['max_ortho'] <= t['max_key'] < 2000000000
    groups = {}
    for op in order:
        assert c[op]['calls'] == rc[op]['calls']
        if op not in ('ortho_other', 'key_other'):
            assert c[op]['calls'] == total['attempts']*(1 if op in ('vect_invnorm_fft', 'norm_sum') else 2)
            assert cc[op]['calls'] == cc[op]['cycles'] == 0
        groups[op] = dict(c[op],
            percent_of_keygen=100*c[op]['cycles']/total['key_cycles'],
            percent_of_ortho=(100*c[op]['cycles']/total['ortho_cycles'] if op != 'key_other' else None),
            cycles_per_key=c[op]['cycles']/100,
            cycles_per_call=(c[op]['cycles']/c[op]['calls'] if c[op]['calls'] else None),
            repeat_cycle_difference=rc[op]['cycles']-c[op]['cycles'])
    subtotal = sum(c[op]['cycles'] for op in requested)
    degrees[d] = dict(total=total, control=control, repeat=repeat, groups=groups,
        keygen_cycles_per_key=total['key_cycles']/100,
        ortho_cycles_per_key=total['ortho_cycles']/100,
        ortho_percent_of_keygen=100*total['ortho_cycles']/total['key_cycles'],
        requested_four_percent_of_keygen=100*subtotal/total['key_cycles'],
        requested_four_percent_of_ortho=100*subtotal/total['ortho_cycles'],
        detail_over_control_key_percent=100*(total['key_cycles']/control['key_cycles']-1),
        detail_over_control_ortho_percent=100*(total['ortho_cycles']/control['ortho_cycles']-1),
        repeat_key_difference=repeat['key_cycles']-total['key_cycles'],
        repeat_ortho_difference=repeat['ortho_cycles']-total['ortho_cycles'])

output = ROOT/'validation/results/ortho_analysis'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
output.mkdir(parents=True, exist_ok=False)
result = dict(analyzer_sha256=sha(Path(__file__)), crypto_unchanged=True,
    crypto_sha256=crypto, evidence=evidence, degrees=degrees,
    prior_profile_digest_match=True, kat='200/200 in each of three runs, same 200 seeds',
    timer_calibration={k: v['empty'] for k, v in data.items()},
    limitations=['candidate denominator covers only check_ortho_norm, not all candidate tests',
                 'candidate timer ends before final comparison/return; key timer covers the complete keygen call',
                 'interval/call overhead is included; no subtraction or normalization to FFT only',
                 'detail/control ELF layouts differ; delta is not pure hook cost',
                 'not a new proof of arithmetic equivalence, constant time, or side-channel safety'])
(output/'summary.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['degree,operation,total_cycles,calls,cycles_per_key,percent_of_keygen,percent_of_ortho']
for d, stats in degrees.items():
    for op, r in stats['groups'].items():
        pct = '' if r['percent_of_ortho'] is None else f"{r['percent_of_ortho']:.8f}"
        lines.append(f"{d},{op},{r['cycles']},{r['calls']},{r['cycles_per_key']:.2f},{r['percent_of_keygen']:.8f},{pct}")
(output/'functions.csv').write_text('\n'.join(lines)+'\n')
print('ANALYSIS', output)
print(json.dumps(degrees, indent=2))
