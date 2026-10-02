# FN-DSA M55 NTRU solve 내부 100% 프로파일

`fn-dsa_m55/ntt_opt_slothy`를 기준으로 `solve_NTRU()`에 들어간 순간부터 반환할 때까지의 누적 사이클만 분모로 사용했다. 키 후보 생성·검사와 공개키 계산은 분모에 포함하지 않았다.

재귀 단계 표와 연산 커널 표는 동일한 실행 시간을 서로 다른 관점에서 분류하므로, 각 표가 독립적으로 정확히 100%가 된다.

## FN-DSA-512

- 키 생성 10회에서 `solve_NTRU()` 호출 11회
- 상세 계측 NTRU 사이클: 호출당 평균 44,961,214 cycles
- 최소/최대: 18,332,079 / 47,624,127 cycles
- 최소 훅 control: 호출당 42,363,988 cycles; 상세 훅에 따른 관측 차이 +6.13%

### 재귀 단계 기준 — 합계 100%

| 단계 | cycles/NTRU call | 비중 |
|---|---:|---:|
| solve 제어·최종 F,G 변환 | 13,428 | 0.03% |
| deepest: resultant·CRT·Bezout로 최초 해 계산 | 11,061,564 | 24.60% |
| intermediate 전체: 재귀 lifting·Babai reduction | 30,496,209 | 67.83% |
| depth0: 최상위 정밀 reduction·F,G 완성 | 3,390,013 | 7.54% |
| **합계** | **44,961,214** | **100.00%** |

#### intermediate 재귀 깊이 상세

| depth | 다항식 차수 | cycles/NTRU call | NTRU 전체 비중 |
|---:|---:|---:|---:|
| 1 | 256 | 5,026,502 | 11.18% |
| 2 | 128 | 3,735,312 | 8.31% |
| 3 | 64 | 2,934,634 | 6.53% |
| 4 | 32 | 2,954,453 | 6.57% |
| 5 | 16 | 4,996,012 | 11.11% |
| 6 | 8 | 2,280,121 | 5.07% |
| 7 | 4 | 3,282,195 | 7.30% |
| 8 | 2 | 5,286,981 | 11.76% |

### 연산 커널 기준 — 합계 100%

| 배타적 연산 범주 | cycles/NTRU call | 비중 | 진입/NTRU call |
|---|---:|---:|---:|
| 31-bit mod-p forward NTT | 3,987,269 | 8.87% | 1514.0 |
| 31-bit mod-p inverse NTT | 3,636,486 | 8.09% | 1495.4 |
| NTT/iNTT twiddle 표 생성 | 1,388,706 | 3.09% | 1294.5 |
| RNS → 큰 정수 CRT 재구성 | 8,951,070 | 19.91% | 136.7 |
| deepest binary GCD·Bezout | 7,912,221 | 17.60% | 1.0 |
| fixed-point forward FFT | 1,608,122 | 3.58% | 766.7 |
| fixed-point inverse FFT | 1,579,339 | 3.51% | 758.4 |
| FFT-domain fixed-point 곱셈·나눗셈 | 2,049,851 | 4.56% | 765.8 |
| 큰 정수 → fixed-point 근사 변환 | 1,318,169 | 2.93% | 764.9 |
| NTT 기반 Babai scaled subtraction 나머지 | 1,583,693 | 3.52% | 109.1 |
| depth-1 전용 scaled subtraction 나머지 | 622,191 | 1.38% | 7.3 |
| 일반 정수 scaled subtraction | 4,531,112 | 10.08% | 641.1 |
| RNS 변환·lifting 점별연산·복사·제어 등 기타 | 5,792,986 | 12.88% | 0.0 |
| **합계** | **44,961,214** | **100.00%** | — |

**핵심:** 순수 `mp_NTT + mp_iNTT`는 NTRU solve의 **16.96%**다. twiddle 표 생성까지 포함한 NTT 지원 경로는 **20.04%**다.

## FN-DSA-1024

- 키 생성 10회에서 `solve_NTRU()` 호출 17회
- 상세 계측 NTRU 사이클: 호출당 평균 123,446,415 cycles
- 최소/최대: 64,430,655 / 159,168,121 cycles
- 최소 훅 control: 호출당 118,214,734 cycles; 상세 훅에 따른 관측 차이 +4.43%

### 재귀 단계 기준 — 합계 100%

| 단계 | cycles/NTRU call | 비중 |
|---|---:|---:|
| solve 제어·최종 F,G 변환 | 16,735 | 0.01% |
| deepest: resultant·CRT·Bezout로 최초 해 계산 | 40,050,783 | 32.44% |
| intermediate 전체: 재귀 lifting·Babai reduction | 78,882,834 | 63.90% |
| depth0: 최상위 정밀 reduction·F,G 완성 | 4,496,062 | 3.64% |
| **합계** | **123,446,415** | **100.00%** |

