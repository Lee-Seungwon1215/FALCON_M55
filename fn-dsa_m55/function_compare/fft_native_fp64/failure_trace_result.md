# 5개 실제 키 불일치의 첫 원인 추적

> **후속 본체 반영 완료:** 이 문서는 수정 전 원인 추적 기록이다. 이후 실제
> `q32_trial/kgen_inner.h`에 누산 안전 상한을 적용하고 M55 키생성 KAT 300개,
> 서명 KAT 90개, 실패 seed 5개와 호스트 20,000개 비교를 모두 통과했다.
> 현재 상태는 [guard_integration_result.md](guard_integration_result.md)를 참고한다.
> 아래의 “본체 미수정”, 기존 guard 설명과 소스 hash는 진단 당시를 뜻한다.

2026-09-23. 대상은 실수부/허수부 각각 double 하나인 `q32_trial`이다.
**본체 소스는 수정하지 않았다.** 기록용/가설 검증용 사본과 단독 재현 테스트만
추가했다. 이전 성능·상수시간 실패 판정은 이 작업으로 해소되지 않는다.

## 1. 확인한 핵심 원인

5개 모두 **처음 다른 키를 만들게 한 분기는 FFT가 다른 정수 k를 계산해서가
아니라, FP64 전환 때 추가한 안전 범위 검사가 같은 k를 거부해서 발생했다.**

기존 fixed 경로에는 없는 [fp64_k_update_ok()](q32_trial/kgen_inner.h:874)를
[solve_NTRU_intermediate()](q32_trial/kgen_ntru.c:792)가 호출한다.
현재 검사는 모든 계수에 대해 다음 제한을 둔다.

```text
|k[i]| <= INT32_MAX >> logn

logn=2 (4계수): 536,870,911
logn=3 (8계수): 268,435,455
```

이것은 정수 갱신 오버플로를 막는 **충분조건**이지만 실제 안전 영역 전체는
아니다. 임계값보다 큰 k라도 안전하게 갱신할 수 있는 경우를 거부했다.
검사 실패는 `SOLVE_ERR_REDUCE`를 반환하고, 키 생성이 다음 후보 f,g로 넘어가
원본과 다른 키가 만들어졌다. 정상 서명·검증은 가능하지만 결정적 결과는 달라진다.

```text
동일 seed / 동일 f,g 후보
 → 해당 시점까지 같은 정수 k
 → 원본: 정수 갱신 계속
 → 후보: 추가 검사에서 거부 → 다른 f,g 후보 → 다른 키
```

| seed index | 키 차수 | 첫 거부의 FFT 크기 | depth | 해당 depth의 반복 번호 | 최대 절댓값 | 기존 제한 | 그때의 k |
|---|---:|---:|---:|---:|---:|---:|---|
| 1198 | 512 | 8 | 6 | 100 | 299,431,551 | 268,435,455 | 원본과 동일 |
| 7470 | 512 | 4 | 7 | 189 | 553,861,974 | 536,870,911 | 원본과 동일 |
| 1691 | 1024 | 4 | 8 | 399 | 542,358,223 | 536,870,911 | 원본과 동일 |
| 4395 | 1024 | 8 | 7 | 207 | 276,919,962 | 268,435,455 | 원본과 동일 |
| 10491 | 1024 | 8 | 7 | 213 | 288,921,132 | 268,435,455 | 원본과 동일 |

seed의 정확한 문자열은 `fp64-audit-20260923-<index>`이다. 모두 첫 NTRU 후보에서
발생했다. 최초 거부 전까지 동일한 k 벡터 수는 각각 660, 558, 1,217, 1,441,
1,447개였다. FP→int 유효성 검사도 전부 통과했으며, **추가 갱신 범위 검사**만 실패했다.

## 2. 원인 분리 방법

- 현재 `reference`와 `q32_trial`의 NTRU 소스를 읽고 결과 디렉터리에만 계측 사본 생성.
- 입력 정수 limbs, 원본 raw Q32 입력, 변환된 입력, 각 FFT 단계 출력, k, 유효성,
  깊이/반복/후보 번호와 함수 반환 상태를 기록.
- 계측 전후 최종 키 digest가 같은지 5개 × 2개 구현에서 확인.
- 두 구현이 같은 입력·같은 k로 진행하다가 첫 검사의 반환값만 갈리는 것을 확인.
- 해당 반복의 f/F 입력을 고정해 독립 테스트에서 FFT→역수→FFT→점곱→iFFT→k 재생.
- 호스트 및 M55에서 k 일치·원본 fixture 일치·FP→int 유효·기존 guard 거부를 재현.

