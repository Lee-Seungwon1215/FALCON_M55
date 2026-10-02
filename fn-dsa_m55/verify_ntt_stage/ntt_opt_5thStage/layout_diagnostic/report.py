#!/usr/bin/env python3
"""Render the audited four-way board comparison without changing old results."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
data = json.loads((ROOT / 'results/comparison.json').read_text())
assert data['complete'] and data['layout']['valid']
m = data['measurements']
names = ('A_low', 'B_low', 'A_high', 'B_high')
ops = (('keygen', '키생성'), ('sign', '서명'), ('verify', '검증'))
# Do not print a causal conclusion if the measurements do not support it.
for degree in (512, 1024):
    key = f'{degree}_sign'
    for where in ('low', 'high'):
        a, b = (m[n + '_' + where]['upper_median'][key] for n in ('A', 'B'))
        assert abs(b-a) / a < 0.001, 'large fixed-layout A/B gap remains; review conclusion'
    for variant in ('A', 'B'):
        pair = data['paired_comparisons'][variant + '_low_to_' + variant + '_high'][key]
        assert pair['second_slower'] == 10 and pair['min_delta'] > 100000, 'placement penalty not reproduced'
lines = [
    '# SLOTHY A/B 실행 위치 고정 재측정', '',
    '## 결과', '',
    '기존 B의 큰 서명 지연은 **NTT 파이프라인 자체의 3–4% 성능 저하가 아니라,',
    '코드 크기 증가에 따라 서명용 FFT 계열 함수들의 실행 위치가 바뀐 영향이 주원인**임을',
    '대조 실험으로 확인했다. A/B의 해당 함수 주소를 맞추면 큰 격차가 사라지고,',
    '같은 함수를 확장 ITCM으로 옮기면 A/B 모두 지연된다.', '',
    '이는 동일 보드·현재 설정의 결과다. wait-state disable bit를 직접 토글하지 않았으므로',
    '내부 지연의 모든 cycle을 특정 하드웨어 단계에 귀속시키는 실험은 아니다.', '',
    '## 전체 API cycle/call', '',
    '각 degree·작업별 100회(고정 seed 10개 × 10회), batch마다 warmup 10회.',
    '대표값: 10개 batch 평균 cycle/call의 **상위 중앙값**. 개별 100회 시간의 중앙값은 아니다.',
    'low=13개 fpoly 함수가 기본 ITCM, high=같은 13개 함수가 확장 ITCM.', '',
    '| degree | 작업 | A_low | B_low | A_high | B_high |',
    '|---:|---|---:|---:|---:|---:|',
]
for degree in (512, 1024):
    for op, label in ops:
        key = f'{degree}_{op}'
        lines.append(f'| {degree} | {label} | ' + ' | '.join(f"{m[n]['upper_median'][key]:,}" for n in names) + ' |')
lines += ['', '## 주소를 맞춘 A/B 서명 차이', '',
          '아래 %는 `(B−A)/A×100`: 양수면 B가 느리고, 음수면 B가 빠르다.', '',
          '| degree | 기본 ITCM B−A | 기본 ITCM 차이 | 확장 ITCM B−A | 확장 ITCM 차이 |',
          '|---:|---:|---:|---:|---:|']
for degree in (512, 1024):
    key = f'{degree}_sign'
    values = []
    for where in ('low', 'high'):
        a, b = (m[n + '_' + where]['upper_median'][key] for n in ('A', 'B'))
        values += [f'{b-a:+,} cycles', f'{(b-a)/a*100:+.5f}%']
    lines.append(f'| {degree} | ' + ' | '.join(values) + ' |')
lines += ['', '## 같은 코드를 기본→확장 ITCM으로 옮긴 효과', '',
          '다른 함수/데이터/스택 주소는 그대로이며, 이동한 13개 함수의 주소 차이는 모두',
          '`0x1BC00`이다. 명령 정렬은 유지된다. NTT/iNTT 기계어도 low/high 사이에 동일하다.', '',
          '| 후보 | degree | 서명 추가 cycle/call | 지연률 | 동일 seed에서 느린 batch |',
          '|---|---:|---:|---:|---:|']
for variant in ('A', 'B'):
    for degree in (512, 1024):
        key = f'{degree}_sign'
        lo, hi = (m[variant + '_' + w]['upper_median'][key] for w in ('low', 'high'))
        pair = data['paired_comparisons'][variant + '_low_to_' + variant + '_high'][key]
        lines.append(f"| {variant} | {degree} | {hi-lo:+,} | {(hi-lo)/lo*100:+.4f}% | {pair['second_slower']}/10 |")
lines += ['', '개별 seed별 차이·평균·최소/최대·상위 중앙값은 [comparison.json](results/comparison.json)의',
          '`paired_comparisons`에 있다. 통계적 유의성 검정이나 다른 보드에 대한 일반화는 하지 않았다.', '',
          '## 실제 실행 주소', '',
          '표는 Thumb 비트를 제외한 명령 주소다. 각 칸은 A/B가 완전히 같다.', '',
          '| 함수 | A_low = B_low | A_high = B_high |', '|---|---|---|']
for func in sorted(data['layout']['records']['A_low']['fpoly_addresses']):
    low = data['layout']['records']['A_low']['fpoly_addresses'][func]
    high = data['layout']['records']['A_high']['fpoly_addresses'][func]
    lines.append(f'| `{func}` | `{low}` | `{high}` |')
lines += ['', 'A/B 사이에서 mq 내부의 iNTT와 곱셈 시험 probe 시작 주소는 다르지만, 둘 다 기본 ITCM 안이다.',
          '그 외 함수 주소는 같다. A/B의 fpoly 함수 주소뿐 아니라 기계어도 동일하다.',
          '전체 DTCM 심벌 주소도 네 빌드 사이에 같으며 스택 위치·크기를 바꾸지 않았다.', '',
          '## 설정과 정확성', '',
          '- 실제 NUCLEO-N657X0-Q, ST-LINK `003C00223335510735383531`.',
          '- CPU 800 MHz / SYSCLK 400 MHz / HCLK 200 MHz, I/D cache OFF, TCM ECC ON.',
          '- ITCM/DTCM 각각 256 KiB. global rodata·데이터·스택 DTCM.',
          '- GCC 15.2.1 기존 `-O3` 애플리케이션 object/archive 그대로 사용; 재컴파일 없음.',
          '- 원래 linker script로 대조 재링크한 ELF가 기존 측정 ELF와 byte-identical.',
          '- 변경: text 배치와 출력 경로뿐. 계산 C/assembly, 입력, 반복수, 클럭 설정 불변.',
          '- full 실행 순서: A_low → B_low → B_high → A_high. 후보별 1회의 full run이며 반복 캠페인은 아니다.',
          '- `SYSCFG_CM55TCMCR` 시작/종료: 네 빌드 모두 `0x00000099`.',
          '- `ITCMWSDISABLE`/`DTCMWSDISABLE`=0 유지. 이 실험은 대기 상태 비트를 변경하지 않았다.',
          '- 네 full run 모두 NTT oracle/roundtrip 및 modular error 0; Barrett 2048쌍 mismatch 0.',
          '- 각 full run에서 고정 seed host DIGEST/AUDIT 22개 일치, 서명검증·변조거부 PASS.',
          '- CFSR/HFSR/AFSR=0, ECC 상태 정상, main stack 사용 상한 9,624 B.',
          '- ITCM 범위(패딩 포함) 118,784 B, DTCM 예약량 225,728 B로 네 빌드 동일.',
          '- 상수시간: 기존 계산 object 불변 및 기존 정적 검사/회귀의 연속성 확인.',
          '  형식적 상수시간 증명, dudect, 전력/EM TVLA 또는 전체 공식 KAT 재실행을 뜻하지 않는다.', '',
          'ST 문서는 기본 ITCM 64 KiB와 확장 ITCM을 구분하며, `ITCMWSDISABLE`이',
          '확장 ITCM에 기본 적용되는 wait-state를 비활성화하는 비트임을 명시한다.',
          '[ST RM0486](https://www.st.com/resource/en/reference_manual/rm0486-stm32n647657xx-armbased-32bit-mcus-stmicroelectronics.pdf)',
          '(프로젝트 저장본 Rev3 p.812). 현재 레지스터값과 배치 대조 결과는 이 설명과 일치한다.', '',
          '## 기존 결과의 해석과 한계', '',
          '기존 배치에서는 A의 iFFT가 `0x1000EB00`, B의 iFFT가 `0x10010010`으로,',
          'B에서 기본 ITCM 64 KiB 경계를 넘어갔다. LDL/split/merge 등도 함께 넘어갔다.',
          '이제 주소를 맞춘 A/B 비교에서는 큰 서명 격차가 재현되지 않는다.', '',
          '기존 실험은 일부 함수만 경계를 넘었고, 이번 high는 13개 함수를 모두 옮겼다.',
          '또한 이번 공통 배치는 원래 배치와 다르다. 따라서 high−low 지연률을 기존 B의',
          '3.7–3.9%와 정확히 같은 수치로 기대하거나, 기존 ref 대비 개선률로 바꿔 보고하면 안 된다.',
          '기존 결과는 당시 ELF의 실측으로 보존한다. B의 코드 크기 증가는 여전히 실제 비용이다.', '',
          '어느 후보도 `ntt_opt`에 승격하지 않았다. 최종 후보 순위/ref 대비 최적화 효과를',
          '다시 정하려면 ref까지 포함한 공통 배치 정책으로 별도 비교해야 한다.', '',
          '## 원시 로그와 재현 자료', '']
for name in names:
    result = m[name]
    run = Path(result['run_directory']).relative_to(ROOT)
    lines += [f'### {name}', '',
              f'- [full 원시 로그]({run}/raw.log)', f'- [실행 기록]({run}/run.json)',
              f'- [링크 입력/명령/해시](build/{name}/provenance.json)',
              f"- ELF SHA-256: `{result['elf_sha256']}`", '']
lines += ['[통제 방법과 재현 명령](README.md), [주소·결과 감사 JSON](results/comparison.json).', '']
(ROOT / 'RESULTS.md').write_text('\n'.join(lines))
print(ROOT / 'RESULTS.md')