#### intermediate 재귀 깊이 상세

| depth | 다항식 차수 | cycles/NTRU call | NTRU 전체 비중 |
|---:|---:|---:|---:|
| 1 | 512 | 7,724,400 | 6.26% |
| 2 | 256 | 5,361,202 | 4.34% |
| 3 | 128 | 5,348,496 | 4.33% |
| 4 | 64 | 4,274,688 | 3.46% |
| 5 | 32 | 6,879,347 | 5.57% |
| 6 | 16 | 12,712,817 | 10.30% |
| 7 | 8 | 6,118,786 | 4.96% |
| 8 | 4 | 11,236,852 | 9.10% |
| 9 | 2 | 19,226,246 | 15.57% |

### 연산 커널 기준 — 합계 100%

| 배타적 연산 범주 | cycles/NTRU call | 비중 | 진입/NTRU call |
|---|---:|---:|---:|
| 31-bit mod-p forward NTT | 7,867,059 | 6.37% | 2996.6 |
| 31-bit mod-p inverse NTT | 7,533,360 | 6.10% | 2987.5 |
| NTT/iNTT twiddle 표 생성 | 2,830,465 | 2.29% | 2606.5 |
| RNS → 큰 정수 CRT 재구성 | 28,819,221 | 23.35% | 174.9 |
| deepest binary GCD·Bezout | 30,457,290 | 24.67% | 1.0 |
| fixed-point forward FFT | 2,763,147 | 2.24% | 1472.1 |
| fixed-point inverse FFT | 2,765,819 | 2.24% | 1465.1 |
| FFT-domain fixed-point 곱셈·나눗셈 | 2,853,810 | 2.31% | 1471.5 |
| 큰 정수 → fixed-point 근사 변환 | 2,812,438 | 2.28% | 1470.9 |
| NTT 기반 Babai scaled subtraction 나머지 | 3,395,922 | 2.75% | 147.6 |
| depth-1 전용 scaled subtraction 나머지 | 900,335 | 0.73% | 5.3 |
| 일반 정수 scaled subtraction | 16,815,383 | 13.62% | 1311.6 |
| RNS 변환·lifting 점별연산·복사·제어 등 기타 | 13,632,164 | 11.04% | 0.0 |
| **합계** | **123,446,415** | **100.00%** | — |

**핵심:** 순수 `mp_NTT + mp_iNTT`는 NTRU solve의 **12.48%**다. twiddle 표 생성까지 포함한 NTT 지원 경로는 **14.77%**다.

## 측정·검증 조건

- 소스: `fn-dsa_m55/ntt_opt_slothy` (`mq_cm55.s` 직접 사용)
- 보드: NUCLEO-N657X0-Q Cortex-M55 800 MHz
- 코드 ITCM, 데이터·rodata·스택 DTCM, I/D cache OFF, TCM ECC ON
- GCC 15.2.1, `-O3`, mlkem-native Nucleo 설정
- 파라미터별 키 생성 10회, 동일 결정적 seed, 키 생성 구간 IRQ OFF
- 상세/control 출력 지문 일치, 정상 서명 검증·변조 거부 PASS, CFSR/HFSR/AFSR=0
- 커널 범주는 중첩 호출 시 가장 안쪽 범주에만 시간을 배정했다. 예를 들어 `poly_sub_scaled_ntt()` 안에서 호출된 `mp_NTT()` 시간은 `sub_ntt`가 아니라 `mp_ntt`에만 들어간다.
- control은 `solve_NTRU()` 시작/종료 타이머만 유지한 펌웨어다. 상세/control 차이는 훅 비용뿐 아니라 계측에 따른 코드 배치 변화도 포함하므로 보정값으로 빼지 않았다.

## 재현 자료

- control 실행: `/Users/seungwon/FALCON/fn-dsa_m55/ntru_profile/results/control/runs/20260914T044929Z`
- detailed 실행: `/Users/seungwon/FALCON/fn-dsa_m55/ntru_profile/results/detailed/runs/20260914T044945Z`
- control raw log SHA-256: `0bf1ce4b53e7e12bc78ccc58c4e0c7531b5fa10de103cb53623204647c960c3e`
- detailed raw log SHA-256: `c5155665716b2b9c26f03e26466e939e0616b96d6997641a48d5acf7da5a54f3`
- 재현: `./build.sh all`, `./run.py control`, `./run.py detailed`, `./report.py`
