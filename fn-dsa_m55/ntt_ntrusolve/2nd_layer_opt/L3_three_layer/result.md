# L3 — Stage 2 실제 M55 측정 결과

## 현재 소스: logn=4/6 전용 제어 경로

L2와 동일한 작은 크기 경로를 `kgen_mp31_cm55.s`에 직접 추가했다. 명령 스케줄링은 적용하지 않았다.
NTT logn4: 381.82 → 343.82 cycles (**9.9523% 개선**),
logn6: 1672.82 → 1614.82 cycles (**3.4672% 개선**).
두 크기에서 L3가 L2보다 느렸던 차이는 없어졌다.
logn5는 7 cycles 증가했고 logn7..10과 모든 iNTT median은 유지됐다.
최신 전체 측정·대조군·검증·소스/ELF는 [SMALL_LOGN_RESULT.md](../SMALL_LOGN_RESULT.md)를 참조한다.


각 API 100회 최종 결과(cycles/call, batch 평균 upper median):

| degree | keygen | sign | verify |
|---:|---:|---:|---:|
| 512 | 46,627,222.9 | 17,643,160.2 | 323,070.3 |
| 1024 | 244,182,378.5 | 37,832,165.3 | 625,018.2 |

동일 배치 대조군 대비 키생성 개선은 0.0536% / 0.0317%다.
그러나 직전 원본 대비 서명은 1.5994% / 1.6627% 느려졌다.
이는 전용 경로가 비활성인 배치 일치 대조군에도 나타난다. 모든 API의 새 기준으로 자동 승격하지 않았다.
전 소수 transform 오차 0, 보드 KAT/digest·서명검증·변조거부 PASS. 상수시간은 정적 구조 검사까지만 수행했다.

- [최종 100회 raw log](../experiments/small_final/results/l3/runs/full-20260915T085947Z/raw.log)
- [최종 전 소수 audit](../experiments/small_final/results/l3_audit/runs/pilot-20260915T085834Z/raw.log)

## 아래는 작은 크기 최적화 직전의 forward 추가 개선 기록

이하 “현재”는 당시 시점을 뜻하며, 아래 표는 logn=4/6 전용 경로 추가 전의 결과다.

`kgen_mp31_cm55.s`에서 불필요한 VMOV 2개 제거, forward 주소 재사용,
공개 layer-mask dispatch 단축을 직접 구현했다. iNTT와 산술식은 그대로다.

각 degree/API 10개 seed × 10회 = 100회. 단위 cycles/call, batch 평균의 upper median.

| degree | API | 현재 cycles | 수정 전 L3 대비 개선율 | L2 대비 개선율 |
|---:|---|---:|---:|---:|
| 512 | keygen | 46,650,269.2 | +0.0910% | +0.0564% |
| 512 | sign | 17,365,412.3 | +0.0000% | -1.2823% |
| 512 | verify | 323,070.3 | 0.0000% | -0.0164% |
| 1024 | keygen | 244,252,177.2 | +0.0461% | +0.0303% |
| 1024 | sign | 37,213,424.0 | -0.0003% | -1.2956% |
| 1024 | verify | 624,979.3 | +0.0062% | -0.0114% |

양수는 빠름, 음수는 느림이다. NTT 직접 측정에서 logn5/7/8/9/10은 L2 대비
2.5855~3.5082% 개선됐지만 logn4/6은 아직 L2보다 느리다.
RNS 전 소수 transform 오차 0, 보드 KAT/digest·서명검증·변조거부 PASS.
상수시간은 정적 구조 감사이며 형식적 증명이나 통계적 leakage 검사는 아니다.
서명은 RNS NTT를 호출하지 않으며, 기존 L3의 L2 대비 서명 불이익은 남아 있다.
따라서 다른 기준/단계 폴더에 자동 승격하지 않았다.

- [현재 상세 보고서: 단계별 효과·측정조건·검증 한계](../NTT_TUNING_RESULT.md)
- [현재 100회 full raw log](../experiments/ntt_final/results/l3/runs/full-20260915T075834Z/raw.log)
- [현재 전 소수 audit](../experiments/ntt_final/results/l3_audit/runs/pilot-20260915T075441Z/raw.log)

## 아래는 초기 L3 측정 기록 (추가 개선 전)

이하 수치와 당시 채택 판단은 과거 기록이며 현재 소스의 결과가 아니다.

측정일: 2026-09-15. kgen_mp31_cm55.s에 3-layer CT/GS를 직접 구현했다. 같은 기준 L2와 비교한 결과, 키생성 512는 0.0346%, 1024는 0.0158% 느려 기준 구현으로 승격하지 않는다.

NUCLEO-N657X0-Q / CPU 800 MHz / SYSCLK 400 MHz / HCLK 200 MHz,
GCC 15.2.1의 최종 -O3. 코드 ITCM, 상수·데이터·스택 DTCM.
런타임 CCR=0x611로 I/D cache enable bit는 0이다.

## 성능

작업마다 10개 seed × 10회 = 100회. 각 batch에는 10회 warm-up이 별도다.
단위는 cycles/call, 10개 batch 평균의 upper median이다.

| degree | keygen cycles | sign cycles | verify cycles |
|---:|---:|---:|---:|
| 512 | 46,692,781.0 | 17,365,412.2 | 323,070.3 |
| 1024 | 244,364,810.8 | 37,213,315.1 | 625,018.3 |

## 검증

- 308 RNS 소수 × logn4..10의 forward/inverse/roundtrip: mismatch 0.
- q=12289 NTT 회귀: mismatch 0.
- 보드 KAT/digest: 호스트 oracle와 일치; 서명 검증·변조 거부 PASS.
- CFSR/HFSR/AFSR=0, TCM ECC 유지.
- 정적 상수시간 구조 감사 수행. 형식적 증명이나 통계적 leakage 검사는 수행하지 않았다.

## 보존 자료

- [이 후보의 full raw log](../results/l3/runs/full-20260915T070750Z/raw.log)
- [이 후보의 산술 audit](../results/l3_audit/runs/pilot-20260915T070254Z/raw.log)
- [L2/L3 전체 비교·logn별 사이클·메모리·해석 한계](../result.md)
- [구현 원리·논문 출처·재실행](../README.md)

이 파일은 복사돼 있던 이전 M1 측정 문서를 대신하는 **새 경로의 실제 결과**다.
이전 M1/M1-improve 측정 기록은 1st_mod_opt에 그대로 보존돼 있다.
