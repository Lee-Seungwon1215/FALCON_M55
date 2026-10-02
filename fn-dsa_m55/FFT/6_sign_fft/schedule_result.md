# LDL·split·merge native FP64 수동 ASM 결과

2026-09-28. `6_sign_fft/plan.md`에 따른 구현·연결된 NUCLEO-N657X0-Q 측정 결과.
**채택: LDL L5b, split/merge S6.** SLOTHY 미적용. `Final_code/Before_slothy`에는 반영하지 않았다.
최적화 전 관찰용 [연산비중 기록](sign_profile_result.md)은 그대로 보존했다.

## 1. 전체 서명 결과

내부 계측 OFF, 크기별 100회 평균. 최종 코드와 M55_ref는 동일 ELF 2회 실행 평균이다.
작업 직전 코드는 이미 FFT/iFFT ASM 및 native C LDL이 적용된 **이 폴더의 직전 코드**다.
`Final_code/Before_slothy`나 태초 M55_ref를 이번 작업 직전으로 잘못 표기하지 않는다.

| 항목 | 512 | 1024 |
|---|---:|---:|
| M55_ref — 이번에 같은 프로그램으로 재측정 | 17,422,694.56 | 37,345,907.75 |
| 이번 작업 직전 | 13,203,722.43 | 27,942,998.58 |
| 최종 L5b + S6 | 11,240,353.42 | 23,556,349.54 |
| **이번 작업의 추가 속도 배율** | **1.1747배** | **1.1862배** |
| 이번 작업의 사이클 감소 | 14.8698% | 15.6986% |
| M55_ref 대비 누적 속도 배율 | 1.5500배 | 1.5854배 |
| M55_ref 대비 누적 사이클 감소 | 35.4844% | 36.9239% |

누적 비교에는 기존 NTT·서명 FFT/iFFT·LDL 전환 등의 효과도 포함된다. **이번 수동 스케줄링만으로 1.55~1.59배가 된다는 뜻이 아니다.**
키 준비에 필요한 키생성·검증·출력은 서명 타이머 밖이다. 키생성/검증 성능을 이번에 다시 측정한 결과는 아니다.
동일 입력 반복은 재현성 검사이며 여러 키에 대한 통계적 모집단 추정은 아니다.

## 2. 개별 커널 — 원본 / native C / 최종 ASM

같은 ELF·동일 버퍼, warm-up 3회 + 100회, upper median cycles.
입력 준비·비교는 제외하고 함수 호출·입출력·저장복원은 포함한다.
두 번 이상 반복했으며 큰 커널의 중앙값은 일치했다.

| 함수 | n | 원본 정수 에뮬레이션 | native C | 최종 ASM | C 대비 사이클 감소 | 원본 대비 배율 |
|---|---:|---:|---:|---:|---:|---:|
| `fpoly_LDL_fft()` | 512 | 236,086 | 39,973 | 39,714 | 0.6479% | 5.9447배 |
| `fpoly_LDL_fft()` | 1024 | 472,118 | 79,909 | 79,394 | 0.6445% | 5.9465배 |
| `fpoly_split_fft()` | 512 | 84,237 | 35,003 | 27,456 | 21.5610% | 3.0681배 |
| `fpoly_split_fft()` | 1024 | 168,397 | 69,947 | 54,848 | 21.5863% | 3.0702배 |
| `fpoly_merge_fft()` | 512 | 75,723 | 24,243 | 23,907 | 1.3860% | 3.1674배 |
| `fpoly_merge_fft()` | 1024 | 151,371 | 48,435 | 47,715 | 1.4865% | 3.1724배 |

LDL은 이미 FP64로 바꾼 상태에서 시작했으므로 **추가 이득은 약 0.65%**다.
split/merge의 큰 개선은 정수 FP64 에뮬레이션을 native FP64로 바꾼 효과가 대부분이다.
split에는 원본의 ½배 비트 처리를 유지한 추가 개선이 있다.

## 3. LDL 후보 비교

| 후보 | 방법 | 512 cycles | 1024 cycles |
|---|---|---:|---:|
| L0 | 동결 native C | 39,973 | 79,909 |
| L1 | 기본 ASM | 41,250 | 82,466 |
| L2 | 독립 계산 교차 배치 | 40,226 | 80,418 |
| L3 | 다음 위치 입력 선행 읽기 | 40,734 | 81,438 |
| L4 | 두 위치를 순차 처리 | 40,252 | 80,444 |
| L5 | 두 위치 계산 교차 배치 | 40,124 | 80,188 |
| L5b | post-increment LD/ST + 비융합 VMLA (채택) | 39,714 | 79,394 |

