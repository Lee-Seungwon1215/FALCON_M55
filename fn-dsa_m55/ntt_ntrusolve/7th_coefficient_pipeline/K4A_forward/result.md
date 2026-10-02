# K4-A 측정 결과

결론: **K4-A는 정확성·KAT·서명검증·정적 상수시간 회귀를 모두 통과했고,
forward `mp_NTT()` 커널의 `logn=6..10`을 1.80~3.99% 단축했다.** 전체
키생성 개선은 512에서 0.0607%, 1024에서 0.0367%로 작다. inverse NTT와
서명·검증은 최적화 대상이 아니다.

## 비교 기준과 조건

- 기준: `ntt_ntrusolve/ref_preslothy`, K2 root pipeline 채택본.
- 후보: 이 폴더의 K4-A. 암호 소스 차이는 `kgen_mp31_cm55.s` 하나.
- 보드: NUCLEO-N657X0-Q, Cortex-M55.
- 클럭: CPU/SYSCLK/HCLK = 800/400/200 MHz.
- 코드/데이터/스택: ITCM/DTCM, TCM ECC ON, 동일 Kconfig.
- 컴파일러: Arm GNU GCC 15.2.1, `-O3`.
- 커널: 10 batch × 100 call, 중앙값. root/twist 준비 포함.
- 전체 API: 10 warmup, 10 batch × 10 call, upper median.

## 직접 RNS NTT 커널

단위 cycles/call. 감소율은 `(K2-K4-A)/K2`이다.

| logn | n | 방향 | K2 | K4-A | 사이클 감소 |
|---:|---:|---|---:|---:|---:|
| 4 | 16 | NTT | 329.82 | 329.82 | 0.0000% |
| 5 | 32 | NTT | 731.82 | 731.82 | 0.0000% |
| 6 | 64 | NTT | 1,539.82 | 1,507.82 | **2.0782%** |
| 7 | 128 | NTT | 3,554.82 | 3,490.82 | **1.8004%** |
| 8 | 256 | NTT | 7,855.82 | 7,599.82 | **3.2587%** |
| 9 | 512 | NTT | 17,616.82 | 17,104.82 | **2.9063%** |
| 10 | 1024 | NTT | 38,501.82 | 36,965.82 | **3.9894%** |
| 4 | 16 | iNTT | 355.80 | 355.80 | 0.0000% |
| 5 | 32 | iNTT | 748.80 | 748.80 | 0.0000% |
| 6 | 64 | iNTT | 1,528.80 | 1,528.80 | 0.0000% |
| 7 | 128 | iNTT | 3,479.80 | 3,479.80 | 0.0000% |
| 8 | 256 | iNTT | 7,469.80 | 7,469.80 | 0.0000% |
| 9 | 512 | iNTT | 16,920.80 | 16,920.80 | 0.0000% |
| 10 | 1024 | iNTT | 36,342.80 | 36,342.80 | 0.0000% |

`logn=4/5`는 K4-A macro가 실행되는 ordinary CT2 반복부가 없어 동일하다.
모든 iNTT 값이 동일한 것은 inverse instruction stream을 건드리지 않았다는
측정상 교차 확인이기도 하다.

## 전체 FN-DSA API

단위 cycles/call.

| degree | API | K2 | K4-A | 사이클 감소 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 46,399,782 | 46,371,621 | **0.0607%** |
| 512 | 서명 | 17,197,899 | 17,197,899 | 0.0000% |
| 512 | 검증 | 323,070 | 323,070 | 0.0000% |
| 1024 | 키생성 | 243,479,951 | 243,390,689 | **0.0367%** |
| 1024 | 서명 | 36,841,897 | 36,841,898 | -0.000003% |
| 1024 | 검증 | 625,018 | 624,964 | +0.0086% |

서명 1 cycle 차이와 검증 54 cycle 차이는 K4-A가 실행되지 않는 API에서 나온
측정 변동이다. K4-A 효과로 해석하지 않는다. 키생성의 개선폭이 커널보다 작은
이유는 RNS forward NTT가 전체 NTRU solve 및 전체 키생성의 일부이기 때문이다.

## 정확성·오차·KAT·서명검증

- q=12289 NTT: 512/1024 forward 및 roundtrip mismatch 0,
  oracle mismatch 0, max modular error 0.
- RNS Montgomery: 308 primes, 18,923,520 cases, mismatch/range error 0.
- RNS NTT/iNTT: 308 primes × `logn=4..10` = 2,156 transforms,
  forward/inverse/roundtrip mismatch 0, max modular error 0.
- deterministic KAT digest:
  - 512: `9fd7c627fa100863e8f684339f3eb3835fc55a24066f4dd34aea05d555d8eadd`
  - 1024: `c543754d19ef263221b2316acac8ad5c34502886750fdd5bfffd4f5487c018bb`
- 전체 `correctness=PASS`, 정상 서명검증 및 변조 거부
  `tamper_rejection=PASS`.
- CFSR/HFSR/AFSR = 0, stack upper bound 9,624 bytes(perf) / 9,888 bytes(audit).

## 정적 상수시간 회귀

[`profiling/results/k4a_static_ct.json`](profiling/results/k4a_static_ct.json)은 PASS다.

- K2와 K4-A의 전체 named symbol 502개 주소·크기가 동일하다.
- forward 두 symbol의 mnemonic multiset, branch sequence, memory-address
  multiset이 동일하다.
- `fndsa_mp_iNTT()` 418개 instruction stream은 완전히 동일하다.
- 새 call, divide, FP32/FP64 명령은 0개다.

이는 디스어셈블리 구조 회귀 검사이며 형식적 증명이나 동적 leakage 검사는 아니다.

## 산출물

- audit raw log:
  [`pilot-20260916T115027Z/raw.log`](profiling/results/d1-k4a_forward_audit_v1-audit/runs/pilot-20260916T115027Z/raw.log)
- full performance raw log:
  [`full-20260916T115312Z/raw.log`](profiling/results/d1-k4a_forward_perf_v1-perf/runs/full-20260916T115312Z/raw.log)
- audit ELF SHA-256:
  `c00b5a5e0098ee34118b9a47a0d32f277adf4659e5da2a98df16d83aed0e03d4`
- performance ELF SHA-256:
  `463e17a331497c27c10f9d51cb84c811086bfe16e5a9a039fcf5703d69302171`
- K4-A source SHA-256:
  `9218bb42139b07f53628476d6b52982f7c3521e7a0a36424bf4602d75f092972`

