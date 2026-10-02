# 키생성 FP64 FFT 구현 로그

## 2026-09-24 시작 상태

- 출발 소스: `fn-dsa_m55/ntt_opt`
- 최종 성능 기준: `fn-dsa_m55/M55_ref`
- 작업 소스의 `kgen_fxp.c`, `kgen_inner.h`, `kgen_ntru.c`, `kgen_mp31_cm55.s`, `mq_cm55.s`는 시작 시점에 `ntt_opt`와 byte-for-byte 동일했다.
- 시작 SHA-256:
  - `kgen_fxp.c`: `cf93446862da0ba3429326bddb6633595cb2b2cb310b0e8489cb1b7f9c100edd`
  - `kgen_inner.h`: `0e124f2cbfee404b9e51c1723ef21544f0849a14e5b61ffa76c32f083fa0ec11`
  - `kgen_ntru.c`: `35696b1619bbaaa14046ab85a66f384670e9f8c8d44e523a0dcf8cd402fb8abf`
  - `kgen_mp31_cm55.s`: `bad74cbe6f569a948b70f887b47cc0c5fc9f7e6130605df27adb70f3d88ece88`
  - `mq_cm55.s`: `0d1c14bed961466f649d1d818732d82ba3d1f1cf87c2ca441b37edaecf5d13f9`
- 기존 `build/`, `profiling/results/`, `result.md`는 이번 구현의 신규 결과로 간주하지 않는다.

## 구현 단계

- [x] 계획 재확인
- [x] REFERENCE 11편 전수 검토 및 적용/부적합 분류
- [x] 출발 소스 hash 고정
- [x] 원본 커널 fixture와 host oracle 고정
- [x] B1 scalar native FP64 + Q32 호환 구현
- [x] B1 host 단계별 대조
- [x] B1~B4 M55 독립 커널 정확성·timing·성능 측정
- [x] 실패한 통합 호출을 fixed 경로로 복구하고 host 전체 테스트·KAT 재검증
- [x] 실제 FP64 NTRU 파이프라인 M55 KAT·서명검증·전체 성능 측정
- [x] 후속 최적화 후보 구현·비교 및 최종 성능 후보 선택

## B1: scalar native FP64 + Q32 호환 기준 구현

- 복소수의 지속 표현은 실수부 `double` 하나와 허수부 `double` 하나다.
- 원본 Q32.32의 add/sub/wrap, 곱셈 뒤 floor, 복소수 3곱셈 순서,
  iFFT의 단계별 half를 먼저 재현했다.
- 최초 host 대조에서 FFT `logn=5`, round 83의 한 계수가 원본보다 raw
  Q32 1만큼 컸다. 원인은 실수부/허수부 사이 carry가 아니라, binary64
  곱셈의 선행 반올림이 Q32 floor 경계를 넘긴 것이었다.
- `p=x*y`, `pe=fma(x,y,-p)`의 product residual을 floor 보정에 사용했다.
  저장 표현은 여전히 성분당 double 하나다.
- host: FFT·invnorm·iFFT, `logn=2..10`, 각 100회, 총 2,700개 vector
  비교에서 raw Q32 bit-exact PASS.
- M55: 같은 2,700개 비교에서 raw Q32 bit-exact PASS.
- M55 환경: STM32N657 800 MHz, cache OFF, TCM control `0x99`, GCC
  15.2.1, `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math`.

### B1 직접 커널 사이클

입력 준비·복사·출력 검사는 타이머 밖이며, 10회 warm-up 뒤 100회 평균이다.

| 함수 | n | 원본 fixed | B1 FP64 | FP64/fixed |
|---|---:|---:|---:|---:|
| FFT | 512 | 126,033.01 | 2,430,322.01 | 19.2832배 |
| iFFT | 512 | 143,329.00 | 3,564,621.52 | 24.8716배 |
| invnorm | 512 | 464,178.51 | 569,617.01 | 1.2272배 |
| FFT | 1024 | 280,627.00 | 5,450,153.06 | 19.4214배 |
| iFFT | 1024 | 318,463.01 | 8,002,931.55 | 25.1309배 |
| invnorm | 1024 | 928,306.51 | 1,133,653.01 | 1.2212배 |

B1은 정확성 기준선이며 성능 후보로는 탈락이다. 역어셈블리에서 native
FP64/FMA 명령은 확인했지만, 매 연산의 portable floor/wrap 보정이 크게
전개됐다. 다음 후보는 동일 수치 규칙을 유지하면서 Arm `VRINTM.F64`로
floor를 직접 표현한다.

## B2: `VRINTM.F64` 직접 floor

