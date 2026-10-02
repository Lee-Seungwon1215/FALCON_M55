# FN-DSA q=12289 NTT/iNTT의 Cortex-M55 구현 설계

## 결론

`mqpoly_int_to_ntt()`와 `mqpoly_ntt_to_int()`에 대해 MVE와 FP64라는 두 구현을 만들 수는 있다. 그러나 두 구현의 연구적 지위는 같지 않다.

- **MVE 정수 구현**은 이 함수들의 본래 수학인 `F_q`, `q=12289` 연산과 맞고, M55 NTT 선행연구가 직접 뒷받침하는 주 최적화 경로다.
- **FP64 구현**은 가능하지만 10편 중 q-NTT를 FP64로 가속한 논문은 없다. Falcon에서 native FP64의 큰 효과가 확인된 곳은 복소 FFT와 Gaussian sampling이고, q-NTT가 사용되는 검증은 거의 이득을 보지 않았다.[^5] 따라서 FP64 q-NTT는 MVE와 동등한 최종 후보라기보다 “정수 NTT를 정확한 double 연산으로 바꿨을 때 실제 M55에서 어떤가”를 확인하는 대조 실험으로 두는 것이 타당하다.

권장 구현 순서는 다음과 같다.

1. 현재 M4 assembly와 같은 결과를 내는 scalar C oracle을 고정한다.
2. MVE forward/iNTT를 먼저 구현한다.
3. Barrett과 rounding Montgomery, 2-layer와 3-layer 병합을 실제 STM32N657에서 비교한다.
4. 별도의 FP64 exact-modular 버전을 구현해 MVE 및 oracle과 비교한다.
5. 최종 FN-DSA 최적화에서 native FP64의 주 적용 대상은 q-NTT가 아니라 FFT/ffSampling 경로로 잡는다.

## 현재 코드에서 반드시 보존할 의미

대상 함수는 다음 두 구간이다.

- forward: [`fndsa_mqpoly_int_to_ntt()`](/Users/seungwon/FALCON/fn-dsa_m55/ref/mq_cm4.s:460)
- inverse: [`fndsa_mqpoly_ntt_to_int()`](/Users/seungwon/FALCON/fn-dsa_m55/ref/mq_cm4.s:664)

현재 assembly의 forward는 CT(Cooley–Tukey) butterfly를, inverse는 GS(Gentleman–Sande) 계열을 쓴다. 내부 residue는 Cortex-M4 전용 relaxed 표현 `[0,q]`이고, `q` 또는 `0`이 0을 나타낼 수 있다. 현재 코드는 32-bit GPR 하나에 16-bit 계수 두 개를 넣고 `SADD16/SSUB16`으로 두 lane을 처리하며, twiddle 곱은 각 halfword에 대해 `SMUL*`, `MUL`, `UMAAL`로 수행한다.[^4]

또한 [`mq_GM`](/Users/seungwon/FALCON/fn-dsa_m55/ref/mq.c:2740)은 일반 root가 아니라 `R=2^32 mod q=10952`를 곱한 Montgomery-domain root이다. [`mq_iGM`](/Users/seungwon/FALCON/fn-dsa_m55/ref/mq.c:2849)의 첫 값 `5476=R/2`가 보여 주듯 inverse root에는 단계별 modular `1/2`도 포함되어 있다. 따라서 기존 표를 FP64로 단순 캐스팅해서 쓰면 다른 변환이 된다.

주 파라미터의 butterfly 수는 다음과 같다.

| 파라미터 | n | 층 | forward butterfly | inverse butterfly |
|---|---:|---:|---:|---:|
| FN-DSA-512 | 512 | 9 | 2,304 | 2,304 |
| FN-DSA-1024 | 1,024 | 10 | 5,120 | 5,120 |

각 butterfly에서 상수 twiddle modular multiplication이 한 번씩 필요하므로 이 곱셈과 메모리 배열이 핵심 병목이다.

