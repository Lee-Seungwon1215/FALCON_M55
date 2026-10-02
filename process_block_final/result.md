# process_block_final — 채택한 1~5단계 직접 통합 결과

측정일: 2026-10-01 (KST). 대상은 단일 Keccak의
`fndsa_sha3_process_block()` 한 함수이며, [sha3_cm55.s](sha3_cm55.s)에
IO3 + T8 + R9 + C4 + I4를 직접 통합했다.
원본과 통합본은 모두 같은 실물 NUCLEO-N657X0-Q에서 실행했다.

## 핵심 결과

| 구현 | 전체 함수 cycles | 원본 대비 속도 배율 |
| --- | ---: | ---: |
| 원본 `sha3_cm4.s`, 같은 M55에서 실행 | 13,383 | 1.0000배 |
| 통합 시작점: 1단계 IO3만 적용 | 12,662 | 1.0569배 |
| **최종: 채택한 1~5단계 통합** | **11,482** | **1.1656배** |

배율은 원본 cycles / 후보 cycles다. 전체 함수 한 번의 24라운드 계산과
입출력·비트 변환·레지스터 저장/복원을 모두 포함하며, 빈 측정 wrapper 비용을 차감했다.
대표값은 100표본 × 64회 호출의 표본당 평균을 구한 뒤 그 중앙값이다.

원본보다 **1,901 cycles** 줄었고, 1단계 단독보다 **1.1028배** 빨라졌다.
**이 배율은 전체 FN-DSA 키생성·서명·검증 API의 배율이 아니다.**
이번에는 그 API의 성능을 재측정하지 않았다.

## 누적 통합 과정에서 실제로 측정한 값

독립 실험의 배율을 곱하거나 cycle 차이를 더해 예상한 값이 아니다.
이 폴더의 생산 소스에 한 단계씩 통합한 뒤 같은 보드에서 다시 측정했다.

| 누적 구현 | 적용 내용 | 전체 cycles | 원본 대비 배율 | 직전 구현보다 줄어든 cycles |
| --- | --- | ---: | ---: | ---: |
| N1 | IO3: 입력·출력과 비트 변환 | 12,662 | 1.0569배 | 721 |
| N12 | 위 + T8: 초기 열 XOR·θ 계산 배치 | 11,972 | 1.1179배 | 690 |
| N123 | 위 + R9: ρ·π와 결합된 재배열/읽기 배치 | 11,695 | 1.1443배 | 277 |
| N1234 | 위 + C4: χ와 다음 열 XOR에서 doubleword 읽기 | 11,527 | 1.1610배 | 168 |
| **N12345** | **위 + I4: ι의 RC 포인터 재사용** | **11,482** | **1.1656배** | **45** |

모든 누적 단계가 직전 단계보다 빨랐으므로, 이번 통합에서는 되돌린 단계가 없다.
이 표는 각각의 구간 시간 표가 아니라 **각 누적 구현의 전체 함수 시간**이다.
개별 실험의 이득과 통합 후의 한 단계 추가 이득은 반드시 같지는 않다.

중간 소스는 [validation/candidates](validation/candidates)에 각각 보존했고,
소스 hash로 실제 실행 이미지와 연결했다.
현재 생산 파일은 `N12345_all.s`와 완전히 같다.
[누적 실행 목록](validation/kernel_compare/experiments.json)에 모든 새 실행을 기록했다.

## 한 함수 안에 직접 통합한 방식

| 단계 | 채택한 코드 | 실제 변경 |
| --- | --- | --- |
| 1 | process_block의 IO3 | MVE `4×32-bit` 비트 분리/복원. 20개 word를 5×4개로 처리하고 나머지 1개는 scalar 처리 |
| 2 | process_block2의 T8 | 초기 열 XOR와 θ의 독립 rotate/XOR 및 읽기 순서를 교차 배치 |
| 3 | process_block3의 R9_seed_two_word_hybrid | 기존 지연 회전을 유지하면서 π 재배열과 다음 열 XOR의 입력 읽기를 결합 |
| 4 | process_block4의 C4_doubleword_load | χ의 상태 읽기를 register-pair VMOV와 LDRD로 묶음. Boolean 계산과 회전 규칙 유지 |
| 5 | process_block5의 I4_push_preserve | R9에 RC 포인터를 한 번 준비하고 매 라운드 `LDRD [R9], #8`로 상수 두 word 읽기 |

