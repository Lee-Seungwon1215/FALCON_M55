# K4-C: forward + inverse coefficient-memory pipeline

K4-C는 채택 기준 `ntt_ntrusolve/ref_preslothy`의 K2에 두 독립 후보를
소스 수준에서 직접 합친 결합 후보다.

- K4-A: forward `mp_NTT()`와 `mp_NTT_small()` ordinary CT2 tile의
  staggered load/early store.
- K4-B: inverse `mp_iNTT()` ordinary GS2 tile의 staggered load/early store.

구현은 [`kgen_mp31_cm55.s`](kgen_mp31_cm55.s)에 직접 들어 있다. Makefile,
링크 또는 빌드 옵션으로 K4-A/K4-B 소스를 선택하지 않는다. 두 독립 폴더는
ablation 결과를 보존하기 위해 그대로 둔다.

## 변경 범위

- forward: `logn=6..10`의 ordinary CT2 반복부.
- inverse: `logn=7..10`의 ordinary GS2 반복부.
- 미변경: Montgomery 산술, root preparation, layer 구성, transpose 경계,
  공개 loop/branch 구조, 메모리 접근 주소와 횟수, q=12289 NTT, CRT/Bezout,
  FFT, sampler와 Slothy.

## 재현

```sh
bash profiling/build_m55.sh audit
python3 profiling/m55.py run audit pilot --label k4c_combined_audit_v1
python3 profiling/audit_k4c.py
bash profiling/build_m55.sh perf
python3 profiling/m55.py run perf pilot --label k4c_combined_perf_v1
python3 profiling/m55.py run perf full --label k4c_combined_perf_v1
```

측정값과 검증 범위는 [`result.md`](result.md), 구현 원리는
[`IMPLEMENTATION.md`](IMPLEMENTATION.md)에 정리했다.
