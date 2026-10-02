# Q32 경계 유지 FFT/iFFT·invnorm 구현 및 M55 실측

측정일: 2026-09-27. 대상은 이 디렉터리의 실제 소스다.
`ntt_opt`, `M55_ref` 및 다른 최적화 후보는 수정하지 않았다.

후속 커널 재측정(100회 ×3회 반복)은
[커널별 재측정 결과](kernel_remeasure_20260927.md)에 별도로 기록했다.
아래의 전체 키생성 수치는 기존 측정이며, 후속 요청에서는 커널만 새로 실행했다.

FFT/iFFT 개선폭의 원인을 확인한 후속 구간 계측은
[원인 진단](fft_slowdown_diagnosis.md)에 있다. 정상 암호 소스는 그대로 유지했다.

## 결론과 활성화한 경로

주변 연산을 원본 고정소수점으로 유지하면 전체 키생성도 빨라졌다.
다만 큰 forward FFT의 MVE 후보는 이번 Q32 입출력 조건에서는 느려서 채택하지 않았다.

| 대상 | 최종 선택 |
| --- | --- |
| `vect_FFT()` | 모든 크기에서 원본 고정소수점 유지 |
| `vect_iFFT()`, n < 512 | 원본 고정소수점 유지 |
| `vect_iFFT()`, n = 512,1024 | Q32 → 2×FP32 MVE → Q32; 최종 스케일링 방식 |
| `vect_invnorm_fft()`, e=0 | 원본 Q32 제곱합 + native FP64 역수 계산 + Q32 반환 |
| `vect_invnorm_fft()`, e≠0 | 원본 고정소수점 유지 |
| 주변 곱셈·나눗셈·입력 변환·정수 k 생성 | 원본 고정소수점 유지 |

2×FP32는 실수값 하나당 float 두 개, 복소수당 네 개다. NTRU solver에 double
배열을 넣지 않았으며 `fxr` 인터페이스도 유지했다. 따라서 이전 double 입출력
실험의 개선율을 이번 Q32 입출력 실험의 결과로 재사용하지 않는다.

범위 주의: 이 폴더 이름은 `4.1_ntrusolve`지만 공통 키생성 함수가 대상이다.
`vect_invnorm_fft(..., 0)`은 `kgen_ntru.c`의 `check_ortho_norm()`에서 호출되는
**키 후보 검사**이며 NTRU solve 안의 반복 나눗셈은 아니다. 큰 iFFT 변경은
이 후보 검사와 NTRU solve에서 같은 함수를 호출하는 해당 크기에 적용된다.
이번 전체 개선율을 NTRU solve만의 개선율이라고 해석하면 안 된다.

## 1. 동일 ELF 커널 비교

원본 `M55_ref/kgen_fxp.c`와 `ntt_opt/kgen_fxp.c`의 내용은 동일하다.
비교용 `validation/ref_fxp.c`는 원본 함수 이름만 변경한 복사본임을 자동 검증했다.
각 backend에 동일 입력 스트림을 넣고 10회 준비 실행 후 100회 측정했다.
측정에는 표현 변환을 포함하고 입력 복사·정답 검사는 제외한다. 단위는 평균 cycles.

| 함수 | n | 원본 | 최종 선택 | 시간 감소 | 속도 배율 |
| --- | ---: | ---: | ---: | ---: | ---: |
| FFT | 512 | 125,910.00 | 125,910.00 | 0.00% | 1.000× |
| FFT | 1024 | 280,376.00 | 280,376.00 | 0.00% | 1.000× |
| iFFT | 512 | 143,338.01 | 142,092.00 | 0.87% | 1.009× |
| iFFT | 1024 | 318,471.98 | 307,855.01 | 3.33% | 1.034× |
| invnorm, e=0 | 512 | 465,986.99 | 72,510.01 | 84.44% | 6.427× |
| invnorm, e=0 | 1024 | 931,906.99 | 144,957.98 | 84.45% | 6.429× |

invnorm 최적화 값은 private 함수 직접 호출이다. 실제 공개 함수의 e 분기 비용은
전체 키생성 측정에 포함된다. iFFT 값은 공개 함수의 크기 선택 비용도 포함한다.
작은 iFFT는 산술 본문이 같아도 새 크기 검사로 몇 cycle이 추가될 수 있다.

채택하지 않은 forward MVE 후보도 로컬 소스에 독립 함수로 남겨 비교할 수 있다.

| forward MVE 후보 | 원본 | 후보 | 결과 |
| --- | ---: | ---: | --- |
| 512 | 125,910.00 | 132,091.01 | 4.91% 느림 → 미채택 |
| 1024 | 280,376.00 | 286,040.99 | 2.02% 느림 → 미채택 |

큰 FFT/iFFT가 모두 원본보다 빨라진 것은 아니다. 현재 성공한 부분은 큰 iFFT와
invnorm이다. 두 변환 이름에 `_fp64` 별칭을 추가해서 별도 커널 수를 늘리지 않았다.

