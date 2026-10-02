# ntt_opt_slothy — 최신 통합 결과

## 2026-09-17: RNS Slothy A 포함, 최적화 전 원본과 동일 조건 재측정 완료

현재 이 폴더의 C/H/S 31개를 직접 컴파일했다. 공통 q-NTT Slothy A와
K4-C 기반 RNS Slothy A가 모두 포함된다. 비교군은 NTT 최적화 전 `../M55_ref`
(이전 명칭 `ref`)이며, 두 구현에 동일한 측정 프로그램·링크 배치 정책을 적용했다.

아래는 전체 API **100회 산술평균 cycles/call**이다.

| 크기 | 연산 | 최적화 전 ref | 현재 통합본 | 사이클 감소율 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 57,447,592.09 | 51,471,982.26 | 10.4018% |
| 512 | 서명 | 18,265,777.46 | 17,966,440.59 | 1.6388% |
| 512 | 검증 | 366,759.01 | 315,677.10 | 13.9279% |
| 1024 | 키생성 | 280,951,478.44 | 260,891,457.64 | 7.1400% |
| 1024 | 서명 | 39,215,814.21 | 38,592,060.50 | 1.5906% |
| 1024 | 검증 | 725,746.21 | 618,877.26 | 14.7254% |

M55 800 MHz / GCC 15.2.1 / -O3 / ITCM 코드·DTCM 데이터 / cache OFF / ECC ON.
공통 함수 256개·상수/데이터 심벌 146개와 작업 버퍼·스택의 주소·크기를 일치시켰다.
프로젝트 KAT 출력 해시, 정상 서명검증·변조서명 거부, q-NTT 정확성 검사 통과.
측정 펌웨어는 `../ntt_final_compare/build/ntt_opt_slothy`에 있다.
이전 `build/m55`의 일반 배치 펌웨어를 이번 측정 ELF와 혼동하지 않는다.

**최신 상세 결과·원시 로그·배치 감사·재현 명령:**
[동일 조건 원본 대비 비교](../ntt_final_compare/result.md).
기존 `measurement/run.py`·`measurement/audit.py`는 아래 9월 14일 q-NTT-only 실험용이므로,
현재 누적 구현의 비교 재실행에는 `../ntt_final_compare/README.md`의 명령을 사용한다.

---

## 아래는 2026-09-14 q-NTT Slothy만 적용했던 과거 기록

아래의 소스 개수·경로·해시·성능 수치는 당시 상태이며, 현재 누적 RNS 최적화 결과가 아니다.

2026-09-14 KST. **전체 펌웨어 빌드, 실제 M55 보드의 고정 입력 KAT 회귀검사,
512/1024 키생성·서명·검증 각각 100회 측정, 최종 로그 검증을 완료했다.**
기존 결과를 복사한 것이 아니라 이 폴더의 소스로 새 ELF를 만들고 보드에서 실행했다.
원본 `../ntt_opt` 및 stage-5 후보 소스·측정 결과는 변경하지 않았다.

## 1. 성능 결과

단위는 cycles/call이며 작을수록 빠르다. 각 값은 **10개 배치 평균의 upper median**이다.
배치마다 같은 입력으로 10회 워밍업 후 10회를 묶어서 측정하며, 총 100회가 측정에 포함된다.
10개 배치를 정렬한 6번째 총 사이클을 10으로 나눈 정수값으로, 100개 개별 호출의 중앙값은 아니다.

| 파라미터 | 연산 | 새 `ntt_opt_slothy` | 기존 SLOTHY A | 새 경로 − 기존 A |
|---|---|---:|---:|---:|
| 512 | 키생성 | 51,706,963 | 51,706,963 | 0 |
| 512 | 서명 | 17,135,527 | 17,135,527 | 0 |
| 512 | 검증 | 321,262 | 321,262 | 0 |
| 1024 | 키생성 | 260,350,231 | 260,350,233 | −2 |
| 1024 | 서명 | 36,724,678 | 36,724,678 | 0 |
| 1024 | 검증 | 622,306 | 622,306 | 0 |

