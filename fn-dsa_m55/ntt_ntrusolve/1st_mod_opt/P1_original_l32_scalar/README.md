# P1 original Plantard `l=32` scalar

상태: **구현·검증·측정 완료 (2026-09-15)**

이 후보는 FN-DSA NTRU solve의 31-bit RNS `mp_NTT()`와 `mp_iNTT()`에서
original unsigned Plantard Algorithm 9를 검증하기 위한 정확성 우선 scalar C
기준점이다. 기준 코드는 `M1_improve`이며 실제 변경은
[`kgen_mp31.c`](kgen_mp31.c)에 직접 들어 있다. `kgen_mp31_cm55.s`는 이
후보의 실행 경로가 아니며 보드 이미지에도 링크하지 않았다.

## 논문 근거와 재검토 결과

10개 PDF 전체 검토표와 수학 검증은
[`ORIGINAL_PLANTARD_L32_RESEARCH.md`](../ORIGINAL_PLANTARD_L32_RESEARCH.md)에
있다. 직접 사용한 근거는 `plantard.pdf`의 original Plantard Algorithm 9와
범위 `p < 2^l/phi`다. 논문 구현 자체는 16-bit modulus 대상이며, FN-DSA
31-bit RNS에 `l=32`로 적용한 부분은 이번 연구의 확장이다.

재검토 결과 기존의 improved Plantard `l=32` 계획은 폐기했다. corrected
improved 식은 `alpha>0` 및 `p < 2^(l-alpha-1)`을 요구하므로 31-bit
prime에 `l=32`로 쓸 수 없다. original 식은 모든 308개 prime에서 다음
정수 동치식으로 조건을 만족한다.

```text
p < 2^32/phi  <=>  p^2 + p*2^32 < 2^64
smallest p = 2,140,653,569
largest  p = 2,147,473,409
```

## 수식과 표현 범위

`R=2^32`, `R2=2^64`, `pinv=p^-1 mod R2`다. 공유 `gm/igm` 테이블은
기존 의미인 `root_mont=w*R mod p`를 그대로 유지한다. root를 사용하는
butterfly group마다 다음 상수를 on-the-fly로 만든다.

```text
b  = Montgomery(root_mont, -R2 mod p) = -w*R2 mod p
bp = b*pinv mod R2
z  = a*bp mod R2
h  = high32(z) + 1
raw = high32(h*p)                    # [0,p]
out = raw mod p                      # canonical [0,p)
```

입력 `a`는 unsigned `[0,p)`다. 논문이 허용하는 `raw=p`의 중복 zero는
branchless subtraction으로 0에 맞춘다. inverse GS 차이는 Plantard 호출
전에 `[0,p)`로 canonicalize한다. `igm`에는 기존 stage별 1/2 scaling이
이미 들어 있으므로 iNTT final scaling은 바꾸지 않았다.

## 구현 선택

- per-prime context: 64-bit Newton lift로 `pinv`를 만들고 32회 고정 modular
  doubling으로 `-R2 mod p`를 계산한다.
- root: 기존 32-bit Montgomery table을 손대지 않고 group 진입 시 `bp`로
  변환한다.
- 별도 64-bit root table은 만들지 않았다. logn=10에서 gm/igm 양방향
  8,192 B 증가와 공유 table 의미 변경을 피하기 위해서다.
- NTT의 기존 2-layer CT 구조와 iNTT의 2-layer GS 및 stage별 halving을
  유지했다.
- q=12289 NTT, FFT, sampler, CRT, Bezout은 수정하지 않았다.
- 3-layer merge, 새 lazy range, final scaling 통합, FP64, Slothy를 섞지
  않았다.

보드 직접 transform cycle은 `mp_NTT()`/`mp_iNTT()` 안의 context/root 준비
비용을 포함한다. 공통 `mp_mkgmigm()`은 함수 밖이므로 이 수치에는 빠지지만
전체 keygen 측정에는 포함된다. 배포 경로에 없는 precomputed-`bp` 전용
kernel은 만들지 않았다.

## Constant-time 구조

- coefficient 보정은 마스크 연산이며 secret-dependent branch가 없다.
- coefficient는 주소 계산에 사용되지 않는다.
- 반복 횟수와 root/coefficient 주소는 공개 `logn`과 고정 loop index에만
  의존한다.
- 생산 ELF의 `fndsa_mp_NTT`/`fndsa_mp_iNTT` disassembly에 `UDIV`, `SDIV`,
  함수 호출이 없었다.

이는 정적 구조 감사 결과이며 TVLA나 형식 검증을 뜻하지 않는다.

## 제한과 판단

정확성은 완전히 보존됐지만 scalar `l=32`는 M1-improve MVE보다 keygen
중앙값이 512에서 19.2709%, 1024에서 12.2498% 느리다. 이 후보는 수식과
범위 검증용 기준으로 보존하며 최종 성능 구현으로 채택하지 않는다. 전체
수치와 로그는 [`result.md`](result.md)에 있다.