L5b는 d0…d7만 사용하여 FP callee-saved 저장을 없앴다. 함수 내부 helper 호출이나 계수 spill은 없다.
`VMLA`는 fused FMA로 바꾼 것이 아니며, 원본의 곱셈 뒤 덧셈 반올림을 유지한다.
한 후보가 모든 레지스터/명령 순서의 전역 최적임을 증명한 실험은 아니다.

## 4. split·merge 후보 비교

| 후보 | 변경 내용 | split 512 / 1024 | merge 512 / 1024 |
|---|---|---:|---:|
| C | 동결 native C | 35,003 / 69,947 | 24,243 / 48,435 |
| S0 | 기본 ASM, FP 곱셈으로 ½배 | 34,688 / 69,312 | 24,125 / 48,189 |
| S1 | 원본의 signed-zero 호환 지수 비트 보정 | 27,455 / 54,847 | 24,125 / 48,189 |
| S2 | 독립적인 복소곱 계산 교차 배치 | 27,455 / 54,847 | 24,125 / 48,189 |
| S3 | 두 위치 묶음 | 27,489 / 54,881 | 23,904 / 47,712 |
| S4 | 단일 위치 twiddle 선행 읽기 | 27,455 / 54,847 | 24,125 / 48,189 |
| S4pair | 두 위치 twiddle 선행 읽기 | 27,489 / 54,881 | 23,904 / 47,712 |
| S5 | split 단일 + merge n≥128 묶음 + n=4 전용 | 27,456 / 54,848 | 23,969 / 47,841 |
| S6 | S5 + 4-byte hot-loop 정렬 (채택) | 27,456 / 54,848 | 23,907 / 47,715 |

S3의 split은 저장복원 비용 때문에 단일 처리보다 느렸다. merge 두 위치 묶음은 작은 크기에서 손해여서 n≥128에만 사용한다.
미리 읽기를 넣었다고 무조건 빨라지지는 않았다. S4/S4pair는 해당 비교에서 추가 이득이 없었다.
S5에서 생긴 정렬 손실을 S6의 4-byte 루프 정렬로 줄였다. 최종 재빌드도 같은 큰 커널 중앙값을 재현했다.

### 재귀에 필요한 작은 크기까지 확인

| n | split native C → ASM | merge native C → ASM |
|---|---:|---:|
| 2 | 56 → 47 | 50 → 45 |
| 4 | 332 → 262 | 240 → 229 |
| 8 | 605 → 492 | 429 → 443 |
| 16 | 1,151 → 920 | 807 → 819 |
| 32 | 2,243 → 1,776 | 1,563 → 1,571 |
| 64 | 4,427 → 3,488 | 3,075 → 3,075 |
| 128 | 8,795 → 6,912 | 6,099 → 6,051 |
| 256 | 17,531 → 13,760 | 12,147 → 12,003 |
| 512 | 35,003 → 27,456 | 24,243 → 23,907 |
| 1024 | 69,947 → 54,848 | 48,435 → 47,715 |

**merge는 모든 크기에서 C보다 빠르지는 않다.** n=8…32에서는 소폭 손해가 남는다.
다만 n=4 전용 경로와 큰 크기 이득을 함께 보면, 실제 재귀 호출 수로 가중한 커널 합은 512에서 C 413,082 → ASM 411,450,
1024에서 923,034 → 918,330 cycles다. 이는 개별 측정의 가중합이지 전체 서명 직접 측정을 대체하지 않는다.
분기·외부 C helper를 추가해 이 작은 구간만 선택하는 배포용 백엔드 구조는 만들지 않았다.

## 5. 전환 단계별 전체 서명

각 중간 후보를 실제로 빌드·보드 측정했다. 중간 후보는 100회 한 번, 최종은 두 번이다.
같은 입력·옵션·메모리 정책이지만 ELF 내 함수 주소가 모두 같지는 않다.

