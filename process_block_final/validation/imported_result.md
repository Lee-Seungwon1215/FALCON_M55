# process_block: 입력·출력/비트 변환 MVE 최적화 결과

측정일: 2026-10-01. 대상: **단일 Keccak `fndsa_sha3_process_block()`**.
비교군과 최적화본을 모두 같은 실물 **NUCLEO-N657X0-Q**에서 실행했다.
이 표는 M4 보드 대비 M55 보드 성능이 아니라,
**M55에서 원본 M4 ASM과 IO-only M55 ASM을 비교한 값**이다.

## 핵심 결과

| 측정 대상 | 원본 cycles | IO-only MVE cycles | 속도 배율 | cycle 감소 |
| --- | ---: | ---: | ---: | ---: |
| 입력·출력 + 비트 변환 | 2,121 | 1,400 | **1.515배** | **33.99%** |
| 실제 비트 변환 처리 경계 | 1,848 | 1,155 | **1.600배** | **37.50%** |
| 초기 열 XOR + 24라운드 전체 core | 11,228 | 11,228 | 1.000배 | 0.00% |
| **전체 process_block, 계측 없는 생산 명령** | **13,383** | **12,662** | **1.057배** | **5.39%** |
| 전체 함수, core 실행 주소까지 맞춘 추가 대조 | 13,385 | 12,664 | 1.057배 | 5.39% |

배율 = 원본/후보, 감소율 = `100×(1−후보/원본)`.
대표값은 100개 표본의 중앙값이다.
함수 전체에서 **721 cycles** 줄었으며, 별도 IO 구간에서도 721 cycles 줄었다.
IO 이외의 24라운드 계산을 변경하지 않은 이번 범위와 일치한다.

**이 수치는 전체 키생성·서명·검증 API의 개선율이 아니다.**
NTT·FFT는 양쪽에서 동일하며 이번 성능 표에는 단일 Keccak 커널만 포함한다.
입출력 구간은 원본 함수의 약 16%이므로, 그 구간의 1.515배 개선이
함수 전체에서는 약 5.39% 감소로 나타난다.

### 구간 계측을 읽을 때 주의

- `io`는 입력 로드/상태 배치/비트 분리와 출력 재배열/비트 복원/저장을 합친 경계다.
- `bits`는 `io`의 **부분집합**이다. 둘을 더하면 중복 집계다.
- 원본 bits는 실제 scalar helper 호출 10개의 합, 후보 bits는 in-place
  MVE 변환 두 구간의 합이다. 후보의 필요한 vector load/store도 포함한다.
  따라서 순수 비트 산술만의 동일 함수 호출 비교라고 해석하면 안 된다.
- 구간별 프로브는 separate firmware에 삽입했다. 프로브당 8 cycles의
  빈 구간 calibration을 차감했지만, 파이프라인·코드 배치 영향까지
  완전히 없어진 것은 아니다. 구간값은 진단용이고, 최종 판단은 plain 전체 값이다.
- 한 표본은 전체 함수 64회 묶음이다. 구간 trace는 그 묶음의 마지막 호출을
  저장하며, 100개 표본으로 집계한다.
- 구간 합을 억지로 100%로 맞추지 않았다. prologue/epilogue·경계·계측
  영향이 별도로 있어 plain 전체 값과 정확히 같은 분모가 아니다.

## 직접 구현한 변경

[sha3_cm55.s](sha3_cm55.s)에만 새 암호 계산을 작성했다.
원본 [sha3_cm4.s](sha3_cm4.s), [sha3.c](sha3.c)는 보존했다.

- 한 상태의 64-bit word 네 개를 low/high 32-bit 벡터로 읽는다.
- `IO_SWAP`의 shift/XOR/AND로 even/odd 비트를 병렬 분리·복원한다.
- `VREV32.8`과 마스크로 원본 REV/SEL의 가운데 두 byte 교환을 처리한다.
- `VMOV + VSLI + VSRI`의 halfword 삽입을 이용해 packing을 세 명령으로 단축했다.
- 마스크는 Q4–Q7에 한 번 준비해 재사용한다.
- 20개 word는 5×4개 unroll, 마지막 1개는 원본 scalar 변환을 inline으로 처리한다.
- 입력 변환은 D-state 로드 전, 출력 변환은 D-state 저장 후에만 실행해
  Q/D 레지스터의 alias 충돌을 피했다.

원본 helper들의 코드 앞부분 **1,284 B는 byte-identical**이다.
초기 열 XOR, θ·ρ·π·χ·ι, 다음 라운드 열 XOR를 포함하는 core 소스와
round constant는 원본과 동일하다. 새 process_block에서는 helper BL 호출을 없앴다.

