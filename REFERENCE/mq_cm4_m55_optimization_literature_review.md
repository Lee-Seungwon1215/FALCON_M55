# `mq_cm4.s` 이후의 M55 최적화 가능성: REFERENCE 10편 전수 검토

작성일: 2026-09-12  
대상 코드: `fn-dsa_m55/ref`, commit `a5f15894bf1a68017074650d5298cecf9bb29a79`  
검토 범위: `REFERENCE`의 PDF 10개, 총 223쪽(첫 페이지부터 마지막 페이지까지)

## 1. 한 줄 결론

**현재 `mq_cm4.s`는 M55에서의 최종 최적화본이 아니라 M4용 2-lane DSP 코드를 그대로 실행하는 기준점이므로, 그 위를 뚫고 나갈 여지가 분명히 있다.** 다만 돌파 수단은 FP64가 아니라 **q=12289 정수 연산을 위한 MVE/Helium 전용 백엔드**이다. 가장 타당한 방향은 `mq_cm4.s`를 덮어쓰는 것이 아니라 별도의 `mq_m55.s`를 만들고 다음 세 요소를 결합하는 것이다.

1. 128-bit MVE의 16-bit 8-lane 병렬 처리
2. 2개 또는 선택적으로 3개 NTT layer 병합과 마지막 layer의 de-interleaving load/store
3. Cortex-M55의 load/store, integer, multiply 파이프를 겹치도록 instruction scheduling 및 software pipelining

Plantard reduction은 M4에서는 매우 강하지만 M55 MVE에는 필요한 16×32 형태를 그대로 벡터화하기 어렵다. 따라서 **MVE Barrett multiplication과 현재 Montgomery 방식부터 실제 보드에서 microbenchmark로 비교**하고, Plantard는 세 번째 후보로 다루는 것이 객관적으로 맞다.

## 2. 무엇을 전부 읽었는가

대소문자 경로 중복을 제거한 실제 PDF 10개를 PDFKit으로 페이지별 추출하여 확인했다. 223쪽 중 빈 페이지는 없었다.

| PDF | 쪽수 | 주제 | `mq_cm4.s` 직접 관련도 |
|---|---:|---|---|
| `falcon_m4.pdf` | 18 | 최신 c-fn-dsa의 Cortex-M4 구현 | 매우 높음: 현재 코드의 설계 근거 |
| `m55_slothy.pdf` | 46 | M55/M85 MVE NTT·FFT 및 자동 scheduling | 매우 높음: 구현 방법과 M55 모델 |
| `m55_ntt-ftt_opt.pdf` | 29 | Cortex-M55 MVE polynomial multiplication/NTT | 매우 높음: 최초 M55 NTT 설계 원칙 |
| `ARMv8_falcon.pdf` | 15 | Falcon q=12289 NTT·FFT의 NEON 벡터화 | 높음: 같은 Falcon 산술, 다른 ISA |
| `Neon_NTT.pdf` | 38 | Barrett multiplication과 multi-stage NTT | 높음: reduction·layer 병합 원리 |
| `plantard.pdf` | 24 | 개선 Plantard arithmetic, M4 16-bit NTT | 중간: reduction 후보와 범위 분석 |
| `plantard_32bit.pdf` | 15 | M3/RISC-V Plantard와 lazy reduction | 중간 이하: 범위 설계는 유용, MVE 대상 아님 |
| `falcon_m7.pdf` | 22 | M7 native FP64 Falcon 및 profiling | `mq`에는 낮음, 전체 FN-DSA에는 중요 |
| `fp64_accuracy.pdf` | 18 | Falcon FP64 에뮬레이션의 형식 검증 | `mq`에는 없음, 검증 방법론은 중요 |
| `TWfalcon.pdf` | 25 | 3×FP32로 고정밀 서명 연산 | `mq`에는 없음, 서명 FP 경로의 별도 선택지 |
| **합계** | **223** |  |  |

## 3. 현재 `mq_cm4.s`가 실제로 하는 일

파일은 처음부터 `.cpu cortex-m4`로 선언돼 있고, q=12289의 정수 모듈러 연산만 구현한다. `vmov s2`와 `vmov s3`는 FPU 레지스터를 임시 저장공간으로 사용할 뿐, 부동소수점 계산이 아니다. `vadd.f64`, `vmul.f64` 같은 FP 명령은 전혀 없다.

현재 B 빌드도 이 파일을 `FNDSA_ASM_CORTEXM4=1`, `FNDSA_ASM_CORTEXM55=1`로 선택한다. CPU target은 Cortex-M55지만 별도의 수동 MVE `mq` backend는 없고, FPU 옵션도 `-mfpu=fpv5-sp-d16`이므로 현재 B가 native FP64 버전이라는 뜻도 아니다.

