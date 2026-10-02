# P2 original Plantard `l=32` full MVE

상태: **handwritten assembly 구현·검증·측정 완료 (2026-09-15)**

이 후보는 `M1_improve`를 기준으로 NTRU solve의 31-bit RNS
`mp_NTT()`와 `mp_iNTT()`에서 `logn>=4`의 모든 modular twiddle
multiplication을 original Plantard `l=32`로 바꾼 full-MVE 실험이다.
활성 구현 전체는
[`kgen_mp31_cm55.s`](kgen_mp31_cm55.s)에 handwritten assembly로 직접
작성돼 있다. C intrinsic, inline assembly, wrapper, alias, 외부 후보 링크,
빌드 옵션에 의한 구현 선택은 사용하지 않았다.

## 근거와 수식

논문 10편의 채택/제외 근거와 범위 증명은
[`ORIGINAL_PLANTARD_L32_RESEARCH.md`](../ORIGINAL_PLANTARD_L32_RESEARCH.md)에
있다. original Plantard Algorithm 9의 조건 `p<2^32/phi`는 FN-DSA
308개 prime 모두가 만족한다. 논문의 실제 고속 코드는 16-bit modulus
대상이므로 31-bit RNS와 MVE 구현은 이번 연구의 확장이다.

`R=2^32`이고 기존 `root_mont=wR mod p`를 group마다 다음처럼 바꾼다.

```text
b  = Montgomery(root_mont, -R^2 mod p) = -wR^2 mod p
bp = b*p^-1 mod R^2
h  = high32(low64(a*bp))
out = high32((h+1)*p)                 # canonical [0,p)
```

inverse GS의 signed 차이는 original Plantard의 unsigned 입력 계약 때문에
먼저 `[0,p)`로 canonicalize한다. `igm`의 stage-wise 1/2 scaling은
그대로이며 final scaling을 합치지 않았다.

## MVE 구성

MVE의 128-bit register 하나가 네 개 32-bit coefficient를 처리한다.
`bp=bp_lo+bp_hi*R`에 대해 coefficient kernel은 정확히 다음 다섯 vector
instructions다.

```asm
VMUL.I32   tmp,  data, bp_hi
VMULH.U32  data, data, bp_lo
VADD.I32   data, data, tmp
VADD.I32   data, data, #1
VMULH.U32  data, data, p
```

`VMULH.U32`를 쓰는 이유는 original 식의 입력과 64-bit product가 unsigned
이기 때문이다. signed high multiply로 바꾸면 상위 bit가 선 값에서 식이
달라진다. root-domain 변환만 M1의 signed
`VQRDMULH.S32` rounding-Montgomery sequence를 사용한다.

8개 vector register는 coefficient `q0..q3`, `bp_lo/bp_hi`
`q4/q5`, vector `p`와 scratch `q6/q7`로 제한했다. 공개 per-prime
context 네 word와 상태를 위한 24-byte local frame을 쓰며 coefficient
spill은 추가하지 않았다. 기존 2-layer CT/GS, `VLD4/VST4` boundary
layout과 load/store 순서를 유지했다.

## root 준비와 fallback

- 기존 32-bit gm/igm table을 보존하고 root마다 `bp`를 on-the-fly로
  만든다. 64-bit table 확장 8,192 B는 추가하지 않았다.
- 직접 NTT/iNTT cycle에는 per-prime context 및 root 변환 비용이 포함된다.
  공통 gm/igm table 생성은 함수 호출 밖이지만 전체 keygen에는 포함된다.
- `logn<4`만 기존 C 경로로 넘어간다. production disassembly는 함수 첫
  공개-`logn` branch 외에 C 호출이 없으며 `logn>=4`는 전부 S 파일에서
  끝난다.
- 3-layer merge, 새 lazy 범위, iNTT scaling 통합, FP64, Slothy, 새 대형
  table은 포함하지 않았다.

## Constant-time 구조

coefficient 값은 branch, 주소 또는 loop 횟수에 쓰이지 않는다. `VPT`
predication과 unsigned wrap으로 보정한다. 분기와 root/coefficient 주소는
공개 `logn`, parity, layer/group/element index뿐이다. 최종 disassembly의
NTT/iNTT에는 division과 함수 call이 없다. 상세 수치와 성능은
[`result.md`](result.md)에 있다.

## 판단

모든 정확성 검사를 통과했지만 M1-improve보다 keygen 중앙값이 512에서
4.9410%, 1024에서 3.1445% 느리다. root 준비와 5-instruction coefficient
kernel이 M1의 짧은 rounding-Montgomery보다 비싸므로 최종 채택하지 않는다.
