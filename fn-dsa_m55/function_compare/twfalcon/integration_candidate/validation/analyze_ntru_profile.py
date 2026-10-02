#!/usr/bin/env python3
"""Validate complete NTRU accounting; do not normalize to just FFT regions."""
import argparse
import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser()
parser.add_argument('--detail', type=Path, required=True)
parser.add_argument('--control', type=Path, required=True)
parser.add_argument('--repeat', type=Path, required=True)
args = parser.parse_args()
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
crypto = {p.name:sha(p) for p in ROOT.glob('*.[chs]')}
origin = json.loads((ROOT/'validation/origin_manifest.json').read_text())
assert crypto == origin['crypto_sha256'], 'Cryptographic source changed'

def rows(text, tag):
    result = []
    for line in text.splitlines():
        if line.startswith(tag+' '):
            pairs = dict(v.split('=', 1) for v in line.split()[1:])
            result.append({k:int(v) if v.isdigit() else v for k,v in pairs.items()})
    return result

def keymap(text, tag):
    data = rows(text, tag)
    assert len(data) == 200 and all(r['match']==1 and r['equation']=='PASS' for r in data)
    mapped = {(r['degree'], r['index']):r['actual'] for r in data}
    assert set(mapped) == {(d,i) for d in (512,1024) for i in range(100)}
    return mapped

evidence, data = {}, {}
for label, path in vars(args).items():
    r = json.loads((path/'run.json').read_text())
    assert r['valid_measurement'] and not r['errors'] and r['source_root']==str(ROOT)
    assert r['kind'] == ('ntrucontrol' if label=='control' else 'ntruprofile')
    assert r['local_crypto_translation_units']==24
    assert all(sha(Path(p))==h for p,h in r['source'].items())
    assert sha(path/'raw.log')==r['raw_sha256']
    build = ROOT/'validation/build'/r['kind']
    assert sha(build/'zephyr/zephyr.elf')==r['elf_sha256']
    assert sha(build/'compile_commands.json')==r['compile_commands_sha256']
    original = (ROOT/'kgen_ntru.c').read_text()
    instrumented = (build/'generated/kgen_ntru.c').read_text()
    recovered = re.sub(r'/\* NPRO_INSERT \*/.*?/\* NPRO_END \*/', '', instrumented, flags=re.S)
    assert recovered==original
    text = (path/'raw.log').read_text()
    data[label] = dict(keys=keymap(text, 'NPRO_KEY'),
        totals={r['degree']:r for r in rows(text,'NPRO_TOTAL')},
        counters={d:{r['op']:r for r in rows(text,'NPRO') if r['degree']==d} for d in (512,1024)},
        empty=rows(text,'NPRO_EMPTY'))
    evidence[label] = dict(path=str(path.resolve()), run=r)
assert data['detail']['keys']==data['control']['keys']==data['repeat']['keys']
assert evidence['detail']['run']['elf_sha256']==evidence['repeat']['run']['elf_sha256']
prior = ROOT/'validation/results/keyprofile/20260923T122434Z'
prior_meta = json.loads((prior/'run.json').read_text())
assert prior_meta['valid_measurement'] and sha(prior/'raw.log')==prior_meta['raw_sha256']
assert all(prior_meta['source'][str(ROOT/name)]==h for name,h in crypto.items())
assert data['detail']['keys']==keymap((prior/'raw.log').read_text(),'APRO_KEY')

order = ('FFT_fp64','inv_mul2e_fft_fp64','mul_fft_fp64','iFFT_fp64',
         'FFT_fixed','div_selfadj_fft_fixed','iFFT_fixed',
         'input_intermediate','round_guard_intermediate','input_depth0','round_rns_depth0','other')
degrees = {}
for d in (512,1024):
    total = data['detail']['totals'][d]
    control = data['control']['totals'][d]
    repeat = data['repeat']['totals'][d]
    c = data['detail']['counters'][d]
    rc = data['repeat']['counters'][d]
    assert set(c)==set(order)
    assert sum(r['cycles'] for r in c.values())==total['cycles']
    assert all(t['attempts']==total['attempts'] and t['failed']==total['failed']
               and t['accepted']==100 and t['errors']==0 for t in (total,control,repeat))
    assert c['FFT_fp64']['calls']==c['input_intermediate']['calls']==c['inv_mul2e_fft_fp64']['calls']+c['mul_fft_fp64']['calls']
    assert c['mul_fft_fp64']['calls']==c['iFFT_fp64']['calls']==c['round_guard_intermediate']['calls']
    assert c['FFT_fixed']['calls']==c['input_depth0']['calls']==2*c['div_selfadj_fft_fixed']['calls']
    assert c['div_selfadj_fft_fixed']['calls']==c['iFFT_fixed']['calls']==c['round_rns_depth0']['calls']
    groups = {}
    for op in order:
        groups[op] = dict(c[op], share_percent=100*c[op]['cycles']/total['cycles'],
            mean_cycles_per_key=c[op]['cycles']/100,
            mean_cycles_per_attempt=c[op]['cycles']/total['attempts'],
            repeat_cycle_difference=rc[op]['cycles']-c[op]['cycles'])
        assert c[op]['calls']==rc[op]['calls']
    share = lambda names: 100*sum(c[n]['cycles'] for n in names)/total['cycles']
    degrees[d] = dict(total=total, control=control, repeat=repeat, groups=groups,
        total_cycles_per_key=total['cycles']/100,
        total_cycles_per_attempt=total['cycles']/total['attempts'],
        detail_over_control_percent=100*(total['cycles']/control['cycles']-1),
        repeat_total_difference=repeat['cycles']-total['cycles'],
        all_seven_fft_functions_percent=share(order[:7]),
        fft_ifft_only_percent=share(('FFT_fp64','iFFT_fp64','FFT_fixed','iFFT_fixed')),
        intermediate_measured_regions_percent=share(order[:4]+order[7:9]),
        depth0_measured_regions_percent=share(order[4:7]+order[9:11]))
output = ROOT/'validation/results/ntru_analysis'/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
output.mkdir(parents=True, exist_ok=False)
result = dict(denominator='all solve_NTRU attempt time, including failures; not whole key generation',
    analyzer_sha256=sha(Path(__file__)),
    crypto_unchanged=True, crypto_sha256=crypto, evidence=evidence, degrees=degrees,
    prior_profile_digest_match=True, kat='200/200 in each of three runs',
    timer_calibration={k:v['empty'] for k,v in data.items()},
    limitations=['timing overhead included; other includes timing bookkeeping',
                 'different ELF layouts for control/detail; difference is not pure timer cost',
                 'no new proof of arithmetic equivalence, constant time, or side-channel safety'])
(output/'summary.json').write_text(json.dumps(result, indent=2)+'\n')
lines = ['degree,operation,total_cycles,calls,cycles_per_key,percent_of_all_ntru']
for d, stats in degrees.items():
    for op, r in stats['groups'].items():
        lines.append(f"{d},{op},{r['cycles']},{r['calls']},{r['mean_cycles_per_key']:.2f},{r['share_percent']:.8f}")
(output/'functions.csv').write_text('\n'.join(lines)+'\n')
print('ANALYSIS', output)
print(json.dumps(degrees, indent=2))
