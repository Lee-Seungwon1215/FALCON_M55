# D0 — adopted H1 baseline (cryptographic source unchanged)

D0는 4단계 대조군이다. 최상위 C/H/S 31개는 채택한 H1과 동일하게 보존한다.

**폴더 이름과 실제 방식은 다르다.** 복사된 최신 H1은 이미 forward 마지막 CT2에서
VLD4를 사용한다. 즉 D0의 실제 방식은 previous plain store → last VLD4다.
D1은 그 대안인 previous VST4 → last plain load를 구현했다.

[상위 README](../README.md)에 수정된 비교 계획과 논문 근거가 있다.
[D1 결과](../D1_vld4_last/result.md)에서 최종 비교를 확인한다.

공정한 성능 비교는 `../experiments/d0_layout/source`의 완전한 D0 복사본으로 했다.
원본과의 차이는 세 함수 반환 뒤의 실행되지 않는 패딩뿐이다.
이로써 D1과 함수 주소 및 커널 밖 전체 메모리 배치를 일치시켰다.
D0 원본의 산술/제어 코드는 수정하지 않았다.

이 폴더의 `profiling/build_m55.sh`는 필요하면 원본 전체 소스를 독립적으로 빌드한다.
그러나 최종 비교표의 D0 수치는 **패딩 대조군**의 새 측정값이며
과거 복사된 H1 결과를 재사용한 값이 아니다.
