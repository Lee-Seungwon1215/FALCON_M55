# FP64 Q32.32 호환 후보 — 검증·실측 결과

2026-09-18. **정확성 검사 통과, 성능 때문에 미채택.**
원래 native FP64와 기존 `hybrid_fixed_div`, 원본 ref, 통합 코드는 변경하지 않았다.

## 1. 이번에 확정한 원인

이전의 “역수 준비는 fixed, 반복은 native FP64” 진단에서 남았던 두 사례를
64-bit raw word로 다시 수집했다. 원본 정수 상태를 유지한 채 최초 k 차이를
포착했으며, 독립 정수 모델의 FFT/계수별 곱셈/iFFT 출력을 실제 C와 대조했다.

| 사례 | 최초 문제 지점 / 원인 |
|---|---|
| `512/test58` | logn=6, depth=3, 769번째 반복. FFT 이후 `vect_mul_fft`의 complex index 31에서 `fxc_mul`의 `z0=ac`가 처음 wrap. raw 곱셈 결과 `-20355459693501784289`가 64-bit 절삭 후 `-1908715619792232673`으로 바뀜 |
| `1024/test65` | logn=3, depth=7, 1258번째 반복. wrap은 없고 primitive별 소수 비트 절삭과 연산 그래프 차이가 누적됨. index 6이 fixed `-1442.50051672291` → -1443, native `-1442.4982897414675` → -1442 |

512에서는 wrap만 없애도 k 63개가 달라졌다. 1024에서는 4곱셈을 사용하는
**고정소수점** 모델도 원본 3곱셈 모델과 k 1개가 달랐다. native 쪽을 3곱셈으로
되돌리는 것만으로도 해결되지 않았다. 일부 역수는 단일 double로 변환하는 순간
원본 raw 하위 비트가 사라진다.

따라서 마지막 반올림 함수만 바꾸거나 특정 seed를 예외 처리하는 해결책은 쓰지 않았다.
자세한 raw 값·양자화 시작점·이벤트는 [진단 보고서](../validation/compatibility_repair/README.md),
[요약 JSON](../validation/compatibility_repair/summary.json)에 있다.

## 2. 시험한 보정의 범위

이번 후보는 **순수 double FFT가 아니라**, 원본 Q32.32 비트 산술을 보존하면서
곱셈에 FP64를 사용하는 혼합 구현이다.

- 원본 `fxr` 저장, add/sub/half/rounding, wrap, 3-product complex graph 유지.
- 32×32 부분곱의 high word를 FP64로 계산하고 정수 low word로 반올림 carry를 보정.
- 그 결과로 signed 64×64 → Q32.32 곱셈을 원본과 동일하게 재현.
- 같은 보정을 모든 입력에 적용. seed 예외/입력 기반 backend 선택/fallback 없음.
- step ④의 FFT 2회, 계수별 곱셈 1회, iFFT 1회 호출만 새 함수로 연결.
- 역수 나눗셈은 원본이며 이전 빠른 divider를 합치지 않았다. FFT 변경 효과만 비교.

실제 변경 파일: `kgen_fxp.c`, `kgen_inner.h`, `kgen_ntru.c`.
`kgen_poly.c`와 assembly 파일은 변경하지 않았다.
다른 후보의 암호 코드를 빌드 옵션이나 링크로 가져오지 않고, 이 폴더의 C에 직접 작성했다.

## 3. 전체 키생성 성능

단위는 cycles/키생성 1회 평균. **양수 %는 느려졌다는 뜻**이다.

| 크기 | 기존 fixed ref | 이번 호환 후보 | 시간 배수 | 사이클 증가 |
|---|---:|---:|---:|---:|
| 512 | 57,007,002.20 | 79,173,946.18 | **1.38885×** | **+38.8846%** |
| 1024 | 243,375,295.54 | 303,080,043.10 | **1.24532×** | **+24.5320%** |

기준은 `../../ref`의 기존 고정소수점/NTT 최적화 코드다.
태초 FN-DSA 전체 ref나 처음의 native FP64 후보와 직접 비교한 표가 아니다.

## 4. Step ④ 근사 계산 profile

각 100회 키생성에서 발생한 구간 합계를 100으로 나눈 평균. 후보 재시도도 포함한다.
전체 시간은 위의 비계측 성능 펌웨어에서, 아래 구간은 별도 계측 펌웨어에서 측정했다.

