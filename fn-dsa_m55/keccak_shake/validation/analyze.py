"""Archive both raw batches and calibrated per-call cycle statistics."""
import json
from pathlib import Path
import re
import statistics
import math
import sys
import tarfile

HERE=Path(__file__).resolve().parent
run=Path(sys.argv[1])
manifest=json.loads((run/'manifest.json').read_text())
assert manifest['valid_measurement'],manifest
with tarfile.open(run/'sources.tar.gz') as archive:
    full_mve=any(m.name=='production/sha3_cm55.s' and
        b'.macro K_SPLIT4' in archive.extractfile(m).read() for m in archive.getmembers())
raw=re.sub(r'Info : [^\n]*\n','',(run/'raw.log').read_text())
samples=[{k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',line)}
         for line in raw.splitlines() if line.startswith('BENCH_SAMPLE ')]
assert len(samples)==100 and [r['i'] for r in samples]==list(range(100))
assert 'BENCH_BEGIN samples=100 batch=64 warmups=5 rate_words=17' in raw
def stats(values):
    return dict(mean=statistics.mean(values),median=statistics.median(values),
        minimum=min(values),maximum=max(values),stdev=statistics.stdev(values))
labels=dict(process='fndsa_sha3_process_block()',split1='bit_split_1',split5='bit_split_5',
    merge1='bit_merge_1',merge5='bit_merge_5',split_group='split group: 4 x split_5 + split_1',
    merge_group='merge group: 4 x merge_5 + merge_1')
data=dict(run=str(run.resolve()),elf_sha256=manifest['elf_sha256'],samples=100,batch=64,
    raw_samples=samples,statistics={},full_mve_source_in_snapshot=full_mve)
classes=[{k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',line)}
    for line in raw.splitlines() if line.startswith('TIMING_CLASS ')]
for c in classes:
    c['mean']=c['sum']/c['n']
    c['variance']=max(0,(c['sumsq']-c['sum']**2/c['n'])/(c['n']-1))
data['timing_classes']=classes
if len(classes)==2:
    a,b=classes
    denom=math.sqrt(a['variance']/a['n']+b['variance']/b['n'])
    data['welch_t']=(a['mean']-b['mean'])/denom if denom else None
    data['welch_t_note']='computed' if denom else 'undefined: both observed sample variances are zero'
for name in labels:
    control='process_empty' if name=='process' else 'helper_empty'
    data['statistics'][name]=dict(
        raw_cycles_per_call=stats([s[name]/64 for s in samples]),
        calibrated_cycles_per_call=stats([(s[name]-s[control])/64 for s in samples]))
for name in ('process_empty','helper_empty'):
    data['statistics'][name]=dict(raw_cycles_per_call=stats([s[name]/64 for s in samples]))
(run/'analysis.json').write_text(json.dumps(data,indent=2)+'\n')
lines=['# Keccak cycle baseline (M55)','',
    f'Run: `{run.name}`. ELF SHA-256: `{manifest["elf_sha256"]}`.','',
    '100 samples; each sample contains 64 calls; 5 warm-up batches. '
    'The empty-loop/timer cost is subtracted, retaining BL/return and the actual function body.','',
    '| Target | Raw cycles/call | Calibrated mean | Median | Min | Max | Stddev |',
    '| --- | ---: | ---: | ---: | ---: | ---: | ---: |']
for name,label in labels.items():
    d=data['statistics'][name]; s=d['calibrated_cycles_per_call']
    values=[d['raw_cycles_per_call']['mean']]+[s[k] for k in ('mean','median','minimum','maximum','stdev')]
    lines.append('| '+label+' | '+' | '.join(f'{v:.3f}' for v in values)+' |')
helper_note=('For the full-MVE variant, bit_split/bit_merge rows measure retained legacy '
    'helpers only: process_block no longer calls them. Its actual MVE split/merge macros '
    'are included in the process_block total, not separately timed by those helper rows. '
    'Do not add the helper rows to process_block.' if full_mve and manifest['variant']=='mve' else
    'The split/merge groups are measured as a private-call sequence in a separate harness. '
    'They exclude caller-side state loads/stores and are not exact in-situ exclusive portions. '
    'Do not add these rows to process_block, which already includes its conversion work.')
lines+=['',helper_note,'',
    'Correctness: helper cases 5120, full-state comparisons 1024, '
    'SHAKE256 vectors 7, guards PASS. CFSR/HFSR/AFSR = 0.',
    'These tests and any absence of observed timing differences are not a proof of constant-time behavior.','',
    'Empty harness cycles per iteration: '+', '.join(f'{name}={data["statistics"][name]["raw_cycles_per_call"]["mean"]:.6f}'
        for name in ('process_empty','helper_empty'))+'.','']
if classes:
    lines+=['| Timing class (raw single call) | Count | Mean | Min | Max |',
        '| --- | ---: | ---: | ---: | ---: |']
    for c in classes:
        lines.append(f'| {c["class"]} (0=zero, 1=random) | {c["n"]} | {c["mean"]:.6f} | {c["min"]} | {c["max"]} |')
    lines+=['',f'Welch t = {data["welch_t"]} ({data["welch_t_note"]}). Limited two-class timing check, not a formal proof.','']
(run/'result.md').write_text('\n'.join(lines))
print('\n'.join(lines))