| 코드 구간 | 함수 | 역할 | 현재 병렬성 | M55 후보 |
|---|---|---|---|---|
| 21–57 | `mqpoly_small_to_int` | `int8` 계수를 내부 mod-q 표현으로 변환 | M4 packed DSP, 주로 4개씩 | MVE widen/sign-extend 및 predication |
| 68–96 | `mqpoly_signed_to_int` | signed 16-bit를 내부 표현으로 변환 | 2×16-bit DSP | 8×16-bit MVE |
| 107–133 | `mqpoly_int_to_ext` | 내부의 q 표현을 외부 0으로 정규화 | 2×16-bit DSP | 8×16-bit compare/select |
| 144–211 | `mqpoly_mul_ntt` | NTT-domain pointwise multiplication | 2 lane을 각각 scalar reduction | **가장 쉬운 첫 MVE pilot** |
| 222–255 | `mqpoly_sub` | mod-q 다항식 뺄셈 | 2×16-bit DSP | 8×16-bit MVE |
| 266–297 | `mqpoly_add` | mod-q 다항식 덧셈 | 2×16-bit DSP | 8×16-bit MVE |
| 308–327 | `mqpoly_sqnorm_signed` | signed 제곱노름 | `SMLAD` 2 lane | MVE widening dot/accumulate 검토 |
| 338–394 | `mqpoly_sqnorm_binf_int` | L2 및 L∞ bound 검사 | DSP + APSR.Q | MVE reduction + predicate, 반환 semantics 주의 |
| 405–449 | `mqpoly_sqnorm_int_to_signed` | centered 변환과 제곱노름 | DSP + APSR.Q | MVE 변환 + widening accumulate |
| 460–653 | `mqpoly_int_to_ntt` | 공통 q=12289 forward NTT | M4 2-lane butterfly | **핵심 MVE 대상** |
| 664–871 | `mqpoly_ntt_to_int` | 공통 q=12289 inverse NTT | M4 2-lane butterfly | **핵심 MVE 대상** |

소스: [`mq_cm4.s`](/Users/seungwon/FALCON/fn-dsa_m55/ref/mq_cm4.s), 함수 호출 지도: [`operation_call_map.md`](/Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/operation_call_map.md).

### FP64로 바꾸면 안 되는 이유

NTT는 유한체 `Z_q` 위의 **정확한 정수 연산**이다. 여기서 double을 사용하면 정수→부동소수점 변환, 반올림, 다시 mod-q 정규화가 추가될 뿐이다. M55의 scalar FP64는 서명의 FFT·LDL·ffSampling 같은 실수 연산에 쓸 수 있지만 `mq`에는 맞지 않는다. MVE도 FP64 2-lane 벡터가 아니라 16-bit 정수 8-lane을 활용하는 쪽이 맞다.

## 4. 10편에서 실제로 얻은 것

### 4.1 `falcon_m4.pdf` — 현재 코드가 왜 이렇게 생겼는가

Thomas Pornin의 2025 M4 업데이트는 현재 c-fn-dsa M4 어셈블리의 직접적인 근거다. STM32F407G-DISC1을 24 MHz, cache off, GCC 13.2.1, `-O2`, M4F 옵션으로 측정했다(p.2). 코드 크기를 억제하기 위해 NTT와 SHAKE를 완전히 unroll하지 않았고, 저자는 더 빠른 기존 NTT와 XKCP SHAKE로 교체하면 검증을 합쳐 약 50k cycles 더 줄일 수 있다고 직접 적었다(pp.3–4).

q=12289 NTT는 forward 27,087 cycles, inverse 29,672 cycles이며 forward 두 번과 inverse 한 번이 검증에 쓰인다(p.15). 구현은 `[0,q]`에 가까운 내부 표현, 2×16-bit packed DSP add/sub, `mul`+`umaal` Montgomery reduction을 사용한다(pp.15–16).

**판단:** `mq_cm4.s`는 “더 이상 줄일 수 없는 최종 코드”가 아니라 **작은 코드 크기와 M4 호환성을 의도적으로 택한 구현**이다. M55 전용 코드를 별도로 만드는 연구 타당성이 이미 이 논문 안에 있다.

