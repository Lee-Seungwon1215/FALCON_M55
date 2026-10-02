#!/usr/bin/env python3
"""Aggregate only complete, hash-verified runs; never substitute historic data."""
from collections import defaultdict
from pathlib import Path
import hashlib
import json
import re
import subprocess
from provenance import snapshot

ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'results'
BASE = ROOT.parent.parent / 'fp64_kat_exact'
FIXED = ROOT.parents[2] / 'ref'
LABELS = ('ref-perf', 'c-perf', 'asm-perf', 'ref-profile', 'c-profile',
          'asm-profile', 'kernels', 'kat')
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
runs, logs = {}, {}
for label in LABELS:
    path = sorted((OUT / label).glob('*/run.json'))[-1]
    run = json.loads(path.read_text())
    assert run['valid'] and not run['errors'], (label, run['errors'])
    logpath = path.parent / 'raw.log'
    assert sha(logpath) == run['raw_sha256'], label
    source = FIXED if label.startswith('ref-') else BASE if label.startswith('c-') else ROOT.parent
    assert snapshot(ROOT/'build'/label, source) == run['build_manifest'], label
    runs[label] = run
    logs[label] = re.sub(r'Info : [^\n]*\n', '', logpath.read_text())

def keys(label):
    return {(x['degree'], x['index']): x['digest'] for x in runs[label]['keys']}

expected = keys('ref-perf')
assert len(expected) == 200
for label in LABELS[:6]:
    assert keys(label) == expected, label
    assert 'FP64_DONE result=0 signature_and_tamper=PASS' in logs[label]

kat = re.findall(r'^BOARD_KAT degree=(\d+) index=(\d+) match=1 equation=PASS$', logs['kat'], re.M)
assert {(int(d), int(i)) for d, i in kat} == {(d, i) for d in (256,512,1024) for i in range(100)}
assert len(kat) == 300

performance = []
for degree in (512,1024):
    row = {'degree': degree}
    for group in ('ref','c','asm'):
        total = next(t for t in runs[group+'-perf']['totals'] if t['degree'] == degree)
        assert total['runs'] == 100
        samples = [k['cycles'] for k in runs[group+'-perf']['keys'] if k['degree'] == degree]
        assert sum(samples) == total['cycles'] and max(samples) < 2**32
        row[group] = dict(total, mean_cycles=total['cycles']/100)
    row['asm_vs_c_cycle_change_percent'] = (row['asm']['mean_cycles']/row['c']['mean_cycles']-1)*100
    row['asm_vs_fixed_time_ratio'] = row['asm']['mean_cycles']/row['ref']['mean_cycles']
    performance.append(row)

profiles = []
counts = lambda label: {(r['degree'],r['kind'],r['logn']):r['calls'] for r in runs[label]['approx']}
assert counts('ref-profile') == counts('c-profile') == counts('asm-profile')
for degree in (512,1024):
    for kind in (0,1):
        row = {'degree':degree,'kind':kind,'name':('prepare','repeat')[kind]}
        for group in ('ref','c','asm'):
            rows = [x for x in runs[group+'-profile']['approx'] if x['degree']==degree and x['kind']==kind]
            row[group] = dict(calls=sum(x['calls'] for x in rows), mean_cycles_per_key=sum(x['cycles'] for x in rows)/100)
        row['asm_vs_c_cycle_change_percent'] = (row['asm']['mean_cycles_per_key']/row['c']['mean_cycles_per_key']-1)*100
        profiles.append(row)

def records(prefix, text):
    out = []
    for line in text.splitlines():
        if line.startswith(prefix+' '):
            out.append({k:int(v) if re.fullmatch(r'\d+',v) else v for k,v in re.findall(r'(\w+)=([^ ]+)',line)})
    return out

kernel_log = logs['kernels']
diff = records('BOARD_DIFF',kernel_log)
assert len(diff)==1 and diff[0]['random_pairs']==1000000 and diff[0]['edge_pairs']==36864 and diff[0]['result']==0
oracle = json.loads((ROOT/'build/kernels/generated/oracle_manifest.json').read_text())
assert diff[0]['checksum']=='c665dcb55f68554d'
kernels = records('KERNEL',kernel_log)
assert len(kernels)==19 and all(k['bitexact']=='PASS' for k in kernels)
for k in kernels:
    k['asm_vs_c_repeat_cycle_change_percent'] = (k['asm_reduce']/k['c_reduce']-1)*100

def timing_summary(rows, fields):
    grouped=defaultdict(list)
    for r in rows: grouped[tuple(r[f] for f in fields)].append(r)
    out=[]
    for key,items in sorted(grouped.items()):
        assert len(items)==20 and {r['case'] for r in items}==set(range(20))
        out.append(dict(zip(fields,key), input_classes=20,
            distinct_input_minima=sorted({r['min'] for r in items}),
            maximum_within_class_span=max(r['max']-r['min'] for r in items)))
    return out

