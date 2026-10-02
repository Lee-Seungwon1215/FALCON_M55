# SLOTHY A/B 실행 위치 고정 재측정

## 결과

기존 B의 큰 서명 지연은 **NTT 파이프라인 자체의 3–4% 성능 저하가 아니라,
코드 크기 증가에 따라 서명용 FFT 계열 함수들의 실행 위치가 바뀐 영향이 주원인**임을
대조 실험으로 확인했다. A/B의 해당 함수 주소를 맞추면 큰 격차가 사라지고,
같은 함수를 확장 ITCM으로 옮기면 A/B 모두 지연된다.

이는 동일 보드·현재 설정의 결과다. wait-state disable bit를 직접 토글하지 않았으므로
내부 지연의 모든 cycle을 특정 하드웨어 단계에 귀속시키는 실험은 아니다.

## 전체 API cycle/call

각 degree·작업별 100회(고정 seed 10개 × 10회), batch마다 warmup 10회.
대표값: 10개 batch 평균 cycle/call의 **상위 중앙값**. 개별 100회 시간의 중앙값은 아니다.
low=13개 fpoly 함수가 기본 ITCM, high=같은 13개 함수가 확장 ITCM.

| degree | 작업 | A_low | B_low | A_high | B_high |
|---:|---|---:|---:|---:|---:|
| 512 | 키생성 | 52,730,593 | 52,728,565 | 52,730,594 | 52,728,565 |
| 512 | 서명 | 17,193,714 | 17,191,775 | 18,027,345 | 18,025,515 |
| 512 | 검증 | 321,325 | 321,016 | 321,325 | 321,016 |
| 1024 | 키생성 | 266,568,426 | 266,567,785 | 266,568,529 | 266,567,786 |
| 1024 | 서명 | 36,840,848 | 36,840,356 | 38,687,094 | 38,686,602 |
| 1024 | 검증 | 622,372 | 622,275 | 622,372 | 622,275 |

## 주소를 맞춘 A/B 서명 차이

아래 %는 `(B−A)/A×100`: 양수면 B가 느리고, 음수면 B가 빠르다.

| degree | 기본 ITCM B−A | 기본 ITCM 차이 | 확장 ITCM B−A | 확장 ITCM 차이 |
|---:|---:|---:|---:|---:|
| 512 | -1,939 cycles | -0.01128% | -1,830 cycles | -0.01015% |
| 1024 | -492 cycles | -0.00134% | -492 cycles | -0.00127% |

## 같은 코드를 기본→확장 ITCM으로 옮긴 효과

다른 함수/데이터/스택 주소는 그대로이며, 이동한 13개 함수의 주소 차이는 모두
`0x1BC00`이다. 명령 정렬은 유지된다. NTT/iNTT 기계어도 low/high 사이에 동일하다.

| 후보 | degree | 서명 추가 cycle/call | 지연률 | 동일 seed에서 느린 batch |
|---|---:|---:|---:|---:|
| A | 512 | +833,631 | +4.8485% | 10/10 |
| A | 1024 | +1,846,246 | +5.0114% | 10/10 |
| B | 512 | +833,740 | +4.8496% | 10/10 |
| B | 1024 | +1,846,246 | +5.0115% | 10/10 |

개별 seed별 차이·평균·최소/최대·상위 중앙값은 [comparison.json](results/comparison.json)의
`paired_comparisons`에 있다. 통계적 유의성 검정이나 다른 보드에 대한 일반화는 하지 않았다.

## 실제 실행 주소

표는 Thumb 비트를 제외한 명령 주소다. 각 칸은 A/B가 완전히 같다.

| 함수 | A_low = B_low | A_high = B_high |
|---|---|---|
| `fndsa_fpoly_FFT` | `0x100004b0` | `0x1001c0b0` |
| `fndsa_fpoly_LDL_fft` | `0x100009a8` | `0x1001c5a8` |
| `fndsa_fpoly_add` | `0x10000874` | `0x1001c474` |
| `fndsa_fpoly_apply_basis` | `0x10000400` | `0x1001c000` |
| `fndsa_fpoly_gram_fft` | `0x10000e74` | `0x1001ca74` |
| `fndsa_fpoly_iFFT` | `0x10000658` | `0x1001c258` |
| `fndsa_fpoly_merge_fft` | `0x10000d3c` | `0x1001c93c` |
| `fndsa_fpoly_mul_fft` | `0x100008f8` | `0x1001c4f8` |
| `fndsa_fpoly_neg` | `0x100008cc` | `0x1001c4cc` |
| `fndsa_fpoly_set_small` | `0x10000854` | `0x1001c454` |
| `fndsa_fpoly_split_fft` | `0x10000a80` | `0x1001c680` |
| `fndsa_fpoly_split_selfadj_fft` | `0x10000c34` | `0x1001c834` |
| `fndsa_fpoly_sub` | `0x1000089c` | `0x1001c49c` |

A/B 사이에서 mq 내부의 iNTT와 곱셈 시험 probe 시작 주소는 다르지만, 둘 다 기본 ITCM 안이다.
그 외 함수 주소는 같다. A/B의 fpoly 함수 주소뿐 아니라 기계어도 동일하다.
전체 DTCM 심벌 주소도 네 빌드 사이에 같으며 스택 위치·크기를 바꾸지 않았다.