## 1. Forward NTT를 MVE로 구현하는 방법

### 데이터 표현

공개 함수 ABI는 그대로 `uint16_t *d`로 둔다. 함수 내부에서는 MVE 레지스터 하나에 `int16_t` 계수 8개를 넣는다. modular multiplication과 butterfly 계산 중에는 signed/centered residue를 사용하고, 메모리에 저장하거나 기존 `mqpoly_mul_ntt()` 등에 넘길 때는 `[0,q]` 호환 표현으로 되돌린다.

q=12289는 `2^16/3`보다 작으므로 16-bit MVE Barrett multiplication의 논문 조건을 만족한다. 다만 q가 Kyber의 3329보다 크고 signed 16-bit headroom이 좁으므로, 각 layer group에서 계수 범위를 증명한 뒤 reduction 위치를 정해야 한다.

### butterfly

8개 butterfly를 병렬로 다음과 같이 계산한다.

```text
t  = mulmod(b, w)       // 8 x int16, w는 공개 twiddle
a' = a + t
b' = a - t
```

이는 문헌의 vector CT butterfly와 같다.[^1][^2] `mulmod()`의 1차 후보는 알려진 상수용 3-instruction MVE Barrett이다.

```text
VMUL      z, a, w
VQRDMULH  t, a, w_twist
VMLA      z, t, -q
```

여기서 `w`는 normal-domain centered root이고, `w_twist`는 `round(w*2^16/q)`의 적절한 even approximation으로 미리 계산한다. 이 방식은 한 피연산자가 미리 알려진 twiddle일 때만 적용된다. 논문은 MVE에도 같은 구성이 적용됨을 명시한다.[^2]

2차 후보는 3-instruction rounding Montgomery다. twiddle의 odd representative와 twisted constant를 미리 만들면 `VQRDMULH`, `VMUL`, `VQRDMLAH`로 구성할 수 있다.[^2][^7] M55 NTT 논문은 이 경로를 썼지만, 후속 SLOTHY 연구는 coefficient growth가 더 작은 Barrett을 선택했다.[^8] 따라서 q=12289에서는 둘 다 구현해 측정해야 한다.

Plantard는 제3 후보로만 둔다. q=12289, l=16이면 수정된 Plantard 조건에서 최대 `alpha=1`은 가능하다. 그러나 Plantard의 장점은 16x32-bit 곱을 한 명령으로 처리하는 M4 `SMULW*`에 의존하며, 논문 스스로 NEON 같은 vector ISA 적용이 어렵다고 설명한다.[^9] 후속 논문도 SIMD가 없는 M3/RISC-V를 대상으로 한다.[^10] 그러므로 MVE 주 경로로 선택할 근거가 약하다.

### layer 병합과 메모리 배열

기본은 **2개 radix-2 layer를 하나의 radix-4 kernel로 병합**한다. M55 직접 연구에서는 4개 데이터 Q register와 중간값·preload·late-store용 4개를 사용하며, 3-layer는 spill 때문에 우선 배제했다.[^7]

다만 SLOTHY 후속 연구는 3-layer group에 iteration당 3개 정도의 stack spill을 허용하면, 줄어든 load/store가 spill 비용을 상쇄할 수 있음을 보였다. Kyber MVE에서는 `2+3+2`가 `1+2+2+2`보다 빨랐다.[^8] 이를 FN-DSA에 그대로 단정할 수 없으므로 다음 후보를 측정한다.

- n=512: `2+2+2+3`, `2+3+2+2`, 전부 2-layer 중심 구성
- n=1024: `2+2+2+2+2`, `2+3+3+2`, `2+2+3+3`

forward 후반부처럼 butterfly 거리가 8개 lane보다 작아지는 구간은 일반 load 후 register shuffle을 반복하지 않는다. `VLD2/VLD4` 또는 앞 group의 `VST2/VST4`로 재배열을 메모리 명령에 흡수한다. M55에서는 `VST4`를 penultimate group에 두는 구성이 유리했던 사례가 있다.[^8]

