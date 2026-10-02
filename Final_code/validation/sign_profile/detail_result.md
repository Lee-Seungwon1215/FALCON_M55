# Before_slothy 서명 함수별 연산 비중 — native FP64 ASM 반영 후

2026-09-28 재측정. 대상은 현재 `Final_code/Before_slothy`의 공통 NTT + K4C +
키생성 A17 + **서명 FFT/iFFT A5 ASM** 통합본이다. SLOTHY 미적용.

실제 NUCLEO-N657X0-Q에서 크기별 서명 100회씩 측정했다. 상세 계측과 내부 계측 OFF
control을 각각 2회 실행하고, 별도로 간단한 단계 계측을 1회 실행했다.
이번 작업에서는 **생산 암호 C/H/S 및 Makefile을 변경하지 않았다.**
작업 전후 38개 C/H/S와 Makefile의 SHA-256이 일치한다.

## 분모·중복 집계 규칙

분모는 **계측 ON 상태의 전체 서명 API 시간**이다. 모든 호출의 시간을 누적하며,
중첩된 함수는 배타적으로 분리한다. 키생성·검증·로그 출력 시간은 분모에 포함하지 않는다.

- `ffsamp_fft_deepest()`의 내부 Gaussian/BerExp 호출은 별도 sampler 행에만 포함한다.
- target 준비 안의 FFT와 점별 곱셈은 해당 함수 행에만 포함한다.
- LDL/split/merge 등은 재귀의 여러 크기에서 발생한 호출을 모두 합친 값이다.
- 명령어별 곱셈·나눗셈 비중이나 독립 커널 벤치마크가 아니라, 실제 서명 중 함수별 시간이다.
- 아래 대표값은 두 번째 상세 실행과 두 번째 control 실행이다. 반복 기록은 아래에 별도로 보존한다.

## 전체 서명 100% 분류

| 함수·구간 | 512 평균 cycles/서명 | 512 비중 | 1024 평균 cycles/서명 | 1024 비중 |
|---|---:|---:|---:|---:|
| `fpoly_FFT()` | 976,845.00 | 6.1241% | 2,197,582.00 | 6.4894% |
| `fpoly_iFFT()` | 404,336.00 | 2.5349% | 907,214.00 | 2.6790% |
| `fpoly_LDL_fft()` | 2,015,845.00 | 12.6379% | 4,529,001.00 | 13.3739% |
| `fpoly_split_fft()` | 1,530,022.00 | 9.5922% | 3,424,166.00 | 10.1114% |
| `fpoly_split_selfadj_fft()` | 642,736.00 | 4.0295% | 1,432,336.00 | 4.2296% |
| `fpoly_merge_fft()` | 1,423,016.00 | 8.9213% | 3,202,408.00 | 9.4566% |
| `fpoly_mul_fft()` | 1,048,732.00 | 6.5748% | 2,302,620.00 | 6.7995% |
| `fpoly_add()` | 405,360.00 | 2.5413% | 903,024.00 | 2.6666% |
| `fpoly_sub()` | 429,936.00 | 2.6954% | 958,784.00 | 2.8312% |
| `ffsamp_fft_deepest()` — sampler 제외 | 996,608.00 | 6.2480% | 1,994,240.00 | 5.8889% |
| Gaussian·BerExp sampler | 4,175,992.45 | 26.1805% | 8,232,231.51 | 24.3094% |
| Gram 계산 | 454,560.00 | 2.8498% | 910,032.00 | 2.6873% |
| target 준비 잔여 — FFT·점별 곱셈 제외 | 77,952.00 | 0.4887% | 156,288.00 | 0.4615% |
| ffSampling 재귀 제어·복사·계측 잔여 | 561,496.00 | 3.5202% | 1,157,000.00 | 3.4166% |
| 기타 키 준비·해시·후처리·인코딩·계측 잔여 | 807,308.31 | 5.0613% | 1,557,433.60 | 4.5990% |
| **합계** | **15,950,744.76** | **100%** | **33,864,360.11** | **100%** |

