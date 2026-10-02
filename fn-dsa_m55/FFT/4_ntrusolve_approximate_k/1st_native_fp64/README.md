# 1st_native_fp64 — NTRU ④ 근사 k 계산의 기본 FP64 실험

## 2026-09-23 후속 실험

아래 본문은 이 폴더 루트의 초기 native-double 실험에 대한 기록이다.
원본 KAT를 보존하는 후속 FP64 후보는 별도 하위 폴더에 구현했다.
FMA 변경·정확 곱셈 재설계·레이어 병합/SLOTHY의 최신 비교는
[fp64_fma_stages_result.md](fp64_fma_stages_result.md)에 있다.
F2 `fp64_two_prod`가 이번 FP64 후보 중 가장 빠르지만, 기존 고정소수점보다
느려 통합 reference는 교체하지 않았다. 이 폴더 루트의 초기 코드는 그대로다.

## 초기 native-double 실험 기록

상태: **후속 수정 후보. 기존 KAT 불일치로 채택하지 않음.**
나눗셈의 발견된 시간차는 20개 입력 종류에서 제거됐고 반복 구간은 초기 FP64보다
5.57~8.40% 개선됐지만, 여전히 고정소수점보다 느리다. 전체 상수시간 인증은 아니다.
최신 판단과 측정값은 [repair_result.md](repair_result.md), 첫 결과는 [result.md](result.md)에 있다.

## 변경 범위

기준 코드는 [../ref](../ref)이며, 이번 실험 직전 `fn-dsa_m55/ntt_opt`의
고정소수점 구현이다. NTT 최적화 이전의 태초 reference와는 다르다.

`solve_NTRU_intermediate()`의 다음 계산만 scalar `double` C로 변경했다.

`정수의 기존 Q32.32 입력 창 → double → FFT → 복소 곱셈/나눗셈 → iFFT → 정수 k`

| 파일 | 추가·변경 사항 |
|---|---|
| `kgen_inner.h` | FP64 복소 곱셈, 정상 가수 division helper, 반올림·범위 검사, 함수 선언 |
| `kgen_poly.c` | 기존 입력 창과 일정한 limb 순회를 유지한 `poly_big_to_fp64()` |
| `kgen_fxp.c` | FP64 FFT/iFFT·점별 곱셈·역수 준비, 동일한 양자화 root 상수표 |
| `kgen_ntru.c` | non-AVX2 intermediate 경로의 근사 계산 호출만 변경 |

NTT/RNS·CRT·Bezout, 정확한 정수 해 갱신, ⑤ `solve_NTRU_depth0()`,
키 후보 노름 검사, 서명 FFT·sampler는 변경하지 않았다. `.s` 파일도 그대로다.
산술 backend는 이 폴더의 C에 직접 작성되어 있으며 다른 후보의 소스를 링크하지 않는다.
호스트 검사는 이 M55 대상 경로를 검사하도록 `FNDSA_AVX2=0`으로 빌드한다.

초기 기본 비교는 기존 radix-2 순서, 복소 3곱셈, iFFT 단계별 1/2,
역수 준비의 두 번 나눗셈, 스케일 및 반복 계획을 유지했다.
후속 속도 수정에서 복소 곱셈만 **4곱셈·2합**으로 바꿨으며,
나눗셈은 정상 가수에서 수행 후 지수·부호를 복원한다.
이 복소 곱셈 변경은 원래 2nd 실험 축과 겹친다. 초기 3곱셈 비교점은
`validation/revision/before_repairs.tar.gz`에 보존했고 2nd 폴더는 수정하지 않았다.
원래 Q32.32 root 값을 정확히 double로 옮겼으며 정밀 root 재생성,
역수 재사용, FMA 결합, MVE, 수작업 assembly 최적화는 하지 않았다.

FP64에서 발산한 키 후보에 대해서는 부정확한 정수 변환이나 정수 갱신 overflow가
발생하기 전에 후보 전체를 거부한다. 이 범위 검사도 실제 측정에 포함했다.

## 빌드·검사

이 실험의 유효한 진입점은 **`validation/`**이다. 복사된 예전
`build_integrated.sh`, `profiling/`, 루트 `build/` 결과를 이번 FP64 결과로 사용하지 않는다.
복사되어 있던 과거 NTT README/결과 문서는 삭제하지 않고 `validation/legacy/`에 보관했다.

```sh
python3 -B validation/host.py
python3 -B validation/host_bench.py
python3 -B validation/trace.py
python3 -B validation/frozen.py
python3 -B validation/revision/division_test.py
bash validation/build.sh ref-perf
bash validation/build.sh fp64-perf
bash validation/build.sh ref-profile
bash validation/build.sh fp64-profile
bash validation/build.sh kernels
```

하드웨어 접근 승인을 받은 환경에서, 보드 실행은 한 번에 하나씩 수행한다.
runner는 M55 probe `003C00223335510735383531`만 선택한다.

```sh
python3 -B validation/run_board.py ref-perf
python3 -B validation/run_board.py fp64-perf
python3 -B validation/run_board.py ref-profile
python3 -B validation/run_board.py fp64-profile
python3 -B validation/run_board.py kernels
python3 -B validation/analyze.py
```

`run.json`의 `valid: true`는 측정 캡처·fault 검사가 정상이라는 뜻이며,
**KAT·상수시간·암호학적 안전성 통과를 뜻하지 않는다.**
`host.py`는 알려진 KAT 불일치 후에도 오차 검사를 계속하여 보고서를 남긴다.
스크립트의 종료만 보지 말고 `summary.json`의 KAT 결과를 확인해야 한다.

26건 원인 진단은 `python3 -B validation/revision/diagnose.py`로 재현한다.
`compatibility_probe.py`는 준비만 고정소수점으로 되돌리는 진단이며 **미채택**이다.
현재 native 소스는 seed별 fallback이나 KAT 기대값 변경을 사용하지 않는다.

GCC 15.2.1, `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math
-fno-strict-aliasing`을 양쪽에 동일하게 적용한다. FP64 명령 사용을 가능하게 하는
타깃 옵션일 뿐, 매크로로 다른 폴더의 산술 구현을 선택하는 구조가 아니다.