| 구간 | 크기 | fixed | 호환 후보 | 시간 배수 |
|---|---:|---:|---:|---:|
| 입력 변환 + FFT + 역수 준비 | 512 | 1,083,009.80 | 1,763,455.10 | 1.62829× |
| 반복 변환 + FFT·곱셈·iFFT + 반올림 | 512 | 4,738,595.99 | 26,128,961.83 | **5.51407×** |
| 두 구간 합계 | 512 | 5,821,605.79 | 27,892,416.93 | 4.79119× |
| 입력 변환 + FFT + 역수 준비 | 1024 | 2,201,665.75 | 3,784,561.08 | 1.71895× |
| 반복 변환 + FFT·곱셈·iFFT + 반올림 | 1024 | 13,437,443.83 | 71,327,704.16 | **5.30813×** |
| 두 구간 합계 | 1024 | 15,639,109.58 | 75,112,265.24 | 4.80285× |

이 합계는 NTRU solve 전체나 step ④의 정수 해 갱신까지 포함한 시간이 아니다.
두 후보의 logn별 준비/반복 호출수 및 200개 키·서명 digest가 모두 일치했다.
다른 후보/키가 선택돼서 전체 시간이 바뀐 것이 아니다.

별도 frozen-input 미세커널(19개 입력, 100회, 10회 warm-up)에서는 입력 변환을
제외한 반복 FFT·곱셈·iFFT·반올림이 logn별 약 **6.26~7.74× 느렸다**.
실제 profile에는 big-int 입력 변환도 포함되므로 위의 5.31~5.51×와 측정 단위가 다르다.

## 5. 왜 느린가

soft-double을 잘못 호출한 것이 아니다. 최종 M55 바이너리의 `fp64q_mul`에는
native `VMUL.F64`가 9개 있고 FP 산술 runtime helper 호출은 없다.
부분곱 3개마다 FP64 곱셈, high-word 추출용 scaling, 경계 확인용 scaling을 수행한다.
변환·비트 대조·캐리 보정도 추가된다.

기존 `fxr_mul`은 M4용 inline assembly의 정수 곱셈/누산 경로다.
두 구현을 같은 펌웨어에서 256회씩 호출한 배치의 최소 시간은:

| 경로 | cycles/256회 배치 |
|---|---:|
| 원본 정수 곱셈 | 5,893 |
| FP64 호환 곱셈 | 77,317 |

호출·루프·load/store 오버헤드 포함 수치이며 단일 명령 latency가 아니다.
이번 구현에서는 보정 비용이 큰 것을 확인했다. 이를 **모든 가능한 FP64 곱셈
설계의 성능 하한 증명**이나 “FP64는 어떤 곳에서도 무조건 느리다”로 일반화하지 않는다.

## 6. 정확성·KAT·서명·시간차 검사

| 검사 | 결과 |
|---|---|
| high-word 곱셈 vs Python 무한정밀 정수 | **338,836건 일치**, binary64 rounding carry 경계 포함 |
| signed Q32.32 곱셈 vs Python 무한정밀 정수 | **1,036,100건 일치**, 전체 64-bit 패턴 random/경계값 |
| FFT / pointwise / iFFT 단계별 차분 | **245,520계수 bit-exact**, logn 1~10, wrapping 입력 포함 |
| 위 두 불일치 raw 입력 재생 | **두 사례 모두 원본 최종 raw output과 bit-exact** |
| 호스트 원본 keygen KAT | **300/300**, 기대값 변경 없음 |
| 실제 M55 원본 keygen KAT | **300/300**, 정수 `fG-gF=q`와 범위 확인 |
| 원본 signature KAT / self / verify — 호스트 | PASS |
| 보드 key/sign/verify/tamper reject | 각 perf/profile 실행에서 512·1024 각 100개, PASS |
| 보드 원본/후보 key+public key+signature digest | **200/200 일치**, perf/profile 간에도 일치 |
| 보드 곱셈 차분 | **100,000건 일치** |
| frozen-input 근사 k 커널 | **19개 모두 일치**, 매 반복 원본 k와 확인 |
| UBSan + float-cast-overflow | `kgen_fxp.c` TU에 적용한 KAT/전체 key-sign-verify 검사 PASS. 전체 프로그램 sanitizer 검사는 아님 |

현재 바이너리 정적 검사:

