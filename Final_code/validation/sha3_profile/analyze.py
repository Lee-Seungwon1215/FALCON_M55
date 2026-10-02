#!/usr/bin/env python3
"""Keep raw profiles and explicitly labelled empty-probe-corrected estimates."""
import json
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
MODES = ('control', 'coarse', 'detail')
data = {}
for mode in MODES:
    path = sorted((HERE / 'results' / mode).glob('*/manifest.json'))[-1]
    manifest = json.loads(path.read_text())
    assert manifest['valid_measurement'], manifest
    text = (path.parent / 'raw.log').read_text()
    rows = {}
    for d, op, calls, total, minimum, maximum in re.findall(
        r'^PROFILE_TOTAL degree=(\d+) operation=(\w+) calls=(\d+) total=(\d+) min=(\d+) max=(\d+)$', text, re.M):
        rows[f'{d}_{op}'] = dict(calls=int(calls), total=int(total), minimum=int(minimum),
                                maximum=int(maximum), functions={})
    for d, op, name, cycles, entries, inclusive, children in re.findall(
        r'^PROFILE_CATEGORY degree=(\d+) operation=(\w+) category=(\w+) cycles=(\d+) entries=(\d+) inclusive=(\d+) children=(\d+)$', text, re.M):
        rows[f'{d}_{op}']['functions'][name] = dict(cycles=int(cycles), calls=int(entries),
                                                  inclusive=int(inclusive), children=int(children))
    runs, empty_total, empty_self, raw_total = map(int, re.search(
        r'PROBE_CALIBRATION runs=(\d+) empty_total=(\d+) empty_self=(\d+) raw_total=(\d+)', text).groups())
    self_cost = empty_self / runs
    whole_cost = (empty_total - raw_total) / runs
    outer_cost = whole_cost - self_cost
    for row in rows.values():
        assert sum(f['cycles'] for f in row['functions'].values()) == row['total']
        for name, f in row['functions'].items():
            # Empty body's BL/BX is included, so this is an estimate, not an
            # exact uninstrumented instruction attribution.
            f['corrected_cycles'] = max(0, f['cycles'] - f['calls'] * self_cost - f['children'] * outer_cost)
        row['corrected_total'] = sum(f['corrected_cycles'] for f in row['functions'].values())
        row['shake_cycles'] = sum(f['corrected_cycles'] for n, f in row['functions'].items() if n != 'other')
    data[mode] = dict(run=str(path.parent.relative_to(HERE)), fingerprints=manifest['fingerprints'],
                      self_cost=self_cost, outer_cost=outer_cost, whole_cost=whole_cost, rows=rows)
assert data['control']['fingerprints'] == data['detail']['fingerprints'] == data['coarse']['fingerprints']
for key, row in data['detail']['rows'].items():
    for name, f in row['functions'].items():
        if not name.startswith('bit_'):
            assert f['calls'] == data['coarse']['rows'][key]['functions'][name]['calls']

keys = [f'{d}_{op}' for op in ('keygen', 'sign', 'verify') for d in (512, 1024)]
heads = ['키생성 512', '키생성 1024', '서명 512', '서명 1024', '검증 512', '검증 1024']
names = list(data['detail']['rows'][keys[0]]['functions'])
labels = {n: f'`{n}()`' for n in names}
labels.update(other='나머지 FN-DSA', process_block='`fndsa_sha3_process_block()` 자체',
              inject_chunk='`fndsa_sha3_inject_chunk()`')
def percent(key, name, internal=False, raw=False):
    row = data['detail']['rows'][key]
    f = row['functions'][name]
    if raw:
        denom = row['total']
        cycles = f['cycles']
    else:
        denom = row['shake_cycles'] if internal else row['corrected_total']
        cycles = f['corrected_cycles']
    return f'{100 * cycles / denom:.3f}%'
def table(internal=False, raw=False):
    lines = ['| 함수 | ' + ' | '.join(heads) + ' |', '|---|' + '---:|' * 6]
    for name in names:
        if internal and name == 'other': continue
        lines.append('| ' + labels[name] + ' | ' + ' | '.join(percent(k, name, internal, raw) for k in keys) + ' |')
    return '\n'.join(lines)

