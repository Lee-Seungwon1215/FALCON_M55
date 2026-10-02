# batch4 전/후 Keccak·SHAKE 연산 비중 — 실물 M55

생산 코드와 `Final_code/Before_slothy`는 수정하지 않았다. 다음 비중은 각 구현의
**키생성 네 건 전체 / 서명 네 건 전체**를 각각 100%로 한 독립 실측이다.
분자와 분모는 빈 probe 오버헤드를 보정한 추정치다. 부모 SHAKE에서 하위 Keccak 시간을
빼는 exclusive 집계이므로 중복 합산하지 않는다.

## 측정 조건

- NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`, 800 MHz, cache OFF, ECC ON.
- 기존 코드 ITCM / 상수·데이터·stack DTCM 정책. 메모리 용량 때문에 키생성과 서명은
  별도 펌웨어지만, 각 펌웨어 안에서 원본 4회 호출과 batch4를 같은 입력으로 교대 실행.
- GCC 15.2.1, `-O3`, `-mcpu=cortex-m55`, `-mfpu=fpv5-d16`, hard ABI,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`. 계측 bookkeeping만 general-regs-only.
- 두 연산 모두 IRQ ON / 64-bit SoC cycle counter. 이전 IRQ OFF 서명 측정값과 직접 혼합하지 않는다.
- 각 크기: 키생성 10배치 = 40개의 서로 다른 seed, 서명 25배치 = 100개의 입력(4개 키).
  각 구현·크기별 별도 warm-up 1배치. 키 prefix64블록/요청, 서명112블록/요청.
- reference는 NTT·FFT 최적화가 이미 포함된 Before_slothy. 최초 M55_ref 대비 수치가 아니다.
- 오류 대조·서명 검증·변조 검사·로그·호출자 workspace 삭제는 시간 밖.

## 전/후 SHAKE 관련 합계

아래 ‘합계’는 계측한 SHAKE/Keccak 및 배치 준비/출력 함수들의 시간이다.
짧은 인라인 난수 읽기와 API 제어는 강제로 함수화하지 않아 나머지에 포함된다.
앞선 sha3_profile도 인라인 `shake_next_*` 자체 비용을 제외했다.

| 연산 | 크기 | 원본 SHAKE 합계 | batch4 SHAKE·관리 합계 | 원본 나머지 | batch4 나머지 |
|---|---:|---:|---:|---:|---:|
| 키생성 | 512 | 5.412% | 5.122% | 94.588% | 94.878% |
| 키생성 | 1024 | 5.601% | 5.487% | 94.399% | 94.513% |
| 서명 | 512 | 21.978% | 17.952% | 78.022% | 82.048% |
| 서명 | 1024 | 20.359% | 18.458% | 79.641% | 81.542% |

## batch4 후 100% 분해

| 구간 | 키생성512 | 키생성1024 | 서명512 | 서명1024 |
|---|---:|---:|---:|---:|
| MVE x4 Keccak | 1.195% | 0.299% | 10.712% | 4.979% |
| x4 출력 버퍼 저장 | 0.011% | 0.003% | 0.103% | 0.048% |
| 남아 있는 단일 Keccak/SHAKE | 3.907% | 5.183% | 7.121% | 13.423% |
| 계측한 배치 준비·관리 | 0.008% | 0.002% | 0.017% | 0.008% |
| 나머지 FN-DSA·인라인 읽기·제어 | 94.878% | 94.513% | 82.048% | 81.542% |
| 합계 | 100% | 100% | 100% | 100% |

‘단일’에는 bit_split/merge, 원래 초기화/흡수/추출도 포함한다. ‘배치 준비·관리’는
prepare/absorb/export/block/sampler_extract/내부 clear의 exclusive 시간이며,
모든 인라인 prefix 읽기 비용까지 완전히 분리한 값이 아니다.

## Keccak 호출 횟수와 적용 범위

x4 1회는 4개의 상태를 계산한다. 아래는 배치당 평균이다. 감소율은
`(원본 단일 호출수 - batch4의 단일 호출수) / 원본 단일 호출수`이다.
미사용 선생성 출력이 있을 수 있으므로 **유효 소비 바이트 비율이라고 해석하지 않는다.**

