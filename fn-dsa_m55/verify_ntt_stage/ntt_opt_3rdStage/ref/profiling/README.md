# FN-DSA-512 참조 C 프로파일링: M4 / M55

연결된 두 보드에서 DWT CYCCNT로 키 생성·서명·검증을 측정한다.
완료된 결과는 [비교 보고서](results/m4_m55_fndsa512_reference.md)에 있다.
호스트 실행은 정확성 검사에만 사용하며, 호스트 시간은 보드 결과로 사용하지 않는다.

## 이번 측정의 범위

- 원본: `pornin/c-fn-dsa`, 커밋 `a5f15894bf1a68017074650d5298cecf9bb29a79`.
- FN-DSA-512 (`logn=9`), 참조 C, `-O3`, LTO 없음, 명시적 벡터 최적화 없음.
- `FNDSA_ASM_CORTEXM4=0`, AVX2/SSE2/NEON/RV64D 비활성화, `FNDSA_64=0`.
- 키 생성은 고정소수점, 서명은 정수 기반 FP64 에뮬레이션 경로다. 하드웨어 FP64로 교체하지 않았다.
- 워밍업 제외 키 생성 10회, 서명 100회, 검증 100회. 입력 생성·체크섬·서명 후 확인 검증은 측정 구간 밖에 둔다.
- OS/하드웨어 RNG 대신 공개된 결정적 벤치마크 시드를 seeded/temp API에 전달한다. 이 시드를 실제 보안 목적으로 사용하면 안 된다.
- 이 디렉터리만 추가했다. 상위 원본 C/헤더, 기존 Falcon 파일, `fn-dsa_m4/ref`는 수정하지 않는다.
- **M4 논문 재현 실험이 아니다.** 논문의 보드·클럭·컴파일러·`-O2`·어셈블리 조건과 분리된 참조 C 기준선이다.

### 원본의 순수 C 링크 문제

이 커밋의 `sign_core.c`는 `mqpoly_sqnorm_int_to_signed()`를 호출하지만,
`mq.c`의 C 구현은 `#if 0 /* obsolete */` 안에 있어 어셈블리를 끄면 링크되지 않는다.
`instrument.py`는 **생성된 복사본에서만** 해당 기존 함수 몸체를 다시 활성화한다.
함수 수식은 변경하지 않으며, 계측 ON/OFF 모두 같은 수정이 적용된다.
원본 파일의 SHA-256, 함수 훅 목록, 호환성 수정은 각 `build/*/generated/manifest.json`에 기록된다.
새 업스트림 버전에서 해당 구문이 바뀌면 스크립트는 실패하므로 수정 필요성을 다시 검토해야 한다.

## 보드와 실행 환경

| 항목 | M4 | M55 |
|---|---|---|
| 대상 | STM32L4R/L4S 계열, device ID `0x470`, Flash 2 MiB | NUCLEO-N657X0-Q / STM32N657 |
| ST-LINK serial | `066DFF363355473043205442` | `003C00223335510735383531` |
| 코어 클럭 | 120 MHz, 내부 MSI → PLL | 600 MHz, 기존 Falcon FSBL 클럭 설정 |
| 코드 / 데이터 | SRAM1 / SRAM3 | AXI SRAM2 |
| 캐시 | Flash I/D 캐시 활성화, SRAM 코드에는 이득 없음 | 코어 I-cache / D-cache 활성화 |
| GDB 포트 | 3334 | 3335 |

M4의 정확한 보드명과 R/S 세부 모델은 디바이스 ID만으로 특정하지 않았다.
공통 레지스터와 메모리 구성을 위해 L4R5 CMSIS 시작 코드를 사용하며, 보드 전용 GPIO나 외부 발진기는 사용하지 않는다.
두 보드의 클럭·캐시·메모리 경로가 다르므로 시간 차이를 순수한 코어 아키텍처 차이로 해석하면 안 된다.

실행 스크립트는 선택한 보드를 리셋하고 SRAM에 프로그램을 로드한다.
Flash 기록·삭제는 하지 않지만, 현재 실행 중인 프로그램과 RAM 상태는 바뀐다.
다른 장비에서 재실행할 때는 먼저 ST-LINK serial과 대상 모델을 확인한다.
M55는 기존 Falcon 측정과 같은 디버그 가능한 개발 부팅 상태가 필요하다.

## 의존성

기본 경로는 이 작업 환경의 설치 위치다. 다른 환경에서는 Make 변수를 지정한다.

- Arm GNU Toolchain 15.3.Rel1, GCC 15.3.1:
  `/private/tmp/arm-gnu-toolchain-15.3.rel1-expanded/Payload`
- STM32CubeN6: `/private/tmp/STM32CubeN6`, 커밋 `80a3a665fccaf9a429343a7ab96a97c1b8a6467a`.
- M55 클럭 코드·링커 스크립트: `../../falcon_ref/profiling/stm32n657/`의 기존 파일.
- M4 HAL/CMSIS Device: `/Users/seungwon/.platformio/packages/framework-arduinoststm32/system`
  (패키지 4.21200.0, STM32L4 HAL 1.13.6).
