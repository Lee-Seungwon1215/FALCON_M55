# P2 original Plantard `l=32` full-MVE 결과

측정일: 2026-09-15  
보드: NUCLEO-N657X0-Q, Cortex-M55 r1p1

## 결론

`logn>=4`의 모든 NTRU-solver NTT/iNTT twiddle multiplication을 handwritten
MVE original Plantard `l=32`로 구현했다. 308-prime bit-exact 감사와 전체
KAT는 통과했지만 keygen 중앙값은 M1-improve보다 512에서 **4.9410%**,
1024에서 **3.1445% 느렸다.** 정확하지만 M1을 대체할 성능은 아니다.

## 식별값과 독립성

| 항목 | SHA-256 |
|---|---|
| `kgen_mp31_cm55.s` | `f0fa1442e18793bcf3250540eddc2f8712f981e26306f71da38e89ec53759c06` |
| `kgen_mp31.c` fallback/oracle | `fd586b85ba6b8b6f72c7068dab8de10c7ffaac91b4ec9bae9215163923bffedb` |
| 성능 C/H/S source tree | `975e1d438e5e08d6d16ae08ee53d75849c20a9b5a2dcdd0b582d6afc22bd9784` |
| 성능 ELF | `31cebd0958984050be2e765ed7e31209ca7ed97a77302f0a27c60fdee3dd6bd7` |
| 최종 감사 ELF | `80338e7fb61af55fe11eb679480e84061d927a7d57f3384b3badee787e30753a` |
| 성능 raw log | `67dbc1b973795a9c529a9939e76cfaf72b872605be021b1f44d70ba8d9e8eb06` |
| 최종 감사 raw log | `d0216b423619c1a009d7d4285f31d8b94b84a997bc8e6bbd77f1924e8f3b964f` |

Makefile은 M1-improve와 byte-identical하다. 후보의 실제 S 파일을 직접
빌드하며 다른 후보 소스/오브젝트, wrapper, alias, weak production symbol,
C intrinsic 또는 inline assembly를 사용하지 않는다.

## 정확성·안전성

| 검사 | 결과 |
|---|---:|
| 독립 original Plantard 모델 | 308 primes, 10,723,328 cases, mismatch 0 |
| 실제 MVE multiply 경계/무작위/root 감사 | 18,923,520 lane cases, mismatch/range error 0 |
| 실제 보드 NTT/iNTT | 308 primes × logn 4..10, 2,156 transforms, mismatch 0 |
| NTT→iNTT 및 C oracle 배열 전체 | bit-exact, 최대 오차 **0** |
| q=12289 NTT 회귀 | degree 512/1024 mismatch 0 |
| host `test_fndsa` | degree 2..10 PASS |
| 실제 MVE 보드 KAT/digest | 고정 seed 22개 모두 M1/host와 동일 |
| 정상 sign/verify | 512/1024 PASS |
| 변조 signature / 변조 message | 각각 거부 PASS |
| fault/ECC | CFSR/HFSR/AFSR=0, TCM MSCR 시작/끝 `0x1300a` |
| 100회 반복 | keygen/sign/verify 완료, digest 전부 일치 |

host Makefile은 비-ARM portable C 경로를 검사한다. handwritten MVE 경로의
실제 KAT와 coefficient exactness는 보드 감사가 담당한다. 변조 message는
코드 배치에 영향을 주지 않도록 감사 이미지에서, 변조 signature는 감사와
성능 이미지 모두에서 확인했다.

## 빌드·보드·측정 조건

- GNU Arm GCC 15.2.1 20251203, Zephyr 4.4.1, 최종 `-O3`.
- CPU/SYSCLK/HCLK/PCLK 800/400/200/200 MHz.
- vectors/text: 256 KiB ITCM `0x10000000`; global rodata/data/BSS/stack:
  256 KiB DTCM `0x30000000`; main stack 64 KiB.
- live CCR 기준 I/D cache OFF. build의 `CONFIG_ICACHE/DCACHE=y`는 capability
  설정이다.
- 10 fixed-seed batches × batch당 10 warm-up + 10 measured calls =
  API별 100회.
- mean/median/minimum/SD는 10개 batch mean에 대해 계산했다. median은
  5·6번째 평균, SD는 population SD다.
- keygen rejection sampling을 그대로 포함했다.

## 전체 API 성능

단위는 cycle/call이다.

| degree | 작업 | mean | median | minimum | SD | M1 median | M1 대비 |
|---:|---|---:|---:|---:|---:|---:|---:|
| 512 | keygen | 54,318,738.50 | 48,333,867.5 | 45,154,003 | 10,570,954.38 | 46,058,121 | **+4.9410%** |
| 512 | sign | 17,163,737.20 | 17,187,620.5 | 17,008,903 | 59,170.77 | 17,143,328.5 | +0.2584% |
| 512 | verify | 317,325.70 | 322,984 | 308,518 | 7,130.56 | 322,985.5 | -0.0005% |
| 1024 | keygen | 269,798,052.80 | 229,276,095 | 168,273,477 | 98,622,264.06 | 222,286,354 | **+3.1445%** |
| 1024 | sign | 36,801,895.20 | 36,799,772.5 | 36,676,842 | 82,548.76 | 36,711,191.5 | +0.2413% |
| 1024 | verify | 620,616.40 | 624,935 | 610,158 | 6,801.40 | 624,882 | +0.0085% |

