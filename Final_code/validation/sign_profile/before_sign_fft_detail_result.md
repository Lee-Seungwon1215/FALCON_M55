# 서명 FFT·LDL·분할·병합 함수별 상세 비중

2026-09-28, `Final_code/Before_slothy`, 실제 NUCLEO-N657X0-Q.
크기별 서명 100회. 생산 C/H/S 파일 37개의 해시가 이전 실행과 같음을 확인했다.
변경한 것은 측정 도구와 빌드 디렉터리의 계측용 복사본뿐이다.

## 분모와 중복 집계 규칙

아래 기본 분모는 **계측한 전체 서명 API 시간**이다. 각 함수의 서명 중 모든 호출을
누적하고, 중첩된 계측 함수는 배타적으로 분리했다.

- `ffsamp_fft_deepest()`는 내부 `sampler_next()` 시간을 제외한다.
- Gaussian·BerExp는 별도 행이다. deepest에 다시 더해 중복 계산하지 않는다.
- `fpoly_apply_basis()` 안의 FFT·점별 곱셈은 각각 해당 함수에만 집계한다.
- LDL/split/merge/mul/add/sub 값은 **재귀의 여러 logn에서 발생한 호출을 합친 것**이다.
  예를 들어 512 열의 LDL 값은 512 크기의 LDL 호출 하나를 뜻하지 않는다.
- 이 결과는 함수별 비중이다. 각 함수 내부의 곱셈·덧셈·나눗셈 명령별 비중을
  추가로 분해한 것은 아니다.

## 요청한 함수의 전체 서명 대비 비중

| 함수 | 512 평균 cycles/서명 | 512 비중 | 1024 평균 cycles/서명 | 1024 비중 |
|---|---:|---:|---:|---:|
| `fpoly_FFT()` | 3,220,460 | 16.8447% | 7,231,273 | 17.6519% |
| `fpoly_iFFT()` | 1,328,476 | 6.9486% | 2,975,144 | 7.2625% |
| `fpoly_LDL_fft()` | 2,015,845 | 10.5439% | 4,529,001 | 11.0555% |
| `fpoly_split_fft()` | 1,530,022 | 8.0028% | 3,424,166 | 8.3586% |
| `fpoly_split_selfadj_fft()` | 642,736 | 3.3618% | 1,432,336 | 3.4964% |
| `fpoly_merge_fft()` | 1,423,016 | 7.4431% | 3,202,408 | 7.8172% |
| `fpoly_mul_fft()` | 1,048,732 | 5.4854% | 2,302,620 | 5.6208% |
| `fpoly_add()` | 405,360 | 2.1202% | 903,024 | 2.2043% |
| `fpoly_sub()` | 429,936 | 2.2488% | 958,784 | 2.3404% |
| `ffsamp_fft_deepest()` — sampler 제외 | 996,608 | 5.2128% | 1,994,240 | 4.8680% |
| **위 10개 함수 합계** | **13,041,191** | **68.2123%** | **28,952,996** | **70.6756%** |

FFT 이외의 큰 개별 함수는 **LDL → 일반 split → merge** 순서였다.
특히 merge의 누적 비중은 iFFT보다 크지만, 이는 작은 크기에서 매우 많이 호출되는
누적 비용이지 동일 크기 1회당 비용의 비교는 아니다.

## 나머지까지 포함한 분류

| 구분 | 512 | 1024 |
|---|---:|---:|
| 위 10개 함수 | 68.2123% | 70.6756% |
| Gaussian·BerExp sampler | 21.8426% | 20.0953% |
| Gram 계산 | 2.3776% | 2.2214% |
| target 준비 잔여 — FFT·점별 곱셈 제외 | 0.4078% | 0.3815% |
| ffSampling 재귀 제어·복사·계측 잔여 | 2.9369% | 2.8243% |
| 기타 준비·해시·후처리·인코딩 등 | 4.2228% | 3.8018% |
| **합계** | **100%** | **100%** |

반올림으로 표시 합계에 미세한 차이가 있을 수 있지만, 원시 사이클 합은 정확히 일치한다.
deepest의 sampler 포함 inclusive 비중이 필요하면 512 **27.0554%**, 1024 **24.9633%**이다.
이 inclusive 값을 표에 쓰는 경우 별도 sampler 행을 더하면 안 된다.

## 요청한 10개 함수 안에서만 100%로 정규화한 비중

다음 표의 분모는 전체 서명이 아니라 **위 10개 함수의 배타적 시간 합계**이다.

