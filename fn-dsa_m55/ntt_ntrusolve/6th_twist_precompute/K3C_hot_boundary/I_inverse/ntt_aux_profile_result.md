# ref_preslothy — NTT 보조 연산 비중 실측

대상은 현재 M55의 `ntt_ntrusolve/ref_preslothy`이다. M4 실측이나 과거 ref의 비중이 아니다.

## 조건과 범위

- NUCLEO-N657X0-Q / STM32N657 / Cortex-M55 r1p1, CPU 800 MHz.
- 코드 ITCM, 상수·데이터·스택 DTCM, 각각 256 KiB. I/D cache OFF, TCM ECC ON.
- `mlkem-native` 637d076 기반 기존 로더·Zephyr 4.4.1·GCC 15.2.1·`-O3`를 그대로 사용.
- M4/M55 어셈블리 ON, `FNDSA_MVE_MP31=1`. 이 폴더의 C 및 6개 asm만 암호 소스로 빌드.
- 이전 단계 프로파일과 같은 seed·메시지·입력 및 키생성 10회 / 서명 100회 / 검증 100회 (각 512/1024).
- DWT CYCCNT, API 계측 중 IRQ OFF. 검증·출력 지문 계산·로그 출력은 해당 API 시간 밖.
- control은 API 총시간과 solve_NTRU 전체만 계측. detailed는 추가 함수/루프 구간을 계측.
- 원본 암호 코드 31개는 변경하지 않았다. 별도 build/generated에 타이머 삽입본을 생성했다.
- q-NTT 곱셈은 계측 전용 wrapper가 같은 로컬 asm을 호출한다. 암호 구현 교체용 링크 선택이 아니다.

상수표는 `mp_mkgm/mp_mkigm/mp_mkgmigm`의 RNS용 동적 생성이다. q=12289의 미리 저장된 표를 읽는 시간은 이 항목이 아니다.
RNS 점별 연산은 NTT 영역의 9개 루프만 포함한다. CRT, RNS 변환, NTT/iNTT butterfly, FFT, 복사 등은 제외한다. 단, depth 0의 두 구간은 `mp_div()` 모듈러 나눗셈을 포함하므로 순수 곱셈 비중으로 해석하면 안 된다.

## 1. 키생성·서명·검증 전체를 각각 100%로 본 비중

계산식: `해당 구간 누적 cycles / 해당 API 누적 cycles × 100`. 서로 배타적인 구간이므로 원자료 합은 정확히 100%. 표시는 반올림했다.

| 크기 | 단계 | 상수표 생성 | mqpoly_mul_ntt | mqpoly_div_ntt | RNS 점별 연산 | 나머지 |
|---|---|---:|---:|---:|---:|---:|
| 512 | 키생성 | 2.87% | 0.00% | 0.04% | 5.92% | 91.17% |
| 512 | 서명 | 0.00% | 0.18% | 0.12% | 0.00% | 99.70% |
| 512 | 검증 | 0.00% | 1.99% | 0.00% | 0.00% | 98.01% |
| 1024 | 키생성 | 1.80% | 0.00% | 0.02% | 2.92% | 95.27% |
| 1024 | 서명 | 0.00% | 0.17% | 0.11% | 0.00% | 99.72% |
| 1024 | 검증 | 0.00% | 2.03% | 0.00% | 0.00% | 97.97% |

0%는 이번 경로에서 호출되지 않았다는 뜻이다. '나머지'에는 이미 최적화한 NTT/iNTT 변환과 CRT·Bezout·FFT·sampler·hash 등이 포함된다.

## 2. NTRU solve만 다시 100%로 보았을 때

NTRU 총시간은 `ntru_rest + table_* + rns_*`의 합이다. 공개키 계산의 mqpoly_div_ntt는 NTRU 밖이므로 포함하지 않는다.

| 크기 | NTRU / 전체 키생성 | 상수표 / NTRU | RNS 점별 / NTRU | NTRU 나머지 |
|---|---:|---:|---:|---:|
| 512 | 80.04% | 3.58% | 7.40% | 89.02% |
| 1024 | 70.67% | 2.54% | 4.13% | 93.33% |

## 3. 내부 구간 상세 (전체 키생성 기준)

cycles/키생성은 모든 재시도 시간을 포함한 누적 cycles / 성공 키생성 10회이다. entries는 전체 실행에서 계측 구간에 들어간 횟수이며 원소별 곱셈 횟수가 아니다.