자료: [`falcon_m4.pdf`](/Users/seungwon/FALCON/REFERENCE/falcon_m4.pdf), [IACR ePrint 2025/123](https://eprint.iacr.org/2025/123), [c-fn-dsa](https://github.com/pornin/c-fn-dsa).

### 4.2 `m55_slothy.pdf` — 가장 직접적인 M55 설계도

M55는 MVE 명령 하나가 두 cycle에 걸리는 dual-beat 구현이고, vector load/store, integer, multiply에 별도 실행 pipeline이 있다. 서로 다른 pipeline의 명령을 교대로 배치하면 실행을 겹칠 수 있지만, `VSTx; ?; VLDx` 일부 조합은 alignment에 따라 bank conflict를 일으킬 수 있다(pp.8–9, 21).

논문의 16-bit Kyber NTT는 Barrett multiplication을 `VMUL.S16`, `VQRDMULH.S16`, `VMLA.S16`의 세 명령으로 구성하고(p.32), 7개 layer를 **2+3+2**로 병합했다. MVE vector register가 8개뿐인데도 3-layer merge를 3회 stack spill로 실현했고, 마지막 layer에서는 `VLD4x`/`VST4x`를 이용해 lane 재배열을 처리했다(pp.33–34). SLOTHY scheduling 후 M55에서 942 cycles, 비교 M4 코드 대비 4.75–6.58배라는 결과를 보였지만, 이는 q=3329 Kyber NTT의 수치다(pp.35–36).

또한 SLOTHY는 산술 알고리즘이나 명령을 발명하지 않는다. 사람이 읽기 쉬운 base assembly와 instruction selection을 제공하면 register allocation, scheduling, software pipelining을 최적화한다(pp.2–4, 12). 따라서 우리도 먼저 q=12289용 올바른 MVE butterfly를 설계해야 한다.

**판단:** 우리 `mq_m55.s`의 최종 scheduling 도구로 매우 적합하다. 처음부터 뒤섞인 어셈블리를 손으로 쓰기보다, symbolic register와 macro로 깨끗한 base kernel을 만든 뒤 SLOTHY를 적용하는 편이 재현성과 논문 기여 측면에서도 낫다.

자료: [`m55_slothy.pdf`](/Users/seungwon/FALCON/REFERENCE/m55_slothy.pdf), [IACR ePrint 2022/1303](https://eprint.iacr.org/2022/1303), [SLOTHY 코드](https://github.com/slothy-optimizer/slothy), [M-profile benchmark 코드](https://github.com/slothy-optimizer/pqmx).

### 4.3 `m55_ntt-ftt_opt.pdf` — M55에서 NTT를 직접 짜는 원칙

이 논문은 M55의 MVE가 128-bit vector, 8개 vector register, dual-beat라는 조건에서 M4보다 3–5배 빠른 polynomial multiplication을 보였다(p.1). 최적 NTT 구현은 다음 원칙을 사용한다.

- 2개 radix-2 layer를 radix-4 형태로 합쳐 load/store를 줄임(pp.16–17)
- 3개 layer를 한 번에 합치면 8개 register 제약 때문에 spill이 생기므로 비용 비교가 필요함(p.17)
- twiddle은 가능한 한 GPR에 두고 scalar-vector 연산으로 vector register 압박을 줄임(p.17)
- 마지막 두 layer는 `VLD4` 계열 de-interleaving을 사용함(p.17)
- load/store, add/sub, multiply를 번갈아 배치해 dual-beat overlap을 유도함(pp.9–10, 17)
- inverse NTT의 최종 scale을 마지막 layer twiddle에 합침(p.19)

논문 수치는 degree 256의 32-bit NTT이고 실제 Nucleo가 아니라 MPS3 FPGA/FVP 계열 환경에서 얻었다(pp.20–22). 따라서 Falcon q=12289의 예상 cycle로 직접 인용하면 안 된다.

**판단:** ISA와 microarchitecture 전략은 직접 적용할 수 있지만, Falcon은 degree 512/1024, 16-bit q=12289이므로 데이터 배치, twiddle 상수, coefficient bound를 새로 설계해야 한다.

자료: [`m55_ntt-ftt_opt.pdf`](/Users/seungwon/FALCON/REFERENCE/m55_ntt-ftt_opt.pdf), [IACR ePrint 2021/998](https://eprint.iacr.org/2021/998), [원 논문 코드](https://gitlab.com/arm-research/security/pqmx).

### 4.4 `ARMv8_falcon.pdf` — 같은 q=12289 Falcon을 벡터화한 가장 가까운 산술 사례

이 논문은 Falcon의 FFT와 q=12289 NTT를 Armv8-A NEON으로 벡터화했다. NTT butterfly에서 8×16-bit coefficient를 읽고, widening multiplication과 Montgomery reduction을 수행하며, layer 병합과 register holding으로 메모리 접근을 줄였다(pp.8–11). 보고된 NTT/iNTT 자체 향상은 약 1.5–2.6배 범위이고, 검증 전체는 65% 이상 개선되었다(pp.11–13).

그러나 NEON 대상은 A-profile이다. 128-bit라는 폭은 같아도 NEON에는 32개 vector register가 있고 대상 CPU는 M55와 pipeline/issue 구조가 다르다. 논문은 당시 Falcon Round-3 참조 코드/PQClean 계열을 기반으로 하므로 현재 c-fn-dsa의 public-key NTT representation과 호출 구조도 그대로 같지 않다.

**판단:** q=12289 twiddle와 16-bit lane 산술을 벡터화할 수 있다는 강한 선행 근거다. 단, 어셈블리를 복사하는 것이 아니라 **산술식과 데이터 배치 아이디어만 MVE로 재설계**해야 한다.

자료: [`ARMv8_falcon.pdf`](/Users/seungwon/FALCON/REFERENCE/ARMv8_falcon.pdf), [IEEE Xplore/DOI](https://ieeexplore.ieee.org/document/9762260/).

### 4.5 `Neon_NTT.pdf` — Barrett multiplication과 multi-stage butterfly

한 operand가 twiddle처럼 알려진 상수일 때 signed Barrett multiplication을 `MUL`, `SQRDMULH`, `MLS`의 세 vector instruction으로 구성하는 방법을 제시한다(pp.11–14). 논문은 이 primitive가 MVE에도 적용 가능하다고 명시한다(p.13). 또한 여러 butterfly layer를 interleave해 load/store와 dependency stall을 줄이고, 16-bit NTT의 마지막 layer에서 필요한 de-interleaving을 다룬다(pp.15–20).

NEON 구현은 32개 vector register를 활용해 최대 4개 layer까지 크게 병합하므로 이를 8-register MVE에 그대로 옮길 수는 없다. 공개 코드는 논문 재현 commit도 별도로 명시한다.

**판단:** q=12289용으로 상수와 허용 입력 범위를 다시 계산하면, 현재 `mul`+`umaal` 기반 scalar Montgomery의 유력한 MVE 대안이다. `mqpoly_mul_ntt`처럼 두 operand가 모두 변수인 경우와 NTT twiddle multiplication처럼 한 operand가 상수인 경우를 구분해야 한다.

자료: [`Neon_NTT.pdf`](/Users/seungwon/FALCON/REFERENCE/Neon_NTT.pdf), [Neon NTT 코드와 재현 commit 안내](https://github.com/neon-ntt/neon-ntt).

### 4.6 `plantard.pdf` — M4에는 강력하지만 MVE에는 조건부 후보

개선 Plantard arithmetic은 constant multiplication에서 Montgomery보다 곱셈 하나를 줄이고, 넓은 입력 범위와 작은 출력 범위로 lazy reduction을 늘린다(pp.9–17). M4에서는 `SMULWB`/`SMLABB` 같은 16×32 scalar/DSP 명령을 이용해 constant Plantard multiplication을 2 cycle로 구현하고, double butterfly와 layer merging으로 Kyber/NTTRU NTT를 개선했다(pp.13–18).

중요한 정정도 있다. 2024년 proof 오류 지적과 2026년 output-range 지적을 반영해 `alpha > 0` 조건과 출력 범위 표현이 수정되었다(p.9와 갱신된 본문). 논문 스스로 AVX2/NEON에는 효율적인 16×32 형태가 없어 덜 적합하다고 평가한다(p.18). SLOTHY 논문도 M4 Plantard Kyber와 M55 MVE의 비교에서 “Plantard arithmetic cannot be vectorized”라는 이유로 M55 쪽 향상 배수가 더 작아진다고 설명한다(`m55_slothy.pdf`, p.36).

**판단:** q=12289도 16-bit odd modulus라 이론 적용 가능성은 있지만, MVE에서 유리한 instruction sequence가 먼저 발견되지 않으면 선택할 이유가 없다. 최신 정정된 range theorem으로 q=12289 상수와 lazy-reduction bound를 다시 증명한 뒤 microbenchmark해야 한다.

자료: [`plantard.pdf`](/Users/seungwon/FALCON/REFERENCE/plantard.pdf), [IACR ePrint 2022/956](https://eprint.iacr.org/2022/956), [공개 코드](https://github.com/UIC-ESLAS/ImprovedPlantardArithmetic).

### 4.7 `plantard_32bit.pdf` — 넓은 범위와 lazy reduction의 교훈

이 논문은 M3와 RISC-V처럼 SIMD가 없는 저가 32-bit core에서 Plantard 입력 범위를 더 넓혀 NTT/iNTT의 중간 modular reduction을 줄였다(pp.4–10). NTT layer grouping을 coefficient growth에 맞춰 다르게 선택하고, stack/speed 버전을 분리하며, pointwise multiplication에서 미리 계산한 값을 cache하는 time-memory trade-off도 사용했다(pp.8–11). M3에서 NTT 26%, iNTT 33–34% 개선을 보고했다(p.12).

**판단:** MVE instruction 선택의 직접 자료는 아니다. 다만 “항상 같은 지점에서 reduce”하지 말고 q=12289에 대해 각 layer 뒤의 최대 coefficient를 증명해 불필요한 reduction을 지우라는 설계 원칙은 유효하다. 16-bit 저장 직전에는 `32767` bound를 반드시 만족해야 한다.

자료: [`plantard_32bit.pdf`](/Users/seungwon/FALCON/REFERENCE/plantard_32bit.pdf), [arXiv 2309.00440](https://arxiv.org/abs/2309.00440), [공개 코드](https://github.com/UIC-ESLAS/Kyber_RV_M3).

### 4.8 `falcon_m7.pdf` — FP64의 효과가 `mq`에는 없다는 대조군

M7 native double은 Falcon keygen/sign에서 큰 전체 향상을 보였지만, 검증에는 부동소수점 연산이 없어 NTT/public-key 계산이 native와 emulation 사이에서 바뀌지 않았다(pp.8, 11–12). 또한 여러 STM32 M7에서 double add 등 일부 FP64 연산의 operand-dependent timing을 관측했다(pp.13–18). 이 논문은 STM32F767ZI Nucleo-144, 216 MHz, GCC 10.2.1, `-O2`, 1,000회라는 별도 조건과 구 Falcon Round-3 코드를 사용했다(pp.2–4).

**판단:** native FP64는 Stage C의 서명 FFT/ffSampling에는 후보지만, `mq_cm4.s` 최적화 방법이 아니다. FP64를 쓴다면 성능뿐 아니라 STM32N657에서의 operand-dependent timing을 별도로 재검증해야 한다.

자료: [`falcon_m7.pdf`](/Users/seungwon/FALCON/REFERENCE/falcon_m7.pdf), [NIST 발표/논문 페이지](https://csrc.nist.gov/presentations/2022/benchmarking-and-analysing-nist-pqc-lattice-based), [IACR ePrint 2022/405](https://eprint.iacr.org/2022/405).

### 4.9 `fp64_accuracy.pdf` — 빠른 어셈블리의 검증 방법

구 Falcon의 emulated FP multiplication이 매우 작은 normal 값 일부를 잘못 zeroize하는 문제를 찾았지만, FFT의 실제 허용 입력 범위를 CryptoLine으로 모델링해 Falcon signature FFT에는 영향이 없음을 증명했다(pp.6–12). 새 Armv7-M assembly/Jasmin 구현과 모델의 동등성도 검증했다(pp.11–13). keygen은 최신 흐름에서 fixed-point로 바뀌었고 sign FFT는 여전히 실수 연산이라는 구분도 명시한다(pp.14–15).

**판단:** q-NTT 산술에는 직접 쓸 FP 기법이 없다. 대신 MVE assembly를 “KAT가 통과하니 맞다”로 끝내지 않고, 읽기 쉬운 base 구현과 optimized 구현의 동등성, 입력 범위와 reduction 범위를 기계적으로 검증하는 방법론을 제공한다.

자료: [`fp64_accuracy.pdf`](/Users/seungwon/FALCON/REFERENCE/fp64_accuracy.pdf), [IACR ePrint 2024/321](https://eprint.iacr.org/2024/321), [검증 코드](https://github.com/vincentvbh/Float_formal).

### 4.10 `TWfalcon.pdf` — FP32를 세 단어로 쓰는 별도 연구축

2026년 TWFalcon은 하나의 고정밀 값을 FP32 세 개로 표현해 최소 72-bit precision을 얻는다(pp.1–8). 최신 c-fn-dsa를 수정해 Cortex-M4F용 C/assembly 구현을 만들었으며, Gaussian sampler의 관측 error를 binary64보다 줄였다고 보고한다(pp.9–12, 21–22). M4에서는 정수 기반 binary64 emulation보다 sign이 약 1.8배 느렸다(pp.19–21). 이 논문의 binary64 보안-bound 주장은 저자들의 분석 결과로 받아들여야 하며, 현재 알려진 실용 공격이 있다는 뜻은 아니다(pp.1–3, 21–22).

**판단:** `mq`와는 무관하다. 하지만 M55의 MVE FP32를 이용한 triple-word FFT를 별도 연구주제로 삼을 수는 있다. 이는 “MVE q-NTT” 이후의 다른 최적화 축이며, scalar native FP64 버전과 정확도·timing·속도를 함께 비교해야 한다.

자료: [`TWfalcon.pdf`](/Users/seungwon/FALCON/REFERENCE/TWfalcon.pdf), [TWFalcon 공개 코드](https://github.com/NXP-Research/TWFalcon).

## 5. 논문 10편을 합치면 나오는 `mq_m55` 설계

### 5.1 유지해야 할 기준점

- A: M4 논문 조건을 가능한 범위에서 재현한 `mq_cm4.s`
- B: 동일 M4 코드를 최소 수정하여 M55에서 실행한 현재 기준점
- B-MVE: 같은 알고리즘/API/내부 표현을 유지한 새 `mq_m55.s`
- C: 서명 실수 경로를 native scalar FP64로 바꾸는 별도 실험
- D: FFT, sampling, 31-bit NTRU NTT까지 추가 M55 최적화

`mq_cm4.s`를 직접 덮어쓰면 A→B의 재현 기준을 잃는다. 새 파일과 새 매크로/빌드 선택 분기로 분리해야 한다.

### 5.2 1차 구현: 위험이 낮은 vector loop

첫 구현 순서는 다음이 합리적이다.

1. `mqpoly_add`, `mqpoly_sub`, `signed_to_int`, `int_to_ext`
2. `mqpoly_mul_ntt`
3. norm 함수들
4. forward NTT
5. inverse NTT

1–3은 lane 간 dependency가 거의 없어 MVE 명령과 load/store가 올바른지 검증하기 쉽다. 특히 `mqpoly_mul_ntt`는 NTT layer permutation 없이 연속 coefficient 8개를 처리할 수 있어 modular multiplication 후보들의 실제 cycle을 비교하기 좋다.

단, pointwise multiplication은 두 operand가 모두 변수이므로 “known twiddle 전용 3-instruction Barrett”을 그대로 쓸 수 없다. variable×variable용 Montgomery/Barrett sequence와 NTT butterfly의 variable×constant sequence를 따로 설계해야 한다.

### 5.3 2차 구현: forward/inverse NTT

권장 구조는 다음과 같다.

- 초기/중간 layer: 두 radix-2 layer를 한 kernel에 병합
- 가능한 구간: `2+3+2` 또는 degree 512/1024에 맞춘 `2+2+…` 후보를 모두 생성해 실제 cycle과 code size 비교
- 마지막 layer: `VLD2`/`VLD4` 또는 `VST2`/`VST4`로 lane permutation 처리
- twiddle: vector register를 차지하지 않도록 가능한 한 GPR에서 scalar-vector operand로 공급
- inverse 최종 scaling: 마지막 twiddle/reduction에 흡수 가능한지 검증
- inner loop: low-overhead loop(`WLS`/`LE`)와 software pipelining 적용
- scheduling: load/store → multiply → add/sub가 교차하도록 배치하고 M55 ST-LD hazard 회피

M55는 MVE 명령이 dual-beat이므로 8개 lane을 처리한다고 무조건 8배가 되지 않는다. 현재 M4도 이미 두 coefficient를 packed DSP로 처리한다. 따라서 현실적인 연구 목표는 “8/2=4배”를 약속하는 것이 아니라, **pipeline overlap을 포함한 kernel cycle/coeff를 실측하여 기존 M4-assembly-on-M55 기준보다 유의미하게 낮추는 것**이다.

### 5.4 q=12289에서 반드시 다시 증명할 범위

현재 내부 값은 대체로 `[1,q]`이고 q도 0의 내부 표현으로 허용된다. `q=12289`이므로 한 번의 덧셈 `x+y <= 24578`은 signed 16-bit 안에 들어가지만, reduction 없이 다음 layer까지 더하면 `49156` 가능성이 있어 signed 16-bit를 넘는다. 따라서 타 논문의 lazy reduction 위치를 그대로 가져오면 안 된다.

각 kernel마다 다음 invariant를 문서화해야 한다.

- 입력 lane 범위
- butterfly add/sub 뒤 범위
- twiddle multiplication이 허용하는 입력 범위
- 16-bit memory에 store할 때의 범위
- q를 0으로 허용하는 내부 표현이 유지되는지
- inverse의 `/2` 처리와 홀수 보정이 bit-exact한지

Barrett, Montgomery, Plantard 후보마다 이 표가 별도로 필요하다.

### 5.5 SLOTHY를 쓰는 정확한 시점

SLOTHY는 잘못된 butterfly나 reduction을 고쳐주지 않는다. 순서는 다음이어야 한다.

1. macro와 symbolic register를 사용한 읽기 쉬운 q=12289 MVE base assembly 작성
2. C reference와 모든 `logn=2..10` differential test
3. range invariant 검증
4. 그 뒤 SLOTHY Cortex-M55 model로 scheduling/register allocation/software pipelining
5. SLOTHY의 CFG self-check 외에 입력/출력 메모리 dependency와 offset rewrite도 독립 검사
6. 실제 NUCLEO-N657X0-Q에서 PMU/DWT cycle 실측

이 순서라야 “빠르지만 이해할 수 없는 새 어셈블리”가 되지 않고, 논문에서 주장할 수 있는 감사 가능성과 재현성을 확보한다.

## 6. 예상되는 전체 효과와 한계

우리의 이전 **참조 C, ASM OFF** 프로파일에서 q=12289 NTT+iNTT의 비중은 다음과 같았다.

| 단계 | M55 비중 | q-NTT만 무한히 빨라질 때의 이론상 최대 전체 향상 |
|---|---:|---:|
| 키생성 | 1.30% | 약 1.013배 |
| 서명 | 2.28% | 약 1.023배 |
| 검증 | 25.92% | 약 1.350배 |

이 수치는 [`m4_m55_fndsa512_reference.md`](/Users/seungwon/FALCON/fn-dsa_m55/ref/profiling/results/m4_m55_fndsa512_reference.md)의 instrumented reference-C 결과이지 현재 B의 M4 assembly 비중은 아니다. 그래도 우선순위는 명확하다.

- `mq_m55`의 가장 큰 end-to-end 효과: **검증**
- 키생성의 다음 큰 대상: NTRU solver, CRT, 별도 31-bit RNS `mp_NTT/mp_iNTT`, fixed-point FFT
- 서명의 다음 큰 대상: LDL+ffSampling, emulated-FP FFT, SHAKE

예를 들어 위 참조-C 비중에 Amdahl 법칙을 적용하면 q-NTT가 4배 빨라져도 검증 전체 향상은 약 1.24배다. 따라서 “MVE NTT가 완성되면 서명·키생성도 몇 배 빨라진다”는 주장은 성립하지 않는다. 반대로 검증의 약 1/4이 q-NTT였으므로 첫 M55 논문 결과를 만들기에는 좋은 목표다.

## 7. 객관적인 최종 판단

### 할 수 있는 것

1. **M4 assembly를 넘어설 수 있다.** M55에서 현재 `mq` backend는 MVE를 전혀 사용하지 않으며, 같은 16-bit NTT가 M55에서 성공적으로 벡터화된 강한 선행 사례가 있다.
2. **연구상 차별점도 있다.** 기존 M55 논문들은 주로 Kyber/Dilithium/Saber이고, Falcon/FN-DSA의 최신 c-fn-dsa q=12289 공통 backend를 M55 MVE로 옮긴 것은 이 10편 안에는 없다.
3. **재사용 범위가 넓다.** forward q-NTT는 키생성·서명·검증이 공유하고, inverse와 pointwise multiply는 서명·검증이 공유한다.
4. **안전한 개발 흐름이 있다.** clean base assembly → range/differential proof → SLOTHY scheduling → actual-board measurement 순서가 선행연구로 뒷받침된다.

### 하면 안 되는 것

1. `mq` 정수를 FP64로 바꾸는 것
2. AArch64 NEON assembly를 M55에 그대로 복사하는 것
3. Kyber q=3329의 twiddle, reduction 상수, coefficient bound를 q=12289에 그대로 쓰는 것
4. Plantard가 M4에서 빠르다는 이유만으로 MVE에서도 빠르다고 가정하는 것
5. 원본 `mq_cm4.s`를 수정해 A/B 기준점을 잃는 것
6. KAT 통과만으로 range·constant-time·memory-layout 동등성이 증명됐다고 보는 것

## 8. 바로 실행할 수 있는 연구 순서

### Phase 0 — 기준 측정 보강

- 현재 B에서 `mqpoly_int_to_ntt`, `mqpoly_ntt_to_int`, `mqpoly_mul_ntt`를 각각 100회 이상 독립 측정
- degree 512와 1024를 분리
- code ITCM, data/stack DTCM, cache 조건과 clock을 고정
- total API cycle과 kernel cycle을 함께 남김

### Phase 1 — modular multiplication bake-off

- M4 방식의 MVE Montgomery
- known-twiddle MVE Barrett
- 가능하면 corrected Plantard
- 각각 cycle/8 coefficients, code bytes, 허용 입력 범위를 비교

**Go/No-Go 기준:** KAT/differential test 전부 통과, constant-time control/memory access 유지, pointwise 또는 butterfly당 기존 M4 assembly-on-M55보다 cycle 감소.

### Phase 2 — 쉬운 공통 함수 MVE화

- add/sub/conversion/norm/pointwise multiply
- 작은 함수부터 호출 ABI와 저장 순서를 확정

### Phase 3 — NTT/iNTT layer kernel

- 2-layer merge를 먼저 완성
- `2+2+...`와 제한적 3-layer merge 비교
- tail de-interleaving 방식 비교
- inverse scale fusion 검토

### Phase 4 — scheduling과 검증

- SLOTHY M55 model 적용
- `VST; ?; VLD` hazard 및 alignment 실측
- clean/optimized CFG와 offset mapping 보존
- 모든 logn, random/adversarial coefficient, KAT, keygen/sign/verify end-to-end 검사

### Phase 5 — 전체 알고리즘으로 확장

- 검증 결과가 유효하면 31-bit `mp_NTT/mp_iNTT`
- native scalar FP64 서명 경로(C)
- LDL/ffSampling, SHAKE 및 선택적으로 MVE FP32/TW 연구(D)

## 9. 가장 현실적인 첫 구현 제안

첫 코드는 `mqpoly_mul_ntt`의 MVE 버전이 좋다. 이유는 다음과 같다.

- 연속 8 coefficient를 처리해 lane shuffle이 거의 없다.
- forward/inverse NTT보다 오류 위치를 찾기 쉽다.
- variable×variable modular multiplication의 실제 M55 비용을 먼저 알 수 있다.
- 여기서 선택한 내부 representation과 reduction primitive를 NTT/iNTT 설계에 재사용할 수 있다.

그 다음 `mqpoly_add/sub`, 이후 forward NTT, 마지막으로 inverse NTT 순서가 안전하다. 성능만 보면 NTT부터 가고 싶지만, 첫 MVE ABI·lane order·reduction 오류를 복잡한 layer permutation과 동시에 디버깅하면 연구 시간이 크게 늘어난다.

## 10. 출처와 해석 원칙

이 문서의 수치와 기법은 각 PDF의 해당 페이지에서 확인했다. 플랫폼과 알고리즘이 다른 논문의 speedup은 우리 STM32N657/FN-DSA 예상치로 전환하지 않았다. 특히 아래 세 비교는 분리했다.

- M4 vs M55라는 core 차이
- scalar/DSP vs MVE라는 구현 차이
- Falcon q=12289 vs Kyber q=3329/Dilithium q=8380417이라는 산술 차이

현재 upstream c-fn-dsa는 아직 최종 FIPS 206과의 호환성을 보장하지 않으며 1.0 이전에는 형식이 바뀔 수 있다고 명시한다. 따라서 최적화 논문과 재현 실험은 반드시 commit을 고정해야 한다. 현재 조사 대상은 `a5f15894...`이다. Upstream 상태: [c-fn-dsa README](https://github.com/pornin/c-fn-dsa).

### PDF 원문 목록

1. Youngbeom Kim, Jingyo Song, Seog Chung Seo, “Accelerating Falcon on ARMv8,” [`ARMv8_falcon.pdf`](/Users/seungwon/FALCON/REFERENCE/ARMv8_falcon.pdf), 15쪽.
2. Hanno Becker et al., “Neon NTT,” [`Neon_NTT.pdf`](/Users/seungwon/FALCON/REFERENCE/Neon_NTT.pdf), 38쪽.
3. Stef Halmans et al., “TWFalcon,” [`TWfalcon.pdf`](/Users/seungwon/FALCON/REFERENCE/TWfalcon.pdf), 25쪽.
4. Thomas Pornin, “Falcon on ARM Cortex-M4: an Update,” [`falcon_m4.pdf`](/Users/seungwon/FALCON/REFERENCE/falcon_m4.pdf), 18쪽.
5. James Howe, Bas Westerbaan, “Benchmarking and Analysing … ARM Cortex M7,” [`falcon_m7.pdf`](/Users/seungwon/FALCON/REFERENCE/falcon_m7.pdf), 22쪽.
6. Vincent Hwang, “Formal Verification of Emulated Floating-Point Arithmetic in Falcon,” [`fp64_accuracy.pdf`](/Users/seungwon/FALCON/REFERENCE/fp64_accuracy.pdf), 18쪽.
7. Hanno Becker et al., “Polynomial multiplication on embedded vector architectures,” [`m55_ntt-ftt_opt.pdf`](/Users/seungwon/FALCON/REFERENCE/m55_ntt-ftt_opt.pdf), 29쪽.
8. Amin Abdulrahman et al., “Fast and Clean: Auditable high-performance assembly via constraint solving,” [`m55_slothy.pdf`](/Users/seungwon/FALCON/REFERENCE/m55_slothy.pdf), 46쪽.
9. Junhao Huang et al., “Improved Plantard Arithmetic for Lattice-based Cryptography,” [`plantard.pdf`](/Users/seungwon/FALCON/REFERENCE/plantard.pdf), 24쪽.
10. Junhao Huang et al., “Yet another Improvement of Plantard Arithmetic for Faster Kyber on Low-end 32-bit IoT Devices,” [`plantard_32bit.pdf`](/Users/seungwon/FALCON/REFERENCE/plantard_32bit.pdf), 15쪽.
