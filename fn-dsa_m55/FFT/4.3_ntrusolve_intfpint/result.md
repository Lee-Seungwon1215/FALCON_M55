# C Q32 규칙 보정판 결과 — 2026-09-27

**실측 KAT는 통과했지만 성능 채택판은 아니다.**
연속 FP32 표현을 유지하면서 주변 산술의 Q32 계산 규칙을 추가했다.
[전체 비교](../4.2_4.3_q32_rules_result.md), [구현 원리](../4.2_4.3_q32_rules_notes.md).

추가 측정: [double 입출력 변환을 포함한 TW / 4.3 / 원본 FFT·iFFT 비교](bridge_conversion_result.md).
아래 기존 FFT 내부 수치는 변환 제외이며, 위 추가 측정과 측정 범위가 다르다.

## KAT·서명 검증

| 항목 | 결과 |
| --- | --- |
| 원본 키생성 KAT 256/512/1024 각 100 | 300/300 일치 |
| 새 입력 `q32-independent-20260927-%u`, 각 100 | 300/300 일치 |
| 위 키들의 정확한 정수 NTRU 방정식 | 600/600 통과 |
| 원본 서명 KAT (degree 4~1024) | 90/90 일치 |
| 생성한 키의 서명 검증·변조 거부 | 90/90 통과 |
| 전체 성능 시험 원본 입력 | 200/200 일치 (위 300개의 부분집합) |

추가 기대값은 변경하지 않은 ntt_opt의 host 원본으로 만들었다. 생성기 자체도
원본 KAT 300개를 먼저 통과했다.
[oracle 로그](../4.2_ntrusolve_q32fpq32/validation/fixtures/extra_oracle.log),
[출처 hash](../4.2_ntrusolve_q32fpq32/validation/fixtures/extra_oracle_manifest.json).
이것은 시험 코드/기대값 공유이며 다른 후보 암호 소스 링크가 아니다.

## 전체 키생성 비교

| 구현 | 512 평균 cycles | 1024 평균 cycles |
| --- | ---: | ---: |
| M55_ref | 62,738,244.07 | 261,716,429.65 |
| ntt_opt | 56,951,252.87 | 243,157,429.06 |
| 4.1 | 54,272,283.72 | 230,887,527.13 |
| B | 70,938,388.01 | 271,877,299.73 |
| C | 72,938,525.49 | 276,756,184.03 |

| 보정판 | M55_ref 대비 512 / 1024 | ntt_opt 대비 512 / 1024 | 4.1 대비 512 / 1024 |
| --- | ---: | ---: | ---: |
| B | +13.07% / +3.88% | +24.56% / +11.81% | +30.71% / +17.75% |
| C | +16.26% / +5.75% | +28.07% / +13.82% | +34.39% / +19.87% |

**+%는 시간 증가(느려짐)** 이다. 표의 B/C는 이번 보정 후 결과다.
보정 전 KAT 294/300 상태의 빠른 수치를 현재 결과로 재사용하지 않았다.

## 커널/연결 구간

| 연산 | n | 원본 cycles | 보정판 cycles | 시간 배율 (후/전) |
| --- | ---: | ---: | ---: | ---: |
| FFT 내부 | 512 | 125,919.01 | 89,771.01 | 0.713× |
| FFT 내부 | 1024 | 280,385.01 | 198,492.01 | 0.708× |
| iFFT 내부 | 512 | 143,342.00 | 97,783.00 | 0.682× |
| iFFT 내부 | 1024 | 318,476.00 | 216,141.00 | 0.679× |
| 복소 역수·스케일 | 512 | 909,111.01 | 1,746,517.03 | 1.921× |
| 복소 역수·스케일 | 1024 | 1,818,167.02 | 3,492,949.06 | 1.921× |
| 점별 복소곱 | 512 | 17,469.00 | 1,062,238.02 | 60.807× |
| 점별 복소곱 | 1024 | 34,877.00 | 2,124,382.03 | 60.911× |
| 정수 입력 생성 | 512 | 42,152.00 | 83,420.00 | 1.979× |
| 정수 입력 생성 | 1024 | 84,136.00 | 166,620.00 | 1.980× |
| 정수 k 생성 | 512 | 4,642.00 | 72,013.00 | 15.513× |
| 정수 k 생성 | 1024 | 9,250.00 | 143,949.00 | 15.562× |

배율은 보정판/원본이므로 1보다 크면 느리다.
FFT/iFFT 내부 행에는 입력·출력 표현 변환이 없다. 변환은 별도 행과 연결 구간에 포함한다.
B/C의 서로 다른 측정 함수를 직접 동일 커널이라고 비교하지 않는다.

## 오차와 동등성 한계

