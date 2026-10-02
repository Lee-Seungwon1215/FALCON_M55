# B 단계: M55 최소 이식 기준점 — 측정 완료

**2026-09-10 11:03:28 KST: 수정 후 본 측정·정합성 검증 완료.**
각 크기/연산 100회, 총 600회 계측(별도 warmup 600회)이 통과했다.
두 크기의 batch별/누적 출력 해시 22개가 호스트와 일치한다.
시작·종료 ECC 검사 ON, 종료 CFSR/HFSR/AFSR=0, 변조서명 거부 PASS.

## 최종 성능

대표값은 원본 방식인 **10개 batch total의 upper median(6번째) ÷ 10**이다.
ms는 확인된 명목 800 MHz에서 환산했다. 외부 장비로 교정한 주파수는 아니다.

| 크기 | 연산 | 대표 cycles/call | 환산 ms/call | 전체 100회 평균 cycles/call |
|---|---|---:|---:|---:|
| 512 | 키생성 | 51,998,993 | 64.998741 | 57,447,400.20 |
| 512 | 서명 | 17,434,921 | 21.793651 | 17,408,717.57 |
| 512 | 검증 | 372,321 | 0.465401 | 366,587.37 |
| 1024 | 키생성 | 261,461,140 | 326.826425 | 280,950,872.82 |
| 1024 | 서명 | 37,347,834 | 46.684793 | 37,323,628.15 |
| 1024 | 검증 | 729,270 | 0.911587 | 724,861.11 |

시작 오류는 전역 상수·초기화 테이블·`.data` 적재 위치를 DTCM으로 옮기고,
초기 DTCM scrub이 이 구역을 보존하도록 조정해 해결했다. 실행 코드는 ITCM,
작업 데이터/스택은 DTCM을 유지한다. **`mlkem-native`와 완전 동일한 배치가
아니며 이 수정은 명시적 차이점이다.** [수정 내용](diagnostics/workaround.md).
FN-DSA 암호 소스, M4 구현/보드, Flash, ECC 설정은 변경하지 않았다.
기존 실패 이미지와 원인 분리 로그는 보존했다. 아래 실패 기록은 수정 전 이력이다.

최종 ELF SHA-256:
`c415762b0c572db02f144fb77ac78a02e8af571544faab2dfa4334a5dfe1b65f`.

- [본 측정 원시 로그](runs/full-20260910T020147Z/raw.log), [세션 및 60개 원시 batch](runs/full-20260910T020147Z/run.json)
- [최종 통계/사후 감사 JSON](results.json), [파일럿 재검증](runs/pilot-20260910T020143Z/raw.log)
- [수정 빌드 감사](audit-dtcm/build_manifest.json), [ELF](build-dtcm/zephyr/zephyr.elf), [map](build-dtcm/zephyr/zephyr.map)

실측 timer 교차검사: Zephyr 80,000,221 / DWT 80,000,591 cycles, 차이 370.
main stack 65,536 B 중 보수적 사용 상한 9,624 B. `MSCR=0x1300a`는 ECCEN=1,
TECCCHKDIS=0이다. 총 계측 환산시간 49.277758초, 전체 세션 101.603191초
(warmup/출력/검사/적재 포함). 종료 후 M55 reset, OpenOCD/GDB 정상 종료 확인.

## 소스와 구현

| 항목 | 확인 결과 |
|---|---|
| 실제 컴파일 경로 | `/Users/seungwon/FALCON/fn-dsa_m55/ref` |
| A의 실제 컴파일 경로 | `/Users/seungwon/FALCON/fn-dsa_m4/ref` |
| 양쪽 원본 HEAD | `a5f15894bf1a68017074650d5298cecf9bb29a79` |
| 원본 C/H/ASM 파일 비교 | `inner.h`의 기존 M55 호환 선택/검사 패치만 다름 |
| M4 어셈블리 | 5개 파일 모두 ON; 새 어셈블리 최적화 없음 |
| binary64 연산 | 기존 `uint64_t` 표현/정수 에뮬레이션 유지; native double 전환 안 함 |
| MVE | 손으로 추가한 MVE 구현은 없음. **GCC 자동 벡터화 MVE는 존재** |

자동 MVE 명령은 `fndsa_poly_big_to_fixed`, `fndsa_mp_NTT`,
`fndsa_solve_NTRU`, 일부 다항식/다중정밀도 함수 등에 확인된다.
따라서 이 B는 `+nomve` 스칼라 빌드가 아니라, 상위 프로젝트의 M55 타깃
설정을 유지한 **컴파일러 최적화 포함 이식 기준점**이다.
정적 명령어 개수는 런타임 연산 비중이나 최적화 기여율이 아니다.

