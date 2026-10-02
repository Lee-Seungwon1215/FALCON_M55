# FP64 C → 직접 작성한 FP64 inline assembly 비교

측정일: 2026-09-22. **핵심 곱셈을 inline assembly로 구현하고 M55에서 시험했다.
원본 KAT 300/300 일치. 곱셈 단독은 1.38% cycle 감소했지만 전체 키 생성은
FP64 C보다 512에서 0.635%, 1024에서 0.599% cycle이 증가했다.**

통합 ref는 변경하지 않았다. 이 후보는 실험용으로 보존하며, 현재 결과로는
속도 개선용 대체 구현으로 채택하지 않는다. 모든 FP64 방식이 느리다는 결론도,
더 이상 최적화할 여지가 없다는 결론도 아니다.

## 1. 무엇을 바꿨는가

암호 소스는 `../fp64_kat_exact`에서 복사한 독립 구현이다.
변경 범위는 [kgen_fxp.c](kgen_fxp.c)의 `fp64e_mul()` 하나다.

- FFT의 C 반복문, two-double 자료형, 15개 16-bit 계수 부분곱,
  carry·절삭·wrap·signed 보정 및 out-of-line 호출 구조를 유지했다.
- 곱셈 본문을 `VMUL/VMLA/VMLS/VCVT.F64` 등을 사용하는 extended inline
  assembly로 직접 작성했다. 레지스터와 명령 순서를 지정했다.
- 함수 내부에 assembly를 넣은 것이며, 함수 호출 자체를 없앤 실험은 아니다.
- ④ 근사 k 경로의 기존 FP64 코드가 대상이다. ⑤ depth0, 후보 검사,
  NTT·CRT·Bezout 및 서명·검증 구현은 변경하지 않았다.
- 일반적인 single-double 실수 FFT가 아니라 **원본 Q32.32 결과를 보존하는
  two-double 연산**이다. 비트 추출·정수 보정은 남아 있다.

[설계와 범위](design.md), [재현 방법](README.md).

## 2. 측정 조건

| 항목 | 조건 |
|---|---|
| 실제 보드 | 연결된 NUCLEO-N657X0-Q, STM32N657 Cortex-M55 |
| ST-LINK | `003C00223335510735383531`, 한 대에서 순차 실행 |
| CPU / 캐시 | 800 MHz / I-cache·D-cache OFF |
| 메모리 정책 | ITCM/DTCM 각각 256 KiB 설정. 코드 하위 128 KiB ITCM, 상수·데이터·스택 DTCM |
| 플랫폼 | 기존 pinned mlkem-native `637d076aa113d8faaec2277ed4a46b657acaf35f` 기반 측정 환경 |
| 컴파일러 | Arm GNU GCC 15.2.1 |
| 공통 옵션 | `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing -fstack-usage` |
| 기존 최적화 | M4 ASM, M55 ASM, MVE MP31 ON, 세 군 동일 |
| 전체 성능 | 512·1024 각각 `test0`~`test99`, warm-up 1회 후 100개 seed |
| 계측 | DWT, 키 생성 중 IRQ OFF. 출력·서명·검증 시간은 키 생성 시간에서 제외 |
| 안정성 | 실행 전후 source/ELF hash 검사, fault 0 및 TCM/ECC 상태 검사 |

비교 기준 `../../ref`에는 이전 NTT 최적화가 이미 있다. 태초의
`fn-dsa_m55/ref`나 M4 보드와 비교한 표가 아니다.
새로운 동일 harness로 fixed / FP64 C / FP64 ASM을 모두 다시 측정했다.
전체 함수 주소까지 고정한 실험은 아니며 **배치 정책**이 같다.
각 군 100개 입력의 한 배치 결과로, 반복 배치 신뢰구간을 산출하지 않았다.

## 3. 전체 키 생성

단위: cycles/key, 100개 입력 산술평균. **증가율의 +는 느려짐**이다.

| 크기 | 고정소수점 ref | 기존 FP64 C | 새 FP64 ASM | ASM/C cycle 변화 | ASM/fixed 시간 배수 |
|---|---:|---:|---:|---:|---:|
| 512 | 57,007,002.21 | 209,733,076.99 | 211,064,606.87 | **+0.6349%** | **3.7024배** |
| 1024 | 243,375,295.54 | 655,568,513.49 | 659,495,898.14 | **+0.5991%** | **2.7098배** |

| 크기 | ASM 상위 중앙값 | ASM 최소 | ASM 최대 |
|---|---:|---:|---:|
| 512 | 196,836,545 | 189,844,855 | 421,567,686 |
| 1024 | 593,044,184 | 536,764,212 | 1,375,997,019 |

중앙값은 정렬한 100개 표본의 index 50이다. 최대 구간도 DWT의 32-bit
측정 범위 안이다. 동일 입력의 key/signature digest와 구간 호출 횟수까지
대조하므로 KAT 불일치에 따른 서로 다른 후보 탐색을 비교하지 않는다.