1단계는 MVE 정수 연산이고, 2~5단계는 실험에서 채택한 scalar 정수 ASM 배치다.
전 구간을 억지로 MVE화하지 않았고 부동소수점 산술도 추가하지 않았다.
이 구현은 **한 상태의 Keccak**이며 x4 메시지 병렬 API가 아니다.

공개 함수 이름·ABI·24라운드·round constants·상태 표현은 유지했다.
생산 코드에는 후보 선택 매크로, 외부 후보 include/link, 계측 프로브 또는 SLOTHY가 없다.
Makefile은 원래부터 이 폴더의 `sha3_cm55.s`를 빌드하므로 변경할 필요가 없었다.

[sha3.c](sha3.c), 원본 [sha3_cm4.s](sha3_cm4.s), inject/helper 함수,
기존 NTT·키생성 FFT·서명 FFT 소스는 변경하지 않았다.
기존 helper/inject 부분 **1,284 bytes는 기계어도 동일**하다.
다른 독립 후보 폴더 및 `Final_code/Before_slothy`에는 반영하지 않았다.

### 통합에서 겹치는 레지스터·스택 처리

T8과 R9 후보가 임시로 쓰는 R9/R14를 복원해야 I4의 RC 포인터 및
원본 라운드 카운터가 유지된다. 이를 한 스택 배치로 통합했다.

| body SP 기준 offset | 용도 |
| --- | --- |
| 0..71 | 상태 A[16..24] |
| 72..75 | 외부 상태 포인터 |
| 76..79 | rate |
| 80..87 | θ의 R14/R9 보존; 이후 π의 기존 A[6] 보존 |
| 88..91 | π의 R14 라운드 카운터 보존 |
| 92..95 | π의 R9 RC 포인터 보존 |
| 96..99 | 8-byte 정렬 padding |

전체 frame은 GPR 저장 36 B + D8..D15 저장 64 B + locals 100 B = **200 B**다.
Q0..Q7은 D0..D15와 겹치므로 MVE 비트 변환은 D-state를 읽기 전/모두 저장한 후에만 실행한다.

원본의 관찰된 경계 표현인 A[0..20] 일반 표현 / A[21..24] split 표현도 유지했다.
이번 작업은 원본의 rate 처리 또는 상태 저장 계약을 변경하는 작업이 아니다.

## 자원 비용

| 항목 | 원본 | 1단계 IO3 | 최종 통합 |
| --- | ---: | ---: | ---: |
| sha3 ASM .text, helper/RC 포함 | 4,184 B | 6,364 B | **6,384 B** |
| 함수 스택 frame | 184 B | 184 B | **200 B** |
| 새 외부 scratch / heap | 0 B | 0 B | **0 B** |

통합본은 원본보다 code 2,200 B, stack 16 B가 늘었다.
1단계 시작점 대비 code 증가는 20 B다.
전체 검사 펌웨어가 256 KiB ITCM / 256 KiB DTCM 안에 링크되고 실행됐다.
이 폴더의 독립 라이브러리 빌드도 통과했다.

## 정확성·KAT·서명검증·상수시간 관련 검사

| 검사 | 최종 통합본 결과 |
| --- | --- |
| 독립 canonical Keccak oracle | 1,024회, bit-exact 일치 |
| 활성 MVE 경계·정렬·guard | 1,600건 통과: 정렬 4종 × rate 5종 × 입력 80종 |
| 원본 scalar helper oracle/왕복 | 5,120건 통과; MVE 변환의 직접 검사는 위 별도 시험으로 수행 |
| SHAKE128 / SHAKE256 | 각각 독립 Python hashlib 7개 벡터 일치; 출력 384 B / 256 B |
| ABI | 16건, R4..R11 및 D8..D15 보존 |
| 키생성 KAT | **300/300 일치**, n=256/512/1024 각 100건 |
| 서명 KAT | **90/90 일치**, 정상 서명 검증·변조 거부 통과 |
| API 경계/오류 | 정상 64건 수락, 잘못된 입력 3,902건 거부; failure/guard=0 |
| 보드 오류 상태 | 유효 실행의 CFSR/HFSR/AFSR=0; TCM/ECC 설정 시작·종료 확인 |
| 정적 통합 감사 | 채택한 다섯 영역 직접 통합, 나머지 암호 소스 불변, 보존/스택 정렬 검사 통과 |

정수 bit permutation이므로 FP 근사 오차 대신 **bit-exact** 일치를 검사했다.
유한 시험은 모든 입력에서의 동등성을 증명한 것은 아니다.

