# K4-B 측정 결과

결론: **K4-B는 정확성·KAT·서명검증·정적 상수시간 회귀를 통과했고,
inverse `mp_iNTT()`의 `logn=7..10`을 1.50~2.65% 단축했다.** 전체 키생성
개선은 512에서 0.0226%, 1024에서 0.0172%다. forward NTT는 K2와 같다.

## 조건

- 기준: `ntt_ntrusolve/ref_preslothy` K2.
- 보드: NUCLEO-N657X0-Q, Cortex-M55.
- CPU/SYSCLK/HCLK: 800/400/200 MHz.
- 코드 ITCM, 데이터·상수·스택 DTCM, TCM ECC ON, 동일 Kconfig.
- GCC 15.2.1, `-O3`.
- 커널: 10 batch × 100 call 중앙값, 내부 root 준비 포함.
- 전체 API: 10 warmup, 10 batch × 10 call, upper median.

## 직접 RNS NTT/iNTT 커널

단위 cycles/call. 감소율은 `(K2-K4-B)/K2`이다.

| logn | n | 방향 | K2 | K4-B | 사이클 감소 |
|---:|---:|---|---:|---:|---:|
| 4 | 16 | NTT | 329.82 | 329.82 | 0.0000% |
| 5 | 32 | NTT | 731.82 | 731.82 | 0.0000% |
| 6 | 64 | NTT | 1,539.82 | 1,539.82 | 0.0000% |
| 7 | 128 | NTT | 3,554.82 | 3,554.82 | 0.0000% |
| 8 | 256 | NTT | 7,855.82 | 7,855.82 | 0.0000% |
| 9 | 512 | NTT | 17,616.82 | 17,616.82 | 0.0000% |
| 10 | 1024 | NTT | 38,501.82 | 38,501.82 | 0.0000% |
| 4 | 16 | iNTT | 355.80 | 355.80 | 0.0000% |
| 5 | 32 | iNTT | 748.80 | 748.80 | 0.0000% |
| 6 | 64 | iNTT | 1,528.80 | 1,528.80 | 0.0000% |
| 7 | 128 | iNTT | 3,479.80 | 3,423.80 | **1.6093%** |
| 8 | 256 | iNTT | 7,469.80 | 7,357.80 | **1.4994%** |
| 9 | 512 | iNTT | 16,920.80 | 16,472.80 | **2.6476%** |
| 10 | 1024 | iNTT | 36,342.80 | 35,446.80 | **2.4654%** |

## 전체 FN-DSA API

| degree | API | K2 | K4-B | 사이클 감소 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 46,399,782 | 46,389,310 | **0.0226%** |
| 512 | 서명 | 17,197,899 | 17,197,900 | -0.000006% |
| 512 | 검증 | 323,070 | 323,070 | 0.0000% |
| 1024 | 키생성 | 243,479,951 | 243,438,179 | **0.0172%** |
| 1024 | 서명 | 36,841,897 | 36,841,899 | -0.000005% |
| 1024 | 검증 | 625,018 | 624,964 | +0.0086% |

서명 1~2 cycle과 검증 54 cycle 차이는 K4-B가 실행되지 않는 API의 측정 변동으로
해석한다. 키생성 개선이 커널 개선보다 작은 이유는 RNS iNTT가 전체 NTRU solve의
일부이기 때문이다.

## 정확성·오차·KAT·서명검증

- q=12289 NTT 512/1024: mismatch 0, max modular error 0.
- Montgomery: 308 primes, 18,923,520 cases, mismatch/range error 0.
- RNS NTT/iNTT: 308 primes × `logn=4..10`, 2,156 transforms,
  forward/inverse/roundtrip mismatch 0, max modular error 0.
- KAT digest:
  - 512: `9fd7c627fa100863e8f684339f3eb3835fc55a24066f4dd34aea05d555d8eadd`
  - 1024: `c543754d19ef263221b2316acac8ad5c34502886750fdd5bfffd4f5487c018bb`
- `correctness=PASS`, 정상 서명검증 및 `tamper_rejection=PASS`.
- CFSR/HFSR/AFSR = 0, stack upper bound 9,624 bytes(perf) / 9,832 bytes(audit).

## 정적 상수시간 회귀

[`profiling/results/k4b_static_ct.json`](profiling/results/k4b_static_ct.json): PASS.

- named symbol 502개의 주소·크기 변화 0.
- iNTT mnemonic multiset, branch sequence, memory-address multiset 동일.
- forward `fndsa_mp_NTT()`와 `fndsa_mp_NTT_small()` instruction stream 완전 동일.
- 새 call, divide, FP32/FP64 명령 0.

이는 디스어셈블리 구조 회귀 검사이며 형식적 증명 또는 동적 leakage 검사가 아니다.

## 산출물

- audit log:
  [`pilot-20260916T121445Z/raw.log`](profiling/results/d1-k4b_inverse_audit_v1-audit/runs/pilot-20260916T121445Z/raw.log)
- full performance log:
  [`full-20260916T121541Z/raw.log`](profiling/results/d1-k4b_inverse_perf_v1-perf/runs/full-20260916T121541Z/raw.log)
- audit ELF SHA-256:
  `74e4b5426f6c2a7754eacffa9668b7f605d133a672d44abd24c3896323840117`
- performance ELF SHA-256:
  `e8f60a18183de6f14a094d01acac5311f8f573bba4e2c1d131750fa3b2f7d2cd`
- K4-B source SHA-256:
  `373b7f8fa06aba2ee9c99e8ff922ff4bcaf583b3ef702b252c151941b609288a`