- portable bit-field floor를 Armv8.1-M의 `VRINTM.F64` 한 명령으로 교체했다.
- host는 portable oracle을 유지하고 M55 빌드에서만 직접 명령을 사용한다.
- M55 raw Q32 대조 2,700개 PASS, fault 0.
- ELF 코드 사용량은 B1 58,544 B에서 45,800 B로 감소했다. 전체 ELF의
  수치이므로 FP64 함수만의 코드 크기로 해석하지 않는다.

| 함수 | n | 원본 fixed | B2 FP64 | FP64/fixed |
|---|---:|---:|---:|---:|
| FFT | 512 | 126,033.00 | 1,511,111.01 | 11.9898배 |
| iFFT | 512 | 143,329.00 | 2,050,154.52 | 14.3038배 |
| invnorm | 512 | 464,178.51 | 390,555.00 | **0.8414배** |
| FFT | 1024 | 280,627.01 | 3,387,369.03 | 12.0707배 |
| iFFT | 1024 | 318,463.00 | 4,600,201.52 | 14.4450배 |
| invnorm | 1024 | 928,306.52 | 780,045.00 | **0.8403배** |

`invnorm`은 이 후보에서 원본보다 15.86%/15.97% 빠르다. FFT/iFFT는 아직
채택 불가다. 다음 B3 후보는 키 생성 FFT의 명시된 범위를 전제로 실제로
발생하지 않는 add/sub/mul 출력의 signed-64 wrap을 제거한다. 범위 밖의
일반 Q32 동작과 구분하고 실제 입력·경계 입력으로 검증한다.

## B3: 키 생성 범위의 불필요한 wrap 제거

- add/sub, 곱셈 결과, half 및 정상-domain division 결과에서 signed-64
  wrap을 제거했다. NTRU의 기존 scale 선택과 후보 계수 범위로 값이
  `[-2^31,2^31)`에 남는 경로만 대상으로 한다.
- host와 M55의 raw Q32 비교 2,700개가 모두 PASS했다. 이것은 임의의
  64-bit Q32 입력 전체에 대한 동등성 증명은 아니다.

| 함수 | n | 원본 fixed | B3 FP64 | FP64/fixed |
|---|---:|---:|---:|---:|
| FFT | 512 | 126,033.00 | 665,106.01 | 5.2772배 |
| iFFT | 512 | 143,329.00 | 903,113.50 | 6.3010배 |
| invnorm | 512 | 464,178.50 | 240,322.00 | **0.5177배** |
| FFT | 1024 | 280,627.01 | 1,488,437.01 | 5.3040배 |
| iFFT | 1024 | 318,463.02 | 2,023,915.50 | 6.3553배 |
| invnorm | 1024 | 928,306.52 | 479,626.00 | **0.5167배** |

`invnorm`은 원본보다 약 1.93배 빠르다. 실제 ELF의 FFT 곱셈에는 여전히
FMA residual 보정당 FP64 scale 곱셈과 coefficient 의존 비교/분기가 있었다.
다음 B4는 twiddle을 raw-Q32 double로 한 번만 준비해 scale 곱을 줄이고,
residual 보정을 두 번째 `VRINTM.F64`로 표현해 그 분기를 제거한다.

## B4: raw-Q32 twiddle + branchless residual correction

- twiddle을 그룹당 한 번 signed raw-Q32 double로 변환했다. 데이터와의
  곱은 곧바로 출력 raw 단위가 되므로 scale 곱셈 두 개를 없앴다.
- `floor(p) + floor((p-floor(p))+error)`로 FMA residual 보정을 표현해
  coefficient 의존 비교/분기를 제거했다.
- host와 M55 raw Q32 비교 2,700개 PASS, fault 0.

| 함수 | n | 원본 fixed | B4 FP64 | FP64/fixed |
|---|---:|---:|---:|---:|
| FFT | 512 | 126,033.01 | 511,454.00 | 4.0581배 |
| iFFT | 512 | 143,329.01 | 749,979.50 | 5.2326배 |
| invnorm | 512 | 464,178.50 | 210,476.00 | **0.4534배** |
| FFT | 1024 | 280,627.01 | 1,143,280.01 | 4.0740배 |
| iFFT | 1024 | 318,463.00 | 1,680,054.52 | 5.2755배 |
| invnorm | 1024 | 928,306.51 | 420,524.00 | **0.4530배** |

다음 B5는 FMA residual을 제거한 단일 `VMUL+VRINTM` 곱셈 후보다. 이 후보는
알려진 Q32 floor 경계에서 1 LSB 차이가 가능하므로 raw 불일치 수, 실제 KAT,
최종 k와 후보 재시도 흐름을 별도로 검사하며, 단순 커널 속도만으로 채택하지 않는다.

