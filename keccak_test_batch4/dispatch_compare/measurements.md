# 활성 상태 수에 따른 단일/x4 선택 비교 — 2026-10-01

## 범위와 기준

기존 `prefix-only` 배치 구현은 처음 일정량을 x4로 만들고, 부족한 나머지는 원래 단일 SHAKE로 이어간다.
이번 후보는 rolling queue를 유지하되, 해당 순간 실제 전진시킬 상태 수로 backend를 선택한다.
상태가 1개인데도 항상 x4를 계산했던 `full_x4_validation` 실험은 보존했으며 채택하지 않았다.

| 후보 | 활성 1개 | 활성 2개 | 활성 3개 | 활성 4개 |
|---|---|---|---|---|
| A | 단일 | 단일 2회 | 단일 3회 | x4 |
| B | 단일 | 단일 2회 | x4 | x4 |
| C | 단일 | x4 | x4 | x4 |

후보마다 완전한 소스 복사본을 두었고 `shake_independent4.c`에 정책을 직접 작성했다.
다른 후보를 include/링크하거나 생산 코드의 빌드 옵션으로 정책을 전환하지 않는다.
측정 프로그램만 선택한 소스와 prefix 기준을 별도 이름으로 같은 ELF에 넣는다.
중복되지 않은 공통 산술/Keccak 소스는 바이트 일치를 검사한 뒤 측정 ELF에서 공유한다.
기준의 sampler는 자체 헤더/별도 TU로 컴파일해 서로 다른 PRNG 구조체 ABI를 섞지 않는다.

**분모는 이전 prefix-only batch4이며, M55_ref 또는 단일 API 네 번과의 비교가 아니다.**
NTT·FFT 최적화는 기준과 후보 모두에 이미 포함되어 있다. 모두 독립 요청 네 건의 전체 시간이다.
1보다 큰 배율은 빨라짐, 시간 변화가 양수면 느려짐이다. warmup은 표에서 제외한다.

## 전체 성능 — 내부 함수 계측 없는 control

| 후보 | 연산 | n | prefix 기준 cycles/4건 | 후보 cycles/4건 | 속도 배율 | 시간 변화 |
|---|---|---:|---:|---:|---:|---:|
| A | 키생성 | 512 | 217,716,258.4 | 215,437,112.7 | 1.01058× | -1.047% |
| A | 키생성 | 1024 | 866,435,975.4 | 856,055,625.0 | 1.01213× | -1.198% |
| A | 서명 | 512 | 41,961,330.2 | 41,444,858.9 | 1.01246× | -1.231% |
| A | 서명 | 1024 | 89,943,833.6 | 92,033,691.9 | 0.97729× | +2.324% |
| A | 검증 | 512 | 923,826.1 | 933,964.4 | 0.98914× | +1.097% |
| A | 검증 | 1024 | 1,800,249.0 | 1,818,013.0 | 0.99023× | +0.987% |
| B | 키생성 | 512 | 217,715,716.2 | 214,794,322.6 | 1.01360× | -1.342% |
| B | 키생성 | 1024 | 866,436,192.3 | 852,724,093.1 | 1.01608× | -1.583% |
| B | 서명 | 512 | 41,961,023.0 | 41,442,263.6 | 1.01252× | -1.236% |
| B | 서명 | 1024 | 89,943,787.9 | 92,029,755.0 | 0.97733× | +2.319% |
| B | 검증 | 512 | 923,782.5 | 932,711.9 | 0.99043× | +0.967% |
| B | 검증 | 1024 | 1,800,205.4 | 1,815,671.9 | 0.99148× | +0.859% |
| C | 키생성 | 512 | 217,716,044.4 | 214,474,974.6 | 1.01511× | -1.489% |
| C | 키생성 | 1024 | 866,436,078.1 | 851,569,251.9 | 1.01746× | -1.716% |
| C | 서명 | 512 | 41,961,197.9 | 41,443,459.9 | 1.01249× | -1.234% |
| C | 서명 | 1024 | 89,943,835.6 | 92,027,577.6 | 0.97736× | +2.317% |
| C | 검증 | 512 | 923,826.1 | 932,798.8 | 0.99038× | +0.971% |
| C | 검증 | 1024 | 1,800,162.0 | 1,815,715.5 | 0.99143× | +0.864% |

