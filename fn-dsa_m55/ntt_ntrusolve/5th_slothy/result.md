# K4-C 대비 RNS Slothy A/B 측정

기준: 현재 ref_slothy 복사본. q-NTT Slothy A는 세 후보에서 동일하며 RNS의 kgen_mp31_cm55.s만 다르다.

## 조건

- NUCLEO-N657X0-Q / Cortex-M55 r1p1, ST-LINK 003C00223335510735383531.
- CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz; GCC 15.2.1, 암호 소스 마지막 옵션 -O3.
- 기존 mlkem-native 기반 TCM 설정 유지: 코드 ITCM, 상수·데이터·스택 DTCM; 각 256 KiB 구성.
- 기존 ECC 우회 방침 그대로 유지: 코드 사용량은 하위 128 KiB 이내, 상수는 DTCM. ECC 검사 ON.
- 런타임 CCR=0x611: I/D cache OFF. Kconfig의 icache/dcache=1은 지원 구성이지 실제 활성 상태가 아니다.
- 측정 전용 고정 배치: mp_NTT=0x10000400, mp_iNTT=0x10001000, small=0x10002000. 다른 함수들의 주소·크기도 동일.
- 커널: prime[0], logn=4..10, 방향별 10 batches × 100 calls. root preparation 포함, 상수표 생성 제외.
- 전체 API: 라운드별 10 deterministic seeds × 10 timed calls = 100회, batch마다 warmup 10회. 아래 수치는 산술평균 cycles/call.
- 개선율=(baseline-candidate)/baseline×100. 양수는 빠름, 음수는 느림.

## 커널 사이클

| logn | 방향 | baseline | A | A 개선 | B | B 개선 |
|---:|---|---:|---:|---:|---:|---:|
| 4 | forward | 323.77 | 305.77 | +5.5595% | 309.77 | +4.3241% |
| 4 | inverse | 349.77 | 317.77 | +9.1489% | 318.77 | +8.8630% |
| 5 | forward | 725.77 | 687.77 | +5.2358% | 683.77 | +5.7870% |
| 5 | inverse | 742.77 | 640.77 | +13.7324% | 636.77 | +14.2709% |
| 6 | forward | 1,501.77 | 1,405.77 | +6.3925% | 1,395.77 | +7.0583% |
| 6 | inverse | 1,522.77 | 1,314.77 | +13.6593% | 1,305.77 | +14.2503% |
| 7 | forward | 3,484.77 | 3,260.77 | +6.4280% | 3,238.77 | +7.0593% |
| 7 | inverse | 3,417.77 | 2,865.77 | +16.1509% | 2,868.77 | +16.0631% |
| 8 | forward | 7,593.77 | 7,002.86 | +7.7815% | 6,957.77 | +8.3753% |
| 8 | inverse | 7,351.77 | 6,232.86 | +15.2196% | 6,225.77 | +15.3160% |
| 9 | forward | 17,100.95 | 15,914.77 | +6.9364% | 15,820.77 | +7.4860% |
| 9 | inverse | 16,468.95 | 13,683.86 | +16.9112% | 13,765.86 | +16.4132% |
| 10 | forward | 36,961.95 | 34,016.86 | +7.9679% | 33,829.95 | +8.4736% |
| 10 | inverse | 35,442.95 | 29,810.96 | +15.8903% | 29,917.04 | +15.5910% |

## 전체 API — v1

| 크기 | 연산 | baseline | A | A 개선 | B | B 개선 |
|---:|---|---:|---:|---:|---:|---:|
| 512 | 키생성 | 52,455,131.07 | 52,221,788.10 | +0.4448% | 52,216,827.14 | +0.4543% |
| 512 | 서명 | 17,990,451.46 | 17,990,418.95 | +0.0002% | 17,990,418.84 | +0.0002% |
| 512 | 검증 | 315,613.70 | 315,591.90 | +0.0069% | 315,591.92 | +0.0069% |
| 1024 | 키생성 | 265,475,880.47 | 264,744,239.98 | +0.2756% | 264,733,366.72 | +0.2797% |
| 1024 | 서명 | 38,641,380.65 | 38,641,358.83 | +0.0001% | 38,641,402.20 | -0.0001% |
| 1024 | 검증 | 618,035.60 | 618,079.26 | -0.0071% | 618,057.40 | -0.0035% |

