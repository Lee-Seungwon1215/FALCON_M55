# 전체 SHAKE x4 경로 — 2026-10-01

현재 소스는 초기 prefix만 생성하던 구현에서 **추가 난수·재시도·주변 해시도
x4 엔진으로 처리하는 구현**으로 변경됐다. 기존 단일 API 및
`Final_code/Before_slothy`는 유지한다.

새 측정의 성능·출력 일치·단일 호출 0회 확인·활성 lane 수와 로그는
[full_x4_validation/result.md](full_x4_validation/result.md)에 모았다.
전체 x4 경로 전환은 완료했지만, 전체 성능이 좋아졌다는 뜻은 아니다.
한 lane만 필요한 구간에서도 x4 계산 비용이 발생하므로 채택 여부를 구분해야 한다.

수정 전 C/ASM 보존본: `full_x4_validation/baseline/prefix_only_20261001.tar.gz`.
아래 모든 표는 이전 prefix-only 정책의 기록이며 현재 소스의 결과가 아니다.

---

# 이전: 원본 호환 키생성·서명·검증 4건 배치 — 2026-09-30

## 추가: batch4 적용 후 연산 비중 실측

키생성·서명의 적용 전/후를 같은 입력으로 새로 계측했다.
원자료와 100% 분해표는 [profiling/result.md](profiling/result.md)에 있다.
이번 표본·IRQ 정책은 아래의 이전 전체 성능 측정과 다르므로 수치를 섞지 않는다.

| 연산 | 크기 | 적용 전 SHAKE 관련 비중 | batch4 후 SHAKE·관리 비중 |
|---|---:|---:|---:|
| 키생성 | 512 | 5.412% | 5.122% |
| 키생성 | 1024 | 5.601% | 5.487% |
| 서명 | 512 | 21.978% | 17.952% |
| 서명 | 1024 | 20.359% | 18.458% |

각 구현의 네 건 전체 시간을 분모로 한 probe 오버헤드 보정 추정치다.
짧은 인라인 난수 읽기와 API 제어 비용은 별도 함수화하지 않아 나머지에 남는다.
각 크기에서 키생성 40키/서명100건, 원본/배치 대조. 전체 키·서명 바이트 일치,
서명 검증·변조 거부 및 fault/TCM/ECC 검사를 통과했다. 생산 코드는 수정하지 않았다.

---

## 최신 통합: 세 배치 API를 이 폴더에서 제공

`keccak_test_batch4` 안에 원본 호환 키생성·검증 4건 배치를 추가했다.
기존 서명 4건 배치의 C/ASM 구현은 유지했다. KAT 변경형 `keccak_test_hybrid`의
서명 PRNG를 가져온 것이 아니다. **각 요청의 원래 SHAKE 출력은 별도로 유지**한다.
단일 키생성·서명·검증 API도 남아 있으며 자동 큐나 묵시적 x4 전환은 없다.

`Before_slothy` 및 `keccak_test_hybrid`는 이번 작업에서 수정하지 않았다.
배포 라이브러리는 이 폴더의 실제 C/ASM만 빌드한다. 외부 후보 링크/선택 옵션은 없다.

### 이번 상태에서 실물 M55 재측정

기준은 **NTT·FFT가 이미 최적화된 `Before_slothy`에서 네 건 순차 실행**이다.
모두 네 건 전체 cycles이며, 호출·SHAKE 준비·버퍼 저장·해당 암호 연산을 포함한다.
출력 대조·변조 검사·로그·작업 공간 삭제는 원본/후보 모두 측정 밖이다.
이 수치를 단일 요청 latency 개선이나 최초 `M55_ref` 대비 누적 개선으로 읽으면 안 된다.

