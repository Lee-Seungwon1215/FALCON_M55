# 6_sign_fft — 서명 FP64 수동 ASM

이 폴더는 서명의 `fpoly_FFT()`, `fpoly_iFFT()`, `fpoly_LDL_fft()`,
`fpoly_split_fft()`, `fpoly_merge_fft()`를 native FP64로 계산한다.
공통 q-NTT, RNS NTT K4C, 키생성 FFT A17은 유지한다.
**SLOTHY는 적용하지 않았으며 Final_code/Before_slothy에는 이번 변경을 반영하지 않았다.**

## 구현

- [sign_fft_cm55.s](sign_fft_cm55.s): 이전에 채택한 FFT/iFFT 수동 ASM을 그대로 유지.
- [sign_ldl_cm55.s](sign_ldl_cm55.s): LDL L5b. 독립 계산 배치, post-increment 입출력,
  비융합 VMLA 사용. 기존의 개별 곱셈·덧셈 반올림 순서를 유지한다.
- [sign_split_merge_cm55.s](sign_split_merge_cm55.s): split/merge S6.
  split은 단일 위치 처리와 원본의 signed-zero 호환 ½배 비트 보정,
  merge는 n≥128에서 두 위치 묶음. n=2/n=4 전용 경로와 4-byte 루프 정렬을 포함한다.
- [sign_fpoly.c](sign_fpoly.c): 위 다섯 함수의 본체는 ASM으로 이동했다.
  기존 회전상수 `fndsa_sign_gm` 및 나머지 함수는 유지한다.
- [Makefile](Makefile): 새 ASM을 정상적인 소스 목록에 등록한다.
  다른 후보 소스 링크나 배포용 구현 선택 옵션은 없다.

실수부와 허수부는 각각 binary64 하나다. `fpr (= uint64_t)` 배열의
binary64 비트를 FP 레지스터로 직접 읽으며 Q32/정수 수치 변환 배열을 만들지 않는다.
FP64는 스칼라 연산이다. 두 위치를 묶은 merge도 FP64 SIMD는 아니다.
공통 `fpr_*`, `split_selfadj`, 점별 연산, sampler/deepest는 변경하지 않았다.
따라서 `sign_fpr_cm4.s` 등 기존 에뮬레이션 코드는 여전히 필요하다.

## 빌드

```sh
make CROSS_COMPILE=/path/to/arm-none-eabi-
```

GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard`,
`-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
배열 정렬/API 계약과 round-to-nearest/ties-to-even 환경을 유지한다.
원본 fpr 입력 영역의 normal/zero를 대상으로 하며 NaN/Inf/subnormal 동등성은 주장하지 않는다.

## 결과·이력

- [현재 LDL·split·merge 결과](schedule_result.md)
- [구현 계획](plan.md), [검증 방법](validation/README.md)
- [직전 native C LDL 결과](ldl_result.md), [이전 FFT/iFFT 결과](result.md)
- [최적화 전 관찰용 연산비중](sign_profile_result.md): 이번 요청에 따라 그대로 보존.
- [최종 상태 연산비중](schedule_profile_result.md): 별도 기록.

`validation/`은 라이브러리에 포함되지 않는다. 원본·native C 비교군과 후보 선택은 시험에만 있다.
이번 작업 직전 소스는 `validation/pre_schedule_sources.tar.gz`,
이전 FFT C 소스는 `validation/native_c_baseline.tar.gz`에 보존했다.
탈락 후보도 각 측정 디렉터리의 `production_sources.tar.gz`에 남아 있다.
[후보 목록](validation/schedule_candidates.json)으로 해당 로그·소스를 찾을 수 있다.
원본 [LICENSE](LICENSE)를 유지한다.