기준/후보 실행 순서는 batch마다 번갈아 바꿨다. A/B/C는 별도 ELF이지만 변경되는 dispatcher
소스만 text 끝의 고정 크기 슬롯에 배치해, 다른 암호 산술 함수가 밀려나지 않게 했다.
이것은 측정용 링크 배치일 뿐 생산 코드의 정책 선택이나 다른 후보 소스 연결이 아니다.
`layout_audit.json`은 control ELF의 slot 밖 암호 함수 및 주요 상수표의 동일 주소를 검사한다.
계측 report 코드의 크기는 정책에 따라 달라 일부 SDK/libc 함수 주소는 소량 이동한다.
따라서 모든 명령의 주소까지 동일한 실험은 아니다. 각 ELF 내부 paired 비교를 사용하며,
작은 차이를 모든 입력에 대한 우월성 또는 통계적 유의성으로 단정하지 않는다.
profile ELF의 wrapper 주소는 이 동일성 조건에 포함하지 않으며, profile cycles로 후보 순위를 매기지 않는다.

## 전환 비용을 포함한 단독 dispatch 측정

각 값은 200회 평균 cycles. 단일에는 x4↔CM4 상태 배치 변환과 임시 상태 삭제 비용을 포함한다.
부분 x4에는 비활성 상태의 보존/복원 비용을 포함한다. 측정 루프 및 인터럽트 영향도 포함된다.
실제 dispatcher와 외부 microbenchmark의 코드 배치/호출 구조는 다르므로 selected 값도 함께 제시한다.

| 후보 | 활성 상태 | 단일 반복 | 마스크 x4 | 실제 선택 경로 |
|---|---:|---:|---:|---:|
| A | 1 | 17,852.0 | 41,782.5 | 17,900.0 |
| A | 2 | 35,624.0 | 41,485.5 | 35,675.4 |
| A | 3 | 53,396.0 | 41,103.0 | 53,454.9 |
| A | 4 | 71,180.0 | 39,882.4 | 39,912.5 |
| B | 1 | 17,852.0 | 41,777.0 | 17,902.5 |
| B | 2 | 35,629.4 | 41,485.5 | 35,669.0 |
| B | 3 | 53,396.0 | 41,103.0 | 41,212.4 |
| B | 4 | 71,185.4 | 39,882.5 | 39,911.0 |
| C | 1 | 17,852.0 | 41,782.5 | 17,895.0 |
| C | 2 | 35,629.5 | 41,480.0 | 41,744.5 |
| C | 3 | 53,396.0 | 41,108.5 | 41,211.5 |
| C | 4 | 71,180.0 | 39,882.5 | 39,915.5 |

## 실행 경로 확인 — profile 전용 펌웨어

profile 수치를 전체 속도 판단에 섞지 않는다. 모든 마스크 호출의 활성 수를 세고,
선택 기준으로 계산한 단일/x4 횟수와 실제 Keccak 진입 횟수가 정확히 일치해야 통과한다.

| 후보 | 연산 | n | 활성1 | 활성2 | 활성3 | 활성4 | 단일 Keccak 호출 | x4 호출 |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| A | 키생성 | 512 | 1571 | 1069 | 301 | 962 | 4612 | 962 |
| A | 키생성 | 1024 | 7512 | 3887 | 1561 | 3298 | 19969 | 3298 |
| A | 서명 | 512 | 3340 | 8 | 4 | 3228 | 3368 | 3228 |
| A | 서명 | 1024 | 17503 | 7 | 10 | 3531 | 17547 | 3531 |
| B | 키생성 | 512 | 1571 | 1069 | 301 | 962 | 3709 | 1263 |
| B | 키생성 | 1024 | 7512 | 3887 | 1561 | 3298 | 15286 | 4859 |
| B | 서명 | 512 | 3340 | 8 | 4 | 3228 | 3356 | 3232 |
| B | 서명 | 1024 | 17503 | 7 | 10 | 3531 | 17517 | 3541 |
| C | 키생성 | 512 | 1571 | 1069 | 301 | 962 | 1571 | 2332 |
| C | 키생성 | 1024 | 7512 | 3887 | 1561 | 3298 | 7512 | 8746 |
| C | 서명 | 512 | 3340 | 8 | 4 | 3228 | 3340 | 3240 |
| C | 서명 | 1024 | 17503 | 7 | 10 | 3531 | 17503 | 3548 |

## 정확성·보안 검사 범위

각 후보의 control/profile 두 종류 모두 다음을 검사했다. 동일 입력을 재사용하므로
여러 실행의 검사 수를 더해서 고유 입력 수가 늘어난 것처럼 표현하지 않는다.

- 상태의 25개 64-bit word 전체: 2,048회, 16개 모든 마스크, 반복 scalar/x4 전환, 비활성 lane 보존.
- 키생성: 88건 byte-exact 대조(각 크기 40개 고유 seed + warmup 반복). 혼합 크기, 선택 출력, 짧은 work 거절 추가.
- 서명: 208건 byte-exact, 정상 검증 208건, 변조 거절 208건(각 크기 100개 고유 입력 + warmup 반복).
- 추가 서명: 혼합 크기·RAW/SHA256/EXTMU·최대 context 등 16건 byte-exact 및 batch 검증. 변조 lane 격리 검사.
- SHAKE 스트림: 10,112회 대조. 136-byte 경계, 비대칭 소비, 0/1/2/7-block queue, retry counter 1..26, 다른 lane 유지.
- work 전후 guard, 하드폴트 레지스터, ECC 상태, 소스/ELF SHA256, control/profile fingerprint 일치.