| 연산 | 크기 | 선택 정책 | 원본 4건 cycles | 배치 4건 cycles | 속도 배율 | cycles 감소 |
|---|---:|---|---:|---:|---:|---:|
| 키생성 | 512 | prefix 64 blocks/lane | 192,689,326.00 | 192,132,779.00 | **1.00290×** | **0.289%** |
| 키생성 | 1024 | prefix 64 blocks/lane | 1,010,371,434.00 | 1,009,187,241.50 | **1.00117×** | **0.117%** |
| 서명 | 512 | prefix 112 blocks/lane | 43,402,690.00 | 41,899,116.50 | **1.03589×** | **3.464%** |
| 서명 | 1024 | prefix 112 blocks/lane | 90,584,719.50 | 89,080,430.00 | **1.01689×** | **1.661%** |
| 검증 | 512 | hash/Hash-to-Point x4 | 1,296,610.875 | 972,697.688 | **1.33300×** | **24.982%** |
| 검증 | 1024 | hash/Hash-to-Point x4 | 2,493,010.375 | 1,894,730.188 | **1.31576×** | **23.998%** |

**검증의 효과가 가장 뚜렷하고, 키생성의 이득은 작다.** prefix 이후의 난수 생성,
NTRU solve, FFT/NTT 등까지 네 건 동시 처리하는 구현은 아니다.
키생성에서 32 blocks도 시험했으며 512: 1.00225×, 1024: 1.00069×였다.
서명 32/64 blocks는 512: 1.00992×/1.02015×, 1024: 1.00473×/1.00956×였다.
표는 이번에 측정한 정책 중 높은 결과이며 모든 입력/메모리 정책의 최적값 증명은 아니다.

이전 서명 단독 이미지의 1.04023×/1.01889×와 숫자가 조금 다르다. 이번에는
새 검증 배치와 연결 검사를 같은 이미지에 포함해 코드/데이터 배치가 바뀌었다.
서명 C/ASM 본체는 보존본과 동일하다. 배치 차이가 각각 얼마나 영향을 주었는지는
따로 분리 측정하지 않았으므로 원인을 단정하지 않는다. **현재 상태에는 위 재측정값을 사용한다.**

### 검사 결과

키생성·검증 이미지:

- x4 SHAKE 출력/단일 SHAKE로 이어가기 대조 **9,216회 통과**.
- 키 출력 **164회 원본과 전체 byte-exact 일치**. 반복 포함, 고유 키 입력 **20개**.
  이 중 기본 16개 입력은 portable 원본 key digest와도 대조했다.
- 명시적 정상 검증 **72회**, 변조/오류 입력 검사 **50회** 통과.
- 혼합 512/1024, unequal/빈 seed, SHAKE rate 경계, prefix 0/1/2/7/112/128,
  raw/prehash/external-mu, lane 오류 격리, unaligned/짧은 work, guards/wipe 통과.
- 기존 단일 키생성·검증 API 회귀 검사 통과.

서명 및 새 검증 배치 연결 이미지:

- 원본 서명 바이트 일치·기존 단일 검증 **1,020회**, 변조 거부 **2,040회** 통과.
  반복 포함, 고유 서명 입력 **344건**, 키 **8개**.
- 같은 서명들을 **새 `fndsa_verify_batch4_temp()`로 1,020회 검증 통과**.
  네 건 중 한 건만 변조하는 lane 격리 검사 **255배치 통과**.
- prefix/136-byte 경계, u8/u16/u64 혼합과 1..7-byte tail, retry counter 1..26
  스트림 대조, 기존 단일 서명 API 검사 통과.
- 기존 서명 파일 및 x4 ASM은 작업 전 snapshot과 동일.

두 실행 모두 CFSR/HFSR/AFSR=0, TCM/ECC 시작·종료 확인 통과.
이것은 **시험 입력의 원본 호환성·회귀 검사**다. 외부 공식 전체 KAT suite나
모든 입력 동등성 증명, 전체 상수시간·전력/EM 검증 완료를 뜻하지 않는다.

### 환경과 비교의 범위

