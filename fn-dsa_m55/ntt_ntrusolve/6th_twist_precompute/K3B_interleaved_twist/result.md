# K3-B interleaved root/twist 결과

## 결론

K3-B는 정확성·KAT·서명검증·정적 상수시간 회귀를 통과했지만 **기각**한다.
K2의 MVE `vmul`을 없애고 `{root, twist}`를 같이 읽었으나, 주소 계산과 추가
load/broadcast 비용이 더 컸다. 전체 키생성은 K2 대비 512에서 1.308%, 1024에서
0.794% 느려졌고 BSS도 16,384 B 증가했다. 채택 기준본은 계속 K2다.

## RNS NTT/iNTT 커널

동일 보드·클럭·TCM·cache·ECC·compiler 조건에서 첫 RNS 소수를 사용해
10 batch x 100 calls의 중앙값을 비교했다. root/twist 표 생성은 커널 시간 밖이며,
그 생성비용은 아래 전체 API 측정에 포함된다. 변화의 음수는 K3-B가 느려진 값이다.

| logn | K2 NTT | K3-B NTT | 변화 | K2 iNTT | K3-B iNTT | 변화 |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 329.82 | 355.82 | -7.883% | 355.80 | 389.80 | -9.556% |
| 5 | 731.82 | 778.82 | -6.422% | 748.80 | 833.80 | -11.351% |
| 6 | 1,539.82 | 1,671.82 | -8.572% | 1,528.80 | 1,680.80 | -9.942% |
| 7 | 3,554.82 | 3,813.82 | -7.286% | 3,479.80 | 3,878.80 | -11.466% |
| 8 | 7,855.82 | 8,529.82 | -8.580% | 7,469.80 | 8,213.80 | -9.960% |
| 9 | 17,616.82 | 18,963.82 | -7.646% | 16,920.80 | 18,791.80 | -11.057% |
| 10 | 38,501.82 | 41,831.82 | -8.649% | 36,342.80 | 39,886.80 | -9.752% |

K3-A와 비교하면 K3-B는 큰 iNTT에서만 소폭 빨랐다: logn 7/9/10에서 각각
0.129%/0.582%/0.382%. 나머지는 같거나 느렸으며 K2에는 전 구간에서 졌다.
코드 크기 변화로 iNTT 위치도 달라졌으므로 완전한 layout-fixed A/B는 아니다.

## 전체 FN-DSA 100회 성능

각 연산 10 batch x 10 calls, 총 100회의 upper median이다. 표 생성비용과
추가 메모리 접근을 모두 포함한다.

| degree | 연산 | K2 cycles | K3-B cycles | K3-B 변화 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 46,399,782 | 47,006,753 | -1.308133% |
| 512 | 서명 | 17,197,899 | 17,214,526 | -0.096680% |
| 512 | 검증 | 323,070 | 324,416 | -0.416628% |
| 1024 | 키생성 | 243,479,951 | 245,412,722 | -0.793811% |
| 1024 | 서명 | 36,841,897 | 37,019,836 | -0.482980% |
| 1024 | 검증 | 625,018 | 627,669 | -0.424148% |

서명·검증 변화는 RNS 커널의 직접 효과가 아니라 추가 BSS와 코드 배치 변화가
포함된 전체 이미지 결과다. 주효과 판단은 RNS NTT를 사용하는 키생성과 커널 측정이다.

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

digest는 K2와 bit-for-bit 동일하다. 여기의 KAT는 프로젝트 고정입력 결정적
회귀검사이며 FIPS 인증 KAT를 뜻하지 않는다.

## 상수시간·크기 회귀

정적 disassembly 검사는 PASS다. NTT/iNTT branch 수와 mnemonic 순서는 K2와
동일하며 call/간접 branch/divide/FP 명령은 추가되지 않았다. 새 표 주소는 공개
root index, 공개 `logn`, 공개 loop counter로만 계산된다.

| 항목 | K2 | K3-B | 변화 |
|---|---:|---:|---:|
| `mp_NTT` 코드 | 1,166 B / 312 instr / 49 memory | 1,210 B / 325 instr / 58 memory | +44 B / +13 instr / +9 memory |
| `mp_iNTT` 코드 | 1,562 B / 418 instr / 64 memory | 1,614 B / 438 instr / 84 memory | +52 B / +20 instr / +20 memory |
| 전체 text | 176,880 B | 177,156 B | +276 B |
| 전체 BSS | 172,351 B | 188,735 B | +16,384 B |

정적 검사는 [k3b_static_ct.json](profiling/results/k3b_static_ct.json)과
`profiling/audit_k3b.py`로 재현한다. 이는 형식적 상수시간 증명이나 동적
누출검사가 아니다. 전역 mutable 표 때문에 K3-B는 재진입 가능하지 않다.

## 근거 로그

- audit: `profiling/results/d1-k3b_interleaved_twist_audit-audit/runs/pilot-20260916T090524Z/`
- 성능: `profiling/results/d1-k3b_interleaved_twist_perf-perf/runs/full-20260916T090642Z/`
- K3-B audit ELF SHA-256: `c5e4de17646b1f86001503582673701285778af5198ccf6a5566f7599b461904`
- K3-B perf ELF SHA-256: `220766c23e0fce4909fbad416f016c252a7294ecd714fbfc94b8eaa9faf127f6`