원시 사이클 합은 전체 시간과 정확히 일치한다. 표시 백분율만 반올림한다.
deepest와 sampler를 합친 inclusive 비중은 512 **32.4286%**,
1024 **30.1983%**이며, 이 값을 사용할 때 sampler를 다시 더하면 안 된다.

## FFT 최적화 전과 비교

이전 상세 측정의 분류·입력·100회 조건과 비교했다.
이전 보고서와 JSON은 [before_sign_fft_detail_result.md](before_sign_fft_detail_result.md),
[before_sign_fft_detail_data.json](before_sign_fft_detail_data.json)에 보존했다.
이전 FFT 계측은 C 본문 내부 scope, 현재는 ASM 호출 전후의 측정 전용 scope이므로
계측 코드가 완전히 동일한 것은 아니다.

| 항목 | 512 이전 → 현재 | 1024 이전 → 현재 |
|---|---:|---:|
| FFT+iFFT 비중 | 23.7933% → **8.6590%** | 24.9143% → **9.1683%** |
| LDL 비중 | 10.5439% → 12.6379% | 11.0555% → 13.3739% |
| 일반 split+merge 비중 | 15.4459% → 18.5135% | 16.1758% → 19.5680% |

LDL/split/merge 등 상세 표의 나머지 8개 함수는 이전과 **누적 사이클이 동일하다.**
이 함수들의 비중이 커진 것은 느려져서가 아니라 FFT/iFFT 개선으로 전체 분모가 줄었기 때문이다.
현재 변환 외 큰 단일 함수는 LDL, 일반 split, merge 순서이며 sampler도 별도의 큰 영역이다.

## 내부 계측 OFF 전체 서명 시간

| 상태 | 512 평균 cycles | 1024 평균 cycles |
|---|---:|---:|
| 이전 control — 서명 FFT 최적화 전 기록 | 18,015,448.91 | 38,736,052.37 |
| 현재 control — 내부 계측 OFF | **14,849,556.93** | **31,638,534.38** |
| 이전 / 현재 속도 배율 | **1.2132배** | **1.2243배** |
| 현재 상세 계측 ON | 15,950,744.76 | 33,864,360.11 |
| 현재 상세 ON/OFF 차이 | **+7.4156%** | **+7.0352%** |

이전 control은 보존된 기존 측정값이며 이번에 이전 암호 구현을 다시 실행한 것은 아니다.
현재 control에는 외부 API 타이머는 있고 내부 함수별 계측은 없다.
위 비중은 계측 ON 분모를 사용하므로 비계측 실행의 정확한 분할로 해석하지 않는다.
ON/OFF 차이에는 계측 비용 및 코드 배치·컴파일 변화가 포함될 수 있다.
함수마다 임의의 계측 비용을 빼거나 control 분모로 나누지 않았다.

## 반복 실행 재현성

| 모드 / UTC 실행 ID | 512: 100회 누적 cycles | 1024: 100회 누적 cycles |
|---|---:|---:|
| sign_detail / 20260928T085741Z | 1,595,074,475 | 3,386,436,011 |
| sign_control / 20260928T085756Z | 1,484,955,693 | 3,163,853,437 |
| sign_profile / 20260928T085811Z | 1,512,462,338 | 3,218,679,797 |
| sign_detail / 20260928T085825Z | 1,595,074,476 | 3,386,436,011 |
| sign_control / 20260928T085840Z | 1,484,955,693 | 3,163,853,438 |

상세 두 번 및 control 두 번의 차이는 각각 100회 누적 최대 1사이클이다.
같은 고정 입력을 반복한 재현성 검사이지 서로 독립적인 무작위 입력 통계는 아니다.
간단한 단계 계측은 [result.md](result.md)에 별도로 기록했으며, 분모가 다르므로 비중을 섞지 않는다.

## 호출 수 확인

| 함수 | 서명 1회당 512 / 1024 호출 수 |
|---|---:|
| FFT | 5 / 5 |
| iFFT | 2 / 2 |
| LDL | 255 / 511 |
| split, split_selfadj, merge 각각 | 510 / 1,022 |
| mul | 257 / 513 |
| add, sub 각각 | 255 / 511 |
| deepest | 256 / 512 |
| Gaussian sampler | 1,024 / 2,048 |

