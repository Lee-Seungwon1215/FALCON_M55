# Original Plantard l=32 적용 근거와 확정 계획

검토일: 2026-09-15

## 결론

FN-DSA NTRU solve의 308개 31-bit RNS prime은 original Plantard의
`p < 2^32/phi` 조건을 모두 만족한다. 가장 큰 prime은 2,147,473,409이고,
가장 작은 prime은 2,140,653,569이다. 부동소수점 없이 다음 동치 조건으로
전부 확인했다.

```text
p < 2^32/phi  <=>  p^2 + p*2^32 < 2^64
```

독립 모델
[`verify_original_plantard_l32.py`](verify_original_plantard_l32.py)는 308개
prime, forward/inverse root 각각 1024개, 경계·무작위 reduction
10,723,328건과 `logn=4..10` 전체 NTT/iNTT 2,156쌍을 검사했고 Montgomery
기준과의 mismatch는 0이었다.

이 적용은 논문에 실린 FN-DSA 31-bit 구현을 재사용하는 것이 아니다.
original Plantard의 일반 정리를 FN-DSA의 31-bit RNS NTT에 확장 적용하고,
Cortex-M55 MVE로 새로 구현하는 연구다.

## 논문 10편 재검토 결과

| 자료 | 실제로 채택한 내용 | 이번 단계에서 채택하지 않은 내용과 이유 |
|---|---|---|
| `plantard.pdf` | Algorithm 9 original Plantard 수식·범위·`p < 2^l/phi`; constant operand의 `b*p^-1 mod 2^(2l)` 사전 계산; Plantard-domain root | Algorithm 10 improved Plantard는 `alpha>0`, `p<2^(l-alpha-1)`라서 FN-DSA 31-bit prime에 `l=32`로 적용 불가. 논문의 고속 구현은 16-bit Kyber/NTTRU용이다. |
| `plantard_32bit.pdf` | constant-time 명령 선택과 multiply decomposition을 검토할 때의 주의점 | 제목의 32-bit는 32-bit MCU를 뜻하고 modulus는 Kyber의 16-bit다. 논문도 32-bit modulus에서 32x64가 여러 명령이면 이득이 사라진다고 명시하므로 직접 성능 근거로 쓰지 않는다. |
| `m55_ntt-ftt_opt.pdf` | M55의 4x32-bit MVE lane, 8개 vector register 제한, 2-layer CT/GS 구조, load/add/multiply unit 배치, TCM 조건 | 논문의 rounding Montgomery/Barrett은 Plantard 수식이 아니다. Barrett의 modulus 조건도 FN-DSA prime에 맞지 않는다. 3-layer 및 lazy reduction은 이번 비교에서 제외한다. |
| `m55_slothy.pdf` | M55가 dual-beat·single-issue이고 load/store·integer·multiply unit 균형이 중요함; VST-then-VLD 충돌 회피 | SLOTHY는 정해진 명령의 scheduling/register allocation 도구이지 reduction 설계 도구가 아니다. Plantard 후보가 정해진 후의 후속 단계로 남긴다. 논문의 “Plantard 비벡터화”는 16-bit improved Plantard의 `smulw` 경로에 대한 결과라 original l=32의 불가능 증명은 아니다. |
| `Neon_NTT.pdf` | multiply/add/load interleave와 layer batching의 일반 데이터 흐름 | 32개 Neon register 및 AArch64 명령을 8-register MVE에 직접 이식하지 않는다. 3-instruction Barrett은 `N<R/3`가 필요해 FN-DSA prime에 부적합하다. |
| `ARMv8_falcon.pdf` | q=12289 NTT의 2-layer 병합과 SIMD 데이터 재배열 원칙 | 대상은 Falcon 검증용 q=12289 NTT와 AArch64 NEON이다. NTRU solve의 가변 31-bit RNS NTT에 대한 직접 근거가 아니며 Plantard도 아니다. |
| `falcon_m4.pdf` | FN-DSA keygen의 31-bit prime/Montgomery 도메인, 고정 시간 구현 규칙, 작은 코드·고정 주소 접근 원칙 | M4의 31-bit Montgomery assembly를 기준 의미론으로만 사용한다. Plantard나 MVE 구현 결과는 없다. |
| `falcon_m7.pdf` | native FP64의 적용 범위와 플랫폼별 constant-time 실측 필요성 | FP64 가속은 FFT/ffSampling 대상이다. 정수 RNS NTT reduction을 FP64로 바꾸는 근거가 아니며 이번 단계에서 제외한다. |
| `TWfalcon.pdf` | KAT, sign/verify, 오차 측정, constant-time assembly 검토의 검증 방법론 | two-word floating point는 서명 FFT/sampler용이다. 31-bit modular NTT의 Plantard 기법으로 사용하지 않는다. |
| `fp64_accuracy.pdf` | 최적화 assembly와 독립 고수준 모델의 등가성·범위 검증 필요성 | 검증 대상은 emulated FP64와 FFT다. 이번 정수 reduction의 직접 알고리즘 근거는 아니다. |