M55 단독 재현 11줄은 호스트와 모두 동일했다. 보드의 원본 정수 산술은
M4 inline ASM 활성화 상태이며 후보는 실제 FP64 명령을 사용한다.
이 단계는 성능 측정이 아니고, 원인 재현 목적이다.

## 3. 처음 발생하는 미세한 수치 차이는 별개

실제 제곱합·역수 준비 안의 연산까지 분리했다. 아래는 **처음 수치가 달라진
산술 연산**이며, 위 표의 최초 거부 시점과 반드시 같은 depth/반복은 아니다.

| seed | 최초 수치 차이 연산 | 오차 (Q32 raw 단위) | 입력은 정확히 동일? | 원본 결과를 double 하나에 정확히 저장 가능? |
|---|---|---:|---|---|
| 512/1198 | 역수 준비의 나눗셈 | −3 | 예 | 아니오 |
| 512/7470 | 제곱합 준비의 실수부 제곱 | −7 | 예 | 아니오 |
| 1024/1691 | 제곱합 준비의 실수부 제곱 | −18 | 예 | 아니오 |
| 1024/4395 | 제곱합 준비의 실수부 제곱 | −8 | 예 | 아니오 |
| 1024/10491 | 역수 준비의 나눗셈 | −3 | 예 | 아니오 |

Q32 raw 1단위는 실제 값으로 2^-32이다. 이 5개 최초 primitive의 후보 값은
모두 원본의 정확한 Q32 값을 가장 가까운 binary64로 반올림한 값과 같았다.
입력 변환/캐리 반환 누락을 발견한 것이 아니라 결과의 표현 정밀도 차이다.
나눗셈은 정확한 유리수 계산으로 원본의 정수 나눗셈 반올림과 대조했고,
normal FP64 나눗셈이 정확한 비율을 올바르게 반올림하는지도 확인했다.

이 미세한 차이가 존재해도 위 첫 거부 때의 k는 동일했다. 따라서 **미세한
중간값 차이를 이번 5개 최종 키 불일치의 직접 원인으로 혼동하면 안 된다.**
한편 이전 `(1+2^-32)*(1-2^-32)` 산술 반례는 여전히 남아 있다. 단일-double
산술 전체의 bit-exact 동등성이 증명됐다는 뜻은 아니다.

## 4. 진단용 안전 검사 실험

검사를 없애지 않았다. 기존 FP→int 범위 검사를 유지하고, 정수 갱신의
**누산 안전 상한**으로 검사 조건을 바꾼 진단용 번역 단위만 별도로 만들었다.
키 생성 입력/예상 KAT를 바꾸거나 특정 seed를 예외 처리하지 않았다.

### 누산 안전 상한

전제: logn=1..3의 기존 `poly_sub_scaled()` 작은 크기 경로, 31-bit limbs,
초기 carry=0, 소스에 적힌 순서대로 int64 누산.

```text
B = 2^31
S = sum(abs(k[i]))
0 <= F_limb, shifted_f_limb <= B-1

|carry| <= S+1 을 가정하면, 모든 부분 누산합 z에 대해
|z| <= (B-1) + (S+1) + (B-1)*S = B*(S+1)

다음 carry = floor(z/B) 역시 절댓값 <= S+1.
carry=0에서 시작하므로 모든 limb에 대해 귀납적으로 성립.

S <= 2^32-2 이면
|z| <= 2^63-2^31 < 2^63
```

각 개별 곱과 왼쪽부터 계산하는 모든 부분합이 이 범위 안에 있다. `abs` 합은
uint64로 구해 INT32_MIN의 signed 부호 반전도 피한다. 이는 **정수 갱신의
오버플로 방지에 대한 충분조건**이지, 전체 FP64 구현의 수치 동등성 증명이 아니다.

처음에는 더 보수적인 `S<=INT32_MAX`로 시험했다. 20,000개에서 3개는 원본으로
복구되고 2개가 남았다. 남은 것도 같은 k를 거부한 경우였으며:

- 1024/1691: 같은 depth의 반복 410, S=2,234,499,997.
- 1024/4395: 같은 depth의 반복 213, S=2,196,457,734.

둘 다 위의 2^32−2 상한 안에 있다. 진단용 검사 조건을 이 충분조건으로 바꾸고
다시 검사한 결과는 다음과 같다.

