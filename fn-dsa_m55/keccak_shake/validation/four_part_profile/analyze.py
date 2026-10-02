"""Summarize directly timed intervals; never call them exact native attribution."""
import json
from pathlib import Path
import re
from statistics import median

HERE=Path(__file__).resolve().parent
rows={}
def stats(values):
    return dict(min=min(values),median=median(values),max=max(values))
for impl in ('ref','mve'):
    for mode in ('plain','io','bits','round','xor','core'):
        variant=impl+'-'+mode
        runs=[]
        for p in sorted((HERE/'results'/variant).glob('*/manifest.json')):
            m=json.loads(p.read_text())
            audit=json.loads((p.parent/'audit.json').read_text())
            if m['valid_measurement'] and audit.get('fixed_placements')=={
                'state':'0x30003000','part_stack_top':'0x30005000'}:
                runs.append(p.parent)
        if not runs: raise SystemExit('Missing fixed-placement measurement: '+variant)
        run=runs[-1]
        text=re.sub(r'Info : [^\n]*\n','',(run/'raw.log').read_text())
        samples=[{k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',line)}
                 for line in re.findall(r'^PART_SAMPLE .*$',text,re.M)]
        assert len(samples)==100,variant
        assert len({s['n'] for s in samples})==1,variant
        assert all(s['cal_min']==s['cal_max']==8 for s in samples),('wrong calibration stack',variant)
        result=dict(run=str(run.relative_to(HERE)),samples=100,batch=64,
                    intervals_per_call=samples[0]['n'],
                    raw_interval_sum=stats([s['raw'] for s in samples]),
                    corrected_interval_sum=stats([s['raw']-s['n']*s['calibration']/64 for s in samples]),
                    whole_function_with_probes=stats([s['total']/64 for s in samples]),
                    empty_interval_calibration=stats([s['calibration']/64 for s in samples]))
        rows[variant]=result
comparison={}
for mode in ('io','bits','round','xor','core','plain'):
    key='whole_function_with_probes' if mode=='plain' else 'corrected_interval_sum'
    a=rows['ref-'+mode][key]['median']; b=rows['mve-'+mode][key]['median']
    comparison[mode]=dict(ref_cycles=a,mve_cycles=b,speedup=a/b,cycle_reduction_percent=100*(1-b/a))
reconstruction={}
for impl in ('ref','mve'):
    total=rows[impl+'-plain']['whole_function_with_probes']['median']
    parts=sum(rows[impl+'-'+mode]['corrected_interval_sum']['median'] for mode in ('io','bits','round','xor'))
    reconstruction[impl]=dict(native_whole_cycles=total,independent_parts_sum=parts,
        difference=parts-total,difference_percent=100*(parts/total-1))
    coarse=sum(rows[impl+'-'+mode]['corrected_interval_sum']['median'] for mode in ('io','bits','core'))
    reconstruction[impl].update(coarse_parts_sum=coarse,coarse_difference=coarse-total,
        coarse_difference_percent=100*(coarse/total-1))
out=dict(measurement_kind='separate-firmware instrumented exclusive intervals; not an exact native pipeline decomposition',
    rows=rows,comparison=comparison,reconstruction=reconstruction)
(HERE/'summary.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(comparison=comparison,reconstruction=reconstruction),indent=2))