변경 함수는 keygen NTRU solve 전용이다. sign/verify 변화는 코드 이미지
차이에 따른 배치/측정 잡음이며 Plantard 효과로 해석하지 않는다.

## `logn`별 NTT/iNTT

각 값은 10 batches × 100 calls의 batch median이며 per-prime context와
on-the-fly root 준비를 포함한다.

| logn | M1 NTT | full NTT | 변화 | M1 iNTT | full iNTT | 변화 |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 375 | 822 | +119.2% | 429 | 904 | +110.7% |
| 5 | 765 | 1,444 | +88.8% | 895 | 1,636 | +82.8% |
| 6 | 1,660 | 3,110 | +87.3% | 1,977 | 3,581 | +81.1% |
| 7 | 3,699 | 6,372 | +72.3% | 4,424 | 7,435 | +68.1% |
| 8 | 8,180 | 14,842 | +81.4% | 9,876 | 17,340 | +75.6% |
| 9 | 18,255 | 31,304 | +71.5% | 22,023 | 36,802 | +67.1% |
| 10 | 39,960 | 72,270 | +80.9% | 48,507 | 84,792.5 | +74.8% |

공통 gm/igm 생성은 함수 밖이라 이 표에는 없지만 전체 keygen에는 포함된다.
full Plantard는 모든 logn에서 M1보다 느려 twiddle 준비를 감추지 않아도 이득이
없었다.

## 메모리·코드

| 항목 | M1-improve | full MVE | 변화 |
|---|---:|---:|---:|
| ITCM 실행 이미지 사용량 | 108,076 B | 109,180 B | +1,104 B |
| ELF `text` 합계 | 169,468 B | 170,572 B | +1,104 B |
| NTT+iNTT symbol | 1,820 B | 2,912 B | +1,092 B |
| global `rodata` | 58,972 B | 58,972 B | 0 |
| `data` / `bss` / `noinit` | 76 / 96,251 / 67,904 B | 동일 | 0 |
| 링크 RAM 사용량 | 225,728 B | 225,728 B | 0 |
| production stack upper bound | 9,624 B | 9,624 B | 0 |
| 새 root table | 0 B | 0 B | 0 |

S 함수는 24-byte local frame을 사용하지만 기존 전체 keygen 최대 stack보다
작아 측정 상한은 증가하지 않았다.

## Constant-time disassembly

| 함수 | size | instructions | branches | calls | division |
|---|---:|---:|---:|---:|---:|
| `fndsa_mp_NTT` | 0x552 B | 378 | 10 | 0 | 0 |
| `fndsa_mp_iNTT` | 0x60e B | 425 | 9 | 0 | 0 |

첫 branch는 공개 `logn<4` C fallback이다. 나머지는 공개 parity,
32회 context loop, layer/group/element counter뿐이다. MVE indexed root
loads의 offsets도 공개 고정 stride vector다. secret coefficient에 따른
branch, address, loop, division은 없다. 이는 정적 구조 감사이지 TVLA나
형식 증명은 아니다.

## 실패와 수정 이력

1. 첫 multiply probe는 M1 감사 harness가 signed GS 입력도 넣어 약 410만
   mismatch가 났다. production Plantard GS는 이미 unsigned canonical
   입력이었고, probe도 같은 계약을 적용하도록 음수에 `p`를 branchless
   추가해 수정했다.
2. 초기 root 변환 뒤 공개 root pointer register를 재사용해 unaligned
   HardFault가 발생했다. pointer를 공개 table base/index로 다시 구성해
   수정했다.
3. vector `p`를 `q6`에 유지하고 소비 완료된 butterfly register를
   scratch로 재사용해 coefficient Plantard를 6개에서 5개 vector
   instruction으로 줄였다.

모든 수정 뒤 308-prime 감사, KAT, 변조 검사와 100회 측정을 다시 통과했다.

최종 결정: **정확성 확인용으로 보존, M1-improve 대체 후보로 미채택.**

## 원시 로그

- [성능 100회 raw log](../results/p2_l32_full/runs/full-20260915T013116Z/raw.log)
- [최종 308-prime 감사 raw log](../results/p2_l32_full_audit/runs/pilot-20260915T014028Z/raw.log)
- [성능 승인 manifest](../results/p2_l32_full/full_validated.json)
- [감사 승인 manifest](../results/p2_l32_full_audit/pilot_validated.json)
- [정적 constant-time 감사](../STATIC_CT_AUDIT.md)
- [host test_fndsa 로그](host_test_fndsa.log)