| 검사 | 현재 본체 | 넓은 누산 상한을 적용한 진단용 사본 |
|---|---:|---:|
| 원본 대비 같은 seed의 키, host 20,000개 | 19,995개 일치 | **20,000/20,000 일치** |
| 기존 키생성 KAT, host | 이전 300/300 | **300/300** |
| upstream host 전체 서명 KAT | 이전 PASS | **PASS** |
| host 정상 검증·self test·NTRU 식/범위 | 이전 PASS | **PASS** |
| UBSan, 문제 seed index 5개 × 512/1024 | 이번 별도 미실행 | **10키 모두 PASS** |

누산 상한 외의 암호 계산은 바꾸지 않았다. 5개 모두 원본으로 돌아왔고,
동일한 20,000개에서 새 불일치도 없었다. 이를 통해 **실제 5개 키 불일치의
원인은 guard의 과도한 거부**라는 판단을 뒷받침했다.
20,000개 일치가 임의 seed 전체의 동등성 증명은 아니다. 이 표의 변경 사본
전체 키 생성/KAT는 host 검사이며 M55 전체 키 생성 재측정이라고 표현하지 않는다.

## 5. 적용 상태와 남는 문제

- `q32_trial/`와 통합 ref는 **그대로**다. 생성한 실험 코드를 배포본에 반영하지 않았다.
- 이번 범위는 원인 규명과 독립 재현이다. 안전 검사 수정 후보의 정식 반영은 별도 단계다.
- 원본과 다른 FP64 중간값, 기존 곱셈 경계 반례, 보정 비용, 입력 의존 분기는 남아 있다.
- 이번 누산 상한을 증명했다고 임의 seed의 같은 키 생성까지 증명한 것은 아니다.
- 새 검사 후보의 전체 키 생성을 M55에서 다시 실행하거나 성능/상수시간을 재측정한 것은 아니다.

## 6. 소스·로그

- [전체 추적 도구](validation/failure_trace/capture.py), [계측 hook](validation/failure_trace/capture.c)
- [분리된 primitive·guard](validation/failure_trace/probes.c)
- [진단용 넓은 누산 상한](validation/failure_trace/guard_wide.c)
- [독립 재현 프로그램](validation/first_failure.c)
- [실제 원본/후보 첫 차이](results/failure-trace/20260923T064147Z/summary.json)
- [최초 산술 차이](results/failure-trace/20260923T064147Z/numerical-summary.json)
- [M55 단독 재현](results/q32_trial-first_failure/20260923T064909Z/raw.log)
- [M55 재현 상태·hash](results/q32_trial-first_failure/20260923T064909Z/run.json)
- [더 보수적인 L1 검사 실험](results/failure-trace/20260923T064147Z/counterfactual-summary.json)
- [그 실험에서 남은 두 사례](results/failure-trace/20260923T064147Z/l1-trace/summary.json)
- [UBSan 10키 검사](results/failure-trace/20260923T064147Z/wide-guard/ubsan-summary.json)
- [진단용 사본의 20,000키·KAT 결과](results/failure-trace/20260923T064147Z/wide-guard/summary.json)
- [변경 사본 KAT 원시 로그](results/failure-trace/20260923T064147Z/wide-guard/kat.log)
- [최종 검증 범위·소스 hash 대조 집계](results/failure-trace/20260923T064147Z/final-summary.json)

### 재현 명령

```sh
python3 -B validation/failure_trace/capture.py
# 위에서 출력된 TRACE_DIR를 아래 인자로 사용
python3 -B validation/failure_trace/guard_analysis.py TRACE_DIR
python3 -B validation/failure_trace/numerical.py TRACE_DIR
python3 -B validation/failure_trace/build_isolated.py TRACE_DIR
bash validation/build.sh q32_trial first_failure
python3 -B validation/run_board.py q32_trial first_failure
python3 -B validation/failure_trace/counterfactual_trace.py TRACE_DIR
python3 -B validation/failure_trace/guard_wide_check.py TRACE_DIR
python3 -B validation/failure_trace/sanitize_wide.py TRACE_DIR
python3 -B validation/failure_trace/finalize.py TRACE_DIR BOARD_RUN_DIR
```

guard_analysis는 probes 라이브러리 생성 후 20,000키를 실행한다. numerical은
생성된 라이브러리를 사용한다. 두 검사에서 새 생성물만 쓰며, crypto 원본은
처음과 끝의 SHA-256을 비교해 변경되지 않았음을 확인한다.
