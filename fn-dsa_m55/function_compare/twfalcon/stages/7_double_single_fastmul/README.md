# Stage 7: double-single fast multiplication

Stage 6을 기반으로 double-single 곱셈의 2차 저차항 `alo*blo`를 제거한 최종
실험 스냅샷이다. FFT 오차 상한과 전체 KAT가 유지되는지 보드에서 재검증했다.

- 최대 FFT 차이: 135 Q32 LSB
- 최대 FFT→iFFT 왕복 차이: 3,607 Q32 LSB
- 키 생성 KAT: 300/300
- 서명·검증·변조 거부: 90/90

최종 커널 로그는 `../../results/20260924T103549Z/raw.log`에 있다.
