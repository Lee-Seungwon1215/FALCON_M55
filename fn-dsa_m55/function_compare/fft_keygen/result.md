# 키생성 native FP64 FFT 최종 결과

측정일: 2026-09-24

## 판정

고정한 표현인 **복소수당 실수부 `double` 하나 + 허수부 `double` 하나**로
키생성 FP64 경로를 구현했다. 이어서 iFFT 최종 스케일링, FP64 twiddle
사전 변환, 두 레이어 실제 커널의 직접 어셈블리화를 차례로 실험했다.
보드 KAT·NTRU 방정식·서명/검증은 모두 통과했지만, 최종 native FP64
FFT/iFFT 커널은 `M55_ref`보다 **21.52~30.38% 느렸다.** 따라서 네 FFT/iFFT
함수에 대해서는 native FP64의 구조적 한계로 판정하고 채택하지 않는다.

아래의 전체 키생성 2.19~2.26% 개선 기록은 `vect_invnorm_fft()`의 큰 이득이
FFT/iFFT 손해를 상쇄한 이전 통합 결과다. 사용자가 이번에 지정한
`vect_FFT{,_fp64}()`와 `vect_iFFT{,_fp64}()` 네 함수가 빨라진 결과는 아니다.

다만 native FP64 커널의 입력군별 사이클이 완전히 같지 않았다. 따라서 이
소스는 기능·성능 연구 후보로 채택하지만, **상수시간이 증명된 배포 후보로는
채택하지 않는다.**

## 최종 구현

- `vect_FFT()`와 `vect_FFT_fp64()`는 같은 native FP64 forward 커널을 사용한다.
- `vect_iFFT()`와 `vect_iFFT_fp64()`는 같은 native FP64 inverse 커널을 사용한다.
- `vect_invnorm_fft()`는 실제 호출의 공개 인자 `e == 0` 경로를 특수화했다.
- 배열은 split-complex 형식이며 `f[0..n/2-1]`이 실수부,
  `f[n/2..n-1]`이 허수부다.
- Q32 twiddle은 FFT 반복 전에 `GM_TAB_FP64[1024]`로 한 번 사전 변환하며,
  butterfly 내부에서는 변환을 반복하지 않는다.
- FFT/iFFT는 두 레이어를 합쳐 중간값을 레지스터에 보존한다.
- iFFT의 레이어별 `1/2`를 제거하고 마지막에 정확한 `2/n` 스케일링을 한 번
  적용한다. `logn == 2`의 작은 경로는 기존 단계별 스케일을 유지한다.
- 두 레이어 forward/inverse inner loop를 직접 소유하는 FP64 어셈블리도 작성해
  실측했다. 그러나 M55의 16개 D 레지스터로 여섯 twiddle double과 데이터·임시값을
  동시에 유지하지 못해 twiddle reload가 생겼고, C/FMA 버전보다 0.83~1.99%
  느렸다. 최종 소스에는 재현용으로 남기되 `FNDSA_FP64_HAND_ASM=0`으로 제외했다.
- 최종 채택 후보는 compiler C/FMA 두 레이어 커널이다.
- `invnorm`은 native FP64 제곱 네 번과 정규화한 scalar FP64 reciprocal을 사용하고,
  결과 경계에서만 Q32 반올림 규칙을 적용한다.
- NTRU FFT 구간의 표현 왕복으로 인한 실패를 막기 위해 점별 곱·나눗셈 등
  지원 연산도 FP64로 유지했다. 성능 목표 함수는 원래 합의한 다섯 개 그대로다.

주요 변경 파일은 `kgen_fxp.c`, `kgen_inner.h`, `kgen_ntru.c`, `kgen_poly.c`다.
빌드 옵션이나 외부 심볼 바꿔치기로 후보를 선택하지 않았으며 실제 소스에
구현했다.

## 측정 환경

