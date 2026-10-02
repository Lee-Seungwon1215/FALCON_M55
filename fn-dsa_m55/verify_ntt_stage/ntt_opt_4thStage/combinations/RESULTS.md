# Stage-4 조합 최종 비교

측정일: 2026-09-13. **12/12 조합의 pilot + 100회 full 측정 완료, 모두 검증 통과.**
수정 전 대표 2개와 `ntt_opt` 기준 코드도 같은 보드에서 새로 측정했다.
총 15개 full run의 원시 로그를 재검사했다.

변경 내용·논문 근거는 [REVISION.md](REVISION.md), 검증·소스 식별값은
[VALIDATION.md](VALIDATION.md), 기계 판독용 전체 결과는
[comparison.json](results/comparison.json)에 있다.

## 결론

- 512: **S1B_S2B_S3A**가 이번 측정의 keygen/sign/verify 모두 최저 cycle이다.
- 1024: **S1B_S2B_S3C**가 keygen/verify 최저이고, **S1B_S2B_S3A**가 sign 최저이다.
- 하나의 조합으로 모든 작업을 최대로 개선하는 결과는 아니다. 서명과 코드 크기를
  우선하면 S1B_S2B_S3A, 1024 keygen/verify를 우선하면 S1B_S2B_S3C가 유리하다.
- 이후 최종 채택에서는 512·1024 모두 `S1B_S2B_S3A`를 `ntt_opt`에 통합했다.
  [통합 경로 재측정](../../ntt_opt/result.md). 아래 표의 `ntt_opt 기준`은 통합 전
  [보존한 1~3단계 코드](../integration/before/README.md)이며, 조합별 소스는 그대로다.

| degree / 작업 | 이번 측정 최저 조합 | 기준 cycle/call | 조합 cycle/call | 기준 대비 cycle 감소 |
|---|---|---:|---:|---:|
| 512 keygen | S1B_S2B_S3A | 51,722,695 | 51,716,562 | 0.0119% |
| 512 sign | S1B_S2B_S3A | 17,150,930 | 17,145,670 | 0.0307% |
| 512 verify | S1B_S2B_S3A | 323,738 | 323,007 | 0.2258% |
| 1024 keygen | S1B_S2B_S3C | 260,391,747 | 260,358,220 | 0.0129% |
| 1024 sign | S1B_S2B_S3A | 36,748,666 | 36,737,445 | 0.0305% |
| 1024 verify | S1B_S2B_S3C | 626,546 | 624,382 | 0.3454% |

이는 **전체 키생성·서명·검증 API 시간**이지 NTT 함수만의 시간이 아니다.
1~3단계가 적용된 `ntt_opt` 대비 추가 개선율이다. 원래 M4/비최적화 구현 대비
개선율과 혼동하면 안 된다. 이번 수치는 단일 100회 run의 고정 입력 비교이며,
미세한 차이에 대해 통계적 유의성이나 모든 입력에서의 우위를 주장하지 않는다.

## 동일 측정 조건

- NUCLEO-N657X0-Q, Cortex-M55 r1p1, probe `003C00223335510735383531`.
- CPU / SYSCLK / HCLK = **800 / 400 / 200 MHz**. 런타임 레지스터로 확인했다.
- ITCM에 vectors/code, DTCM에 전역 상수·데이터·스택. 각각 256 KiB 구성.
  코드는 현재 하위 128 KiB 안에 들어간다. I/D cache OFF, TCM ECC ON.
- GNU Arm **15.2.1**, Zephyr **4.4.1**, FN-DSA 최종 유효 옵션 **-O3**,
  `-mcpu=cortex-m55 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard`.
  공통 빌드 명령에는 앞선 `-O2`도 있으나 뒤의 `-O3`가 유효하다.
- 12개 후보의 정규화한 C/ASM 컴파일 명령과 Zephyr `.config`가 기준 코드와 같다.
  `FNDSA_ASM_CORTEXM4=1`, `FNDSA_ASM_CORTEXM55=1`, `CONFIG_FPU=y` 유지.
- 각 degree·작업마다 **10개 입력 batch × 10회 측정 = 100회**.
  각 batch에는 별도 10회 warm-up이 있다. 100개의 서로 다른 입력은 아니다.
- 10-call block을 `k_cycle_get_64()`로 계측하고, 10개 block total의
  upper median을 10으로 나눈 정수값을 보고한다. 인터럽트 허용 조건이다.
- 고정 seed 생성 규칙, 메시지 `blah`, raw mode, 빈 context가 모두 같다.
  API 내부 재시도는 포함하며 seed 준비·로그·digest·변조 검사는 계측 밖이다.
- 환경은 `mlkem-native` commit `637d076aa113d8faaec2277ed4a46b657acaf35f`의
  Nucleo 설정을 기반으로 한다. **upstream과 무수정 동일 환경은 아니다.**
  기존 FN-DSA용 DTCM 상수 배치·초기화 대응과 FPU 설정을 그대로 재사용했다.
  차이는 [공통 측정 환경](../../measurement_mlkem_native/README.md)에 기록돼 있다.

