# FN-DSA M4: SRAM / cache OFF / CPU·HCLK 24 MHz

상태: **동일 조건 100회 본 측정 중** (2026-09-09T02:08:25.962828+00:00).

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
  "iteration": 72,
  "operation": 0,
  "cpuid": 1091551809,
  "core_clock_hz": 24000000,
  "hclk_hz": 24000000,
  "cache_control": 512,
  "vtor": 536871936,
  "primask": 1,
  "assembly": 1,
  "m55_compat": 0,
  "gcc_version": 130201,
  "mve_compiled": 0,
  "mvfr0": 0,
  "mvfr1": 0,
  "mvfr2": 0,
  "cpacr": 15728640,
  "fpscr": 0,
  "mpu_ctrl": 0,
  "counts": [
    [
      72,
      72,
      72
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
    1125729620,
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
  "device_id": 270492784,
  "flash_acr": 1,
  "pclk1_hz": 24000000,
  "pclk2_hz": 24000000,
  "pclk4_hz": 0,
  "pclk5_hz": 0,
  "clock_registers": [
    155,
    0,
    4096,
    1,
    512,
    256,
    0,
    0,
    0,
    0,
    0,
    0
  ],
  "mem_remap": 3,
  "dwt_control": 1073741825,
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

클럭 교차 확인(READY 상태, 본 계측 전): `{"elapsed_seconds": 3.0113091874999967, "observed_cycles": 72283081, "inferred_hz": 24003872.236052174, "read_time_uncertainty_seconds": 0.0018195625000032578}`. 호스트 시간 대조이며 외부 정밀 계측기로 보정한 값은 아니다.

## 로그·재현

- [공통 코드·조건](../../comparison_m4_m55/README.md), [컨트롤러](../../comparison_m4_m55/controller.py).
- [메타데이터·SHA-256](session.json), [진행 상태](status.json), [원시 결과](results.json).
- [빌드 로그](build.log), [OpenOCD 로그](logs/openocd.log), [원시 mailbox](logs/mailbox.bin).
- [소스 패치](logs/source.patch), ELF·디스어셈블리·심볼·메모리 배치: `build/`.
- 측정 펌웨어 로드는 SRAM에만 수행. Flash·option bytes 기록/삭제 없음. 종료 후 해당 MCU halt 및 이 세션의 OpenOCD 종료.

### 실행 로그

```text
2026-09-09T02:03:19.375957+00:00 OpenOCD: halt
2026-09-09T02:03:20.364953+00:00 OpenOCD: dump_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_controlled/logs/flash_before.bin} 0x08000000 0x200000
2026-09-09T02:03:52.852521+00:00 dumped 2097152 bytes in 32.486416s (63.042 KiB/s)
2026-09-09T02:03:52.856772+00:00 OpenOCD: reset halt
2026-09-09T02:03:53.038935+00:00 OpenOCD: load_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_controlled/build/firmware.bin} 0x20000400 bin
2026-09-09T02:03:56.115280+00:00 103340 bytes written at address 0x20000400
downloaded 103340 bytes in 3.075043s (32.818 KiB/s)
2026-09-09T02:03:56.115941+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_controlled/build/firmware.bin} 0x20000400 bin
2026-09-09T02:03:59.162066+00:00 verified 103340 bytes in 3.044997s (33.142 KiB/s)
2026-09-09T02:03:59.164680+00:00 OpenOCD: write_memory 0x40021060 32 {0x00000001}
2026-09-09T02:03:59.167868+00:00 OpenOCD: write_memory 0x40010000 32 {0x00000003}
2026-09-09T02:03:59.169565+00:00 OpenOCD: verify_image {/Users/seungwon/FALCON/fn-dsa_m4/measurement_controlled/build/firmware.bin} 0x00000400 bin
2026-09-09T02:04:02.277566+00:00 verified 103340 bytes in 3.107021s (32.481 KiB/s)
2026-09-09T02:04:02.278477+00:00 OpenOCD: reg sp 0x200a0000
2026-09-09T02:04:02.279281+00:00 sp (/32): 0x200a0000
2026-09-09T02:04:02.279637+00:00 OpenOCD: reg msp 0x200a0000
2026-09-09T02:04:02.280179+00:00 msp (/32): 0x200a0000
2026-09-09T02:04:02.280483+00:00 OpenOCD: reg psp 0x200a0000
2026-09-09T02:04:02.281038+00:00 psp (/32): 0x200a0000
2026-09-09T02:04:02.281448+00:00 OpenOCD: reg xpsr 0x01000000
2026-09-09T02:04:02.282031+00:00 xpsr (/32): 0x01000000
2026-09-09T02:04:02.282369+00:00 OpenOCD: reg primask 0x00000000
2026-09-09T02:04:02.282903+00:00 primask (/1): 0x00
2026-09-09T02:04:02.283499+00:00 OpenOCD: reg basepri 0x00000000
2026-09-09T02:04:02.284279+00:00 basepri (/8): 0x00
2026-09-09T02:04:02.284735+00:00 OpenOCD: reg faultmask 0x00000000
2026-09-09T02:04:02.285498+00:00 faultmask (/1): 0x00
2026-09-09T02:04:02.285944+00:00 OpenOCD: reg control 0x00000000
2026-09-09T02:04:02.286551+00:00 control (/3): 0x00
2026-09-09T02:04:02.286847+00:00 OpenOCD: resume 0x0000d0a4
2026-09-09T02:04:25.520729+00:00 READY: both warmups, output SHAKE256 digests, tampered-signature rejection, clocks and cache settings passed.
2026-09-09T02:04:25.521628+00:00 clock probe: {"elapsed_seconds": 3.0113091874999967, "observed_cycles": 72283081, "inferred_hz": 24003872.236052174, "read_time_uncertainty_seconds": 0.0018195625000032578}
2026-09-09T02:04:25.861366+00:00 OpenOCD: write_memory 0x20030088 32 {0x474f3130}
2026-09-09T02:04:25.873298+00:00 counts=[[0, 0, 0], [0, 0, 0]] degree=512 index=0 op=0 state=0x52554e21
2026-09-09T02:05:25.897122+00:00 counts=[[19, 19, 19], [0, 0, 0]] degree=512 index=19 op=0 state=0x52554e21
2026-09-09T02:06:25.916537+00:00 counts=[[35, 35, 35], [0, 0, 0]] degree=512 index=35 op=0 state=0x52554e21
2026-09-09T02:07:25.943489+00:00 counts=[[54, 54, 54], [0, 0, 0]] degree=512 index=54 op=0 state=0x52554e21
2026-09-09T02:08:25.961800+00:00 counts=[[72, 72, 72], [0, 0, 0]] degree=512 index=72 op=0 state=0x52554e21

```
