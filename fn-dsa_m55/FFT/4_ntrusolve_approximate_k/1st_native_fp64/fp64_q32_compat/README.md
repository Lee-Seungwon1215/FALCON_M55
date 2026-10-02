# FP64-assisted exact Q32.32 FFT — 성능 미채택 실험

**결론: KAT 호환은 확보했지만 성능이 나빠 채택하지 않는다.**
결과와 원시 로그는 [result.md](result.md)에 있다.

이 폴더는 전체 native double FFT가 아니다. 기존 fixed Q32.32 산술의 정확한 비트
의미를 유지하면서 곱셈에 하드웨어 FP64를 사용하는 **별도의 혼합 실험**이다.
원래 `1st_native_fp64`, `hybrid_fixed_div`, 공통 ref와 2nd~5th 폴더는 보존했다.

## 무엇을 시험했나

남은 두 KAT 차이는 마지막 반올림만의 문제가 아니었다.
[primitive 추적](../validation/compatibility_repair/README.md)에서 중간 곱셈의
Q32.32 절삭, 범위 wrap, 3곱셈/4곱셈 그래프 차이를 확인했다.

이 후보는 단일 double에 64-bit raw word를 저장하지 않는다. 배열은 `fxr`로 유지한다.
32-bit limb를 정확히 double로 바꾸고, 그 곱셈의 high word를 계산할 때 FP64를 사용한다.
반올림 때문에 high word가 1 커지는 경우를 exact low word로 판별·보정한다.
그 뒤 캐리/부호/32-bit 절삭/64-bit wrap은 원본과 같게 정수 연산한다.

FP64 product `P=RN(x*y)`에서 `x,y`는 unsigned 32-bit 정수다.
`P`의 최대 절대 반올림 오차는 1024이고 모든 `2^32` 배수는 정확히 표현된다.
따라서 `floor(P/2^32)`는 정확한 high word이거나 1 큰 값이다.
`P`가 `2^32` 배수이고 실제 low word의 상위 비트가 1일 때만 1을 빼면 된다.
이를 세 부분곱에 적용하면 원본 signed Q32.32 곱셈을 재현할 수 있다.

보정 횟수는 고정이고 seed 특례, 입력 기반 backend 선택, 예외 fallback은 없다.
원본의 3-product complex multiply와 매 primitive 절삭 순서를 유지한다.

## 변경 파일

기준은 `../../ref`. 독립 전체 소스 복사본이며 다른 후보의 암호 소스를 링크하지 않는다.

| 파일 | 변경 |
|---|---|
| `kgen_fxp.c` | `fp64q_mul_hi32`, `fp64q_mul`, `fp64q_cmul`, `vect_FFT_fp64q`, `vect_iFFT_fp64q`, `vect_mul_fft_fp64q` 추가 |
| `kgen_inner.h` | 새 vector 함수 3개 선언 |
| `kgen_ntru.c` | `solve_NTRU_intermediate` 안의 FFT 호출 2개, 곱셈/iFFT 호출 각각 1개 교체 |

`kgen_poly.c`, 입력 변환, 반올림, 역수 나눗셈, depth0, 후보 검사, 서명/검증은 원본이다.
이전에 만든 `hybrid_fixed_div`의 빠른 divider를 합치지 않아 FFT 변경의 비용만 비교한다.
기존 어셈블리는 그대로이며 이번 암호 변경은 C로 직접 구현했다.

## 재현

```sh
python3 -B validation/host.py
bash validation/build.sh compat-perf
python3 -B validation/run_board.py compat-perf
```

label: `ref-perf`, `compat-perf`, `ref-profile`, `compat-profile`, `kernels`, `kat`.
여섯 실행 후 `python3 -B validation/static_audit.py` 및
`python3 -B validation/analyze.py`로 검토한다.

호스트의 두 targeted replay에는 상위 `validation/compatibility_repair/trace.py`로
생성한 raw 입력 두 파일을 사용한다. 이는 검증용 데이터 의존성이지 다른 후보의
암호 소스를 빌드해 가져오는 방식이 아니다.
보드 시작/링커 환경은 기존 공통 `measurement_mlkem_native`를 재사용한다.
