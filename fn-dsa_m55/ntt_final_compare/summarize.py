#!/usr/bin/env python3
"""Summarize only validated, provenance-matched full runs; keep raw samples."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import statistics
import sys
sys.dont_write_bytecode = True
import run

ROOT = Path(__file__).resolve().parent
VARIANTS = ('ref','ntt_opt_slothy')

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--label',default='matched_v1')
    a=parser.parse_args()
    records,paths,stats,digests={},{},{},{}
    for v in VARIANTS:
        folder=ROOT/'results'/(v+'-'+a.label)
        valid=json.loads((folder/'full_validated.json').read_text())
        pilot=json.loads((folder/'pilot_validated.json').read_text())
        assert valid['valid'] and pilot['valid']
        assert valid['elf_sha256']==pilot['elf_sha256']
        path=Path(valid['run_directory'])
        record=json.loads((path/'run.json').read_text())
        assert record['valid'] and record['host_digests_match'] and record['returncode']==0
        assert not record['validation_errors']
        assert record['raw_log_sha256']==hashlib.sha256((path/'raw.log').read_bytes()).hexdigest()
        assert json.loads((path/'provenance.json').read_text())==run.manifest(v)
        raw=re.sub(r'Info : [^\n]*\n','',(path/'raw.log').read_text())
        digests[v]=re.findall(r'^(?:DIGEST|AUDIT) degree=.+$',raw,re.M)
        assert len(digests[v])==22
        paths[v]=str(path.relative_to(ROOT))
        records[v]=record
        stats[v]={}
        for n in (512,1024):
            for op in range(3):
                rows=sorted((s for s in record['samples'] if s['degree']==n and s['operation']==op),key=lambda s:s['batch'])
                assert [s['batch'] for s in rows]==list(range(10))
                totals=[s['total'] for s in rows]
                values=[t/10 for t in totals]
                stats[v][f'{n}_{op}']={'mean':sum(totals)/100,
                    'upper_median':sorted(totals)[5]//10,
                    'min_batch_mean':min(values),'max_batch_mean':max(values),
                    'stdev_batch_means':statistics.stdev(values),'batch_means':values}
    assert digests['ref']==digests['ntt_opt_slothy']
    comparison={}
    for k,b in stats['ref'].items():
        f=stats['ntt_opt_slothy'][k]
        comparison[k]={'ref_mean':b['mean'],'final_mean':f['mean'],
                       'cycle_reduction_percent':100*(1-f['mean']/b['mean']),
                       'speedup':b['mean']/f['mean'],
                       'ref_upper_median':b['upper_median'],
                       'final_upper_median':f['upper_median'],
                       'upper_median_reduction_percent':100*(1-f['upper_median']/b['upper_median'])}
    result={'valid':True,'label':a.label,'unit':'cycles/call',
            'primary_statistic':'100-call arithmetic mean; 10 fixed seeds x 10 repetitions',
            'order':['ref','ntt_opt_slothy'],'runs':paths,
            'timing':{v:{k:records[v][k] for k in ('started_utc','ended_utc','elf_sha256','source_tree_sha256')} for v in VARIANTS},
            'digests_equal':22,'comparison':comparison,'statistics':stats,
            'layout_audit':json.loads((ROOT/'results/layout_audit.json').read_text())}
    out=ROOT/'results'/('comparison-'+a.label+'.json')
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(comparison,indent=2))
    print(out)

if __name__=='__main__': main()