| 함수 | 512: 10개 함수 내 비중 | 1024: 10개 함수 내 비중 |
|---|---:|---:|
| `fpoly_FFT()` | 24.6945% | 24.9759% |
| `fpoly_iFFT()` | 10.1868% | 10.2758% |
| `fpoly_LDL_fft()` | 15.4575% | 15.6426% |
| `fpoly_split_fft()` | 11.7322% | 11.8266% |
| `fpoly_split_selfadj_fft()` | 4.9285% | 4.9471% |
| `fpoly_merge_fft()` | 10.9117% | 11.0607% |
| `fpoly_mul_fft()` | 8.0417% | 7.9530% |
| `fpoly_add()` | 3.1083% | 3.1189% |
| `fpoly_sub()` | 3.2968% | 3.3115% |
| `ffsamp_fft_deepest()` — sampler 제외 | 7.6420% | 6.8879% |
| **합계** | **100%** | **100%** |

## 서명 1회당 호출 횟수

| 함수 | 512 | 1024 |
|---|---:|---:|
| FFT / iFFT | 5 / 2 | 5 / 2 |
| LDL | 255 | 511 |
| split / split_selfadj / merge 각각 | 510 | 1,022 |
| mul | 257 | 513 |
| add / sub 각각 | 255 | 511 |
| deepest | 256 | 512 |
| Gaussian sampler | 1,024 | 2,048 |

일반 재귀 노드 수는 `n/2-1`, deepest 노드 수는 `n/2`이다.
mul의 추가 2회는 target 준비에서 발생한다. 이번 100개 입력에서는 서명 재시도 없이
완료되었으며, 재시도가 발생하면 해당 호출들도 계측에 포함된다.

## 계측 영향과 이전 표와의 차이

| 전체 서명 평균 | 512 cycles | 1024 cycles |
|---|---:|---:|
| 이번 내부 계측 OFF control | 18,015,448.91 | 38,736,052.37 |
| 이번 함수별 상세 계측 | 19,118,537.76 | 40,966,019.12 |
| 계측 ON/OFF 차이 | **+6.1230%** | **+5.7568%** |

이전 간단한 계측은 +1.4~1.5%였지만, 이번에는 수백~수천 번 호출되는 함수의
진입/종료까지 기록하여 교란이 늘었다. 위 값은 **계측 포함 비중**이며, 실제 비계측
실행의 정확한 분할이나 최적화 속도 개선률로 해석하면 안 된다. 코드 위치·컴파일
변화도 포함될 수 있으므로 차이를 순수 타이머 비용이라고 단정하지 않는다.

예를 들어 FFT 누적 시간은 이전 512 3,220,435.06 / 1024 7,231,048.00 cycles에서
이번 3,220,460 / 7,231,273 cycles로 거의 같지만, 계측 분모가 증가하여 비중이 낮아졌다.
FFT 자체가 빨라지거나 느려진 결과가 아니다. 과거 표의 백분율과 새 표를 섞지 않는다.

## 환경·검증·한계

- CPU/SYSCLK/HCLK 800/400/200 MHz, ITCM/DTCM 각각 256 KiB.
- 코드 ITCM, 상수·데이터·스택 DTCM, cache OFF, ECC ON.
- GCC 15.2.1, Zephyr 4.4.1, `-O3 -mfpu=fpv5-d16`, hard-float,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 이전과 같은 메시지·seed 생성식·준비 호출. 크기별 고정 키 하나에 서명 seed 100종.
  모든 키·메시지에서 같은 비중을 보장하는 표는 아니다.
- DWT CYCCNT, 서명 계측 구간 IRQ OFF. 키생성/검증/출력 시간은 분모에 미포함.
- 두 이미지 모두 서명 100회/크기 정상 검증, 변조 거부 통과.
- 출력 FNV-1a가 기존 실행 및 control과 일치: 512 `9895079d`, 1024 `a020dd02`.
- 원시 범주 합=전체 시간, 계측 스택 오류 0, 호출 수를 재귀 구조와 대조하여 일치 확인.
- CFSR/HFSR/AFSR=0, TCM/ECC 시작·종료 확인. 전체 KAT·상수시간 증명을 새로 한 것은 아니다.

## 원자료·재현

- [상세 계측 로그](../results/sign_detail/20260928T063851Z/raw.log)
- [상세 계측 manifest](../results/sign_detail/20260928T063851Z/manifest.json)
- [control 로그](../results/sign_control/20260928T063907Z/raw.log)
- [control manifest](../results/sign_control/20260928T063907Z/manifest.json)
- [계산에 사용한 당시 상세 JSON](before_sign_fft_detail_data.json)

```sh
bash Final_code/validation/build.sh sign_detail
bash Final_code/validation/build.sh sign_control
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python Final_code/validation/run_board.py sign_detail
python Final_code/validation/run_board.py sign_control
python Final_code/validation/sign_profile/analyze_detail.py \
  Final_code/validation/results/sign_detail/20260928T063851Z \
  Final_code/validation/results/sign_control/20260928T063907Z
```

다시 실행하면 마지막 두 경로를 새 UTC 실행 디렉터리로 바꾼다.
