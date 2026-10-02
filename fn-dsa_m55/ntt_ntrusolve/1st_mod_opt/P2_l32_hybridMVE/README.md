# P2 original Plantard `l=32` hybrid MVE

상태: **handwritten assembly 구현·검증·측정 완료 (2026-09-15)**

이 후보는 `M1_improve` rounding Montgomery와 original Plantard `l=32`를
레이어별로 비교한 독립 handwritten MVE 구현이다. 활성 코드는
[`kgen_mp31_cm55.s`](kgen_mp31_cm55.s)에 직접 들어 있으며 다른 후보
S 파일을 링크하거나 build option, wrapper, alias, intrinsic으로 선택하지
않는다.

## 논문 근거와 수정한 계획

수학·논문 10편의 전체 검토는
[`ORIGINAL_PLANTARD_L32_RESEARCH.md`](../ORIGINAL_PLANTARD_L32_RESEARCH.md)에
기록했다. `plantard.pdf`에서 original 식과 범위를, M55 NTT/Slothy
논문에서 4×32-bit lane, 8개 vector register, 2-layer와 unit scheduling
제약을 채택했다. 논문 어느 것도 FN-DSA의 31-bit RNS에 이 hybrid를 직접
제시하지 않으므로 이번 결과는 확장 실험이다.

초기 가설은 forward early/middle 및 inverse middle/late의 큰 twiddle
reuse에서 Plantard root 준비가 상쇄될 수 있다는 것이었다. 이를 다음
레이어-family A/B로 확인했다.

1. full: 모든 레이어 Plantard.
2. broad hybrid: forward boundary는 Montgomery, early/middle은 Plantard;
   inverse boundary는 Montgomery, middle/late는 Plantard.
3. final hybrid: maximum-reuse odd singleton만 Plantard, 나머지는
   Montgomery.
4. M1-improve: 모든 레이어 Montgomery.

full→broad에서 boundary Montgomery가 빨랐고, broad→M1에서 남은
early/middle Plantard도 느렸으며, final→M1에서 maximum-reuse singleton도
느렸다. 따라서 실제로 M1보다 이긴 Plantard 레이어 집합은 비어 있다.
다만 “실제로 Plantard를 포함하는 hybrid”의 최소 비용을 남기기 위해 최종
후보는 아래 정책으로 고정했다.

## 최종 레이어 정책

- odd-logn forward의 단일 첫 CT layer: original Plantard.
- odd-logn inverse의 단일 마지막 GS layer: original Plantard.
- 모든 merged 2-layer와 lane-varying boundary layer: M1-improve
  rounding Montgomery.
- even logn: Plantard context도 만들지 않고 전체 M1-improve.
- `logn<4`: 기존 C fallback.

Plantard 부분의 수식은 full 후보와 같다.

```text
b  = Montgomery(root_mont, -R^2 mod p)
bp = b*p^-1 mod R^2
h  = VMULH.U32(a,bp_lo) + VMUL.I32(a,bp_hi)
out = VMULH.U32(h+1,p)
```

inverse Plantard layer만 signed 차이를 `[0,p)`로 canonicalize한다.
Montgomery GS는 M1-improve처럼 signed 차이를 직접 받아 그 추가 보정을
피한다.

## 구현·메모리 정책

- 4×32-bit lane, 8개 vector register 안에서 동작한다.
- Plantard coefficient 경로는 5 vector instructions이며 vector `p`를
  `q6`에 유지한다.
- 기존 32-bit gm/igm를 group 진입 시 on-the-fly로 변환한다.
- 새 root table과 RAM 증가는 0이다.
- NTT/iNTT 직접 cycle은 사용한 Plantard context/root 준비를 포함한다.
- 기존 2-layer, stage-wise inverse halving, gm/igm 표현을 보존한다.
- 3-layer, 새 lazy range, scaling 통합, FP64, Slothy는 넣지 않았다.

## Constant-time와 판단

분기는 공개 `logn`, parity, layer/group/element counter뿐이며 coefficient
기반 주소·loop·분기가 없다. production `logn>=4` assembly에는 함수
call과 division이 없다.

hybrid는 full Plantard보다 keygen 중앙값이 512에서 4.3838%, 1024에서
2.8312% 빠르다. 그러나 M1-improve보다는 각각 0.3406%, 0.2242% 느리다.
따라서 Plantard 후보 중에는 hybrid가 낫지만 최종 제품은 M1-improve를
유지한다. 상세 수치는 [`result.md`](result.md)에 있다.