md = '''# 현재 Before_slothy의 Keccak/SHAKE 함수별 연산 비중

대상: `Final_code/Before_slothy/sha3.c`, `sha3_cm4.s`. **최적화/수정 없이 계측만 수행**했다.
원본 C/H/ASM의 SHA-256은 각 실행의 `sources.json`에 보존하고 실행 전후 동일성을 검사했다.
키생성·서명·검증에서 실제로 실행되는 M55 경로만 집계하며 AVX2/C 대체 permutation은 실행하지 않는다.

## 측정 조건

- 보드: NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`만 사용. M4 보드는 사용하지 않음.
- CPU 800 MHz, I/D cache OFF, ITCM/DTCM 각각 256 KiB 설정.
- 코드는 ITCM, 전역 상수·데이터·스택은 기존 DTCM 배치. Keccak ASM의 인라인 라운드 상수는 원본 `.text` 그대로.
- 기존 mlkem-native 기반 보드 초기화/로더와 ECC 설정 유지. 시작/종료 TCM 설정 및 fault 레지스터 확인.
- 동일 GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard -ffp-contract=off -fno-fast-math`.
- DWT CYCCNT, 각 측정 구간 IRQ OFF. 512/1024 각각 키생성 10회, 서명 100회, 검증 100회.
- 입력은 `fn-dsa_m55/ntt_profile_compare/benchmark.c`의 결정적 시드·메시지와 동일.
- 현재 채택된 NTT/키생성 FFT/서명 FFT·LDL·split·merge ASM을 모두 포함. 예전 validation의 누락된 ASM 목록을 재사용하지 않음.
- control: 내부 계측 없음. coarse: C 7개+ASM 공개 함수 2개만 계측. detail: 여기에 bit_split/merge 10개 진입점 추가.
- 측정 보조 코드만 별도 경로에 생성. 실제 최적화 구현이나 생산 빌드 설정은 변경하지 않음.

## 집계 방식과 정확도 한계

각 함수의 **자체 시간(exclusive)**: 하위 계측 함수에서 쓴 시간을 제외한다.
따라서 `shake_extract → process_block → bit_split/merge` 시간을 중복 합산하지 않는다.
`process_block()` 자체 시간에는 24라운드뿐 아니라 상태 이동·프로로그/에필로그 등이 포함된다.
보조 함수는 호출된 진입점 하나로 집계한다. 예: `bit_split_5`에서 4/3/2/1 라벨을 통과해도 5개의 호출로 세지 않는다.
`inner.h`의 inline `shake_next_*` 자체 비용은 이번 대상이 아니며, 그 함수에서 호출한 `shake_extract()` 등만 집계한다.

짧은 함수에서는 계측 비용이 크므로 빈 ASM wrapper 2,000회와 직접 빈 함수 호출을 비교했다.
wrapper는 모든 GPR, LR, APSR의 NZCVQ/GE를 보존하며, 계측 C는 `-mgeneral-regs-only`로 컴파일하고 FP/MVE 명령이 없는지 확인했다.
현재 측정된 빈 wrapper 추가 비용은 호출당 **392 cycles**: 함수 자체 구간 201, 부모 구간 191 cycles.
보정식은 `raw exclusive - 호출수×201 - 하위호출수×191`이며 음수는 0으로 제한한다.
이것은 빈 함수의 BL/BX·배치 영향 등을 포함한 **오버헤드 보정 추정치**이지, 원본의 모든 명령을 비침습적으로 정확히 분해한 수치가 아니다.
원자료와 보정값을 모두 보존한다. 특히 극히 짧은 함수의 미세한 차이는 과해석하지 않는다.

## 전체 연산을 분모로 한 함수별 비중 — 보정 추정

각 열의 분모는 해당 키생성/서명/검증의 보정된 전체 시간이다. 나머지 FN-DSA를 포함하면 반올림 전 100%.

'''
md += table() + '\n'
md += '| SHAKE 관련 합계 | ' + ' | '.join(f"{100 * data['detail']['rows'][k]['shake_cycles'] / data['detail']['rows'][k]['corrected_total']:.3f}%" for k in keys) + ' |\n'
md += '\n## 두 파일 내부만 100%로 다시 정규화 — 보정 추정\n\n' + table(internal=True) + '\n'
md += '\n## 호출 횟수 — 측정 전체 누적\n\n| 함수 | ' + ' | '.join(heads) + ' |\n|---|' + '---:|'*6 + '\n'
for n in names[1:]:
    md += '| ' + labels[n] + ' | ' + ' | '.join(str(data['detail']['rows'][k]['functions'][n]['calls']) for k in keys) + ' |\n'