| 구간 | 512 cycles/키생성 | 512 비중 | 512 entries | 1024 cycles/키생성 | 1024 비중 | 1024 entries |
|---|---:|---:|---:|---:|---:|---:|
| mp_mkgm | 199,643.9 | 0.380% | 1,554 | 523,591.8 | 0.198% | 4,144 |
| mp_mkigm | 178,585.7 | 0.340% | 1,443 | 483,761.7 | 0.183% | 3,949 |
| mp_mkgmigm | 1,130,009.9 | 2.149% | 11,243 | 3,744,020.5 | 1.416% | 36,218 |
| 재귀 하강: f,g의 norm/resultant 곱셈 | 175,708.7 | 0.334% | 3,559 | 588,998.7 | 0.223% | 10,823 |
| 상승: F lifting 곱셈 | 130,846.4 | 0.249% | 3,403 | 345,831.0 | 0.131% | 9,843 |
| depth 0: G 계산 + Babai 분자·분모 (mp_div 포함) | 890,874.0 | 1.694% | 10 | 1,781,562.0 | 0.674% | 10 |
| depth 0: F 보정 + G 재계산 (mp_div 포함) | 865,945.0 | 1.646% | 10 | 1,731,737.1 | 0.655% | 10 |
| poly_sub_scaled_ntt: k·f 점별 곱셈 | 758,505.0 | 1.442% | 7,850 | 2,607,178.5 | 0.986% | 26,385 |
| depth 1: N(f)·k 계산 및 F 차감 | 292,500.0 | 0.556% | 150 | 660,076.0 | 0.250% | 170 |

### q-NTT 계수별 곱셈·나눗셈 호출

| 크기 | 함수 | cycles/함수 호출 | 키생성당 호출 | 서명당 호출 | 검증당 호출 |
|---|---|---:|---:|---:|---:|
| 512 | mqpoly_mul_ntt | 6,436.0 | 0 | 5 | 1 |
| 512 | mqpoly_div_ntt | 21,008.0 | 1 | 1 | 0 |
| 1024 | mqpoly_mul_ntt | 12,708.0 | 0 | 5 | 1 |
| 1024 | mqpoly_div_ntt | 41,744.0 | 1 | 1 | 0 |

## 4. 계측 영향과 재현성

아래 차이는 타이머 비용뿐 아니라 타이머 삽입에 따른 레지스터 배치·인라이닝·코드 배치 변화까지 포함한다. 이를 각 항목에서 일괄 차감하지 않았다. 세부 비중은 계측 실행의 관측치이며 무계측 실행의 정확한 함수별 비중 또는 오차 한계가 아니다.

| 크기 | 단계 | control cycles/API | detailed cycles/API | 관측된 총시간 차이 |
|---|---|---:|---:|---:|
| 512 | 키생성 | 51,835,739.70 | 52,593,758.40 | +1.4623% |
| 512 | 서명 | 17,365,874.34 | 17,444,046.33 | +0.4501% |
| 512 | 검증 | 323,461.00 | 323,740.00 | +0.0863% |
| 1024 | 키생성 | 262,050,354.70 | 264,410,762.30 | +0.9007% |
| 1024 | 서명 | 37,239,824.27 | 37,412,976.29 | +0.4650% |
| 1024 | 검증 | 625,008.00 | 625,289.00 | +0.0450% |

세부 계측은 같은 ELF로 2회 독립 실행했다. 각 실행마다 512/1024 모두 동일한 위 반복 횟수를 적용했다.

| 크기 | 단계 | 재실행 간 API 총 cycles 최댓값−최솟값 |
|---|---|---:|
| 512 | 키생성 | 1 |
| 512 | 서명 | 1 |
| 512 | 검증 | 0 |
| 1024 | 키생성 | 0 |
| 1024 | 서명 | 0 |
| 1024 | 검증 | 0 |

- 키·공개키·서명의 기존 FNV-1a 출력 지문 일치: 512 `9895079d`, 1024 `a020dd02`.
- 정상 서명 검증 및 변조 서명 거부 PASS. 프로파일 스택/합계 오류 0. CFSR/HFSR/AFSR 모두 0.
- 이는 현재 workload의 회귀 확인이며 전체 KAT corpus·수학적 오차증명·상수시간 검사를 새로 실행했다는 뜻은 아니다.
- 이번에는 최적화를 구현하지 않았고 암호 소스의 변경도 없다.

## 5. 소스 경계

아래 줄 번호는 원본 파일 기준. 루프 본문의 SHA-256은 build/generated/manifest.json에도 기록했다.