기존 A는 `ntt_opt_5thStage/results/slothyA/runs/full-20260913T142157Z`의 과거 실측이다.
이번에 A를 별도로 다시 실행한 것은 아니다. 같은 배치 입력끼리 비교한 60개 배치 평균의
차이는 −2.5~+3.3 cycles/call이고, 새 ELF의 실행 바이트·데이터·함수 주소가 A와 동일하다.
따라서 이번 결과는 **새 경로로 옮긴 A의 성능 재현**으로 해석한다. −2사이클을 추가 최적화 효과로 주장하지 않는다.

### SLOTHY 적용 전 기준과의 참고 비교

적용 전은 현재 `../ntt_opt`와 계산 소스가 동일한 stage-5 `ref`의 과거 실측
(`full-20260913T141611Z`)이다. 이번 측정과 같은 세션에서 다시 실행한 대조군은 아니다.

| 파라미터 | 연산 | SLOTHY 적용 전 | 이번 적용 후 | 사이클 감소율 |
|---|---|---:|---:|---:|
| 512 | 키생성 | 51,716,563 | 51,706,963 | 0.0186% |
| 512 | 서명 | 17,145,671 | 17,135,527 | 0.0592% |
| 512 | 검증 | 323,007 | 321,262 | 0.5402% |
| 1024 | 키생성 | 260,368,534 | 260,350,231 | 0.0070% |
| 1024 | 서명 | 36,737,446 | 36,724,678 | 0.0348% |
| 1024 | 검증 | 624,898 | 622,306 | 0.4148% |

감소율 = `(적용 전 − 적용 후) / 적용 전 × 100`.
이 표는 일반 링크 배치의 전체 키생성·서명·검증 결과이며, NTT/iNTT만의 개선율이 아니다.
적용 전/후 사이에 다른 함수의 실행 주소까지 고정한 실험은 아니므로 순수 스케줄링 효과만
분리한 수치로 인용하지 않는다. [이전 주소 고정 진단](../ntt_opt_5thStage/layout_diagnostic/RESULTS.md)은 별도 실험이다.

## 2. 빌드·보드 조건

| 항목 | 실제 적용·확인 내용 |
|---|---|
| 보드 | NUCLEO-N657X0-Q / STM32N657 / Cortex-M55 r1p1 |
| ST-LINK | `003C00223335510735383531`; M4 보드는 사용하지 않음 |
| CPU / SYSCLK / HCLK | 800 / 400 / 200 MHz; 보드 레지스터로 확인 |
| 환경 | GCC 15.2.1 (`20251203`), Zephyr 4.4.1, 고정된 mlkem-native `637d076aa113d8faaec2277ed4a46b657acaf35f` 기반 측정 하네스 |
| 애플리케이션 최적화 | 계산 소스 23개 컴파일 명령의 마지막 최적화 옵션 `-O3`; 기존 A와 옵션 동일 |
| 주요 타깃 옵션 | `-mcpu=cortex-m55 -mthumb -mabi=aapcs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mfp16-format=ieee -mcmse` |
| 계산 경로 | `FNDSA_ASM_CORTEXM4=1`, `FNDSA_ASM_CORTEXM55=1`; 새 경로의 `mq_cm55.s` 직접 컴파일 |
| 메모리 | ITCM/DTCM 각각 256 KiB; 코드·벡터 ITCM, 상수·데이터·스택 DTCM |
| I/D 캐시 | 실제 OFF: `CCR=0x611`, IC/DC enable 비트 0 |
| TCM | `ITCMCR=DTCMCR=0x49`, 시작·끝 `SYSCFG_CM55TCMCR=0x99` |
| TCM ECC | ON 유지: 시작·끝 `MSCR=0x1300a`; ECC 비활성화하지 않음 |
| wait-state 설정 | 기존 값 유지; ITCMWSDISABLE/DTCMWSDISABLE 비트를 변경하지 않음 |
| 인터럽트 | 기존 조건 유지, `PRIMASK=0`, `BASEPRI=0`; 전체 IRQ OFF 실험 아님 |
| 입력 | 크기별 고정 키/서명 seed 10쌍, 메시지 `blah`, 동일 배치 안에서는 동일 입력 반복 |
| 측정 | 각 크기·연산별 10배치 × (워밍업 10회 + 측정 10회) |
| 타이머 | `k_cycle_get_64()`; 100 ms 자체 점검에서 DWT와 차이 410 cycles |
| 측정 구간 | 10회 호출 블록; 루프·반환값 검사 포함. 출력·seed 준비·digest·변조 검사는 구간 밖 |

