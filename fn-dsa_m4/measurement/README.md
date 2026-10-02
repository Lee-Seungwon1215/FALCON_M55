# M4 100회 성능 측정

연결 장비는 STM32L4R/L4S / ST-LINK `066DFF363355473043205442`다.
M55 등 다른 보드는 사용하지 않는다. 최신 `../ref`를 수정하지 않고
GCC 13.2.1, `-O3`, M4 어셈블리 활성화로 빌드한다.
논문의 F407 대신 승인된 현재 보드를 사용하므로 완전 재현은 아니다.
자세한 조건과 전체 로그는 [결과 문서](../perforamance_result.md)에 기록된다.

컴파일러는 [Arm 공식 13.2.Rel1 macOS arm64 아카이브](https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-darwin-arm64-arm-none-eabi.tar.xz)를 사용한다.
SHA-256 `39c44f8af42695b7b871df42e346c09fee670ea8dfc11f17083e296ea2b0d279`가
Arm의 `.sha256asc` 값과 일치함을 확인했다. `Makefile` 기본 경로에 압축을
푼 뒤 `make all`로 빌드하며 실제 명령과 컴파일러 버전은 빌드 로그에 남는다.

## 실행 중 확인

이 디렉터리에서 `python3 controller.py status`는 파일만 읽는다.
[status.json](status.json)은 약 60초마다 갱신된다. `counts`의 두 행은
각각 512와 1024이며 열은 키 생성, 서명, 검증 순서다.
[events.log](logs/events.log)에 진행·검증·Flash 복원 내역을 누적한다.
본 측정 중 디버거는 별도 SRAM2의 136바이트만 읽고 코어를 정지하지 않는다.

`python3 controller.py launch`로 시작한 작업은 백그라운드에서 실행되며
일반 유휴 절전은 해당 프로세스가 실행되는 동안만 방지한다.
다른 폴더 작업과 M55 작업은 가능하지만, 완료 전 M4의 USB 분리,
reset, 디버깅, 재플래시는 하지 않는다. PC 종료·노트북 덮개 닫기도 피한다.
백그라운드 프로세스는 보고서를 갱신할 뿐 채팅 알림을 보내지는 않는다.

## 정확성과 원본 보존

각 크기에서 워밍업 키 생성·서명·검증과 변조 서명 거부를 확인하고,
호스트 portable C 경로와 워밍업 체크섬이 일치해야 본 측정을 시작한다.
100회씩 모두 성공하고 최종 체크섬이 일치해야 결과를 확정한다.
체크섬은 진단용 FNV-1a이며 암호학적 동등성 증명은 아니다.
호스트용 생성 소스에는 앞선 프로파일링의 scalar helper 복원이 있다.
실제 M4 빌드는 이 복원본이 아닌 `../ref` 원본과 M4 어셈블리를 사용한다.

전체 2 MiB Flash를 `backups/`에 저장하고 보드와 검증했다.
비어 있음을 확인한 `0x081C0000`부터의 최대 256 KiB 슬롯만 사용한다.
기존 boot image·option bytes는 쓰지 않는다. 정상 종료 또는 포착한 오류 시
이번에 기록한 페이지만 지우고 전체 Flash가 백업과 같은지 검증한다.
그 뒤 원래 reset 주소에서 halt 상태로 두며 실행 중 RAM 상태는 복원하지 않는다.

USB 분리·프로세스 강제 종료로 복원이 미확인인 경우 백업과
[session.json](session.json)을 보존한다. 같은 보드를 다시 연결하고,
다른 디버거를 종료한 뒤 다음 절차로 복원할 수 있다.

```sh
/Users/seungwon/test/.tools/xpack-openocd-0.12.0-7/bin/openocd -f openocd.cfg -c init
```

별도 터미널에서 다음 명령을 실행한다. 진행 중인 제어 프로세스가 있으면
잠금 검사가 복원을 거부한다. 장비 UID·보호 설정·백업 SHA-256을 확인한 뒤
기록된 측정 슬롯 페이지만 지운다. 전체 Flash erase 명령은 사용하지 않는다.

```sh
python3 controller.py recover
```

`session.json`을 삭제하거나 수정해서 중복 실행 방지 검사를 우회하지 않는다.
보드 연결이 끊긴 경우 성공 결과나 복원 완료로 간주하지 않는다.

이번 실험에서는 모든 계산 완료 후 WFI 대기에서 디버그 SRAM 읽기가 0을 반환했다.
코어를 halt한 뒤 DONE·각 100회·최종 체크섬을 확인했고, `finalize-completed`
복구 명령으로 원시 결과를 수집한 다음 측정 Flash를 복원·검증했다.
펌웨어나 계측된 사이클은 변경하지 않았고 재측정도 하지 않았다.
해당 명령은 완료가 확인된 수집 복구용이며 진행 중 측정을 확인하는 용도로 사용하지 않는다.
