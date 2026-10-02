# F3u: 무스케줄링 ASM 대조군 결과

2026-09-23 실제 NUCLEO-N657X0-Q 측정 완료. F3b의 순수 재배열 효과를 비교하는 대조군. 새 최적화 후보가 아님.

[전체 비교·설계·측정 조건·한계](../fp64_fma_stages_result.md).
이 결과는 이 폴더의 소스로 빌드한 것이며 다른 후보를 링크한 결과가 아니다.

## 전체 키생성

단위 cycles/key, 동일 100개 seed 평균. 감소율은 이전 FP64 R3 대비이며
양수가 개선이다. FFT 단독 사이클이나 태초 FN-DSA ref 대비 개선율이 아니다.

| 크기 | 평균 cycle | R3 대비 감소 | fixed 대비 걸리는 시간 |
|---|---:|---:|---:|
| 512 | 184,824,679.63 | 0.4682% | 3.2421배 |
| 1024 | 601,470,426.58 | -2.0013% | 2.4714배 |

## 검증

200개 입력의 전체 키생성·서명·검증·변조 서명 거부 및 후보 간 digest 비교 PASS.
이 대조군에서 별도 kernel/CT/300-vector KAT는 수행하지 않았다.
F3a/F3b 검증을 이 대조군의 별도 검증으로 중복 계산하지 않는다.
F3b와 복소곱 helper·FFT·iFFT의 실제 주소/크기가 동일함을 검사했다.

## 메모리와 증거

ITCM 코드 115,040 B, DTCM 예약 220,296 B,
관찰 stack 사용 18,856 B / 예약 65,536 B.
모든 입력에 대한 stack 상한 증명은 아니다.

- [전체 keygen raw log](validation/results/asm-perf/20260923T004119Z/raw.log)
- [실행·source·ELF·옵션 hash](validation/results/asm-perf/20260923T004119Z/run.json)

perf ELF SHA256: `37e40b8d7395927a749353d199aa04d8a940fa817d98a16526a12baec8b3adbc`.