| 단계 | 512 평균 cycles | 1024 평균 cycles |
|---|---:|---:|
| 직전 native C LDL / 원본 split·merge | 13,203,722.43 | 27,942,998.58 |
| L5b만 적용 | 13,186,581.44 | 27,908,705.56 |
| L5b + split만 native C | 12,310,587.42 | 25,943,343.57 |
| L5b + merge만 native C | 12,281,668.42 | 25,869,448.56 |
| L5b + split·merge 모두 native C | 11,405,674.42 | 23,904,086.52 |
| 최종 L5b + split·merge ASM | 11,240,353.42 | 23,556,349.54 |

LDL-only 전체 변화에는 배치 효과가 섞일 수 있다. 전체 약 0.13% 변화 모두를 LDL 명령 감소의 순수 효과로 해석하지 않는다.
이번에는 모든 함수 절대 주소를 고정한 추가 실험까지 수행하지 않았다. LDL 작은 이득은 동일 ELF 커널 반복 결과로 한정해 해석한다.
split·merge를 합친 최종 전체 이득은 같은 입력의 반복 실행에서 재현됐다.

## 6. 정확성·KAT·서명검증·상수시간 점검

| 검사 | 결과 |
|---|---|
| LDL 원본 대비 | 1,280 배열 비교/실행, 실패 0, guard 0 |
| split·merge 원본/native C/ASM | 5,120 배열 비교/실행, 실패 0, guard 0 |
| 기존 FFT/iFFT 회귀 | 3,840 배열 비교, 실패 0, guard 0 |
| ASM ABI | LDL 10회, split·merge 20회, FFT/iFFT 20회 통과 |
| 서명 KAT | 90/90 일치, 정상 검증·변조 거부 통과 |
| 키생성 KAT | 기존 300 + 추가 300 모두 일치, NTRU 방정식 통과 |
| API | 정상 64, 잘못된 입력 3,902 거부, 실패/guard 0 |
| 전체 서명 | 크기별 100개 seed × 2회, 출력 지문·검증·변조 거부 통과 |
| fault / 배치 | CFSR/HFSR/AFSR 0, 시작·종료 TCM=0x99, ECC 유지 |

유효 normal/zero 영역에서 무작위·지수/가수 경계·상쇄·signed zero를 시험했다. 원본 대비 출력 오차는 **시험한 입력에서 비트 차이 0**이다.
NaN/Inf/subnormal과 원본 계약 밖 입력까지 동등성을 주장하지 않는다.
ABI probe는 callee-saved r4…r11/d8…d15 보존을 확인한다. 입력 불변 및 배열 guard도 검사했다.

정적 검사에서 새 세 함수는 helper 호출·VFMA/VFMS·수치변환 VCvt·FP 비교를 사용하지 않는다.
분기/반복 수는 공개 logn 및 공개 인덱스에만 의존한다. 계수값은 주소·분기 조건에 사용하지 않는다.
8입력군×100회 timing screen의 동일 크기 전체 관측 범위는 LDL 최대 2 cycles, split/merge 0 cycles, 기존 FFT/iFFT 최대 1 cycle이다.
VDIV 별도 20입력군×100회×32반복은 모든 군에서 1,158 cycles였다.
이는 **경험적 스크리닝 통과**이며, 모든 입력의 상수시간 증명이나 전력·EM TVLA가 아니다.
서명 전체에는 원래의 샘플러 거부 루프 등이 있으므로 전체 서명 cycles가 모든 seed에서 동일하다고 주장하지 않는다.

## 7. 구현 범위·메모리

- 생산 변경: `sign_fpoly.c`에서 세 함수 본체 제거, `sign_ldl_cm55.s`/`sign_split_merge_cm55.s` 직접 추가, Makefile 등록.
- 공통 fpr, FFT/iFFT ASM, sampler, NTT, 키생성 소스는 직전 snapshot과 동일함을 집계기가 확인한다.
- 기존 API 및 fpr 배열의 binary64 비트 형식을 유지한다. 수치 변환 버퍼나 후보 선택 빌드 옵션은 없다.
- LDL ASM 88 B / split 402 B / merge 392 B. 직전 세 함수 본체 854 B → 현재 882 B: 합계 +28 B (패딩·프레임워크 제외).
- 추가 스택 최대: LDL 8 B, split 32 B, merge 96 B. 내부 계수 spill/helper 호출 없음.
- 전체 서명 펌웨어 ITCM 점유 125,400 / 262,144 B, DTCM 245,496 / 262,144 B.
  DTCM 수치는 테스트 배열·런타임·65,536 B main stack 예약도 포함한다. 여유 16,648 B.
