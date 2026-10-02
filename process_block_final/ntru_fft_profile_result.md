# 과거 기록: ntt_opt NTRU solve 내부 FFT 비중

> 아래는 복사해 보관한 2026-09-17 ntt_opt 측정 기록이다. A17 FFT를 포함한
> 현재 Final_code/Before_slothy의 프로파일링 결과가 아니다. 현재 검증은 result.md 참조.

현재 Slothy 적용 전 `fn-dsa_m55/ntt_opt`를 실제 M55 보드에서 재측정했다.
공통 q-NTT 수동 최적화와 최신 K4-C RNS 어셈블리를 모두 켰으며 암호 소스는 변경하지 않았다.
분모는 NTRU solve 전체 누적 사이클이다. 후보 생성·검사 및 공개키 계산은 포함하지 않는다.

## FFT 관련 비중

| 구간 | 512 | 1024 |
|---|---:|---:|
| FFT | 4.1916% | 2.5130% |
| iFFT | 4.1166% | 2.5154% |
| FFT 영역 곱셈·나눗셈 | 5.3418% | 2.5954% |
| 큰 정수 → 고정소수점 근사 변환 | 3.4385% | 2.5591% |
| 나머지 정수 연산·제어·반올림 등 | 82.9116% | 89.8170% |
| FFT+iFFT 소계 | 8.3081% | 5.0285% |
| FFT+iFFT+곱셈·나눗셈 소계 | 13.6499% | 7.6239% |

첫 다섯 행의 합계가 100%이며 소계 행은 중복 합산하지 않는다.

## 실제 사이클과 계측 영향

### 512

- 키생성 10회, NTRU solve 11회(실패 후 재시도 포함).
- 최소 계측 대조군: 37,467,756.91 cycles/NTRU call.
- FFT 상세 계측: 38,402,391.82 cycles/NTRU call.
- 관측 차이: +2.4945%.

| 구간 | cycles/NTRU call | 호출 횟수 합계 |
|---|---:|---:|
| FFT | 1,609,655.91 | 8434 |
| iFFT | 1,580,855.64 | 8342 |
| FFT 영역 곱셈·나눗셈 | 2,051,383.00 | 8424 |
| 큰 정수 → 고정소수점 근사 변환 | 1,320,463.27 | 8414 |
| 나머지 정수 연산·제어·반올림 등 | 31,840,034.00 | 0 |

### 1024

- 키생성 10회, NTRU solve 17회(실패 후 재시도 포함).
- 최소 계측 대조군: 108,279,135.18 cycles/NTRU call.
- FFT 상세 계측: 110,070,127.18 cycles/NTRU call.
- 관측 차이: +1.6541%.

| 구간 | cycles/NTRU call | 호출 횟수 합계 |
|---|---:|---:|
| FFT | 2,766,091.24 | 25025 |
| iFFT | 2,768,748.94 | 24906 |
| FFT 영역 곱셈·나눗셈 | 2,856,753.24 | 25015 |
| 큰 정수 → 고정소수점 근사 변환 | 2,816,850.47 | 25005 |
| 나머지 정수 연산·제어·반올림 등 | 98,861,683.29 | 0 |

## 조건·검증·한계

- NUCLEO-N657X0-Q, Cortex-M55 r1p1, CPU 800 MHz, 프로브 003C00223335510735383531.
- ITCM/DTCM 256 KiB, 코드 lower 128 KiB ITCM, 상수·데이터·스택 DTCM, I/D cache OFF, TCM ECC ON.
- GCC 15.2.1, 최종 -O3, M4 어셈블리 ON, M55 q-NTT 및 RNS MVE ON.
- 기존 NTRU 상세 프로파일과 동일한 키생성 seed 10개/차수, IRQ OFF, DWT CYCCNT.
- control: NTRU 진입/반환만 계측. fft: 이에 더해 FFT/iFFT/세 spectral 함수/poly_big_to_fixed만 계측.
- 각 범주의 배타적 사이클 합이 NTRU 전체와 일치. 후보 검사에서 호출된 FFT는 NTRU 밖이므로 제외된다.
- 두 펌웨어의 출력 키 지문이 서로 일치하고 기존 deterministic 기준과도 일치한다.
- 각 최종 키의 정상 서명 검증 및 변조 서명 거부 PASS. 시작·종료 ECC 설정과 fault 상태 검사 PASS.
- FFT 관련 함수 호출 횟수도 기존 상세 기록과 일치한다. 전체 upstream KAT/상수시간 증명을 새로 수행한 것은 아니다.
- 계측 오버헤드 포함 비중이다. control과의 차이는 훅 비용뿐 아니라 코드 배치 영향도 포함하므로 보정값으로 빼지 않는다.
- 예전 전체 커널 상세 계측과 훅 수가 다르므로 비중 차이를 전부 NTT 최적화 효과로 해석하지 않는다.
- 여기서 모든 정수 연산을 FP64로 바꿀 수 있다는 의미는 아니다. 고정소수점 근사 계산의 후보 범위다.

## 재현과 원본 자료

```sh
bash fn-dsa_m55/ntru_profile/build.sh latest
python3 -B fn-dsa_m55/ntru_profile/run.py ntt_opt_control
python3 -B fn-dsa_m55/ntru_profile/run.py ntt_opt_fft
python3 -B fn-dsa_m55/ntru_profile/latest.py ntt_opt_fft report
```

- 측정 완료 UTC: `2026-09-17T07:29:16.925925+00:00`
- 암호 소스 트리 SHA-256: `8356267ec5434628f98c6ef33d194d9fa60cae9f99d975d173b82f14b8aebe74`
- [최소계측 원시 로그](/Users/seungwon/FALCON/fn-dsa_m55/ntru_profile/results/ntt_opt_control/runs/20260917T072811Z/raw.log)
- [FFT 계측 원시 로그](/Users/seungwon/FALCON/fn-dsa_m55/ntru_profile/results/ntt_opt_fft/runs/20260917T072909Z/raw.log)
- [FFT 계측 검증·소스·빌드 기록](/Users/seungwon/FALCON/fn-dsa_m55/ntru_profile/results/ntt_opt_fft/runs/20260917T072909Z/run.json)