- 새 scalar 곱셈 코어에 조건부 분기/IT/함수 호출 없음.
- scalar 코어의 메모리 접근은 고정 stack/PC offset 및 ABI 출력 pointer의 고정 offset.
- 새 transform에는 public logn/index 기반 반복문이 있으며, IT 블록 없음.
- FP runtime helper/FMA/divide 없이 실제 native double multiply 사용.

시간차 측정은 34종 입력 × 256회 호출 × warm-up 1 + 유효 trial 20회로 수행했다.
원본은 모든 클래스에서 최소 5,893 cycles, 후보는 모든 클래스에서 최소 77,317 cycles.
관찰한 trial 흔들림은 원본 0, 후보 최대 1 cycle/배치다.

**한계:** 유한 입력 검사와 현재 바이너리 검토다. 전체 상수시간 형식 증명,
dudect 검증 또는 전력/EM 부채널 안전성 증명을 했다고 주장하지 않는다.
키생성 전체에는 원래 후보 거절에 따른 시간 변동이 있다.

## 7. 보드·빌드·메모리 조건

- NUCLEO-N657X0-Q / STM32N657, probe `003C00223335510735383531`.
- Cortex-M55 800 MHz, I/D cache OFF, TCM control 0x99.
- 기존 공통 배치: 코드 ITCM, 상수·데이터·스택 DTCM, 각각 256 KiB 설정.
  ECC 대응을 위해 코드는 하위 128 KiB 이내 유지.
- GCC 15.2.1, 동일 공통 pinned Zephyr/mlkem-native 부트·링커 환경.
- `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing`,
  Cortex-M55 hard-float, M4/M55 ASM 및 MVE MP31 ON. 양쪽 동일 옵션.
- `test0`~`test99`, 크기별 100개, warm-up 별도 1회.
  DWT CYCCNT, keygen 타이머 안에서는 IRQ OFF. 서명/검증은 타이머 밖.
- CFSR/HFSR/AFSR=0, TCM/ECC 정상, 모든 보드 실행 완료 확인.

| 전체 성능 측정 펌웨어 | fixed | 호환 후보 | 차이 |
|---|---:|---:|---:|
| ITCM ROM/code image | 101,588 B | 105,204 B | +3,616 B |
| DTCM RAM image | 220,232 B | 220,232 B | 0 B |

링커의 `FLASH` 라벨은 여기서는 실제 `0x10000000` ITCM 실행 영역이다.
RAM 수치는 예약 stack 포함 linker 크기이며 peak stack 실측이 아니다.

## 8. 채택 판단 및 보존

**이 후보는 성능 때문에 채택하지 않는다.**

- 원본 결과와 같은 FFT 산술을 FP64 보조 연산으로 재현하는 것은 이번 방식으로 확인했다.
- 하지만 이번 방식은 단순 double FFT가 아니며, 전체 키생성까지 느려졌다.
- 원래 `1st_native_fp64`의 순수 FP64 KAT 문제를 그 소스에서 해결한 것은 아니다.
- 기존 `hybrid_fixed_div`는 별도 후보로 보존했고 코드/결과를 덮지 않았다.
- `ref`, `ntt_opt`, 2nd~5th 폴더로 통합하지 않았다.
- baseline/native/기존 hybrid의 root C/H/S hash 보존을 최종 분석에서 확인했다.

## 9. 로그

- [종합 JSON](validation/results/summary.json), [호스트 검사](validation/build/host/summary.json)
- [보드 KAT](validation/results/kat/20260918T081118Z/raw.log)
- [커널·시간차](validation/results/kernels/20260918T081002Z/raw.log)
- 전체 성능: [fixed](validation/results/ref-perf/20260918T081252Z/raw.log), [호환 후보](validation/results/compat-perf/20260918T081340Z/raw.log)
- profile: [fixed](validation/results/ref-profile/20260918T081439Z/raw.log), [호환 후보](validation/results/compat-profile/20260918T081528Z/raw.log)
- [역어셈블리 검사](validation/results/static/summary.json)

각 실행의 `run.json`에 ELF/소스/원시 로그/컴파일 명령/build-time manifest가 있다.
최종 변경 소스 SHA-256:

```text
kgen_fxp.c   994c3bd082ce577d60fa5102b544c6350dbfef9068f7cb865ad9d94f55ab838d
kgen_inner.h 991090bdcebc279324e3b01d3aa73f851920a03559ef5eca3d9c4dd3985eeddf
kgen_ntru.c  427c69d2ccdbfddd7884a0ecdf44511949452fed54aa77bacf4a5ba2c1adabc9
```