`CONFIG_ICACHE=y`, `CONFIG_DCACHE=y`는 지원 설정이며, 이 실행에서 캐시가 켜졌다는 뜻이 아니다.
실제 CCR을 읽어 OFF를 확인했다. 코드 ITCM/상수 DTCM 배치는 이전 ECC 대응이 반영된
기존 FN-DSA 측정 조건을 그대로 유지한 것으로, 수정 없는 upstream ML-KEM 펌웨어와 동일하다는 주장은 하지 않는다.
최종 링크 명령에 보이는 `-O2`와 별개로 계산 소스의 실제 컴파일 옵션은 마지막 `-O3`이다.

이번 빌드에서는 계산 C/H/S 30개가 선택한 A와 동일하고, 컴파일된 계산 C/S 23개가 모두
`ntt_opt_slothy`에서 나오는 것을 확인했다. `mq_cm55.s`는 일반 파일이며 외부 후보 include/링크가 없다.
새 측정 스크립트는 전체 소스 경로를 지정할 뿐 SLOTHY 변환을 빌드 옵션으로 적용하지 않는다.

## 3. 검증 결과와 범위

| 검사 | 결과 |
|---|---|
| 전체 펌웨어 빌드 | 210개 빌드 단계 완료, ELF 생성 성공 |
| 새 경로 소스·ELF 추적 | PASS; 전체 실행 대상 ELF section의 바이트·주소와 모든 함수 바이트·주소가 기존 A와 동일 |
| 보드 사전 실행 | PASS; pilot DIGEST/AUDIT 4개가 host 기대값과 일치 |
| 보드 고정 입력 KAT 회귀 | PASS; 본 측정 DIGEST 20개 + 전체 AUDIT 2개 = 22개 모두 host와 일치 |
| NTT 정확성 | 512/1024 고정 시험 벡터에서 scalar oracle 불일치 0, 최대 모듈러 오차 0 |
| iNTT 왕복 | 512/1024 모두 입력 복원 불일치 0; oracle 왕복도 불일치 0 |
| Barrett 상수곱 | 각 크기에서 정·역방향 상수/입력 2,048쌍 검사, 불일치 0 |
| 키생성·서명·정상 검증 | 워밍업·본 측정의 반환값 검사 모두 PASS |
| 변조 서명 | 크기별 10배치에서 서명 바이트를 변경한 뒤 거부 확인, 총 20건 PASS |
| Fault/ECC 상태 | `CFSR=HFSR=AFSR=0`, 정상 종료 코드 0; ECC ON 상태 유지 |
| 정적 상수시간 회귀 | 분기·스택 구조 유지, 기존 검증 A와 실행 명령 동일 확인 |

여기서 KAT는 **프로젝트의 고정 seed SK/PK/서명 digest 회귀검사**이다.
공식 인증 KAT 전체 또는 upstream `test_fndsa` 전체를 보드에서 실행했다는 뜻은 아니다.
NTT 오차 0은 실행한 시험 입력의 결과이며 입력 공간 전수검사나 수학적 증명은 아니다.

선택한 A의 독립 ISA 모델 816개 회귀검사 기록과 manifest/소스 동일성도 확인했다.
이번 전체 펌웨어 재측정에서 해당 816개 모델 사례를 새로 실행한 것은 아니다.
상수시간 검사는 정적 회귀 범위이며 **형식적 증명, dudect, 전력·EM TVLA는 이번에 수행하지 않았다.**
FFT·sampler의 수치 표현/연산은 변경하지 않았고, 이번 모듈러 오차 검사를 별도의 FP 오차 검증으로 해석하지 않는다.

## 4. 메모리와 산출물

