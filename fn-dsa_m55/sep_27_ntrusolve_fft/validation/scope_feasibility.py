#!/usr/bin/env python3
"""Recompute conditional time floors from frozen, integrity-checked logs.

No firmware builds or board access. Do not mix profiled and plain timings.
This is measured-work accounting, not an algorithmic impossibility proof.
"""
import hashlib
import json
import re
import subprocess
import sys
import tempfile
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
DEGREES = (512, 1024)
SCOPE = frozenset((
    'I_input', 'I_fft', 'I_recip', 'I_mul', 'I_ifft', 'I_round',
    'D_input', 'D_fft', 'D_div', 'D_ifft', 'D_round',
))
RUNS = {
    'M55_ref': ('baseline_m55', '20260927T140919Z', '20260927T141357Z'),
    'ntt_opt': ('baseline_ntt', '20260927T140452Z', '20260927T142645Z'),
    'A16': ('A_tw_bridge', '20260927T234659Z', '20260927T234807Z'),
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_run(candidate, mode, run):
    directory = HERE / 'results' / candidate / mode / run
    manifest = directory / 'manifest.json'
    meta = json.loads(manifest.read_text())
    assert meta['candidate'] == candidate and meta['mode'] == mode
    assert meta['valid_measurement'] and not meta['errors'], directory
    assert digest(directory / 'raw.log') == meta['raw_sha256'], directory
    assert digest(directory / 'benchmark.elf') == meta['elf_sha256'], directory
    for path in (ROOT / candidate).glob('*.[chs]'):
        assert meta['source_sha256'].get(str(path)) == digest(path), path
    # OpenOCD status messages can interrupt a line in the captured stream.
    raw = re.sub(r'Info : [^\n]*\n', '', (directory / 'raw.log').read_text())
    rows = re.findall(
        r'^KEYGEN_SUMMARY degree=(\d+) calls=(\d+) total=(\d+)', raw, re.M)
    assert len(rows) == 2 and {int(d) for d, _, _ in rows} == set(DEGREES)
    totals = {int(d): int(t) for d, n, t in rows if int(n) == 100}
    assert set(totals) == set(DEGREES)
    evidence = {
        'manifest': str(manifest.relative_to(HERE)),
        'manifest_sha256': digest(manifest),
        'raw_sha256': meta['raw_sha256'], 'elf_sha256': meta['elf_sha256'],
    }
    return raw, totals, evidence


profiles, plain, evidence, counts = {}, {}, {}, {}
profile_manifests = {}
for label, (candidate, profile_run, plain_run) in RUNS.items():
    raw, totals, pe = load_run(candidate, 'profile', profile_run)
    _, plain_totals, ke = load_run(candidate, 'keygen', plain_run)
    evidence[label] = {'profile': pe, 'plain': ke}
    profile_manifests[label] = json.loads((HERE / pe['manifest']).read_text())
    ops = {d: defaultdict(int) for d in DEGREES}
    counts[label] = {}
    matches = re.findall(
        r'^IPRO degree=(\d+) op=(\w+) logn=(\d+) calls=(\d+) '
        r'cycles=(\d+) success=(\d+)$', raw, re.M)
    for degree, op, logn, calls, cycles, success in matches:
        key = (int(degree), op, int(logn))
        assert key not in counts[label], key
        counts[label][key] = (int(calls), int(success))
        ops[int(degree)][op] += int(cycles)
    reported = re.findall(
        r'^IPRO_TOTAL degree=(\d+) cycles=(\d+) top=(\d+) '
        r'ortho_leaves=(\d+) ntru_leaves=(\d+) errors=(\d+)$', raw, re.M)
    assert len(reported) == 2
    for degree, total, top, ortho, ntru, errors in reported:
        d, values = int(degree), ops[int(degree)]
        assert int(errors) == 0 and int(total) == totals[d]
        assert int(top) == sum(values[o] for o in ('sample', 'invert', 'ortho', 'ntru', 'finish'))
        assert int(ortho) == sum(c for o, c in values.items() if o.startswith('O_'))
        assert int(ntru) == sum(values[o] for o in SCOPE) + values['I_update']
        assert int(ntru) <= values['ntru'] and int(top) <= totals[d]
    profiles[label] = {
        d: {'total': totals[d] / 100, 'scope': sum(ops[d][o] for o in SCOPE) / 100,
            'integer_update': ops[d]['I_update'] / 100,
            'operations': {o: v / 100 for o, v in ops[d].items()}}
        for d in DEGREES
    }
    plain[label] = {d: plain_totals[d] / 100 for d in DEGREES}

# The generator evolved to recognize new A/B entry points. Test its actual
# output, not the false assumption that all historical generator hashes match.
common_names = ('board_keygen_perf.c', 'integration_profile.c',
                'integration_profile.h', 'generated/upstream_kat.h')
common_hashes = {
    label: {name: meta['source_sha256'][str(HERE / name)] for name in common_names}
    for label, meta in profile_manifests.items()
}
assert common_hashes['M55_ref'] == common_hashes['ntt_opt'] == common_hashes['A16']
generator = HERE / 'generate_integration_profile.py'
replayed = {}
with tempfile.TemporaryDirectory(prefix='sep27-scope-replay-', dir='/private/tmp') as temp:
    for label, (candidate, _, _) in RUNS.items():
        output = Path(temp) / candidate
        subprocess.run([sys.executable, str(generator), str(ROOT / candidate),
                        str(output), 'integer'], check=True, capture_output=True, text=True)
        expected = profile_manifests[label]['source_sha256']
        files = {}
        for name in ('kgen.c', 'kgen_ntru.c', 'integration_bench.c', 'integration_manifest.json'):
            key = next(k for k in expected if k.endswith('/generated/' + name))
            actual = digest(output / name)
            assert actual == expected[key], (label, name, 'instrumentation changed')
            files[name] = actual
        replayed[label] = {
            'historical_generator_sha256': expected[str(generator)],
            'current_generator_sha256': digest(generator),
            'all_generated_files_match_archived_measurement': True,
            'generated_sha256': files,
        }

# Equality of observed aggregate counts is evidence, not a trace/equivalence proof.
assert len(counts['A16']) == 218
assert counts['M55_ref'] == counts['ntt_opt'] == counts['A16']
rows = {}
for d in DEGREES:
    a, base = profiles['A16'][d], profiles['M55_ref'][d]
    op = a['operations']
    parts = {
        'sample': op['sample'], 'invert': op['invert'], 'ortho': op['ortho'],
        'NTRU_FFT_scope': a['scope'], 'NTRU_integer_update': a['integer_update'],
        'NTRU_other': op['ntru'] - a['scope'] - a['integer_update'],
        'finish': op['finish'],
        'outer_residual': a['total'] - sum(op[x] for x in ('sample', 'invert', 'ortho', 'ntru', 'finish')),
    }
    assert min(parts.values()) >= 0 and abs(sum(parts.values()) - a['total']) < 1e-5
    fft_floor = a['total'] - a['scope']
    wider_floor = fft_floor - a['integer_update']
    rows[d] = {
        'plain_actual_speedup_vs_M55_ref': plain['M55_ref'][d] / plain['A16'][d],
        'plain_time_reduction_vs_ntt_opt_pct': 100 * (1 - plain['A16'][d] / plain['ntt_opt'][d]),
        'plain_target_1_7_cycles': plain['M55_ref'][d] / 1.7,
        'plain_additional_saving_required': plain['A16'][d] - plain['M55_ref'][d] / 1.7,
        'profile_zero_scope_floor': fft_floor,
        'profile_zero_scope_speedup_vs_M55_ref': base['total'] / fft_floor,
        'profile_zero_scope_and_integer_update_floor': wider_floor,
        'profile_zero_scope_and_integer_update_speedup_vs_M55_ref': base['total'] / wider_floor,
        'profile_nonoverlapping_partition': parts,
        'profile_partition_pct': {o: 100 * c / a['total'] for o, c in parts.items()},
    }

out = {
    'claim': 'Conditional accounting with all unremoved work fixed; not a new speed measurement or universal bound',
    'scope_leaf_names': sorted(SCOPE), 'common_profile_count_success_rows': 218,
    'common_harness_seed_hashes': common_hashes['M55_ref'],
    'instrumentation_replay': replayed,
    'evidence': evidence, 'plain_means': plain, 'profile_means': profiles, 'analysis': rows,
}
(HERE / 'scope_feasibility.json').write_text(json.dumps(out, indent=2) + '\n')
lines = [
    '# NTRU FFT 범위와 1.7배 목표 재검토', '',
    '분석 대상은 A16. **새 보드 측정이 아니라 보존된 원시 로그의 재집계**다. '
    '소스·ELF·로그 해시와 정상 완료를 확인한 뒤 계산한다. 원본과 ntt_opt는 변경하지 않았다.', '',
    '## 실제 전체 키생성 — 비계측 빌드', '',
    '| 항목 | 512 | 1024 |', '| --- | ---: | ---: |',
]
for label in RUNS:
    lines.append(f'| {label} cycles | {plain[label][512]:,.2f} | {plain[label][1024]:,.2f} |')
for label, field, suffix in (
    ('M55_ref/A16 속도 배율', 'plain_actual_speedup_vs_M55_ref', '×'),
    ('ntt_opt 대비 A16 시간 감소', 'plain_time_reduction_vs_ntt_opt_pct', '%'),
    ('1.7배에 필요한 시간 상한', 'plain_target_1_7_cycles', ''),
    ('A16에서 더 줄여야 할 cycles', 'plain_additional_saving_required', ''),
):
    lines.append('| ' + label + ' | ' + ' | '.join(f'{rows[d][field]:,.4f}{suffix}' for d in DEGREES) + ' |')
lines += [
    '', '## A16 전체 연산 비중 — 계측 빌드', '',
    '| 서로 겹치지 않는 구간 | 512 | 1024 |', '| --- | ---: | ---: |',
]
names = {
    'sample': '후보 샘플링', 'invert': '가역성 검사', 'ortho': '후보 직교노름 검사 (범위 밖)',
    'NTRU_FFT_scope': 'NTRU FFT·입력·역수·곱셈·나눗셈·반올림 (대상)',
    'NTRU_integer_update': 'NTRU 정수 다항식 갱신 I_update (범위 밖)',
    'NTRU_other': '나머지 NTRU: 축소·복원·CRT·Bezout·제어·계측 잔여 등',
    'finish': '키 마무리', 'outer_residual': '외부 제어·계측 잔여',
}
for key, name in names.items():
    lines.append('| ' + name + ' | ' + ' | '.join(f'{rows[d]["profile_partition_pct"][key]:.3f}%' for d in DEGREES) + ' |')
lines += [
    '| 합계 (반올림 전) | 100% | 100% |', '',
    '`ortho`, `ntru`, `intermediate`, `deepest`는 자식 구간을 포함하는 부모다. '
    '부모와 자식을 합산하지 않았으며 I_update도 FFT 분자에 넣지 않았다. '
    '원본·ntt_opt·A16의 218개 (크기, 구간, logn) 행에서 호출·성공 횟수가 모두 같다. '
    '이는 이 입력 집합의 집계 일치이지 전체 입력의 동일 실행 추적 증명은 아니다.', '',
    '측정 본체·타이머·입력 seed의 해시도 같다. 계측 코드 생성기는 후보 함수 지원 때문에 '
    '과거 버전과 해시가 다르지만, 현재 생성기로 세 소스를 임시 경로에 다시 처리한 결과 '
    '각 측정 당시의 C 파일 3개와 계측 manifest가 모두 바이트 단위로 일치했다. '
    '원본 암호 소스를 복구할 수 있다는 생성기 검사도 통과했다.', '',
    '## 다른 작업량·시간을 고정한 가정 계산', '',
    '| 가정 | 512 M55_ref 대비 | 1024 M55_ref 대비 |', '| --- | ---: | ---: |',
]
for label, field in (
    ('A16의 대상 FFT 구간을 전부 0 cycles로 가정', 'profile_zero_scope_speedup_vs_M55_ref'),
    ('위 구간과 I_update까지 모두 0 cycles로 가정 (범위 밖 참고)', 'profile_zero_scope_and_integer_update_speedup_vs_M55_ref'),
):
    lines.append('| ' + label + ' | ' + ' | '.join(f'{rows[d][field]:.4f}×' for d in DEGREES) + ' |')
lines += [
    '',
    '식: M55_ref 계측 전체 / (A16 계측 전체 − 제거한다고 가정한 서로 겹치지 않는 구간). '
    '**실측 가속률이 아니며 실제 최적화가 0 cycles가 된다는 뜻도 아니다.** '
    '기존 NTT 개선은 이미 A16의 나머지 시간에 포함된다. '
    '비계측 전체 시간과 계측 비중을 섞지 않았다. 타이머·집계 비용은 보정해서 빼지 않았다.', '',
    '1024는 기록된 FFT 구간과 정수 갱신을 모두 없애는 가정에서도 1.7배 미만이다. '
    '따라서 동일한 나머지 작업을 유지한 채 이 구간의 명령어만 줄이는 접근으로는 목표를 설명할 수 없다. '
    '그러나 새 알고리즘이 재시도·CRT·복원·부모 제어 작업까지 바꾸면 이 고정작업 가정이 깨진다. '
    '**모든 Babai 변형이나 모든 구현에 대한 불가능성 증명은 아니다.**', '',
    '반복 정책·정수 갱신·다른 키생성 단계의 구현 변경은 별도 범위 판단이 필요하며 이번 분석에서는 하지 않았다. '
    'A16의 기존 KAT·서명·시간 관련 유한 검증 상태는 그대로이고, 목표를 달성했다고 표시하지 않는다.', '',
    '## 재현·근거', '',
    '- `python3 validation/scope_feasibility.py`',
    '- [기계 판독 수치·해시](scope_feasibility.json)',
    '- [관련 논문과 실제 solver 비교](../research/babai_scope_review.md)',
]
for label, runs in evidence.items():
    for mode, item in runs.items():
        lines.append(f'- [{label} {mode}]({item["manifest"]})')
(HERE / 'scope_feasibility.md').write_text('\n'.join(lines) + '\n')
print('SCOPE_OK count_success_rows=218; current source/log/ELF checks passed')
for d in DEGREES:
    print(f'{d}: actual={rows[d]["plain_actual_speedup_vs_M55_ref"]:.4f}x; '
          f'zero-FFT hypothetical={rows[d]["profile_zero_scope_speedup_vs_M55_ref"]:.4f}x; '
          f'zero-FFT+update hypothetical={rows[d]["profile_zero_scope_and_integer_update_speedup_vs_M55_ref"]:.4f}x')
