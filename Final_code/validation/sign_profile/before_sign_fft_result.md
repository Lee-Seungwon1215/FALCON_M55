# Before_slothy 서명 FFT 연산 비중

당시 후속 측정: [LDL·split·merge·점별 연산·deepest까지 함수별로 분리한 표](before_sign_fft_detail_result.md).
두 표는 계측 지점 수와 분모가 다르므로 백분율을 섞어 합산하지 않는다.

2026-09-28, 실제 NUCLEO-N657X0-Q 보드 재측정.
대상: `Final_code/Before_slothy`의 K4C + 공통 NTT + A17 통합본, SLOTHY 미적용.
원본 암호 C/H/S는 수정하지 않았고, 측정용 사본에만 진입/종료 계측을 추가했다.

## 핵심 결과

**분모는 서명 전체 API 시간**, 분자는 서명 실행 중 각 함수/단계에 누적한 시간이다.
FFT 시간 전체를 분모로 한 비율도 아니고, FP 명령어 개수를 센 결과도 아니다.

| 구분 | 512 평균 cycles/서명 | 512 비중 | 1024 평균 cycles/서명 | 1024 비중 |
|---|---:|---:|---:|---:|
| `fpoly_FFT()` | 3,220,435.06 | 17.6053% | 7,231,048.00 | 18.4051% |
| `fpoly_iFFT()` | 1,328,466.02 | 7.2624% | 2,975,134.00 | 7.5726% |
| **FFT+iFFT 소계** | **4,548,901.08** | **24.8677%** | **10,206,182.00** | **25.9777%** |

두 함수만 최적화하는 경우 직접적인 대상은 서명 시간의 약 1/4이다.
이 비중으로 이상적인 Amdahl 계산을 하면 두 함수의 시간을 완전히 없애더라도
전체 서명 속도 배율의 상한은 약 1.33배/1.35배이다. 이는 계측 비중으로 계산한
이론적 참고치이며 실제 최적화 성능 예측이나 달성 약속이 아니다.

## 전체 100% 분류

모두 배타적 시간이다. `fpoly_apply_basis()`에서 호출하는 `fpoly_FFT()`는
첫 행에만 집계했으며 target 행에 중복 포함하지 않았다.

| 구분 | 512 | 1024 |
|---|---:|---:|
| FFT 변환: `fpoly_FFT()` | 17.61% | 18.41% |
| 역변환: `fpoly_iFFT()` | 7.26% | 7.57% |
| FFT 영역 Gram 계산: `fpoly_gram_fft()` | 2.48% | 2.32% |
| target 준비: `fpoly_apply_basis()`의 FFT 제외 부분 | 1.52% | 1.42% |
| LDL·ffSampling 진행: Gaussian/BerExp 제외 | 43.92% | 45.40% |
| Gaussian·BerExp sampler | 22.80% | 20.92% |
| 나머지 준비·해시·정수 계산·노름·인코딩·계측 잔여 | 4.41% | 3.96% |
| **합계** | **100.00%** | **100.00%** |

LDL·ffSampling에는 FFT 영역의 분할/병합, 점별 곱셈, LDL 분해, 재귀 제어 등이
포함되어 있다. 이 43.92%/45.40%를 `fpoly_FFT()`/`fpoly_iFFT()` 시간과 혼동하면 안 된다.
두 변환 함수를 바꾸는 것만으로 해당 영역 전체가 자동으로 빨라지는 것은 아니다.
Gaussian/BerExp는 ffSampling의 하위 호출이지만 위 표에서는 별도 분리했다.

## 호출 횟수와 단일 커널 평균

| 함수 | 512 호출 수/서명 | 512 cycles/호출 | 1024 호출 수/서명 | 1024 cycles/호출 |
|---|---:|---:|---:|---:|
| `fpoly_FFT()` | 5 | 644,087.01 | 5 | 1,446,209.60 |
| `fpoly_iFFT()` | 2 | 664,233.01 | 2 | 1,487,567.00 |
| `fpoly_gram_fft()` | 1 | 454,555.00 | 1 | 910,011.00 |
| `fpoly_apply_basis()` FFT 제외 | 1 | 277,917.97 | 1 | 556,479.00 |

