#!/usr/bin/env python3
"""Read only fresh, current-binary kernel runs. Never edit crypto sources."""
from pathlib import Path
from collections import defaultdict
import argparse
import hashlib
import json
import re
import shlex

ROOT = Path(__file__).resolve().parent
BASE = ROOT.parent
M55 = BASE.parents[2]
REFERENCE = M55 / 'M55_ref'
CANDIDATES = {
    'F1': 'fp64_vfma',
    'F2': 'fp64_two_prod',
    'F3a': 'fp64_loop_merge',
    'F3b': 'fp64_loop_schedule',
    'F3c': 'fp64_schedule_only',
}
DEFAULT_START = '20260923T030111Z'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def clean_c(text):
    text = re.sub(r'/\*.*?\*/|//[^\n]*', '', text, flags=re.S)
    return re.sub(r'\bfndsa_kgen_GM_TAB\b', 'GM_TAB', text)


def function(text, name):
    text = clean_c(text)
    m = re.search(r'\b' + re.escape(name) + r'\s*\([^;{}]*\)\s*\{', text)
    assert m, name
    depth = 1
    end = m.end()
    while depth:
        if text[end] == '{':
            depth += 1
        elif text[end] == '}':
            depth -= 1
        end += 1
    return re.sub(r'\s+', '', text[m.start():end])


def fixed_identity():
    names = {
        'kgen_fxp.c': ['inner_fxr_div', 'vect_FFT', 'vect_iFFT',
                       'vect_mul_fft', 'vect_inv_mul2e_fft'],
        'kgen_inner.h': ['fxr_of', 'fxr_of_scaled32', 'fxr_add', 'fxr_sub',
                         'fxr_double', 'fxr_neg', 'fxr_abs', 'fxr_mul',
                         'fxr_sqr', 'fxr_round', 'fxr_div2e', 'fxr_mul2e',
                         'fxr_inv', 'fxr_div', 'fxr_lt', 'fxc_add',
                         'fxc_sub', 'fxc_half', 'fxc_mul', 'fxc_conj'],
    }
    audit = {'reference': str(REFERENCE), 'functions': {}, 'candidates': {},
             'reference_files': {name: sha(REFERENCE / name)
                                 for name in ('kgen_fxp.c', 'kgen_inner.h', 'inner.h')}}
    for filename, functions in names.items():
        original = (REFERENCE / filename).read_text()
        for name in functions:
            expected = function(original, name)
            audit['functions'][name] = hashlib.sha256(expected.encode()).hexdigest()
            for key, folder in CANDIDATES.items():
                assert function((BASE / folder / filename).read_text(), name) == expected, (key, name)
    def table(path):
        text = clean_c(path.read_text())
        m = re.search(r'\bGM_TAB\[1024\]\s*=\s*(\{.*?\n\};)', text, re.S)
        assert m, path
        return re.sub(r'\s+', '', m[1])
    expected = table(REFERENCE / 'kgen_fxp.c')
    audit['twiddle_initializer_sha256'] = hashlib.sha256(expected.encode()).hexdigest()
    for key, folder in CANDIDATES.items():
        assert table(BASE / folder / 'kgen_fxp.c') == expected, key
        audit['candidates'][key] = '25 function bodies and GM_TAB initializer match'
    return audit


def records(prefix, text):
    return [{k: int(v) if v.isdigit() else v
             for k, v in re.findall(r'(\w+)=([^ ]+)', line)}
            for line in text.splitlines() if line.startswith(prefix + ' ')]


def groups(rows, fields):
    result = []
    grouped = defaultdict(list)
    for row in rows:
        grouped[tuple(row[k] for k in fields)].append(row)
    for keys, group in sorted(grouped.items()):
        assert len(group) == 20 and {r['case'] for r in group} == set(range(20))
        minima = {r['min'] for r in group}
        assert len(minima) == 1, (keys, minima)
        result.append(dict(zip(fields, keys), cycles=minima.pop(),
                           max_trial_span=max(r['max'] - r['min'] for r in group)))
    return result


def comparison(fixed, fp64):
    assert fixed > 0 and fp64 > 0
    return dict(fixed_cycles=fixed, fp64_cycles=fp64,
                time_ratio=fp64 / fixed,
                cycle_reduction_percent=100 * (1 - fp64 / fixed))


