# 5단계 SLOTHY A/B: 실제 M55 비교

같은 연결 보드에서 ref/A/B를 다시 빌드하고 예비 검사 후 각각 전체 측정했다.
`ref`와 기존 `../ntt_opt`는 변경하지 않았다. 아래는 실제 보드 cycle이며 SLOTHY 예상값이 아니다.

후속 진단: [A/B 실행 위치 고정 재측정](layout_diagnostic/RESULTS.md)에서
서명용 FFT 계열 함수의 주소를 맞추자 큰 A/B 서명 격차가 사라졌다.
동일 함수를 확장 ITCM으로 옮기면 A/B 모두 느려져, 기존 서명 지연의 주원인이
코드 배치였음을 확인했다. 아래 수치와 판단은 **최초 배치의 측정 당시 기록**으로 보존하며,
후속 진단 수치를 기존 ref 대비 개선률로 직접 비교하지 않는다.

## 전체 API 성능

degree·작업별 100회 = 고정 입력 10종 × 입력별 10회. batch마다 10회 warm-up.
대표값은 **10개 batch 평균 cycle/call의 상위 중앙값**이다. 개별 100회 시간의 중앙값은 아니다.
절감률 양수는 빨라짐, 음수는 느려짐이다. 전체 키생성·서명·검증 수치이며 NTT 단독 cycle은 아니다.

| degree | 작업 | ref | A | A 절감률 | B | B 절감률 |
|---:|---|---:|---:|---:|---:|---:|
| 512 | 키생성 | 51,716,563 | 51,706,963 | +0.0186% | 51,704,935 | +0.0225% |
| 512 | 서명 | 17,145,671 | 17,135,527 | +0.0592% | 17,782,550 | -3.7145% |
| 512 | 검증 | 323,007 | 321,262 | +0.5402% | 321,016 | +0.6164% |
| 1024 | 키생성 | 260,368,534 | 260,350,233 | +0.0070% | 260,349,375 | +0.0074% |
| 1024 | 서명 | 36,737,446 | 36,724,678 | +0.0348% | 38,151,945 | -3.8503% |
| 1024 | 검증 | 624,898 | 622,306 | +0.4148% | 622,329 | +0.4111% |

## 현재 판단

이번 실험에서는 A가 여섯 API 항목 모두 소폭 개선되었고 코드·데이터 메모리 증가도 없다.
A의 이득은 작지만 동일 입력의 10개 batch에서 모두 같은 개선 방향이었다.
B는 키생성·검증 이득이 있으나 서명은 512 약 3.71%, 1024 약 3.85% 느려져
현 상태로 기준 코드에 승격하기 어렵다. 어느 후보도 기존 `ntt_opt`에 반영하지 않았다.
B의 서명 지연 원인은 이번 실험에서 분리 진단하지 않았다. 코드 크기/배치 변화도 포함된
전체 API 측정이므로 이 수치를 NTT 루프 자체의 지연으로 단정하지 않는다.

## 같은 입력끼리 비교

키생성의 재시도 횟수 등 입력별 변동을 통제하기 위해 동일 seed의 batch끼리 비교했다.
아래 차이는 ref−후보이며 양수가 이득이다. 통계적 유의성 검정이나 다른 보드에 대한 일반화는 아니다.

| 후보 | degree·작업 | paired 차이 상위 중앙값 (cycle/call) | 빠른 batch / 10 |
|---|---|---:|---:|
| slothyA | 512_keygen | +9,600.0 | 10 |
| slothyA | 512_sign | +10,035.1 | 10 |
| slothyA | 512_verify | +1,745.0 | 10 |
| slothyA | 1024_keygen | +31,615.0 | 10 |
| slothyA | 1024_sign | +12,768.2 | 10 |
| slothyA | 1024_verify | +2,592.0 | 10 |
| slothyB | 512_keygen | +11,628.0 | 10 |
| slothyB | 512_sign | -636,879.4 | 0 |
| slothyB | 512_verify | +1,991.0 | 10 |
| slothyB | 1024_keygen | +32,907.9 | 10 |
| slothyB | 1024_sign | -1,414,497.5 | 0 |
| slothyB | 1024_verify | +2,626.0 | 10 |

## 조건과 메모리

