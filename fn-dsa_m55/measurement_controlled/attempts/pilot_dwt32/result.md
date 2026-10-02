# FN-DSA M55: SRAM / cache OFF / CPU·HCLK 24 MHz

상태: **동일 조건 100회 본 측정 중** (2026-09-09T02:08:48.541855+00:00).

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
{
  "magic": 1178815824,
  "version": 1,
  "state": 1381322273,
  "error": 0,
  "runs": 100,
  "degree": 512,
  "iteration": 18,
  "operation": 0,
  "cpuid": 1092604449,
  "core_clock_hz": 24000000,
  "hclk_hz": 24000000,
  "cache_control": 513,
  "vtor": 873989120,
  "primask": 1,
  "assembly": 1,
  "m55_compat": 1,
  "gcc_version": 130201,
  "mve_compiled": 0,
  "mvfr0": 269550113,
  "mvfr1": 303038993,
  "mvfr2": 64,
  "cpacr": 15728640,
  "fpscr": 262144,
  "mpu_ctrl": 5,
  "counts": [
    [
      18,
      18,
      18
    ],
    [
      0,
      0,
      0
    ]
  ],
  "warmup_fingerprint": [
    4053617184,
    4181047927
  ],
  "fingerprint": [
    1913850288,
    0
  ],
  "command": 1196372272,
  "fault_registers": [
    0,
    0,
    0,
    0,
    0
  ],
  "device_id": 0,
  "flash_acr": 0,
  "pclk1_hz": 24000000,
  "pclk2_hz": 24000000,
  "pclk4_hz": 24000000,
  "pclk5_hz": 24000000,
  "clock_registers": [
    858980352,
    0,
    3211264,
    3211264,
    3211264,
    3211264,
    4213504,
    0,
    1224736773,
    2357198848,
    24000000,
    24000000
  ],
  "mem_remap": 0,
  "dwt_control": 2147483649,
  "output_digest": [
    [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ],
    [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ]
  ],
  "warmup_digest": [
    [
      710823756,
      3161443728,
      3043565509,
      864562664,
      2359685779,
      3224530124,
      2158862127,
      568738672
    ],
    [
      4178381717,
      2099356519,
      3791872295,
      157760929,
      3129081602,
      2231489965,
      3199367593,
      539664458
    ]
  ]
}
```

클럭 교차 확인(READY 상태, 본 계측 전): `{"elapsed_seconds": 3.0114639789999913, "observed_cycles": 72281420, "inferred_hz": 24002086.860093307, "read_time_uncertainty_seconds": 0.0014084379999985686}`. 호스트 시간 대조이며 외부 정밀 계측기로 보정한 값은 아니다.

## 로그·재현

- [공통 코드·조건](../../comparison_m4_m55/README.md), [컨트롤러](../../comparison_m4_m55/controller.py).
- [메타데이터·SHA-256](session.json), [진행 상태](status.json), [원시 결과](results.json).
- [빌드 로그](build.log), [OpenOCD 로그](logs/openocd.log), [원시 mailbox](logs/mailbox.bin).
- [소스 패치](logs/source.patch), ELF·디스어셈블리·심볼·메모리 배치: `build/`.
- 측정 펌웨어 로드는 SRAM에만 수행. Flash·option bytes 기록/삭제 없음. 종료 후 해당 MCU halt 및 이 세션의 OpenOCD 종료.

### 실행 로그

```text
2026-09-09T02:01:50.715137+00:00 OpenOCD: halt
2026-09-09T02:01:50.717980+00:00 OpenOCD: reset halt
2026-09-09T02:01:50.852221+00:00 OpenOCD: load_image {/Users/seungwon/FALCON/fn-dsa_m55/measurement_controlled/build/firmware.bin} 0x34180400 bin
2026-09-09T02:01:51.663875+00:00 110316 bytes written at address 0x34180400
downloaded 110316 bytes in 0.810000s (133.001 KiB/s)
2026-09-09T02:01:51.664747+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m55/measurement_controlled/build/firmware.bin} 0x34180400 bin
2026-09-09T02:01:52.481593+00:00 verified 110316 bytes in 0.817000s (131.861 KiB/s)
2026-09-09T02:01:52.481742+00:00 OpenOCD: reg sp 0x341ff000
2026-09-09T02:01:52.482085+00:00 sp (/32): 0x341ff000
2026-09-09T02:01:52.482159+00:00 OpenOCD: reg msp 0x341ff000
2026-09-09T02:01:52.482281+00:00 msp (/32): 0x341ff000
2026-09-09T02:01:52.482331+00:00 OpenOCD: reg psp 0x341ff000
2026-09-09T02:01:52.482439+00:00 psp (/32): 0x341ff000
2026-09-09T02:01:52.482522+00:00 OpenOCD: reg xpsr 0x01000000
2026-09-09T02:01:52.482628+00:00 xpsr (/32): 0x01000000
2026-09-09T02:01:52.482678+00:00 OpenOCD: reg primask 0x00000000
2026-09-09T02:01:52.482774+00:00 primask (/1): 0x00
2026-09-09T02:01:52.482834+00:00 OpenOCD: reg basepri 0x00000000
2026-09-09T02:01:52.482930+00:00 basepri (/8): 0x00
2026-09-09T02:01:52.482979+00:00 OpenOCD: reg faultmask 0x00000000
2026-09-09T02:01:52.483080+00:00 faultmask (/1): 0x00
2026-09-09T02:01:52.483179+00:00 OpenOCD: reg control 0x00000000
2026-09-09T02:01:52.483296+00:00 control (/3): 0x00
2026-09-09T02:01:52.483346+00:00 OpenOCD: resume 0x3418dcbc
2026-09-09T02:03:48.115466+00:00 READY: both warmups, output SHAKE256 digests, tampered-signature rejection, clocks and cache settings passed.
2026-09-09T02:03:48.116515+00:00 clock probe: {"elapsed_seconds": 3.0114639789999913, "observed_cycles": 72281420, "inferred_hz": 24002086.860093307, "read_time_uncertainty_seconds": 0.0014084379999985686}
2026-09-09T02:03:48.441303+00:00 OpenOCD: write_memory 0x341ff088 32 {0x474f3130}
2026-09-09T02:03:48.445695+00:00 counts=[[0, 0, 0], [0, 0, 0]] degree=512 index=0 op=0 state=0x52554e21
2026-09-09T02:04:48.463202+00:00 counts=[[3, 3, 3], [0, 0, 0]] degree=512 index=3 op=0 state=0x52554e21
2026-09-09T02:05:48.480678+00:00 counts=[[7, 7, 7], [0, 0, 0]] degree=512 index=7 op=0 state=0x52554e21
2026-09-09T02:06:48.501831+00:00 counts=[[11, 11, 11], [0, 0, 0]] degree=512 index=11 op=0 state=0x52554e21
2026-09-09T02:07:48.522327+00:00 counts=[[15, 15, 15], [0, 0, 0]] degree=512 index=15 op=0 state=0x52554e21
2026-09-09T02:08:48.540887+00:00 counts=[[18, 18, 18], [0, 0, 0]] degree=512 index=18 op=0 state=0x52554e21

```
