# SLOTHY A/B 실행 위치 대조 실험

목적: 기존 B에서 나타난 서명 지연이 NTT 스케줄 자체인지, B의 코드 크기 증가가
뒤쪽 서명 함수들을 기본 ITCM 밖으로 밀어낸 효과인지 구분한다.
이 폴더는 **원인 진단 전용**이며 `ntt_opt`, `ref`, `slothyA`, `slothyB`의
계산 소스와 기존 측정 결과를 교체하지 않는다.

## 통제 방법

- 기존 stage-5 A/B 빌드의 object/archive를 그대로 다시 링크한다. 재컴파일하지 않는다.
- 원래 linker script로 다시 링크한 ELF의 SHA-256이 기존 측정 ELF와 완전히 같아야 진행한다.
- 변경 사항은 text 배치와 출력 경로뿐이다. 입력 파일 해시와 전체 링크 명령을
  `build/<후보>/provenance.json`에 기록한다.
- `sign_fpoly.c`의 살아 있는 13개 함수(FFT, iFFT, LDL, split/merge, gram,
  apply_basis 및 보조 함수)를 함께 옮긴다. A/B의 이 함수들은 주소와 기계어가 같다.
- low/high 사이에는 이 13개 함수의 주소만 바뀐다. NTT/iNTT 기계어는 같고,
  다른 함수와 DTCM 데이터/스택 주소는 고정한다. 함수 호출의 재배치값은 링커가 갱신한다.
- A/B 사이에는 크기가 다른 mq assembly 내부의 iNTT와 곱셈 검사 probe 시작 주소만
  다르다. 두 함수 모두 기본 ITCM에 남는다. 전체 프로그램의 모든 함수 주소까지
  같게 만들었다는 의미는 아니다.

| text 영역 | 절대 주소 | 네 빌드의 처리 |
|---|---|---|
| 벡터 | `0x10000000` | 동일 |
| fpoly low 예약 | `0x10000400–0x100013FF` | A_low/B_low만 fpoly 사용 |
| mq 예약 | `0x10001400–0x100053FF` | A/B 원본 assembly 전체, 끝까지 패딩 |
| 나머지 코드 | `0x10005400`부터 | 동일 시작 주소/함수 배치 |
| fpoly high 예약 | `0x1001C000–0x1001CFFF` | A_high/B_high만 fpoly 사용 |

기본 ITCM은 `0x10000000–0x1000FFFF`, 확장 ITCM은 `0x10010000`부터다.
진단 ELF의 ITCM 주소 범위는 패딩 포함 118,784 B, DTCM 예약량은 225,728 B로 같다.
기존 128 KiB text 안전 상한은 유지한다. 패딩 증가를 계산 코드 증가로 해석하지 않는다.

## 보드/빌드/측정 조건

- NUCLEO-N657X0-Q / STM32N657 / ST-LINK `003C00223335510735383531`.
- 기존 mlkem-native pinned runner/clock/overlay/config 사용.
- CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz.
- ITCM/DTCM 각각 256 KiB, global rodata/데이터/스택 DTCM, I/D cache 실제 OFF, TCM ECC ON.
- GCC 15.2.1, 기존 애플리케이션 `-O3`, Cortex-M55/Thumb/hard-float 옵션으로 이미
  컴파일된 object 사용. 기존 최종 링크 명령의 `-O2`도 그대로다(재컴파일 아님).
- full: 512/1024 각각 키생성·서명·검증, 고정 seed 10개 × batch별 10회 = 각 작업 100회.
  batch마다 warmup 10회. 기존 upper median 정의 유지.
- pilot: 각 작업 1회, warmup 1회. 동일 ELF/source가 pilot을 통과해야 full 허용.
- 타이밍 밖의 기존 GDB 정지 지점에서 `SYSCFG_CM55TCMCR`를 읽어 시작/종료값을 기록한다.
  기대값 `0x00000099`: ITCM/DTCM 확장 256 KiB, bit23/24 `WSDISABLE=0`.
  **대기 상태, 클럭, ECC 설정을 변경하는 실험은 하지 않는다.**

## 실행

저장소 루트에서:

```sh
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_5thStage/layout_diagnostic/build.py all
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_5thStage/layout_diagnostic/audit.py
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_5thStage/layout_diagnostic/run.py A_low pilot
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/ntt_opt_5thStage/layout_diagnostic/run.py A_low full
```

`A_low`, `B_low`, `A_high`, `B_high`를 순차 실행한다. 보드는 하나이므로 동시 로드하지 않는다.
완료 후 `audit.py --require-full`로 네 결과와 ELF/source 해시, 주소 고정,
NTT oracle/roundtrip, modular error, 고정 seed host DIGEST/AUDIT 22개,
서명검증/변조거부, fault/ECC/cache/clock 레지스터를 대조한다.

상수시간에 관한 범위: 계산 object를 바꾸지 않으므로 기존 정적 검사와 회귀검사의
연속성만 확인한다. 정식 상수시간 증명, dudect/TVLA, 전체 공식 KAT 재실행을 뜻하지 않는다.

## 산출물

- `build/<후보>/zephyr/{zephyr.elf,zephyr.map,linker.cmd}`: 주소 고정 진단 ELF/맵/스크립트.
- `build/<후보>/zephyr/original_layout_control.elf`: 기존 ELF와 byte-identical인 대조 링크.
- `results/<후보>/runs/`: 수정하지 않은 SWO/GDB 원시 로그와 실행 메타데이터.
- `results/comparison.json`: 주소 검증, 전체 성능, 동일 seed batch 간 차이.
- `RESULTS.md`: 완료 후 해석과 표.

하드웨어 근거: ST RM0486 Rev3의 메모리 맵 및 SYSCFG_CM55TCMCR(p.812).
저장본: `../../measurement_mlkem_native/diagnostics/documents/RM0486_Rev3.pdf`.
배치 대조만으로 지연 효과를 확인할 수 있지만, wait-state disable bit를 직접 토글한
실험과 동일시하지 않는다.
