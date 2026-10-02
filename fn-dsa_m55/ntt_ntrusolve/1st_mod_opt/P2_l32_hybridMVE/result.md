# P2 original Plantard `l=32` hybrid-MVE 결과

측정일: 2026-09-15  
보드: NUCLEO-N657X0-Q, Cortex-M55 r1p1

## 결론

hybrid는 full Plantard보다 keygen 중앙값이 512에서 **4.3838%**, 1024에서
**2.8312% 빨랐다.** 하지만 M1-improve보다 각각 **0.3406%**, **0.2242%
느렸다.** 측정한 모든 layer family에서 Plantard가 M1보다 느렸으므로
M1-improve를 유지한다.

## 식별값과 독립성

| 항목 | SHA-256 |
|---|---|
| `kgen_mp31_cm55.s` | `ca2f4614635e6740d4fa57e05df0ab03a4e4828211dcc0440ae0043e3b37c748` |
| `kgen_mp31.c` fallback/oracle | `fd586b85ba6b8b6f72c7068dab8de10c7ffaac91b4ec9bae9215163923bffedb` |
| 성능 C/H/S source tree | `cc8f87bd38cfa8f50e92b19eed21f7d86d8e8aa1489bd36e5c81219b8cd4b54b` |
| 성능 ELF | `e29518863f64dcfb21c5eda482d28817fb843e0bc45053dab6502713f4cb8976` |
| 최종 감사 ELF | `c3b653adeeff23add2b749a500aae908f843c6e522c0dd1c8c5fb622a8e770c1` |
| 성능 raw log | `781a867b84456ff4fc1a5ef3a2383590355ad2ba943790d63f19e689c5a96ab6` |
| 최종 감사 raw log | `95536d261323f6c3b36318df27a9f32898e3ba2726197f165f0149fe9a69bc61` |

Makefile은 M1-improve와 byte-identical하다. 실제 hybrid는 후보의 S 파일에
직접 작성됐으며 외부 후보 파일, wrapper, alias, intrinsic, inline assembly
또는 빌드 옵션으로 구성하지 않았다.

## 정확성·안전성

| 검사 | 결과 |
|---|---:|
| 독립 original Plantard 모델 | 308 primes, 10,723,328 cases, mismatch 0 |
| 실제 MVE multiply 경계/무작위/root 감사 | 18,923,520 lane cases, mismatch/range error 0 |
| 실제 보드 NTT/iNTT | 308 primes × logn 4..10, 2,156 transforms, mismatch 0 |
| NTT→iNTT/C oracle 배열 전체 | bit-exact, 최대 오차 **0** |
| q=12289 NTT 회귀 | degree 512/1024 mismatch 0 |
| host portable `test_fndsa` | degree 2..10 PASS |
| 실제 hybrid 보드 KAT/digest | 고정 seed 22개 모두 M1/host와 동일 |
| 정상 sign/verify | 512/1024 PASS |
| 변조 signature / 변조 message | 각각 거부 PASS |
| fault/ECC | CFSR/HFSR/AFSR=0, TCM MSCR 시작/끝 `0x1300a` |
| 100회 반복 | keygen/sign/verify 완료, digest 모두 일치 |

host 테스트는 portable C를, 실제 S 경로는 보드 감사/KAT가 검사한다. 변조
message 검사는 self-test 감사 이미지에만 넣어 생산 성능 배치를 유지했다.

## 빌드·보드·측정 조건

- GNU Arm GCC 15.2.1 20251203, Zephyr 4.4.1, 최종 `-O3`.
- CPU/SYSCLK/HCLK/PCLK 800/400/200/200 MHz.
- 256 KiB ITCM text(`0x10000000`), 256 KiB DTCM
  rodata/data/BSS/stack(`0x30000000`), main stack 64 KiB.
- live CCR 기준 I/D cache OFF.
- 10 fixed-seed batches × 10 warm-up + 10 measured calls = API별 100회.
- mean/median/minimum/population SD는 10개 batch mean에서 계산했다.
- NTRU solve 내부 rejection sampling을 포함한다.

## 전체 API 성능

단위는 cycle/call이다.

| degree | 작업 | mean | median | minimum | SD | M1 대비 | full 대비 |
|---:|---|---:|---:|---:|---:|---:|---:|
| 512 | keygen | 52,186,777.80 | 46,214,987.5 | 43,034,959 | 10,550,867.32 | **+0.3406%** | **-4.3838%** |
| 512 | sign | 17,119,467.00 | 17,143,383.5 | 16,964,612 | 59,181.04 | +0.0003% | -0.2574% |
| 512 | verify | 317,336.50 | 322,973 | 308,475 | 7,149.03 | -0.0039% | -0.0034% |
| 1024 | keygen | 263,185,981.70 | 222,784,762.5 | 161,940,188 | 98,316,328.43 | **+0.2242%** | **-2.8312%** |
| 1024 | sign | 36,713,315.10 | 36,711,191.5 | 36,588,262 | 82,548.72 | +0.0000% | -0.2407% |
| 1024 | verify | 620,649.00 | 624,978.5 | 610,147 | 6,806.15 | +0.0154% | +0.0070% |