- 실물 NUCLEO-N657X0-Q / ST-Link `003C00223335510735383531`.
- CPU 800 MHz, cache OFF, ITCM/DTCM 각 256 KiB, ECC ON.
- 코드 ITCM, 상수·데이터·stack DTCM. 기존 pinned mlkem-native 부트와 DTCM 상수
  workaround 유지. GCC 15.2.1, `-O3`, Cortex-M55, hard FP64 ABI,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- **키생성/검증:** 같은 ELF에 원본 비교군과 후보를 넣음. 크기별 입력 8개 → 두 배치,
  배치별 warm-up 1회 + 측정 3회, 두 중앙값의 평균. 검증은 timed sample당 배치 8회
  실행 후 8로 나눔. interrupt ON, 64-bit cycle timer.
- **서명:** 같은 ELF의 원본/후보 paired 비교, 크기별 40배치 중앙값, warm-up 2배치,
  원본/후보 순서 교대. interrupt OFF, DWT timer. 새 검증 배치 연결 검사는 timing 밖.
- 두 시험 이미지 사이의 timer 정책·주소는 같지 않으므로 raw cycles를 혼합하지 않는다.
  세 배율은 각각 자기 이미지의 동일 조건 원본/후보 비교다.
- main stack은 두 이미지 모두 32 KiB. 키생성·검증 이미지 ITCM **125,212 B**,
  DTCM **256,784 B**. 서명·검증 연결 이미지 ITCM **83,772 B**, DTCM **259,624 B**.
  이는 fixture/비교군/OS를 포함한 시험 이미지 수치다. 세 배치 API를 모두 유지하는
  단일 제품 펌웨어의 메모리 적합성까지 검사한 것은 아니다.
- caller 작업 공간: 키생성 blocks=64 **57,375 B**, 서명 blocks=112 **126,783 B**,
  검증 **14,207 B**. 내부 stack 별도, 요청 완료 후 재사용 가능, 비밀 work 삭제 필요.

### 파일 및 증거

추가/통합: `kgen.c`, `kgen_gauss.c`, `vrfy.c`, `shake_independent4.c/.h`,
`fndsa_batch4.h`, `Makefile`. 이미 있는 `sha3x4_cm55.s`를 공유하며 변경하지 않았다.
시험 도구는 원본 비교용 복사본만 사용한다. 실제 라이브러리는 다른 후보에 의존하지 않는다.

- [키생성·검증 raw.log](validation_keygen_verify/results/keygen_verify_batch4/20260930T084342Z/raw.log)
- [키생성·검증 manifest](validation_keygen_verify/results/keygen_verify_batch4/20260930T084342Z/manifest.json)
- [키생성·검증 집계](validation_keygen_verify/summary.json)
- [서명·검증 연결 raw.log](validation/results/batch4/20260930T084503Z/raw.log)
- [서명·검증 연결 manifest](validation/results/batch4/20260930T084503Z/manifest.json)
- [서명 집계](validation/results/batch4/20260930T084503Z/summary.json)
- [작업 전 보존본](validation_keygen_verify/baseline/before_keygen_verify.tar.gz)
- [재현 안내](validation_keygen_verify/README.md)

SDK가 강제 생성하는 512-MiB flat BIN은 사용하지 않아 삭제했고, build script도
그 재생성 가능한 파일만 정리하도록 수정했다. 실제 측정 ELF/map/로그는 보존했다.
이 빌드 산출물 정리는 보드 측정 후 수행했으며 암호 소스는 바꾸지 않았다.

---

## 아래는 통합 전 서명 단독 실험 기록

## 결론

현재 hybrid의 MVE Keccak x4 permutation을 재사용하면서, **서명마다 원본 SHAKE
스트림을 유지하도록 연결한 배치 API**를 구현했다. 네 스트림의 출력을 섞지 않는다.
시험한 입력에서 원본과 서명 바이트가 모두 일치했다.

측정한 정책 중 `blocks=112`가 가장 빨랐다. 원본 서명 네 건의 순차 실행 대비
네 건 처리량은 **512: 1.04023배, 1024: 1.01889배**다.
이는 최초의 `M55_ref` 대비나 단일 서명의 지연시간 개선 수치가 아니다.

