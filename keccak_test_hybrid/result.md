# M55 hybrid 결과 — 2026-09-30

## 최신: 원본 호환 키생성·검증 네 건 배치

`keccak_test_hybrid`의 기존 MVE x4 permutation을 **독립적인 키생성 네 건 및
검증 네 건**에 연결했다. 원래 SHAKE 입력/순서/도메인을 유지한다.
단일 API를 새 PRNG로 교체한 것이 아니다. 기존 서명 x4 코드는 그대로이며
그 경로의 원본 KAT 불일치가 해결됐다는 뜻도 아니다.

기준: 현재 `Final_code/Before_slothy`의 원래 키생성/검증 함수를 각각 네 번 호출.
NTT/FFT 최적화가 이미 있는 기준이며 최초 `M55_ref`가 아니다.
비교군은 함수 이름만 바꾼 테스트 전용 복사본으로 같은 ELF에 들어간다.
NTT/FFT·단일 SHAKE·원본 Gaussian·codec은 같은 코드를 공유한다.

### 네 건 전체 성능

원본 cycles / 배치 cycles = 속도 배율. 입력 준비·prefix 생성·출력 저장·호출 비용
모두 포함한다. 출력 검사·로그·사용 후 wipe는 양쪽 모두 시간에서 제외했다.

| 연산 | 크기 | 정책 | 원본 4건 cycles | 배치 4건 cycles | 속도 배율 | cycles 감소 |
|---|---:|---|---:|---:|---:|---:|
| 키생성 | 512 | prefix 32 blocks/lane | 192,689,333.50 | 192,255,805.50 | 1.00225× | 0.225% |
| 키생성 | 512 | **prefix 64 blocks/lane** | 192,689,333.50 | 192,132,773.50 | **1.00290×** | **0.289%** |
| 키생성 | 1024 | prefix 32 blocks/lane | 1,010,371,419.50 | 1,009,678,981.00 | 1.00069× | 0.069% |
| 키생성 | 1024 | **prefix 64 blocks/lane** | 1,010,371,419.50 | 1,009,187,222.00 | **1.00117×** | **0.117%** |
| 검증 | 512 | hash/Hash-to-Point x4 | 1,296,610.94 | 972,697.56 | **1.33301×** | **24.982%** |
| 검증 | 1024 | hash/Hash-to-Point x4 | 2,493,010.56 | 1,894,730.19 | **1.31576×** | **23.998%** |

해석: **검증은 뚜렷한 처리량 이득, 키생성은 연결은 됐지만 이득이 매우 작다.**
키생성은 prefix 이후의 SHAKE, 마지막 공개키 해시, NTRU solve 등을 여전히 원래
방식으로 실행한다. 시험하지 않은 prefix 크기나 스케줄로 큰 이득을 보장하지 않는다.
이 수치는 단일 요청 latency 개선이나 현재 KAT 변경형 서명의 재측정 결과가 아니다.

표본: 크기마다 서로 다른 입력 8개를 두 개의 4건 배치로 구성. 배치당 warm-up 1회,
측정 3회. 배치별 중앙값 둘의 산술평균. 검증은 timed sample마다 배치를 8회 호출한
시간을 8로 나눴다. 키생성의 입력별 재시도 편차가 커서 큰 표본에서의 우월성을
증명하는 표가 아니며, 특히 0.1~0.3% 키생성 이득은 채택 근거로 과대평가하지 않는다.
양쪽은 동일 scratch 및 출력 주소를 사용하지만 서로 다른 함수의 코드 주소까지
겹쳐 고정한 시험은 아니다.

### 정확성 및 검사 범위

- SHAKE x4 vs 기존 단일 SHAKE 출력/연속 상태 대조 **9,216회 통과**.
  입력 길이 0/1/7/135/136/137/271/272/1024, fragment/빈 fragment,
  prefix 0/1/2/7/112/128 blocks, 이후 단일 SHAKE로 211-byte continuation 포함.
- 키생성 **164회 원본 sk/pk 전체 byte-exact 대조 통과**.
  이는 반복 포함이며 고유 키 입력은 **20개**(동일 크기 16 + 혼합 크기 4)다.
  기본 16개 입력은 별도 portable `fn-dsa_ref`의 출력 digest도 대조했다.
- 검증 명시적 정상 판정 **72회**, 변조/잘못된 길이/잘못된 external-mu 등
  **50회** 통과. 이에 더해 timing loop에서도 원본/배치 검증을 반복했다.
  원본 portable 구현이 만든 서명 20개를 사용한다.
- 서로 다른 seed 길이/빈 seed, 혼합 512/1024, raw/prehash/external-mu,
  전부 external-mu인 배치, context 길이 255, 독립 lane 오류 격리 확인.