| 연산 | 크기 | 원본 단일 호출 | batch4 잔여 단일 호출 | x4 호출 | 단일 호출 감소율 |
|---|---:|---:|---:|---:|---:|
| 키생성 | 512 | 793.40 | 571.50 | 64.00 | 27.97% |
| 키생성 | 1024 | 3277.80 | 3029.00 | 64.00 | 7.59% |
| 서명 | 512 | 650.24 | 202.24 | 112.00 | 68.90% |
| 서명 | 1024 | 1269.80 | 821.80 | 112.00 | 35.28% |

## 계측 없는 control의 전체 성능

샘플별 paired 측정의 전체 cycle 합계 비율을 사용한다(평균 비용에 해당).
이전 결과와는 입력 집합/IRQ 정책/코드 배치가 달라 이전 값을 덮어쓰지 않는다.

| 연산 | 크기 | 원본4 평균 cycles | batch4 평균 cycles | 배율 | cycles 감소 |
|---|---:|---:|---:|---:|---:|
| 키생성 | 512 | 213,676,371.2 | 213,179,930.1 | 1.00233× | 0.232% |
| 키생성 | 1024 | 852,471,457.8 | 851,346,859.8 | 1.00132× | 0.132% |
| 서명 | 512 | 43,273,006.1 | 41,604,701.8 | 1.04010× | 3.855% |
| 서명 | 1024 | 91,175,366.9 | 89,510,838.2 | 1.01860× | 1.826% |

## 계측 영향 점검

빈 wrapper 4,000회로 추정한 보정값을 각 함수 호출/하위 호출 수에 적용했다.
짧은 함수의 보정 후 음수는 0으로 제한하며 data.json에 기록한다. 코드 배치와
함수 wrapping에 따른 최적화 차이는 빈 probe 보정만으로 제거되지 않는다.
따라서 보정 후 control 대비 차이도 함께 보고, 미세한 값은 과해석하지 않는다.

| 연산 | 크기 | 구현 | raw/control 차이 | 보정/control 차이 |
|---|---:|---|---:|---:|
| 키생성 | 512 | 원본4 | +0.358% | -0.003% |
| 키생성 | 512 | batch4 | +0.287% | -0.002% |
| 키생성 | 1024 | 원본4 | +0.366% | -0.003% |
| 키생성 | 1024 | batch4 | +0.345% | -0.003% |
| 서명 | 512 | 원본4 | +1.384% | -0.001% |
| 서명 | 512 | batch4 | +0.758% | +0.001% |
| 서명 | 1024 | 원본4 | +1.219% | -0.002% |
| 서명 | 1024 | batch4 | +0.926% | +0.001% |

## 검증 및 원자료

각 모드: 키 88회 전체 바이트 일치, 서명208회 전체 바이트 일치·검증·변조 거부(별도 warm-up 포함). control/profile의 출력 지문 일치, 계측 stack 및 합계 검사, workspace guards, TCM/ECC 및 fault 레지스터 확인. 이는 이번 입력에 대한 회귀 검사이며 전체 공식 KAT/상수시간 증명이 아니다.

- keygen/control: [raw.log](results/keygen_control/20260930T125634Z/raw.log), [manifest](results/keygen_control/20260930T125634Z/manifest.json), [source hashes](results/keygen_control/20260930T125634Z/sources.json). probe 보정 self=243.000, parent=234.000 cycles.
- keygen/profile: [raw.log](results/keygen_profile/20260930T125727Z/raw.log), [manifest](results/keygen_profile/20260930T125727Z/manifest.json), [source hashes](results/keygen_profile/20260930T125727Z/sources.json). probe 보정 self=243.000, parent=234.000 cycles.
- sign/control: [raw.log](results/sign_control/20260930T125838Z/raw.log), [manifest](results/sign_control/20260930T125838Z/manifest.json), [source hashes](results/sign_control/20260930T125838Z/sources.json). probe 보정 self=206.000, parent=208.000 cycles.
- sign/profile: [raw.log](results/sign_profile/20260930T125932Z/raw.log), [manifest](results/sign_profile/20260930T125932Z/manifest.json), [source hashes](results/sign_profile/20260930T125932Z/sources.json). probe 보정 self=206.000, parent=208.000 cycles.