- 상세 프로파일 펌웨어 ITCM 128,120 B, DTCM 248,528 B. 여유 13,616 B.
- 빌드 표시의 FLASH/RAM 이름은 이 플랫폼 linker에서 ITCM/DTCM에 매핑된다. 실제 실행/데이터 주소는 0x1000… / 0x3000…다.
- standalone Makefile 빌드 성공. 기존 헤더의 unused static helper 경고 외 새 오류 없음.
- `Final_code/Before_slothy`는 시작 때 저장한 전체 C/H/S·Makefile SHA와 동일하다.
  [확인 목록](validation/before_slothy_unchanged.sha256)을 보존했다.

## 8. 측정 조건

NUCLEO-N657X0-Q, serial 003C00223335510735383531, CPU/SYS/HCLK 800/400/200 MHz.
ITCM 코드 / DTCM 상수·데이터·스택, 각각 256 KiB, cache OFF, ECC ON.
GCC 15.2.1, Zephyr 4.4.1, 고정 mlkem-native 플랫폼. O3, cortex-m55, fpv5-d16, hard-float,
`-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
M55_ref는 원래 M4/M55 ASM을 활성화한 채 시험하며 C-only 비교가 아니다.
서명 입력은 `validation/sign_perf.c`에 고정되어 있고, 지문은 512 `9895079d`, 1024 `a020dd02`로 전 단계 일치한다.
이전 다른 harness의 전체 서명 수치와 직접 섞지 않았다.

## 9. 원자료·재현

- [집계 JSON](validation/schedule_summary.json) / [집계기](validation/analyze_schedule.py)
- [후보별 run ID](validation/schedule_candidates.json): 각 경로의 `production_sources.tar.gz`에 탈락 후보 소스도 보존.
- [최종 통합 비중](schedule_profile_result.md): 100% 표는 별도 파일. 이전 관찰용 표를 덮어쓰지 않음.
- [실행 방법](validation/README.md)

| 검사 | 최종 로그 |
|---|---|
| candidate_api | [20260928T104228Z](validation/results/candidate_api/20260928T104228Z/raw.log) |
| candidate_extra | [20260928T104141Z](validation/results/candidate_extra/20260928T104141Z/raw.log) |
| candidate_kat | [20260928T104051Z](validation/results/candidate_kat/20260928T104051Z/raw.log) |
| candidate_kernel | [20260928T104254Z](validation/results/candidate_kernel/20260928T104254Z/raw.log) |
| candidate_ldl | [20260928T104009Z](validation/results/candidate_ldl/20260928T104009Z/raw.log), [20260928T104352Z](validation/results/candidate_ldl/20260928T104352Z/raw.log) |
| candidate_poly | [20260928T103127Z](validation/results/candidate_poly/20260928T103127Z/raw.log), [20260928T104000Z](validation/results/candidate_poly/20260928T104000Z/raw.log), [20260928T104343Z](validation/results/candidate_poly/20260928T104343Z/raw.log) |
| candidate_sigkat | [20260928T104037Z](validation/results/candidate_sigkat/20260928T104037Z/raw.log) |
| candidate_sign | [20260928T103753Z](validation/results/candidate_sign/20260928T103753Z/raw.log), [20260928T104020Z](validation/results/candidate_sign/20260928T104020Z/raw.log) |
| candidate_sign_control | [20260928T104418Z](validation/results/candidate_sign_control/20260928T104418Z/raw.log), [20260928T104452Z](validation/results/candidate_sign_control/20260928T104452Z/raw.log) |
| candidate_sign_detail | [20260928T104401Z](validation/results/candidate_sign_detail/20260928T104401Z/raw.log), [20260928T104435Z](validation/results/candidate_sign_detail/20260928T104435Z/raw.log) |
| original_sign | [20260928T104306Z](validation/results/original_sign/20260928T104306Z/raw.log), [20260928T104325Z](validation/results/original_sign/20260928T104325Z/raw.log) |

각 로그 옆에 ELF, 역어셈블, compile_commands, SHA manifest, 생산 소스 snapshot이 있다.
후보 기록·이전 측정은 삭제하지 않았다. 현재 미최적화인 split_selfadj·점별 연산·deepest·sampler로 범위를 넓히지 않았다.

