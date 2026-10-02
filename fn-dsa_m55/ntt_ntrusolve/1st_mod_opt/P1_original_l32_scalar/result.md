# P1 original Plantard `l=32` scalar 결과

측정일: 2026-09-15  
보드: NUCLEO-N657X0-Q, Cortex-M55 r1p1

## 결론

original Plantard `l=32`는 FN-DSA의 308개 31-bit RNS prime에서
**수학적으로 유효했고 기준 Montgomery 구현과 완전히 일치했다.** 그러나
scalar 구현의 keygen 중앙값은 M1-improve보다 512에서 **19.2709%**,
1024에서 **12.2498% 느리므로** 성능 후보로 채택하지 않는다.

## 식별값과 독립성

| 항목 | SHA-256 |
|---|---|
| `kgen_mp31.c` | `202dfbdd838fe5d2a523811a25973d91aa98bbfdc90e41882ef29cb7c42132b0` |
| 성능 C/H/S source tree | `31e9f02a514d8939da91b3c4b7844fce8696af0d91c01e499fdb4f816ed5989b` |
| 성능 ELF | `bf84f689320ed0cf503f4bc87b9913e0c507aeabb653e42449f4c690eee37d4b` |
| 최종 감사 ELF | `12b5ed68e095abc08b17da58c0d9083e3ee5c72ce617622c4e8c2ece7041420c` |
| 성능 raw log | `8b57b45b9b8a137a13b94487ee8a30beb05971f308479a4f96a25e4a4e09d661` |
| 최종 감사 raw log | `8e1a9530a93af0a0e2df99aa006123f6721c884866bee7f49838f82cbf993126` |

후보 폴더의 Makefile은 M1-improve와 byte-identical하다. 구현은
`kgen_mp31.c`에 직접 작성됐고 다른 후보 소스·오브젝트를 링크하지 않는다.
보드 성능 이미지에서는 `kgen_mp31_cm55.s`를 링크하지 않았다.

## 정확성·안전성

| 검사 | 결과 |
|---|---:|
| 독립 original Plantard 모델 | 308 primes, 10,723,328 reduction cases, mismatch 0 |
| 독립 transform 모델 | logn 4..10, 2,156 pairs, 1,251,712 coefficients, mismatch 0 |
| 실제 보드 NTT/iNTT | 308 primes × logn 4..10, forward/inverse/round-trip mismatch 0 |
| 최대 coefficient 오차 | **0** |
| q=12289 NTT 회귀 | degree 512/1024 mismatch 0 |
| host `test_fndsa` | SHAKE/SHA3/codec/q/fpoly/sampler/keygen/verify/self/KAT degree 2..10 PASS |
| 보드 KAT와 digest | 고정 seed 22개 모두 M1/host oracle과 동일 |
| 정상 sign/verify | 512/1024 PASS |
| 변조 signature / 변조 message | 각각 거부 PASS |
| fault/ECC | CFSR/HFSR/AFSR=0, TCM MSCR 시작/끝 `0x1300a` |
| 100회 반복 | keygen/sign/verify 전부 완료, digest 일치 |

변조 message 검사는 성능 코드 배치를 움직이지 않도록 self-test 감사 이미지에만
넣었다. 성능 이미지도 별도로 변조 signature를 거부한다.

## 보드·빌드·측정 조건

- GNU Arm GCC 15.2.1 20251203, Zephyr 4.4.1, 최종 `-O3`.
- CPU/SYSCLK/HCLK/PCLK: 800/400/200/200 MHz.
- vectors/text는 256 KiB ITCM(`0x10000000`), global rodata/data/BSS/stack은
  256 KiB DTCM(`0x30000000`). main stack 64 KiB.
- live CCR에서 I/D cache enable bit는 OFF다. `CONFIG_ICACHE/DCACHE=y`는
  capability 설정이며 실제 enable 상태가 아니다.
- MVE/FPU build 기능은 켜져 있지만 이 후보의 NTRU NTT는 scalar C다.
- degree별 10개 고정-seed batch, batch마다 warm-up 10회 후 10회 측정:
  API별 총 100회.
- mean은 100회 합의 평균과 같은 10개 batch mean의 평균, median은 5·6번째
  batch mean의 평균, minimum은 최솟값, SD는 10개 batch mean의 population
  standard deviation이다.
- keygen의 rejection sampling 때문에 seed별 분산이 크므로 중앙값과 함께
  원시 batch를 보존했다.

## 전체 API 성능

단위는 cycle/call이다.

