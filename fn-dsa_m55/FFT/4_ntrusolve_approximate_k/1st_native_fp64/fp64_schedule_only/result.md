# F3c: 병합 없이 지역 SLOTHY 결과

2026-09-23 실제 NUCLEO-N657X0-Q 측정 완료. F2보다 근소하게 느리고 재측정에서도 순위가 같아 미채택.

[전체 비교·설계·측정 조건·한계](../fp64_fma_stages_result.md).
이 결과는 이 폴더의 소스로 빌드한 것이며 다른 후보를 링크한 결과가 아니다.

## 전체 키생성

단위 cycles/key, 동일 100개 seed 평균. 감소율은 이전 FP64 R3 대비이며
양수가 개선이다. FFT 단독 사이클이나 태초 FN-DSA ref 대비 개선율이 아니다.

| 크기 | 평균 cycle | R3 대비 감소 | fixed 대비 걸리는 시간 |
|---|---:|---:|---:|
| 512 | 178,569,083.12 | 3.8369% | 3.1324배 |
| 1024 | 571,310,186.15 | 3.1135% | 2.3474배 |

## 검증

- 원본 KAT **300/300** (256·512·1024 각 100).
- 실제 보드 곱셈 1,036,864쌍, FFT/iFFT 81,840 coefficient positions: 원본 raw와 일치.
- 실제 NTRU 중간 입력 19개: 준비·반복·정수 k 일치.
- 200개 키의 서명·검증·변조 서명 거부 PASS. 모든 후보와 키/서명 digest 일치.
- 67개 그룹 × 20종 입력의 최소 cycle 동일, 그룹 내 관찰 jitter 최대 1 cycle.
- 소스/ELF 감사 및 hardware FP64/FMA 사용 확인. 소프트웨어 double 산술 fallback 없음.

이 결과는 유한 입력 시험이다. 이상적인 실수 FFT의 오차 0, 전체 상수시간
형식 증명 또는 전력/EM 안전성 인증을 뜻하지 않는다. keygen 전체는 재시도로 가변 시간이다.

## 메모리와 증거

ITCM 코드 108,416 B, DTCM 예약 220,296 B,
관찰 stack 사용 18,696 B / 예약 65,536 B.
모든 입력에 대한 stack 상한 증명은 아니다.

- [전체 keygen raw log](validation/results/asm-perf/20260923T005524Z/raw.log)
- [실행·source·ELF·옵션 hash](validation/results/asm-perf/20260923T005524Z/run.json)
- [원본 KAT log](validation/results/kat/20260923T004923Z/raw.log)
- [정확성·커널·timing log](validation/results/kernels/20260923T004804Z/raw.log)
- [실제 ELF 정적 감사](validation/results/static/audit.json)

같은 ELF/100개 seed 재실행:

- [20260923T005110Z](validation/results/asm-perf/20260923T005110Z/raw.log): 178,569,083.06 / 571,310,186.15 cycles/key.
- [20260923T005524Z](validation/results/asm-perf/20260923T005524Z/raw.log): 178,569,083.12 / 571,310,186.15 cycles/key.

perf ELF SHA256: `59529d6849ea12140f8893da1d04343a3d1855b1f14a2b316854dcc21eeebae8`.