- prefix 0/1에서 실제 전체 키생성 원본 일치, unaligned work,
  최소 크기/짧은 work, 과도한 blocks, NULL seed 거부, guards, wipe 통과.
- 기존 단일 키생성·검증 API 원본 동작 회귀 검사 통과.
- CFSR/HFSR/AFSR=0, TCM/ECC 시작·종료 확인 통과.

이는 **이번 입력의 원본 호환/differential 검사**다. 외부 공식 전체 KAT suite를
새로 돌렸거나 모든 입력 동등성/배포 안전성을 증명했다는 뜻이 아니다.
새 scatter ASM은 고정 17회 반복·공개 stride 주소다. 흡수 반복/마스크는 입력 길이에
의존하고, 검증의 rejection sampling은 공개 nonce/mu에 의존한다. 키생성의 원래
가변 샘플링/재시도는 남아 있다. **전체 상수시간/전력·EM 검증은 이번에 완료하지 않았다.**

### 환경·파일·재현

- 실제 NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`.
- CPU 800 MHz, cache OFF, ITCM/DTCM 각각 256 KiB, ECC ON.
- 코드 ITCM, 상수·데이터·stack DTCM. 기존 pinned mlkem-native 부트 및
  DTCM 상수 workaround 유지. Zephyr가 출력하는 FLASH 영역 이름은 실제 Flash
  실행을 뜻하지 않으며 loader는 RAM ELF를 올렸다. M4 보드/Flash는 변경하지 않았다.
- GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard`,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- main stack 32 KiB, `k_cycle_get_64()` 측정, interrupt/SysTick ON.
  이전 서명 x4의 DWT/interrupt OFF 표와 raw cycles를 섞지 않는다.
- 최종 시험 이미지: ITCM **125,212 bytes**, DTCM **256,784 bytes**.
  테스트 fixture/비교군/OS 포함 수치이며 라이브러리 자체 RAM 요구량이 아니다.
  키생성 blocks=64 작업 공간 **57,375 bytes**, 검증 **14,207 bytes**, 내부 stack 별도.
  이번 ELF는 키생성·검증 시험용이며 서명까지 모두 사용하는 최종 앱의 용량 검사가 아니다.

최초 연결본도 정확성 검사를 통과했지만 prefix를 소진한 뒤에도 느린 prefetched
reader를 계속 불렀다. 최종본은 다음 polynomial부터 원본 `sample_f()`로 돌아간다.
prefix 경계를 가로지르는 polynomial만 기존 prefetched reader가 정확히 이어 읽는다.
최초 결과는 보존하고 최종 집계에는 사용하지 않았다.

- [최종 raw.log](validation_batch4/results/keygen_verify_batch4/20260930T075813Z/raw.log)
- [최종 manifest](validation_batch4/results/keygen_verify_batch4/20260930T075813Z/manifest.json)
- [집계 JSON](validation_batch4/summary.json)
- [최초 연결본 로그](validation_batch4/results/keygen_verify_batch4/20260930T075611Z/raw.log)
- [작업 전 파일 보존본](validation_batch4/baseline/pre_keygen_verify.tar.gz)
- [사용·재현 안내](validation_batch4/README.md)

`Final_code/Before_slothy` 및 기존 `sign_core.c`/`sign_sampler.c`는 변경하지 않았다.
원래 hybrid x4 permutation도 그대로이며 별도 출력 ASM만 덧붙였다.

---

## 보존된 이전 기록: 단일 서명용 KAT 변경형 SHAKE256x4

**아래는 이전 서명 실험 기록이며 위의 원본 호환 키생성·검증 배치와 별개다.**

비교한 세 후보 중 **hybrid를 선택**한다. 단일 SHAKE/Keccak은 원본을 유지하며,
새 x4 PRNG는 VecFalcon과 같은 **서명 샘플러 위치**에 연결했다.
원본은 `Final_code/Before_slothy`의 기존 단일 SHAKE 서명이다.
NTT·FFT는 이미 최적화된 같은 코드이므로 여기의 배율은 이번 PRNG 변경의 효과다.
`M55_ref` 전체와의 새 비교나 기존 단일 Keccak A14와의 비교가 아니다.

## 최종 보드 결과

Cycles, 중앙값. `permutation4`는 **4개 상태의 총 작업**이다.
원본은 기존 `fndsa_sha3_process_block()` 4회, 후보는 x4 permutation 1회다.
이 표를 단일 Keccak 호출의 개선 배율로 읽으면 안 된다.
`refill544`는 x4 permutation + 실제 출력 버퍼 작성까지 포함한다.