def read_run(path):
    data = json.loads(path.read_text())
    assert data['valid'] and not data['errors'] and data['label'] == 'kernels'
    raw = path.parent / 'raw.log'
    assert sha(raw) == data['raw_sha256']
    assert all(sha(p) == h for p, h in data['build_manifest'].items()), (path, 'stale source/binary')
    text = re.sub(r'Info : [^\n]*\n', '', raw.read_text())
    assert text.count('KERNEL_DONE result=0') == 1
    assert records('BOARD_DIFF', text) == [dict(random_pairs=1000000, edge_pairs=36864,
                                              checksum='c665dcb55f68554d', result=0)]
    assert records('FFT_DIFF', text) == [dict(coefficient_positions=81840, backends=3, result=0)]
    kernel = records('KERNEL', text)
    assert len(kernel) == 19 and all(k['bitexact'] == 'PASS' for k in kernel)
    ct = groups(records('CT_OP', text), ('op',))
    mul = groups(records('MUL', text), ('backend',))
    fft = groups(records('CT_FFT', text), ('backend', 'logn', 'inverse'))
    assert (len(ct), len(mul), len(fft)) == (4, 3, 60)
    transforms = []
    for logn in range(1, 11):
        for inverse in (0, 1):
            get = lambda backend: next(r['cycles'] for r in fft
                                       if (r['backend'], r['logn'], r['inverse']) == (backend, logn, inverse))
            transforms.append(dict(logn=logn, n=1 << logn, inverse=inverse,
                                   used_in_step4=logn <= 9,
                                   **comparison(get(0), get(2))))
    regions = []
    for row in kernel:
        regions.append(dict(case=row['case'], logn=row['logn'], n=1 << row['logn'],
                            prepare=comparison(row['fixed_prepare'] / 100, row['asm_prepare'] / 100),
                            repeat=comparison(row['fixed_reduce'] / 100, row['asm_reduce'] / 100)))
    get_mul = lambda backend: next(r['cycles'] / 256 for r in mul if r['backend'] == backend)
    return dict(run_dir=str(path.parent), elf_sha256=data['elf_sha256'],
                source_sha256=data['source'], raw_sha256=data['raw_sha256'],
                fft=transforms, regions=regions, multiplication=comparison(get_mul(0), get_mul(2)),
                checks=dict(random_multiply_pairs=1000000, edge_pairs=36864,
                            fft_positions=81840, frozen_cases=19, timing_groups=67,
                            timing_classes_each=20, all_observed_minima_equal=True,
                            max_trial_span=max(r['max_trial_span'] for r in ct + mul + fft)))


