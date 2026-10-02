# M4 → M55: 공통 실행 조건의 FN-DSA 비교

기존 결과는 보존하고 **추가 실험**으로 기록한다. 이 실험은 최신 공개 M4 최적화 구현을 M4와 M55에서 같은 종류의 실행 메모리·캐시·명목 클럭 조건으로 비교한다. 논문 당시 코드/STM32F407/-O2/15000회를 완전히 재현한 실험이나 순수 코어만의 비교는 아니다.

## 고정 조건

| 항목 | M4 | M55 |
|---|---|---|
| 보드 | 현재 연결 STM32L4R/L4S | NUCLEO-N657X0-Q / STM32N657 |
| ST-LINK | `066DFF363355473043205442` | `003C00223335510735383531` |
| 원본 소스 | `a5f15894bf1a68017074650d5298cecf9bb29a79` | 같은 커밋, 기존 `inner.h` 호환 선택 패치만 |
| 연산 | M4 정수/DSP ASM + 정수 FP64 에뮬레이션 | 동일 구현, native FP64/MVE 전환 없음 |
| 툴체인 | GCC 13.2.1 / Arm GNU 13.2.Rel1 | 동일 |
| 공통 옵션 | `-O3 -ffp-contract=off`, LTO/fast-math 없음 | 동일 |
| CPU/ABI 옵션 | `-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb` | `-mcpu=cortex-m55+nomve -mfpu=auto -mfloat-abi=hard -mthumb -mcmse` |
| 코드/상수 | SRAM1 물리 `0x20000400` → 실행 alias `0x00000400` | AXISRAM2 `0x34180400` |
| 데이터/스택 | SRAM3 `0x20040000`, stack top `0x200A0000` | AXISRAM2 `0x341C0000`, stack top `0x341FF000` |
| 캐시/prefetch | Flash I/D cache·prefetch OFF | CPU I/D cache OFF, SRAM MPU Normal non-cacheable |
| CPU/HCLK | 공칭 24/24 MHz (MSI) | 공칭 24/24 MHz (HSI→PLL1→IC1/2) |
| APB | PCLK1/2 = 24 MHz | PCLK1/2/4/5 = 24 MHz |
| 추가 N6 시스템 클럭 | 해당 없음 | IC6/IC11 = 24 MHz |
| 입력 | 회차별 동일 결정적 key/sign seed, RAW `blah`, 빈 context | 동일 |
| 횟수 | 512/1024 keygen/sign/verify 각각 100회 | 동일 |
| 워밍업 | 크기별 각 연산 1회, 통계 제외 | 동일 |
| 타이머 | DWT CYCCNT, 인터럽트/SysTick OFF | 동일 |

모든 키/서명/작업 버퍼는 32-byte 정렬이다. seeded/temp API 전체(내부 재시도 포함)를 재고, 외부 RNG/시드 준비/출력 해시/로그는 제외한다. Flash는 코드·상수 저장/실행에 사용하지 않는다. M4의 Flash latency 레지스터에 남는 1WS는 SRAM 접근 지연을 뜻하지 않는다.

공통 명목 클럭을 맞춰도 발진원 오차, SRAM/버스 구조, TrustZone·MPU, 코어 파이프라인, CPU 대상별 C 코드 생성 차이는 남는다. Cortex-M4 SRAM1은 ICode/DCode 접근을 위한 volatile remap을 적용하며, M55는 AXI SRAM 경로를 사용한다. 캐시 OFF 측정이 각 보드의 최대 실사용 성능을 뜻하지 않는다.

## 보존·진행·결과 파일

- 기존 M4: [perforamance_result.md](../fn-dsa_m4/perforamance_result.md), `fn-dsa_m4/measurement/`.
- 기존 M55: [result.md](../fn-dsa_m55/result.md), `fn-dsa_m55/measurement/`.
- 추가 M4: [측정 보고서](../fn-dsa_m4/measurement_controlled/result.md), [상태](../fn-dsa_m4/measurement_controlled/status.json), [로그](../fn-dsa_m4/measurement_controlled/logs/events.log).
- 추가 M55: [측정 보고서](../fn-dsa_m55/measurement_controlled/result.md), [상태](../fn-dsa_m55/measurement_controlled/status.json), [로그](../fn-dsa_m55/measurement_controlled/logs/events.log).
- 두 측정 완료 후: [비교 보고서](result.md), `comparison.json`, `audit.json`.

컨트롤러는 장비 식별 → ELF/소스 검사 → SRAM 로드/검증 → 워밍업 → CPU/HCLK/APB/cache 레지스터 검사 → 호스트 시간 대비 DWT 클럭 점검 → GO 순서로 진행한다. 본 측정 중 60초 간격으로 정지 없이 mailbox를 읽으며, 완료 후만 halt한다. 이 디버그 버스 접근의 영향이 정확히 0이라고 보장하지는 않는다. 종료 대기는 WFI 대신 NOP로 구현해 이전 L4의 절전 중 SRAM 읽기 문제를 피한다.