| 구현 | Keccak 4상태 | x4 refill 544B | PRNG 32KiB | 전체 서명 512 | 전체 서명 1024 |
|---|---:|---:|---:|---:|---:|
| ref | 57,788.219 | — | 3,622,688 | 10,817,230.5 | 22,635,395 |
| serial | 60,895.25 | 66,076.375 | 4,355,078 | 11,373,244 | 23,631,783 |
| mlkem | 30,583.25 | 38,552.375 | 2,676,722 | 10,678,400 | 22,279,079 |
| vecfalcon | 30,894.25 | 36,075.375 | 2,525,017 | 10,911,151 | 22,732,574.5 |
| hybrid | 30,871.25 | 31,104.375 | 2,221,786 | 10,401,587 | 21,740,990.5 |

`serial`은 동일한 x4 난수열을 원본 CM4 Keccak 4회로 계산하는 시험용 대조군이다.
그 안의 low/high↔원본 ABI 변환 비용도 포함되므로, 그 대조군만을 원본 개선 배율의 기준으로 삼지 않았다.
원본에는 x4 refill API가 없으므로 해당 칸은 비워 뒀다.

### 원래 단일 PRNG 대비

| 후보 | Keccak 4상태 배율 | PRNG 32KiB 배율 | 서명 512 배율 / cycles 감소 | 서명 1024 배율 / cycles 감소 |
|---|---:|---:|---:|---:|
| mlkem | 1.8895× | 1.3534× | 1.0130× / 1.283% | 1.0160× / 1.574% |
| vecfalcon | 1.8705× | 1.4347× | 0.9914× / -0.868% | 0.9957× / -0.429% |
| hybrid | 1.8719× | 1.6305× | 1.0400× / 3.842% | 1.0411× / 3.951% |

음수 감소율은 느려졌다는 뜻이다. VecFalcon 적응 후보는 커널/출력 생성은 빨라졌지만
이 서명 표본에서는 원래 단일 PRNG보다 512에서 0.868%, 1024에서 0.429% 느렸다.
따라서 커널 배율을 서명 배율로 대신 사용하지 않았다.

동일한 난수열을 쓰는 `serial`과 hybrid를 비교하면:
PRNG **1.9602×**,
서명 512 **1.0934×**,
서명 1024 **1.0870×**다.
원본과 비교한 서명 배율에는 PRNG 변경에 따른 샘플러 입력/거부 횟수 차이도 포함되지만,
이 serial 비교는 그 난수열 차이를 없앤다.

## 왜 이 하이브리드인가

- mlkem 후보: even/odd bit-interleaved 상태 + θ·ρ·π 융합. 라운드 커널은 세 후보 중 조금 더 빠르나 출력 변환 비용이 크다.
- vecfalcon 적응 후보: low/high 상태 + 같은 위치 네 스트림 병렬 처리 + 제자리 ρ·π. 출력 표현 변환은 더 단순하다.
- hybrid: low/high 상태에 θ·ρ·π 융합을 적용하고, 출력은 MVE `VST20/VST21`로 직접 64-bit word 순서로 전치한다.
- 출력 ASM 전 hybrid: 4상태 30,871.25 / refill 36,052.375 / 서명 10,585,292 및 22,098,470.5 cycles.
- 출력 ASM 후: 4상태 커널은 동일하고 refill이 **31,104.375 cycles**가 되었다. 전체 API 개선까지 확인해 채택했다.
- 이 선택은 **이번에 구현·측정한 후보들 중 최선**이며 가능한 모든 M55 스케줄을 탐색했다는 뜻은 아니다. SLOTHY는 사용하지 않았다.

VecFalcon 원본은 AArch64의 2 scalar + 2 NEON 상태 혼합이다.
이번 VecFalcon 후보는 그 ASM 스케줄의 정확한 복제가 아니라 **x4 PRNG/동일 위치 병렬 처리 원리의 MVE 이식**이다.
각 구현 및 출처는 [README](../keccak_test_hybrid/README.md)에 구분했다.

## 측정 조건과 한계

