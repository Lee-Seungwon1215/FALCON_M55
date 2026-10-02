"""Summarize valid raw runs without disguising timer/layout perturbation."""
import json
from pathlib import Path
import re
import statistics as st
import sys

HERE=Path(__file__).resolve().parent
paths=[Path(p).resolve() for p in sys.argv[1:]]
assert paths
assert len({json.loads((p/'manifest.json').read_text())['production_sha256'] for p in paths})==1, 'Do not combine different production versions'
all_runs=[]
def stats(v):
    return dict(mean=st.mean(v),median=st.median(v),min=min(v),max=max(v),n=len(v))
for path in paths:
    manifest=json.loads((path/'manifest.json').read_text())
    assert manifest['valid_measurement'],(path,manifest['errors'])
    raw=re.sub(r'Info : [^\n]*\n','',(path/'raw.log').read_text())
    def rows(name):
        return [dict((k,int(v)) for k,v in re.findall(r'(\w+)=(\d+)',line))
                for line in re.findall('^'+name+r' .*$',raw,re.M)]
    bench=rows('BENCH_SAMPLE'); phases=rows('PHASE_SAMPLE')
    assert len(bench)==len(phases)==100
    ext=stats([(p['process']-p['process_empty'])/64 for p in bench])
    ext_phase=stats([p['total']/64 for p in phases])
    assert ext['mean']==ext_phase['mean']
    out=dict(path=str(path.relative_to(HERE)),variant=manifest['variant'],
             external_cycles=ext,phase_batch_cycles=ext_phase,
             split_group=stats([(p['split_group']-p['helper_empty'])/64 for p in bench]),
             merge_group=stats([(p['merge_group']-p['helper_empty'])/64 for p in bench]))
    if manifest['variant']=='trace':
        corrected=[]; overhead=[]
        for p in phases:
            assert sum(p[k] for k in ('input','init','theta','chi','control','iota','output'))==p['span']
            c=dict(input=p['input']-p['cff'],init=p['init']-p['cfi'],
                theta=p['theta']-24*p['cii'],chi=p['chi']-24*p['cii'],
                control=p['control']-23*p['cii']-p['cif'],
                iota=p['iota']-p['cff'],output=p['output']-p['cff'])
            assert all(v>=0 for v in c.values())
            corrected.append(c)
            # 76 adjacent timestamp intervals + one tap across external edges.
            overhead.append(4*p['cff']+p['cfi']+71*p['cii']+p['cif'])
        out['raw_intervals']={k:stats([p[k] for p in phases]) for k in
            ('input','init','theta','chi','control','iota','output','span','cff','cii','cfi','cif')}
        out['corrected_intervals']={k:stats([p[k] for p in corrected]) for k in corrected[0]}
        out['estimated_77_tap_cost']=stats(overhead)
        out['estimated_corrected_external']=stats([p['total']/64-h for p,h in zip(phases,overhead)])
    all_runs.append(out)
plain=[r for r in all_runs if r['variant']=='plain']
trace=[r for r in all_runs if r['variant']=='trace']
assert plain and trace
base=st.mean([r['external_cycles']['mean'] for r in plain])
c={k:st.mean([r['corrected_intervals'][k]['mean'] for r in trace])
   for k in trace[0]['corrected_intervals']}
groups=[('입출력·비트 분리/복원',c['input']+c['output']),
        ('θ 보정 + ρ/π 회전·재배치',c['theta']),
        ('χ + 다음 라운드 열 XOR 누적',c['chi']),
        ('초기 준비·ι·루프 제어·복귀/계측 잔여',base-c['input']-c['output']-c['theta']-c['chi'])]
summary=dict(production_sha256=json.loads((paths[0]/'manifest.json').read_text())['production_sha256'],
    baseline_cycles=base,runs=all_runs,groups=[dict(name=n,cycles=v,percent=100*v/base,microseconds=v/800)
    for n,v in groups],unassigned_after_measured_intervals=base-sum(c.values()),
    note='Phase estimates subtract adjacent-tap calibration; remaining pipeline/layout perturbation is not a per-phase error bound.')
(HERE/'summary.json').write_text(json.dumps(summary,indent=2,ensure_ascii=False)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='runs'},ensure_ascii=False,indent=2))
for r in all_runs:
    print(r['path'],r['external_cycles'],r.get('estimated_corrected_external'))