- NUCLEO-N657X0-Q / STM32N657 / Cortex-M55, CPU 800 MHz
- cache OFF: `SCB->CCR = 0x611`
- TCM control `0x99`, ECC ON
- GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16`
- `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`
- 커널: 준비·복사·검사는 타이머 밖, warm-up 10회 후 100회
- 전체 키생성: 공개 seed 10개를 각각 10회, 총 100회/degree;
  표는 10개 batch의 upper median

## 다섯 함수의 직접 커널 비교

`vect_FFT()`/`vect_FFT_fp64()`와 `vect_iFFT()`/`vect_iFFT_fp64()`는 각각
동일 커널로 이어지는 공개 이름이므로 같은 계산 성능으로 해석한다.

| 대상 | n | 원본 fixed cycles | FP64 cycles | 원본/FP64 | 시간 변화 |
|---|---:|---:|---:|---:|---:|
| `vect_FFT_fp64()` | 512 | 126,030.34 | 162,360.33 | 0.7762배 | 28.83% 느림 |
| `vect_FFT()` | 512 | 126,030.34 | 162,360.33 | 0.7762배 | 28.83% 느림 |
| `vect_iFFT_fp64()` | 512 | 143,324.68 | 174,164.34 | 0.8229배 | 21.52% 느림 |
| `vect_iFFT()` | 512 | 143,324.68 | 174,164.34 | 0.8229배 | 21.52% 느림 |
| `vect_invnorm_fft()` | 512 | 464,176.99 | 64,177.49 | **7.2327배** | **86.17% 감소** |
| `vect_FFT_fp64()` | 1024 | 280,624.35 | 365,891.33 | 0.7670배 | 30.38% 느림 |
| `vect_FFT()` | 1024 | 280,624.35 | 365,891.33 | 0.7670배 | 30.38% 느림 |
| `vect_iFFT_fp64()` | 1024 | 318,458.68 | 388,781.35 | 0.8191배 | 22.08% 느림 |
| `vect_iFFT()` | 1024 | 318,458.68 | 388,781.35 | 0.8191배 | 22.08% 느림 |
| `vect_invnorm_fft()` | 1024 | 928,305.01 | 128,177.49 | **7.2423배** | **86.19% 감소** |

따라서 네 FFT/iFFT 이름은 모두 fixed보다 느리다. 이전 전체 키생성 개선은
후보 검사에서 반복 호출되는 `invnorm`의 큰 이득이 이 손해를 상쇄한 결과다.

직접 어셈블리 후보와 최종 C/FMA 후보의 비교는 다음과 같다.

| 커널 | n | C/FMA | 직접 FP64 asm | asm 변화 |
|---|---:|---:|---:|---:|
| FFT | 512 | 162,360 | 163,715 | 0.83% 느림 |
| iFFT | 512 | 174,164 | 177,631 | 1.99% 느림 |
| FFT | 1024 | 365,891 | 371,599 | 1.56% 느림 |
| iFFT | 1024 | 388,781 | 395,498 | 1.73% 느림 |

## 전체 키생성 비교

| 구현 | n=512 cycles | n=1024 cycles | FP64 후보 대비 설명 |
|---|---:|---:|---|
| `M55_ref` | 48,268,765 | 220,426,877 | 최종 요구 기준 |
| `ntt_opt` | 42,926,974 | 203,618,043 | 출발 코드; NTT 최적화 포함 |
| 이 FP64 후보 | **47,211,176** | **215,451,315** | `M55_ref` 대비 1.0224배/1.0231배 |

- `M55_ref` 대비: n=512 **2.191% 감소**, n=1024 **2.257% 감소**.
- `ntt_opt` 대비: n=512 **9.980% 증가**, n=1024 **5.812% 증가**.

즉 사용자가 정한 최종 기준 `M55_ref`는 넘었지만, NTT 최적화만 적용된
`ntt_opt`보다 빠르지는 않다.

## 오차와 기능 검증

무작위 정수 입력, `logn=2..10`, 각 100회를 원본 fixed Q32 출력과 비교했다.

| 함수 | 비교 계수 | 다른 계수 | 최대 절대 차이 |
|---|---:|---:|---:|
| `vect_FFT_fp64()` | 204,400 | 188,673 | 144 Q32 LSB (`3.35e-8`) |
| `vect_FFT()` | 204,400 | 188,673 | 144 Q32 LSB (`3.35e-8`) |
| `vect_iFFT_fp64()` | 204,400 | 156,630 | 8 Q32 LSB (`1.86e-9`) |
| `vect_iFFT()` | 204,400 | 156,630 | 8 Q32 LSB (`1.86e-9`) |
| `vect_invnorm_fft()` | 102,200 | **0** | **0** |

native FP64 FFT의 중간 Q32 값은 원본과 bit-exact하지 않지만 오차 범위는 위와
같고, 최종 암호 결과는 다음을 통과했다.

- host 전체 `test_fndsa`: SHAKE/SHA-3, codec, mod-q, sampler, keygen,
  verify, self-test, `logn=2..10` KAT PASS
- M55 키생성 KAT: **300/300 일치**, NTRU equation 모두 PASS
- M55 서명 KAT/검증/변조 거부: **90/90 PASS**
- fault registers: CFSR/HFSR/AFSR 0
- 최종 KAT 펌웨어 RAM: 210,568 B / 256 KiB
- 최종 서명 회귀 펌웨어 RAM: 242,632 B / 256 KiB

## 상수시간 검사

역어셈블리에서 실제 `VMUL.F64`, `VFMA.F64`, `VFMS.F64`, `VDIV.F64`,
`VRINTM.F64`를 확인했으며 세 커널 안에는 software FP helper 호출이 없다.
FFT/iFFT 분기와 반복 횟수는 공개 `logn`과 loop index에만 의존한다.
`invnorm`의 `e == 0` hot loop에도 계수값 의존 분기는 없다. 다만 통합을 위해
추가한 일반 FP64 나눗셈 지원 함수에는 zero/exception 처리를 컴파일러가
조건분기로 만든 구간이 있다. 정상 NTRU denominator는 양의 normal 값이지만
numerator의 영값까지 포함한 전체 입력 공간에서 구조적 상수시간을 보장하지 않는다.

그러나 `logn=10`, 입력군 5개, 각 100회 실측 평균에는 다음 차이가 있었다.

| 커널 | FP64 입력군 평균의 최대-최소 | fixed 대조군 |
|---|---:|---:|
| FFT | 약 53.5 cycles | 0.01 cycle 이내 |
| iFFT | 약 30.5 cycles | 0.01 cycle 이내 |
| invnorm | 107 cycles | 동일 평균 |

다섯 핵심 커널의 차이는 소스 분기 때문은 아니며 M55 scalar FP64 명령의
operand-dependent latency와 일치하는 현상으로 판단한다. 유한 입력 실험만으로
원인을 완전히 증명한 것은 아니고, 지원 나눗셈의 예외 처리 분기도 별도 한계다.
fixed 대조군에는 없는 차이이므로 이 후보를 constant-time이라고 주장하지 않는다.

## 메모리

전체 API 성능 ELF 기준:

| 구현 | FLASH | RAM |
|---|---:|---:|
| `M55_ref` | 74,164 B | 155,944 B |
| `ntt_opt` | 86,212 B | 164,136 B |
| 이 FP64 후보 | 89,512 B | 164,136 B |

FP64 후보는 `M55_ref`보다 FLASH 15,348 B, RAM 8,192 B가 크며,
`ntt_opt`보다 FLASH 3,300 B가 크고 RAM은 같다.

## SLOTHY 판정

로컬 SLOTHY의 Armv8.1-M 모델은 MVE Q-register FP32 명령은 모델링하지만
이번 커널의 scalar D-register FP64 `VMUL/VFMA/VFMS.F64`는 모델링하지 않는다.
따라서 유효하지 않은 모델로 결과를 만드는 대신 적용 불가로 기록했다. 최종
명령 선택과 FMA 결합은 직접 작성한 inline assembly로 고정했다.

## 최종 해시

- `kgen_fxp.c`: `3eac7007f8239b26c8d1b4dd3507004aaa3c7db0ad82a576e68250236bc5fc97`
- `kgen_inner.h`: `0b71e23ccc212f0769474b0ea86b6ce4b8ccdd2f9e19b5c6f40b2cc658ace773`
- `kgen_ntru.c`: `dea772c878cdf77a7a54505ef3341171312ffcfd81daea2383db161f10a9eddf`
- `kgen_poly.c`: `2d8fe81382a1b526346eb095566af7713bf7ef8e5204762961c12294613be853`
- 전체 성능 ELF: `8b9fa87207fd80c2053f846eba9fd42b24b250007bbbb69e4705b206aca5455d`
- 키 KAT ELF: `d7388921d179f7a18a1724ac7c510c269d043a4256b8bee638c5ff13bc82b9df`
- 서명 KAT ELF: `182ae064e578013c1b3ab6ecec486466a4648094940de03d5275e8587148d9e5`

`/private/tmp`의 ELF는 임시 산출물이므로 장기 재현 근거는 위 소스 해시와
이 문서의 조건을 기준으로 한다.
