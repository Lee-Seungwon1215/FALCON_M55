#!/usr/bin/env python3
"""Check current-source provenance and report exclusive signing shares."""
import hashlib
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
CRYPTO = HERE.parents[1]
WORKSPACE = HERE.parents[4]

# This writer describes and preserves the pre-scheduling observation.
# The integrated ASM revision has a separate report and aggregator.
if (CRYPTO / 'sign_ldl_cm55.s').exists():
    raise SystemExit('Historical report is preserved. Use validation/analyze_schedule.py for the integrated ASM revision.')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(directory, mode):
    directory = directory.resolve()
    manifest = json.loads((directory / 'manifest.json').read_text())
    assert manifest['valid_measurement'] and not manifest['errors']
    assert manifest['mode'] == mode and Path(manifest['crypto_root']) == CRYPTO
    assert sha(directory / 'raw.log') == manifest['raw_sha256']
    assert sha(directory / 'benchmark.elf') == manifest['elf_sha256']
    for path in CRYPTO.iterdir():
        if path.suffix in ('.c', '.h', '.s') or path.name == 'Makefile':
            assert manifest['source_sha256'][str(path)] == sha(path), path
    text = re.sub(r'Info : [^\n]*\n', '', (directory / 'raw.log').read_text())
    assert 'PROFILE_STATUS error=0 result=0' in text
    result = {'directory': str(directory), 'mode': mode, 'degrees': {}}
    for n, fingerprint in ((512, '9895079d'), (1024, 'a020dd02')):
        assert f'PROFILE_FINGERPRINT degree={n} fnv1a={fingerprint}' in text
        total = re.search(rf'^PROFILE_TOTAL degree={n} operation=sign calls=100 total=(\d+) min=(\d+) max=(\d+)$', text, re.M)
        assert total
        cats = {m[1]: {'cycles': int(m[2]), 'calls': int(m[3])} for m in re.finditer(
            rf'^PROFILE_CATEGORY degree={n} operation=sign category=(\w+) cycles=(\d+) entries=(\d+)$', text, re.M)}
        assert len(cats) == (32 if mode == 'sign_detail' else 24)
        ticks = int(total[1])
        assert sum(row['cycles'] for row in cats.values()) == ticks
        if mode == 'sign_detail':
            nodes = n // 2 - 1
            expected = {'sg_fft': 5, 'sg_ifft': 2, 'sg_ldl': nodes,
                'sg_split': 2*nodes, 'sg_split_selfadj': 2*nodes,
                'sg_merge': 2*nodes, 'sg_mul': nodes+2, 'sg_add': nodes,
                'sg_sub': nodes, 'sg_deepest': n//2, 'sg_gaussian_berexp': 2*n,
                'sg_gram': 1, 'sg_target': 1, 'sg_ldl_ffsampling': 1}
            for category, calls in expected.items():
                assert cats[category]['calls'] == 100*calls, (n, category, cats[category])
        else:
            assert cats['other']['cycles'] == ticks
            assert all(row['calls'] == 0 for row in cats.values())
        result['degrees'][str(n)] = {'total': ticks, 'mean': ticks/100,
            'min': int(total[2]), 'max': int(total[3]), 'fingerprint': fingerprint,
            'categories': cats}
    return result


paths = list(map(Path, sys.argv[1:]))
assert len(paths) >= 4 and len(paths) % 2 == 0, 'detail control [detail control ...], at least two pairs'
runs = [load(path, 'sign_detail' if i % 2 == 0 else 'sign_control') for i, path in enumerate(paths)]
details = runs[::2]
controls = runs[1::2]
labels = [
    ('sg_fft', '`fpoly_FFT()`'), ('sg_ifft', '`fpoly_iFFT()`'),
    ('sg_ldl', '`fpoly_LDL_fft()` — native FP64'),
    ('sg_split', '`fpoly_split_fft()`'),
    ('sg_merge', '`fpoly_merge_fft()`'),
    ('sg_split_selfadj', '`fpoly_split_selfadj_fft()`'),
    ('sg_mul', '`fpoly_mul_fft()`'), ('sg_add', '`fpoly_add()`'),
    ('sg_sub', '`fpoly_sub()`'), ('sg_gram', '`fpoly_gram_fft()`'),
    ('sg_target', '`fpoly_apply_basis()` — FFT·점별 곱셈 제외'),
    ('sg_deepest', '`ffsamp_fft_deepest()` — sampler 제외'),
    ('sg_gaussian_berexp', '`sampler_next()` — 내부 `ber_exp()`·Gaussian 포함'),
    ('sg_ldl_ffsampling', 'ffSampling 재귀 제어·복사·계측 잔여'),
]
selected = {key for key, _ in labels}
summary = {'source': str(CRYPTO), 'runs': runs, 'degrees': {}}
old_path = WORKSPACE / 'Final_code/validation/sign_profile/detail_data.json'
old = json.loads(old_path.read_text())
for n in ('512', '1024'):
    ticks = sum(run['degrees'][n]['total'] for run in details)
    calls = 100 * len(details)
    cats = {key: {'cycles': sum(run['degrees'][n]['categories'][key]['cycles'] for run in details),
                  'calls': sum(run['degrees'][n]['categories'][key]['calls'] for run in details)}
            for key in details[0]['degrees'][n]['categories']}
    for row in cats.values():
        row['mean_cycles'] = row['cycles']/calls
        row['percent'] = 100*row['cycles']/ticks
        row['calls_per_sign'] = row['calls']/calls
    other_ticks = sum(row['cycles'] for key, row in cats.items() if key not in selected)
    cats['remainder'] = {'cycles': other_ticks, 'mean_cycles': other_ticks/calls,
                         'percent': 100*other_ticks/ticks}
    assert sum(cats[key]['cycles'] for key in selected) + other_ticks == ticks
    control_mean = sum(run['degrees'][n]['total'] for run in controls)/(100*len(controls))
    summary['degrees'][n] = {'mean_profile_cycles': ticks/calls,
        'mean_control_cycles': control_mean,
        'instrumentation_delta_percent': 100*((ticks/calls)/control_mean-1),
        'split_merge_percent': cats['sg_split']['percent'] + cats['sg_merge']['percent'],
        'categories': cats,
        'historical_pre_ldl': old['degrees'][n]}