원본은 rate와 LR에 r14를 공유해, 이 실행 환경에서 실제로 처음21개 word를
변환한다. `r=9/13/17/18/21`의 oracle 시험으로 확인했고,
후보도 **A[0..20] canonical / A[21..24] split**의 실제 경계 계약을 유지했다.
원본의 이 rate 처리 자체를 수정하지 않았다.

## 후보 선택 및 비용

초기 일반 스택 benchmark에서 원본은 13,382 cycles였다.
아래는 탐색 기록이며, 위 최종 표의 고정 상태/스택 재측정과 구분한다.

| 후보 | 변경 | 초기 whole cycles | 판정 |
| --- | --- | ---: | --- |
| IO1 | 4-word unroll, 묶음마다 mask 준비, 긴 packing | 12,760 | 보존 |
| IO2 | 위 묶음을 5회 루프로 변경 | 12,814 | IO1보다 54 cycles 느려 채택 안 함 |
| **IO3, 현재 생산 파일** | unroll + mask 한 번 준비 + 3명령 packing | **12,662** | **현재 채택** |

IO1/IO2 소스는 [validation/candidates](validation/candidates)에 남겼다.
원본/A14/C9 등 다른 연구 후보나 `process_block2..5`는 변경하지 않았다.

| 자원 | 원본 | 현재 후보 | 차이 |
| --- | ---: | ---: | ---: |
| sha3 ASM .text, 기존 helper/RC 포함 | 4,184 B | 6,364 B | **+2,180 B** |
| process_block + RC | 2,900 B | 5,080 B | +2,180 B |
| 함수 스택 | 184 B | 184 B | 0 |
| 새 임시 상태 배열/heap | 0 B | 0 B | 0 |

unroll의 코드 증가를 속도와 교환한 결과다. 이 실험의 전체 펌웨어들은
256 KiB ITCM / 256 KiB DTCM 범위에서 링크되고 실제로 실행됐다.
라이브러리도 이 폴더의 20개 C + 10개 ASM으로 독립 빌드했다.

## 속도·정확성·KAT·서명검증·상수시간 관련 검사

| 검사 | 실제 결과 |
| --- | --- |
| 독립 canonical Keccak oracle | 1,024회 permutation: 비트 불일치 0 |
| 활성 MVE 경계·walking bits·guard | 1,600건: 정렬 4종 × rate 5종 × 입력 80종, 통과 |
| 원본 scalar helper oracle/왕복 | 5,120건 통과. 새 MVE의 직접 검사로 대신 간주하지 않음 |
| SHAKE256 | 독립 Python hashlib 출력과 7개 메시지 일치, 각 256 B 출력 |
| SHAKE128 | 7개 메시지 일치, 각 384 B 출력 |
| ABI | 16건, R4–R11 및 D8–D15 보존 |
| 키생성 KAT | **300/300 일치**, n=256/512/1024 각100건, NTRU 방정식 검사 통과 |
| 서명 KAT | **90/90 일치**, n=4..1024 시험군, 정상 검증/변조 거부 통과 |
| API 오류·경계 검사 | 정상 64건 수락, 잘못된 입력 3,902건 거부, failure/guard 0 |
| 하드웨어 | 유효 실행에서 CFSR/HFSR/AFSR=0, TCM/ECC 설정 확인 |

정수 bit permutation이므로 FP 근사 오차라는 지표는 적용하지 않는다.
시험한 입력의 정확성은 **bit-exact**로 검사했다. 유한 시험은 모든 입력 동등성의 증명이 아니다.

[정적 감사](validation/static_audit.json):
생산 process_block은 leaf이며, 조건 분기는 고정24회 카운터의 종료 검사 하나뿐이다.
상태 주소는 고정 증가, 스택은 고정 offset, RC index는 고정 round counter를 사용한다.
나머지 암호 소스들이 현재 Before_slothy와 같은 것도 확인했다.

plain 이미지의 zero/random 두 입력군을 각각1,000회 interleave 측정:
두 군 모두 raw wrapper **12,665 cycles**, min=max, 관측 차이0.
이 값은 제어 overhead를 빼지 않아 net 12,662와 구분한다.
**전체 상수시간의 형식적 증명·새 전력/EM 평가·fault injection 검증은 수행하지 않았다.**

## 같은 위치를 이용한 대조