| 파일 | 함수 | 구간 | 원본 줄 |
|---|---|---|---|
| [mq.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/mq.c:1971) | mqpoly_div_ntt | CAT_MQ_DIV | 1971 (함수 전체) |
| [kgen_mp31.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_mp31.c:295) | mp_mkgm | CAT_TABLE_GM | 295 (함수 전체) |
| [kgen_mp31.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_mp31.c:379) | mp_mkigm | CAT_TABLE_IGM | 379 (함수 전체) |
| [kgen_mp31.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_mp31.c:171) | mp_mkgmigm | CAT_TABLE_BOTH | 171 (함수 전체) |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:1820) | solve_NTRU | CAT_NTRU_REST | 1820 (함수 전체) |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:104) | make_fg_step | CAT_RNS_DESCENT | 104–111 |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:137) | make_fg_step | CAT_RNS_DESCENT | 137–141 |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:148) | make_fg_step | CAT_RNS_DESCENT | 148–152 |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:608) | solve_NTRU_intermediate | CAT_RNS_LIFTING | 608–614 |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:1286) | solve_NTRU_depth0 | CAT_RNS_LIFTING | 1286–1292 |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:1331) | solve_NTRU_depth0 | CAT_RNS_DEPTH0_BABAI | 1331–1359 |
| [kgen_ntru.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_ntru.c:1441) | solve_NTRU_depth0 | CAT_RNS_DEPTH0_RECOVER | 1441–1453 |
| [kgen_poly.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_poly.c:891) | poly_sub_scaled_ntt | CAT_RNS_SCALED_SUB | 891–894 |
| [kgen_poly.c](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/kgen_poly.c:1076) | poly_sub_kf_scaled_depth1 | CAT_RNS_DEPTH1_SUB | 1076–1100 |
| [mq_cm55.s](/Users/seungwon/FALCON/fn-dsa_m55/ntt_ntrusolve/ref_preslothy/mq_cm55.s:723) | fndsa_mqpoly_mul_ntt | CAT_MQ_MUL | 함수 전체 (계측 wrapper) |

## 6. 원본 로그와 빌드 증거

- 원본 암호 소스 SHA-256: `1bee63df84452c426acc1b045a25d771a456d76ead95b3ee9cc2c39fe354daae`
- 상세 계측 빌드: ITCM 105,084 B / 262,144 B, DTCM 221,568 B / 262,144 B (정적 stack 예약 포함).
- control 빌드: ITCM 104,796 B, DTCM 221,568 B. 둘 다 용량 이내.
- linker의 FLASH/RAM 이름은 각각 0x10000000 ITCM / 0x30000000 DTCM이다. 물리 flash 실행이 아니다.
- control: [raw.log](/Users/seungwon/FALCON/fn-dsa_m55/ntt_aux_profile/results/control/runs/20260915T153646Z/raw.log), [run.json](/Users/seungwon/FALCON/fn-dsa_m55/ntt_aux_profile/results/control/runs/20260915T153646Z/run.json)
  - ELF SHA-256: `2a4149d79332b456b652d1b15f933d4c81753ae15b84ea727616c64da970c461`
- detailed 20260915T153822Z: [raw.log](/Users/seungwon/FALCON/fn-dsa_m55/ntt_aux_profile/results/detailed/runs/20260915T153822Z/raw.log), [run.json](/Users/seungwon/FALCON/fn-dsa_m55/ntt_aux_profile/results/detailed/runs/20260915T153822Z/run.json)
  - ELF SHA-256: `49de92a1c1146b29951e8a84dc354bc4e487e7d86ab5c3198a79034093012731`
- detailed 20260915T153921Z: [raw.log](/Users/seungwon/FALCON/fn-dsa_m55/ntt_aux_profile/results/detailed/runs/20260915T153921Z/raw.log), [run.json](/Users/seungwon/FALCON/fn-dsa_m55/ntt_aux_profile/results/detailed/runs/20260915T153921Z/run.json)
  - ELF SHA-256: `49de92a1c1146b29951e8a84dc354bc4e487e7d86ab5c3198a79034093012731`

재실행 방법:

```sh
bash fn-dsa_m55/ntt_aux_profile/build.sh all
python3 -B fn-dsa_m55/ntt_aux_profile/run.py control
python3 -B fn-dsa_m55/ntt_aux_profile/run.py detailed
python3 -B fn-dsa_m55/ntt_aux_profile/test_profile.py -v
python3 -B fn-dsa_m55/ntt_aux_profile/report.py
```

run.py는 지정된 M55 보드 접근 승인이 필요하다. M4 보드는 사용하지 않는다.
