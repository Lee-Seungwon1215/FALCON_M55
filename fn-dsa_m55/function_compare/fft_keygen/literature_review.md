# 키생성 FP64 FFT 구현을 위한 REFERENCE 전수 검토

검토일: 2026-09-24

## 결론

이번 구현에 직접 적용할 수 있는 핵심은 다음 네 가지다.

1. 복소수는 split-complex 배열에서 실수부 `double` 하나와 허수부 `double` 하나로 유지한다.
2. Cortex-M55의 MVE에는 FP64 vector lane이 없으므로 FFT 산술은 scalar FP64로 구현한다. ARMv8-A NEON의 `2 x FP64` 코드는 그대로 이식하지 않는다.
3. 원본 Q32.32 twiddle, 3-real-multiply 복소 곱셈, 연산별 절삭/wrap, iFFT의 단계별 half를 먼저 보존한다. FMA·식 재배치는 별도 후보로만 시험한다.
4. 정확한 기준 구현 뒤에 2-layer 병합, register holding, 독립 butterfly interleave, load/store 선행 배치와 SLOTHY를 차례로 시험한다.

## 논문별 판정

| 논문 | 검토 범위 | 이번 FP64 FFT에 대한 판정 |
|---|---:|---|
| `falcon_m4.pdf` | 18쪽 전체 | 키생성은 64-bit fixed-point이며 `fxr_mul/sqr`만 M4 inline assembly로 가속한다. 메모리 접근 교차 배치와 고정 경로 검사는 적용 후보지만, M4의 FPU-register 임시 저장 기법은 native FP64 값을 담아야 하는 M55 구현에 그대로 적용하지 않는다. |
| `falcon_m7.pdf` | 22쪽 전체 | MCU에서 native FP64 Falcon을 측정한 직접 기준이다. FP64 자체의 성능 이득과 별개로 일부 FPU 명령의 입력 의존 timing을 관찰했으므로, M55에서도 명령 생성과 입력군 timing을 별도로 검사한다. |
| `ARMv8_falcon.pdf` | 15쪽 전체 | split real/imag, fused complex arithmetic, 2-layer merging, register holding, twiddle/register reuse가 직접 후보이다. 단 NEON `2 x FP64` 병렬성은 MVE에 없고 FMA는 Q32 단계별 결과를 바꿀 수 있어 그대로 복사하지 않는다. |
| `TWfalcon.pdf` | 25쪽 전체 | 정밀도·constant-time·직접 커널 benchmark 방법을 채택한다. triple-word/FP32 다중 워드 표현은 사용자 고정 조건과 충돌하므로 부적합이다. |
| `fp64_accuracy.pdf` | 18쪽 전체 | FFT 중간 범위와 구현 동등성을 KAT만으로 주장하면 안 된다는 근거다. 원본 대조, 첫 불일치 추적, 범위/역어셈블리 검사를 채택한다. |
| `m55_ntt-ftt_opt.pdf` | 29쪽 전체 | M55 dual-beat, 제한된 vector register, layer fusion과 메모리 비용 분석은 방법론으로 사용한다. 정수 NTT/Toom-Cook 산술 및 MVE lane 자체는 FP64 FFT에 부적합하다. |
| `m55_slothy.pdf` | 46쪽 전체 | 사람이 알고리즘·명령 선택을 먼저 고정한 뒤 register allocation, scheduling, software pipelining을 수행하는 절차를 적용한다. scalar FP64 명령 모델 지원 여부를 먼저 확인한다. |
| `Neon_NTT.pdf` | 38쪽 전체 | layer merging, permutation을 load/store에 흡수, inverse scaling 결합이라는 일반 원칙만 참고한다. 모듈러 reduction과 NEON NTT 명령은 본 FFT에 부적합하다. |
| `plantard.pdf` | 24쪽 전체 | lazy reduction을 쓰기 전 범위 증명이 필요하다는 검증 원칙만 적용한다. Plantard 산술은 정수 모듈러 곱셈용이므로 부적합하다. |
| `plantard_32bit.pdf` | 15쪽 전체 | register 수에 맞춘 layer split과 범위 분석 방법만 참고한다. 32-bit 모듈러 산술은 부적합하다. |
| `Vista do Fast Implementation ... Signatures.pdf` | 16쪽 전체 | Cortex-M85 MVE의 sliding-window, vector/scalar 혼합 비용, GCC/Clang scheduling 차이를 확인했다. 대상은 `GF(2^m)` carry-less multiplication이며 FP64 FFT와 산술이 달라 직접 적용하지 않는다. |

## 구현 후보 순서

| ID | 내용 | 상태 |
|---|---|---|
| B0 | 원본 Q32 커널과 입력 fixture·hash 고정 | 완료 |
| B1 | scalar native FP64 + 연산별 Q32 호환 기준 구현 | 완료; 정확하지만 FFT/iFFT가 지나치게 느려 기준 후보로만 보존 |
| B2 | Q32 보정 중복 제거(범위가 증명된 지점만) | 완료; 실제 NTRU 범위에서 불필요한 보정을 제거 |
| B3 | 2-layer FFT/iFFT 병합 | 완료; exact-Q32 후보에서는 손해였으나 native 후보의 최종 구조에 통합 |
| B4 | 하위 layer register holding과 twiddle preload | 컴파일 결과와 병합 루프에서 확인·측정 |
| B5 | 2/4개 독립 butterfly 수동 interleave | 독립 곱 dependency와 병합 butterfly로 시험; 최종 후보는 4-product FMA 경로 |
| B6 | FMA 복소 곱셈 | 직접 scalar FP64 asm으로 구현; 최종 KAT 통과 및 채택 |
| B7 | handwritten scalar FP64 assembly | `VMUL.F64` + `VFMS.F64`/`VFMA.F64` inline asm 구현·채택 |
| B8 | SLOTHY scheduling | 현 Armv8.1-M 모델이 scalar D-register FP64를 지원하지 않아 적용 불가 |

## 적용하지 않는 기법

- MVE FP16/FP32 SIMD로 FP64를 여러 워드에 나누는 방식
- ARMv8-A NEON의 `v?.2d` 명령을 M55에서 사용할 수 있다고 가정하는 방식
- Plantard·Montgomery·Barrett 등 NTT 전용 모듈러 reduction
- global fast-math 또는 compiler option만으로 후보를 바꾸는 방식
- 원본 KAT 변경, 실패 seed 예외 처리, fixed-point fallback으로 FP64 실패를 숨기는 방식

## 첫 구현의 정확성 기준

- 원본 Q32 twiddle을 exact하게 `double`로 변환한다.
- forward는 원본의 `mul -> add/sub`, inverse는 `add/sub -> half -> mul` 순서를 유지한다.
- 순수 double 값 일치뿐 아니라 각 연산 뒤의 Q32 raw 결과를 비교한다.
- 단일 double로 보존할 수 없는 Q32 경계 반례는 명시적으로 회귀시험한다.
- 최종 채택은 KAT, NTRU 식·범위, 정상 서명/검증, 변조 거부, timing 검사와 M55 실측을 모두 통과해야 한다.