def write_report(report):
    selected = {key: runs[-1] for key, runs in report['candidates'].items()}
    f2 = selected['F2']
    fmt = lambda x: f'{x:,.2f}' if isinstance(x, float) else f'{x:,}'
    lines = [
        '# 변경한 FP64 커널 재측정 결과', '',
        '2026-09-23 실제 M55 보드에서 5개 후보, F2 재실행까지 총 6회 완료.',
        '**전체 키생성이 아니라 변경한 함수/커널만 측정했다. 실제 butterfly가 있는',
        'FFT/iFFT와 준비·반복 커널은 고정소수점보다 느렸다.**',
        '암호 소스는 바꾸지 않았고, 과거 전체 API 평균을 분모로 사용하지 않았다.', '',
        '## 1. F2: FFT/iFFT 함수 단독', '',
        '단위 cycles/call. 각 20종 입력에서 1회 warm-up 후 20 trial의 최소값.',
        '감소율 = `(고정소수점 − FP64) / 고정소수점 × 100`; 음수는 느려짐이다.',
        '**시간 배수는 FP64/고정소수점이며 속도 향상 배수가 아니다.**', '',
        '| 함수 | FFT 길이 n | 고정소수점 | FP64 F2 | 시간 배수 | 사이클 감소율 |',
        '|---|---:|---:|---:|---:|---:|',
    ]
    for row in f2['fft']:
        if row['n'] not in (256, 512):
            continue
        name = 'iFFT' if row['inverse'] else 'FFT'
        lines.append(f"| {name} | {row['n']} | {fmt(row['fixed_cycles'])} | {fmt(row['fp64_cycles'])} | {row['time_ratio']:.4f}배 | {row['cycle_reduction_percent']:+.2f}% |")
    lines += ['', 'NTRU ④ intermediate 경로에서 FN-DSA-512의 최대 FFT 길이는 256,',
              'FN-DSA-1024는 512다. 위 표는 그 크기의 **함수 한 번**이지 키 하나의',
              '총 FFT 비용이 아니다. n=1024 FFT는 이 변경 구간에서 사용되지 않는 진단 크기다.', '',
              '## 2. 다섯 후보의 FFT/iFFT 직접 비교', '',
              '각 셀은 `FP64 cycles (같은 ELF 고정소수점 대비 시간 배수)`.',
              '후보마다 원본 함수의 실제 실행값을 분모로 사용한다.', '',
              '| 후보 | FFT n=256 | iFFT n=256 | FFT n=512 | iFFT n=512 |',
              '|---|---:|---:|---:|---:|']
    for key, run in selected.items():
        values = [r for r in run['fft'] if r['n'] in (256, 512)]
        lines.append('| ' + key + ' | ' + ' | '.join(
            f"{fmt(r['fp64_cycles'])} ({r['time_ratio']:.2f}배)" for r in values) + ' |')
    lines += ['', 'F1=VFMA, F2=정확 곱 재설계, F3a=레이어 병합,',
              'F3b=병합+SLOTHY, F3c=병합 없이 SLOTHY.',
              '어떤 후보가 개별 FFT에서 조금 앞선다고 전체 근사 k 계산도 반드시',
              '앞서는 것은 아니다. 후보 간 함수 주소는 고정하지 않았으므로 작은 차이를',
              '알고리즘 하나의 순수 효과로 단정하지 않는다.',
              '예외: logn=1(n=2) iFFT는 F1/F2에서 fixed 34 → FP64 16 cycles였다.',
              '이 경로에는 butterfly가 없으므로 함수 진입/종료 비용 차이이며,',
              '실제 FFT 산술이 빨라진 결과로 일반화하지 않는다.', '',
              '## 3. 실제 NTRU 중간 입력의 준비·반복 커널', '',
              '19개 frozen case 중 최대 두 크기의 사례 14/16을 표시한다.',
              '각 10 warm-up + 100회 평균; 데이터 초기화는 타이머 밖이며',
              '고정소수점/이전 FP64 C/현재 후보의 실행 순서를 회전했다.', '',
              '- 준비: FFT → 역수/스케일 준비.',
              '- 반복: FFT → 점별 곱 → iFFT → 정수 k 반올림.',
              '- 큰 정수 입력 변환과 정확한 정수 NTRU 해 갱신은 제외.', '',
              '| 후보 | 구간 | n | 고정소수점 cycles/회 | FP64 cycles/회 | 시간 배수 | 감소율 |',
              '|---|---|---:|---:|---:|---:|---:|']
    for key, run in selected.items():
        for row in run['regions']:
            if row['case'] not in (14, 16):
                continue
            for kind, name in (('prepare', '준비'), ('repeat', '반복')):
                r = row[kind]
                lines.append(f"| {key} | {name} | {row['n']} | {fmt(r['fixed_cycles'])} | {fmt(r['fp64_cycles'])} | {r['time_ratio']:.4f}배 | {r['cycle_reduction_percent']:+.2f}% |")
    lines += ['', '점별 곱·역수·반올림은 위 묶음 안에서 측정했으며 각각의 단독 시간을',
              '측정한 것은 아니다. 준비·반복의 호출 빈도도 다르므로 두 평균을 더해서',
              '전체 키생성의 개선율로 해석하지 않는다. 모든 크기/사례는 JSON에 보존했다.', '',
              '## 4. 실수 곱셈 wrapper', '',
              '256회 호출의 최소 cycle/256. raw 표현 변환·호출·loop·sink를 포함하므로',
              'VMUL/VFMA 한 명령의 latency나 내장된 곱셈 body만의 비용이 아니다.', '',
              '| 후보 | 고정소수점 | FP64 | 시간 배수 |', '|---|---:|---:|---:|']
    for key, run in selected.items():
        r = run['multiplication']
        lines.append(f"| {key} | {r['fixed_cycles']:.6f} | {r['fp64_cycles']:.6f} | {r['time_ratio']:.4f}배 |")
    first, second = report['candidates']['F2']
    fft_delta = max(abs(a['fp64_cycles'] - b['fp64_cycles']) for a, b in zip(first['fft'], second['fft']))
    repeat_delta = max(abs(a['repeat']['fp64_cycles'] - b['repeat']['fp64_cycles'])
                       for a, b in zip(first['regions'], second['regions']))
    prep_delta = max(abs(a['prepare']['fp64_cycles'] - b['prepare']['fp64_cycles'])
                     for a, b in zip(first['regions'], second['regions']))
    lines += ['', '## 5. 재현성·정확성·한계', '',
              f'- F2 처음/마지막 실행의 FFT/iFFT 최소 cycle 최대 차이: {fft_delta} cycle.',
              f'- F2 19개 사례의 반복 커널 평균 최대 차이: {repeat_delta:.2f} cycle/회.',
              f'- F2 19개 사례의 준비 커널 평균 최대 차이: {prep_delta:.2f} cycle/회.',
              '- 여섯 실행 모두 원본 raw 곱셈 1,036,864쌍, FFT/iFFT 81,840 위치,',
              '  NTRU 19개 사례의 중간값 및 정수 k 일치. add/half/div 회귀 검사 통과.',
              '- 각 실행의 67개 timing 그룹에서 20종 입력별 최소 cycle이 동일.',
              '  관찰된 trial 내부 최대 흔들림은 ' + str(max(r['checks']['max_trial_span'] for rs in report['candidates'].values() for r in rs)) + ' cycle.',
              '- fault/TCM/ECC 및 실행 전후 source/build/ELF hash 검증 통과.',
              '- 원본 M55_ref의 함수 25개와 twiddle 상수표 일치 검사를 수행했다.',
              '- 이번은 커널 재측정이다. KAT 300개·전체 서명/검증은 재실행하지 않았고,',
              '  변경 없는 암호 소스에 대한 이전 결과는 각 후보 result.md에 보존돼 있다.',
              '- 유한 입력의 정확성/timing 관찰이며 전체 상수시간 형식 증명·dudect·',
              '  전력/EM 검증은 아니다. 커널만의 결과를 전체 keygen 배수로 쓰지 않는다.', '',
              '## 6. 조건과 원시 로그', '',
              'NUCLEO-N657X0-Q, CPU 800 MHz, cache OFF, DWT/IRQ OFF, 기존 ITCM/DTCM',
              '배치. GCC 15.2.1 -O3, hardware FP64, ffp-contract OFF/fast-math OFF.',
              '현재 manifest와 일치하는 기존 ELF를 다시 실행했으며 암호 코드는 변경하지 않았다.',
              '입력·반복·통계·제외 범위는 [README](README.md), 모든 값과 source/ELF/로그',
              'hash 및 고정소수점 동등성 감사는 [summary.json](summary.json)에 있다.', '',
              '| 실행 | 실제 새 raw log |', '|---|---|']
    for key, runs in report['candidates'].items():
        for index, run in enumerate(runs):
            directory = Path(run['run_dir'])
            link = '../' + str(directory.relative_to(BASE)) + '/raw.log'
            lines.append(f'| {key} #{index + 1} | [{directory.name}]({link}) |')
    lines += ['', '재집계: `python3 analyze.py`. 기존 측정값을 이번 결과로 복사하지 않고',
              '20260923T030111Z 이후의 지정된 새 실행만 읽는다.', '']
    (ROOT / 'result.md').write_text('\n'.join(lines))


