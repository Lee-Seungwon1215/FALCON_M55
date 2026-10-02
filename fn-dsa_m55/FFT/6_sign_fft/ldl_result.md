# fpoly_LDL_fft — native FP64 전환 결과

2026-09-28. 작업 경로: `fn-dsa_m55/FFT/6_sign_fft`.
**Final_code/Before_slothy에는 아직 LDL 변경을 반영하지 않았다.**

## 비교 범위

- 기준: 현재 `Final_code/Before_slothy`. 공통 NTT·K4C·키생성 A17·서명 FFT/iFFT A5 ASM이 이미 적용된 코드다.
- 후보: 기준과 같은 암호 소스에서 **sign_fpoly.c의 LDL 함수 및 해당 함수 전용 입출력 helper만** 변경했다.
- split/merge, sampler, 공통 `fpr_*`, `ffsamp_fft_deepest()` 안의 별도 LDL 계산은 그대로다.
- SLOTHY·FP32·MVE 병렬화·FMA 단일 반올림은 추가하지 않았다.
- 아래 전체 서명 개선률은 **LDL 변경 직전 대비 추가 개선**이다. 태초 M55_ref 대비 수치가 아니다.

## 구현

기존 C 반복문은 각 위치마다 정수 ASM `fpr_div/mul/add`를 호출했다.
현재는 같은 반복문 안에서 `double`로 동일한 순서의 연산을 수행한다.

```text
u = 1 / g00
mu_re = g01_re * u
mu_im = g01_im * u
z = (mu_re * g01_re) + (mu_im * g01_im)
d11 = g11 - z
l10 = mu_re - i*mu_im
```

기존 `fpr` 배열은 binary64 비트 패턴이므로, `VLDR/VSTR`로 직접 읽고 쓴다.
정수값을 double로 수치 변환하지 않으며 Q32 보정·변환 버퍼도 없다.
API·배열 배치·in-place 출력 규칙은 유지한다.

- 실제 생산 변경 파일: [sign_fpoly.c](sign_fpoly.c).
- C의 FP64 산술을 컴파일한 결과는 `VDIV.F64`, `VMUL.F64`,
  `VMLA.F64`, `VSUB.F64`, `VNEG.F64`이다.
- `VMLA`는 곱셈 뒤 덧셈의 반올림을 유지하는 명령이며, 단일 반올림의 `VFMA`가 아니다.
  프로젝트의 `-ffp-contract=off`와 함께, disassembly에서 VFMA 계열이 없음을 확인했다.
- LDL 내부 함수 호출 0, 수치 변환 명령 0. 외부 공통 `fpr_*`는 수정하지 않았다.
- 생산 Makefile·헤더·링커·구현 선택용 옵션은 이번 LDL 변경을 위해 수정하지 않았다.
  측정용 CMake는 양쪽 펌웨어를 같은 조건으로 컴파일한다.

## LDL 단독 커널

같은 ELF에 동결된 기존 LDL 함수와 후보 함수를 넣고, 동일 입력·동일 버퍼로 교대 실행했다.
입력 준비·복사·검사는 계측 밖이며 함수 호출과 배열 읽기/쓰기는 포함한다.
크기별 구현당 100회, 준비 실행 3회, upper median. 두 차례 실행에서 대표값이 같았다.

| 크기 n | 기존 정수 에뮬레이션 cycles | native FP64 cycles | 속도 배율 | cycles 감소 |
|---|---:|---:|---:|---:|
| 2 | 976 | 193 | **5.057배** | 80.23% |
| 4 | 1,897 | 349 | **5.436배** | 81.60% |
| 8 | 3,741 | 661 | **5.660배** | 82.33% |
| 16 | 7,429 | 1,285 | **5.781배** | 82.70% |
| 32 | 14,805 | 2,533 | **5.845배** | 82.89% |
| 64 | 29,557 | 5,029 | **5.877배** | 82.99% |
| 128 | 59,061 | 10,021 | **5.894배** | 83.03% |
| 256 | 118,069 | 20,005 | **5.902배** | 83.06% |
| 512 | 236,085 | 39,973 | **5.906배** | 83.07% |
| 1024 | 472,117 | 79,909 | **5.908배** | 83.07% |

512/1024 표의 값은 해당 크기 LDL **1회** 실행이다. 전체 서명에서는 여러 작은 크기의
LDL이 재귀적으로 호출되므로, 아래 전체 서명 성능과 직접 동일시하면 안 된다.
logn=1(n=2)는 함수 경계 시험이며 실제 ffSampling은 이 크기에서 별도 deepest 경로를 쓴다.

## 전체 서명 — 계측 OFF

