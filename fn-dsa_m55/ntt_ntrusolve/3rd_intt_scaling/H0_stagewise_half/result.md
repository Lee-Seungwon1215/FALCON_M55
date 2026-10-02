# L2 — Stage 2 실제 M55 측정 결과

## 현재 소스: logn=4/6 전용 제어 경로

`kgen_mp31_cm55.s`에 작은 크기 전용 경로를 직접 추가했다. 명령 스케줄링은 적용하지 않았다.
NTT logn4: 375.82 → 343.82 cycles (**8.5147% 개선**),
logn6: 1660.82 → 1614.82 cycles (**2.7697% 개선**).
logn5는 7 cycles 증가했고 logn7..10과 모든 iNTT median은 유지됐다.
최신 전체 측정·대조군·검증·소스/ELF는 [SMALL_LOGN_RESULT.md](../SMALL_LOGN_RESULT.md)를 참조한다.
현재 L2는 아래 과거 원본과 달리 M1-improve와 byte-identical하지 않다.


각 API 100회 최종 결과(cycles/call, batch 평균 upper median):

| degree | keygen | sign | verify |
|---:|---:|---:|---:|
| 512 | 46,657,969.4 | 17,169,884.6 | 323,070.3 |
| 1024 | 244,269,931.6 | 36,786,089.1 | 624,961.3 |

동일 배치 대조군 대비 키생성 개선은 0.0441% / 0.0261%다.
그러나 직전 원본 대비 서명은 0.1419% / 0.1324% 느려졌다.
이는 전용 경로가 비활성인 배치 일치 대조군에도 나타난다. 모든 API의 새 기준으로 자동 승격하지 않았다.
전 소수 transform 오차 0, 보드 KAT/digest·서명검증·변조거부 PASS. 상수시간은 정적 구조 검사까지만 수행했다.

- [최종 100회 raw log](../experiments/small_final/results/l2/runs/full-20260915T085635Z/raw.log)
- [최종 전 소수 audit](../experiments/small_final/results/l2_audit/runs/pilot-20260915T085514Z/raw.log)

## 아래는 작은 크기 최적화 전의 원본 L2 기록

이하 수치는 과거 결과이며 현재 소스의 측정값이 아니다.

측정일: 2026-09-15. 1단계 M1_improve와 모든 최상위 C/H/S가 동일한 기준 구현이다. 이번 단계에서는 암호 소스를 수정하지 않았다.

NUCLEO-N657X0-Q / CPU 800 MHz / SYSCLK 400 MHz / HCLK 200 MHz,
GCC 15.2.1의 최종 -O3. 코드 ITCM, 상수·데이터·스택 DTCM.
런타임 CCR=0x611로 I/D cache enable bit는 0이다.

## 성능

작업마다 10개 seed × 10회 = 100회. 각 batch에는 10회 warm-up이 별도다.
단위는 cycles/call, 10개 batch 평균의 upper median이다.

| degree | keygen cycles | sign cycles | verify cycles |
|---:|---:|---:|---:|
| 512 | 46,676,611.9 | 17,145,561.6 | 323,017.3 |
| 1024 | 244,326,106.6 | 36,737,446.1 | 624,908.3 |

## 검증

- 308 RNS 소수 × logn4..10의 forward/inverse/roundtrip: mismatch 0.
- q=12289 NTT 회귀: mismatch 0.
- 보드 KAT/digest: 호스트 oracle와 일치; 서명 검증·변조 거부 PASS.
- CFSR/HFSR/AFSR=0, TCM ECC 유지.
- 정적 상수시간 구조 감사 수행. 형식적 증명이나 통계적 leakage 검사는 수행하지 않았다.

## 보존 자료

- [이 후보의 full raw log](../results/l2/runs/full-20260915T070416Z/raw.log)
- [이 후보의 산술 audit](../results/l2_audit/runs/pilot-20260915T065820Z/raw.log)
- [L2/L3 전체 비교·logn별 사이클·메모리·해석 한계](../result.md)
- [구현 원리·논문 출처·재실행](../README.md)

이 파일은 복사돼 있던 이전 M1 측정 문서를 대신하는 **새 경로의 실제 결과**다.
이전 M1/M1-improve 측정 기록은 1st_mod_opt에 그대로 보존돼 있다.