- 실제 NUCLEO-N657X0-Q, STM32N657 Cortex-M55 r1p1; ST-LINK `003C00223335510735383531`.
- CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz. 코드 ITCM, 데이터·상수·stack DTCM; 각각 256 KiB 설정.
- I/D cache 실제 OFF(CCR 확인), TCM ECC ON, 기존 IRQ 허용 조건.
- GCC 15.2.1, 최종 유효 옵션 `-O3`; 동일 Zephyr 4.4.1/config/linker/startup/harness.
- `mlkem-native` pinned commit `637d076aa113d8faaec2277ed4a46b657acaf35f`의 Nucleo 경로 및 기존 프로젝트 FN-DSA harness를 그대로 재사용.
- config에 cache 지원 여부가 1로 출력되어도 활성 상태를 뜻하지 않는다. CCR cache-enable 비트를 따로 확인했다.

| 후보 | ITCM 코드 | DTCM 예약 | main stack 사용 상한 |
|---|---:|---:|---:|
| ref | 106,236 B | 225,728 B | 9,624 B |
| slothyA | 106,236 B | 225,728 B | 9,624 B |
| slothyB | 111,628 B | 225,728 B | 9,624 B |

B의 앞뒤 처리 코드 때문에 ITCM은 기준보다 5,392 B 늘었다. 두 후보 모두 기존 active-code 한계
128 KiB 안에 있고 DTCM은 256 KiB 안에 있다. heap/table/stack 추가 예약은 없다.

## 검증 결과와 한계

- A/B: 실제 SLOTHY selfcheck 및 별도 instruction interpreter 816개 상태·메모리 접근 시험 PASS.
- A/B: object에서 변경된 함수는 공통 NTT/iNTT 2개뿐. `mq.c` 등 다른 C/H/S 파일 불변.
- 각 보드 full run: 512·1024 forward oracle/roundtrip 오차 0, Barrett 2048쌍 표 검사 0 mismatch.
- 각 full run: host 고정-seed DIGEST/AUDIT 22개 일치, 정상 서명·검증 및 변조 거부 PASS.
- 각 full run: CFSR/HFSR/AFSR=0, ECC 시작/종료 활성 상태 정상.
- 상수시간: 새 비밀 의존 분기/메모리 주소/stack spill을 추가하지 않았는지 정적으로 확인.
  이 결과는 형식적 CT 증명, dudect 타이밍 검정, 전력/EM TVLA가 아니다. 정수 NTT 검사이며 FFT/sampler 오차 분석도 아니다.
- B: 8개 루프에 halving 적용, 실제 교차 이동은 6개. 512 CT3/마지막 GS2는 현 해에서 교차 이동 0개.
  1024 중간 pass는 A의 반복 내부 스케줄만 적용. 전체 범위를 무제한 modulo scheduling한 결과가 아니다.

## 원시 로그와 정확한 실행 파일

### ref

- [full 원시 로그](results/ref/runs/full-20260913T141611Z/raw.log)
- [full 실행 기록](results/ref/runs/full-20260913T141611Z/run.json)
- [소스·ELF 검증 기록](results/ref/full_validated.json)
- source tree SHA-256: `e5c13189883685fea042fc3d74d23cf396afa29a94bd26a54d5a3bb2caac6172`
- ELF SHA-256: `10a2702a6835e988a827d479a161a5335b0fbe2dcb183d0ad5fb86e6a6fd3ac0`

### slothyA

- [full 원시 로그](results/slothyA/runs/full-20260913T142157Z/raw.log)
- [full 실행 기록](results/slothyA/runs/full-20260913T142157Z/run.json)
- [소스·ELF 검증 기록](results/slothyA/full_validated.json)
- source tree SHA-256: `4cca9f390516f2136d240447b4a257f799c6f0e72a4a915902a8aa76fd9a9aee`
- ELF SHA-256: `b9d9ac19954fc014633b3a548cd9d1c768c7cb0312726a4502d7c9239bd8c068`

### slothyB

- [full 원시 로그](results/slothyB/runs/full-20260913T142413Z/raw.log)
- [full 실행 기록](results/slothyB/runs/full-20260913T142413Z/run.json)
- [소스·ELF 검증 기록](results/slothyB/full_validated.json)
- source tree SHA-256: `9b605e313645f75193d813632ce5a2a388c6d3ccf871a70c389f011c2e533d1b`
- ELF SHA-256: `5aa203ffdded2f479867952c13565fdf9f8d014d4b98f2808b1a9a7f63948976`

[구현 범위·논문 근거·재현 명령](README.md), [전체 기계 판독 결과](results/comparison.json),
[SLOTHY 입력/출력 manifest](tooling/logs/manifest.json), [독립 모델 검사](tooling/logs/instruction_model.json).
