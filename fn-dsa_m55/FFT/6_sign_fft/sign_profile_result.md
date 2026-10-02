# 현재 6_sign_fft 서명 함수별 연산 비중

2026-09-28. FFT/iFFT A5 ASM + native FP64 LDL이 적용된 현재 코드의 M55 실측.
LDL 수동 스케줄링 및 split·merge FP64 전환은 아직 구현하지 않았다.
이번 작업은 계측·측정만 수행했으며 생산 C/H/S·Makefile은 변경하지 않았다.

## 분모와 중첩 처리

- 분모는 **내부 계측 ON 상태의 전체 서명 API 시간**이다. 키생성·검증·로그 출력은 제외한다.
- 각 행은 중첩을 뺀 배타적 시간이다. 원시 사이클 합은 전체 시간과 정확히 일치한다.
- `apply_basis` 내부 FFT·점별 곱셈은 FFT·곱셈 행에만 포함한다.
- `deepest` 내부 sampler 호출은 sampler 행에만 포함한다.
- `sampler_next`에는 `ber_exp`, Gaussian, PRNG, 정수 산술과 거부 루프도 포함한다. **전체가 FP64 전환 가능한 시간은 아니다.**
- 함수별 실제 서명 누적 비중이며 명령어별 산술 비중이나 단독 커널 성능이 아니다.
- 512·1024 각각 100개 서명, 상세/control 각 2회 이상 동일 입력 실행의 합산 비중이다.

## 전체 서명 100% 표

| 함수·구간 | 512 평균 cycles/서명 | 512 비중 | 1024 평균 cycles/서명 | 1024 비중 |
|---|---:|---:|---:|---:|
| `fpoly_FFT()` | 976,845.00 | 6.8314% | 2,197,582.00 | 7.2864% |
| `fpoly_iFFT()` | 404,336.00 | 2.8277% | 907,214.00 | 3.0080% |
| `fpoly_LDL_fft()` — native FP64 | 367,452.00 | 2.5697% | 830,908.00 | 2.7550% |
| `fpoly_split_fft()` | 1,530,022.00 | 10.7000% | 3,424,166.00 | 11.3533% |
| `fpoly_merge_fft()` | 1,423,016.00 | 9.9517% | 3,202,408.00 | 10.6180% |
| `fpoly_split_selfadj_fft()` | 642,736.00 | 4.4949% | 1,432,336.00 | 4.7491% |
| `fpoly_mul_fft()` | 1,048,732.00 | 7.3342% | 2,302,620.00 | 7.6346% |
| `fpoly_add()` | 405,360.00 | 2.8348% | 903,024.00 | 2.9941% |
| `fpoly_sub()` | 429,936.00 | 3.0067% | 958,784.00 | 3.1790% |
| `fpoly_gram_fft()` | 454,560.00 | 3.1789% | 910,032.00 | 3.0173% |
| `fpoly_apply_basis()` — FFT·점별 곱셈 제외 | 77,952.00 | 0.5451% | 156,288.00 | 0.5182% |
| `ffsamp_fft_deepest()` — sampler 제외 | 996,608.00 | 6.9696% | 1,994,240.00 | 6.6122% |
| `sampler_next()` — 내부 `ber_exp()`·Gaussian 포함 | 4,175,992.45 | 29.2042% | 8,232,231.51 | 27.2951% |
| ffSampling 재귀 제어·복사·계측 잔여 | 558,436.00 | 3.9053% | 1,150,868.00 | 3.8159% |
| 기타 키 준비·해시·후처리·인코딩·계측 잔여 | 807,308.31 | 5.6458% | 1,557,433.60 | 5.1639% |
| **합계** | **14,299,291.76** | **100%** | **30,160,135.11** | **100%** |

일반 split+merge 합계는 512 **20.6516%**, 1024 **21.9713%**다.
백분율 표시 반올림 때문에 표시된 행들의 합에는 끝자리 차이가 있을 수 있다.

## 내부 계측 OFF와 측정 비용

| 구분 | 512 평균 cycles | 1024 평균 cycles |
|---|---:|---:|
| 내부 계측 OFF control | 13,201,697.93 | 27,939,407.38 |
| 함수별 계측 ON | 14,299,291.76 | 30,160,135.11 |
| ON/OFF 차이 | +8.3140% | +7.9484% |

ON/OFF 차이는 계측 비용뿐 아니라 코드 배치·컴파일 변화도 포함할 수 있다.
따라서 ON 비중을 비계측 실행의 정확한 분할이나 보장된 최적화 가능 시간으로 해석하지 않는다.
임의의 고정 계측 비용을 함수별로 빼거나, ON 함수 시간을 OFF 분모로 나누지 않았다.

