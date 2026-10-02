# Stage 6: double-single MVE redesign

Stage 5의 `2×FP32` 표현을 유지하면서 다음 두 변경을 적용한 스냅샷이다.

- iFFT의 레이어별 `1/2` 스케일링을 제거하고 마지막에 `2/n`을 한 번 적용
- 같은 twiddle을 쓰는 네-lane 블록 전체를 span 어셈블리로 처리하여 twiddle을
  `q4`~`q7`에 고정하고 함수 호출·스택 준비 비용을 상각

측정 결과는 상위 `result.md`의 `20260924T103351Z` 항목을 참조한다.