FFT 5회 = 비밀키 기저 `g,-f,G,-F` 4회 + 메시지 대표 다항식 변환 1회.
iFFT 2회 = 샘플링 결과 `t0,t1` 복원.
이번 입력에서는 각 크기 서명 100회에 시도 100회였고, 재시도가 발생했다면 같은
누적 카운터에 포함되는 계측 구조이다. 단일 호출 값도 서명 중 누적값을 나눈 값이며
별도 고립 커널 벤치마크는 아니다.

## 측정 조건과 교란 확인

- CPU/SYSCLK/HCLK 800/400/200 MHz, ITCM/DTCM 각각 256 KiB.
- 코드 ITCM, 상수·데이터·스택 DTCM, I/D cache OFF, ECC ON.
- GCC 15.2.1, Zephyr 4.4.1, `-O3`, `-mfpu=fpv5-d16`, hard-float ABI,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 크기별 고정 키 1개로 서명 seed 100종, 서명 100회. 기존 단계 프로파일과 같은
  메시지·seed 생성식·키 준비 순서(준비 키생성 10회 후 마지막 키 사용).
- DWT CYCCNT, 측정 구간 IRQ OFF. 초기 준비 서명/검증 및 키생성은 분모에 미포함.
- 내부 계측을 넣은 이미지와 넣지 않은 control 이미지를 모두 새로 실행했다.

| 전체 서명 평균 | 512 cycles | 1024 cycles |
|---|---:|---:|
| 내부 계측 OFF control | 18,015,448.93 | 38,736,052.36 |
| 단계·함수 계측 ON | 18,292,418.38 | 39,288,266.97 |
| 계측 ON/OFF 차이 | +1.5374% | +1.4256% |

위 비중의 분모는 계측 ON 행이다. 분자에서 오버헤드를 임의로 빼거나 control
분모와 섞지 않았다. 차이에는 계측 비용과 계측으로 인한 코드 배치/컴파일 영향도
포함될 수 있으므로 순수 타이머 비용이라고 단정하지 않는다.
성능 비교에 사용할 비계측 API 수치와 계측 비중은 별개이다.

## 검증

- 두 실행 모두 생성한 서명을 100/100 검증하고 변조 서명을 거부함(크기별).
- 출력 FNV-1a 지문이 profile/control 및 이전 동일 입력 실행과 일치:
  512 `9895079d`, 1024 `a020dd02`. FNV 일치 자체는 암호학적 동등성 증명이 아니다.
- 모든 범주의 사이클 합이 서명 전체 사이클과 정확히 일치. 계측 스택 오류 0.
- CFSR/HFSR/AFSR=0, TCM/ECC 시작·종료 확인.
- 전체 upstream KAT/상수시간 검증을 새로 실시한 것은 아니다. 이전 통합본 검증과
  이번 프로파일링의 정상·변조 서명 검사를 구분한다.

## 재현과 원자료

```sh
# workspace root에서
bash Final_code/validation/build.sh sign_profile
bash Final_code/validation/build.sh sign_control
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python Final_code/validation/run_board.py sign_profile
python Final_code/validation/run_board.py sign_control
```

- [계측 ON 로그](../results/sign_profile/20260928T061827Z/raw.log)
- [계측 ON 출처·검증 manifest](../results/sign_profile/20260928T061827Z/manifest.json)
- [control 로그](../results/sign_control/20260928T061856Z/raw.log)
- [control 출처·검증 manifest](../results/sign_control/20260928T061856Z/manifest.json)

`generate.py`는 현재 원본에서 `sign.c`, `sign_core.c`, `sign_sampler.c`,
`sign_fpoly.c`만 임시 복사하여 계측한다. 다른 후보의 암호 구현을 가져오지 않는다.
생성 파일은 `validation/build/<mode>/sign_generated/`에 있으며 원본·생성본 해시를 기록한다.
