#!/usr/bin/env python3
"""Audit identical-seed whole-keygen records; no board access or new timings."""
import hashlib
import json
import re
import shlex
import statistics
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
RUNS = {
    'M55_ref': ('baseline_m55', '20260927T141357Z'),
    'ntt_opt': ('baseline_ntt', '20260927T142645Z'),
    'A16': ('A_tw_bridge', '20260927T234807Z'),
    'B18': ('B_continuous_ds', '20260927T211520Z'),
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


evidence, samples, hardware, harness = {}, {}, {}, {}
for label, (candidate, run) in RUNS.items():
    directory = HERE / 'results' / candidate / 'keygen' / run
    path = directory / 'manifest.json'
    meta = json.loads(path.read_text())
    assert meta['valid_measurement'] and not meta['errors']
    assert meta['candidate'] == candidate and meta['mode'] == 'keygen'
    assert sha(directory / 'raw.log') == meta['raw_sha256']
    assert sha(directory / 'benchmark.elf') == meta['elf_sha256']
    crypto = ROOT / candidate
    for source in crypto.glob('*.[chs]'):
        assert not source.is_symlink(), source
        assert meta['source_sha256'].get(str(source)) == sha(source), source
    compiled = []
    for command in meta['compile_commands']:
        source = Path(command['file'])
        assert source.parent == crypto, (label, source)
        flags = shlex.split(command['command'])
        assert [f for f in flags if re.fullmatch(r'-O[0-3sgz]', f)][-1] == '-O3'
        assert [f for f in flags if f.startswith('-mfpu=')][-1] == '-mfpu=fpv5-d16'
        assert all(f in flags for f in (
            '-mcpu=cortex-m55', '-mfloat-abi=hard', '-ffp-contract=off',
            '-fno-fast-math', '-fno-strict-aliasing'))
        compiled.append(source.name)
    assert len(compiled) >= 23
    raw = re.sub(r'Info : [^\n]*\n', '', (directory / 'raw.log').read_text())
    headers = re.findall(r'^KEYGEN_HW (.*)$', raw, re.M)
    assert len(headers) == 1
    hardware[label] = dict(field.split('=', 1) for field in headers[0].split())
    harness[label] = {name: meta['source_sha256'][str(HERE / name)] for name in (
        'board_keygen_perf.c', 'generated/upstream_kat.h')}
    assert raw.count('KEYGEN_DONE count=200 mismatches=0') == 1
    matches = re.findall(
        r'^KEYGEN_PERF degree=(\d+) index=(\d+) cycles=(\d+) '
        r'match=1 equation=PASS keyhash=([0-9a-f]{64})$', raw, re.M)
    assert len(matches) == 200
    samples[label] = {(int(d), int(i)): (int(c), h) for d, i, c, h in matches}
    assert set(samples[label]) == {(d, i) for d in (512, 1024) for i in range(100)}
    totals = re.findall(r'^KEYGEN_SUMMARY degree=(\d+) calls=100 total=(\d+)', raw, re.M)
    assert len(totals) == 2
    for d, total in totals:
        assert sum(samples[label][int(d), i][0] for i in range(100)) == int(total)
    evidence[label] = {
        'manifest': str(path.relative_to(HERE)), 'manifest_sha256': sha(path),
        'elf_sha256': meta['elf_sha256'], 'raw_sha256': meta['raw_sha256'],
        'own_compiled_crypto_files': sorted(compiled),
    }

for label in RUNS:
    assert harness[label] == harness['M55_ref']
    assert hardware[label] == hardware['M55_ref']
    assert all(samples[label][key][1] == samples['M55_ref'][key][1]
               for key in samples['M55_ref'])

comparisons = []
for label in ('ntt_opt', 'A16', 'B18'):
    for reference in ('M55_ref', 'ntt_opt'):
        if label == reference:
            continue
        for degree in (512, 1024):
            before = [samples[reference][degree, i][0] for i in range(100)]
            after = [samples[label][degree, i][0] for i in range(100)]
            ratios = [x / y for x, y in zip(before, after)]
            comparisons.append({
                'candidate': label, 'reference': reference, 'degree': degree,
                'ratio_of_means': sum(before) / sum(after),
                'per_seed_min': min(ratios), 'per_seed_median': statistics.median(ratios),
                'per_seed_max': max(ratios),
                'faster_seed_count': sum(x > y for x, y in zip(before, after)),
                'at_least_1_7_seed_count': sum(10*x >= 17*y for x, y in zip(before, after)),
                'per_seed_ratios': ratios,
            })

out = {
    'claim': 'Paired analysis of archived whole-keygen runs, not new measurement or statistical proof',
    'degree_seed_pairs': 200, 'encoded_key_hashes_match_all_four': True,
    'same_hardware_header': hardware['M55_ref'], 'common_harness_hashes': harness['M55_ref'],
    'evidence': evidence, 'comparisons': comparisons,
}
(HERE / 'paired_keygen_audit.json').write_text(json.dumps(out, indent=2) + '\n')
lines = [
    '# 동일 seed의 전체 키생성 재검토', '',
    'A16/B18 및 기준 구현의 보존된 비계측 보드 로그를 분석했다. 새 보드 측정이 아니다. '
    '각 크기 100개 seed에서 재시도·변환·키 인코딩을 포함한다.', '',
    '소스·ELF·로그 해시, 200개 입력 index, KAT/정수 방정식 통과, 기록된 총합을 재확인했다. '
    '네 구현의 동일 입력별 공개키·비밀키 인코딩 SHA-256도 모두 일치한다. '
    '같은 측정 본체·KAT 입력 해시, 하드웨어 헤더 및 암호 파일별 컴파일 옵션을 확인했다. '
    '암호 파일은 각 후보의 실제 로컬 파일이며 다른 후보의 소스를 컴파일하지 않는다.', '',
    '| 후보 / 기준 | 크기 | 평균 시간의 비 | seed별 최소 | seed별 중앙값 | seed별 최대 | 빠른 seed | 1.7배 이상 seed |',
    '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
]
for row in comparisons:
    lines.append(
        f'| {row["candidate"]} / {row["reference"]} | {row["degree"]} | '
        f'{row["ratio_of_means"]:.4f}× | {row["per_seed_min"]:.4f}× | '
        f'{row["per_seed_median"]:.4f}× | {row["per_seed_max"]:.4f}× | '
        f'{row["faster_seed_count"]}/100 | {row["at_least_1_7_seed_count"]}/100 |')
lines += [
    '',
    '배율은 기준 시간/후보 시간이다. 평균 시간의 비와 개별 배율의 중앙값은 서로 다른 통계다. '
    '100개 고정 입력을 분석한 것이므로 전체 입력 분포·통계적 유의성·상수시간의 증명은 아니다. '
    '함수 주소를 모두 고정한 실험도 아니다. 후보 선택에 불리한 seed를 제외하지 않았다.', '',
    '원본 KAT와 성능 조건을 유지한 개선은 확인되지만 1.7배 목표는 달성하지 못했다. '
    '이 표 자체로 모든 새로운 알고리즘의 성능 상한을 주장하지 않는다.', '',
    '- 재현: `python3 validation/paired_keygen_audit.py`',
    '- [전체 수치·입력별 배율·해시](paired_keygen_audit.json)',
    '- [조건부 시간 범위 분석](scope_feasibility.md)',
]
for label, item in evidence.items():
    lines.append(f'- [{label} 원시 측정 manifest]({item["manifest"]})')
(HERE / 'paired_keygen_audit.md').write_text('\n'.join(lines) + '\n')
print('PAIRED_OK seeds=200 implementations=4 keys_match=200 own_source_compile_checks=4')
for row in comparisons:
    if row['candidate'] == 'A16' and row['reference'] == 'M55_ref':
        print(f'A16/{row["degree"]}: range={row["per_seed_min"]:.4f}..{row["per_seed_max"]:.4f}x; '
              f'target_met_seeds={row["at_least_1_7_seed_count"]}/100')
