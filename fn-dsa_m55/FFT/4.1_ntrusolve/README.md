# Q32 경계를 유지하는 선택적 FFT/iFFT·invnorm 실험

출발 코드: `fn-dsa_m55/ntt_opt`. 원본 `ntt_opt`, `M55_ref`는 변경하지 않았다.
이 경로의 소스는 다른 후보를 링크하거나 include하지 않는 독립 구현이다.

## 현재 선택

| 대상 | 구현 |
| --- | --- |
| forward FFT | 원본 고정소수점 유지. Q32 경계 MVE 후보는 단독 비교용으로 구현했으나 아직 원본보다 느려 기본 경로에서 제외 |
| iFFT, logn < 9 | 원본 고정소수점 유지 |
| iFFT, logn = 9,10 | Q32 → 2×FP32 MVE → Q32 |
| invnorm, e=0 | 원본 Q32 제곱합 + native FP64 역수/나눗셈 + Q32 반환 |
| invnorm, e≠0 | 원본 고정소수점 |
| 주변 곱셈·나눗셈·입력 변환·k 반올림 | 원본 고정소수점 유지 |
| NTT·CRT·Bezout·정수 갱신·서명 코드 | ntt_opt와 동일 |

`vect_FFT()`·`vect_iFFT()`·`vect_invnorm_fft()`의 기존 `fxr` 인터페이스를 유지한다.
double 배열을 NTRU solver에 도입하지 않았다. `_fp64` 공개 별칭을 불필요하게
추가하지 않았다. 2×FP32는 실수값 하나당 float 두 개이며 복소수당 네 개다.

## 소스

- `kgen_fxp.c`: 기존 입출력을 유지하는 경로 선택, FP64 invnorm. 실측으로
  forward MVE를 제외했다. 느린 후보를 정상 구현인 것처럼 활성화하지 않는다.
- `kgen_inner.h`: private M55 entry 선언만 추가. `fxr`, `fxc`, 기존 산술 helper 유지.
- `kgen_fft_mve.c`: Q32 직접 입출력 변환, DS FFT 제어, 사전 변환 root 상수표.
  변환에는 MVE intrinsics, 계산 butterfly에는 직접 작성된 어셈블리를 사용한다.
- `kgen_fft_cm55.s`: 채택한 DS MVE span 및 packed-tail 어셈블리의 로컬 이식본.
  기존 실험의 triple-float 계산 경로는 가져오지 않았다.

FFT 산술과 상수의 출처는
`function_compare/twfalcon/integration_candidate` stage 11이다. 상수의 세 번째
float는 12-byte assembly root stride를 보존하는 0 패딩이며 산술은 2×FP32다.
이식하면서 작업 배열은 실제 두 성분으로 줄였다. 변환용 임시 double 배열은 없다.

## 검증 및 주의

새 측정은 `validation/`에서만 실행한다. 방법은 [validation/README.md](validation/README.md),
결과는 [result.md](result.md)를 참조한다. `build/`, 기존 `profiling/`는 복사된
이전 도구/산출물이며 이 실험의 결과가 아니다. 기존 README·결과 문서들은
`validation/legacy/`에 내용 그대로 보관했다(상대 링크는 과거 경로 기준).

MVE FFT/iFFT의 모든 중간값이 원본 Q32와 bit-exact한 것은 아니다. KAT 통과는
시험한 입력에 대한 결과이며 모든 입력의 동등성이나 전체 상수시간의 증명이 아니다.
고정소수점 경계 도입 후의 성능은 과거 double 경계의 개선율과 구분해야 한다.
메모리 사용량은 시험 펌웨어 기준이며 별도의 엄격한 최악 스택 사용 증명은 아니다.

원 저작권·라이선스는 [LICENSE](LICENSE)에 보존되어 있다.
