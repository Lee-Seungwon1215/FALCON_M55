#!/usr/bin/env python3
"""Offline verification and statistics for the completed sparse-TCM run."""
from datetime import datetime
import hashlib
import json
from pathlib import Path
import re
import statistics
from run import validate_measurements

ROOT = Path(__file__).resolve().parent

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    accepted = json.loads((ROOT / 'full_validated.json').read_text())
    path = Path(accepted['run_directory'])
    meta = json.loads((path / 'run.json').read_text())
    manifest = json.loads((ROOT / 'audit-dtcm/build_manifest.json').read_text())
    assert accepted['valid'] and meta['valid'] and meta['returncode'] == 0
    assert sha(path / 'raw.log') == meta['raw_log_sha256']
    assert sha(ROOT / 'audit-dtcm/build_manifest.json') == meta['source_manifest_sha256']
    assert sha(ROOT / 'host/full.log') == meta['host_expected_log_sha256']
    assert sha(ROOT / 'build-dtcm/zephyr/zephyr.elf') == (
        meta['elf_sha256']) == accepted['elf_sha256'] == manifest['elf_sha256']
    assert sha(ROOT / 'exec_with_tcm_init.py') == meta['loader_adapter_sha256']
    for name, rec in manifest['sources'].items():
        assert sha(ROOT.parent / 'ref' / name) == rec['m55_sha256'], name
    for file, key in [('app/benchmark.c', 'benchmark_sha256'),
                      ('app/dtcm_startup.s', 'startup_adapter_sha256'),
                      ('app/generate_dtcm_linker.py', 'linker_generator_sha256')]:
        assert sha(ROOT / file) == manifest[key], file
    raw = (path / 'raw.log').read_text()
    samples, errors = validate_measurements(raw, False)
    assert not errors and samples == meta['samples'] and len(samples) == 60
    expected = re.findall(r'^(?:DIGEST|AUDIT) degree=.+$',
                          (ROOT / 'host/full.log').read_text(), re.M)
    assert len(expected) == 22
    assert re.findall(r'^(?:DIGEST|AUDIT) degree=.+$', raw, re.M) == expected
    assert 'FNDSA_DONE correctness=PASS tamper_rejection=PASS' in raw.splitlines()
    for reg in ('CFSR', 'HFSR', 'AFSR'):
        assert re.findall(rf'^{reg}=(.+)$', raw, re.M) == ['0x0']
    assert re.findall(r'^TCM_MSCR_(START|END)=(.+)$', raw, re.M) == [
        ('START', '0x1300a'), ('END', '0x1300a')]
    assert 'CLOCK_DECODE cpu=800000000 sysclk=400000000 hclk=200000000' in raw
    assert re.findall(r'^CCR=(.+)$', raw, re.M) == ['0x611']
    timer = re.search(r'^TIMER selfcheck_100ms_zephyr=(\d+) dwt=(\d+) error=(\d+)$', raw, re.M)
    z, dwt, delta = map(int, timer.groups())
    assert 79000000 <= z <= 81000000 and abs(z - dwt) == delta <= 20000
    records = []
    for degree in (512, 1024):
        for op, name in enumerate(('keygen', 'sign', 'verify')):
            totals = sorted(s['total'] for s in samples
                            if s['degree'] == degree and s['operation'] == op)
            assert len(totals) == 10
            upper = totals[5] // 10
            records.append(dict(degree=degree, operation=name,
                measured_calls=100, warmup_calls=100, independent_batch_inputs=10,
                upper_median_cycles=upper, upper_median_ms_at_800mhz=upper/800000,
                mean_cycles=sum(totals)/100,
                min_batch_mean_cycles=totals[0]/10,
                max_batch_mean_cycles=totals[-1]/10,
                sd_of_batch_means=statistics.stdev(x/10 for x in totals)))
    wall = (datetime.fromisoformat(meta['ended_utc']) -
            datetime.fromisoformat(meta['started_utc'])).total_seconds()
    measured_s = sum(s['total'] for s in samples) / 800000000
    assert measured_s < wall
    result = dict(valid=True, run_directory=str(path.relative_to(ROOT)),
        started_utc=meta['started_utc'], ended_utc=meta['ended_utc'],
        elf_sha256=meta['elf_sha256'], raw_sha256=meta['raw_log_sha256'],
        measured_calls=600, warmup_calls=600, batch_records=60,
        ecc_check_enabled=True, fault_registers_zero=True, host_digests_match=True,
        cpu_sys_hclk_mhz=[800, 400, 200], icache_enabled=False, dcache_enabled=False,
        timer_selfcheck=dict(zephyr=z, dwt=dwt, difference=delta),
        wall_seconds=wall, summed_measured_seconds_at_nominal_cpu=measured_s,
        memory_note=manifest['memory_layout_deviation'], statistics=records,
        interpretation='Upper median of 10 measured block totals divided by 10. '
                       'Not a 100-independent-input distribution or pure M4/M55 core comparison.')
    (ROOT / 'results.json').write_text(json.dumps(result, indent=2) + '\n')
    print('PASS: exact ELF/source/adapter/log hashes; 60 blocks = 600 measured calls.')
    print('PASS: 22 host digests, ECC ON, fault registers zero, clocks/cache/timer.')
    for r in records:
        print(f"{r['degree']} {r['operation']}: {r['upper_median_cycles']:,} cycles, "
              f"{r['upper_median_ms_at_800mhz']:.6f} ms; mean={r['mean_cycles']:.2f}")
    print(f'PASS: measured {measured_s:.6f} s < whole-run {wall:.6f} s.')

if __name__ == '__main__':
    main()