## 4. 곱셈과 FFT 커널

같은 ELF 안에서 측정 순서를 교대했다. 곱셈은 같은 `uint64_t` 입출력
wrapper, 함수 포인터 호출, sink, timer를 사용한다. FP64 양쪽 모두 raw와
two-double 사이 변환을 포함한다. 아래는 256회 총 cycle을 256으로 나눈
값이며 **명령 한 개의 latency가 아니다**.

| 곱셈 | cycles/회 |
|---|---:|
| 원본 fixed | 25.015625 |
| FP64 C | 1,381.015625 |
| FP64 ASM | 1,362.015625 |

ASM/C cycle 변화 **−1.3758%**. 기존 FP64 C 대비의 소폭 개선이며,
원본 fixed보다 빠르다는 의미는 아니다.

실제 NTRU 중간 입력 19개를 사용했다. warm-up 10회 후 각 100회 측정하며,
각 실행에서 준비 결과와 반복 결과의 raw 값 및 정수 k를 모두 대조했다.
다음 표는 각 logn 첫 사례의 **반복 FFT→점별 곱→iFFT→반올림** 평균이다.
입력 변환과 정수 NTRU 해 갱신은 이 커널 표에서 제외된다.

| 내부 logn | fixed | FP64 C | FP64 ASM | ASM/C cycle 변화 |
|---|---:|---:|---:|---:|
| 4 | 4,949 | 194,375 | 195,243 | +0.447% |
| 6 | 27,651 | 1,170,699 | 1,181,075 | +0.886% |
| 8 | 142,897 | 6,252,799 | 6,324,169 | +1.141% |
| 9 | 318,512 | 14,075,193 | 14,248,959 | +1.235% |

독립 FFT/iFFT는 logn 1~10도 측정했다. 예를 들어 logn=9의 class 0:

| 변환 | fixed | FP64 C | FP64 ASM |
|---|---:|---:|---:|
| FFT | 135,804 | 5,789,056 | 5,874,632 |
| iFFT | 156,188 | 6,913,965 | 7,004,413 |

위 별도 transform timing 입력군은 성능/타이밍 관찰용이다. 정확성의
raw 비교는 앞의 19개 실입력 및 primitive/KAT 시험으로 구분해 보고한다.

## 5. ④ 내부 구간 프로파일

세 군의 별도 profile 펌웨어에서 측정한 총 cycle / 100개 키다.
전체 성능은 구간 계측을 넣지 않은 3절의 별도 perf 펌웨어 결과를 사용한다.

| 크기 | 구간 | fixed cycles/key | FP64 C | FP64 ASM | ASM/C cycle 변화 |
|---|---|---:|---:|---:|---:|
| 512 | 입력 변환→FFT→역수 준비 | 1,083,140.37 | 5,752,697.30 | 5,809,043.02 | +0.9795% |
| 512 | 반복 입력 변환→FFT→점별 곱→iFFT→정수 k | 4,740,769.99 | 152,690,150.92 | 153,965,797.58 | +0.8354% |
| 1024 | 입력 변환→FFT→역수 준비 | 2,201,931.68 | 12,974,838.82 | 13,116,991.90 | +1.0956% |
| 1024 | 반복 입력 변환→FFT→점별 곱→iFFT→정수 k | 13,442,744.34 | 414,553,586.82 | 418,340,235.27 | +0.9134% |

100개 키의 준비/반복 호출 총수는 세 군 모두 같다:
512는 879 / 92,174회, 1024는 1,107 / 251,354회.
반복 구간은 정수 NTRU 해 갱신 전에 끝난다. 즉, **실제 근사 k 반복 구간도
0.84~0.91% 느려졌으며 이번 구현은 이 구간의 병목을 해결하지 못했다.**

## 6. 정확성·KAT·서명검증·상수시간

| 검사 | 결과 |
|---|---|
| 보드 곱셈 random | **1,000,000쌍**, fixed/C/ASM 결과 일치 |
| 보드 곱셈 경계값 | **36,864쌍**, fixed/C/ASM 결과 일치 |
| 독립 Python 정수 모델 | 같은 random stream의 signed 곱/절삭 checksum `c665dcb55f68554d` 일치 |
| 변경하지 않은 add/half/div 회귀 | 각각 100,000쌍 일치, 나눗셈의 zero denominator 사례 포함 |
| 실제 NTRU 커널 | 19개 입력, 각 110회에서 raw 준비/반복 및 정수 k 일치 |
| 원본 보드 keygen KAT | **300/300**: 256·512·1024 각각 100개. 256은 진단용 크기 |
| KAT 키의 정수 방정식·범위 | 전부 PASS |
| 새 후보 전체 perf 및 profile | 각각 200개 키의 서명·검증·변조 서명 거부 PASS |
| 6개 perf/profile 펌웨어 간 대조 | 같은 200개 입력의 키·결정적 서명 digest 전부 동일 |
| 새 곱셈의 실제 ELF | 조건분기·IT·외부 호출 없음. FP64 명령 사용, integer coefficient multiply 없음 |
| 입력별 타이밍 관찰 | primitive 20종, FFT/iFFT logn 1~10 × 20종, 각 20 trial. 같은 연산·크기에서 입력별 최소 cycle 동일; trial 범위 최대 1 cycle |

