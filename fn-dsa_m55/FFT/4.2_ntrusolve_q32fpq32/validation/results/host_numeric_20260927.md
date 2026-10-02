# B 호스트 수치 검사 실행 기록

2026-09-27 실행. 암호 소스 변경 없이 호스트용 검사 프로그램만 컴파일했다.
다음 결과는 M55 성능이나 상수시간 측정이 아니다.

## 실행 명령

```sh
cc -std=c11 -O3 -ffp-contract=off -fno-fast-math fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/validation/host_ds_math.c -lm -o /private/tmp/fndsa_b_host_ds_math
/private/tmp/fndsa_b_host_ds_math
cc -std=c11 -O3 -ffp-contract=off -fno-fast-math -DFNDSA_AVX2=0 -DFNDSA_ASM_CORTEXM4=0 -I fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32 fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/validation/host_q32_fixture.c fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/kgen_fxp.c -lm -o /private/tmp/fndsa_b_q32_fixture
/private/tmp/fndsa_b_q32_fixture
```

## 출력

```text
HOST_DS_RECIP count=61000 excessive_error=0 invalid_accepted=0 max_relative=1.1732703282982445e-14
HOST_Q32_DEN case=8 name=1024-test7 index=2 re_raw=fffffffffffdccb8 im_raw=fffffffffffdbcd2 original_den_raw=0000000000000009 exact_den=2.31898012619836946e-09 denominator_ratio=0.903619556378024824
HOST_Q32_PRODUCT case=8 outside_signed_q32=0 max_unwrapped_abs=798.009002488348415 index=17 wrapped_ref_raw=0000031e024dfcb2
HOST_Q32_DEN case=11 name=1024-test74 index=5 re_raw=00000000000014ea im_raw=000000000002c922 original_den_raw=0000000000000007 exact_den=1.80831636340320068e-09 denominator_ratio=0.901288368872480983
HOST_Q32_PRODUCT case=11 outside_signed_q32=0 max_unwrapped_abs=146.798824446541914 index=5 wrapped_ref_raw=ffffff6d33803db7
HOST_Q32_DEN case=14 name=1024-test79 index=3 re_raw=0000000000002608 im_raw=0000000000009135 original_den_raw=0000000000000000 exact_den=8.00478186882037923e-11 denominator_ratio=0
HOST_Q32_PRODUCT case=14 outside_signed_q32=0 max_unwrapped_abs=419.461717890524824 index=9 wrapped_ref_raw=000001a3763324c8
HOST_Q32_DEN case=15 name=1024-test80 index=5 re_raw=0000000000019efe im_raw=0000000000027d00 original_den_raw=0000000000000008 exact_den=2.0534241531536962e-09 denominator_ratio=0.907092256789842288
HOST_Q32_PRODUCT case=15 outside_signed_q32=0 max_unwrapped_abs=374.907886931040082 index=9 wrapped_ref_raw=00000176e86b4725
HOST_Q32_DEN case=22 name=512-test78 index=0 re_raw=000000000000c27f im_raw=00000000000b3e69 original_den_raw=000000000000007e exact_den=2.95694979900217383e-08 denominator_ratio=0.992125774684685657
HOST_Q32_PRODUCT case=22 outside_signed_q32=0 max_unwrapped_abs=77.2565397989182259 index=0 wrapped_ref_raw=ffffffb2be536862
HOST_Q32_DEN case=27 name=residual-512-test58 index=31 re_raw=ffffffff24644d6d im_raw=ffffffffc6a8915c original_den_raw=00000000c93bcf5a exact_den=0.78606887782358148 denominator_ratio=0.999999999805783468
HOST_Q32_PRODUCT case=27 outside_signed_q32=2 max_unwrapped_abs=7973648507.50702095 index=63 wrapped_ref_raw=24bbc7847e33eb7a
```

두 프로그램 종료 상태는0. DS 역수 검사는 정상 exp-30..30 및 비정상6개 사례다.
원본 Q32 진단의 long double은 이 호스트에서 binary64 정밀도일 수 있다.
표에 표시한 분모 약10% 차이 및 약8e9 wrap의 구분에는 충분하지만, 이 소수
표기들을 임의정밀도 수학 증명이나 모든 원본 raw 연산의 재현으로 해석하지 않는다.

## 입력·소스 SHA-256

```text
c0804f67d7b70bc74a55494624eeb8da7bc39d2dca05ff82aff6807765277bf3  fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/validation/host_ds_math.c
62a92385c71b8421f4bd55edc27c4ab5e667c8a9701edc64065f4a94559535a1  fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/validation/host_q32_fixture.c
70d936136a67c4eb617c9e5cc6db9f7afbf7e8300df7fd63d28bf586af81cbf7  fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/validation/frozen_cases.inc
b5906d2910d6b830027fc85cf9e929702f1eda1a5d89ca7bf7623f940022f603  fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/kgen_fft_mve.c
1e82d9e60b6bb5a19b45c64cb3dbc8f2d3532a3089b2f383a8c3f57ba208ad27  fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/kgen_fxp.c
```
