# KAT 유지형 two-double FP64 FFT 결과

측정일: 2026-09-18. **원본 KAT 300/300 일치. 하지만 전체 키 생성은 512에서 3.6791배, 1024에서 2.6937배 시간이 걸린다. 성능 개선 후보로 채택하지 않았으며 기존 통합 ref는 변경하지 않았다.**

이 결과는 일반적인 single-double 실수 FFT가 아니다. 두 double에 원본 Q32.32 raw 상·하위 워드를 담고, 하드웨어 FP64 부분곱·덧셈·뺄셈으로 원본의 절삭·wrap·반올림 규칙을 재현한 후보다. FP64 명령 실행과 KAT 보존은 확인했지만, **빠른 native FP64 FFT라는 최종 성능 목표는 달성하지 못했다.** 다른 FP64 방식까지 모두 느리다는 결론은 아니다.

## 1. 비교 대상과 구현 범위

| 구분 | 실제 소스 |
|---|---|
| 기준: 원본 고정소수점 FFT | `../../ref` (`4_ntrusolve_approximate_k/ref`) |
| 실험: KAT 호환 FP64 | 이 폴더 `fp64_kat_exact` |

기준 코드에도 기존 NTT 최적화가 들어 있다. 아래 수치는 태초의 `fn-dsa_m55/ref` 또는 과거 M4 보드와의 비교가 아니다. FFT만 바꾸기 전후를 같은 M55에서 새로 비교했다.

암호 소스는 기준에서 복사한 독립 소스이며, 변경 파일은 다음 네 개뿐이다. 다른 후보의 암호 소스를 링크하거나 옵션으로 선택하지 않는다.

| 파일 | 변경 사항 |
|---|---|
| [kgen_inner.h](kgen_inner.h) | `fp64_exact`, raw 변환, add/sub/neg/half/round/mul2e, 새 함수 선언 |
| [kgen_fxp.c](kgen_fxp.c) | 정확한 FP64 부분곱, FFT/iFFT/점별 곱, 역수 준비와 정확한 나눗셈 보정 |
| [kgen_poly.c](kgen_poly.c) | `poly_big_to_fp64_exact()` 입력 변환 |
| [kgen_ntru.c](kgen_ntru.c) | `solve_NTRU_intermediate()`의 ④ 근사계산 경로와 임시 배열 |

- 기존 3-product 복소수 곱셈, 각 산술 연산의 절삭/wrap, iFFT의 단계별 half를 보존한다. 기존 GM 상수표 비트도 그대로 사용한다.
- ④ 내부의 새 FFT에서 기존 FFT로 돌아가는 fallback이나 두 FFT를 모두 계산해 선택하는 경로는 없다.
- 비트/캐리 추출용 정수 변환, 나눗셈의 정확한 정수 보정은 남아 있다. 모든 연산을 부동소수점으로 바꿨다는 뜻은 아니다.
- ⑤ depth0, 후보 검사, NTT/CRT/Bezout, 정수 해 갱신, reject 조건, 서명·검증 구현은 변경하지 않았다.
- 이전 `1st_native_fp64`, `fp64_final_scaling`, `hybrid_fixed_div`, `fp64_q32_compat`의 암호 소스는 SHA-256 대조로 보존을 확인했다. 이전 26건 불일치 후보를 덮어쓴 것이 아니다.

산술 범위와 정확성 논리는 [design.md](design.md)에 정리했다.

## 2. 보드·빌드·계측 조건

| 항목 | 조건 |
|---|---|
| 보드 | 연결된 NUCLEO-N657X0-Q, STM32N657 Cortex-M55 |
| ST-LINK | `003C00223335510735383531` 한 대만 순차 사용 |
| CPU / 캐시 | 800 MHz / I-cache·D-cache OFF |
| 메모리 | ITCM/DTCM 각각 256 KiB 설정, 코드 하위 128 KiB ITCM 범위 사용, 상수·데이터·스택 DTCM |
| 확인한 레지스터 | `TCM_CONTROL=0x99`, `ITCMCR=DTCMCR=0x49`, `CCR=0x611`; fault 상태 0 |
| 공통 플랫폼 | 고정된 mlkem-native `637d076aa113d8faaec2277ed4a46b657acaf35f` 기반 기존 측정 환경과 DTCM 상수 배치 정책 |
| 컴파일러 | Arm GNU GCC 15.2.1 |
| 암호 코드 옵션 | `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing`; 양쪽 동일 |
| 기존 최적화 | M4 어셈블리 및 M55/MVE MP31 경로 ON, 양쪽 동일 |
| 스택 / 진단 옵션 | main stack 64 KiB, 양쪽 `-fstack-usage` |
| 입력 / 횟수 | 512·1024 각각 `test0`~`test99`, 준비 실행 1회 후 100개 서로 다른 seed |
| 시간 | DWT cycle counter, 키 생성 구간에서 IRQ 차단. 출력·서명·검증은 키 생성 시간에서 제외 |