## `mlkem-native`와 맞춘 조건

기준 저장소/커밋:
[mlkem-native `637d076`](https://github.com/pq-code-package/mlkem-native/tree/637d076aa113d8faaec2277ed4a46b657acaf35f/test/zephyr).
이는 ML-KEM을 FN-DSA로 바꾸는 것이 아니라, 해당 프로젝트의 **Nucleo
실행 환경과 배치 측정 방법**을 FN-DSA API에 적용하는 작업이다.

| 항목 | B 설정 및 현재 검증 수준 |
|---|---|
| 보드/코어 | NUCLEO-N657X0-Q / STM32N657 / CPUID `0x411fd221` 실제 확인 |
| ST-LINK | `003C00223335510735383531`; M4 프로브와 분리 |
| 컴파일러 | Arm GNU 15.2.Rel1, GCC 15.2.1 20251203 |
| 옵션 | 최종 `-O3`, `-mcpu=cortex-m55 -mfpu=fpv5-sp-d16 -mfloat-abi=hard` |
| OS | Zephyr 4.4.1, CMSIS/HAL도 상위 Nix 고정 소스와 해시 일치 |
| 코드 | ITCM secure alias `0x10000000`, 256 KiB; inline literal pool 포함 |
| 전역 상수/데이터/스택 | DTCM secure alias `0x30000000`, 256 KiB; main stack 64 KiB |
| ELF 실제 점유 | ITCM 95,484 B, DTCM 상단까지 213,152 B |
| 외부 RAM 예외 | 원본 runner의 bootargs 전달 영역 `0x340b0000`, 64 KiB. 암호 작업 버퍼/스택은 아님 |
| CPU/SYSCLK/HCLK | **800/400/200 MHz**, 실행 레지스터와 HAL decode 확인 |
| 캐시/ECC | 실제 CCR=`0x611`: I/D OFF. MSCR=`0x1300a`: ECC 검사 ON |
| 타이머 | `k_cycle_get_64()`, 64-bit SysTick 확장; IRQ/SysTick 유지 |
| 반복 방법 | 크기/연산마다 10 batches × (10 warmup + 10 measured) |
| 대표값 | 10개 block total의 upper median(6번째 값) ÷ 10 |
| OpenOCD | 상위 고정 `4e9b167e1ae5ccb437eb0538440988b3f0ec53cb`도 별도 빌드 |
| Flash | 쓰기/지우기 없음; RAM 적재 방식 |

ELF 구역 이름이 `FLASH`로 출력되더라도 실제 주소는 `0x10000000` ITCM이다.
256 KiB TCM 설정 자체를 모든 접근의 0 wait-state 증명으로 해석하지 않는다.

FPU를 사용하는 M4 어셈블리의 FP 레지스터 저장/이동 명령을 실행하기 위해
`app/fndsa.conf`에 `CONFIG_FPU=y`를 명시했다. 원본 OPT=0에는 없는 조건이다.
원본 **OPT=1 최종 `.config`와 비교하면 `CONFIG_FIPS202_MVE_BACKEND=y` 부재
한 줄만 다르며 나머지 설정은 동일**하다. ML-KEM 전용 SHAKE 백엔드를 FN-DSA에
연결하지 않았다. `CONFIG_FPU=y`를 native FP64 구현으로 바꿨다는 뜻으로 읽으면 안 된다.

## 입력과 완료된 검증

- FN-DSA-512/1024 각각 키생성·서명·검증 API를 측정한다.
- 공개 결정적 seed generator는 이전 A와 동일하고, batch index 0–9를 사용한다.
  한 batch 안의 20회 호출은 같은 입력을 재사용한다. **100개의 독립 입력이 아니다.**
- 메시지 `blah`, 빈 context, `FNDSA_HASH_ID_RAW`; seeded temporary-buffer API.
- 입력 준비, SWO 출력, SHAKE-256 감사, 변조서명 거부 검사는 계측 밖에서 수행한다.
  API 내부 재시도는 계측에 포함된다.
- macOS arm64의 같은 원본 코드로 각 batch 결과 `sk || pk || sig`를 SHAKE-256
  해시했다. 각 크기 10개 결과와 누적 해시를 보드 출력과 모두 대조해 일치했다.
  이것은 실험 입력 정합성 검사이며 공식 표준 KAT 전체 통과 주장과는 구분한다.
- 원본 설정의 64-bit printf가 꺼져 있어 64-bit 수치를 계측 밖에서 십진 문자열로
  변환한다. libc 설정을 추가 변경하지 않는다.
- 파일럿에서 100 ms 구간의 Zephyr 64-bit timer와 DWT를 교차 검사하고, main stack의
  사용하지 않는 하단을 표시해 보수적인 최대 사용량을 확인한다. 이 진단은 계측 밖이다.

호스트 누적 출력 SHAKE-256:

```text
512  c455025367f3309f0ecb04b2d8784afe9d1cba965d99ae9246eb0c1528b0419b
1024 72e6bed093cb6e8ea32376824caac24cb4aa210613415aa9e14ccfede589dc67
```

## 2026-09-09 연결 문제 이력 — 재연결 후 해소

처음 읽기 확인에서 CPUID는 정상으로 확인됐다. 이후 SYSCFG/TCM 제어 레지스터
`0x56008008` 읽기가 실패했고, 다음 연결에서도 AP1의 CPUID 요청에 이전 주소의
`STLINK_SWD_AP_FAULT`가 보고됐다. SYSCFG clock gating 또는 미완료 AP 전송이
관련됐을 가능성은 있으나 원인은 확정하지 않았다.

정상 init, M55 SRST, debug-port sticky clear(`0x1e`), DAPABORT를 포함한
명시적 write(`0x1f`), 상위에 고정된 OpenOCD 버전으로도
연결 준비 실패가 재현됐다. 파일럿 실패는 펌웨어의 성능/정합성 실패가 아니라
**FLEXMEM 설정 스크립트의 core examine 단계 실패**이며, 펌웨어 적재/본 측정
전이다. M55만 USB 전원 재연결을 요청했다. M4 측정은 중단하거나 리셋하지 않았다.

다음 시도에는 clock-gated SYSCFG에 대한 선행 진단 read를 하지 않고 상위
FLEXMEM 순서부터 진행한다. 펌웨어 진단도 SYSCFG에 접근하지 않고 Cortex-M55의
MEMSYSCTL TCM 크기/활성 레지스터를 읽는다. 빌드 설정이나 암호 구현을 완화해서
성능 수치를 만드는 방식으로 우회하지 않는다.

수정 전 실패 ELF SHA-256(보존된 `build/`):
`44e351780ce356112a9d53d577a5a5b5c2831de1b43d4cec39b0b267763aabdb`.

## 로그·재실행

- [현재 빌드/소스 감사](audit-dtcm/build_manifest.json), [상위 config와 차이](audit-dtcm/upstream_config.diff)
- [환경과 버전](env/README.md), [환경 매니페스트](env/manifest.json)
- [수정 빌드 로그](build-dtcm/build.log), [생성된 ELF](build-dtcm/zephyr/zephyr.elf), [링커 map](build-dtcm/zephyr/zephyr.map)
- [전체 호스트 출력](host/full.log), [MVE 정적 위치](audit-dtcm/mve_static_sites.json)
- [첫 파일럿 준비 실패](runs/pilot-20260909T114706Z/raw.log)
- [고정 OpenOCD로 재시도한 로그](runs/pilot-20260909T115717Z/raw.log)
- [명시적 DAPABORT 시도 로그](debug_probe_dapabort.log)
- [2026-09-09 21:12 KST M55만 재시도한 로그](runs/pilot-20260909T121208Z/raw.log)
- [2026-09-09 22:25 KST M55만 재시도한 로그](runs/pilot-20260909T132541Z/raw.log)

2026-09-09 21:12:08 KST 사용자 요청으로 **M55만** 재시도했다. 고정 OpenOCD
`4e9b167`, M55 시리얼 `003C00223335510735383531`, 기존 ELF와 소스 감사 해시를
그대로 사용했다. ST-LINK 인식·타깃 전압 3.276647 V·SWD DPIDR 확인 후,
FLEXMEM 준비의 `stm32n6x.cpu arp_examine` 단계에서 동일한
`Failed to read memory at 0x56008008` 오류가 재현됐다. 이번에도 펌웨어 적재와
본 측정 전 실패했으며 M4 보드에는 접근하지 않았다. 유효한 새 B 성능 수치는 없다.

2026-09-09 22:25:41 KST 다시 M55만 재시도했다. 같은 고정 환경/ELF/시리얼을
사용했고 ST-LINK·타깃 전압 3.278243 V·SWD DPIDR은 확인됐다. 그러나 동일한
`arp_examine` 단계에서 `Failed to read memory at 0x56008008`가 재현됐다.
펌웨어 적재와 본 측정은 시작되지 않았고 M4에는 접근하지 않았다.

```sh
source env/environment.sh
bash build.sh
bash build_host.sh
python audit_build.py
python run.py pilot
# 정확히 같은 ELF의 파일럿 정합성 검사를 통과해야 실행됨:
python run.py full
python audit_result.py
```

## A → B 해석

A는 현재 M4 보드에서 선행 구현을 재측정하고 원 논문과의 차이를 기록하는
실험이다. B는 같은 암호 구현을 M55에 최소 이식한 뒤 이후 M55 최적화의
기준으로 삼는 실험이다. A와 B의 메모리·클럭·컴파일러·OS/타이머·배치 통계가
다르므로 둘의 비율을 순수 코어 성능 차이나 새 알고리즘 최적화 효과라고
주장하지 않는다. 이후 M55 구현 변경은 B와 동일 환경/입력/통계로 비교한다.

## 2026-09-10 전원 재연결 후 진단

**이 절 이하의 실패/미완료 표현은 수정 전 진단 당시의 기록이다.**
최신 상태는 맨 위의 최종 성능 및 [수정 보고서](diagnostics/workaround.md) 참조.

사용자가 M55를 분리·재연결한 뒤 **M55만** 사용했다. ST-LINK 시리얼과
기존 ELF SHA-256은 위와 같다. M4, Flash, option byte는 수정하지 않았다.
상위 FLEXMEM 설정과 RAM 적재가 통과했고, 코어의 ITCMCR/DTCMCR은 모두
`0x49`로 읽혔다(각 256 KiB 활성). 본 측정의 클럭/타이머/출력 검사는 아직
도달하지 못했다. 따라서 설정상의 800 MHz를 실측 확인했다고 주장하지 않는다.

### 시도별 실제 결과

| KST | 진단 | 결과 / 원시 로그 |
|---|---|---|
| 10:01 | 원래 RAM 적재 경로 재시도 | 연결/적재 성공, 시작 단계 fault. [로그](runs/pilot-20260910T010106Z/raw.log) |
| 10:05 | CPU의 정렬된 STRD로 ITCM/DTCM 전 영역 초기화 후 적재 | 초기화 완료, 동일 시작 문제. [로그](runs/pilot-20260910T010500Z/raw.log) |
| 10:07 | 최초 fault 진입에 하드웨어 breakpoint 추가 | 아래 `memcpy`의 precise ECC fault 포착. [로그](runs/pilot-20260910T010713Z/raw.log) |
| 10:12 | AXISRAM에 동일 이미지 적재 후 CPU LDRD/STRD로 ITCM에 복사 | 초기화/CPU 복사 완료, ELF의 16개 적재 section 모두 matched, 동일 fault. [로그](runs/pilot-20260910T011210Z/raw.log) |
| 10:13 | 고정된 `mlkem-native` OPT1 원본의 시작 단계만 실행 | `get_bootargs` 도달, CFSR/HFSR/AFSR 모두 0. main/벤치마크는 실행하지 않음. [로그](runs/upstream-startup-20260910T011338Z/raw.log) |
| 10:15 | FN-DSA ELF의 `memcpy` 명령 바이트만 진단용 AXISRAM에서 실행 | 최초 복사를 통과한 뒤 `z_sys_init_run_level`에서 instruction-fetch ECC fault. [로그](runs/fndsa-memcpy-axi-startup-20260910T011531Z/raw.log) |

처음 잡힌 fault:

```text
Zephyr arch_data_copy -> arch_early_memcpy -> memcpy
memcpy                  = 0x1001302c
stacked PC              = 0x10013076  (vldrw.u32 q3, [r12], #16)
source at this iteration= 0x100243d8
BFAR                    = 0x100243e4
CFSR                    = 0x00008200  (PRECISERR | BFARVALID)
HFSR                    = 0x40000000  (FORCED)
AFSR                    = 0x00020000  (PECC)
MEMSYSCTL.MSCR          = 0x0001300a  (ECCEN=1, TECCCHKDIS=0)
ITCMCR / DTCMCR         = 0x49 / 0x49
```

`memcpy` 바이트를 AXISRAM에서 실행한 **별도 진단**에서는 다음 fault로 진행했다:

```text
stacked PC = 0x10015c82  (z_sys_init_run_level + 10)
CFSR       = 0x00000100  (IBUSERR)
HFSR       = 0x40000000
AFSR       = 0x10000000  (FECC)
```

Arm 문서에서 PECC는 정밀 접근의 수정 불가능 ECC 오류, FECC는 명령 fetch의
수정 불가능 ECC 오류를 뜻한다. 따라서 단순한 벡터 명령 미지원/정렬 예외로
분류하지 않는다. [Cortex-M55 r1p1 TRM, AFSR 표 5-4](https://documentation-service.arm.com/static/6622c173fabc8c11c7b53a92).

### 확인된 사실과 아직 확인되지 않은 원인

- 원본 ML-KEM OPT1의 ITCM image 끝은 `0x1000f2b4`로 전체가 첫 64 KiB 안에
  들어간다. FN-DSA는 `0x10024448`까지 사용하며 fault 관련 명령/상수가 확장
  ITCM에 있다. **원본 startup 통과는 확장 영역 전체가 정상이라는 증거가 아니다.**
- 전체 TCM 초기화와 CPU 기반 이미지 복사까지 수행했지만 같은 fault가 났다.
  단순 미초기화나 debugger 전송 누락만을 원인이라고 확정할 수 없다.
- 첫 fault는 MVE load였으나, 이를 우회한 진단에서 명령 fetch도 실패했다.
  **MVE memcpy 한 함수만 바꾸면 해결된다는 근거는 없다.**
- 우선 의심 범위는 확장 ITCM의 instruction/data 접근·메모리 배치·FLEXMEM
  초기화 상호작용이다. 칩 결함, 특정 bank 충돌, 유일한 원인은 미확정이다.
- ST 커뮤니티에 확장 ITCM의 bank 간 접근 시 ECC 오류를 관찰했다는 보고가
  있으나, 해당 글의 ST 답변은 reference board 재현 여부를 묻는 수준이다.
  공식 확인된 동일 결함이나 해결책으로 취급하지 않는다.
  [관련 재현 보고와 ST 답변](https://community.st.com/stm32-mcus-products-25/reproducible-ecc-error-in-tcm-memory-following-a-certain-access-pattern-with-stm32n657i0-158561).
- 확인한 ES0620 Rev 5(2026-08)에는 이 증상에 직접 대응하는 TCM 항목을 찾지
  못했다. 이것이 결함의 존재/부재를 확정하는 것은 아니다.
  [STM32N6 errata](https://www.st.com/resource/en/errata_sheet/es0620-stm32n6xxxx-device-errata-stmicroelectronics.pdf).

### 보존 및 다음 단계

FN-DSA `ref`와 측정 ELF는 변경하지 않았다. ECC, MVE, 캐시, 목표 클럭을
임의로 끄거나 바꿔 측정값을 만들지 않았다. 위 AXISRAM 복사/함수 실행은
**진단에만 사용했고 성능 기준점으로 채택하지 않았다.** 시작 단계 비교는
`get_bootargs`에서 의도적으로 끝내므로 원본 wrapper의 `target did not hit
nucleo_test_done` 메시지는 이 진단의 종료 방식이며 성능시험 실패 판정과 다르다.

현재 기본 runner는 상위 적재 경로 + 최초 fault 포착만 사용한다. 실패한
CPU 초기화/복사는 `--loader cpu-copy`로만 선택 가능하며 valid pilot으로
등록되지 않는다. 정상 파일럿 없이 full 실행도 허용하지 않는다.

다음은 작은 독립 테스트로 고정/확장 ITCM 접근을 비교하고 배치/초기화 문제를
분리하는 작업이다. 암호 측정용 코드·상수의 메모리 종류나 ECC/클럭을 바꾸는
우회가 필요하면 변경 조건을 명시하고 사용자와 기준을 정한 후 별도 실험으로
진행해야 한다. 현재까지의 새 B 결과: **측정 전 중단, 유효 cycle 0개**.

## 추가 원인 조사: 독립 재현 완료

[원인 조사 보고서](diagnostics/cause.md)에 코드/입력 위치별 통제 실험과
[사후 바이트 감사](diagnostics/tcm_audit.json)를 정리했다. 단일 읽기 70개 조합은
각 10,000회 통과했으나, 실제 140바이트 복사는 코드가 입력과 다른 확장 ITCM
창에 있을 때 MVE와 정수 LDM 모두 ECC fault가 재현됐다. 원본 MVE 결과는 새
리셋 세션에서 반복 확인했다. 데이터만 DTCM에 옮기면 시험한 코드 위치 5개
모두 정확히 복사했다. 독립 재현은 HSI/1(명목 64 MHz), 캐시 OFF 상태이므로
800 MHz에서만 발생하는 문제도 아니다.

실리콘 결함인지 추가 설정 문제인지는 미확정이며, 상수/초기값을 DTCM에 두는
배치가 다음 검증 후보다. 이번에는 원인 조사만 수행했고 측정용 구현/배치의
해결 패치 및 본 성능 측정은 실행하지 않았다.