(HERE / 'data.json').write_text(json.dumps(summary, indent=2) + '\n')
d512, d1024 = (summary['degrees'][n] for n in ('512', '1024'))
lines = [
    '# 현재 6_sign_fft 서명 함수별 연산 비중',
    '', '2026-09-28. FFT/iFFT A5 ASM + native FP64 LDL이 적용된 현재 코드의 M55 실측.',
    'LDL 수동 스케줄링 및 split·merge FP64 전환은 아직 구현하지 않았다.',
    '이번 작업은 계측·측정만 수행했으며 생산 C/H/S·Makefile은 변경하지 않았다.',
    '', '## 분모와 중첩 처리', '',
    '- 분모는 **내부 계측 ON 상태의 전체 서명 API 시간**이다. 키생성·검증·로그 출력은 제외한다.',
    '- 각 행은 중첩을 뺀 배타적 시간이다. 원시 사이클 합은 전체 시간과 정확히 일치한다.',
    '- `apply_basis` 내부 FFT·점별 곱셈은 FFT·곱셈 행에만 포함한다.',
    '- `deepest` 내부 sampler 호출은 sampler 행에만 포함한다.',
    '- `sampler_next`에는 `ber_exp`, Gaussian, PRNG, 정수 산술과 거부 루프도 포함한다. **전체가 FP64 전환 가능한 시간은 아니다.**',
    '- 함수별 실제 서명 누적 비중이며 명령어별 산술 비중이나 단독 커널 성능이 아니다.',
    '- 512·1024 각각 100개 서명, 상세/control 각 2회 이상 동일 입력 실행의 합산 비중이다.',
    '', '## 전체 서명 100% 표', '',
    '| 함수·구간 | 512 평균 cycles/서명 | 512 비중 | 1024 평균 cycles/서명 | 1024 비중 |',
    '|---|---:|---:|---:|---:|',
]
for key, label in labels + [('remainder', '기타 키 준비·해시·후처리·인코딩·계측 잔여')]:
    a, b = d512['categories'][key], d1024['categories'][key]
    lines.append(f"| {label} | {a['mean_cycles']:,.2f} | {a['percent']:.4f}% | {b['mean_cycles']:,.2f} | {b['percent']:.4f}% |")
lines += [f"| **합계** | **{d512['mean_profile_cycles']:,.2f}** | **100%** | **{d1024['mean_profile_cycles']:,.2f}** | **100%** |", '',
    f"일반 split+merge 합계는 512 **{d512['split_merge_percent']:.4f}%**, 1024 **{d1024['split_merge_percent']:.4f}%**다.",
    '백분율 표시 반올림 때문에 표시된 행들의 합에는 끝자리 차이가 있을 수 있다.',
    '', '## 내부 계측 OFF와 측정 비용', '',
    '| 구분 | 512 평균 cycles | 1024 평균 cycles |', '|---|---:|---:|',
    f"| 내부 계측 OFF control | {d512['mean_control_cycles']:,.2f} | {d1024['mean_control_cycles']:,.2f} |",
    f"| 함수별 계측 ON | {d512['mean_profile_cycles']:,.2f} | {d1024['mean_profile_cycles']:,.2f} |",
    f"| ON/OFF 차이 | +{d512['instrumentation_delta_percent']:.4f}% | +{d1024['instrumentation_delta_percent']:.4f}% |", '',
    'ON/OFF 차이는 계측 비용뿐 아니라 코드 배치·컴파일 변화도 포함할 수 있다.',
    '따라서 ON 비중을 비계측 실행의 정확한 분할이나 보장된 최적화 가능 시간으로 해석하지 않는다.',
    '임의의 고정 계측 비용을 함수별로 빼거나, ON 함수 시간을 OFF 분모로 나누지 않았다.',
    '', '## 이전 LDL 전환 전 기록과 구분', '',
    '이전 `Final_code/Before_slothy` 상세 기록과 현재 기록은 같은 단계 분류·입력·계측 방식을 사용한다.',
    '이전 소스를 이번에 다시 실행한 비교는 아니다. 기존 기록을 읽어 아래에 표시한다.', '',
    '| 항목 | 512 이전 → 현재 | 1024 이전 → 현재 |', '|---|---:|---:|',
]
for key, label in [('sg_ldl', 'LDL 비중'), ('sg_split', 'split 비중'), ('sg_merge', 'merge 비중')]:
    a, b = d512, d1024
    lines.append(f"| {label} | {a['historical_pre_ldl']['categories'][key]['percent_sign']:.4f}% → {a['categories'][key]['percent']:.4f}% | {b['historical_pre_ldl']['categories'][key]['percent_sign']:.4f}% → {b['categories'][key]['percent']:.4f}% |")