- 커널 단독 시험: 역수/점곱의 지정 입력에서 원본 차이 0, 유효하지 않은 결과 0.
- FFT 단독의 최대 차이는 512:77, 1024:141 Q32 LSB(올림); iFFT는 각각 5 LSB.
- 연결 구간 logn 4~10, 각 100개 합성 입력에서는 최종 k 차이 0.
- 반정수 주변 직접 k 반올림: 18,576/18,576 일치.
- B와 합성 입력 분포가 다르므로 B의 k 차이 개수와 단순 비교하면 안 된다.

호스트 bounded 산술 1,000,000 입력쌍: codec/add/mul 차이 0.
넓은 범위 5종 ×200,000쌍: 표현된 DS 입력에 대한 투영 곱셈 차이 0.
그러나 큰 임의 64-bit Q32 값은 DS로 바꾸는 과정에서 하위 비트를 잃는다.
이 검사를 모든 64-bit 입력의 무손실/bit-exact 증명으로 해석하지 않는다.
UBSan 및 float-cast-overflow 시험은 위 유한 입력 집합에서 오류 없었다.
[호스트 원시 결과와 hash](validation/results/q32_rules_host_20260927/ubsan.json).

## 상수시간 검사

- 새 helper `qd_raw_floor`, `qd_mul`의 operand-dependent branch는 tested ELF에서 0.
  GCC가 만든 masked-shift 분기를 로컬 mask barrier로 제거했다.
- 원본 고정 반복 정수 division을 호출하며, 큰 곱 carry 보정은 두 계산을 모두
  수행하고 마스크로 선택한다. 비밀 크기에 따른 fallback 분기는 아니다.
- 보정 함수만 3크기 ×3연산 ×8클래스 ×100회 분리 측정:
  클래스 평균 최대 차이 0.01 cycle, 개별 min/max 범위 최대 1 cycle.
- 기존 전체 합성 segment 시험 6클래스 ×7크기는 클래스 평균이 동일했다.
- IT 조건 실행, FP 피연산자별 하드웨어 시간, 전체 keygen 재시도 및 전력/EM까지
  증명한 것은 아니다. **전체 상수시간 PASS라고 표기하지 않는다.**
- [ELF 검사 결과](validation/results/q32_rules_host_20260927/elf_audit.json).

## 메모리·측정 조건

- 키생성 성능 펌웨어: ITCM 107,476 B, DTCM 212,648 B.
- 전체 서명 시험 펌웨어: ITCM 122,700 B, DTCM 250,920 B.
- 두 DS workspace 총 16 KiB, 기존 64 KiB main stack 예약 포함. 실측 fault 없음.
  전체 호출의 최악 스택 watermark/형식적 증명은 별도다.
- 코드 중복을 줄이기 위해 큰 보정 helper 두 개는 noinline 공유. 기존 128 KiB
  코드 guard를 해제하거나 메모리 배치를 바꿔 문제를 피하지 않았다.
- NUCLEO-N657X0-Q / 800 MHz / ITCM·DTCM 각각 256 KiB / 캐시 OFF.
- GCC 15.2.1 -O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math.
- 전체 키생성 warm-up 3 +100회/크기, SysTick64/IRQ ON.
- 커널과 시간 검사 warm-up 10 +100회, DWT/IRQ OFF.
- 모든 최종 로그는 fault 레지스터 0, TCM/ECC 검사와 source hash 확인 통과.
- 같은 배치 정책 비교지만 모든 함수 주소를 고정한 실험은 아니다.

## 로그

- [kat](validation/results/kat/20260927T065146Z/raw.log) · [manifest](validation/results/kat/20260927T065146Z/manifest.json)
- [extra](validation/results/extra/20260927T064707Z/raw.log) · [manifest](validation/results/extra/20260927T064707Z/manifest.json)
- [sigkat](validation/results/sigkat/20260927T065240Z/raw.log) · [manifest](validation/results/sigkat/20260927T065240Z/manifest.json)
- [keygen_current](validation/results/keygen_current/20260927T065252Z/raw.log) · [manifest](validation/results/keygen_current/20260927T065252Z/manifest.json)
- [ds](validation/results/ds/20260927T065343Z/raw.log) · [manifest](validation/results/ds/20260927T065343Z/manifest.json)
- [q32timing](validation/results/q32timing/20260927T065707Z/raw.log) · [manifest](validation/results/q32timing/20260927T065707Z/manifest.json)

## 변경 파일과 보존

- 새 `kgen_ds_q32.h`, 수정 `kgen_fft_mve.c`.
- `kgen_ntru.c`, `kgen_fxp.c`, `kgen_ds.h`, `kgen_fft_cm55.s`는 이번 pass에서 동일.
- 실행 검증은 `validation/`의 로컬 소스 빌드. 외부 후보 암호 소스 링크 없음.
- 이전 소스·ELF·보고서는 `validation/history/pre_q32_rules_20260927/`에 보존.
- 통합 `ntt_opt`, `M55_ref` 및 `4.1`의 암호 코드는 변경하지 않음.
