# KAT 유지형 FP64 곱셈: 직접 작성한 inline assembly 실험

비교 기준은 형제 폴더 `../fp64_kat_exact`의 two-double FP64 C 구현이다.
암호 구현은 이 폴더에 독립적으로 복사했다. 변경한 암호 함수는
`kgen_fxp.c`의 `fp64e_mul()` 하나이며, FFT 반복문·자료형·나눗셈·NTRU
호출 흐름은 그대로다. 다른 후보의 구현을 링크해 대신 실행하지 않는다.

`inline assembly`는 C 함수 안에 명령을 작성했다는 뜻이다. 함수 호출을
없애는 compiler inlining과 다르며, 여기서는 기존 out-of-line 곱셈 호출을
유지한다. Arm hardware FP64 전용 후보이고, host C fallback은 없다.

- 산술 및 레지스터 설계: [design.md](design.md)
- 실제 보드 결과와 한계: [result.md](result.md)
- 검증 프로그램: [validation](validation/)

## 재현

프로젝트 최상위에서 다음과 같이 실행한다. 연결된 ST-LINK
`003C00223335510735383531`만 사용하며 보드 실행은 반드시 순차로 한다.

```sh
bash fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/build.sh asm-perf
python3 -B fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_kat_exact_inlineasm/validation/run_board.py asm-perf
```

가능한 label은 `ref-perf`, `c-perf`, `asm-perf`, `ref-profile`,
`c-profile`, `asm-profile`, `kernels`, `kat`이다. 각 label을 빌드한 다음
동일 label로 실행한다. 모든 실행 후 `validation/static_audit.py`와
`validation/analyze.py`를 실행하면 감사 자료와 집계가 생성된다.

검증 harness만 비교 대상으로 `../../ref`(고정소수점),
`../fp64_kat_exact`(FP64 C), 현재 폴더(FP64 ASM)를 구분한다.
커널 비교용 C oracle도 기준 C 소스에서 생성하는 **시험 전용** 코드다.
`asm-perf`/`asm-profile`/`kat` 암호 구현에는 이 oracle을 포함하지 않는다.

소스와 ELF hash를 실행 전후 검사하며 `validation/results/`에 원문과
manifest를 보존한다. 기존 통합 `ntt_opt`/`ntt_opt_slothy`는 수정하지 않는다.