### reduction과 scheduling

각 twiddle product를 signed 범위로 환원하고, group 경계에서 계수를 다시 `[0,q]` 또는 centered 범위로 정규화한다. 정확한 reduction 횟수는 단순 추측이 아니라 각 layer의 최악 bound를 계산하고 exhaustive butterfly test로 확인한다. q가 커서 Kyber 논문의 lazy-reduction 위치를 복사하면 안 된다.

Cortex-M55는 dual-beat, in-order이며 load/store, integer add/sub, integer multiply 파이프가 분리된다. 따라서 `load -> multiply -> add/sub -> store` 종류가 겹치도록 서로 독립인 butterfly와 다음 iteration을 섞는다. `VST; 한 명령; VLD` 형태의 alignment-dependent ST-LD hazard도 피한다.[^7][^8] 먼저 readable symbolic assembly를 만들고, 그 다음 SLOTHY로 register allocation, instruction scheduling, software pipelining을 수행한 뒤 실제 STM32N657에서 재측정한다. SLOTHY는 instruction 선택 자체를 해 주지 않으므로 Barrett/Montgomery와 layer split은 사람이 먼저 결정해야 한다.[^8]

## 2. Inverse NTT를 MVE로 구현하는 방법

### butterfly와 처리 순서

기본 kernel은 forward의 역순으로 GS butterfly 8개를 병렬 처리한다.

```text
s  = a + b
d  = a - b
a' = scale_or_reduce(s)
b' = mulmod(d, w_inverse)
```

초기 inverse layer는 butterfly 간격이 1, 2, 4처럼 작으므로 `VLD4`/`VLD2`로 deinterleave한 뒤 register 안에서 2-layer 또는 3-layer를 처리한다. 뒤쪽 layer는 일반 contiguous vector load/store로 전환한다. 이는 forward의 메모리 변환을 정확히 거꾸로 적용하는 방식이다.[^2][^8]

### inverse scaling: 먼저 두 버전을 둔다

**호환성 기준 버전**은 현재 코드를 그대로 벡터화한다.

- `a' = mq_half(a+b)`를 lane-wise로 구현한다: 홀수이면 q를 더한 뒤 logical shift right 1.
- `b' = mulmod(a-b, iroot_half)`로 구현한다.
- `iroot_half`는 현재 `mq_iGM`을 Montgomery domain에서 해제한 값이며 이미 modular `1/2`를 포함한다.

이 버전은 M4와 단계별 상태까지 대응하므로 첫 KAT 통과용으로 가장 안전하다.

**성능 후보 버전**은 모든 layer에서 raw inverse root를 쓰고, 전체 `n^-1 mod q` normalization을 뒤로 미룬다.

- n=512: `n^-1 mod q = 12265`
- n=1024: `n^-1 mod q = 12277`

마지막 group의 inverse twiddle에 이 scaling을 합치거나, 일부 lane에만 별도 최종 곱을 둔다. inverse scaling을 마지막 butterfly와 합치는 방식은 여러 NTT 연구에서 사용한다.[^2][^7] 다만 GS의 `a+b` 경로가 layer마다 커지므로, 16-bit overflow를 막기 위한 선택적 Barrett reduction이 추가된다. M55 논문도 inverse에서 선택적 reduction이 필요하다고 명시한다.[^7] 즉 “stagewise half 제거로 절약되는 명령”과 “추가 range reduction”을 실제로 비교해야 한다.

inverse layer split은 forward 선택의 역방향 배열을 기본으로 하되 별도로 측정한다. forward 최적 split이 inverse 최적 split이라고 보장되지 않는다.

## 3. Forward NTT를 FP64로 구현하는 방법

### 전제