## B5: residual 제거 후보 — 탈락

- `VMUL.F64`의 반올림 결과를 곧바로 `VRINTM.F64`에 넣었다.
- M55의 2,700 vector 대조에서 **7,197 coefficient mismatch**가 발생했다.
  최초 보드 차이는 FFT `logn=4`, round 36이며 차이는 ±1 raw Q32였다.
- n=512에서 FFT 294,181.01, iFFT 529,674.00 cycles, n=1024에서
  FFT 654,647.00, iFFT 1,184,545.01 cycles로 B4보다 빨랐지만 정확성
  조건을 만족하지 않는다. KAT의 우연한 일치만을 근거로 채택하지 않는다.
- 소스는 B4의 FMA residual + 두 번째 VRINTM 보정으로 복원했다.

## B6: Q32 연산 경계를 유지한 2-layer 병합 — 탈락

- forward는 연속 두 레이어의 네 coefficient를 레지스터에서 결합하고,
  inverse도 대칭 구조로 두 레이어의 중간 저장·재로드를 제거했다.
- `fp64q_mul_scaled_rhs()`, add/sub, iFFT 단계별 half의 호출 횟수와 각
  dependency chain의 순서는 B4와 동일하게 유지했다.
- host와 M55에서 FFT·iFFT 병합 후보를 추가해 logn 2..10, 각 100회,
  총 **4,500 vector** 비교를 수행했고 mismatch 0, fault 0이었다.
- 실제 M55에서는 감소한 메모리 접근보다 늘어난 live register와 명령
  스케줄 부담이 더 컸다. B4 대비 유의한 개선이 없어 채택하지 않는다.

| 함수 | n | B4 FP64 | 2-layer | B4 대비 |
|---|---:|---:|---:|---:|
| FFT | 512 | 511,228.93 | 511,727.34 | **0.0975% 느림** |
| iFFT | 512 | 749,801.12 | 750,155.00 | **0.0472% 느림** |
| FFT | 1024 | 1,143,054.94 | 1,143,555.34 | **0.0438% 느림** |
| iFFT | 1024 | 1,679,870.84 | 1,680,038.02 | **0.0100% 느림** |

측정 조건은 STM32N657 800 MHz, cache OFF, TCM control `0x99`, GCC
15.2.1, `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math`, 각 100회다.
측정 순서는 fixed/B4/fused2를 3회 주기로 회전했다. 측정 ELF 사용량은
50,024 B였으며 B4 기록의 전체 ELF 45,800 B보다 컸다(두 수치는 각
후보가 포함된 전체 검증 ELF이므로 함수 하나의 크기는 아니다).

## B4 실제 키 생성 연결 시도 — 경계 설계 탈락

- 공개 `vect_FFT()`, `vect_iFFT()`, `vect_invnorm_fft()`를 double
  인터페이스로 만들고 NTRU ④·⑤ 및 후보 검사에 연결했다.
- 계획대로 범위 밖 점별 연산은 fixed로 유지하고, 그 앞뒤에만 명시적인
  `fxr <-> double` 숫자 변환을 넣었다.
- 후보 직교노름 전체 경로는 host 3,000회에서 fixed와 판정이 모두 같았다.
- 반면 통합 keygen은 5분 동안 첫 KAT 키를 만들지 못해 중단했다. 보드 fault는
  없었고, host도 첫 self-key에서 같은 현상을 재현했다.
- 원인은 NTRU 중간 단계의 반복 경계다. 실제 중간 Q32 값에는 raw 정수가
  binary64의 exact-integer window를 넘는 경우가 있다. FP64 FFT 출력과 fixed
  점별 곱 사이에서 표현을 왕복하면 하위 비트를 복원할 수 없고 solver가
  반복 실패한다. 이는 변환 함수의 real/imag carry 누락 문제가 아니다.
- 작업 소스의 실제 keygen 호출은 KAT 가능한 fixed 심볼로 복원했다. FP64
  공개 인터페이스·커널·독립 검증기는 유지한다.

계획의 “나머지 점별 함수를 fixed로 유지” 조건으로는 NTRU ④ 전체를 연결할
수 없다. 다음 통합 후보는 `vect_mul_fft()`와 `vect_inv_mul2e_fft()` 등 인접
구간도 double 상태로 유지하는 지원 FP64 함수가 필요하다. 이는 다섯 성능
타깃을 늘린다는 뜻은 아니지만, 현재 계획의 변경 제외 범위를 수정하는 결정이다.