`perf`는 구간별 계측을 넣지 않은 전체 키 생성 시간이다. `profile`은 별도 펌웨어에서 ④ 준비/반복 구간을 계측한다. 두 결과를 섞어서 전체 성능을 계산하지 않았다. 함수 실행 주소 자체를 양쪽에서 고정한 실험은 아니며, 메모리 배치 정책을 동일하게 맞췄다.

## 3. 전체 키 생성 성능

단위는 cycles/key, 100회 산술평균. 시간 배수는 **FP64 / 기준**, 1보다 크면 느려진 것이다.

| 크기 | 기준 고정소수점 | KAT 호환 FP64 | 시간 배수 | 사이클 증가율 |
|---|---:|---:|---:|---:|
| 512 | 57,007,002.22 | 209,733,076.99 | **3.6791배** | **+267.91%** |
| 1024 | 243,375,295.54 | 655,568,513.49 | **2.6937배** | **+169.37%** |

| 크기 | 기준 중앙 표본값 | FP64 중앙 표본값 | FP64 최소 | FP64 최대 |
|---|---:|---:|---:|---:|
| 512 | 48,150,560 | 195,532,363 | 188,540,673 | 418,959,322 |
| 1024 | 195,772,943 | 589,167,784 | 532,887,812 | 1,368,389,419 |

로그의 `median`은 정렬한 100개 표본의 인덱스 50, 즉 상위 중앙값이다. 두 중앙 표본의 평균이 아니다. 최대 측정 구간은 DWT 32-bit 범위 안이며, 전체 실행 시간과도 일관된다. 이 표는 각 입력 한 번씩의 한 배치 결과이지, 반복 배치 기반 신뢰구간 추정은 아니다.

기준과 FP64의 200개 키·결정적 서명 digest가 모두 일치한다. `profile` 및 host의 같은 seed 결과도 동일하다. 따라서 이전 일반 FP64 후보의 KAT 불일치처럼 서로 다른 출력/후보 경로를 비교한 결과가 아니다.

## 4. ④ 내부에서 느려진 구간

별도 `profile`의 총 cycle을 100개 키로 나눈 값이다. 준비/반복 호출 횟수는 양쪽이 동일하다.

| 크기 | 구간 | 기준 cycles/key | FP64 cycles/key | 시간 배수 |
|---|---|---:|---:|---:|
| 512 | 입력 변환 → FFT → 역수 준비 | 1,083,140.37 | 5,752,697.30 | 5.31배 |
| 512 | 반복 입력 변환 → FFT → 점별 곱 → iFFT → 정수 k | 4,740,769.99 | 152,690,150.92 | **32.21배** |
| 1024 | 입력 변환 → FFT → 역수 준비 | 2,201,931.68 | 12,974,838.82 | 5.89배 |
| 1024 | 반복 입력 변환 → FFT → 점별 곱 → iFFT → 정수 k | 13,442,744.34 | 414,553,586.82 | **30.84배** |

100개 키의 준비/반복 호출 총수: 512는 879 / 92,174회, 1024는 1,107 / 251,354회. 이 표의 반복 구간에는 정확한 정수 NTRU 해 갱신은 들어 있지 않다.

실제 NTRU 입력 19개를 고정해 준비 및 반복 커널도 분리 측정했다. 준비 10회 후 각 100회, 기준/후보 측정 순서를 번갈아 사용했다. 아래는 각 logn의 첫 입력 사례의 반복 커널 평균이며, 입력 변환은 제외하고 FFT·점별 곱·iFFT·반올림을 비교한다. 전체 19개 원자료는 [집계 JSON](validation/results/summary.json)의 `kernels`에 있다.

