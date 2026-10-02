# Step ④ FP64 / fixed-point hybrid: 측정 및 검증 결과

측정일: 2026-09-18. 현재 후보 구현·보드 검증 완료. **기존 통합 ref는 미교체.**

## 결론

기존 고정소수점 결과를 유지하면서 `vect_inv_mul2e_fft()`의 나눗셈만
FP64 몫 추정 + 정확한 정수 보정으로 변경했다. 순수 FP64 FFT 구현이 아니다.

| 이전 문제 | 이번 후보 결과 |
|---|---|
| 순수 FP64의 기존 키생성 KAT 26/300 불일치 | 호스트·M55 모두 **300/300 일치**. 기대값 변경 없음 |
| 입력별 나눗셈 시간차 | 최종 바이너리에 조건부 분기·IT 없음. 24종 입력의 최소 배치 시간 동일. 전체 CT 증명은 아님 |
| FP64 반복 구간이 fixed보다 1.64~1.82배 느림 | 반복 FFT 구간을 fixed로 유지하여 **baseline과 동일 사이클**. FP64 반복 FFT 자체를 가속한 것은 아님 |

## 1. 비교 조건

- 기준 소스: `../../ref` — 기존 NTT 최적화 적용 상태의 고정소수점 구현.
  “태초 FN-DSA ref”와 비교한 수치가 아니다.
- 후보 소스: 이 폴더. root C/H/S 전체 중 **`kgen_fxp.c`만 다름**.
- 실제 보드: NUCLEO-N657X0-Q / STM32N657, Cortex-M55.
- 지정 probe: `003C00223335510735383531`. 다른 보드 사용 안 함.
- CPU 800 MHz, I/D 캐시 OFF, TCM control `0x99`.
- 코드 ITCM, 상수·데이터·스택 DTCM. 기존 공통 ECC 대응 배치 정책 유지.
  ITCM/DTCM 각각 256 KiB 설정이며 코드는 안전한 하위 128 KiB 이내.
