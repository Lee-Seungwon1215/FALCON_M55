# K4-A: forward NTT coefficient-memory pipeline

K4-A는 채택 기준인 `ntt_ntrusolve/ref_preslothy`의 K2 구현에서 출발해,
RNS forward NTT의 반복 CT2 tile 안에서 **계수 load/store와 독립 산술을 겹치도록
명령 순서만 재배치**한 독립 후보다. 구현은
[`kgen_mp31_cm55.s`](kgen_mp31_cm55.s)에 직접 들어 있으며, 다른 후보를
Makefile·링크·빌드 옵션으로 끌어오지 않는다.

## 범위

- 변경 함수: `fndsa_mp_NTT()`와 내부 small dispatcher
  `fndsa_mp_NTT_small()`의 ordinary two-layer CT2 반복부.
- 변경 크기: `logn=6..10`의 해당 반복부. `logn=4/5`는 이 반복부를
  지나지 않으므로 K2와 같다.
- 유지: root-preparation K2, Montgomery 산술, layer 구성, 변환 순서,
  메모리 접근 횟수·주소, branch 구조, register 수.
- 완전 제외: `fndsa_mp_iNTT()`, 공통 q=12289 NTT/iNTT, CRT/Bezout,
  FFT, sampler, Slothy.

## 핵심 변경

기존 K2 tile은 네 coefficient vector를 연속 load한 뒤 계산하고 마지막에
네 vector를 연속 store한다. K4-A는 다음처럼 배치한다.

1. `q0`, `q2`를 먼저 load하고 첫 root를 준비한다.
2. root 준비 및 첫 Montgomery dependency 사이에 `q1`, `q3` load를 넣는다.
3. 최종값이 확정된 `q0`, `q1` store를 마지막 `q3` Montgomery dependency
   사이에 넣는다.
4. 마지막 butterfly 후 `q2`, `q3`를 store한다.

두 tile의 coefficient를 동시에 들고 가는 방식은 MVE의 Q register 8개를
넘기므로 사용하지 않았다. 새 spill·scratch buffer·상수표도 없다.

## 재현

```sh
bash profiling/build_m55.sh audit
python3 profiling/m55.py run audit pilot --label k4a_forward_audit_v1
bash profiling/build_m55.sh perf
python3 profiling/m55.py run perf full --label k4a_forward_perf_v1
python3 -B profiling/audit_k4a.py
```

보드 접근 명령은 연결된 NUCLEO-N657X0-Q가 필요하다. 구체적인 속도,
정확성, KAT, 서명검증 및 정적 상수시간 회귀 결과는
[`result.md`](result.md)에 있다. 설계와 안전성 검토는
[`IMPLEMENTATION.md`](IMPLEMENTATION.md)에 정리했다.