## 확정한 수식과 표현 영역

`R=2^32`, `R2=2^64`, `pinv=p^-1 mod R2`로 둔다. 기존 root table은
다른 NTRU 코드와 공유되므로 그대로 `root_mont=w*R mod p`를 유지한다.
root 하나를 사용할 때 다음 64-bit 상수를 준비한다.

```text
b  = -w*R2 mod p
   = Montgomery(root_mont, -R2 mod p)
bp = b*pinv mod R2
```

original Plantard constant multiplication은 다음과 같다.

```text
z   = a*bp mod R2
h   = floor(z/R)
raw = floor((h+1)*p/R)       # 0 <= raw <= p
out = 0 if raw == p else raw # canonical [0,p)
```

따라서 `out = a*w mod p`이고 기존
`Montgomery(a, root_mont)`와 bit-exact하게 같다. 논문이 허용하는 두 번째
zero 표현 `p`는 FN-DSA의 `[0,p)` 계약에 맞춰 0으로 정규화한다.

inverse `igm` root에는 이미 각 stage의 1/2 scaling이 포함되어 있다. 같은
변환을 `igm`에도 적용하면 기존 stage-wise halving과 최종 결과가 그대로
보존되므로 별도 final scaling 변경은 하지 않는다.

## MVE lane 수식

`bp = bp_lo + bp_hi*R`일 때 네 개 32-bit lane에서 필요한 값은 다음과
같이 정확히 구성할 수 있다.

```text
h = VMULH.U32(a,bp_lo) + VMUL.U32(a,bp_hi) mod R
h = h + 1 mod R
r = VMULH.U32(h,p)
```

`h=R-1`이면 수학적 `raw=p`지만 lane의 `h+1`은 0으로 wrap되고 결과도
0이 된다. 이는 바로 FN-DSA가 요구하는 canonical zero이므로 별도 branch가
필요 없다. 일반 lane은 exact `[0,p)` 결과다.

original Plantard는 unsigned 입력만 허용한다. forward 입력은 항상
`[0,p)`이고, inverse GS의 차이는 Plantard 전에 `MP31_SUB`로 canonicalize한다.
M1-improve의 signed-difference 생략은 Plantard layer에는 사용할 수 없다.

## 논문 재검토로 수정한 계획

1. `improved l=32`가 아니라 **original l=32**만 구현한다. improved의
   수정된 `alpha>0` 조건은 31-bit prime과 양립하지 않는다.
2. 기존 32-bit `gm/igm`를 64-bit로 확장하면 logn=10에서 transform당
   방향별 4,096 B가 추가된다. 두 방향 동시 보유 시 8,192 B 증가하며,
   공유 table 의미도 바뀐다. 이번 실험에서는 table을 확대하지 않고 root가
   butterfly group에 들어올 때 on-the-fly로 `bp`를 준비한다.
3. 준비 비용은 숨기지 않고 end-to-end와 `mp_NTT()`/`mp_iNTT()` 직접
   측정에 포함한다. 감사용 multiply probe는 산술의 bit-exact 검증에만
   사용한다. 준비된 `bp`만 받는 별도 성능 entry point는 배포 경로에 없는
   인위적 인터페이스이므로 만들지 않는다. 따라서 보고하는 transform
   cycle에는 후보가 실제로 부담하는 per-prime context와 on-the-fly root
   변환이 모두 포함된다. 공통 `gm/igm` 테이블 생성은 모든 후보에서 함수
   호출 전 수행되므로 직접 transform cycle에서는 제외되며, 전체 keygen
   cycle에는 포함된다.
4. full MVE는 `logn>=4`의 모든 multiplication을 Plantard로 바꾸되 기존
   2-layer 구조를 유지한다. 8개 vector register 안에서 coefficient q0..q3,
   root-low/root-high q4/q5, scratch q6/q7로 제한한다.
5. hybrid는 먼저 full/rounding Montgomery의 layer별 실측을 얻은 뒤
   Plantard가 실제로 이긴 layer에만 적용한다. 결과를 보고 선택하며 가설을
   결과로 둔갑시키지 않는다.
6. 3-layer, 새 lazy reduction, iNTT scaling 통합, FP64, SLOTHY는 이
   비교가 끝날 때까지 섞지 않는다.

## Constant-time 계약

- loop 횟수와 root/coefficient 주소는 public `logn`과 loop index에만 의존
- coefficient 값에 따른 branch·주소·loop 없음
- division instruction 없음
- canonicalization은 mask 또는 Plantard의 자연스러운 unsigned wrap 사용
- 실제 M55 object의 disassembly를 별도로 검사

수학 모델 통과는 assembly 정확성의 대체가 아니다. 각 후보는 실제 M55
probe, 전 prime NTT/iNTT, KAT, sign/verify와 변조 거부를 다시 통과해야 한다.