| 영역 | 사용·예약량 | 설정 용량 | 남은 용량 |
|---|---:|---:|---:|
| ITCM 코드·벡터 영역 | 106,236 B | 262,144 B | 155,908 B |
| DTCM 상수·데이터·스택 영역 | 225,728 B | 262,144 B | 36,416 B |

메인 스택 65,536 B 예약은 위 DTCM 수치에 이미 포함되어 있다.
실측 watermark 기반 사용 상한은 9,624 B이며, 스택 예약을 줄이지 않았다.
빌드 로그의 `FLASH`/`RAM`은 이 링크 스크립트의 영역 이름으로 실제 배치는 각각
ITCM `0x10000000` / DTCM `0x30000000`이다. 외부 Flash 실행으로 바뀐 것이 아니다.
또한 기존 링커 스크립트의 ITCM 코드 구간 제한은 128 KiB이므로, 현 설정에서 그 한도까지의
코드 여유는 24,836 B이다. 위 256 KiB 전체 잔량과 혼동하지 않는다.

보드에 로드한 파일은 sparse ELF다. 빌드 중 생성되는 주소 공백 포함 flat `zephyr.bin`만
스크립트가 제거하며, ELF·map·빌드 로그는 보존한다. 필요하면 빌드로 BIN을 다시 생성할 수 있다.

- [새 펌웨어 ELF](build/m55/zephyr/zephyr.elf)
- [링크 map](build/m55/zephyr/zephyr.map)
- [전체 빌드 로그](build/m55/build-20260914T022311Z.log)
- [보드 사전 검사 원본 로그](measurement/results/integrated/runs/pilot-20260914T022940Z/raw.log)
- [보드 100회 측정 원본 로그](measurement/results/integrated/runs/full-20260914T023029Z/raw.log)
- [실행 명령·시간·60개 배치 원자료](measurement/results/integrated/runs/full-20260914T023029Z/run.json)
- [정적 감사: 소스·옵션·함수 주소·실행 section](measurement/results/static_audit.json)
- [최종 검증·기존 결과 비교 JSON](measurement/results/comparison.json)
- [펌웨어 disassembly](measurement/results/firmware.dis)

본 측정 시간: **2026-09-14 11:30:29~11:32:09 KST**
(`02:30:29~02:32:09 UTC`). 이 시간에는 로드·검사·워밍업·로그 출력도 포함된다.

| SHA-256 대상 | 값 |
|---|---|
| 계산 소스 트리 C/H/S | `4cca9f390516f2136d240447b4a257f799c6f0e72a4a915902a8aa76fd9a9aee` |
| `mq_cm55.s` | `b826d79ed25d1529007fe8bf5eac71e60bdde336e65e7c3bb6738264d28b382d` |
| 새 ELF | `24b8128723bd63ace2608758eac5563512a72a56b638bfc778de4360caa10d8d` |
| 본 측정 원본 로그 | `db010379c20cac0b80a2af382bf67d191d9ff3481912e02f5d387a703757e42d` |
| host 기대값 로그 | `b2fd0eb306af23be686e7d22d9e9019554e62412cb2d10e495317bda78389c72` |

전체 ELF 파일 hash는 디버그 소스 경로 등 비실행 정보가 달라 기존 A와 다르다.
로드 대상 section 및 함수 바이트·주소가 같다는 검사는 별도로 통과했다.

## 5. 재실행 방법

저장소 루트 `/Users/seungwon/FALCON`에서 실행한다. 보드에 로드하므로 M55 측정을 동시에 실행하지 않는다.

```sh
bash fn-dsa_m55/ntt_opt_slothy/measurement/build.sh
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_slothy/measurement/audit.py
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_slothy/measurement/run.py pilot
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_slothy/measurement/run.py full
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_slothy/measurement/audit.py --require-full
```

현재 감사기는 선택한 A와 정확히 같은 통합본인지 검증한다. 이후 계산 소스를 바꾸면 실패하는 것이 정상이며,
새 최적화의 검증 기준을 별도로 갱신해야 한다. 실행별 로그는 UTC timestamp 하위 경로에 새로 저장한다.