이 버전은 복소 FFT가 아니다. **모든 값은 여전히 `F_12289`의 정수 residue이고, 저장과 계산 형식만 binary64**이다. 복소 root나 실수 Fourier transform으로 바꾸면 FN-DSA q-NTT와 다른 알고리즘이 된다.

M55의 MVE는 FP16/FP32 vector 연산을 제공하지만 FP64 vector lane은 제공하지 않는다. 따라서 이 버전은 native **scalar FP64**다. 8-lane MVE 정수판과 같은 SIMD 폭을 기대할 수 없다.

### 표와 데이터 변환

함수 입구에서 `uint16_t[n]`을 `double tmp[n]`으로 한 번 변환한다. `q`는 0으로, 나머지는 정확한 정수-valued double로 넣는다. n=512/1024에서 scratch는 4/8 KiB다. 매 butterfly마다 uint16↔double 변환하는 방식은 변환 비용이 `O(n log n)`이 되므로 주 구현에서 제외한다.

forward root 표는 다음처럼 새로 생성한다.

```text
R_inv = 10952^(-1) mod 12289 = 11857
w[i]  = centered((mq_GM[i] * R_inv) mod q)
```

즉 기존 Montgomery root를 normal-domain 정수 root로 복원한 뒤 그 정수를 정확히 double로 저장한다.

### exact FP64 modular reduction

centered reduction을 다음 형태로 구현한다.

```text
reduce_q(z):
    k = round_to_nearest(z * (1.0 / 12289.0))
    return fma(-k, 12289.0, z)
```

`z`, `k`, `q`와 필요한 곱은 이 NTT의 bound에서 `2^53`보다 훨씬 작아 정수로 정확히 표현된다. q가 홀수이므로 정수 `z/q`는 정확한 half-integer가 될 수 없고, nearest-integer 경계와 최소 `1/(2q)`만큼 떨어진다. binary64 reciprocal 오차는 이보다 훨씬 작다. 따라서 range proof와 rounding mode 고정을 전제로 정확한 centered residue를 얻을 수 있다. `fmod()`나 FP division을 매 butterfly에서 부르는 방식은 느리고 생성 코드가 불투명하므로 쓰지 않는다.

FP64 CT butterfly는 다음과 같다.

```text
t  = reduce_q(b * w)
a' = a + t
b' = a - t
```

double의 범위가 넓으므로 add/sub를 매번 환원할 필요는 없다. 10개 layer 동안의 최악 정수 bound를 증명한 뒤, twiddle multiplication 직전과 함수 출력에서만 환원하는 lazy variant도 시험한다. 서로 독립인 butterfly 2~4개를 unroll해 FP multiply/round/FMA와 load/store를 교차 배치한다. 다만 M55에서는 FP add와 FP multiply가 같은 파이프를 사용하므로, MVE 정수판 같은 연산 파이프 중첩은 기대하기 어렵다.[^8]

마지막에 centered double을 `[0,q]` 호환 `uint16_t`로 정확히 변환한다.

## 4. Inverse NTT를 FP64로 구현하는 방법

inverse도 double scratch와 exact modular reduction을 쓰며 GS 순서로 처리한다.

```text
s  = a + b
d  = a - b
a' = s
b' = reduce_q(d * w_inverse)
```

여기서 가장 중요한 점은 마지막 scaling이다. **실수 의미로 `a /= n`을 하면 안 된다.** NTT inverse의 scaling은 `F_q`에서의 `n^-1 mod q` 곱이므로 다음 중 하나여야 한다.

1. 현재 코드와 같은 단계별 modular half:
   `half_q(x) = (x + (x가 홀수이면 q, 아니면 0)) / 2`
2. raw inverse root를 쓴 뒤 마지막에 `reduce_q(x * n_inv_mod_q)`
3. 마지막 inverse twiddle 표에 `n_inv_mod_q`를 미리 합침

