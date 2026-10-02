# KAT 보존 FP64 계산량 감소: R1 → R2 → R3

최종 후보는 이 폴더의 독립적인 암호 소스다. 변경 암호 파일은
`kgen_fxp.c` 하나다. 기존 `fp64_kat_exact`,
`fp64_kat_exact_inlineasm` 및 통합 NTT ref는 수정하지 않는다.

| 후보 | 독립 소스 폴더 | 누적 변경 |
|---|---|---|
| R1 | `../fp64_radix24` | 24+24+16 분할, 계수 부분곱 15→8 |
| R2 | `../fp64_radix24_twiddle` | R1 + FFT/iFFT 회전상수 분해 재사용 |
| R3 | 현재 폴더 | R2 + 내부 실수 곱셈 호출 제거 및 compiler register allocation |

R1/R2는 곱셈 API를 out-of-line으로 유지한다. R3는 private
`always_inline` body를 FFT/점별 곱/역수 준비에 직접 사용한다.
실제 GCC ELF에서는 큰 복소수 helper 호출 1회가 남고 그 안의 실수 곱셈
3회 호출이 사라진다. 모든 함수 호출을 0회로 만들었다는 뜻은 아니다.
독립 곱셈 API는 시험용으로 남아 있으며, 실제 production에서 미사용이면
링커가 제거한다. 어떤 후보도 build flag로 다른 산술 backend를 고르거나
다른 후보의 구현을 링크하지 않는다.

8개 계수 부분곱은 직접 작성한 FP64 inline assembly의 4개 VMUL와
4개 비융합 VMLA다. 분해·carry·정규화는 C의 double 산술이며 실제 ELF에서
hardware FP64/변환 명령 여부를 검사한다. 함수 전체가 손으로 쓴
어셈블리라는 뜻은 아니다. no-fast-math와 contraction OFF를 유지한다.

일반적인 single-double 실수 FFT로 바꾼 것이 아니라 two-double에
원본 raw 워드를 저장하는 KAT 호환 구현의 계산량을 줄이는 실험이다.
signed correction, 각 연산의 절삭/wrap, 3-product 복소수 곱셈,
iFFT의 단계별 half는 유지한다.

- [설계·정확성 근거](design.md)
- [비교 결과와 로그](result.md)
- [공통 보드 검증 harness](validation/)

## 재현

프로젝트 최상위에서:

```sh
bash fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/build.sh r1-kernels
python3 -B fn-dsa_m55/FFT/4_ntrusolve_approximate_k/1st_native_fp64/fp64_radix24_inline/validation/run_board.py r1-kernels
```

R1 label: `r1-kernels`, `r1-kat`, `r1-perf`.
R2 label: `r2-kernels`, `r2-kat`, `r2-perf`.
R3 label: `kernels`, `kat`, `asm-perf`, `asm-profile`.
기준 label: `ref-perf`(원본 fixed), `c-perf`(기존 exact FP64 C),
`old-perf`(이전 16-bit inline assembly).

각 label은 해당 폴더 소스를 직접 컴파일하는 비교 harness 선택일 뿐이다.
`kernels`에서만 기존 C oracle을 함께 넣어 비교한다. 실제 키 생성/KAT
펌웨어는 선택한 독립 소스만 실행한다.

보드는 ST-LINK `003C00223335510735383531`만 순차 사용한다.
기존 N657 측정 환경: 800 MHz, cache OFF, 코드 ITCM, 상수/데이터/스택
DTCM, GCC 15.2.1, -O3, -mfpu=fpv5-d16, 기존 M4/M55/MVE NTT ON.
소스/ELF/계측본 hash를 실행 전후 검사한다.

`validation/model.py`는 독립 산술 모델이며 host에서 Arm ASM을 실행하거나
sanitizer로 검증한 결과로 취급하지 않는다.