- 연결된 NUCLEO-N657X0-Q, serial `003C00223335510735383531`, CPU 800 MHz.
- I/D cache OFF. ITCM/DTCM 각각 256KiB 설정, code ITCM, constants/data/stack DTCM, ECC 검사 유지.
- GCC 15.2.1, Cortex-M55, `-O3 -mfpu=fpv5-d16 -mfloat-abi=hard -ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 동일 firmware harness. 인터럽트를 막은 DWT cycle 구간 측정. 출력·검증은 측정 구간 밖.
- 커널: warm-up 3 batches, 50 samples × 32 calls. 배치당 평균의 중앙값. 호출/루프/타이머 비용 포함.
- PRNG: 32KiB 제공을 50회 측정. seed 초기화, 표현 변환, 출력 가져오기 포함.
- 서명: 크기별 동일 고정 테스트 키 1개, 결정적 seed 32개, 별도 warm-up 2회. 각 호출 cycle의 중앙값.
  여러 키에 대한 모집단 성능/통계적 신뢰구간을 뜻하지 않는다.
- 시험용 고정 slot으로 x4 kernel 시작 `0x10000400`, 공통 text `0x10008400`,
  공통 constants `0x30004b00`, benchmark BSS `0x3000c900`을 맞췄다.
  원본 Keccak·NTT·FFT 주소 및 key/tmp buffers도 비교했다. 각 x4 C helper까지 모두 동일 주소로 고정한 것은 아니다.
- 최종 시험 이미지 ITCM 약 95.5KB, DTCM 예약 231,000B(64KiB thread stack 포함).
  이는 시험용 padding/키/검증 oracle을 포함한 크기이지 crypto 라이브러리의 최소 메모리 사용량이 아니다.
- 키생성·검증 코드는 바꾸지 않았다. 이번에는 해당 API의 전체 성능을 재측정하지 않았다.

## 정확성 / KAT

각 x4 후보와 serial 대조군:

- 독립 canonical Keccak oracle 대조: **512 state permutations PASS**.
- 8개의 56-byte seed에 대해 각 2,176 bytes: 단일 SHAKE256 4개로 만든 기대 출력과 일치.
- u8/u16/u64 혼합 읽기 및 refill 경계의 tail-discard 규칙 PASS. buffer guards PASS.
- 정상 서명 **68건 검증 PASS**, 서명/메시지 변조 **136건 거부 PASS**.
- 세 후보와 serial의 512/1024 서명 digest가 모두 같다. 원본 단일 PRNG digest와는 다르다.
- **원래 서명 KAT 일치를 주장하지 않는다.** 사용자가 허용한 난수 생성 방식 변경이다.
  원래 90/300 KAT suite를 새 방식에 강제로 맞추거나 오류를 무시한 것이 아니다.
- 상태 산술은 정수 XOR/AND/shift이므로 수치 근사 오차가 없다. 신규 ASM은 고정 24라운드/공개 주소.
  전체 상수시간·부채널·새 PRNG 보안의 형식 증명/포괄 검증은 이번 성능 시험 범위가 아니다.
- 채택 실행의 CFSR/HFSR/AFSR 모두 0, 시작/종료 TCM 설정과 ECC 조건 검사 PASS.

## 재현 / 증거

프로젝트 루트에서:

```sh
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
bash keccak_test_mlkem/validation/build.sh hybrid
python keccak_test_mlkem/validation/run.py hybrid
python keccak_test_mlkem/validation/analyze.py
```

`hybrid` 대신 `ref`, `serial`, `mlkem`, `vecfalcon`도 가능하다.
집계는 다섯 실행의 통과 여부, 현재 crypto source hash 일치, x4 결과 동등성을 확인한다.
독립 archive는 각 폴더에서 `make`로 생성한다. 다른 후보의 crypto 소스를 끌어오지 않는다.

최종 raw logs:

- ref: [raw.log](../keccak_test_mlkem/validation/results/ref/20260930T053733Z/raw.log)
- serial: [raw.log](../keccak_test_mlkem/validation/results/serial/20260930T053738Z/raw.log)
- mlkem: [raw.log](../keccak_test_mlkem/validation/results/mlkem/20260930T053728Z/raw.log)
- vecfalcon: [raw.log](../keccak_test_mlkem/validation/results/vecfalcon/20260930T053723Z/raw.log)
- hybrid: [raw.log](../keccak_test_mlkem/validation/results/hybrid/20260930T053718Z/raw.log)

각 실행 폴더에 ELF/map/disassembly, 소스 스냅샷, SHA-256, compile commands, symbols, manifest를 보존했다.
[기계 판독 집계](../keccak_test_mlkem/validation/summary.json).

초기 full-keygen 시험 이미지는 서명/Keccak 진입 전 startup fault가 나서 결과에서 제외했다.
시험 키를 host의 원본 keygen으로 고정 생성해 서명 시험과 분리한 후 정상 실행했다.
최초 fault의 칩 내부 근본 원인을 이번 작업에서 확정한 것은 아니다.
코드 배치가 자유였던 예비 측정도 최종 표에서 제외했다.
Zephyr의 강제 flat BIN 생성은 주소 간격 때문에 512MiB 파일을 만들므로, 최종 빌드 스크립트는
자신이 만든 BIN만 삭제하고 실제 업로드에 사용하는 ELF/map을 유지한다.