## 512 전체 결과

단위: upper median cycle/call, 작을수록 빠르다.

| 조합 | keygen | sign | verify | verify cycle 감소 |
|---|---:|---:|---:|---:|
| ntt_opt 기준 | 51,722,695 | 17,150,930 | 323,738 | 0.0000% |
| S1A_S2A_S3A | 51,720,019 | 17,148,551 | 323,391 | 0.1072% |
| S1A_S2A_S3B | 51,721,159 | 17,149,682 | 323,578 | 0.0494% |
| S1A_S2A_S3C | 51,721,531 | 17,155,440 | 323,680 | 0.0179% |
| S1A_S2B_S3A | 51,717,330 | 17,146,247 | 323,071 | 0.2060% |
| S1A_S2B_S3B | 51,718,470 | 17,147,378 | 323,258 | 0.1483% |
| S1A_S2B_S3C | 51,718,662 | 17,150,767 | 323,394 | 0.1063% |
| S1B_S2A_S3A | 51,718,867 | 17,147,686 | 323,295 | 0.1368% |
| S1B_S2A_S3B | 51,720,006 | 17,148,818 | 323,482 | 0.0791% |
| S1B_S2A_S3C | 51,720,379 | 17,154,576 | 323,524 | 0.0661% |
| S1B_S2B_S3A | 51,716,562 | 17,145,670 | 323,007 | 0.2258% |
| S1B_S2B_S3B | 51,717,703 | 17,146,802 | 323,194 | 0.1680% |
| S1B_S2B_S3C | 51,717,895 | 17,150,192 | 323,330 | 0.1260% |

## 1024 전체 결과

| 조합 | keygen | sign | verify | verify cycle 감소 |
|---|---:|---:|---:|---:|
| ntt_opt 기준 | 260,391,747 | 36,748,666 | 626,546 | 0.0000% |
| S1A_S2A_S3A | 260,378,986 | 36,742,726 | 625,698 | 0.1353% |
| S1A_S2A_S3B | 260,384,002 | 36,745,402 | 626,253 | 0.0468% |
| S1A_S2A_S3C | 260,370,320 | 36,749,388 | 625,014 | 0.2445% |
| S1A_S2B_S3A | 260,378,987 | 36,741,766 | 625,378 | 0.1864% |
| S1A_S2B_S3B | 260,384,002 | 36,744,443 | 625,824 | 0.1152% |
| S1A_S2B_S3C | 260,368,776 | 36,743,307 | 624,844 | 0.2716% |
| S1B_S2A_S3A | 260,368,536 | 36,738,406 | 625,218 | 0.2120% |
| S1B_S2A_S3B | 260,373,333 | 36,741,081 | 625,664 | 0.1408% |
| S1B_S2A_S3C | 260,359,868 | 36,745,068 | 624,534 | 0.3211% |
| S1B_S2B_S3A | 260,368,536 | 36,737,445 | 624,898 | 0.2630% |
| S1B_S2B_S3B | 260,373,442 | 36,740,122 | 625,344 | 0.1918% |
| S1B_S2B_S3C | 260,358,220 | 36,738,988 | 624,382 | 0.3454% |

## 충돌 해결 자체의 수정 전후 비교

v1은 조합 안의 충돌 구간에서 S3 적용을 줄였던 코드이고, v2가 이번 수정본이다.
보존한 이전 소스·ELF를 실제 보드에서 다시 측정했다. 양수 감소량은 개선이다.

| 조합 | degree / 작업 | v1 | v2 | cycle 감소 |
|---|---|---:|---:|---:|
| S1B_S2B_S3B | 512 keygen | 51,718,855 | 51,717,703 | 1,152 |
| S1B_S2B_S3B | 512 sign | 17,147,665 | 17,146,802 | 863 |
| S1B_S2B_S3B | 512 verify | 323,290 | 323,194 | 96 |
| S1B_S2B_S3B | 1024 keygen | 260,373,444 | 260,373,442 | 2 |
| S1B_S2B_S3B | 1024 sign | 36,740,121 | 36,740,122 | -1 |
| S1B_S2B_S3B | 1024 verify | 625,344 | 625,344 | 0 |
| S1B_S2B_S3C | 512 keygen | 51,720,307 | 51,717,895 | 2,412 |
| S1B_S2B_S3C | 512 sign | 17,155,720 | 17,150,192 | 5,528 |
| S1B_S2B_S3C | 512 verify | 323,636 | 323,330 | 306 |
| S1B_S2B_S3C | 1024 keygen | 260,369,659 | 260,358,220 | 11,439 |
| S1B_S2B_S3C | 1024 sign | 36,751,556 | 36,738,988 | 12,568 |
| S1B_S2B_S3C | 1024 verify | 625,114 | 624,382 | 732 |

- S1B_S2B_S3B의 수정 대상은 512 forward 3-layer이다. 1024의 ±1~2 cycle
  차이는 개선으로 해석하지 않는다.
- S1B_S2B_S3C는 동일 입력끼리 짝지은 **60개 batch 비교 모두** v1보다 빨랐다.
  각 batch의 원래 total과 차이는 `comparison.json`의 `paired`에 보존했다.