## 2. 전체 키생성 비교

세 구현을 동일 측정 프로그램·일반 배치 정책으로 각각 실행했다. 크기별
원본 KAT seed `test0`..`test99` 100개, 준비 실행 3회다. 후보 재시도와 키 인코딩을
포함하며 seed 문자열 준비·결과 검사·해시는 타이머 밖이다.

| 구현 / 평균 cycles | 512 | 1024 |
| --- | ---: | ---: |
| `M55_ref` | 62,738,243.84 | 261,716,429.53 |
| `ntt_opt` | 56,951,253.20 | 243,157,429.44 |
| 이번 `4.1_ntrusolve` | **54,272,283.63** | **230,887,528.49** |
| `ntt_opt` 대비 시간 감소 | **4.70%** | **5.05%** |
| `ntt_opt` 대비 속도 배율 | **1.049×** | **1.053×** |
| `M55_ref` 대비 시간 감소 | **13.49%** | **11.78%** |
| `M55_ref` 대비 속도 배율 | **1.156×** | **1.134×** |

시간 감소 = `100 × (1 - 새 cycles / 기준 cycles)`.
속도 배율 = `기준 cycles / 새 cycles`.
`M55_ref` 대비 수치는 기존 NTT 최적화까지 포함한다. 이번 변경의 추가 효과는
`ntt_opt`와의 비교다. 개별 함수별 기여도를 분리한 ablation 측정은 아니다.

배치 영향 확인을 위해 변경하지 않은 공통 정수 함수 8개의 ITCM 주소를 동일하게
고정한 진단 실험도 별도로 했다. ELF에서 해당 함수들의 주소와 크기 일치를 확인했다.

| 정수 함수 주소 통제 / 평균 cycles | 512 | 1024 |
| --- | ---: | ---: |
| `M55_ref` | 62,738,244.08 | 261,716,429.27 |
| `ntt_opt` | 56,951,252.89 | 243,157,439.34 |
| 이번 구현 | 54,272,283.64 | 230,887,529.01 |

이번에는 일반 배치와 사실상 같은 결과다. 이는 정수 함수 주소 차이가 이번 전체
개선의 주원인이라는 설명을 지지하지 않는다. 모든 코드·데이터 주소를 동일하게
맞춘 것은 아니다. 이 배치 스크립트는 검증용이며 최적화 코드의 기능이나 기본
실행 경로를 링크 설정으로 교체하는 방식이 아니다.

## 3. 정확성·KAT·서명 검증·시간 검사

| 검사 | 결과와 범위 |
| --- | --- |
| 최종 M55 키생성 KAT | 256/512/1024 각 100, **300/300 일치**; NTRU 방정식 정확 검사 통과 |
| 최종 M55 서명 KAT | 크기 4..1024, **90/90 일치**; 서명 검증·변조 거부 통과 |
| 전체 키생성 재측정 | 구현별 512/1024 각 100, 모든 KAT·방정식 통과; 세 구현의 인코딩된 키 쌍 해시 모두 일치 |
| invnorm 호스트 비교 | 0 입력 포함 **1,023,000개 출력 계수, 불일치 0** |
| M55 invnorm 커널 비교 | 시험 출력 모두 원본 Q32와 일치 |
| 최종 큰 iFFT 커널 오차 | 시험 입력에서 최대 **4 Q32 LSB**, 약 `9.313e-10` |
| 미채택 큰 FFT MVE 오차 | 512 최대 139 LSB, 1024 최대 264 LSB |
| 하드웨어 상태 | 실행 후 CFSR/HFSR/AFSR 모두 0, TCM/ECC 상태 검사 통과 |

invnorm을 처음에 제곱합까지 FP64로 바꾼 버전에서는 드문 1 LSB 차이와 0 입력의
특수 결과 문제가 있었다. 최종본은 **원본 Q32 제곱합을 유지**하고 나눗셈만
가속한다. 0 분모는 원본의 raw Q32 결과 `0xfffffffffffffffe`로 마스킹한다.
일반 입력 범위는 양의 정상 제곱합과 표현 가능한 몫을 전제로 한다.

시간 검사: logn=4..10 × FFT/iFFT/invnorm × 입력군 8개, 각 100회.
MVE 변환은 private 후보를 검사하므로 기본 경로에서 제외한 forward도 포함한다.
0 입력을 포함한 각 입력군의 반복 측정에서 동일 크기·연산 내 전체 sample 범위는
최대 **1 cycle**, 입력군별 평균 범위는 최대 **0.01 cycle**이었다. 입력군마다
준비한 배열 하나를 반복 실행한 검사이지 대규모 통계적 leakage test는 아니다.