라운드 core에 새 함수 호출이나 데이터 의존 분기/주소 계산을 추가하지 않았다.
원래의 고정 24라운드 카운터와 RC 상수 증가 주소를 유지했다.
최종 plain 펌웨어에서 zero/random 입력군을 각각 1,000회 interleave 측정했고,
두 군 모두 wrapper 포함 min=max **11,485 cycles**였다.
이는 빈 wrapper를 차감한 표의 11,482 cycles와 다른 측정 경계다.

**이 검사는 정적 분석 및 제한된 입력의 시간 관측이다.
전체 상수시간 형식 증명, 전력/EM 또는 fault injection 검증을 완료했다는 뜻은 아니다.**

## 코드 위치 영향 추가 대조

원본과 통합본의 함수 entry, 상태 배열, timed stack top은 동일하게 배치했다.
별도 aligned 펌웨어에서는 초기 계산 진입점을 함수 시작 +0x800으로 맞췄다.
이 padding/branch는 검사 이미지에만 있고 생산 ASM에는 없다.

| 추가 대조 | 원본 cycles | 통합 cycles | 속도 배율 |
| --- | ---: | ---: | ---: |
| 초기 계산 진입 위치 고정 | 13,385 | 11,484 | **1.1655배** |

이 대조에서도 1,901 cycles 차이가 유지됐다.
다만 모든 θ·χ·π 내부 명령 주소까지 같게 고정한 시험은 아니다.

함수 entry=0x10000844, guard 객체=0x30003000, 실제 상태 배열=0x30003020,
timed stack top=0x30005000.

## 보드·빌드·측정 조건

- 실제 NUCLEO-N657X0-Q / STM32N657 Cortex-M55,
  ST-Link `003C00223335510735383531`.
- CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz.
- 코드 ITCM, 상수·데이터·스택 DTCM, 각각 256 KiB.
  I/D cache OFF, ECC ON, 측정 중 interrupt OFF.
- GNU Arm GCC 15.2.1, Zephyr 4.4.1,
  mlkem-native pin `637d076aa113d8faaec2277ed4a46b657acaf35f`.
- C 빌드: `-O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard`,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- DWT CYCCNT. Warm-up 5묶음 후 100표본 × 64호출.
  입력 생성·oracle·출력은 타이밍 밖이며 빈 wrapper를 차감한다.
- 원본과 각 후보는 같은 보드에서 공유 lock으로 직렬 실행했다.
  plain의 측정 대상 .text는 생산 object와 byte-identical이다.
- 실제 보드 로딩은 DTCM 구간까지 포함한 full ELF다.
  incidental BIN은 주소 사이 빈 공간을 피하도록 코드 부분만 생성하므로 배포 이미지가 아니다.

## 증거·재현

원본 source SHA256:
`b313a4da7943202e97ed6753c71ebbf20d9fb9e2f44ce7cd67007e2461b6c830`.

최종 source SHA256:
`8da25be7532a6c6fc2bcd5977a4548ca58ec4d3afdaedea0dc0933868accefe7`.

- [전체 통계](validation/kernel_compare/summary.json),
  [누적 실행 index](validation/kernel_compare/experiments.json),
  [최종 정적 감사](validation/static_audit.json).
- [원본 plain 로그](validation/kernel_compare/results/ref-plain/20261001T115612Z/raw.log),
  [통합 plain 로그·oracle·ABI·timing](validation/kernel_compare/results/mve-plain/20261001T120617Z/raw.log).
- [aligned 원본](validation/kernel_compare/results/ref-aligned/20261001T120620Z/raw.log),
  [aligned 통합](validation/kernel_compare/results/mve-aligned/20261001T120624Z/raw.log).
- [키생성 KAT](validation/results/mve_kat/20261001T120655Z/raw.log),
  [서명 KAT](validation/results/mve_sigkat/20261001T120739Z/raw.log),
  [API 검사](validation/results/mve_api/20261001T120748Z/raw.log).
- [독립 라이브러리 빌드](validation/library_build.log).

각 실행 디렉터리에 ELF, map, disassembly, source archive, compile commands,
소스·ELF·로그 hash와 유효성 manifest를 보관했다.
재현 명령은 [README.md](README.md)에 있다.
복사돼 있던 IO-only 문서는 [이전 README](validation/imported_README.md)와
[이전 result](validation/imported_result.md)에 그대로 보존했다.
이전 단계별 FFT 프로파일 문서는 이번 Keccak 통합 결과가 아니다.