| 내부 logn | 기준 cycles | FP64 cycles | 시간 배수 |
|---|---:|---:|---:|
| 4 | 4,902.00 | 194,308.00 | 39.64배 |
| 6 | 27,480.00 | 1,170,462.03 | 42.59배 |
| 8 | 141,838.01 | 6,251,888.05 | 44.08배 |
| 9 | 316,175.00 | 14,073,385.18 | 44.51배 |

실행 ELF의 `fp64e_mul()`은 99개 명령이며, 정적 검사에서 FP64 연산/변환 명령 76개를 센다. 원본 64-bit raw 정보와 곱셈 절삭을 유지하려고 16-bit 부분곱, 캐리 추출, 정규화를 반복한다. FPGA나 소프트웨어 double로 우회된 것이 아니라 실제 FP64 명령이지만, **연산 수·변환·임시값 저장 비용이 커져 느리다.** 이 후보의 구조적 비용이며 M55의 일반적인 단일-double FFT 성능을 나타내는 수치는 아니다.

## 5. 정확성·KAT·서명검증

| 검사 | 결과 및 범위 |
|---|---|
| Host 원본 keygen KAT | **300/300 일치**: 256·512·1024 각각 100개. 256은 upstream의 진단용 크기 |
| M55 원본 keygen KAT | **300/300 일치**, 각각 정수 방정식 `fG−gF=q` 및 출력 범위 검사 통과 |
| Host scheme KAT / 자체 검사 | PASS; 원본 기대값 변경 없음 |
| Host 임의 정밀도 정수 oracle | 1,036,100 operand pairs, 7,252,700 primitive 검사 통과 |
| Host FFT/점별 곱/iFFT | 245,520 coefficient 비교에서 raw 비트 동일, logn 1~10 |
| Host 역수 준비 / 입력 변환 | 20,460 / 112,530 coefficient 비교 동일 |
| 과거 불일치 입력 재생 | `512/test58`, `1024/test65`에서 저장된 raw 출력까지 일치 |
| M55 primitive 대조 | 100,000쌍 × mul/add/half/div = 400,000 비교 통과 |
| M55 고정 입력 커널 | 19개 사례, 각 100회에서 준비·반복 raw 결과 및 정수 k 일치 |
| 서명·검증·변조 거부 | Host 기존 200 seed + 추가 200 seed 통과, 기준/후보 digest 동일. M55 perf/profile 각 200개 키의 서명·검증·변조 거부 통과 |
| UBSan + float-cast-overflow | 수정된 `kgen_fxp/kgen_poly/kgen_ntru` translation unit을 계측해 KAT·서명 시험 통과. 보드 ASM까지 검증하는 것은 아님 |

여기서 “오차 0”은 **원본 Q32.32 결과와의 차이가 시험한 범위에서 0**이라는 뜻이다. 이상적인 실수 FFT에 대한 수학적 근사 오차가 0이라는 뜻은 아니다. 유한 테스트만으로 모든 입력의 정확성을 증명했다고 주장하지 않는다.

추가 메모리 검사인 AddressSanitizer는 실행하지 못했다. macOS ASan이 빈 `main()` 프로그램에서도 초기화 시 `sanitizer_malloc_mac.inc:189` CHECK 오류로 종료했다. **ASan 통과로 취급하지 않는다.** [진단 요약](validation/build/asan/summary.json), [빈 프로그램 로그](validation/build/asan/runtime_smoke.log), [최초 KAT 실행 로그](validation/build/asan/kat_audit.log).

## 6. 상수시간 확인의 범위

- 실제 ELF에서 FP64 multiply 및 나눗셈 보정 함수의 조건분기·IT·외부 호출 없음 확인. FFT 및 변환 함수의 분기는 공개 크기/루프/limb 길이 기반인지 검토했다.
- 새 FFT/점별 곱 경로에서 기존 고정소수점 FFT 호출, `__aeabi_d*` 소프트웨어 double helper, fused `VFMA/VFMS` 없음 확인. 비융합 `VMLA/VMLS`는 사용된다.
- M55에서 mul/add/half/div 각각 20종 입력, 각 256회 연산을 20개 유효 trial로 관찰했다. 입력 종류별 최소 cycle이 같고 trial 내 최대 흔들림은 0~1 cycle이었다.
- FFT/iFFT는 logn 1~10 각각 20종 입력 × 20개 유효 trial로 비교했다. 같은 크기·방향에서 종류별 최소 cycle이 같고 흔들림은 0~1 cycle이었다. logn=1 변환은 실질적으로 계산이 없는 경로다.

