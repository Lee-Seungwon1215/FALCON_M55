> 진단용 동일 정수 코드 주소 배치. 계산 소스는 그대로이며 정수 루틴 8개만 양쪽에서 같은 ITCM 주소로 옮겼다. 기본 통합 펌웨어나 최종 ref를 교체한 결과는 아니다.

# M55_ref 대비 현재 후보 전체 키 생성 재측정

2026-09-26 KST. 두 소스 트리를 직접 빌드하고 같은 M55 보드에서 순서대로 측정했다. 암호 구현은 수정하지 않았다.

## 결과 — 100개 동일 입력의 총 시간 비율

| n | M55_ref 평균 cycles | 현재 평균 cycles | 기준 평균 ms | 현재 평균 ms | 배속 | 시간 감소 |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | 62,738,244.17 | 60,138,543.80 | 78.423 | 75.173 | **1.0432×** | **4.144%** |
| 1024 | 261,716,429.84 | 250,808,606.83 | 327.146 | 313.511 | **1.0435×** | **4.168%** |

`배속 = Σ M55_ref cycles / Σ 현재 cycles`이며 개별 입력 배속의 단순평균이 아니다. 시간 감소는 `1 − 현재 총 시간 / 기준 총 시간`이다. n별 동일한 100개 seed에 대한 결과이지 모든 난수 입력의 보장값은 아니다.

## 조건과 범위

- 기준: `fn-dsa_m55/M55_ref` 전체 구현. M4 어셈블리를 끄지 않고 M55 호환 모드로 실행.
- 현재: `fn-dsa_m55/function_compare/twfalcon/integration_candidate` 전체 구현. 11단계 사전 변환 상수표 사용.
- NUCLEO-N657X0-Q, CPU 800 MHz, 캐시 OFF, 코드 ITCM·데이터/상수/스택 DTCM 각 256 KiB.
- GCC 15.2.1, `-O3`, `-mfpu=fpv5-d16`, `-ffp-contract=off`, `-fno-fast-math`, 같은 FP 환경.
- 같은 `board_keygen_perf.c`와 Zephyr 설정·링커 배치 정책. 각 구현 소스는 원래 경로에서 빌드. 별도 펌웨어이므로 함수/버퍼의 세부 주소까지 고정한 비교는 아니다.
- n=512,1024 각각 원본 KAT의 `test0`..`test99` 100개 입력을 한 번씩 계측. 각 크기별 warmup 3회는 제외.
- 계측 대상: `fndsa_keygen_seeded_temp()` 전체. 실패 후보 재시도, 공개키 계산, 비밀키·공개키 인코딩을 포함.
- 계측 제외: seed 문자열 준비, 출력 해시, 원본 KAT 비교, NTRU 방정식 재검사, 로그 출력.
- 긴 호출의 wrap 문제를 피하도록 64-bit SysTick cycle counter 사용. 두 실행 모두 인터럽트 ON이므로 짧은 시스템 tick 처리 비용도 포함. 이전 FFT 커널의 IRQ OFF 계측과 수치/분모를 혼합하지 않는다.
- 현재 트리는 NTT 및 주변 FP64/Q32 연산·invnorm 개선도 포함하므로 이 배속을 **FFT만의 기여**로 해석하면 안 된다.

## 입력별 분포

| n | 기준 중앙값 | 현재 중앙값 | 기준 min~max | 현재 min~max | 빨라진 입력 수 |
| ---: | ---: | ---: | --- | --- | ---: |
| 512 | 53,540,318 | 51,047,604 | 46,436,887 ~ 135,545,997 | 44,380,566 ~ 128,859,544 | 100/100 |
| 1024 | 212,966,851 | 200,880,719 | 155,582,023 ~ 769,576,501 | 147,697,317 ~ 750,209,225 | 100/100 |

입력별 재시도 횟수가 달라 실행 시간이 넓게 퍼진다. 그래서 과거 다른 seed 집합의 평균/중앙값을 가져오지 않고 이번 동일 seed 집합끼리 비교했다.

## 검증

- 각 구현: KAT 및 NTRU 방정식 **200/200 PASS** (512 100 + 1024 100).
- 두 구현의 인코딩된 비밀키+공개키 SHA-256: **200/200쌍 일치**.
- CFSR/HFSR/AFSR=0, TCM/ECC 검사 PASS. 실행 중 소스 변경 없음.
- 두 펌웨어의 Zephyr 설정과 생성된 링커 스크립트 SHA-256 일치, 두 keygen 진입점은 ITCM, 작업 버퍼·스택은 DTCM 주소 범위 확인.

## 로그

- [M55_ref 원시 로그](/Users/seungwon/FALCON/fn-dsa_m55/function_compare/twfalcon/integration_candidate/validation/results/keylayout_ref/20260926T093459Z/raw.log)
- [현재 원시 로그](raw.log)
- [수치 JSON](keygen_comparison.json)
- [현재 실행 manifest](run.json)

재실행: `validation/build.sh keygen_ref` / `keygen_current`를 빌드하고, 동일 이름으로 `validation/run_board.py`를 보드별 순차 실행한다. 마지막으로 `tools/summarize_keygen.py <reference-result-dir> <current-result-dir>`를 실행한다.