def main():
    args = argparse.ArgumentParser()
    args.add_argument('--partial', action='store_true')
    args.add_argument('--not-before', default=DEFAULT_START)
    options = args.parse_args()
    report = dict(not_before=options.not_before, baseline_identity=fixed_identity(),
                  pending=[], candidates={}, harness={}, methodology=dict(
                      fft_statistic='minimum of 20 trials after one warm-up, equal across 20 input classes',
                      region_statistic='mean of 100 calls after 10 warm-ups per frozen case; backend order rotated',
                      excluded='integer input conversion, exact integer solution update, all other keygen work',
                      timing='DWT CYCCNT, IRQ off, common kernel harness, same ELF per fixed/FP64 pair',
                      layout='same placement policy, NOT fixed function addresses across candidate ELFs',
                      hardware='NUCLEO-N657X0-Q serial 003C00223335510735383531, 800 MHz, cache off, ITCM/DTCM'))
    for key, folder in CANDIDATES.items():
        validation = BASE / folder / 'validation'
        harness = {name: sha(validation / name) for name in ('kernel_bench.c', 'kernel_cases.h')}
        if report['harness']:
            assert report['harness'] == harness, (key, 'different input/harness')
        report['harness'] = harness
        command_rows = json.loads((validation / 'build/kernels/compile_commands.json').read_text())
        row = next(r for r in command_rows if Path(r['file']).name == 'kernel_bench.c')
        command = shlex.split(row['command'])
        for flag in ('-O3', '-mfpu=fpv5-d16', '-ffp-contract=off', '-fno-fast-math',
                     '-DFNDSA_ASM_CORTEXM4=1', '-DFNDSA_ASM_CORTEXM55=1'):
            assert flag in command, (key, flag)
        paths = sorted(p for p in (validation / 'results/kernels').glob('*/run.json')
                       if p.parent.name >= options.not_before)
        wanted = 2 if key == 'F2' else 1
        if len(paths) < wanted:
            report['pending'].append(f'{key}: {len(paths)}/{wanted} fresh runs')
        report['candidates'][key] = [read_run(p) for p in paths[:wanted]]
    (ROOT / 'summary.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(dict(pending=report['pending'], runs={k: len(v) for k, v in report['candidates'].items()},
                          fixed_functions=len(report['baseline_identity']['functions'])), indent=2))
    if report['pending'] and not options.partial:
        raise SystemExit('Fresh measurements not complete')
    if not report['pending']:
        write_report(report)


if __name__ == '__main__':
    main()
