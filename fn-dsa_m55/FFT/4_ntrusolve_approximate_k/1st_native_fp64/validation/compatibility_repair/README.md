# 남은 두 repeat 불일치의 primitive 추적

2026-09-18. 진단 완료. 원래 native FP64 또는 기존 나눗셈 hybrid를 수정하지 않았다.

## 방법

원본 fixed NTRU의 정수 상태를 그대로 진행하고, 역수 준비만 원본 fixed 결과를
사용하는 FP64 shadow를 계산한다. **최초로 반올림한 k가 달라지는 반복**에서
입력과 출력의 원본 64-bit word를 저장한다. 이전의 double-only 진단 자료로부터
raw word를 역산하지 않는다.

저장한 입력에서 별도의 Python 정수 모델을 실행했다. FFT, 계수별 곱셈, iFFT
각 단계의 raw output을 실제 원본 C와 대조하여 모두 일치했다.
native 4-product float 모델의 최종 값도 실제 C native shadow와 일치했다.

## 확인한 원인

| 사례 | 첫 다른 k가 나온 반복 | logn/depth | 확인 결과 |
|---|---:|---|---|
| 512/test58 | 769 | 6 / 3 | `vect_mul_fft`의 complex index 31, 첫 곱 `z0=ac`에서 Q32.32 범위 wrap 최초 발생 |
| 1024/test65 | 1258 | 3 / 7 | wrap 없음. primitive별 양자화와 연산 순서 차이가 마지막 index 6 반올림을 가름 |

두 경우 모두 가장 이른 곱셈 양자화는 forward FFT 첫 layer의 첫 butterfly,
twiddle index 2의 `ac`에서 시작한다. 이것은 최초 수치 차이이며, 그 한 연산만이
최종 k 차이를 단독으로 일으켰다는 뜻은 아니다. 이후 오차 누적/증폭이 존재한다.

### 512/test58 — wrap 위치 확정

첫 wrap의 raw signed operands:

```text
a = 36430319595946384
b = -2399815171766
floor(a*b/2^32) = -20355459693501784289
원본의 64-bit wrap 후 signed word = -1908715619792232673
```

Q32.32 실수로 보면 약 -4,739,374,782.30842가 -444,407,486.30842로 바뀌는
`2^32` 크기의 wrap이다. 해당 반복에는 총 5개의 wrap 이벤트가 있다.
최종 index 0은 fixed `45,170,645.80859` 대 native `-223,264,810.19141`이고,
두 반올림 정수의 차이는 `2^28`이다. 단순한 마지막 반올림 오차가 아니다.

정수 모델에서 양자화/3곱셈은 유지하고 **wrap만 제거**해도 64개 k 중 63개가
달라졌다. native 3곱셈/4곱셈 모두 이 63개 차이를 유지한다.

이는 원본 bit-arithmetic의 동작을 확인한 것으로, 이 값만으로 원본 구현의
암호학적 오류/취약점을 단정하지 않는다. 키생성 후보 중간 상태를 관찰한 것이다.

### 1024/test65 — 양자화와 계산 순서

최종 index 6:

```text
fixed: -1442.50051672291   -> k = -1443
native: -1442.4982897414675 -> k = -1442
```

원본 fixed complex multiply는 `ac`, `bd`, `(a+b)(c+d)`를 각각 Q32.32로 잘라서
계산한다. 네 곱셈 `ac,bd,ad,bc`와 대수적으로는 같지만, primitive별 절삭이 있는
계산에서는 동일하지 않다. 원본 `kgen_inner.h`의 `fxc_mul` 주석도 이 차이를 명시한다.

정수 모델의 비교:

- 원본 양자화 + 원본 3곱셈: 원본 raw output과 정확히 일치.
- 원본 양자화 + **4곱셈**: 이 사례에서 k 1개가 여전히 다름.
- native 3곱셈으로만 복귀: k 1개가 여전히 다름.
- wrap 제거만 수행: 이 사례에는 wrap이 없어서 k 차이 없음.

또한 원본 역수의 3개 coefficient는 single binary64로 변환할 때 raw word 기준
각각 8, 2, 4 단위가 달라진다. 원본 64-bit Q32.32 값을 단일 double로 옮기고
마지막 반올림만 고쳐 모든 중간 비트가 유지된다고 가정할 수 없다.
이 세 변환 손실 각각의 독립적인 최종-k 기여도를 증명했다는 의미는 아니다.

## 시험한 일반적 보정

검증 후보 [fp64_q32_compat](../../fp64_q32_compat/README.md)에서는 seed/크기별
예외나 비밀값 기반 fallback 대신, 모든 입력에 같은 규칙을 적용한다.

- Q32.32 raw word, wrap, half/rounding, 원본 3곱셈 그래프를 유지.
- 곱셈 high word를 native FP64로 추정하고 정확한 low word로 carry 보정.
- 모든 덧셈/뺄셈/캐리와 저장 형식은 원본 정수 규칙 유지.

이것은 **전체 double FFT가 아니라 정확한 Q32.32 산술을 재현하는 FP64/정수
혼합 구현**이다. 두 raw replay와 원본 KAT 모두 해결했지만 M55에서 크게 느려져
성능 후보로는 탈락했다. 자세한 측정은 [result.md](../../fp64_q32_compat/result.md).

이 결과로 모든 가능한 FP64 최적화가 불가능하다고 일반화하지 않는다.
현재 순수 FP64 원본의 KAT 불일치는 해당 소스를 고쳐 해결한 상태가 아니다.

## 자료

- [요약](summary.json), [baseline/native 소스 hash](manifest.json)
- [512 정확한 raw 입력](build/512-test58.json), [분석](build/512-test58-analysis.json), [이벤트](build/512-test58-events.json)
- [1024 정확한 raw 입력](build/1024-test65.json), [분석](build/1024-test65-analysis.json), [이벤트](build/1024-test65-events.json)
- 재현: `python3 -B validation/compatibility_repair/trace.py` (원래 `1st_native_fp64`에서 실행)
