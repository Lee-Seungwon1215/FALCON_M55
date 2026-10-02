# K3-C hot-boundary 결과

## 결론

K3-C의 세 후보는 모두 정확성·오차·KAT·서명검증·변조 거부·정적 상수시간
회귀를 통과했다. 하지만 **모두 기각**한다. packed root/twist를 사용하면 NTT와
iNTT 커널은 빨라지지만, `mp_mkgm*()`에서 packed table을 만드는 비용이 이를
상쇄하고도 남았다. 채택 기준본은 K2 `ntt_ntrusolve/ref_preslothy`다.

## 구현 범위

각 96-byte block은 MVE가 소비하는 순서대로 여섯 벡터를 저장한다:
`s roots`, `s twists`, `s0 roots`, `s0 twists`, `s1 roots`, `s1 twists`.
`logn=4..10` region을 연속 배치했고, NTRU solver의 root-table 재사용 때문에
generator가 `logn`과 `logn-1` region을 함께 채운다.

| 후보 | packed 적용 위치 | 추가 table |
|---|---|---:|
| F-only | NTT 마지막 두 layer | 12,192 B |
| I-only | iNTT 첫 두 layer | 12,192 B |
| FI | 위 두 위치 모두 | 24,384 B |

전역 mutable table을 사용하므로 세 후보 모두 재진입 가능하지 않다.

## RNS NTT/iNTT 커널

첫 RNS 소수, 10 batch x 100 calls의 upper median이며 root/twist 준비는 커널
시간 밖이다. 양수는 K2보다 빨라진 비율이다. F-only의 iNTT와 I-only의 NTT는
K2 코드 그대로이므로 변화 열에서 생략한다.

| logn | K2 NTT | F-only/FI NTT | 개선 | K2 iNTT | I-only/FI iNTT | 개선 |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 329.82 | 319.82 | +3.031957% | 355.80 | 347.80 | +2.248454% |
| 5 | 731.82 | 707.82 | +3.279495% | 748.80 | 728.80 | +2.670940% |
| 6 | 1,539.82 | 1,490.82 | +3.182190% | 1,528.80 | 1,484.80 | +2.878074% |
| 7 | 3,554.82 | 3,446.82 | +3.038129% | 3,479.80 | 3,387.80 | +2.643830% |
| 8 | 7,855.82 | 7,635.82 | +2.800471% | 7,469.80 | 7,281.80 | +2.516801% |
| 9 | 17,616.82 | 17,172.82 | +2.520319% | 16,920.80 | 16,540.80 | +2.245757% |
| 10 | 38,501.82 | 37,609.82 | +2.316774% | 36,342.80 | 35,578.80 | +2.102205% |

## 전체 FN-DSA 100회 성능

각 연산 10 batch x 10 calls, 총 100회의 upper median이다. 여기에는 packed
table 생성 비용과 전체 이미지 배치 영향이 포함된다. 변화가 음수이면 K2보다
느린 것이다.

| degree | 연산 | K2 | F-only | 변화 | I-only | 변화 | FI | 변화 |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 512 | 키생성 | 46,399,782 | 46,629,025 | -0.494061% | 46,612,731 | -0.458944% | 46,792,746 | -0.846909% |
| 512 | 서명 | 17,197,899 | 17,214,526 | -0.096680% | 17,217,594 | -0.114520% | 17,242,169 | -0.257415% |
| 512 | 검증 | 323,070 | 324,416 | -0.416628% | 324,416 | -0.416628% | 324,476 | -0.435200% |
| 1024 | 키생성 | 243,479,951 | 244,222,815 | -0.305103% | 244,167,190 | -0.282257% | 244,744,805 | -0.519490% |
| 1024 | 서명 | 36,841,897 | 36,997,160 | -0.421431% | 37,003,811 | -0.439483% | 37,124,743 | -0.767729% |
| 1024 | 검증 | 625,018 | 627,630 | -0.417908% | 627,615 | -0.415508% | 627,630 | -0.417908% |

서명·검증은 이 RNS 커널을 직접 사용하지 않는다. 해당 변화는 table로 인한 BSS,
코드·데이터 배치가 달라진 전체 이미지 결과이며 K3-C의 직접 연산 이득으로
해석하면 안 된다. 채택 판단의 핵심은 키생성과 위 커널 측정이다.

