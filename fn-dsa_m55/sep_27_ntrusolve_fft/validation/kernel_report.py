#!/usr/bin/env python3
import json,re
from pathlib import Path
p=Path(__file__).resolve().parent
lines=['# Paired FFT kernel measurements','',
       '32 bounded identical Q32 arrays per size/direction, two warmups, IRQ masked.',
       'Fixed is the unchanged local original fixed routine. Native is the candidate transform',
       'on its required representation; inclusive = pack + native + unpack.',
       'A native bridge timing already includes double <-> DS; outer Q32 packing',
       'is reported separately. Whole NTRU uses its actual integer input path, so',
       'these synthetic Q32 boundary times are NOT whole-keygen predictions.','',
       'Times are mean cycles including timing-call overhead (not subtracted).',
       'A raw-word difference is not silently counted as exact equality.','']
for path in sorted((p/'results').glob('*/kernel/*/manifest.json')):
    m=json.loads(path.read_text())
    if not m['valid_measurement'] or (path.parent/'review.json').exists():continue
    text=(path.parent/'raw.log').read_text()
    rows=[]
    for line in text.splitlines():
        if not line.startswith('KERNEL logn='):continue
        d={k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',line)}
        rows.append(d)
    if not rows or any(not x['run'] for x in rows):continue
    lines += [f'## {m["candidate"]} / {path.parent.name}','',
              f'[Manifest]({path.relative_to(p)})','',
              '| n | direction | fixed | pack | native | unpack | native speedup | inclusive speedup | max raw error | rounded differences | native min–max |',
              '| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |']
    for d in rows:
        total=d['pack']+d['run']+d['unpack'];n=d['calls']
        lines.append(f'| {1<<d["logn"]} | '+('iFFT' if d['inverse'] else 'FFT')+' | '
            +' | '.join(f'{d[k]/n:,.2f}' for k in ('fixed','pack','run','unpack'))
            +f' | {d["fixed"]/d["run"]:.4f}× | {d["fixed"]/total:.4f}×'
            +f' | {d["max_error_raw"]} | {d["rounded_different"]}'
            +f' | {d["native_min"]}–{d["native_max"]} |')
    div=[x for x in text.splitlines() if x.startswith(('DIV_TIMING','DIV_DONE'))]
    if div:lines+=['','### FP64 division classes','','```text',*div,'```','']
lines+=['','The test domain is finite. Zero variation here is supporting evidence,',
        'not a universal timing/side-channel proof. Raw errors are in 2^-32 units.']
(p/'kernel_summary.md').write_text('\n'.join(lines)+'\n')
print(p/'kernel_summary.md')