본 실행은 코드/데이터 SRAM과 volatile 제어 레지스터만 변경한다. Flash/option bytes의 기록·삭제 기능은 없다. M4 Flash는 측정 전 전체를 읽어 SHA-256을 기록하고 완료 후 같은 내용인지 검증한다. 원래 실행 중 SRAM 상태까지 복원하지는 않는다. 완료 후 MCU는 halt 상태, 이 세션의 OpenOCD는 종료한다. 다른 연결 보드는 건드리지 않는다.

## 정확성·타이머 검증

기존 FNV-1a 진단값과 추가 SHAKE256 32-byte digest를 모두 대조한다. digest 입력은 각 차수/워밍업 구분별 순차 `sk || pk || signature`이며, 입력 크기와 회차 순서는 고정되어 있다. 호스트의 untimed portable C 결과, 두 보드의 결과가 모두 일치해야 완료로 처리한다. 테스트 시드는 공개 벤치마크 전용이며 실제 키 생성에 사용하면 안 된다.

호스트 oracle은 앞선 전체 portable 테스트/KAT 검증에 사용한 일회성 생성본을 사용한다. 그 생성본에는 upstream의 비활성 scalar helper 복원 및 비활성 프로파일링 계측 래퍼가 있다. 이 수정은 ARM 측정 소스에 적용하지 않는다. 이번 보드 실험은 전체 upstream 테스트 스위트를 다시 실행하는 것과 같지 않으며, 타이밍/부채널 안전성 감사 결과도 아니다.

DWT는 32비트이며 공칭 24 MHz에서 1 wrap은 약 178.957초다. 회차별 raw cycle을 보존하고, 모든 API 사이클 합과 GO→DONE 호스트 관측 시간을 비교해 숨겨진 wrap이 들어갈 여지가 없는지 검증한다(명목 클럭 ±2% 범위 가정). 클럭 sanity check는 정밀 계측기 교정이 아니다.

## 재실행

완료/실패 세션을 자동 덮어쓰지 않는다. 기존 결과를 다른 이름으로 보존하고 보드가 유휴 상태인지 확인한 뒤 별도 승인된 실험으로 실행한다.

```sh
cd /Users/seungwon/FALCON/comparison_m4_m55
make BOARD=m4
make BOARD=m55
make host
python3 controller.py m4
python3 controller.py m55
python3 verify_results.py
```

두 보드 컨트롤러는 별도 프로세스로 병행 실행할 수 있다. 전용 TCL 포트는 M4 6668 / M55 6669다. 점유된 서버에 접속하거나 다른 서버를 종료하지 않는다. 실행 중에는 해당 보드의 USB 분리, reset, 디버깅/다운로드를 피한다. 호스트에서의 다른 코드 편집·작업은 가능하지만 측정 대상 `ref` 파일은 실행 중 변경하지 않는다.

## 준비 단계 기록

- 초기 ELF의 기본 페이지 정렬 때문에 이미지 밖 ELF 헤더까지 PT_LOAD에 포함되어 사전 검사에서 거부됐다. 명시적 SRAM 세그먼트로 수정한 후 검사를 통과했다. 이 거부 단계에서는 보드 로드가 없었다.
- 첫 M4 시도는 측정 코드 로드 전 2 MiB Flash **읽기**가 약 32.5초 걸려 30초 socket 제한을 넘었다. 원본 Flash를 쓰지 않았으며 해당 시도는 `fn-dsa_m4/measurement_controlled/attempts/preflight_read_timeout/`에 보존했다. 제한을 240초로 늘려 새 세션을 시작했다.
- M55 세션은 기존 30초 제한 버전으로 시작했다. 당시 컨트롤러를 `revisions/controller_initial.py`에 그대로 보존했으며 현재 파일과의 차이는 읽기 timeout 및 설명 주석뿐이다. 측정 펌웨어/입력/계측은 동일하다.

## 근거

- [ST STM32L4 memory remap 설명](https://www.st.com/resource/en/product_training/stm32l4_system_syscfg.pdf).
- [ST L4 HAL SRAM remap 매크로](https://github.com/STMicroelectronics/stm32l4xx-hal-driver/blob/master/Inc/stm32l4xx_hal.h).
- [ST N6 시스템 클럭 예제](https://github.com/STMicroelectronics/STM32CubeN6/blob/main/Projects/STM32N6570-DK/Examples/RCC/RCC_ClockConfig/FSBL/Src/main.c).
- 실제 사용한 CubeN6 HAL은 IC divider 1..256을 허용한다. 1200 MHz PLL1과 /50 IC divider로 24 MHz를 구성하고 HAL 반환값 및 raw register로 확인한다.