FP64 실험의 주 후보는 2 또는 3이다. 단계마다 parity를 검사하고 modular half를 하는 비용을 없앨 수 있기 때문이다. forward와 마찬가지로 `mq_iGM`을 그대로 double로 쓰지 않는다. 단계별 호환판이면 `mq_iGM * R_inv mod q`를 써서 이미 포함된 `1/2`를 보존하고, 최종 scaling판이면 그 값에서 `1/2`를 제거한 raw inverse root 표를 생성한다.

GS의 sum 경로는 환원을 늦추면 최악값이 커지지만 n≤1024에서는 여전히 binary64 exact-integer 범위보다 매우 작다. 그래도 각 kernel의 bound를 문서화하고, 마지막 `n^-1` 곱 전에 정확히 reduce한다.

## 네 구현의 직접 비교

| 구현 | 병렬 폭 | modular multiply | layer 전략 | inverse scaling | 예상 위치 |
|---|---:|---|---|---|---|
| Forward MVE | 8×int16 | Barrett 우선, rounding Montgomery 비교 | 2-layer 기본, 3-layer spill 후보 | 해당 없음 | 최종 성능 후보 |
| Inverse MVE | 8×int16 | 같은 두 reduction 비교 | forward 역배열, 별도 측정 | stagewise half vs 최종 scaling | 최종 성능 후보 |
| Forward FP64 | scalar double | reciprocal+round+FMA exact reduction | 2~4 butterfly software unroll | 해당 없음 | 대조 실험 |
| Inverse FP64 | scalar double | 같은 exact reduction | GS, software unroll | 반드시 modular `n^-1` | 대조 실험 |

## 10편을 종합한 판단

| 논문 | 이 설계에 실제로 주는 근거 |
|---|---|
| Accelerating Falcon on ARMv8 | Falcon q=12289 NTT/iNTT를 vector CT/GS와 layer 병합으로 가속할 수 있다는 직접 근거. FP64는 별도의 complex FFT에 사용.[^1] |
| Neon NTT | 알려진 twiddle용 3-instruction Barrett, rounding Montgomery, CT/GS, 마지막 layer permutation과 inverse scaling 병합의 근거.[^2] |
| TWFalcon | FP32 여러 개로 binary64급 정밀도를 만드는 대상은 서명 FFT/Gaussian 경로이며 q-NTT가 아님. FP 코드는 정확도 증명이 필요함.[^3] |
| Falcon on ARM Cortex-M4: an Update | 현재 `mq_cm4.s`와 같은 packed-16 integer q-NTT, Montgomery reduction, 단계별 iNTT half의 직접 배경.[^4] |
| Falcon Cortex-M7 benchmark | native FP64가 FFT/ffSampling을 크게 개선하지만 verify에는 거의 효과가 없다는 실험적 근거. FP 명령 timing과 conversion도 감사해야 함.[^5] |
| Formal Verification of Emulated FP Arithmetic in Falcon | Falcon FP 정확도 검증이 서명 FFT를 대상으로 하며, 구현 변경은 단순 KAT 외에 range/error 증명이 필요하다는 근거.[^6] |
| Polynomial multiplication on embedded vector architectures | M55 8-register·dual-beat 구조, 2-layer radix-4, VLD4, 3-instruction Montgomery, inverse scaling 병합의 직접 근거.[^7] |
| Fast and Clean / SLOTHY | Barrett의 작은 성장, `2+3+2`와 3-layer spill의 실측, M55 scheduling·software pipelining·ST-LD hazard의 직접 근거.[^8] |
| Improved Plantard Arithmetic | Plantard의 큰 입력 범위와 lazy reduction 장점, 동시에 16x32 곱 때문에 vector ISA 적용이 어렵다는 제한.[^9] |
| Yet another Improvement of Plantard | Plantard 추가 개선이 SIMD 없는 M3/RISC-V에 초점을 둔다는 근거. MVE용 주 reduction 선택 근거는 아님.[^10] |