## 동일 펌웨어에서 원본 네 건과 비교

분모/분자는 모두 전체 서명 네 건이다. key decode·G 복원·mu/seed 준비,
nonce 생성, x4 prefix 생성·출력 저장, 샘플러·FFT·NTT·인코딩과 함수 호출까지 포함한다.
출력 비교·검증·printf 및 사용 후 작업 공간 삭제는 양쪽 모두 측정 밖이다.

각 행: warm-up 2회 이후 40개 배치의 중앙값. 원본/배치 실행 순서를 번갈아 측정.

| 크기 | lane당 prefix 블록 | 원본 4건 cycles | 배치 4건 cycles | 처리량 배율 | cycle 감소 |
|---|---:|---:|---:|---:|---:|
| 512 | 32 | 43,244,049 | 42,768,363 | 1.01112× | 1.100% |
| 512 | 64 | 43,244,048.5 | 42,289,619 | 1.02257× | 2.207% |
| **512** | **112** | **43,244,049** | **41,571,434** | **1.04023×** | **3.868%** |
| 1024 | 32 | 90,254,383.5 | 89,778,149.5 | 1.00530× | 0.528% |
| 1024 | 64 | 90,254,383.5 | 89,299,420 | 1.01069× | 1.058% |
| **1024** | **112** | **90,254,383.5** | **88,580,994.5** | **1.01889×** | **1.854%** |

112-block 배치 비용을 4로 나눈 **처리량용 환산값**은 512: 10,392,858.5 cycles,
1024: 22,145,248.625 cycles/서명이다. 실제 단일 요청의 latency로 해석하면 안 된다.

개선폭이 제한되는 이유: 전체 서명이 아니라 SHAKE prefix만 x4로 계산한다.
버퍼 소진 뒤의 SHAKE와 드문 재시도는 단일 경로다. 같은 prefix 길이를 사용하므로
1024에서도 절약하는 절대 cycles가 비슷하고, 전체 서명 대비 비율은 작다.
최적 prefix 길이를 모든 작업량/메모리 배치에서 찾은 것은 아니다.

## 원본 일치 및 검증 범위

- 원본 기준: **`Final_code/Before_slothy`**의 기존 단일 SHAKE 서명.
- 본 측정에서 1,008회, 경계/일반 API 검사에서 12회:
  **총 1,020회 바이트 단위 일치 및 유효 서명 검증 통과**.
- 같은 입력을 prefix 정책마다 반복했다. **고유 서명 입력은 344건**, 키는 8개
  (512/1024 각 4개)다. 1,020개가 모두 서로 다른 입력이라는 뜻은 아니다.
- 서명 또는 메시지 변조 거부 **2,040회 통과**.
- 독립 SHAKE 스트림: prefix 0/1/2/7/112 블록, lane별 서로 다른 소비량,
  u8/u16/u64 혼합, 136-byte 경계, prefix 끝의 1..7-byte straddle 통과.
- counter 1..26 초기화 후 바이트열을 원본과 대조하여 통과.
  실제 전체 서명에서 모든 재시도 횟수를 강제로 유발한 시험은 아니다.
- 혼합 512/1024 배치, 서로 다른 키·메시지·seed 길이, 빈 seed 길이,
  raw/prehash/external-mu, prefix=0/1, 일반 단일 API, 짧은 work 및 NULL seed 거부,
  작업 공간 guards/삭제 검사 통과.
- CFSR/HFSR/AFSR=0. 시작/종료 TCM 설정 및 ECC 활성 확인 통과.

이것은 **원본 코드와의 보드상 differential/KAT 호환 회귀 검사**다.
외부 공인 KAT 파일 전체를 새로 실행했다는 뜻이나 모든 가능한 입력에 대한 형식 증명은 아니다.
키 fixture는 host의 원본 `fn-dsa_ref`에서 생성한 공개 테스트 키다.
이번 실험을 키생성 KAT 재검사라고 부르지 않는다.

## 측정 조건과 비교군

- NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`.
- CPU 800 MHz, I/D cache OFF, ITCM/DTCM 각 256 KiB.
- 실행 코드 ITCM, 상수·데이터·작업 공간·스택 DTCM. AXISRAM 미사용.
- GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard`,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 기존 pinned mlkem-native Nucleo 부트/클럭/TCM 초기화와 DTCM 상수 배치 사용.
  이번 검사 main stack 예약량은 **32 KiB**. 이전 x4 시험의 64 KiB와 다르지만,
  이번 원본/배치 비교는 같은 이미지·같은 스택·같은 임시 배열을 사용한다.
- DWT cycle counter, 측정 중 interrupt OFF. 동일한 키·seed·메시지별 paired 비교.
- 테스트 전용 원본 복사본은 이름만 바꿔 같은 펌웨어에 공존시킨다.
  원본 재귀 ASM도 별도 이름으로 분리했다. 나머지 FFT/NTT/검증은 동일 코드 공유.
  소스 대조 스크립트에서 원본 알고리즘 변경이 없음을 확인했다.
- 배치 래퍼와 원본 래퍼 자체를 동일 주소에 겹쳐 놓은 것은 아니다.
  공통 연산 코드·데이터 주소가 같은 단일 이미지 비교다.

테스트 이미지: ITCM 코드 **81,052 bytes**, DTCM 전체 예약 **259,552 bytes**
(256 KiB 중 여유 2,592 bytes). DTCM 수치는 원본 비교 코드의 상수, 8개 테스트 키,
기대/실제 서명 버퍼, Zephyr 스택 등을 모두 포함하므로 배포 라이브러리 RAM 요구량이 아니다.
별도로 배치 API의 112-block 최소 작업 공간은 **126,783 bytes**다.

## 구현·정리 및 한계

`sha3x4_cm55.s`의 permutation은 기존 hybrid와 동일하다. 출력 부분만 `VIDUP`,
`VMUL`, `VSTRW` scatter로 네 개의 분리된 버퍼에 저장한다. C scalar 저장 버전도
원본 일치를 통과했으나, 별도 MVE 저장 후 전체 비용이 줄어 최종본으로 채택했다.
해당 중간 소스·로그도 아래 이전 실행 디렉터리에 보존되어 있다.

고정 길이 prefix 생성의 반복 횟수와 scatter 주소는 공개 `blocks`에 의존한다.
입력 비트에 따른 Keccak 분기/주소 선택은 추가하지 않았다. 다만 샘플러의 원래
가변 난수 소비·재시도와 버퍼 소진에 따른 경로는 존재한다. **전체 상수시간/전력·EM
안전성 검증을 완료했다고 주장하지 않는다.** 배치 caller와 비밀 버퍼의 수명 관리도
보안 검토 대상이다. 원본 난수열은 유지하지만 제품 배포 승인까지 의미하지 않는다.

초기 시험에서 비교군 재귀 ASM이 새 샘플러를 호출하는 테스트 연결 오류를 발견했다.
비교군 ASM의 함수 이름도 분리하여 해결했고, 그 뒤 전체 재검사했다.
실패 기록은 삭제하지 않았으며 최종 성능/정확성 집계에서 제외했다.

## 증거와 재현

- [최종 raw.log](validation/results/batch4/20260930T062134Z/raw.log)
- [최종 summary.json](validation/results/batch4/20260930T062134Z/summary.json)
- [최종 manifest](validation/results/batch4/20260930T062134Z/manifest.json)
- [C 출력 저장 중간본](validation/results/batch4/20260930T061835Z/raw.log)
- [초기 비교군 연결 오류 기록](validation/results/batch4/20260930T061702Z/raw.log)

각 실행 폴더에 ELF, map, 소스 tar.gz, 소스 hash, compile_commands, 디스어셈블리가 있다.
최종 로그/ELF에 대응하는 production source hash도 확인했다.
빌드/보드 실행 명령은 [README.md](README.md)를 참고한다.