- M4 CMSIS Core: `/Users/seungwon/.platformio/packages/framework-cmsis/CMSIS/Core/Include`
  (패키지 2.60300.0).
- M4 OpenOCD: `/Users/seungwon/test/.tools/xpack-openocd-0.12.0-7/bin/openocd`.
- M55 OpenOCD: `/private/tmp/falcon-openocd/bin/openocd` (`stm32n6x` 지원 빌드).
- Python 3, Make; 호스트 정확성 검사에는 Clang.

## 빌드 및 측정

이 디렉터리에서 실행한다. 빌드만으로는 보드에 접근하지 않는다.

```sh
make -s TARGET=m4 INSTRUMENT=1
make -s TARGET=m55 INSTRUMENT=1
make -s TARGET=m4 INSTRUMENT=0
make -s TARGET=m55 INSTRUMENT=0
```

설치 위치가 다른 경우 `ARM_GCC_ROOT=... STM32CUBE_N6=... STM32L4_SYSTEM=... CMSIS_CORE=...`를 Make 인수로 지정한다.
컴파일러 경로를 변경했다면 실행할 때도 같은 `ARM_GCC_ROOT` 환경변수를 지정한다.

각 OpenOCD 서버를 별도 터미널에서 시작한다. 이미 같은 서버가 실행 중이면 중복 실행하지 않는다.

```sh
/Users/seungwon/test/.tools/xpack-openocd-0.12.0-7/bin/openocd -f openocd_m4.cfg
```

```sh
/private/tmp/falcon-openocd/bin/openocd -f openocd_m55.cfg
```

각 보드를 실행하고 완료 시 RAM의 결과를 JSON으로 읽는다.

```sh
python3 run_board.py m4
python3 run_board.py m55
python3 run_board.py m4 --instrument 0
python3 run_board.py m55 --instrument 0
python3 report.py
```

결과는 `results/`의 기존 동일 이름 파일을 갱신한다. 이전 측정을 보존하려면 실행 전에 별도 보관한다.
GDB에 내장 Python이 없어도 실행 가능하다. `capture.gdb`가 JSON을 출력하고 호스트 Python이 검증한다.
`--capture-only`는 동일 빌드가 이미 완료된 뒤 결과를 다시 읽을 때만 사용한다.

## 분류 및 검증

`instrument.py`의 `HOOKS`가 함수별 분류의 원본이다. `profile.c`는 중첩 호출 중 가장 안쪽 분류에만 시간을 부과한다.
따라서 각 단계의 정수 사이클 합계는 전체 사이클과 정확히 일치한다. 백분율 표시에는 반올림 차이가 생길 수 있다.
SHAKE/Keccak-f는 호출 위치와 관계없이 별도 분류한다. Hash-to-Point·Gaussian·NTRU 등의 비중에 SHAKE를 중복해서 넣지 않는다.
기존 Falcon 결과와는 세부 항목의 경계가 다를 수 있으므로 같은 이름의 백분율을 바로 비교하지 않는다.

재귀적 ffSampling, LDL, FFT, NTT 등 큰 함수 경계에 계측하며 개별 `fpr_add`/`fpr_mul`에는 훅을 넣지 않는다.
계측 비용은 제거하지 않는다. 별도 `INSTRUMENT=0` 빌드의 전체 시간과 비교하여 훅 및 코드 배치 변화의 영향을 보고한다.
DWT의 32비트 wrap은 읽을 때 64비트로 확장한다. 연속 타이머 읽기 간격이 한 wrap보다 짧아야 하며 이번 입력의 API 최대 시간이 그 조건을 만족한다.

호스트 정확성 검사:

```sh
make -s TARGET=host test
make -s TARGET=host INSTRUMENT=1 run
make -s TARGET=host INSTRUMENT=0 run
```

업스트림 전체 테스트와 KAT, 보드의 정상 서명 검증 및 변조 서명 거부를 확인했다.
호스트/두 보드의 계측 ON/OFF 생성물 누적 FNV-1a 체크섬은 모두 `0x21d16142`다.
체크섬은 진단용이며 암호학적 동등성 증명은 아니다.

## 파일 안내

- `bench.c`: 입력·반복 횟수·API 측정·확인 검증.
- `profile.h`, `profile.c`: 분류·배타적 계측·DWT 타이머.
- `instrument.py`: 원본을 보존하는 계측용 C 생성 및 호환성 수정.
- `platform_m4.c`, `platform_m55.c`, 링커·HAL 설정: 보드 초기화 및 SRAM 실행.
- `run_board.py`, `run_*.gdb`, `capture.gdb`, `openocd_*.cfg`: 장비 선택·실행·수집.
- `report.py`: 네 번의 보드 실행 결과 검증 및 비교 보고서 생성.
- `results/*.json`, `results/*.log`: 원시 사이클과 실행 로그.
- `build/`: 생성 C, 원본 해시 manifest, 실행 ELF 및 map; Git에서 제외.
