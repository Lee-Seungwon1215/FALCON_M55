# K4-B: inverse NTT coefficient-memory pipeline

K4-B는 채택 기준 `ntt_ntrusolve/ref_preslothy`의 K2에서 독립 분기한
inverse-only 후보이다. RNS inverse NTT의 반복 GS2 tile 안에서 coefficient
load/store와 독립 산술을 겹치도록 명령 순서만 재배치했다.

구현은 [`kgen_mp31_cm55.s`](kgen_mp31_cm55.s)에 직접 들어 있으며 다른
후보를 Makefile·링크·빌드 옵션으로 선택하지 않는다.

## 범위

- 변경 함수: `fndsa_mp_iNTT()`의 ordinary two-layer GS2 반복부.
- 영향 크기: `logn=7..10`. `logn=4..6`은 해당 반복부를 지나지 않는다.
- 유지: K2 root pipeline, inverse-root 순서, Montgomery 산술, layer 구성,
  메모리 접근 횟수·주소, branch 구조 및 register 수.
- 완전 제외: forward `fndsa_mp_NTT()`, 공통 q=12289 NTT/iNTT,
  CRT/Bezout, FFT, sampler, Slothy.

## 변경 원리

1. 첫 GS가 먼저 사용하는 `q0`, `q1`을 load한다.
2. 첫 inverse root 준비와 q0/q1 산술 사이에 `q2`, `q3` load를 분산한다.
3. 마지막 q1/q3 Montgomery dependency 사이에 이미 완성된 `q0`, `q2`를
   먼저 store한다.
4. reduction 완료 후 `q1`, `q3`를 store한다.

새 coefficient spill, scratch buffer 또는 상수표는 없다. 세부 설계는
[`IMPLEMENTATION.md`](IMPLEMENTATION.md), 측정 결과는
[`result.md`](result.md)에 있다.

## 재현

```sh
bash profiling/build_m55.sh audit
python3 profiling/m55.py run audit pilot --label k4b_inverse_audit_v1
bash profiling/build_m55.sh perf
python3 profiling/m55.py run perf pilot --label k4b_inverse_perf_v1
python3 profiling/m55.py run perf full --label k4b_inverse_perf_v1
python3 -B profiling/audit_k4b.py
```

