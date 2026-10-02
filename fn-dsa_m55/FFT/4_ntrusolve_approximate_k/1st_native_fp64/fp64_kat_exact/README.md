# KAT-compatible two-double FFT experiment

목표: step ④ `solve_NTRU_intermediate()`의 FFT/iFFT를 하드웨어 FP64로 계산하면서 원본 Q32.32 결과와 KAT를 보존한다.

**구현의 정확한 분류:** 두 double에 원본 raw 상·하위 32비트를 정확하게 담고, FP64 덧셈·뺄셈·부분곱으로 Q32.32 산술을 재현한다. 일반적인 “계수당 double 하나 + 무보정 IEEE 실수 FFT”도, double-double 고정밀 실수 FFT도 아니다. 하드웨어 연산은 native FP64이고 수치 의미는 원본 fixed-point 호환이다.

- FFT 배열과 butterfly 연산은 이 후보의 `fp64_exact`/FP64 코드다. 원본 FFT를 호출하는 fallback은 없다.
- 비트 추출·캐리 추출용 정수 변환과 역수 준비의 정확한 정수 보정은 남긴다.
- `kgen_inner.h`, `kgen_fxp.c`, `kgen_poly.c`, `kgen_ntru.c`만 암호 코드 변경.
- 원본 3-product 복소수 곱셈, primitive마다의 절삭/wrap, iFFT 단계별 half/round를 보존.
- final-scaling, 4-product 변경은 이 후보에 적용하지 않았다.
- ⑤ depth0, 후보 검사, NTT/CRT/Bezout, 서명·검증은 그대로다.
- 이 폴더는 `4_ntrusolve_approximate_k/ref`에서 복사한 독립 소스다. 다른 후보의 암호 소스를 include/link/빌드 옵션으로 선택하지 않는다.
- 이전 모든 후보와 통합 ref는 보존한다. 이 후보를 자동 채택하지 않는다.

자료: [산술 설계](design.md), [실제 측정 결과](result.md).

## 재현

```sh
python3 -B validation/host.py
bash validation/build.sh kernels
python3 -B validation/run_board.py kernels
```

보드 label: `kernels`, `kat`, `ref-perf`, `compat-perf`, `ref-profile`, `compat-profile`.
여기서 `compat-*`는 **이 폴더의 two-double 후보**를 뜻한다. 이전 `fp64_q32_compat` 소스를 가져오는 설정이 아니다.
각 label을 build 후 run한다. 지정 ST-LINK 한 대만 순차 사용한다.

검증 코드에는 원본 산술/테스트 벡터가 비교 oracle로 들어간다. 이는 실제 암호 구현의 fallback 또는 이중계산 경로가 아니다. `validation/generate.py`는 프로파일용 NTRU 계측과 원본 KAT 상수 추출만 수행한다.

새로운 FP 임시 배열 때문에 `solve_NTRU_intermediate()`에 16 KiB 로컬 스택 배열을 추가했다. 기존 keygen tmp API와 정수 arena offsets는 유지한다. MCU 스택 설정 및 실측 watermark/컴파일러 stack-usage는 결과에서 확인해야 한다.