## 통합 실패 후 복구 검증

- 실제 키 생성 호출은 `vect_FFT_fixed()`, `vect_iFFT_fixed()`,
  `vect_invnorm_fft_fixed()`로 복구했다. 따라서 이 검증은 FP64 통합 KAT가
  아니라, 작업 소스가 정상 기준 동작을 잃지 않았다는 회귀 검사다.
- macOS host `clang -O2`로 전체 소스를 강제 재빌드했다.
- `test_fndsa`의 SHAKE/SHA-3, codec, mod-q, fpoly, sampler, keygen self,
  keygen reference, verify, self-test 및 logn 2..10 KAT가 모두 PASS했다.
- FP64 독립 커널은 별도 M55 검사에서 FFT·iFFT·invnorm, logn 2..10,
  함수별 100회(총 2,700 vector) raw Q32 bit-exact PASS 상태를 유지한다.

## FP64 구간 확장으로 통합 실패 해결

위의 “복구” 상태는 최종 상태가 아니다. fixed 점별 함수 앞뒤의 반복 변환이
실패 원인이었으므로, 성능 타깃 다섯 함수 사이의 점별 곱·나눗셈·켤레·상수곱과
입력 변환을 FP64 지원 함수로 구현해 NTRU spectral interval 전체에서 `double`
표현을 유지했다. 정확한 정수 갱신·NTT/RNS·CRT·Bezout은 그대로 유지했다.

- 수정: `kgen_fxp.c`, `kgen_inner.h`, `kgen_ntru.c`, `kgen_poly.c`
- persistent 표현: 실수부 `double` 하나 + 허수부 `double` 하나
- host 전체 시험과 keygen KAT가 다시 정상 종료했다.
- 이 범위 확대는 새 성능 타깃 추가가 아니라 다섯 타깃의 올바른 연결을 위한
  지원 경로다.

## native FP64 최종 산술 후보

exact-Q32 보정을 모든 butterfly에 적용한 후보는 정확하지만 느렸다. 이후
FFT/iFFT는 native FP64 산술을 사용하고 KAT에 필요한 보정은 점별 연산과 최종
정수 경계에만 남겼다.

1. twiddle 복소 곱을 세 곱 방식에서 네 독립 곱으로 바꿔 dependency chain을
   줄였다.
2. Cortex-M55에서 실수부에 `VFMS.F64`, 허수부에 `VFMA.F64`를 직접 inline
   assembly로 작성했다.
3. FFT/iFFT 두 레이어 병합으로 중간 coefficient를 레지스터에 유지했다.
4. `vect_invnorm_fft()`의 실제 `e == 0` 경로를 native 제곱 네 번과 정규화
   reciprocal로 특수화했다. 이 결과는 102,200개 비교 계수에서 fixed Q32와
   bit-exact했다.

SLOTHY도 확인했으나 로컬 Armv8.1-M 모델에 scalar D-register FP64 명령 모델이
없어 적용하지 않았다. 이는 미시도가 아니라 모델 부적합 판정이다.

## 최종 검증 결과

- host `test_fndsa`: 전체 PASS
- M55 keygen KAT: 300/300 일치, NTRU equation PASS
- M55 sign KAT/verify/tamper: 90/90 PASS
- 전체 키생성 upper median, 100 calls/degree:
  - n=512: 47,211,176 cycles (`M55_ref`보다 2.191% 감소)
  - n=1024: 215,451,315 cycles (`M55_ref`보다 2.257% 감소)
- 직접 커널:
  - FFT/iFFT는 fixed보다 각각 약 44%/86% 느림.
  - invnorm은 n=512에서 7.2327배, n=1024에서 7.2423배 빠름.
- API 성능 ELF: FLASH 89,512 B, RAM 164,136 B.

정확한 표·오차·메모리·해시는 `result.md`에 기록했다.

## 상수시간 판정

다섯 핵심 커널의 역어셈블리에는 비밀 계수값에 따른 branch가 없고 native FP64
명령이 실제로 생성됐다. 일반 FP64 나눗셈 지원 경로에는 컴파일러가 만든
zero/exception 조건분기가 남는다. 또한 고정소수점 대조군과 같은 하네스에서
입력군별 시간을 측정했을 때 FP64 FFT/iFFT/invnorm 평균에 각각 약
53.5/30.5/107 cycles의 차이가 관측됐다. fixed 대조군은 동일 평균이었다.
따라서 최종 코드는 KAT와 성능 기준은 통과했지만 constant-time 배포 구현으로
승인하지 않는다.
