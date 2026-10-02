# FFT native FP64 독립 검증 프로젝트

**2026-09-23 최신 상태: `q32_trial` 본체 수정·M55 재검사 완료.** 과도한
안전 검사 거부를 누산 절댓값 합 상한으로 수정했다. 실제 본체로 M55 키생성
KAT 300/300, 서명 KAT 90/90, 이전 불일치 5개 회귀시험이 통과했고,
호스트 추가 20,000개 키도 원본과 모두 일치했다.
최신 결과는 [guard_integration_result.md](guard_integration_result.md).

**성능·비중 재측정도 완료:** 실제 키생성의 계측한 근사 k 구간 합은 후보가
고정소수점보다 512에서 11.07배, 1024에서 11.16배 오래 걸렸다. 전체 키생성의
지연 비율이 아니다. 후보 구간의 약 84%가 FFT+iFFT다. 최신 속도·비중은
[performance_profile_result.md](performance_profile_result.md)에 있다.

**전체 최적화 채택은 아직 보류:** FFT 보정 비용과 입력 의존 시간 문제는
재측정에서도 확인됐다. 임의 입력의 동등성·상수시간을 보증하지 않는다.
이전 실패 기록은 [followup_result.md](followup_result.md), 직접 원인과 진단
단계는 [failure_trace_result.md](failure_trace_result.md)에 보존한다.

목표는 NTRU solve ④ `solve_NTRU_intermediate()` 근사 k 계산을
**실수부 double 하나 + 허수부 double 하나**로 수행하면서 기존 KAT와 비교하는 것이다.
한 성분을 두 double hi/lo로 분할하지 않는다. 실제 물리 레지스터 수와 spill은
컴파일러가 결정하며, 복소 연산 전체가 레지스터 두 개만 쓴다고 주장하지 않는다.

## 소스 구성

| 폴더 | 역할 |
|---|---|
| `reference/` | 기존 `FFT/4_ntrusolve_approximate_k/ref`의 고정소수점 코드 사본 |
| `native/` | `1st_native_fp64` 루트의 일반 scalar-double 코드 사본, 변경하지 않은 비교군 |
| `q32_trial/` | native 사본에 Q32.32 호환 보정을 직접 작성한 실험 후보 |
| `validation/` | 동일 입력 단계별 검사, 원본 KAT, 서명검증, 호스트 추가 입력 비교 |

세 소스 폴더는 C/H/S를 독립적으로 보유한다. 다른 후보의 구현을 링크하거나
암호 경로 선택 매크로로 대체하지 않는다. 공통 Zephyr·N657 부트/링커/로더는
기존 `measurement_mlkem_native` 환경을 재사용한다. 원래 연구 폴더는 변경하지 않았다.
reference에도 이미 NTT 최적화가 들어 있으며 **이번 비교의 기준은 FFT 고정소수점 경로**다.

## 보정 후보의 정확한 의미

저장 형식은 `typedef struct { double re, im; } fp64c`이며 복소수 하나당 16바이트다.
실제 곱셈/덧셈은 M55 FP64 명령을 사용한다. 그러나 계산 의미는 제한 없는 일반
IEEE FFT가 아니라 **FP64 계산 뒤 원본 Q32.32의 절삭·wrap·반올림 규칙을 적용하는
호환 후보**다. 기존의 두-double/성분 방식과 다르지만, 보정 비용이 없는 구현은 아니다.

`native/` 대비 암호 변경은 두 파일뿐이다.

- `q32_trial/kgen_inner.h`: 단일 double을 유지하는 floor/wrap/half/div 보정과 원본
  3-product 복소수 곱셈. IEEE 값의 비트 조작을 위한 일시적 uint64 연산은 남아 있다.
  이것은 원본 Q32 raw의 상·하위 32비트를 각각 double에 저장하는 구조가 아니다.
- `q32_trial/kgen_fxp.c`: FFT/iFFT butterfly, 점별 곱셈, 역수 준비에서 이 보정 적용.

정수 입력 추출과 최종 k 변환, NTT/RNS/CRT/Bezout, 정수 해 갱신, depth0, 서명 FFT는
추가 변경하지 않았다. `native`가 이미 가진 FP64 intermediate 호출을 그대로 사용한다.
기존 FFT를 몰래 재실행하는 fallback, seed 특례, KAT 기대값 변경은 없다.