## 검증 및 측정 기준

네 구현은 같은 API 아래 build-time selector로 분리한다. 최소 검증 순서는 다음과 같다.

1. `logn=2..10`에서 scalar oracle과 forward 출력의 residue 동치 확인.
2. random/adversarial coefficient에 대해 `iNTT(NTT(a)) == a mod q` 확인.
3. FN-DSA-512/1024 KAT가 기존 커밋과 byte-for-byte 일치하는지 확인.
4. Barrett/Montgomery/FP64 butterfly의 허용 입력 전체 또는 증명된 bound 전체 exhaustive test.
5. FP64 rounding mode 고정, compiler의 `fmod`·software helper·data-dependent branch 생성 여부를 disassembly로 확인.
6. STM32N657에서 동일 ITCM/DTCM 배치, clock/cache/compiler option으로 forward, inverse, keygen, sign, verify를 각각 측정.
7. cycles뿐 아니라 code size, stack/scratch, KAT, timing 분산을 함께 기록.

MVE판은 assembly 또는 intrinsics로 readable base를 먼저 만들 수 있다. 최종 peak 성능은 handwritten/symbolic assembly와 SLOTHY가 유리하다. FP64판은 우선 C `double` oracle로 정확성과 생성 코드를 확인한 뒤, 이득이 보일 때만 scalar FP64 assembly scheduling으로 넘어가는 편이 합리적이다.

## Sources

[^1]: Youngbeom Kim, Jingyo Song, Seog Chung Seo, “Accelerating Falcon on ARMv8,” 특히 pp. 4–13. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/ARMv8_falcon.pdf). 2026-09-12 재확인.
[^2]: Hanno Becker et al., “Neon NTT: Faster Dilithium, Kyber, and Saber on Cortex-A72 and Apple M1,” 특히 pp. 11–20 및 Appendix. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/Neon_NTT.pdf). 2026-09-12 재확인.
[^3]: Stef Halmans et al., “TWFalcon: Triple-Word Arithmetic for Falcon Giving Falcon the Precision to Fly Securely,” 특히 pp. 4–22. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/TWfalcon.pdf). 2026-09-12 재확인.
[^4]: Thomas Pornin, “Falcon on ARM Cortex-M4: an Update,” 특히 pp. 9–17. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/falcon_m4.pdf). 2026-09-12 재확인.
[^5]: James Howe, Bas Westerbaan, “Benchmarking and Analysing the NIST PQC Lattice-Based Signature Schemes Standards on the ARM Cortex M7,” 특히 pp. 8, 12–18. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/falcon_m7.pdf). 2026-09-12 재확인.
[^6]: Vincent Hwang, “Formal Verification of Emulated Floating-Point Arithmetic in Falcon,” 특히 pp. 6–15. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/fp64_accuracy.pdf). 2026-09-12 재확인.
[^7]: Hanno Becker et al., “Polynomial multiplication on embedded vector architectures,” 특히 pp. 6–10, 13–21. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/m55_ntt-ftt_opt.pdf). 2026-09-12 재확인.
[^8]: Amin Abdulrahman et al., “Fast and Clean: Auditable high-performance assembly via constraint solving,” 특히 pp. 8–9, 21, 29–36. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/m55_slothy.pdf). 2026-09-12 재확인.
[^9]: Junhao Huang et al., “Improved Plantard Arithmetic for Lattice-based Cryptography,” 특히 pp. 9–20. 이 로컬 판에는 2024/2026 정정 내용도 반영되어 있다. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/plantard.pdf). 2026-09-12 재확인.
[^10]: Junhao Huang et al., “Yet another Improvement of Plantard Arithmetic for Faster Kyber on Low-end 32-bit IoT Devices,” 특히 pp. 4–12. [로컬 PDF](/Users/seungwon/FALCON/REFERENCE/plantard_32bit.pdf). 2026-09-12 재확인.