이는 시험 입력에 대한 원본 일치 검사다. **공식 전체 KAT 재인증, 모든 입력 동등성 증명,
전체 상수시간 증명 또는 물리적 부채널 안전성 완료를 뜻하지 않는다.**
단일 및 x4 Keccak 산술 엔진은 기존 코드 그대로이고 새 변환은 고정 횟수 비트연산이다.
새 dispatcher는 상태 값 자체로 분기하지 않지만 활성 마스크는 샘플러 소비/재시도에 영향을 받는다.
이 제어 정보가 누설하는지에 대한 별도 분석 없이 전체 구현을 constant-time으로 부르지 않는다.

## 측정 조건

- 실제 NUCLEO-N657X0-Q, ST-LINK serial `003C00223335510735383531`.
- 800 MHz, 캐시 OFF, ECC ON, ITCM 코드 및 DTCM 상수/데이터/스택 각 256 KiB 설정.
- GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard`,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`. SLOTHY 추가 없음.
- IRQ ON, 64-bit SoC cycle timer. 키생성 10 batch(40건)/크기, 서명·검증 25 batch(100건)/크기.
- queue: 키생성 64 blocks/lane, 서명 112 blocks/lane. 메모리 제한으로 서명 fixture 키는 크기별 2개를 네 요청에서 재사용.
  메시지·난수 seed는 독립적이다. 네 건 모두 서로 다른 키에 대한 성능 분포를 측정한 것은 아니다.
- RAM-only ELF 실행. Flash, M4 보드, `Final_code/Before_slothy`, root all-x4 코드를 변경하지 않았다.

## 실행/재현

예: `bash validation/build.sh B_three_plus keygen control` 후
`python3 validation/run.py B_three_plus keygen control`.
`sign`/`profile` 및 A/C도 같은 방식. 검증은 sign firmware에 포함된다.
일반 라이브러리는 후보 폴더의 `Makefile`로 독립 빌드한다.
runner는 ELF/map/컴파일 명령/설정/소스 압축본/해시/디스어셈블리/raw log를 각 실행 경로에 보존한다.

| 후보 | 작업 | 종류 | 근거 경로 |
|---|---|---|---|
| A | keygen | control | [validation/results/A_four_only_keygen_control_pinned/20261001T053510Z](validation/results/A_four_only_keygen_control_pinned/20261001T053510Z/raw.log) |
| A | keygen | profile | [validation/results/A_four_only_keygen_profile_pinned/20261001T053800Z](validation/results/A_four_only_keygen_profile_pinned/20261001T053800Z/raw.log) |
| A | sign | control | [validation/results/A_four_only_sign_control_pinned/20261001T053605Z](validation/results/A_four_only_sign_control_pinned/20261001T053605Z/raw.log) |
| A | sign | profile | [validation/results/A_four_only_sign_profile_pinned/20261001T053836Z](validation/results/A_four_only_sign_profile_pinned/20261001T053836Z/raw.log) |
| B | keygen | control | [validation/results/B_three_plus_keygen_control_pinned/20261001T054050Z](validation/results/B_three_plus_keygen_control_pinned/20261001T054050Z/raw.log) |
| B | keygen | profile | [validation/results/B_three_plus_keygen_profile_pinned/20261001T053709Z](validation/results/B_three_plus_keygen_profile_pinned/20261001T053709Z/raw.log) |
| B | sign | control | [validation/results/B_three_plus_sign_control_pinned/20261001T053419Z](validation/results/B_three_plus_sign_control_pinned/20261001T053419Z/raw.log) |
| B | sign | profile | [validation/results/B_three_plus_sign_profile_pinned/20261001T053746Z](validation/results/B_three_plus_sign_profile_pinned/20261001T053746Z/raw.log) |
| C | keygen | control | [validation/results/C_two_plus_keygen_control_pinned/20261001T054014Z](validation/results/C_two_plus_keygen_control_pinned/20261001T054014Z/raw.log) |
| C | keygen | profile | [validation/results/C_two_plus_keygen_profile_pinned/20261001T053850Z](validation/results/C_two_plus_keygen_profile_pinned/20261001T053850Z/raw.log) |
| C | sign | control | [validation/results/C_two_plus_sign_control_pinned/20261001T054127Z](validation/results/C_two_plus_sign_control_pinned/20261001T054127Z/raw.log) |
| C | sign | profile | [validation/results/C_two_plus_sign_profile_pinned/20261001T053926Z](validation/results/C_two_plus_sign_profile_pinned/20261001T053926Z/raw.log) |