## 설정과 정확성

- 실제 NUCLEO-N657X0-Q, ST-LINK `003C00223335510735383531`.
- CPU 800 MHz / SYSCLK 400 MHz / HCLK 200 MHz, I/D cache OFF, TCM ECC ON.
- ITCM/DTCM 각각 256 KiB. global rodata·데이터·스택 DTCM.
- GCC 15.2.1 기존 `-O3` 애플리케이션 object/archive 그대로 사용; 재컴파일 없음.
- 원래 linker script로 대조 재링크한 ELF가 기존 측정 ELF와 byte-identical.
- 변경: text 배치와 출력 경로뿐. 계산 C/assembly, 입력, 반복수, 클럭 설정 불변.
- full 실행 순서: A_low → B_low → B_high → A_high. 후보별 1회의 full run이며 반복 캠페인은 아니다.
- `SYSCFG_CM55TCMCR` 시작/종료: 네 빌드 모두 `0x00000099`.
- `ITCMWSDISABLE`/`DTCMWSDISABLE`=0 유지. 이 실험은 대기 상태 비트를 변경하지 않았다.
- 네 full run 모두 NTT oracle/roundtrip 및 modular error 0; Barrett 2048쌍 mismatch 0.
- 각 full run에서 고정 seed host DIGEST/AUDIT 22개 일치, 서명검증·변조거부 PASS.
- CFSR/HFSR/AFSR=0, ECC 상태 정상, main stack 사용 상한 9,624 B.
- ITCM 범위(패딩 포함) 118,784 B, DTCM 예약량 225,728 B로 네 빌드 동일.
- 상수시간: 기존 계산 object 불변 및 기존 정적 검사/회귀의 연속성 확인.
  형식적 상수시간 증명, dudect, 전력/EM TVLA 또는 전체 공식 KAT 재실행을 뜻하지 않는다.

ST 문서는 기본 ITCM 64 KiB와 확장 ITCM을 구분하며, `ITCMWSDISABLE`이
확장 ITCM에 기본 적용되는 wait-state를 비활성화하는 비트임을 명시한다.
[ST RM0486](https://www.st.com/resource/en/reference_manual/rm0486-stm32n647657xx-armbased-32bit-mcus-stmicroelectronics.pdf)
(프로젝트 저장본 Rev3 p.812). 현재 레지스터값과 배치 대조 결과는 이 설명과 일치한다.

## 기존 결과의 해석과 한계

기존 배치에서는 A의 iFFT가 `0x1000EB00`, B의 iFFT가 `0x10010010`으로,
B에서 기본 ITCM 64 KiB 경계를 넘어갔다. LDL/split/merge 등도 함께 넘어갔다.
이제 주소를 맞춘 A/B 비교에서는 큰 서명 격차가 재현되지 않는다.

기존 실험은 일부 함수만 경계를 넘었고, 이번 high는 13개 함수를 모두 옮겼다.
또한 이번 공통 배치는 원래 배치와 다르다. 따라서 high−low 지연률을 기존 B의
3.7–3.9%와 정확히 같은 수치로 기대하거나, 기존 ref 대비 개선률로 바꿔 보고하면 안 된다.
기존 결과는 당시 ELF의 실측으로 보존한다. B의 코드 크기 증가는 여전히 실제 비용이다.

어느 후보도 `ntt_opt`에 승격하지 않았다. 최종 후보 순위/ref 대비 최적화 효과를
다시 정하려면 ref까지 포함한 공통 배치 정책으로 별도 비교해야 한다.

## 원시 로그와 재현 자료

### A_low

- [full 원시 로그](results/A_low/runs/full-20260913T144921Z/raw.log)
- [실행 기록](results/A_low/runs/full-20260913T144921Z/run.json)
- [링크 입력/명령/해시](build/A_low/provenance.json)
- ELF SHA-256: `e1c848e06fcc663e8a3f3c3fc269e1ffe7d6ec9832ae2285834953dfe9e44017`

### B_low

- [full 원시 로그](results/B_low/runs/full-20260913T145156Z/raw.log)
- [실행 기록](results/B_low/runs/full-20260913T145156Z/run.json)
- [링크 입력/명령/해시](build/B_low/provenance.json)
- ELF SHA-256: `713a9ba9f5d23ef657735360a03b0fd6abb09dc0c0477985daf08f3722809d9c`

### A_high

- [full 원시 로그](results/A_high/runs/full-20260913T145539Z/raw.log)
- [실행 기록](results/A_high/runs/full-20260913T145539Z/run.json)
- [링크 입력/명령/해시](build/A_high/provenance.json)
- ELF SHA-256: `2dbd98aa8093f09b7bd0b0f7fef66823a081b9d8a2f9bf4a60a7c02bbb3b6587`

### B_high

- [full 원시 로그](results/B_high/runs/full-20260913T145342Z/raw.log)
- [실행 기록](results/B_high/runs/full-20260913T145342Z/run.json)
- [링크 입력/명령/해시](build/B_high/provenance.json)
- ELF SHA-256: `47ad05a4d1c1fddb9b2c258f020e8d0bc457ccb2f2d4886ac97149bd8c454169`

[통제 방법과 재현 명령](README.md), [주소·결과 감사 JSON](results/comparison.json).