정적 확인: MVE 어셈블리 루프 분기는 공개 크기에 따른 카운터를 사용하고,
Q32 변환에는 값에 따른 반복 횟수나 FP→int64 라이브러리 호출이 없다.
invnorm ELF에서는 native `vdiv.f64`를 확인했고 `__aeabi_*` helper 및 일반
조건 분기를 발견하지 않았다. 나눗셈 입력은 정상 mantissa로 정규화한다.
이는 **전체 상수시간 증명, 모든 입력의 수치 동등성 증명, 전력/EM 검증이 아니다.**
특히 iFFT 중간값은 원본과 bit-exact하지 않으므로 300개 KAT 통과만으로
임의의 모든 seed에 대한 KAT 동등성을 보장하지 않는다.

## 4. 환경·메모리

- 실제 NUCLEO-N657X0-Q / STM32N657 M55, 800 MHz, cache OFF.
- 코드 ITCM / 데이터·상수·스택 DTCM, 각각 256 KiB. ELF 주소도 검사했다.
- ARM GCC 15.2.1, `-O3`, `-mcpu=cortex-m55`, `-mfpu=fpv5-d16`,
  `-ffp-contract=off`, `-fno-fast-math`, `-fno-strict-aliasing`.
- 원본 M4 어셈블리 ON. `ntt_opt`와 새 구현은 기존 MVE NTT ON.
- 커널: DWT CYCCNT, IRQ OFF. 전체 키생성: 64-bit SysTick 확장, IRQ ON.
- 같은 compiler/board 설정·입력·횟수·harness, 각 보드 실행은 순차 수행.

| 펌웨어 | ITCM 사용 bytes | DTCM 사용 bytes |
| --- | ---: | ---: |
| 전체 키생성 `M55_ref` | 76,752 | 179,752 |
| 전체 키생성 `ntt_opt` | 88,808 | 187,944 |
| 전체 키생성 이번 구현 | 96,872 | 212,648 |
| 최종 키생성 KAT | 96,168 | 218,856 |
| 최종 서명 KAT | 112,092 | 250,920 |

위 값은 각 ELF의 정렬·예약 스택을 포함한 영역 점유량이며 함수 코드 크기만이 아니다.
가장 큰 서명 테스트의 DTCM 잔여는 **11,224 bytes**다. 64 KiB 예약 스택 안에
MVE 작업 배열 8 KiB를 지역 변수로 두었다. 전역 공유 작업 배열은 쓰지 않았다.
빌드·보드 테스트는 통과했지만 엄격한 최악 스택 사용량 증명은 별도로 하지 않았다.

## 5. 수정 파일·재실행·원시 로그

- 수정: [kgen_fxp.c](kgen_fxp.c), [kgen_inner.h](kgen_inner.h).
- 추가: [kgen_fft_mve.c](kgen_fft_mve.c), [kgen_fft_cm55.s](kgen_fft_cm55.s).
- 새 구현의 계산 소스와 상수는 모두 이 폴더 안에 있다. 다른 후보를 include/link하지 않는다.
- `kgen_ntru.c`, `kgen_poly.c`, NTT 소스, 서명·검증 소스는 `ntt_opt`와 동일함을 확인했다.
- 기존 복사본 README·결과는 [validation/legacy](validation/legacy)에 내용 그대로 보관했다.
  기존 `build/`, `profiling/` 산출물은 이번 실측 결과가 아니다.

빌드·재측정 방법: [validation/README.md](validation/README.md).
M55 실험의 실제 빌드 진입점은 `validation/build.sh`이며 복사된 호스트용 Makefile이 아니다.
자동 집계: `validation/analyze.py`. 요약 데이터:
[final_summary.json](validation/results/final_summary.json).
분석 프로그램은 최종 소스/ELF/raw SHA-256, 동일 입력 키 해시, 환경, 배치 조건을 검사한다.

| 측정 | raw log |
| --- | --- |
| 커널·오차·입력군 시간 검사 | [kernels](validation/results/kernels/20260927T045516Z/raw.log) |
| 최종 KAT | [kat](validation/results/kat/20260927T045625Z/raw.log) |
| 최종 서명 KAT | [sigkat](validation/results/sigkat/20260927T045746Z/raw.log) |
| 일반 배치 M55_ref | [keygen_ref](validation/results/keygen_ref/20260927T050235Z/raw.log) |
| 일반 배치 ntt_opt | [keygen_ntt](validation/results/keygen_ntt/20260927T050137Z/raw.log) |
| 일반 배치 이번 구현 | [keygen_current](validation/results/keygen_current/20260927T045921Z/raw.log) |
| 정수 주소 통제 M55_ref | [keylayout_ref](validation/results/keylayout_ref/20260927T045245Z/raw.log) |
| 정수 주소 통제 ntt_opt | [keylayout_ntt](validation/results/keylayout_ntt/20260927T045143Z/raw.log) |
| 정수 주소 통제 이번 구현 | [keylayout_current](validation/results/keylayout_current/20260927T045830Z/raw.log) |

각 로그 옆 `manifest.json`에 빌드 옵션·소스와 ELF hash·성공 판정이 있다.
초기 탐색 실행도 보존했지만 최종 판정은 위 목록만 사용했다.