md += '''
## 계측 없는 대조 실행 및 교차 점검

| 구분 | control 평균 cycles | coarse 시간 증가 | detail 시간 증가 | detail 보정 후 control 대비 | 보정 SHAKE 합계: detail/coarse 차이 |
|---|---:|---:|---:|---:|---:|
'''
for k, head in zip(keys, heads):
    a, b, c = (data[m]['rows'][k] for m in MODES)
    md += f"| {head} | {a['total']/a['calls']:,.1f} | {100*(b['total']/a['total']-1):+.3f}% | {100*(c['total']/a['total']-1):+.3f}% | {100*(c['corrected_total']/a['total']-1):+.3f}% | {100*(c['shake_cycles']/b['shake_cycles']-1):+.3f}% |\n"
md += '''
3개 실행 모두 키생성 성공, 서명 검증 및 변조 거부, 출력 지문 일치(512: `9895079d`, 1024: `a020dd02`),
프로파일 스택/합계 검사 통과, CFSR/HFSR/AFSR=0. 지문 비교는 전체 KAT 재실행이나 상수시간 검증을 대체하지 않는다.

## 실제 bit_split/merge 호출 경로에서 확인한 점

현재 실행에서는 permutation마다 `bit_split_5` 4회 + `bit_split_1` 1회,
`bit_merge_5` 4회 + `bit_merge_1` 1회가 호출된다. 2/3/4 진입점은 호출되지 않았다.
이는 SHAKE256이 SHAKE128로 바뀌었다는 뜻이 아니다. SHAKE256의 rate는 136바이트 그대로다.
원본 주석은 rate에 따라 첫 17개 lane만 변환하는 의도를 설명하지만, 실제 ASM은 rate를 r14(LR)에 둔 뒤
`bl bit_split_5`/`bl bit_merge_5`가 LR을 반환주소로 덮어쓴다. 이후 `cmp r14, #...`는 rate가 아닌 반환주소를 비교한다.
계측 없는 control ELF에서도 이 명령열을 확인했다. 결과적으로 현 실행에서는 4×5+1=21개 lane(168바이트)을 분리/복원한다.
이는 최대 rate에 해당하는 변환 경로이며, 나머지 4개 lane(32바이트)은 비트 분리 상태로 유지된다.
따라서 이전 대화에서 '현재 코드는 136바이트만 복원한다'고 설명한 것은 실제 실행과 달랐다.
이 보고서는 현 실행 경로를 그대로 측정했으며 해당 로직은 수정하지 않았다.

`sha3_init/update/close`는 별도 SHA3 API로 존재하지만 이번 FN-DSA 워크로드에서는 0회이다.
`sha3.c`의 C `process_block` 대체 구현도 M4 ASM 경로 선택으로 실행되지 않는다.
상수표 및 매크로는 별도 함수가 아니므로 해당 실행 함수에 포함한다.

## 보정 전 원자료 — 계측 포함 비중

'''
md += table(raw=True) + '\n\n## 재현 및 원자료\n\n'
md += '```sh\nbash Final_code/validation/sha3_profile/build.sh control\nbash Final_code/validation/sha3_profile/build.sh coarse\nbash Final_code/validation/sha3_profile/build.sh detail\nsource fn-dsa_m55/measurement_mlkem_native/env/environment.sh\npython Final_code/validation/sha3_profile/run.py control\npython Final_code/validation/sha3_profile/run.py coarse\npython Final_code/validation/sha3_profile/run.py detail\npython Final_code/validation/sha3_profile/analyze.py\n```\n\n'
for mode in MODES:
    run = data[mode]['run']
    md += f'- {mode}: [{run}/raw.log]({run}/raw.log), [manifest]({run}/manifest.json), [sources]({run}/sources.json)\n'
(HERE / 'result.md').write_text(md)
(HERE / 'data.json').write_text(json.dumps(data, indent=2) + '\n')
print('RESULT', HERE / 'result.md')
print(table())
for k in keys:
    row = data['detail']['rows'][k]
    control = data['control']['rows'][k]
    print(k, 'SHAKE%', round(100 * row['shake_cycles'] / row['corrected_total'], 3),
          'corrected_vs_control%', round(100 * (row['corrected_total'] / control['total'] - 1), 3))
