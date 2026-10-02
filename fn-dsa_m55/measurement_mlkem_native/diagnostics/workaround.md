# STM32N657 FN-DSA TCM 시작 오류 수정 — 2026-09-10

## 수정 내용과 범위

FN-DSA `ref`의 C/어셈블리 구현은 수정하지 않았다. 기존 `inner.h`의 M55
호환 패치는 유지한다. 상위 Zephyr/ML-KEM checkout도 수정하지 않았다.
로컬 측정 앱의 링커 및 시작 초기화만 조정했다.

| 구역 | 실패한 원본 배치 | 수정 배치 |
|---|---|---|
| 벡터·실행 코드 | ITCM | ITCM 유지 |
| 전역 상수·Zephyr 초기화/장치 테이블 | ITCM | DTCM |
| `.data` 초기값 적재 위치(LMA) | ITCM | DTCM, 실행 주소(VMA)와 동일 |
| 작업 데이터·BSS·스택 | DTCM | DTCM 유지 |
| DTCM 초기화 | 전체 256 KiB를 STRD로 0 초기화 | 적재된 상수/초기값 이후부터 끝까지 STRD 초기화 |

- `app/generate_dtcm_linker.py`: SHA-256으로 고정 Zephyr 링커 원본을 확인하고
  빌드 디렉터리에 로컬 파생본을 생성한다. 코드 128 KiB 이내, DTCM 256 KiB
  이내, 초기값 LMA=VMA 및 scrub/BSS 경계 조건을 링크 시 검사한다.
- `app/dtcm_startup.s`: `--wrap=soc_early_reset_hook`으로 원본 초기화 함수의
  호출만 교체한다. 원본 전체 scrub은 새 DTCM 상수를 지워버리므로 유지할 수
  없다. 적재 완료 구역 끝 `0x3000cf50`부터 `0x30040000`까지 초기화한다.
  함수 호출이 실제 wrapper로 연결됐는지도 disassembly 감사에서 확인한다.
- 기존 Zephyr `.data` 복사는 동일한 DTCM 주소로의 self-copy가 된다.
  초기화 테이블·FN-DSA 상수 전체는 GDB ELF 적재로 먼저 준비된다.
- `exec_with_tcm_init.py`: 시작 fault용 중단점을 정상 시작 이후 제거해 상위
  측정용 중단점과 중복되지 않게 수정했다. 측정 전후 MSCR을 읽기만 한다.
- 코드 안의 literal pool은 ITCM에 남는다. 모든 ITCM data read 제거를
  주장하지 않는다. 실제 두 크기 API와 호스트 출력 비교로 동작을 검사한다.

ECC를 끄거나 클럭을 낮추지 않았다. 본 측정 구간 밖의 초기화 변경이며,
암호 API의 계측 범위·입력·반복 횟수·컴파일러 옵션은 유지했다. 다만 상수
메모리 위치가 성능에 영향을 줄 수 있어 **원본 환경과 완전히 동일하다고
기술하면 안 된다.** 논문에는 “mlkem-native Nucleo 환경 기반, 상수 DTCM
배치와 이에 맞춘 시작 초기화 수정”이라고 명시한다.

## 시험 이력

- `pilot-20260910T015740Z`: 상수 이동 후 get_bootargs 도달, 중복 디버그
  중단점으로 중단. 유효 측정 아님.
- `pilot-20260910T015811Z`: 중단점 수정 후 진행했지만 전체 DTCM scrub이
  상수·타이머 초기값을 지워 timer self-check에서 정체. GDB SIGINT로
  정지 위치/레지스터를 기록하고 reset. 유효 측정 아님.
- `pilot-20260910T020046Z`: scrub 범위 수정 후 두 크기 모든 연산, 호스트
  digest 및 변조서명 거부 통과. CFSR/HFSR/AFSR=0.
- `pilot-20260910T020143Z`: 새 reset/load 세션에서 재통과.
  시작/종료 MSCR=`0x1300a`: ECCEN=1, TECCCHKDIS=0. 캐시 OFF, CPU/SYS/HCLK
  800/400/200 MHz, 100 ms timer 교차검사 통과.
- 100회 본 측정 상태와 최종 수치는 [결과](../result.md)에서 확인한다.

이 수정은 해당 보드/이미지에서 재현된 문제의 검증된 소프트웨어 우회다.
실리콘 결함인지 미확인 설정 문제인지는 단정하지 않는다.
[원인 분리 실험과 판단 한계](cause.md)는 그대로 보존했다.

## 재현 산출물

- 기존 실패 이미지: `build/zephyr/zephyr.elf`, SHA-256
  `44e351780ce356112a9d53d577a5a5b5c2831de1b43d4cec39b0b267763aabdb`.
- 수정 이미지: `build-dtcm/zephyr/zephyr.elf`, SHA-256
  `c415762b0c572db02f144fb77ac78a02e8af571544faab2dfa4334a5dfe1b65f`.
- 수정 이미지 실제 점유: ITCM 95,484 B, DTCM 213,152 B(64 KiB main stack 포함).
- 새 정적 감사: `audit-dtcm/build_manifest.json`, `upstream_config.diff`.
- SoC가 자동 생성하는 약 512 MiB gap-filled BIN은 주소 간 빈 공간 때문에
  불필요하며 `build.sh`가 빌드 후 삭제한다. ELF/HEX/맵은 보존된다. 이는
  재생성 가능한 빌드 산출물 정리이며 소스나 원래 실패 ELF를 삭제하지 않는다.