**관찰한 입력에서 timing 차이를 발견하지 못했다는 결과이며, 완전한 상수시간 증명이나 dudect 통계 검정, 전력·EM 보안 검증은 아니다.** 전체 키 생성은 후보 재시도로 실행 시간이 달라지므로 이 커널 검사로 전체 키 생성 시간이 일정하다고 주장하지 않는다. 정적 검사 자료는 [ELF 감사 요약](validation/results/static/summary.json)에 있다.

## 7. 메모리

| 항목 | 기준 perf | FP64 perf | 변화 |
|---|---:|---:|---:|
| 링커 `FLASH` 영역 사용량 | 101,780 B | 106,560 B | +4,780 B |
| 링커 `RAM` 영역 사용량 | 220,296 B | 220,296 B | 동일한 스택 예약량 포함 |
| stack watermark 관찰 사용량 | 9,488 B | 18,696 B | +9,208 B |

링커 이름은 `FLASH`지만 이 보드 측정에서 실행 코드는 ITCM에 적재된다. 링커 영역 사용량은 순수 함수 text 크기와는 다르다.

`fp_work[1024]`는 16 KiB 로컬 배열이며, GCC가 보고한 `solve_NTRU_intermediate()` 프레임은 16,592 B이다. 원본 tmp API 크기와 정수 arena offset은 유지했다. 64 KiB 스택의 실측 미사용 prefix는 후보 perf에서 46,840 B, KAT에서 47,360 B였다. watermark는 해당 시험에서 관찰한 값이지 모든 호출 상황의 최대 사용량 증명은 아니다. 작은 스택의 다른 환경에 그대로 배포해서는 안 된다.

## 8. 로그와 재현

- [최종 집계](validation/results/summary.json): 전체·구간별·19개 커널 성능, CT 관찰, 스택, source hashes.
- [Host 요약](validation/build/host/summary.json), [Host 실행 기록](validation/results/build_logs/fp64-exact-host.log).
- [M55 KAT 원문](validation/results/kat/20260918T095303Z/raw.log), [KAT 실행·소스 manifest](validation/results/kat/20260918T095303Z/run.json).
- [기준 perf](validation/results/ref-perf/20260918T095506Z/raw.log), [후보 perf](validation/results/compat-perf/20260918T095554Z/raw.log).
- [기준 profile](validation/results/ref-profile/20260918T095754Z/raw.log), [후보 profile](validation/results/compat-profile/20260918T095843Z/raw.log).
- [M55 커널·CT 원문](validation/results/kernels/20260918T095056Z/raw.log).
- [기준 빌드 로그](validation/results/build_logs/fp64-exact-refresh-ref-perf.log), [후보 빌드 로그](validation/results/build_logs/fp64-exact-refresh-compat-perf.log).

각 보드 로그 옆 `run.json`에 ELF·실제 crypto source·빌드 명령·생성된 계측본의 SHA-256을 보존했다. 분석 시 현재 빌드 산출물, 정적 감사 ELF, host/board 출력의 일치도 재확인한다. 분석기와 ASan 환경 진단 스크립트는 보드 실행 후 보강했지만, 측정에 사용한 C/H/S 및 빌드 산출물은 변경하지 않았다.

빌드/실행 방법은 [README.md](README.md). `compat-perf`/`compat-profile`은 이 새 후보를 지칭하는 harness label이며 이전 `fp64_q32_compat`와 혼동하지 않는다. 테스트의 두 과거 불일치 재생만 이전 진단 폴더의 저장 입력을 참조한다. 암호 구현 자체가 이전 후보의 소스에 종속된 것은 아니다.

최종 판단: **KAT 호환성을 확인하는 실험으로 보존. 속도 개선용 통합 ref로는 미채택.**
