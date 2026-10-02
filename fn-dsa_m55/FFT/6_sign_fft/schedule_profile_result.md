# 최종 L5b + S6 서명 연산비중

2026-09-28. [최적화 결과](schedule_result.md)에 대응하는 통합 코드의 관찰용 기록.
**이전 비중 표·JSON은 보존했으며 이 파일로 덮어쓰지 않았다.**

## 분모와 계측

분모는 내부 계측 ON 전체 서명 API 시간이다. 중첩 시간을 뺀 배타적 집계이며 원시 사이클 합은 정확히 100%다.
512/1024 각각 100회, detail/control 각각 두 번 실행했다. 키생성·검증·출력은 계측 밖이다.
실제 재귀 ASM에서 LDL/split/merge를 직접 호출하므로 build 아래 시험용 복사본의 호출도 wrapper로 연결했다.
생산 ASM은 변경하지 않았다. 예상 재귀 호출 수와 합계를 집계기가 확인했다.

| 함수·구간 | 512 cycles/서명 | 512 비중 | 1024 cycles/서명 | 1024 비중 |
|---|---:|---:|---:|---:|
| `fpoly_FFT()` | 976,845.00 | 7.9230% | 2,197,582.00 | 8.5348% |
| `fpoly_iFFT()` | 404,336.00 | 3.2795% | 907,214.00 | 3.5234% |
| `fpoly_LDL_fft()` | 360,025.00 | 2.9201% | 814,009.00 | 3.1614% |
| `fpoly_split_fft()` | 526,490.00 | 4.2702% | 1,186,490.00 | 4.6080% |
| `fpoly_merge_fft()` | 472,144.00 | 3.8294% | 1,061,584.00 | 4.1229% |
| `fpoly_split_selfadj_fft()` | 642,736.00 | 5.2131% | 1,432,336.00 | 5.5628% |
| `fpoly_mul_fft()` | 1,048,732.00 | 8.5060% | 2,302,620.00 | 8.9428% |
| `fpoly_add()` | 405,360.00 | 3.2878% | 903,024.00 | 3.5071% |
| `fpoly_sub()` | 429,936.00 | 3.4871% | 958,784.00 | 3.7237% |
| `fpoly_gram_fft()` | 454,560.00 | 3.6868% | 910,032.00 | 3.5343% |
| `fpoly_apply_basis()` — FFT·점별 곱 제외 | 77,952.00 | 0.6322% | 156,288.00 | 0.6070% |
| `ffsamp_fft_deepest()` — sampler 제외 | 996,608.00 | 8.0832% | 1,994,240.00 | 7.7451% |
| `sampler_next()` — BerExp/Gaussian/PRNG/정수·제어 포함 | 4,175,992.45 | 33.8705% | 8,232,231.51 | 31.9718% |
| ffSampling 재귀·복사·계측 잔여 | 550,276.00 | 4.4632% | 1,134,516.00 | 4.4062% |
| 기타 키 준비·메시지 해시·Hash-to-Point·후처리·인코딩 | 807,308.31 | 6.5479% | 1,557,433.60 | 6.0487% |
| **합계** | **12,329,300.76** | **100%** | **25,748,384.11** | **100%** |

표시 백분율은 반올림된다. sampler 비중 전체를 부동소수점으로 바꿀 수 있는 시간으로 해석하면 안 된다.
변경하지 않은 함수의 비중은 분모 감소로 상승할 수 있다. 함수 자체가 느려졌다는 의미가 아니다.

## 내부 계측 비용

| 항목 | 512 | 1024 |
|---|---:|---:|
| 내부 계측 OFF control | 11,240,376.92 | 23,557,094.38 |
| 내부 계측 ON | 12,329,300.76 | 25,748,384.11 |
| ON/OFF 차이 | +9.6876% | +9.3020% |

프로파일 wrapper·코드 배치 비용도 포함한다. 임의의 고정 비용을 빼지 않았으며, ON 시간을 OFF 분모로 나누지 않았다.
세 함수가 C 본체에서 ASM wrapper 방식으로 바뀌었으므로 이전 표와 함수별 계측 배치까지 동일하지는 않다.
최적화 성능 결론에는 [비계측 전체 서명](schedule_result.md)의 수치를 사용한다.

## 검증·조건·원자료

양 크기 출력 지문 9895079d / a020dd02 일치. 정상 서명 검증·변조 거부, 범주 합·예상 호출 수, 계측 stack 검사 통과.
fault 0, TCM=0x99, ECC 유지. CPU/SYS/HCLK 800/400/200 MHz, ITCM/DTCM 256 KiB씩, cache OFF.
GCC 15.2.1, O3, fpv5-d16, hard-float, contraction/fast-math OFF. 입력은 기존 stage-profile workload와 동일.

- candidate_sign_detail [20260928T104401Z](validation/results/candidate_sign_detail/20260928T104401Z/raw.log) / [manifest](validation/results/candidate_sign_detail/20260928T104401Z/manifest.json)
- candidate_sign_detail [20260928T104435Z](validation/results/candidate_sign_detail/20260928T104435Z/raw.log) / [manifest](validation/results/candidate_sign_detail/20260928T104435Z/manifest.json)
- candidate_sign_control [20260928T104418Z](validation/results/candidate_sign_control/20260928T104418Z/raw.log) / [manifest](validation/results/candidate_sign_control/20260928T104418Z/manifest.json)
- candidate_sign_control [20260928T104452Z](validation/results/candidate_sign_control/20260928T104452Z/raw.log) / [manifest](validation/results/candidate_sign_control/20260928T104452Z/manifest.json)

[전체 JSON](validation/schedule_summary.json)의 `final_profile`에 사이클·비중·호출 횟수가 있다.
[집계기](validation/analyze_schedule.py)와 [재현 방법](validation/README.md)을 함께 보존한다.