오차 0은 **시험한 범위에서 원본 raw 값과의 차이가 0**이라는 뜻이다.
이상적인 실수 FFT의 수학적 근사 오차가 0이라는 의미가 아니다.

상수시간은 변경 함수의 분기/주소 검토와 시험한 입력군의 timing 관찰이다.
완전한 상수시간 증명, dudect 통계 검정, 전력/EM 검증을 수행한 것은 아니다.
키 생성 전체는 후보 재시도로 시간이 달라진다. 이번 inline assembly를
host sanitizer가 검증했다고 주장하지 않는다.

## 7. 왜 큰 개선이 나오지 않았는가

**확인한 사실:** 기존 C도 이미 하드웨어 FP64 명령으로 컴파일된다.
이번 변경은 소프트웨어 double을 하드웨어 double로 전환한 것이 아니다.

| production 곱셈 ELF | FP64 C | FP64 ASM |
|---|---:|---:|
| 정적 명령 개수 | 99 | 105 |
| `VCVT` 개수 | 26 | 26 |
| `.f64` 명령 개수, move/convert 포함 | 76 | 84 |
| GCC 곱셈 함수 stack usage | 144 B | 120 B |

계수 부분곱 15개와 carry/정규화의 계산량을 그대로 두었고 FFT의 복소수
곱 하나당 이 함수 호출 3개도 그대로다. 원본 fixed의 핵심 곱셈은
`UMAAL/UMULL/SMLAL` 등을 사용하는 6개 inline integer assembly 명령이다.
단순한 C/ASM 표기 차이보다 **KAT 보존을 위해 raw 정수 연산을 double
부분곱으로 재현하는 방식의 비용**이 여전히 크다.

곱셈 단독의 1.38% 감소가 FFT에서는 이득으로 연결되지 않았다.
caller의 레지스터 배치·명령 순서·함수 주소도 달라지므로 이번 데이터만으로
전체 +0.6%의 원인을 한 명령이나 스필에 단정하지 않는다. 실제로 GCC의
FFT stack frame은 424→392 B, iFFT는 336→320 B로 줄었다.
"스택이 늘어서 느려졌다"는 설명은 이 결과와 맞지 않는다.

## 8. 메모리

| perf 펌웨어 | fixed | FP64 C | FP64 ASM |
|---|---:|---:|---:|
| 링커 FLASH 영역 | 101,780 B | 106,560 B | 106,508 B |
| 링커 RAM 영역 | 220,296 B | 220,296 B | 220,328 B |
| stack watermark 관찰 사용량 | 9,488 B | 18,696 B | 18,696 B |

링커 명칭 FLASH는 여기서 외부 flash 실행을 뜻하지 않으며 코드가 ITCM에
적재된다. 64 KiB 스택을 예약했다. watermark는 해당 실행의 관찰값이다.
초기 3-backend 진단용 커널은 중복 버퍼 때문에 DTCM 링크 한도를 넘었지만,
실제 최대 입력 크기에 맞춰 진단 버퍼만 줄여 다시 빌드했다. 암호 자료형이나
실제 NTRU 버퍼 크기를 줄인 것은 아니다. 최종 커널 RAM은 241,144 B다.

## 9. 로그와 재현 근거

- [최종 집계 JSON](validation/results/summary.json)
- [원본 KAT 원문](validation/results/kat/20260922T060650Z/raw.log)
- [primitive·커널·CT 원문](validation/results/kernels/20260922T060238Z/raw.log)
- [fixed 전체 성능](validation/results/ref-perf/20260922T060908Z/raw.log)
- [FP64 C 전체 성능](validation/results/c-perf/20260922T061114Z/raw.log)
- [FP64 ASM 전체 성능](validation/results/asm-perf/20260922T061338Z/raw.log)
- [fixed 구간 프로파일](validation/results/ref-profile/20260922T061612Z/raw.log)
- [FP64 C 구간 프로파일](validation/results/c-profile/20260922T061842Z/raw.log)
- [FP64 ASM 구간 프로파일](validation/results/asm-profile/20260922T062058Z/raw.log)
- [정적 감사](validation/results/static/summary.json)
- [빌드 로그](validation/results/build_logs/)

각 원문 옆 `run.json`에 source·generated instrumentation·ELF·빌드 옵션과
raw log hash를 보존한다. 기존 C 후보와 5개 이전 후보의 암호 소스 보존도
기존 hash 기록과 대조한다. 통합 ref로 복사하거나 기존 결과를 덮어쓰지 않았다.