Q32.32의 64-bit 상태 전체를 단일 double이 모두 보존하는 것은 아니다. **전체 중간값
bit-exact 보장도, 임의의 모든 seed에서 원본 키가 같다는 증명도 하지 않는다.**
기존 최종 k/KAT 시험 기록은 [result.md](result.md), 그 이후 확인한 실패와
성능·타이밍 측정은 [followup_result.md](followup_result.md)에 보존한다.
현재 본체 guard 수정 검증은 [guard_integration_result.md](guard_integration_result.md)가 최신이다.

## 현재 본체 재검사

```sh
python3 -B validation/guard_integrated_host.py
bash validation/build.sh q32_trial kat
python3 -B validation/run_board.py q32_trial kat
bash validation/build.sh q32_trial sigkat
python3 -B validation/run_board.py q32_trial sigkat
bash validation/build.sh q32_trial guard_repro
python3 -B validation/run_board.py q32_trial guard_repro
```

각 명령이 출력한 새 결과 경로를 `validation/analyze_guard_integration.py`의
`--host`, `--kat`, `--sigkat`, `--repro`에 넣어 수집한다. `guard_repro`는
이전 실패 5개의 결과를 **원본 reference digest**와 비교한다. 본체 암호 코드
대신 진단 사본을 링크하거나 KAT 기대값을 바꾸지 않는다.

## 최초 진단 재현 기록 (수정 전 소스용)

아래는 초기 실험 명령을 보존한 것이다. `analyze.py`, followup/failure-trace
분석에는 당시 소스 hash와 5개 실패 등을 전제로 한 검사가 있으므로 현재
본체의 합격 수집기로 사용하지 않는다. 과거 상태 재현이 필요하면 별도 사본에서
[수정 전 헤더](build/q32_trial-before-l1-guard-20260923.tar.gz)를 사용한다.

```sh
python3 -B validation/prepare.py
python3 -B validation/host.py reference kat
python3 -B validation/host.py native stages
python3 -B validation/host.py native kat
python3 -B validation/host.py q32_trial stages
python3 -B validation/host.py q32_trial kat
python3 -B validation/host.py reference extended
python3 -B validation/host.py q32_trial extended
python3 -B validation/check_floor.py

bash validation/build.sh native stages
python3 -B validation/run_board.py native stages
bash validation/build.sh reference kat
python3 -B validation/run_board.py reference kat
bash validation/build.sh native kat
python3 -B validation/run_board.py native kat
bash validation/build.sh q32_trial stages
python3 -B validation/run_board.py q32_trial stages
bash validation/build.sh q32_trial kat
python3 -B validation/run_board.py q32_trial kat
bash validation/build.sh q32_trial sigkat
python3 -B validation/run_board.py q32_trial sigkat
python3 -B validation/analyze.py
```

`prepare.py`만 최초 frozen raw 입력 자료를 기존 진단 폴더에서 읽는다. 생성된
`validation/generated/cases.h`에는 입력이 실제로 저장되며 crypto 구현 의존성이 아니다.
KAT 벡터는 이 프로젝트 `reference/test_fndsa.c`에서 원문 그대로 추출한다.
보드 실행은 serial `003C00223335510735383531`만 대상으로 한 번에 하나씩 수행한다.
`run.json`의 `valid_measurement`는 측정 완결성/환경 확인이며 KAT 합격은 별도 `kat` 필드다.

## 추가 검증 재현 기록 (수정 전 소스용)

```sh
python3 -B validation/followup_host.py
bash validation/build.sh q32_trial perfct
python3 -B validation/run_board.py q32_trial perfct
bash validation/build.sh q32_trial repro
python3 -B validation/run_board.py q32_trial repro
bash validation/build.sh reference repro
python3 -B validation/run_board.py reference repro
```

`followup_host.py`는 기존 seed 0..999와 겹치지 않는 1000..10999를 두 차수에
각각 적용한다. `repro`는 여기서 발견한 5개 seed를 고정하고 당시 후보의
실패 digest를 기대하는 역사적 재현 검사다. 수정 후 본체에는 `guard_repro`를 사용한다.
`validation/generated/perf_cases.h`는 기존 연구의 `validation/kernel_cases.h`를
그대로 복사한 실제 NTRU 중간 입력 19개이며, 다른 암호 코드를 링크하지 않는다.
새 시각의 로그를 `analyze_followup.py --host ... --perf ... --trial-repro ...
--reference-repro ...`로 모은다. 실패했던 최초 계측 로그도 삭제하지 않는다.