plain의 함수 entry와 state/stack 주소는 양쪽 동일하다.
구현 길이가 달라 core 주소가 이동하므로, 별도 aligned 시험에서
**양쪽 모두 같은 unconditional branch + padding**을 넣어 core 주소를 맞췄다.

| 위치 | 양쪽 고정 주소 |
| --- | --- |
| process_block entry | 0x10000844 |
| core loop | 0x10001138 |
| final output 시작 | 0x1000173c |
| state guard object / 실제 A 배열 | 0x30003000 / 0x30003020 |
| timed stack top | 0x30005000 |

aligned padding은 생산 ASM에 들어가지 않는다. 이것은 측정용 원인 대조다.
그 대조에서도 721 cycles 차이가 유지돼 개선이 단순 core 정렬 변화에만
의존하지 않는다는 근거를 얻었다.

## 보드·빌드·계측 조건

- 실제 NUCLEO-N657X0-Q, STM32N657, ST-Link `003C00223335510735383531`.
- CPU **800 MHz** 확인. pinned Nucleo 설정의 SYSCLK/HCLK는 400/200 MHz.
- code ITCM, 상수·데이터·스택 DTCM, 각각256 KiB 확장.
  I/D cache OFF, ECC ON. 측정 중 interrupt OFF.
- GNU Arm GCC15.2.1, Zephyr4.4.1, mlkem-native pin
  `637d076aa113d8faaec2277ed4a46b657acaf35f`.
- `-O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard`,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- DWT CYCCNT, warm-up5개 묶음 후100표본 ×64회, 빈 loop overhead 차감.
  입력 생성/oracle/printf는 타이밍 밖. 동일 deterministic 입력 생성기.
- 원본과 후보는 다른 firmware를 직렬 실행하며 같은 물리 보드와 공유 lock을 사용.

중간 `mve-io/20261001T072406Z`는 PC의 디스크 부족으로 GDB 스크립트 생성에
실패한 **무효 측정**이다. [실패 로그](validation/io_profile/results/mve-io/20261001T072406Z/raw.log)를 보존하고 집계에서 제외했다.
빌드가 ITCM–DTCM 주소 사이 빈 공간 때문에 생성하던 512 MiB flat BIN들을
이번 작업의 build 경로에서만 정리했다. ELF·소스·로그는 유지했다.
현재 incidental BIN/HEX는 코드 부분만 생성하므로 배포용 full image가 아니다.
실제 board loader는 **모든 DTCM 구간을 포함한 full ELF**를 사용하며,
이 byproduct 제한은 암호 구현 선택이나 성능을 바꾸는 빌드 옵션이 아니다.

## 원본/최종 hash와 증거

- 원본 sha3_cm4.s:
  `b313a4da7943202e97ed6753c71ebbf20d9fb9e2f44ce7cd67007e2461b6c830`.
- 현재 sha3_cm55.s:
  `8d0588db4ef95cd5f0f32774cd84e6e6e6e91b97390b96a635dac5d99862d2ce`.
- [통계·실행 index](validation/io_profile/summary.json), [정적 감사](validation/static_audit.json).
- [최종 plain 원본](validation/io_profile/results/ref-plain/20261001T074815Z/raw.log),
  [최종 plain 후보](validation/io_profile/results/mve-plain/20261001T074812Z/raw.log).
- [최종 oracle/ABI 재검사](validation/results/mve/20261001T074808Z/raw.log).
- [IO 원본](validation/io_profile/results/ref-io/20261001T073455Z/raw.log),
  [IO 후보](validation/io_profile/results/mve-io/20261001T073452Z/raw.log).
- [bits 원본](validation/io_profile/results/ref-bits/20261001T073540Z/raw.log),
  [bits 후보](validation/io_profile/results/mve-bits/20261001T073537Z/raw.log).
- [core 원본](validation/io_profile/results/ref-core/20261001T073548Z/raw.log),
  [core 후보](validation/io_profile/results/mve-core/20261001T073544Z/raw.log).
- [aligned 원본](validation/io_profile/results/ref-aligned/20261001T073503Z/raw.log),
  [aligned 후보](validation/io_profile/results/mve-aligned/20261001T073459Z/raw.log).
- [키생성 KAT](validation/results/mve_kat/20261001T071538Z/raw.log),
  [서명 KAT](validation/results/mve_sigkat/20261001T072333Z/raw.log),
  [API 검사](validation/results/mve_api/20261001T072343Z/raw.log).

각 유효 실행 폴더에 full ELF, map, disassembly, sources.tar.gz,
컴파일 명령, 소스/ELF/log hash와 manifest를 보관했다.
재현 명령은 [README.md](README.md).