| degree | 작업 | mean | median | minimum | SD | M1 median | M1 대비 |
|---:|---|---:|---:|---:|---:|---:|---:|
| 512 | keygen | 60,992,885.30 | 54,933,932 | 51,754,069 | 10,687,326.45 | 46,058,121 | **+19.2709%** |
| 512 | sign | 17,119,423.40 | 17,143,329 | 16,964,611 | 59,152.86 | 17,143,328.5 | +0.0000% |
| 512 | verify | 317,251.80 | 322,921 | 308,423 | 7,143.97 | 322,985.5 | -0.0200% |
| 1024 | keygen | 290,451,803.90 | 249,516,069 | 187,662,022 | 99,920,692.17 | 222,286,354 | **+12.2498%** |
| 1024 | sign | 36,713,304.10 | 36,711,192 | 36,588,153 | 82,565.21 | 36,711,191.5 | +0.0000% |
| 1024 | verify | 620,575.20 | 624,899.5 | 610,095 | 6,815.78 | 624,882 | +0.0028% |

수정 경로는 keygen의 NTRU solve에서만 실행된다. sign/verify의 0.02% 이하
차이는 알고리즘 개선으로 해석하지 않는다.

## `logn`별 직접 NTT/iNTT

10 batches × 100 calls의 batch median이다. 각 호출은 per-prime context와
on-the-fly Plantard root 준비를 포함한다. 공통 `gm/igm` 생성은 함수 밖이며,
전체 keygen에는 포함된다.

| logn | M1 NTT | P1 NTT | M1 iNTT | P1 iNTT |
|---:|---:|---:|---:|---:|
| 4 | 375 | 1,619 | 429 | 1,753 |
| 5 | 765 | 3,302 | 895 | 3,642 |
| 6 | 1,660 | 7,129 | 1,977 | 7,998 |
| 7 | 3,699 | 15,628 | 4,424 | 17,583 |
| 8 | 8,180 | 34,383 | 9,876 | 38,915 |
| 9 | 18,255 | 75,479.5 | 22,023 | 85,343 |
| 10 | 39,960 | 164,608 | 48,507 | 186,675 |

## 메모리

| 항목 | M1-improve | P1 l32 | 변화 |
|---|---:|---:|---:|
| ITCM 실행 이미지 사용량 | 108,076 B | 107,268 B | -808 B |
| ELF `text` 합계 | 169,468 B | 168,660 B | -808 B |
| global `rodata` | 58,972 B | 58,972 B | 0 |
| `data` / `bss` / `noinit` | 76 / 96,251 / 67,904 B | 동일 | 0 |
| 링크 RAM 사용량 | 225,728 B | 225,728 B | 0 |
| production stack upper bound | 9,624 B | 9,624 B | 0 |
| 새 root table | 0 B | 0 B | 0 |

## Constant-time 정적 감사

최종 성능 ELF에서 `fndsa_mp_NTT`는 486 instructions/9 branches,
`fndsa_mp_iNTT`는 508 instructions/8 branches였다. 두 함수 모두 division과
함수 call이 0개다. branch는 공개 `logn`, parity, layer/group/element loop
counter에만 의존한다. coefficient load/store 주소도 이 공개 counter에서만
생긴다. Plantard의 `raw>=p` 보정은 compiler가 branchless predication으로
생성했다. 이는 정적 감사이며 물리 누설의 형식 증명은 아니다.

## 실패·수정 이력과 채택

초기 폴더에는 기존 corrected improved `l=64` 코드가 복사돼 있었으나 이를
original `l=32` 식으로 완전히 교체한 뒤에만 결과를 측정했다. 수식·경계
모델, host, 보드 감사 과정에서 최종 식의 반례나 mismatch는 없었다.

최종 결정: **정확성 기준점으로 보존, 성능 구현으로는 미채택.**

## 원시 로그

- [성능 100회 raw log](../results/p1_l32_scalar/runs/full-20260915T010448Z/raw.log)
- [최종 308-prime 감사 raw log](../results/p1_l32_scalar_audit/runs/pilot-20260915T014014Z/raw.log)
- [성능 승인 manifest](../results/p1_l32_scalar/full_validated.json)
- [감사 승인 manifest](../results/p1_l32_scalar_audit/pilot_validated.json)
- [독립 수학 모델](../verify_original_plantard_l32.py)
- [정적 constant-time 감사](../STATIC_CT_AUDIT.md)
- [host test_fndsa 로그](host_test_fndsa.log)