- GCC 15.2.1, 공통 pinned Zephyr/mlkem-native 부트·링커 환경.
- 암호 C/ASM: `-O3 -mcpu=cortex-m55 -mthumb -mfloat-abi=hard`,
  유효 FPU 옵션 `-mfpu=fpv5-d16`, `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 기존 M4/M55 어셈블리 및 MVE MP31 경로 ON; baseline과 candidate에 같은 옵션 사용.
- 키생성: 512·1024 각각 `test0`~`test99`, 100회, 별도 warm-up 1회.
  DWT CYCCNT, 측정 중 IRQ 차단. 서명/검증/변조 검사는 키생성 타이머 밖에서 수행.
- 계측 없는 전체 성능과 구간 계측 profile을 별도 펌웨어로 측정.
- 전체 성능은 baseline→hybrid, 이어 hybrid→baseline 순서로 **2회씩 재측정**.

## 2. 전체 키생성 성능

수치는 100개 입력의 평균 cycles. 아래는 두 번째 측정 결과다.
사이클 감소율 = `(baseline-hybrid)/baseline`; 배속 = `baseline/hybrid`.

| 크기 | baseline | hybrid | 사이클 감소 | 배속 |
|---|---:|---:|---:|---:|
| 512 | 57,007,002.14 | 56,416,873.45 | **1.0352%** | 1.01046× |
| 1024 | 243,375,295.54 | 242,190,644.58 | **0.4868%** | 1.00489× |

중앙값은 512: 48,150,560 → 47,577,164 cycles,
1024: 195,772,943 → 194,623,806 cycles.

측정 순서를 바꾼 두 실행 사이의 **100회 합계** 차이는 baseline 512에서 2 cycles,
hybrid 512에서 4 cycles, 양쪽 1024에서 0 cycles였다. 같은 입력 재측정의 재현성을
확인한 것이며, 서로 다른 200개 난수 seed를 사용했다는 뜻은 아니다.

## 3. Step ④ 내부 구간

아래 평균은 100번 키생성 중 발생한 해당 구간의 전체 사이클을 100으로 나눈 값이다.
후보 거절 과정에서 수행한 호출도 포함한다. 단일 함수 호출 평균은 아니다.

| 구간 | 크기 | baseline | hybrid | 사이클 감소 | 배속 |
|---|---:|---:|---:|---:|---:|
| 역수 준비: 입력 변환 + FFT + `vect_inv_mul2e_fft` | 512 | 1,083,009.80 | 479,530.38 | **55.7224%** | **2.25848×** |
| 역수 준비: 입력 변환 + FFT + `vect_inv_mul2e_fft` | 1024 | 2,201,665.75 | 990,346.89 | **55.0183%** | **2.22313×** |
| 반복 근사: 변환 + FFT·곱셈·iFFT + 정수 `k` 반올림 | 512 | 4,738,595.99 | 4,738,595.99 | 0% | 1.00000× |
| 반복 근사: 변환 + FFT·곱셈·iFFT + 정수 `k` 반올림 | 1024 | 13,437,443.83 | 13,437,443.83 | 0% | 1.00000× |
| 위 두 구간 합계 | 512 | 5,821,605.79 | 5,218,126.37 | **10.3662%** | 1.11565× |
| 위 두 구간 합계 | 1024 | 15,639,109.58 | 14,427,790.72 | **7.7454%** | 1.08396× |

이 합계는 **NTRU solve 전체나 step ④의 정수 해 갱신까지 포함한 수치가 아니다.**
전체 키생성 개선폭은 작지만, 준비 구간 자체의 개선은 크다.

준비 구간 호출수는 512에서 879, 1024에서 1,107;
반복 구간 호출수는 92,174 / 251,354였다. **모든 logn별 호출수도 두 후보가 같다.**
동일한 계산 결과/거절 흐름을 유지한 상태로 비교했다.

별도의 동일 펌웨어 frozen-input 커널 검사 19개에서도 출력이 모두 일치했다.
그 커널은 `logn=1..9`의 실제 NTRU 입력을 고정해 100회씩 측정한다.
반복 부분에 나타나는 호출당 약 1-cycle 차이는 공개 backend 분기/호출·버퍼 배치가
포함된 그 harness의 차이다. 전체 profile에서는 반복 구간 사이클이 정확히 같았다.

## 4. 정확성·KAT·서명검증

| 검사 | 결과 | 범위 |
|---|---|---|
| 독립 Python 무한정밀 정수 몫/반올림 + 기존 C divider 대조 | **1,036,896개 일치** | 네 부호 조합, 경계값, 자리 경계·반올림, 명시한 quotient-fit 영역 |
| 0 분모 legacy 결과 | 일치 | 호스트 188개 magnitude × 부호 조합 및 보드 랜덤 0 분모 사례 포함 |
| FFT/역수 벡터 차분 | **204,600개 계수 bit-exact** | random/sparse/zero/tiny fixed 입력 |
| 원본 keygen KAT — 호스트 | **300/300** | 256·512·1024 각각 100개 |
| 원본 keygen KAT — 실제 M55 | **300/300** | 동일 원본 벡터, 기대값 재생성 안 함 |
| 정수 NTRU 방정식 / 계수 범위 | PASS | `fG-gF=q`를 정수 다항식으로 독립 확인; 원본 keypair 검사 |
| 원본 signature KAT / self / verify — 호스트 | PASS | 원본 `test_kat`, `test_self`, `test_verify` |
| M55 keyed sign / verify / tamper reject | **각 실행 200/200** | 512·1024 각각 100개; 위 성능/profile 실행마다 수행 |
| baseline/hybrid key+public key+signature digest | **200/200 일치** | 성능 두 반복 및 profile 전체 사이에서도 일치 |
| 보드 divider 차분 | **100,000개 일치** | 혼합 부호, 큰/작은 분모, 0 분모 |
| UBSan + float-cast-overflow | PASS | `kgen_fxp.c` TU에 적용, KAT와 key/sign/verify 실행. 전체 프로그램 sanitizer 검사는 아님 |

정확한 정수 보정으로 Q32.32 출력 오차는 위 검사에서 **0 bit**다.
이 말은 전체 NTRU 수치 범위가 형식적으로 증명됐거나, 모든 가능한 입력을
전수 검사했다는 뜻은 아니다. 적용 범위와 오차 경계 논증은
[division_design.md](division_design.md)를 참고한다.

## 5. 상수시간 점검

단순 C 마스크를 사용한 초기 초안에서 GCC가 조건부 literal/stack load를 생성했다.
첫 수정 후에도 IT 조건부 정수 명령 때문에 특정 입력에 호출당 1-cycle 차이가 남았다.
이를 명시적 borrow/zero 비트 및 `volatile` 중간값으로 제거했다.

최종 divider의 현재 GCC 바이너리:

- 조건부 분기 0, IT 블록 0, 다른 함수 호출 0.
- 메모리 접근은 고정 stack/PC literal 오프셋. 입력 기반 주소 없음.
- `VDIV.F64` 1개, 정수 divide/FP runtime helper/FMA 없음.
- VDIV 피연산자는 항상 양의 정규수. 0 분모도 하드웨어에는 1로 공급.

최종 timing harness는 24종 입력 × 256회 호출 × 20개 유효 trial로 검사했다.

| divider | 256회 호출 배치의 최소 cycles | 입력 종류별 최소값 차이 | 관찰된 최대 trial 흔들림 |
|---|---:|---:|---:|
| 원본 | 451,588 | 0 | 1 cycle / 배치 |
| hybrid | 156,932 | 0 | 1 cycle / 배치 |

측정 루프/호출 오버헤드를 포함한 배치 기준 약 **2.8776×**다.
예전처럼 입력 종류에 따라 256 또는 512 cycles가 반복적으로 갈리는 현상은 없어졌다.

**한계:** 유한한 입력 실측 + 현재 바이너리 정적 검사이다. dudect 검사,
전체 상수시간 증명, 전력/EM 안전성 증명을 했다고 주장하지 않는다.
컴파일러/옵션 변경 시 재검사해야 한다. 키생성 전체에는 원래 후보 거절에 따른
시간 변동이 있고, 이번 검사는 새 divider가 추가하는 시간차에 초점을 둔다.

## 6. 메모리

전체 성능 측정 펌웨어의 linker/nm 기준:

| 영역 | baseline | hybrid | 차이 |
|---|---:|---:|---:|
| ITCM 코드/ROM image | 101,588 B | 102,536 B | **+948 B** |
| DTCM static + 예약된 스택 등 RAM image | 220,232 B | 220,232 B | 0 B |

링커 출력에서 `FLASH`라고 표시된 영역의 실제 실행 주소는 `0x10000000` ITCM이다.
hybrid ROM end `0x10019088`, RAM end `0x30035c48`.
128 KiB 코드 제한 및 256 KiB 데이터 제한 이내. 여기의 RAM 값은 **실제 peak stack
사용량 측정값이 아니라 예약 스택을 포함한 linker 크기**다.

## 7. 로그와 재현성

- [최종 기계 판독 요약](validation/results/summary.json)
- [나눗셈 독립 대조](validation/build/division/summary.json)
- [호스트 검사 요약](validation/build/host/summary.json)
- [호스트 원본 KAT/서명 로그](validation/build/host/hybrid-kat_audit.log)
- [보드 keygen KAT 300개](validation/results/kat/20260918T060843Z/raw.log)
- [최종 보드 커널·시간차 검사](validation/results/kernels/20260918T061326Z/raw.log)
- [최종 divider 역어셈블리 점검](validation/results/static/summary.json)
- 전체 성능 1회차: [baseline](validation/results/ref-perf/20260918T061012Z/raw.log),
  [hybrid](validation/results/hybrid-perf/20260918T061101Z/raw.log)
- 전체 성능 2회차: [hybrid](validation/results/hybrid-perf/20260918T061534Z/raw.log),
  [baseline](validation/results/ref-perf/20260918T061623Z/raw.log)
- 구간 profile: [baseline](validation/results/ref-profile/20260918T061149Z/raw.log),
  [hybrid](validation/results/hybrid-profile/20260918T061238Z/raw.log)

각 최종 실행의 `run.json`에는 ELF·소스·원시 로그·컴파일 명령 및 build manifest
해시가 있다. 빌드 당시 파일과 실행 전후 파일의 일치도 검사한다.
최종 `kgen_fxp.c` SHA-256:

```text
e89f626245ac2163dabcfdc3ba1dfbfd777061b04887fd2562efbfa811a6b9d1
```

`kernels/20260918T055956Z`, `060438Z`는 시간차가 남아 있던 **폐기한 초안** 로그다.
`060718Z`는 최종 암호 소스의 추가 검사이나 build-time manifest 도입 전 기록이다.
최종 판정에는 manifest가 있는 `061326Z`를 사용한다.

원본/순수 FP64 실험, 2nd~5th 폴더, 통합 `ntt_opt`는 변경하지 않았다.
