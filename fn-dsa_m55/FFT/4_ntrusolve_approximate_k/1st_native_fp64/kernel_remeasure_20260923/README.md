# 고정소수점 대 FP64: 변경한 커널만 재측정

2026-09-23, 사용자 요청으로 실제 NUCLEO-N657X0-Q에서 새로 실행한 측정이다.
기존 기록끼리 전체 키생성 평균을 나눈 비교가 아니다.
암호 소스와 기존 빌드 ELF는 변경하지 않는다. 현재 source/build manifest와
ELF가 일치하는지 검사한 뒤 검증된 동일 ELF를 보드에 다시 적재한다.

## 비교 대상과 기준

- F1 `fp64_vfma`: 정확한 부분곱 VMLA → VFMA.
- F2 `fp64_two_prod`: FMA 잔차로 정확한 word 곱 재구성.
- F3a `fp64_loop_merge`: F2 + FFT 2-layer 병합.
- F3b `fp64_loop_schedule`: 병합 + 지역 SLOTHY.
- F3c `fp64_schedule_only`: 병합 없이 지역 SLOTHY.

각 ELF 안에서 고정소수점과 해당 FP64 후보를 직접 비교한다. 고정소수점
코드는 후보 파일에 그대로 남아 있는 원본 함수이며, `M55_ref`의 함수 25개와
GM_TAB의 모든 상수 값이 동일함을 `analyze.py`에서 검사한다. 주석/공백과
F3의 상수표 공개 이름 차이만 정규화한다. 이전 `M55_ref` 전체 API 실행
사이클을 이 측정의 분모로 사용하지 않는다.

공통 `kernel_bench.c`와 `kernel_cases.h`의 SHA256 일치, 옵션 및 원시 로그·
source·ELF 해시를 검증한다. 모든 후보의 함수 주소까지 강제로 같게 한
실험은 아니다. 후보 간 작은 차이는 코드 배치 영향을 포함할 수 있으므로
고정소수점 사이클은 해당 후보와 같은 ELF에서 측정한 값을 사용한다.

## 타이머 범위

| 지표 | 포함 | 제외 |
|---|---|---|
| FFT 단독 | `vect_FFT()` / `vect_FFT_fp64_exact()` | 입력 배열 구성·표현 변환 |
| iFFT 단독 | `vect_iFFT()` / `vect_iFFT_fp64_exact()` | 입력 배열 구성·표현 변환 |
| 준비 커널 | FFT → `vect_inv_mul2e_fft()` 또는 FP64 대응 함수 | 큰 정수 입력 변환 |
| 반복 커널 | FFT → 점별 곱 → iFFT → 정수 k 반올림 | 큰 정수 입력 변환·정확한 정수 해 갱신 |
| 실수 곱셈 wrapper | raw 입출력 변환·함수 호출·곱셈·loop·sink | FFT 전체 |

점별 곱·역수 준비·반올림은 이번에는 묶음 커널에 포함된다. 각각의 함수
단독 시간을 별도로 측정했다고 주장하지 않는다. `poly_big_to_fixed()`와
`poly_big_to_fp64_exact()`는 이번 타이머 범위 밖이다.

전체 키생성·NTRU solve·CRT·Bezout·NTT·서명·검증 시간은 보고하지 않는다.

## 공통 조건과 통계

- 실제 보드 ST-LINK: `003C00223335510735383531`. 한 번에 한 실행만 진행.
- CPU 800 MHz, cache OFF, ECC ON, ITCM/DTCM 각각 256 KiB 설정.
  코드는 하위 128 KiB ITCM, 상수·데이터·stack은 DTCM의 기존 정책.
- GCC 15.2.1, `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math
  -fno-strict-aliasing`; 기존 M4 인라인 ASM ON. 기준만 강제 스칼라화하지 않음.
- DWT CYCCNT, 계측 중 IRQ OFF. 32-bit 타이머 차분이며 각 측정 구간은
  2^32 cycles 미만. 큰 누적 합은 64-bit 변수에 보관.
- FFT/iFFT: logn 1..10, 각 20종 입력. 1회 warm-up + 20 trial의 최소값.
  같은 연산·크기의 20종 입력에서 최소값이 모두 같은지도 확인.
- 준비/반복 커널: 기존 실제 NTRU 중간 입력 19개 사례. 10회 warm-up +
  100회 평균. 고정소수점/이전 FP64 C/현재 후보의 실행 순서를 매회 회전.
- 곱셈: 동일 raw 입력 wrapper로 256회 호출한 최소 cycle / 256.
  primitive 한 명령의 latency로 해석하지 않음.

FFT 길이 n은 FN-DSA 키 크기가 아니다. 변경한 NTRU ④ intermediate 경로에서
FN-DSA-512의 최대 FFT 길이는 256, FN-DSA-1024는 512다. 전체 logn별 값은
JSON에 보존하며 n=1024 FFT 측정은 함수 진단용으로만 분류한다.

## 검증과 재현

매 실행에서 곱셈 random 1,000,000쌍 + 경계 36,864쌍, FFT/iFFT 81,840
coefficient positions, 실제 NTRU 사례 19개의 raw/정수 k 일치를 확인한다.
add/half/div 회귀 검사와 67개 timing 그룹의 입력별 최소 사이클 검사도
실행된다. 이는 유한 입력 검사이며 전체 상수시간 증명이나 부채널 인증은 아니다.

이번에는 KAT 300개와 전체 서명/검증을 다시 실행하지 않는다. 암호 코드는
변경하지 않았고 해당 검증의 이전 기록은 각 후보의 `result.md`에 있다.

실행 순서: F2 → F1 → F3a → F3b → F3c → F2 재실행.
각 후보 폴더에서 `python3 validation/run_board.py kernels`로 실행한다.
새 raw log는 기존 `validation/results/kernels/<UTC timestamp>/`에 추가한다.
다른 보드 작업이 실행 중이면 동시에 실행하지 않는다.

이 폴더에서 `python3 analyze.py`로 집계한다. `--partial`은 진행 중 확인용이다.
기본 시작 시각은 `20260923T030111Z`이며 그 이후 첫 실행만 선택한다
(F2는 첫 두 실행). 따라서 이전 수치를 새 측정으로 오인하지 않는다.

최종 결과는 [result.md](result.md), 전체 로그 위치·정확성·수치는
[summary.json](summary.json)에 기록한다.