lines += ['', '변경하지 않은 함수의 비중 상승은 전체 분모 감소 때문일 수 있다. 절대 사이클도 함께 확인한다.',
    '', '## 반복 실행·검증', '',
    '| 모드 / UTC 실행 ID | 512: 100회 누적 cycles | 1024: 100회 누적 cycles |', '|---|---:|---:|']
for run in runs:
    lines.append(f"| {run['mode']} / {Path(run['directory']).name} | {run['degrees']['512']['total']:,} | {run['degrees']['1024']['total']:,} |")
lines += ['',
    '- 모든 측정에서 각 크기 100개 서명 정상 검증 및 정해진 변조 거부 검사 통과.',
    '- 출력 지문 512 `9895079d`, 1024 `a020dd02`로 이전 기록 및 ON/OFF 실행과 일치.',
    '- 계측 stack 오류 0, 범주 합 일치, 재귀 호출 수 확인. 전체 KAT·상수시간 검사를 새로 수행한 작업은 아니다.',
    '- 동일 입력의 반복은 재현성 확인이다. 서로 다른 키의 대규모 무작위 통계는 아니다.',
    '- CFSR/HFSR/AFSR=0, 시작·종료 TCM_CONTROL=0x99, ECC 설정 유지.',
    '', '## 조건', '',
    'NUCLEO-N657X0-Q, CPU/SYSCLK/HCLK 800/400/200 MHz. ITCM 코드, DTCM 상수·데이터·스택,',
    '각각 256 KiB, cache OFF, ECC ON. GCC 15.2.1 / Zephyr 4.4.1, pinned mlkem-native 플랫폼.',
    '`-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16`, hard-float, `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.',
    'DWT CYCCNT, 서명 계측 중 IRQ OFF. 기존 프로파일과 같은 준비 실행·키 준비 순서·메시지·seed 식.',
    '크기별 10개 준비 키 중 마지막 키 하나에 100개 서명 seed를 사용한다.',
    '', '## 원자료·재현', '',
    '생산 소스는 그대로 두고 build 아래 시험용 C 복사본에만 계측을 추가한다.',
    'FFT/iFFT는 시험용 probe가 변경하지 않은 실제 ASM을 호출한다. 다른 후보 암호 구현을 가져오지 않는다.',
    '각 실행에 소스·계측 소스 archive, ELF, disassembly, compile_commands, SHA-256 manifest를 보존했다.', '']
for run in runs:
    rel = Path(run['directory']).relative_to(CRYPTO)
    lines.append(f"- {run['mode']} {Path(run['directory']).name}: [로그]({rel}/raw.log) / [manifest]({rel}/manifest.json)")
lines += ['', '- [계산 JSON](validation/sign_profile/data.json)',
    '- [생성기](validation/sign_profile/generate.py) / [집계기](validation/sign_profile/analyze.py)',
    '- [이전 LDL 전환 전 비중](../../../Final_code/validation/sign_profile/detail_result.md)', '',
    '```sh', 'bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign_detail',
    'bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign_control',
    'python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign_detail',
    'python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign_control',
    '# 위 보드 실행 쌍을 한 번 더 실행한 뒤:',
    'python3 fn-dsa_m55/FFT/6_sign_fft/validation/sign_profile/analyze.py DETAIL1 CONTROL1 DETAIL2 CONTROL2',
    '```', '']
(CRYPTO / 'sign_profile_result.md').write_text('\n'.join(lines))
print('REPORT', CRYPTO / 'sign_profile_result.md')
for n, d in summary['degrees'].items():
    print('DEGREE', n, 'profile', d['mean_profile_cycles'], 'control', d['mean_control_cycles'],
          'overhead%', d['instrumentation_delta_percent'])
    for key, label in labels:
        row = d['categories'][key]
        print(label, f"{row['percent']:.4f}%", 'cycles/sign', row['mean_cycles'])