## 역순 커널 재측정

| 후보 | v1 대비 v2 최대 상대 차이 |
|---|---:|
| baseline | 0.00000607% |
| slothyA | 0.00001604% |
| slothyB | 0.00000887% |

## 최종 ref_slothy 경로 재측정

동일한 고정 배치에서 이 경로 자체의 소스를 새로 빌드했다.

| 크기 | 연산 | ref_slothy cycles | baseline 대비 개선 |
|---:|---|---:|---:|
| 512 | 키생성 | 52,221,788.25 | +0.4448% |
| 512 | 서명 | 17,990,418.76 | +0.0002% |
| 512 | 검증 | 315,591.90 | +0.0069% |
| 1024 | 키생성 | 264,744,239.33 | +0.2756% |
| 1024 | 서명 | 38,641,358.54 | +0.0001% |
| 1024 | 검증 | 618,079.21 | -0.0071% |

## 코드 크기 (세 RNS 함수 본문 합계)

| 후보 | bytes | 기준 대비 |
|---|---:|---:|
| baseline | 3754 | +0 |
| slothyA | 3754 | +0 |
| slothyB | 6694 | +2940 |

고정 배치를 위한 미사용 패딩은 후보 알고리즘의 코드 크기에 포함하지 않는다. 함수별 section 및 로컬 stride literal 복사는 측정 배치를 위한 동일한 조정이다.

## 검증

- 세 후보: 308개 소수 × logn 4..10 = 2,156개 변환 설정에서 forward/iNTT/왕복 오류 0.
- rounding Montgomery: 18,923,520 cases, 불일치·범위 오류 0.
- 독립 inverse 입력 포함 17,248개 경계/랜덤 패턴 검사: 불일치·비정규 출력·버퍼 guard 손상 0.
- q-NTT 512/1024도 기존 C oracle과 일치. 프로젝트의 deterministic host KAT/digest와 서명·변조 거부 검사 통과.
- 2,944개의 별도 호스트 명령 에뮬레이션 검사: 최종 레지스터·메모리와 순서 있는 메모리 접근 trace 일치.
- 정적 점검: 새 secret-dependent branch/address 없음, 공개 크기/포인터 기반 루프만 사용. ABI 저장/복원 유지, FP·나눗셈·새 함수 호출 없음.
- 한계: 위 검사는 형식적 상수시간 증명, dudect 또는 전력/EM 부채널 검사가 아니다. Slothy 모델 cycle 추정치를 보드 측정값으로 사용하지 않음.

## 채택 상태

최종 채택 및 ref_slothy 반영은 `adoption.md` 참고. 해당 파일이 없으면 아직 미반영.

## 원시 로그

- [baseline audit 원시 로그](measurement/results/baseline-audit-v1/runs/pilot-20260917T031816Z/raw.log)
- [slothyA audit 원시 로그](measurement/results/slothyA-audit-v1/runs/pilot-20260917T031854Z/raw.log)
- [slothyB audit 원시 로그](measurement/results/slothyB-audit-v1/runs/pilot-20260917T032053Z/raw.log)
- [baseline v1 100회 원시 로그](measurement/results/baseline-perf-v1/runs/full-20260917T032237Z/raw.log)
- [slothyA v1 100회 원시 로그](measurement/results/slothyA-perf-v1/runs/full-20260917T032418Z/raw.log)
- [slothyB v1 100회 원시 로그](measurement/results/slothyB-perf-v1/runs/full-20260917T032600Z/raw.log)
- [baseline 역순 v2 커널 로그](measurement/results/baseline-audit-v2/runs/pilot-20260917T032825Z/raw.log)
- [slothyA 역순 v2 커널 로그](measurement/results/slothyA-audit-v2/runs/pilot-20260917T032817Z/raw.log)
- [slothyB 역순 v2 커널 로그](measurement/results/slothyB-audit-v2/runs/pilot-20260917T032809Z/raw.log)
- [최종 ref_slothy 100회 로그](measurement/results/ref_slothy-perf-adopted_a/runs/full-20260917T033122Z/raw.log)

- [정적 감사](measurement/results/static_audit.json)
- [Slothy 생성 기록](tooling/logs/manifest.json)
- [독립 스케줄 검사](tooling/logs/independent_check.json)
