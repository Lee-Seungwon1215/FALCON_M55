# D0 — 4단계 기준점의 새 측정 결과

2026-09-15. 암호 소스 31개는 채택한 H1과 동일하게 보존했다.
실제 D0 방식은 **NTT penultimate plain store → final VLD4**다.
폴더 이름은 실제 방식과 다르므로 [비교 정의](../README.md)를 확인한다.

이번 D0 수치는 원본에 실행되지 않는 패딩만 넣어 D1과 함수 주소를 맞춘
[전체 대조군 복사본](../experiments/d0_layout/README.md)을 **새로 측정**한 값이다.
복사되어 있던 과거 H1 결과가 아니다.

공통 조건: NUCLEO-N657X0-Q, CPU/SYSCLK/HCLK 800/400/200 MHz,
코드 ITCM, 상수·데이터·스택 DTCM, I/D cache OFF, TCM ECC ON,
GCC 15.2.1 최종 -O3, 동일 결정적 seed, API별 100회.
단위 cycles/call; 10개 batch 평균의 upper median.

| 크기 | 연산 | D0 주소 통제 대조군 | D1 | D1 개선율 |
|---|---|---:|---:|---:|
| 512 | 키생성 | 46,522,075.10 | 46,489,021.70 | +0.071049% |
| 512 | 서명 | 17,369,508.10 | 17,369,508.00 | +0.000001% |
| 512 | 검증 | 323,070.30 | 323,070.30 | +0.000000% |
| 1024 | 키생성 | 243,814,524.30 | 243,716,892.30 | +0.040044% |
| 1024 | 서명 | 37,222,532.20 | 37,222,531.70 | +0.000001% |
| 1024 | 검증 | 624,979.30 | 624,961.30 | +0.002880% |

D0 산술 audit·KAT/digest·서명검증·변조 거부 모두 PASS.
상세 커널표·검증 범위·실험 한계·실제 raw log 링크는
[D1의 통합 결과 보고서](../D1_vld4_last/result.md)에 있다.
D0 원본 또는 통합 ref를 교체하지 않았다.

- [D0 full 원시 로그](../experiments/d0_layout/profiling/results/d0_layout-boundary_v2-perf/runs/full-20260915T113934Z/raw.log)
- [D0 audit 원시 로그](../experiments/d0_layout/profiling/results/d0_layout-boundary_v1-audit/runs/pilot-20260915T113506Z/raw.log)
- [기계 판독 비교 결과](../results/comparison.json)
