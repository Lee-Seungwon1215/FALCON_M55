# FN-DSA NTRU-solver original Plantard `l=32` 최종 비교

완료일: 2026-09-15  
보드: NUCLEO-N657X0-Q, Cortex-M55 r1p1

## 최종 판단

1. original Plantard `l=32`는 FN-DSA의 308개 31-bit RNS prime에서
   **수학적으로 유효하다.**
2. P1 scalar는 reduction 10,723,328건, transform coefficient
   1,251,712개와 실제 보드 `logn=4..10`에서 Montgomery 기준과
   **오차 0, bit-exact 일치**했다.
3. P2 hybrid MVE가 full MVE보다 빨랐다.
4. 하지만 twiddle 준비를 포함하면 Plantard 후보 어느 것도 M1-improve를
   이기지 못했다.
5. keygen 중앙값 기준 최선 Plantard인 hybrid도 M1보다 512에서 0.3406%,
   1024에서 0.2242% 느리다. 즉 개선율은 각각 **-0.3406%, -0.2242%**다.
6. M1-improve를 대체할 가치가 없다. 후속 Slothy 대상도 M1-improve다.

## 동일 표 비교

모든 수치는 cycle/call의 표준 median(10개 batch mean 중 5·6번째 평균)이다.

| 후보 | 512 keygen | 512 sign | 512 verify | 1024 keygen | 1024 sign | 1024 verify |
|---|---:|---:|---:|---:|---:|---:|
| M1-improve | **46,058,121** | 17,143,328.5 | 322,985.5 | **222,286,354** | 36,711,191.5 | 624,882 |
| improved Plantard l64 scalar | 64,662,354 | 17,197,092.5 | 322,984 | 279,390,449.5 | 36,818,716 | 624,971.5 |
| original Plantard l32 scalar | 54,933,932 | 17,143,329 | 322,921 | 249,516,069 | 36,711,192 | 624,899.5 |
| original Plantard l32 full MVE | 48,333,867.5 | 17,187,620.5 | 322,984 | 229,276,095 | 36,799,772.5 | 624,935 |
| original Plantard l32 hybrid MVE | 46,214,987.5 | 17,143,383.5 | 322,973 | 222,784,762.5 | 36,711,191.5 | 624,978.5 |

수정된 NTRU NTT/iNTT는 keygen에서만 쓰인다. sign/verify의 미세 차이는
Plantard 효과가 아니라 이미지/측정 잡음이다.

| 후보 | 512 keygen: M1 대비 | 512: full 대비 | 1024: M1 대비 | 1024: full 대비 |
|---|---:|---:|---:|---:|
| M1-improve | 0% | -4.7084% | 0% | -3.0486% |
| improved Plantard l64 scalar | +40.3929% | +33.7827% | +25.6894% | +21.8576% |
| original Plantard l32 scalar | +19.2709% | +13.6552% | +12.2498% | +8.8278% |
| original Plantard l32 full MVE | +4.9410% | 0% | +3.1445% | 0% |
| original Plantard l32 hybrid MVE | +0.3406% | **-4.3838%** | +0.2242% | **-2.8312%** |

양수는 느려짐, 음수는 빨라짐이다.

## 통계 범위

API마다 고정 seed 10개 batch를 사용했다. batch마다 warm-up 10회 뒤 10회를
한 블록으로 측정해 API별 정확히 100회다. 아래 keygen 값은
`mean / median / minimum / population SD`다.

| 후보 | FN-DSA-512 | FN-DSA-1024 |
|---|---|---|
| M1-improve | 52,029,177.60 / 46,058,121 / 42,878,203 / 10,549,634.50 | 262,683,600.70 / 222,286,354 / 161,448,186 / 98,305,434.37 |
| improved Plantard l64 scalar | 70,799,066.70 / 64,662,354 / 61,482,195 / 10,813,535.57 | 320,826,855.40 / 279,390,449.5 / 216,596,199 / 101,422,547.62 |
| original Plantard l32 scalar | 60,992,885.30 / 54,933,932 / 51,754,069 / 10,687,326.45 | 290,451,803.90 / 249,516,069 / 187,662,022 / 99,920,692.17 |
| original Plantard l32 full MVE | 54,318,738.50 / 48,333,867.5 / 45,154,003 / 10,570,954.38 | 269,798,052.80 / 229,276,095 / 168,273,477 / 98,622,264.06 |
| original Plantard l32 hybrid MVE | 52,186,777.80 / 46,214,987.5 / 43,034,959 / 10,550,867.32 | 263,185,981.70 / 222,784,762.5 / 161,940,188 / 98,316,328.43 |

keygen은 내부 rejection sampling 때문에 seed별 분산이 크다. 같은 고정 seed
집합과 raw batch를 사용했고 중앙값·평균·최솟값·SD를 함께 보존했다.

## 직접 NTT/iNTT cycle

10 batches × 100 calls의 batch median이다. Plantard 수치는 실제 함수 안의
per-prime context 및 on-the-fly root 변환 비용을 포함한다. 공통
`mp_mkgmigm()` table 생성은 함수 호출 밖이라 이 표에서는 제외되지만 전체
keygen에는 포함된다.