M1 median은 512 keygen/sign/verify
46,058,121/17,143,328.5/322,985.5 cycles, 1024는
222,286,354/36,711,191.5/624,882 cycles다. full median은 각각
48,333,867.5/17,187,620.5/322,984 및
229,276,095/36,799,772.5/624,935 cycles다.

수정 함수는 keygen에서만 실행되므로 sign/verify의 작은 수치는 hybrid
효과가 아니다.

## 최종 `logn`별 NTT/iNTT

10 batches × 100 calls의 batch median이며 Plantard를 쓰는 호출은 context와
on-the-fly root 준비를 포함한다.

| logn | M1 NTT | hybrid NTT | 변화 | M1 iNTT | hybrid iNTT | 변화 |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 375 | 384 | +2.4% | 429 | 442 | +3.0% |
| 5 | 765 | 1,047 | +36.9% | 895 | 1,192 | +33.2% |
| 6 | 1,660 | 1,666 | +0.4% | 1,977 | 1,993 | +0.8% |
| 7 | 3,699 | 3,962 | +7.1% | 4,424 | 4,752 | +7.4% |
| 8 | 8,180 | 8,183 | +0.0% | 9,876 | 9,895 | +0.2% |
| 9 | 18,255 | 18,463 | +1.1% | 22,023 | 22,454 | +2.0% |
| 10 | 39,960 | 39,996 | +0.1% | 48,507 | 48,493 | -0.0% |

even logn은 산술적으로 M1과 동일하다. 이때의 수 cycle 차이는 실행 잡음이며
개선으로 주장하지 않는다. odd logn의 차이가 maximum-reuse singleton
Plantard 비용을 격리하며 전부 손해다.

## 레이어-family 선택 실험

q6에 `p`를 유지하도록 정리한 broad hybrid의 NTT/iNTT 중앙값은 logn
4..10 순서로 다음과 같다.

```text
NTT : 735, 1268, 2756, 5662, 13420, 28458, 66581.5
iNTT: 801, 1434, 3169, 6628, 15683, 33554, 78110.5
```

이는 full Plantard보다 빠르므로 boundary layer는 Montgomery가 낫다. 그러나
M1보다 모든 logn에서 느리므로 남은 early/middle Plantard도 이득이 없다.
마지막 final hybrid와 M1 비교까지 합쳐 maximum-reuse layer도 탈락했다.
개별 layer에 timer/log를 삽입해 production layout을 바꾸지 않고, 완성된
레이어-family binary 간 차이로 판단했다.

## 메모리·코드

| 항목 | M1-improve | hybrid | 변화 |
|---|---:|---:|---:|
| ITCM 실행 이미지 사용량 | 108,076 B | 108,364 B | +288 B |
| ELF `text` 합계 | 169,468 B | 169,756 B | +288 B |
| NTT+iNTT symbol | 1,820 B | 2,112 B | +292 B |
| global `rodata` | 58,972 B | 58,972 B | 0 |
| `data` / `bss` / `noinit` | 76 / 96,251 / 67,904 B | 동일 | 0 |
| 링크 RAM 사용량 | 225,728 B | 225,728 B | 0 |
| production stack upper bound | 9,624 B | 9,624 B | 0 |
| 새 root table | 0 B | 0 B | 0 |

## Constant-time disassembly

| 함수 | size | instructions | branches | calls | division |
|---|---:|---:|---:|---:|---:|
| `fndsa_mp_NTT` | 0x3e0 B | 276 | 12 | 0 | 0 |
| `fndsa_mp_iNTT` | 0x460 B | 308 | 10 | 0 | 0 |

첫 branch는 공개 `logn<4` fallback이다. 추가 parity branch는 공개 logn으로
Plantard context와 odd singleton을 선택한다. 나머지는 공개 layer/group/
element loop다. indexed root load도 공개 고정 stride만 사용한다. secret
dependent branch/address/loop와 division이 없다. 정적 감사 범위이며 TVLA나
형식 증명은 아니다.

## 실패·수정 이력과 채택

- broad early/middle 가설은 정확성 검사를 통과했지만 cycle 비교에서
  탈락했다.
- full 후보에서 발견한 signed probe 입력 계약과 root pointer clobber 문제는
  hybrid에도 같은 방식으로 수정된 상태에서 검증했다.
- full과 동일하게 vector `p` resident 최적화를 적용했다.

최종 결정: **Plantard 후보 중에는 full보다 hybrid가 낫지만,
M1-improve보다 느려 제품 후보로 미채택.**

후속 Slothy 후보는 Plantard hybrid가 아니라 더 짧고 실제로 빠른
**M1-improve Montgomery S 파일**이다.

## 원시 로그

- [성능 100회 raw log](../results/p2_l32_hybrid/runs/full-20260915T013317Z/raw.log)
- [최종 308-prime 감사 raw log](../results/p2_l32_hybrid_audit/runs/pilot-20260915T014044Z/raw.log)
- [broad hybrid raw log](../results/p2_l32_hybrid_audit/runs/pilot-20260915T012711Z/raw.log)
- [성능 승인 manifest](../results/p2_l32_hybrid/full_validated.json)
- [감사 승인 manifest](../results/p2_l32_hybrid_audit/pilot_validated.json)
- [정적 constant-time 감사](../STATIC_CT_AUDIT.md)
- [host test_fndsa 로그](host_test_fndsa.log)
