# K3-A separate twist 결과

## 결론

K3-A는 정확성·KAT·서명검증·정적 상수시간 회귀를 통과했지만 **기각**한다.
K2의 MVE `vmul` 한 번을 없애는 대신 root와 twist의 주소 계산·load·broadcast가
늘어 커널이 모든 크기에서 느려졌고, 전체 키생성도 512에서 0.927%,
1024에서 0.566% 느려졌다. BSS도 8192 B 증가하며 구현은 재진입 가능하지 않다.
채택 기준본은 계속 `ntt_ntrusolve/ref_preslothy`의 K2다.

## RNS NTT/iNTT 커널

같은 보드/클럭/TCM/cache/ECC/compiler 조건의 통합 audit 하네스에서 첫 RNS 소수에
대해 10 batch x 100 calls의 중앙값을 비교했다. root 표 생성은 커널 시간 밖이며,
K3-A의 표 생성비용은 아래 전체 API 측정에 포함된다. 음수는 K3-A가 느려진 값이다.

| logn | K2 NTT | K3-A NTT | 변화 | K2 iNTT | K3-A iNTT | 변화 |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 329.82 | 348.82 | -5.761% | 355.80 | 381.80 | -7.307% |
| 5 | 731.82 | 764.82 | -4.509% | 748.80 | 829.80 | -10.817% |
| 6 | 1,539.82 | 1,651.82 | -7.274% | 1,528.80 | 1,667.80 | -9.092% |
| 7 | 3,554.82 | 3,773.82 | -6.161% | 3,479.80 | 3,883.80 | -11.610% |
| 8 | 7,855.82 | 8,481.82 | -7.969% | 7,469.80 | 8,205.80 | -9.853% |
| 9 | 17,616.82 | 18,867.82 | -7.101% | 16,920.80 | 18,901.80 | -11.707% |
| 10 | 38,501.82 | 41,767.82 | -8.483% | 36,342.80 | 40,039.80 | -10.173% |

NTT는 두 ELF에서 같은 시작 주소였지만, 코드 크기가 달라 iNTT 시작 주소는 바뀐다.
따라서 이 표는 K1/K2처럼 완전한 layout-fixed A/B는 아니다. 다만 K3-A는 명령과
메모리 접근이 모두 증가했고 전 크기·전체 API가 같은 방향으로 느려져 기각 판단은 변하지 않는다.

## 전체 FN-DSA 100회 성능

각 연산 10 batch x 10 calls, 총 100회의 upper median이다. 표 생성비용과 추가
메모리 접근을 모두 포함한다.

| degree | 연산 | K2 cycles | K3-A cycles | K3-A 변화 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 46,399,782 | 46,829,851 | -0.926877% |
| 512 | 서명 | 17,197,899 | 17,229,882 | -0.185970% |
| 512 | 검증 | 323,070 | 324,416 | -0.416628% |
| 1024 | 키생성 | 243,479,951 | 244,858,612 | -0.566232% |
| 1024 | 서명 | 36,841,897 | 36,926,695 | -0.230167% |
| 1024 | 검증 | 625,018 | 627,630 | -0.417908% |

서명·검증은 RNS 커널의 직접 효과로 해석하지 않는다. K3-A가 추가한 BSS와 코드
배치 변화까지 포함된 전체 이미지 결과이며, 주효과 판단은 RNS를 사용하는 키생성이다.

## 정확성·오차·KAT·서명검증

| 검사 | 결과 |
|---|---|
| q=12289 NTT 512/1024 | forward/roundtrip/oracle mismatch 0, max modular error 0 |
| RNS NTT/iNTT | 308 primes x logn 4..10 = 2,156 transforms, mismatch 0, max modular error 0 |
| Montgomery lane | 18,923,520 cases, mismatch/range error 0 |
| 프로젝트 고정입력 digest 512 | `9fd7c627fa100863e8f684339f3eb3835fc55a24066f4dd34aea05d555d8eadd` |
| 프로젝트 고정입력 digest 1024 | `c543754d19ef263221b2316acac8ad5c34502886750fdd5bfffd4f5487c018bb` |
| 정상 서명 검증 | PASS |
| 서명 변조 거부 | PASS |
| fault registers | CFSR/HFSR/AFSR = 0 |

digest는 K2와 bit-for-bit 동일하다. 여기의 KAT는 프로젝트 고정입력 결정적 회귀이며
FIPS 인증 KAT를 뜻하지 않는다.

## 상수시간·크기 회귀

정적 disassembly 검사는 PASS다. NTT/iNTT의 branch 수와 branch mnemonic 순서는
K2와 동일하고, call/간접 branch/divide/FP 명령은 추가되지 않았다. 새 twist 주소는
공개 root-table offset, 공개 `logn`, 공개 loop counter로만 계산한다.

| 항목 | K2 | K3-A | 변화 |
|---|---:|---:|---:|
| `mp_NTT` 코드 | 1,166 B / 312 instr / 49 memory | 1,248 B / 339 instr / 61 memory | +82 B / +27 instr / +12 memory |
| `mp_iNTT` 코드 | 1,562 B / 418 instr / 64 memory | 1,652 B / 453 instr / 88 memory | +90 B / +35 instr / +24 memory |
| 전체 text | 176,880 B | 177,224 B | +344 B |
| 전체 BSS | 172,351 B | 180,543 B | +8,192 B |

정적 검사는 [k3a_static_ct.json](profiling/results/k3a_static_ct.json)과
`profiling/audit_k3a.py`로 재현한다. 이는 형식적 상수시간 증명이나 동적 누출검사가 아니다.

## 근거 로그

- 성공 audit: `profiling/results/d1-k3a_separate_twist_audit_v2-audit/runs/pilot-20260916T084725Z/`
- 100회 성능: `profiling/results/d1-k3a_separate_twist_perf-perf/runs/full-20260916T084846Z/`
- 개발 중 정렬 fault 로그(최종 결과 제외): `profiling/results/d1-k3a_separate_twist_audit-audit/runs/pilot-20260916T084625Z/`
- K3-A audit ELF SHA-256: `d9b2ffc4a260cb116783f51ea25645efa7b29eaa23c14b1f11d482b20ffb7ea9`
- K3-A perf ELF SHA-256: `ec81dae17134604580891484895cc062b3a4ee2957944de4eb0f4a5bd0905b18`