원본/후보를 각각 크기별 100회씩 2회 실행했다. 모든 실행은 같은 메시지·키 준비 순서·
서명 seed 100종을 사용했다. 2회는 새로운 무작위 표본이 아니라 동일 입력의 재현성 확인이다.
표는 실행당 평균의 평균이다. 내부 함수 프로파일 계측은 없다.

| 크기 | LDL 변경 전 cycles | LDL 변경 후 cycles | 속도 배율 | cycles 감소 |
|---|---:|---:|---:|---:|
| 512 | 14,851,581.460 | 13,203,722.425 | **1.1248배** | **11.10%** |
| 1024 | 31,642,697.640 | 27,942,998.575 | **1.1324배** | **11.69%** |

LDL 변경 전후는 이번에 모두 새로 측정했다. FFT/iFFT 자체는 양쪽 모두 A5 ASM으로 동일하다.
같은 코드·상수·데이터 배치 정책을 사용했으며 전체 함수의 절대 주소를 고정한 실험은 아니다.
다만 이번 서명 이미지의 LDL 시작 주소는 양쪽 모두 `0x1001196c`였다.
반복 실행의 100회 누적 시간 차이는 최대 2사이클이었다.

| 펌웨어 메모리 | 변경 전 | 변경 후 |
|---|---:|---:|
| 코드 영역 ITCM 사용량 | 125,476 B | 125,368 B |
| DTCM 상수·데이터·스택 할당 | 245,496 B | 245,496 B |
| LDL 함수 심볼 크기 | 216 B | 106 B |

코드 영역은 108 B 감소했다. 전용 큰 상수표나 추가 배열이 없다.
링커 출력의 FLASH/RAM 명칭은 이 측정 플랫폼에서 실제 ITCM/DTCM으로 매핑된다.
스택의 실제 최대 사용량을 새로 계측한 것은 아니다.

## 정확성·KAT·서명검증

| 검사 | 결과 |
|---|---|
| LDL 원본 대비 비트 비교 | logn=1..10, 각 128입력 = **1,280/1,280 통과**, 동일 시험 2회 |
| 원본 대비 오차 | 시험한 출력에서 **비트 차이 0**, g00 미변경, 버퍼 guard 오류 0 |
| 서명 KAT | **90/90 일치**, 정상 검증·변조 거부 통과 |
| 기존 키생성 KAT | **300/300 일치**, NTRU 방정식 검사 통과 |
| 추가 seed 키생성 KAT | **300/300 일치**, NTRU 방정식 검사 통과 |
| API 검사 | 정상 64건 통과, 잘못된 입력 3,902건 거부, guard 오류 0 |
| 성능 측정 서명 | 매 실행 크기별 100/100 정상 검증, 정해진 변조 거부 검사 통과 |
| 결정적 출력 지문 | 512 `9895079d`, 1024 `a020dd02`: 변경 전후 및 반복 실행 동일 |
| 보드 fault | 모든 채택 실행 CFSR/HFSR/AFSR=0, TCM/ECC 유지 |

LDL 시험 입력에는 signed zero, 2의 거듭제곱, 가수 경계, 다양한 부호·지수,
상쇄/상쇄 직후 값이 포함된다. 원본이 지원하는 유한 normal/zero 범위를 시험했다.
NaN/Inf/subnormal이나 모든 가능한 입력의 동등성을 증명한 것은 아니다.
키생성 KAT는 회귀검사이며, 직접적인 LDL 검증은 커널 비교와 서명 KAT/API 검사다.
FNV 지문만으로 동등성을 주장하지 않는다.

## 상수시간 점검

- 정적 검사: LDL의 메모리 주소는 공개 `logn`과 반복 인덱스로만 정해진다.
  입력값에 따른 분기/테이블 인덱스는 없고, `DLS/LE` 반복 제어만 있다.
- LDL timing screen: 각 logn=1..10에서 8개 입력군 × 100회, 두 차례 실행.
  512의 전체 입력군 min..max는 39,958..39,960 cycles,
  1024는 79,894..79,895 cycles였다.
- raw FP64 역수 명령 검사: 20개 입력군 × 100회, 매 측정 `VDIV.F64` 32회.
  두 차례 모두 **모든 측정이 1,127 cycles**였다.
  2의 거듭제곱·인접 가수·최대 가수·무작위 가수와 여러 지수를 포함한다.
- 커널 성능 표와 timing screen은 호출 형태가 달라 고정 부가 비용이 다르다.
  서로 다른 시험의 절대값 차이를 입력 의존 시간차로 해석하지 않는다.
