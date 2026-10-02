# FN-DSA M4: SRAM / cache OFF / CPU·HCLK 24 MHz

상태: **오류로 중단 / 최종 결과 미확정** (2026-09-09T02:02:17.643273+00:00).

기존 측정 결과는 변경하지 않고 보존한다. 최신 공개 M4 구현의 플랫폼 비교이며 논문 당시 실험의 완전 재현이나 순수 코어 성능 비교가 아니다.

## 공통 조건

- 고정 소스 `a5f15894bf1a68017074650d5298cecf9bb29a79`, GCC 13.2.1 / `-O3 -ffp-contract=off`, LTO·fast-math 없음.
- M4 정수/DSP 어셈블리 ON, native FP64 전환·MVE 없음. CPU/ABI/보드 초기화 차이는 빌드 로그에 기록.
- CPU/HCLK/PCLK1/PCLK2 공칭 24 MHz. M55의 IC1/2/6/11 및 PCLK4/5도 24 MHz. M4 MSI vs M55 HSI→PLL1 발진원 차이는 남는다.
- 두 보드 코드·상수·데이터·스택 모두 내부 SRAM, 캐시 OFF. DMA는 벤치마크에서 사용하지 않는다.
- M4: SRAM1 physical 0x20000400에 로드하고 0x00000400 alias로 실행(ICode/DCode). SRAM3 데이터·스택, SRAM2 mailbox. Flash cache/prefetch OFF, Flash 1WS 설정은 남지만 실행·상수 읽기에 Flash를 사용하지 않는다.
- M55: AXISRAM2 0x34180400 코드, 0x341C0000 데이터, 0x341FF000 stack top/mailbox. I/D cache OFF, 해당 SRAM 전체 MPU Normal non-cacheable. AXI 경로이며 M4와 물리 구조는 같지 않다.
- 32-byte 정렬 버퍼, FN-DSA-512/1024 키 생성·서명·검증 각 100회, 크기별 워밍업 각 1회 제외.
- 이전과 동일한 결정적 32-byte key seed / 40-byte sign seed, RAW 메시지 `blah` 4 bytes, 빈 context.
- DWT 32-bit cycle 차분으로 seeded/temp API 전체 측정. 내부 재시도 포함; 시드 준비·출력 해시·로그 제외. PRIMASK=1, SysTick OFF.
- 약 60초 간격으로 코어를 정지하지 않고 mailbox 읽기. 디버그 버스 영향이 엄밀히 0이라는 보장은 없다.
- 출력 전체(sk || pk || signature)의 누적 SHAKE256 32-byte digest 및 기존 FNV 진단값을 호스트와 대조. 워밍업에서 변조 서명 거부 확인. constant-time/부채널 안전성 검증과는 별개.

## 설정 검증 및 진행

```json
{}
```

오류: timeout('timed out')

## 로그·재현

- [공통 코드·조건](../../comparison_m4_m55/README.md), [컨트롤러](../../comparison_m4_m55/controller.py).
- [메타데이터·SHA-256](session.json), [진행 상태](status.json), [원시 결과](results.json).
- [빌드 로그](build.log), [OpenOCD 로그](logs/openocd.log), [원시 mailbox](logs/mailbox.bin).
- [소스 패치](logs/source.patch), ELF·디스어셈블리·심볼·메모리 배치: `build/`.
- 측정 펌웨어 로드는 SRAM에만 수행. Flash·option bytes 기록/삭제 없음. 종료 후 해당 MCU halt 및 이 세션의 OpenOCD 종료.

### 실행 로그

```text
2026-09-09T02:01:46.646792+00:00 OpenOCD: halt
2026-09-09T02:01:47.639945+00:00 OpenOCD: dump_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_controlled/logs/flash_before.bin} 0x08000000 0x200000
2026-09-09T02:02:17.642207+00:00 ERROR timeout('timed out')

```