## 이전 LDL 전환 전 기록과 구분

이전 `Final_code/Before_slothy` 상세 기록과 현재 기록은 같은 단계 분류·입력·계측 방식을 사용한다.
이전 소스를 이번에 다시 실행한 비교는 아니다. 기존 기록을 읽어 아래에 표시한다.

| 항목 | 512 이전 → 현재 | 1024 이전 → 현재 |
|---|---:|---:|
| LDL 비중 | 12.6379% → 2.5697% | 13.3739% → 2.7550% |
| split 비중 | 9.5922% → 10.7000% | 10.1114% → 11.3533% |
| merge 비중 | 8.9213% → 9.9517% | 9.4566% → 10.6180% |

변경하지 않은 함수의 비중 상승은 전체 분모 감소 때문일 수 있다. 절대 사이클도 함께 확인한다.

## 반복 실행·검증

| 모드 / UTC 실행 ID | 512: 100회 누적 cycles | 1024: 100회 누적 cycles |
|---|---:|---:|
| sign_detail / 20260928T100418Z | 1,429,929,176 | 3,016,013,512 |
| sign_control / 20260928T100704Z | 1,320,169,793 | 2,793,940,737 |
| sign_detail / 20260928T100800Z | 1,429,929,176 | 3,016,013,511 |
| sign_control / 20260928T100834Z | 1,320,169,793 | 2,793,940,738 |

- 모든 측정에서 각 크기 100개 서명 정상 검증 및 정해진 변조 거부 검사 통과.
- 출력 지문 512 `9895079d`, 1024 `a020dd02`로 이전 기록 및 ON/OFF 실행과 일치.
- 계측 stack 오류 0, 범주 합 일치, 재귀 호출 수 확인. 전체 KAT·상수시간 검사를 새로 수행한 작업은 아니다.
- 동일 입력의 반복은 재현성 확인이다. 서로 다른 키의 대규모 무작위 통계는 아니다.
- CFSR/HFSR/AFSR=0, 시작·종료 TCM_CONTROL=0x99, ECC 설정 유지.

## 조건

NUCLEO-N657X0-Q, CPU/SYSCLK/HCLK 800/400/200 MHz. ITCM 코드, DTCM 상수·데이터·스택,
각각 256 KiB, cache OFF, ECC ON. GCC 15.2.1 / Zephyr 4.4.1, pinned mlkem-native 플랫폼.
`-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16`, hard-float, `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
DWT CYCCNT, 서명 계측 중 IRQ OFF. 기존 프로파일과 같은 준비 실행·키 준비 순서·메시지·seed 식.
크기별 10개 준비 키 중 마지막 키 하나에 100개 서명 seed를 사용한다.

## 원자료·재현

생산 소스는 그대로 두고 build 아래 시험용 C 복사본에만 계측을 추가한다.
FFT/iFFT는 시험용 probe가 변경하지 않은 실제 ASM을 호출한다. 다른 후보 암호 구현을 가져오지 않는다.
각 실행에 소스·계측 소스 archive, ELF, disassembly, compile_commands, SHA-256 manifest를 보존했다.

- sign_detail 20260928T100418Z: [로그](validation/results/candidate_sign_detail/20260928T100418Z/raw.log) / [manifest](validation/results/candidate_sign_detail/20260928T100418Z/manifest.json)
- sign_control 20260928T100704Z: [로그](validation/results/candidate_sign_control/20260928T100704Z/raw.log) / [manifest](validation/results/candidate_sign_control/20260928T100704Z/manifest.json)
- sign_detail 20260928T100800Z: [로그](validation/results/candidate_sign_detail/20260928T100800Z/raw.log) / [manifest](validation/results/candidate_sign_detail/20260928T100800Z/manifest.json)
- sign_control 20260928T100834Z: [로그](validation/results/candidate_sign_control/20260928T100834Z/raw.log) / [manifest](validation/results/candidate_sign_control/20260928T100834Z/manifest.json)

- [계산 JSON](validation/sign_profile/data.json)
- [생성기](validation/sign_profile/generate.py) / [집계기](validation/sign_profile/analyze.py)
- [이전 LDL 전환 전 비중](../../../Final_code/validation/sign_profile/detail_result.md)

```sh
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign_detail
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign_control
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign_detail
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign_control
# 위 보드 실행 쌍을 한 번 더 실행한 뒤:
python3 fn-dsa_m55/FFT/6_sign_fft/validation/sign_profile/analyze.py DETAIL1 CONTROL1 DETAIL2 CONTROL2
```