mul_rows=records('MUL',kernel_log)
assert len(mul_rows)==60
mul_summary=timing_summary(mul_rows,('backend',))
op_summary=timing_summary(records('CT_OP',kernel_log),('op',))
fft_rows=records('CT_FFT',kernel_log)
assert len(fft_rows)==1200
fft_summary=timing_summary(fft_rows,('backend','logn','inverse'))
ct_all_input_minima_equal=all(len(r['distinct_input_minima'])==1 for r in mul_summary+op_summary+fft_summary)

memory={}
for label in LABELS[:6]+('kat',):
    rows=records('STACK_WATERMARK',logs[label])
    assert len(rows)==1 and rows[0]['untouched_low']>0, label
    memory[label]=rows[0]
for group in ('ref','c','asm'):
    log=(OUT/'build_logs'/('fp64-inlineasm-'+group+'-perf-build.log')).read_text()
    for region in ('FLASH','RAM'):
        match=re.search(r'^\s*'+region+r':\s*(\d+) B',log,re.M)
        assert match
        memory[group+'-perf'][region+'_region_bytes']=int(match[1])

crypto_files=lambda p:{x.name:sha(x) for x in p.iterdir() if x.suffix in ('.c','.h','.s')}
baseline,candidate=crypto_files(BASE),crypto_files(ROOT.parent)
assert set(baseline)==set(candidate)
changed=[name for name in baseline if baseline[name]!=candidate[name]]
assert changed==['kgen_fxp.c'], changed
def without_mul(text):
    begin=text.index('\nfp64_exact\nfp64e_mul(')
    end=text.index('\n/* Convert through 32-bit limbs:',begin)
    return text[:begin]+text[end:]
assert without_mul((BASE/'kgen_fxp.c').read_text())==without_mul((ROOT.parent/'kgen_fxp.c').read_text())
old_host=json.loads((BASE/'validation/build/host/summary.json').read_text())
assert baseline==old_host['source'], 'Existing C baseline changed since prior validation'
for directory, hashes in old_host['preserved'].items():
    assert crypto_files(Path(directory))==hashes, directory

tool=ROOT.parents[4]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
machine=[]
for label in ('c-perf','asm-perf'):
    elf=ROOT/'build'/label/'zephyr/zephyr.elf'
    row={'label':label,'elf_sha256':sha(elf),'functions':[]}
    for function in ('fndsa_fp64e_mul','fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact'):
        asm=subprocess.check_output([str(tool),'-d','--disassemble='+function,str(elf)],text=True)
        (OUT/'static'/(label+'-'+function+'.asm')).write_text(asm)
        ins=[]
        for line in asm.splitlines():
            m=re.match(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{4}\s+)+\s*([a-z][a-z0-9.]*)\s*(.*)',line)
            if m and m[1]!='.word': ins.append(m.groups())
        calls=[args for op,args in ins if op in ('bl','blx','bl.w','blx.w')]
        row['functions'].append(dict(name=function,instructions=len(ins),
            conversions=sum(op.startswith('vcvt') for op,_ in ins),
            FP64_ops=sum('.f64' in op for op,_ in ins),calls=calls,
            save_restore=[(op,args) for op,args in ins if op in ('vpush','vpop','push','pop')]))
    su=[]
    for path in (ROOT/'build'/label).rglob('*.su'):
        for line in path.read_text().splitlines():
            if any(name in line for name in ('fndsa_fp64e_mul','fndsa_vect_FFT_fp64_exact','fndsa_vect_iFFT_fp64_exact','solve_NTRU_intermediate')):
                su.append(line)
    row['gcc_stack_usage_records']=su
    machine.append(row)

static=json.loads((OUT/'static/summary.json').read_text())
assert all(x['elf_sha256']==runs[x['label']]['elf_sha256'] for x in static)
summary=dict(performance=performance,profile=profiles,kernels=kernels,
    differential=diff[0],oracle=oracle,kat_count=300,
    key_and_signature_digests_equal=200,changed_crypto_files=changed,
    previous_candidates_preserved=list(old_host['preserved']),c_baseline_preserved=True,
    mul=mul_summary,CT_ops=op_summary,CT_FFT=fft_summary,
    observed_input_minima_equal=ct_all_input_minima_equal,
    memory=memory,machine=machine,
    runs={label:dict(run_dir=runs[label]['run_dir'],elf_sha256=runs[label]['elf_sha256'],raw_sha256=runs[label]['raw_sha256']) for label in LABELS},
    caveats=['One 100-seed batch per group, not repeated-batch confidence intervals.',
             'Same placement policy, not identical function addresses.',
             'Inline assembly not validated by a host sanitizer.',
             'Observed timing and source/ELF review are not a complete constant-time proof.',
             'Primitive timing includes same-ABI conversion wrappers, loop, indirect call and sink.'])
(OUT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:summary[k] for k in ('performance','profile','differential','mul','observed_input_minima_equal','memory','machine')},indent=2))
