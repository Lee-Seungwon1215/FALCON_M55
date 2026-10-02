# Stage A — 현재 M4에서 선행 구현 재측정

원본 `../ref` 커밋 `a5f15894bf1a68017074650d5298cecf9bb29a79`는 수정하지 않는다.
보드는 기존 확인된 STM32L4R/L4S, ST-LINK `066DFF363355473043205442`만 사용한다.
기존 `../measurement/` 및 결과는 보존한다. 새 로그와 결과는 이 폴더에서 생성된다.

## 조건

- GCC 13.2.1 / Arm GNU 13.2.Rel1, `-O3`, M4 정수/DSP 어셈블리 ON.
- Flash 코드/상수 `0x081C0000`, SRAM3 데이터/스택, SRAM2 진행 mailbox.
- CPU/HCLK 24 MHz, APB1 12 MHz, APB2 24 MHz. Flash cache/prefetch OFF, 1 WS.
- FN-DSA-512/1024 keygen/sign/verify 각각 100개 독립 결정적 입력, 각 warmup 1회 제외.
- 인터럽트와 SysTick OFF, DWT 32-bit 차분. API 내부 재시도 포함, 입력 준비·출력 해시·로그 제외.
- 종료는 측정 밖 NOP 대기로 구현해 과거 WFI 후 디버그 SRAM 읽기 문제를 피한다.
- 논문의 F407/24 MHz/GCC13.2.1/-O2/15000회 및 당시 소스와 차이를 `result.md`에 명시한다.
- M55 Stage B의 mlkem-native 환경과 측정 방법 차이가 있으므로 순수 코어 속도 비교가 아니다.

## 실행·보존

`controller.py status`는 상태 파일만 읽는다. 약 60초마다 상태·로그를 갱신한다.
TCL 전용 포트는 6674이며 GDB/Telnet은 꺼 둔다. 다른 프로브를 자동 선택하지 않는다.
`supervise.py`가 빌드 → 새 Flash 백업·보호 상태/UID 검사 → 워밍업 → 100회 측정 → Flash 복원을 관리한다.
전체 2 MiB Flash 새 백업과 보드 읽기 대조를 완료하고 상위 256 KiB가 전부 0xFF일 때만 기록한다.
기록한 페이지만 복원(erase)하고 전체 Flash가 새 백업과 일치하는지 검증한다.
부트 이미지·option bytes·다른 Flash 영역은 쓰거나 지우지 않는다. 실행 중 RAM 상태는 복원하지 않는다.
종료 후 MCU는 reset/halt 상태이며 이 세션에서 시작한 OpenOCD만 종료한다.

중단 후 복원은 세션과 백업을 보존한 채 다른 측정/디버거가 없음을 확인하고,
이 폴더의 `openocd.cfg`로 전용 서버를 시작한 다음 `python3 controller.py recover`를 사용한다.
진행 중에는 reset/halt/USB 분리/별도 debugger를 사용하지 않는다.
완료 세션을 재실행하기 위해 `session.json`을 지우지 않는다.

## 시작 단계 점검 기록

- 새 M4 바이너리 SHA-256: `35b9049267f4be64fa6bce7b5029e911204f89b07506d3a898df00aa109bc9f1`.
- 이전 Flash 실험 바이너리와 `cmp` 대조 시 차이는 종료 대기의 WFI→NOP 명령 1바이트뿐이다. 암호 코드·계측 API·입력·주소 배치는 동일하다.
- 새 호스트 oracle의 warmup FNV 값은 `[4053617184,4181047927]`, 최종 값은 `[3060065408,1579935960]`으로 이전과 같다.
- 기록 직전 reset 후 `verify_image`의 내부 CRC 가속 루틴이 halt-timeout을 냈으나, OpenOCD fallback 전체 읽기 비교가 성공 반환한 후에만 Flash 기록을 진행했다. 원본 로그를 `logs/openocd.log`와 `logs/events.log`에 보존한다.
- 본 측정 시작은 `2026-09-09T11:39:42Z`이며, 위 사전 검증 지연은 측정값에 포함되지 않는다.

## 완료

`2026-09-09T12:10:54Z` (한국시간 21:10:54)에 512/1024 각각 keygen/sign/verify 100회씩 총 600회 성공, 호스트 체크섬 대조와 Flash 복원을 완료했다.
측정용 26개 페이지(106,496 bytes)만 지워 원래 blank 상태로 복원하고, 전체 2 MiB Flash가 새 백업과 일치함을 `verify_image`로 확인했다.
새 백업 SHA-256은 `8899d461cef13b43b72c548e63fd1259df6d3e4b8bbd8eaeba44b6bdaececdf3`다. 과거 백업으로 되돌리지 않았다.
측정 바이너리는 `build/`에 보존되어 재생성할 수 있다. 이 세션의 감독/OpenOCD는 종료됐고 보드는 reset/halt 상태다.

결과는 [result.md](result.md), 600개 원시값은 [results.json](results.json)에 있다.
추가 [audit.py](audit.py)는 보드 접근 없이 기록·해시·통계·호스트 출력·이전 바이너리 차이를 대조하며 [audit.json](audit.json)에 통과 결과를 저장했다.