### Forward NTT

| logn | M1 | l64 scalar | l32 scalar | full MVE | hybrid MVE |
|---:|---:|---:|---:|---:|---:|
| 4 | 375 | 2,837 | 1,619 | 822 | 384 |
| 5 | 765 | 6,067 | 3,302 | 1,444 | 1,047 |
| 6 | 1,660 | 13,671 | 7,129 | 3,110 | 1,666 |
| 7 | 3,699 | 30,102.5 | 15,628 | 6,372 | 3,962 |
| 8 | 8,180 | 67,506 | 34,383 | 14,842 | 8,183 |
| 9 | 18,255 | 147,344.5 | 75,479.5 | 31,304 | 18,463 |
| 10 | 39,960 | 325,126 | 164,608 | 72,270 | 39,996 |

### Inverse NTT

| logn | M1 | l64 scalar | l32 scalar | full MVE | hybrid MVE |
|---:|---:|---:|---:|---:|---:|
| 4 | 429 | 2,963 | 1,753 | 904 | 442 |
| 5 | 895 | 6,337 | 3,642 | 1,636 | 1,192 |
| 6 | 1,977 | 14,399 | 7,998 | 3,581 | 1,993 |
| 7 | 4,424 | 31,667 | 17,583 | 7,435 | 4,752 |
| 8 | 9,876 | 71,281.5 | 38,915 | 17,340 | 9,895 |
| 9 | 22,023 | 155,376 | 85,343 | 36,802 | 22,454 |
| 10 | 48,507 | 343,671 | 186,675 | 84,792.5 | 48,493 |

hybrid의 even-logn 경로는 M1과 산술적으로 동일하다. 그 행의 수 cycle 차이는
잡음이다. odd singleton Plantard도 M1을 이기지 못했다.

## 정확성·KAT·상수시간

- 모든 후보의 22개 고정-seed digest가 M1 및 host oracle과 line-by-line
  동일했다.
- 정상 keygen/sign/verify, 변조 signature, 변조 message 거부를 통과했다.
- 308 primes, logn 4..10의 forward/inverse/round-trip 최대 오차는 0이다.
- CFSR/HFSR/AFSR=0, TCM ECC MSCR은 시작/끝 `0x1300a`다.
- P2 full/hybrid production disassembly에는 function call과
  `UDIV`/`SDIV`가 없다. 분기와 주소는 공개 logn/layer/index만 사용한다.
- P1 scalar compiler output도 division/call이 없고 coefficient 보정은
  branchless다.

이는 기능·정적 constant-time 감사이며 전력/EM TVLA나 형식 증명은 아니다.

## 코드·테이블·스택 비용

| 후보 | ITCM 실행 사용량 | M1 대비 | rodata | 링크 RAM | stack upper | 새 table |
|---|---:|---:|---:|---:|---:|---:|
| M1-improve | 108,076 B | 0 | 58,972 B | 225,728 B | 9,624 B | 0 |
| improved Plantard l64 scalar | 109,316 B | +1,240 B | 58,972 B | 225,728 B | 9,624 B | 0 |
| original Plantard l32 scalar | 107,268 B | -808 B | 58,972 B | 225,728 B | 9,624 B | 0 |
| original Plantard l32 full MVE | 109,180 B | +1,104 B | 58,972 B | 225,728 B | 9,624 B | 0 |
| original Plantard l32 hybrid MVE | 108,364 B | +288 B | 58,972 B | 225,728 B | 9,624 B | 0 |

64-bit `bp` gm/igm table을 추가했다면 logn=10에서 양방향 8,192 B가
필요하지만 모든 구현이 on-the-fly 변환을 사용해 실제 증가는 0 B다.

## 실제 측정 조건

- GNU Arm GCC 15.2.1 20251203, Zephyr 4.4.1, 최종 `-O3`.
- CPU/SYSCLK/HCLK/PCLK 800/400/200/200 MHz.
- vectors/text ITCM `0x10000000`, rodata/data/BSS/stack DTCM
  `0x30000000`, 각각 256 KiB.
- live CCR 기준 I/D cache OFF.
- M1과 P2 NTT 시작 주소는 `0x10000330`. iNTT 주소는 앞선 NTT code size에
  따라 달라지지만 cache-off ITCM 실행이며 코드 위치만으로 개선을 주장하지
  않았다.
- 같은 seed, message, warm-up, 반복, timer와 loader를 사용했다.

## 산출물

- [논문·수학 재검토](ORIGINAL_PLANTARD_L32_RESEARCH.md)
- [P1 l32 README](P1_original_l32_scalar/README.md) /
  [상세 결과](P1_original_l32_scalar/result.md)
- [P2 full README](P2_l32_fullMVE/README.md) /
  [상세 결과](P2_l32_fullMVE/result.md)
- [P2 hybrid README](P2_l32_hybridMVE/README.md) /
  [상세 결과](P2_l32_hybridMVE/result.md)
- [검증 모델](verify_original_plantard_l32.py)
- [정적 constant-time 감사](STATIC_CT_AUDIT.md)

원시 보드 로그는 각 상세 결과에서 직접 연결한다.