- 관측한 범위에서는 뚜렷한 입력 의존 지연을 발견하지 못했다.
  **형식적 상수시간 증명, 전력/EM TVLA, 모든 FP 특수값 검증은 아니다.**

## 환경

NUCLEO-N657X0-Q / STM32N657, CPU/SYSCLK/HCLK 800/400/200 MHz.
ITCM 코드, DTCM 상수·데이터·스택, 각각 256 KiB. cache OFF, ECC ON.
GCC 15.2.1 / Zephyr 4.4.1 / pinned mlkem-native 기반 보드 설정.
`-O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard`,
`-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
DWT CYCCNT, timed API/커널 구간 IRQ OFF, 서명 warm-up 3회.
정상 검증·seed 준비·로그 출력은 성능 계측 밖이다.

## 원자료 및 재현

- baseline_sign: [20260928T092235Z 로그](validation/results/baseline_sign/20260928T092235Z/raw.log) / [manifest](validation/results/baseline_sign/20260928T092235Z/manifest.json)
- baseline_sign: [20260928T092619Z 로그](validation/results/baseline_sign/20260928T092619Z/raw.log) / [manifest](validation/results/baseline_sign/20260928T092619Z/manifest.json)
- candidate_api: [20260928T092315Z 로그](validation/results/candidate_api/20260928T092315Z/raw.log) / [manifest](validation/results/candidate_api/20260928T092315Z/manifest.json)
- candidate_extra: [20260928T092522Z 로그](validation/results/candidate_extra/20260928T092522Z/raw.log) / [manifest](validation/results/candidate_extra/20260928T092522Z/manifest.json)
- candidate_kat: [20260928T092437Z 로그](validation/results/candidate_kat/20260928T092437Z/raw.log) / [manifest](validation/results/candidate_kat/20260928T092437Z/manifest.json)
- candidate_ldl: [20260928T092137Z 로그](validation/results/candidate_ldl/20260928T092137Z/raw.log) / [manifest](validation/results/candidate_ldl/20260928T092137Z/manifest.json)
- candidate_ldl: [20260928T092634Z 로그](validation/results/candidate_ldl/20260928T092634Z/raw.log) / [manifest](validation/results/candidate_ldl/20260928T092634Z/manifest.json)
- candidate_sigkat: [20260928T092303Z 로그](validation/results/candidate_sigkat/20260928T092303Z/raw.log) / [manifest](validation/results/candidate_sigkat/20260928T092303Z/manifest.json)
- candidate_sign: [20260928T092250Z 로그](validation/results/candidate_sign/20260928T092250Z/raw.log) / [manifest](validation/results/candidate_sign/20260928T092250Z/manifest.json)
- candidate_sign: [20260928T092606Z 로그](validation/results/candidate_sign/20260928T092606Z/raw.log) / [manifest](validation/results/candidate_sign/20260928T092606Z/manifest.json)

- [자동 집계 JSON](validation/ldl_summary.json)
- [집계·소스 범위·disassembly 검사](validation/analyze_ldl.py)
- [시험용 원본 LDL](validation/oracle_ldl.c)
- [커널 검사 프로그램](validation/ldl_kernel.c)
- [standalone 라이브러리 빌드 로그](validation/library_ldl.log)

각 실행 디렉터리에 ELF, 실제 생산 소스 archive, 컴파일 명령, disassembly와 SHA-256 기록을 보존했다.
기존 FFT-only 결과와 실패/이전 소스 로그는 삭제하지 않고 별도로 유지한다.

```sh
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh ldl
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py ldl
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign baseline
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign baseline
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign
# sigkat / kat / extra / api도 각각 build 후 run
python3 fn-dsa_m55/FFT/6_sign_fft/validation/analyze_ldl.py
```

## 통합할 때 주의

이번 암호 변경은 `sign_fpoly.c` 한 파일뿐이다. 다른 암호 C/H/S 37개는 현재
Before_slothy와 byte-identical이다. split/merge 최적화는 아직 시작하지 않았다.

기존 `Before_slothy/Makefile`은 복사된 `sign_fft_cm55.s`를 아직 S_SOURCES에 나열하지 않는다.
이번 보드 측정에서는 별도 측정 CMake가 **양쪽 모두 해당 ASM을 직접 컴파일**했으므로
위 비교에 영향을 주지 않았다. 이후 standalone 통합 시 이 누락도 보완해야 한다.
`6_sign_fft/Makefile`에는 이전 FFT 단계부터 해당 항목이 이미 들어 있으며 LDL로 인한 추가 변경은 없다.

후보 sign_fpoly.c SHA-256: `48b462f633fa66c9b3c2fbef99514053f1fd35d279633363be1cf214fe548875`.
