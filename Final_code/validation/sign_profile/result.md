# Before_slothy 서명 단계 비중 — native FP64 ASM 반영 후

2026-09-28 실제 NUCLEO-N657X0-Q 재측정. 현재 `Final_code/Before_slothy`의
서명 FFT/iFFT A5 ASM 반영 상태, SLOTHY 미적용이다.

**세부 함수별 현재 비중은 [detail_result.md](detail_result.md)가 기준이다.**
이 문서는 계측 지점을 줄인 별도 실행이다. 두 표는 분모와 계측 비용이 다르므로
백분율을 섞어 합산하지 않는다. 이전 기록은 [before_sign_fft_result.md](before_sign_fft_result.md)에 보존했다.

## 전체 서명 100% 분류

분모는 계측한 전체 서명 API 시간이다. 중첩 호출을 배타적으로 분리했다.
키생성·검증·출력 시간은 포함하지 않는다.

| 구간 | 512 | 1024 |
|---|---:|---:|
| FFT: `fpoly_FFT()` | 6.4585% | 6.8275% |
| iFFT: `fpoly_iFFT()` | 2.6733% | 2.8186% |
| Gram 계산 | 3.0054% | 2.8273% |
| target 준비 — FFT 제외 | 1.8375% | 1.7289% |
| LDL·ffSampling — Gaussian/BerExp 제외 | 53.1165% | 55.4196% |
| Gaussian·BerExp sampler | 27.5712% | 25.5395% |
| 기타 준비·해시·후처리·인코딩·계측 잔여 | 5.3377% | 4.8387% |
| **합계** | **100%** | **100%** |

FFT+iFFT 합계는 **9.1318% / 9.6460%**다.
LDL·ffSampling 행에는 LDL, split, merge, 점별 연산, deepest, 재귀 제어 등이 포함된다.
FFT/iFFT 두 변환 함수만 수정한다고 이 영역 전체가 자동으로 개선되지는 않는다.
상세 계측에서는 이 묶음을 개별 함수로 나눴다.

## 누적 cycles와 계측 영향

| 항목 | 512 평균 cycles/서명 | 1024 평균 cycles/서명 |
|---|---:|---:|
| FFT — 서명당 5회 누적 | 976,820.00 | 2,197,549.04 |
| iFFT — 서명당 2회 누적 | 404,326.00 | 907,204.00 |
| 전체 — 내부 계측 OFF control | 14,849,556.93 | 31,638,534.38 |
| 전체 — 간단한 단계 계측 ON | 15,124,623.38 | 32,186,797.97 |
| ON/OFF 차이 | +1.8524% | +1.7329% |

ON/OFF 차이에는 계측 비용과 코드 배치·컴파일 영향이 포함될 수 있다.
위 백분율을 비계측 시간의 정확한 분할로 해석하지 않는다.
별도 고립 커널 측정이 아니라 실제 서명 중 모든 호출을 누적한 값이다.

## 조건·검증

- 크기별 100회, 기존과 같은 고정 키·메시지·서명 seed 100종.
- CPU/SYSCLK/HCLK 800/400/200 MHz, 코드 ITCM, 상수·데이터·스택 DTCM.
  ITCM/DTCM 각각 256 KiB, cache OFF, ECC ON.
- GCC 15.2.1 / Zephyr 4.4.1, 암호 코드 `-O3 -mfpu=fpv5-d16`, hard-float,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- DWT CYCCNT, 측정 구간 IRQ OFF. 서명 100/100 정상 검증 및 변조 거부 검사 PASS.
- 지문: 512 `9895079d`, 1024 `a020dd02`, control·상세 실행·이전 기록과 일치.
- 원시 범주 합 = API 전체 시간, 계측 오류 0, CFSR/HFSR/AFSR=0, TCM/ECC 유지.
- 생산 소스 변경 없음. 계측용 C 사본 및 실제 ASM을 호출하는 별도 probe만 사용했다.
- 이번 프로파일링은 전체 KAT·상수시간 검사를 새로 수행한 것이 아니다.

## 원자료·재현

- [단계 로그](../results/sign_profile/20260928T085811Z/raw.log) /
  [manifest](../results/sign_profile/20260928T085811Z/manifest.json)
- [control 로그](../results/sign_control/20260928T085840Z/raw.log) /
  [manifest](../results/sign_control/20260928T085840Z/manifest.json)
- [현재 함수별 상세 결과](detail_result.md)

각 실행 디렉터리에 ELF·컴파일 명령·disassembly·생산 및 계측 소스 snapshot을 보존했다.

```sh
bash Final_code/validation/build.sh sign_profile
bash Final_code/validation/build.sh sign_control
python3 Final_code/validation/run_board.py sign_profile
python3 Final_code/validation/run_board.py sign_control
```