- 수정에는 명령 순서뿐 아니라 S2-B의 scalar-vector 명령 선택 변경도 포함한다.
  개별 S1/S2/S3 효과를 완전히 독립적으로 분리한 factorial 실험은 아니다.

## 메모리

DTCM 예약량은 모든 조합 **225,728 / 262,144 B**, 여유 **36,416 B**.
main stack 사용 상한은 모든 full run **9,624 B**이다.

| 그룹 (S1-A/B 동일) | ITCM 코드 B | 현재 하위 128 KiB 내 여유 B |
|---|---:|---:|
| S2-A + S3-A/B | 106,316 | 24,756 |
| S2-A + S3-C | 108,556 | 22,516 |
| S2-B + S3-A/B | 106,236 | 24,836 |
| S2-B + S3-C | 108,492 | 22,580 |

S2-B 조합은 v1보다 코드가 80 B 줄었으며, 이번 수정에서 새 stack spill은 없다.
S3-C는 S3-A/B보다 약 2.2 KiB 큰 prologue/epilogue 비용을 갖는다.
ELF의 전체 `text` 합계와 실제 ITCM 점유는 다를 수 있어 메모리 주소/section으로 확인했다.

## 원시 로그

| 조합 | full log | 승인 manifest |
|---|---|---|
| baseline | [raw.log](results/baseline/runs/full-20260913T111745Z/raw.log) | [full_validated.json](results/baseline/full_validated.json) |
| S1A_S2A_S3A | [raw.log](results/S1A_S2A_S3A/runs/full-20260913T113200Z/raw.log) | [full_validated.json](results/S1A_S2A_S3A/full_validated.json) |
| S1A_S2A_S3B | [raw.log](results/S1A_S2A_S3B/runs/full-20260913T113345Z/raw.log) | [full_validated.json](results/S1A_S2A_S3B/full_validated.json) |
| S1A_S2A_S3C | [raw.log](results/S1A_S2A_S3C/runs/full-20260913T113529Z/raw.log) | [full_validated.json](results/S1A_S2A_S3C/full_validated.json) |
| S1A_S2B_S3A | [raw.log](results/S1A_S2B_S3A/runs/full-20260913T113714Z/raw.log) | [full_validated.json](results/S1A_S2B_S3A/full_validated.json) |
| S1A_S2B_S3B | [raw.log](results/S1A_S2B_S3B/runs/full-20260913T113859Z/raw.log) | [full_validated.json](results/S1A_S2B_S3B/full_validated.json) |
| S1A_S2B_S3C | [raw.log](results/S1A_S2B_S3C/runs/full-20260913T114044Z/raw.log) | [full_validated.json](results/S1A_S2B_S3C/full_validated.json) |
| S1B_S2A_S3A | [raw.log](results/S1B_S2A_S3A/runs/full-20260913T114229Z/raw.log) | [full_validated.json](results/S1B_S2A_S3A/full_validated.json) |
| S1B_S2A_S3B | [raw.log](results/S1B_S2A_S3B/runs/full-20260913T114414Z/raw.log) | [full_validated.json](results/S1B_S2A_S3B/full_validated.json) |
| S1B_S2A_S3C | [raw.log](results/S1B_S2A_S3C/runs/full-20260913T114558Z/raw.log) | [full_validated.json](results/S1B_S2A_S3C/full_validated.json) |
| S1B_S2B_S3A | [raw.log](results/S1B_S2B_S3A/runs/full-20260913T114743Z/raw.log) | [full_validated.json](results/S1B_S2B_S3A/full_validated.json) |
| S1B_S2B_S3B | [raw.log](results/S1B_S2B_S3B/runs/full-20260913T112830Z/raw.log) | [full_validated.json](results/S1B_S2B_S3B/full_validated.json) |
| S1B_S2B_S3C | [raw.log](results/S1B_S2B_S3C/runs/full-20260913T113015Z/raw.log) | [full_validated.json](results/S1B_S2B_S3C/full_validated.json) |
| before_S1B_S2B_S3B | [raw.log](results/before_S1B_S2B_S3B/runs/full-20260913T111415Z/raw.log) | [full_validated.json](results/before_S1B_S2B_S3B/full_validated.json) |
| before_S1B_S2B_S3C | [raw.log](results/before_S1B_S2B_S3C/runs/full-20260913T111600Z/raw.log) | [full_validated.json](results/before_S1B_S2B_S3C/full_validated.json) |

재검사 명령(저장된 결과만 읽고, 보드는 사용하지 않음):

```sh
python3 fn-dsa_m55/ntt_opt_4thStage/check_combination_revision.py
python3 fn-dsa_m55/ntt_opt_4thStage/audit_combinations.py --require-full
```

보드 재측정 예시(이미 해당 소스의 ELF가 빌드되어 있어야 함):

```sh
python3 fn-dsa_m55/ntt_opt_4thStage/run_combinations.py S1B_S2B_S3A pilot
python3 fn-dsa_m55/ntt_opt_4thStage/run_combinations.py S1B_S2B_S3A full
```