## 정확성·오차·KAT·서명검증

세 후보 모두 다음을 통과했다.

| 검사 | 결과 |
|---|---|
| q=12289 NTT 512/1024 | forward/roundtrip/oracle mismatch 0, max modular error 0 |
| RNS NTT/iNTT | 308 primes x logn 4..10 = 2,156 transforms, mismatch 0, max modular error 0 |
| Montgomery lane | 18,923,520 cases, mismatch/range error 0 |
| 고정입력 digest 512 | `9fd7c627fa100863e8f684339f3eb3835fc55a24066f4dd34aea05d555d8eadd` |
| 고정입력 digest 1024 | `c543754d19ef263221b2316acac8ad5c34502886750fdd5bfffd4f5487c018bb` |
| 정상 서명 검증 | PASS |
| 서명 변조 거부 | PASS |
| fault registers | CFSR/HFSR/AFSR = 0 |

digest는 K2와 bit-for-bit 동일하다. 여기의 KAT는 프로젝트의 고정입력 결정적
회귀검사이며 FIPS 인증 KAT를 뜻하지 않는다.

## 상수시간·메모리 회귀

[static_ct.json](static_ct.json)의 정적 disassembly 검사는 PASS다.
`mp_NTT`, `mp_iNTT`, `mp_NTT_small`의 branch 수와 branch mnemonic 순서가
K2와 같고, call/간접 branch/divide/FP 명령이 추가되지 않았다. 새 주소는 공개
`logn`과 공개 loop counter만 사용하며 packing loop도 공개 크기와 공개 root
index에만 의존한다.

| 후보 | text 변화 | BSS 변화 | RAM(audit build) |
|---|---:|---:|---:|
| F-only | +284 B | +12,192 B | 246,496 / 262,144 B (94.03%) |
| I-only | +316 B | +12,192 B | 246,496 / 262,144 B (94.03%) |
| FI | +364 B | +24,384 B | 258,688 / 262,144 B (98.68%) |

이는 정적 구조 회귀 검사이며 형식적 상수시간 증명이나 dudect/TVLA·전력/EM
누출검사가 아니다.

## 측정 조건

NUCLEO-N657X0-Q, Cortex-M55, CPU/SYSCLK/HCLK 800/400/200 MHz, code ITCM,
data·stack DTCM, cache 관리 OFF, ECC ON, GCC 15.2.1, `-O3`이다. K2와 동일한
입력·계측기·반복 횟수를 사용했다.

## 근거 로그와 ELF

- K2 audit: `../../ref_preslothy/profiling/results/d1-k2_root_pipeline_audit-audit/runs/pilot-20260916T082122Z/`
- K2 full perf: `../../ref_preslothy/profiling/results/d1-k2_root_pipeline_perf-perf/runs/full-20260916T082212Z/`
- F audit: `F_forward/profiling/results/d1-k3c_f_audit-audit/runs/pilot-20260916T094112Z/`
- F full perf: `F_forward/profiling/results/d1-k3c_f_perf-perf/runs/full-20260916T094219Z/`
- I audit: `I_inverse/profiling/results/d1-k3c_i_audit-audit/runs/pilot-20260916T094128Z/`
- I full perf: `I_inverse/profiling/results/d1-k3c_i_perf-perf/runs/full-20260916T094415Z/`
- FI audit: `FI_combined/profiling/results/d1-k3c_fi_audit_v2-audit/runs/pilot-20260916T093618Z/`
- FI full perf: `FI_combined/profiling/results/d1-k3c_fi_perf-perf/runs/full-20260916T093710Z/`
- audit ELF SHA-256: F `f2d1014b...12d411cf`, I `72a0d671...c2358ff410`, FI `1cfa845e...76189fb9c7`
- perf ELF SHA-256: F `1ea7f2a0...1ae04d7`, I `e39d3f4c...7d0db8`, FI `1b570bb3...dcceaa`

초기 FI 개발 실행 `d1-k3c_fi_audit-audit`은 `logn-1` root-table 재사용을
처리하지 않아 전체 키생성에서 멈췄다. 수정 전 실패 기록으로 보존하지만 위 결과와
판정에서는 제외했다.
