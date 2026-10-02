# K4-C 측정 결과

결론: **K4-C는 K4-A의 forward 이득과 K4-B의 inverse 이득을 손실 없이
한 소스에 결합했다.** K2 대비 전체 키생성은 512에서 **0.083259%**,
1024에서 **0.053728%** 빨라졌다. 정확성·오차·KAT·서명검증·변조 거부와
정적 상수시간 회귀 검사는 모두 PASS다.

## 조건

- 기준: `ntt_ntrusolve/ref_preslothy` K2.
- 보드: NUCLEO-N657X0-Q, Cortex-M55 r1p1.
- CPU/SYSCLK/HCLK: 800/400/200 MHz.
- 코드 ITCM, 데이터·상수·스택 DTCM, 각 256 KiB, I/D cache OFF, TCM ECC ON.
- Arm GNU GCC 15.2.1, `-O3`, MVE MP31 ON, 동일 Kconfig와 결정적 입력.
- 커널: 방향·logn별 10 batch × 100 call, root/twist 준비 포함.
- 전체 API: batch당 warm-up 10회, 10 batch × 10 call = 100회,
  batch 평균 10개의 upper median.

## 직접 RNS NTT/iNTT 커널

단위 cycles/call. 감소율은 `(K2-K4-C)/K2`이다.

| logn | n | NTT K2 → K4-C | NTT 감소 | iNTT K2 → K4-C | iNTT 감소 |
|---:|---:|---:|---:|---:|---:|
| 4 | 16 | 329.82 → 329.82 | 0.0000% | 355.80 → 355.80 | 0.0000% |
| 5 | 32 | 731.82 → 731.82 | 0.0000% | 748.80 → 748.80 | 0.0000% |
| 6 | 64 | 1,539.82 → 1,507.82 | **2.0782%** | 1,528.80 → 1,528.80 | 0.0000% |
| 7 | 128 | 3,554.82 → 3,490.82 | **1.8004%** | 3,479.80 → 3,423.80 | **1.6093%** |
| 8 | 256 | 7,855.82 → 7,599.82 | **3.2587%** | 7,469.80 → 7,357.80 | **1.4994%** |
| 9 | 512 | 17,616.82 → 17,104.82 | **2.9063%** | 16,920.80 → 16,472.80 | **2.6476%** |
| 10 | 1024 | 38,501.82 → 36,965.82 | **3.9894%** | 36,342.80 → 35,446.80 | **2.4654%** |

K4-C의 forward instruction stream과 사이클은 K4-A와 같고 inverse는 K4-B와
같다. 따라서 두 최적화를 결합하면서 커널 수준의 상호 간섭은 발생하지 않았다.

## 전체 FN-DSA API

단위 cycles/call. 양수는 빨라짐이다.

| degree | API | K2 | K4-C | 개선율 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 46,399,782 | 46,361,150 | **+0.083259%** |
| 512 | 서명 | 17,197,899 | 17,197,899 | 0.000000% |
| 512 | 검증 | 323,070 | 323,130 | −0.018572% |
| 1024 | 키생성 | 243,479,951 | 243,349,133 | **+0.053728%** |
| 1024 | 서명 | 36,841,897 | 36,841,898 | −0.000003% |
| 1024 | 검증 | 625,018 | 624,961 | +0.009120% |

512 키생성의 결합 감소 38,632 cycles는 K4-A와 K4-B 독립 감소량의 합
38,633 cycles와 1 cycle 차이다. 1024는 130,818 대 131,034 cycles로
216 cycles 차이다. 반복 전체의 변동 범위 안에서 거의 가산적이다.
서명·검증은 RNS NTT/iNTT를 호출하지 않으므로 표의 미세한 증감은 K4-C 효과가
아니라 측정 변동으로 해석한다.

## 정확성·오차·KAT·서명검증

- q=12289 NTT 512/1024: forward/roundtrip/oracle mismatch 0,
  max modular error 0.
- rounding Montgomery: 308개 소수, 18,923,520 lane case,
  mismatch/range error 0.
- RNS NTT/iNTT: 308개 소수 × `logn=4..10` = 2,156 transforms,
  forward/inverse/roundtrip mismatch 0, max modular error 0.
- KAT digest: 512 `9fd7c627…eadd`, 1024 `c543754d…18bb`, K2와 동일.
- `correctness=PASS`, 정상 서명검증 및 `tamper_rejection=PASS`.
- 보드 exit 0, CFSR/HFSR/AFSR 0, TCM ECC 유지.

## 정적 상수시간 회귀

[`profiling/results/k4c_static_ct.json`](profiling/results/k4c_static_ct.json): PASS.

- K2/K4-A/K4-B/K4-C의 named symbol 주소·크기 동일.
- K4-C forward 두 함수의 instruction row가 K4-A와 정확히 동일.
- K4-C inverse 함수의 instruction row가 K4-B와 정확히 동일.
- K2 대비 mnemonic multiset, branch sequence와 memory-address multiset 동일.
- 새 call, divide, FP32/FP64 명령 0.

이는 디스어셈블리 구조 회귀이며 형식적 상수시간 증명 또는 동적 leakage 검사가
아니다.

## 메모리와 식별자

- perf: 코드 109,292 B, DTCM 225,728 B.
- audit: 코드 115,104 B, DTCM 234,304 B.
- 추가 배열·stack frame·코드 크기 증가 없음(K2와 동일 명령 multiset/layout).
- source SHA-256: `bad74cbe6f569a948b70f887b47cc0c5fc9f7e6130605df27adb70f3d88ece88`.
- perf ELF: `1edb21237e56e1e4e9e2dc9d83bc6481edbf9644073fb5daa49d3642439e68ab`.
- audit ELF: `c7d10d096902e9791dee5f3085e20f5b4b588785f3625bc7ce49acb5c72290a9`.

## 로그

- [audit raw log](profiling/results/d1-k4c_combined_audit_v1-audit/runs/pilot-20260916T124600Z/raw.log)
- [full performance raw log](profiling/results/d1-k4c_combined_perf_v1-perf/runs/full-20260916T124748Z/raw.log)
- [정적 상수시간 검사](profiling/results/k4c_static_ct.json)

K4-C는 구현과 측정이 완료된 결합 후보다. 아직 `ref_preslothy`에는 자동 통합하지
않았으므로 K2 기준과 K4-A/K4-B ablation 결과가 모두 보존되어 있다.