FFT 5회는 기저 4회 + target 1회, iFFT 2회는 결과 복원이다.
이번 입력에서는 서명 재시도 없이 완료했다. 재시도가 발생하면 추가 호출도 누적하는 구조이다.

## 측정 환경·검증

- NUCLEO-N657X0-Q, CPU/SYSCLK/HCLK 800/400/200 MHz.
- 코드 ITCM, 상수·데이터·스택 DTCM. 각각 256 KiB, cache OFF, ECC ON.
- GCC 15.2.1 / Zephyr 4.4.1, 암호 코드 `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16`,
  hard-float, `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 기존과 같은 키 준비 순서·메시지·seed 식. 크기별 마지막 준비 키 하나에 서명 seed 100종.
- DWT CYCCNT, 계측 구간 IRQ OFF. 준비 실행 후 측정하며 준비 시간은 제외한다.
- 5회 보드 실행 모두 크기별 100개 서명 검증 및 정해진 변조 거부 검사 PASS.
- 출력 지문: 512 `9895079d`, 1024 `a020dd02`; 이전 및 모든 현재 실행과 일치.
  FNV 지문 일치 자체는 암호학적 동등성 증명이 아니다.
- 범주 합 = 전체 시간, 계측 stack 오류 0, 재귀 구조와 함수 호출 수 일치.
- 모든 실행 CFSR/HFSR/AFSR=0, TCM_CONTROL `0x99`, TCM_MSCR `0x1300a` 시작·종료 일치.
- 이번 작업은 프로파일링이며 전체 KAT·상수시간 검사를 새로 수행한 것은 아니다.

## 생산 소스를 그대로 측정했는지 확인

`sign_fpoly.c`와 `sign_fft_cm55.s`는 채택된 A5 파일과 byte-identical이다.

- sign_fpoly.c SHA-256: `92aded616f3eb7820338ed6f17e93b1aca14ec5c06b2c1ff2cf86f953d0821a0`
- sign_fft_cm55.s SHA-256: `285a52ecc2b6eaf3f66a591c8b01b27362e78888df94acbbe8db5e2ba4163e81`

측정용 C 복사본에서만 FFT/iFFT 호출을 `fft_probes.c`로 감싸고,
이 probe는 수정하지 않은 실제 ASM 함수를 호출한다. ELF disassembly에서도
`profile_fpoly_FFT → fndsa_fpoly_FFT`, `profile_fpoly_iFFT → fndsa_fpoly_iFFT`를 확인했다.
control은 probe를 사용하지 않는다. 다른 후보 구현을 링크하지 않는다.

## 원자료·재현

- [대표 상세 로그](../results/sign_detail/20260928T085825Z/raw.log) /
  [manifest](../results/sign_detail/20260928T085825Z/manifest.json)
- [대표 control 로그](../results/sign_control/20260928T085840Z/raw.log) /
  [manifest](../results/sign_control/20260928T085840Z/manifest.json)
- [첫 상세 로그](../results/sign_detail/20260928T085741Z/raw.log) /
  [첫 control 로그](../results/sign_control/20260928T085756Z/raw.log)
- [계산 JSON](detail_data.json) / [분석 스크립트](analyze_detail.py)

각 실행 디렉터리에 ELF, compile_commands, disassembly,
`production_sources.tar.gz`, `profile_sources.tar.gz`도 보존했다.

```sh
bash Final_code/validation/build.sh sign_detail
bash Final_code/validation/build.sh sign_control
python3 Final_code/validation/run_board.py sign_detail
python3 Final_code/validation/run_board.py sign_control
python3 Final_code/validation/sign_profile/analyze_detail.py \
  Final_code/validation/results/sign_detail/20260928T085825Z \
  Final_code/validation/results/sign_control/20260928T085840Z
```

다시 실행하면 분석 스크립트의 두 경로를 새 UTC 실행 디렉터리로 바꾼다.
