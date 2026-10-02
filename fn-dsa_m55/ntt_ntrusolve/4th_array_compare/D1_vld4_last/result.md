# D1 — 배열 재배열 위치 변경: 구현 및 M55 실측 결과

측정일: 2026-09-15. **구현·정확성·KAT/digest·서명검증·변조 거부·100회 성능 측정 완료.**

D0 대비 전체 키생성 개선은 **512: +0.071049%, 1024: +0.040044%**다.
NTT/iNTT 커널의 개선은 확인됐지만 전체 키생성 개선폭은 작다.
서명·검증은 사실상 동일하다. D0/H1 또는 통합 ref를 자동 교체하지 않았다.

## 1. 최신 코드 검토로 수정한 계획

폴더 이름과 실제 코드가 달랐다. 복사된 H1/D0는 **이미 마지막 NTT 구간에서 VLD4**를 사용했다.
같은 방식을 D1에 다시 넣어서는 비교가 되지 않으므로 D0 원본은 보존하고
D1에 반대 대안을 직접 구현했다. 폴더 이름은 사용자 구조대로 보존했다.

| 구간 | D0 실제 코드 | D1 실제 구현 |
|---|---|---|
| NTT 직전 → 마지막 CT2 | plain store → VLD4 | **VST4 → plain load** |
| iNTT 첫 → 다음 GS2 | VST4 → plain load | **plain store → VLD4** |
| 함수 외부의 계수 순서 | 원래 순서 | 원래 순서 유지 |
| 산술 및 iNTT 정규화 | M1_improve + H1 | 그대로 유지 |

암호 C/H/S 31개 중 [kgen_mp31_cm55.s](kgen_mp31_cm55.s) 하나만 변경했다.
`mq_cm55.s`, CRT/Bezout, FFT, sampler, gm/igm 생성은 바꾸지 않았다.
새 연산 선택 옵션이나 타 후보 소스 링크는 추가하지 않았다.
공유하는 것은 기존 고정 보드/측정 harness뿐이다.

논문 근거는 [상위 README](../README.md)에 정리했다.
핵심은 **Fast and Clean §8.2.2–8.2.3, Listing 10, PDF pp.32–34**의
penultimate VST4 / final VLD4 비교다. 연구의 Cortex-M55에서는 전자가 유리했지만
Kyber/Dilithium 결과를 FN-DSA의 31-bit 소수 결과로 그대로 가정하지 않고 실제 측정했다.
inverse의 대응 경계 이동은 전치 원리에서 도출한 이번 구현이다.

[구현 원리 및 정적 검토](IMPLEMENTATION.md).
이번 수치는 재배열과 그 경계의 루프 제어 단순화까지 포함한 **완성 커널 비교**이며,
VLD4/VST4 한 명령만 교체한 독립적인 latency 실험은 아니다.

## 2. 주소를 맞춘 대조군

비교의 D0는 [전체 복사본](../experiments/d0_layout/README.md)에 **반환 뒤 실행되지 않는 패딩만**
넣은 새 측정 대조군이다. 원본 D0의 31개 암호 파일은 H1과 byte-identical이다.

perf/audit 모두에서 다음을 확인했다.

- 세 커널 시작 주소 동일: NTT `0x10000330`, iNTT `0x100007c0`, small NTT `0x10000ec0`.
- 모든 allocated section의 주소·크기 동일.
- 세 커널 슬롯 밖의 **모든 allocated byte 동일**.
- 서명, 검증, q-NTT, 상수·데이터·스택의 코드/주소 동일.

따라서 서명·검증 함수가 코드 크기 증가로 이동한 영향은 통제했다.
다만 커널 **내부** 명령 배치는 구현의 일부로 달라진다.
[perf 정적 판정](../results/static_audit/perf.json), [audit 정적 판정](../results/static_audit/audit.json).

## 3. 공통 빌드·보드 조건

| 항목 | D0/D1 공통 조건 |
|---|---|
| 보드 | NUCLEO-N657X0-Q, STM32N657, Cortex-M55 r1p1 |
| ST-LINK | `003C00223335510735383531` |
| CPU / SYSCLK / HCLK | 800 / 400 / 200 MHz, runtime decode 확인 |
| 메모리 | ITCM 256 KiB: 코드; DTCM 256 KiB: 상수·데이터·스택 |
| 캐시 / ECC | I/D cache OFF, `CCR=0x611`; TCM ECC ON, `MSCR=0x1300a` |
| 컴파일러 | GNU Arm GCC 15.2.1 20251203 / 15.2.Rel1 |
| 주요 옵션 | `-mcpu=cortex-m55 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16`, 최종 `-O3`, `-fno-reorder-functions` |
| 암호 소스 | 후보의 C 18개 + asm 6개, `FNDSA_MVE_MP31=1` |
| 환경 | 고정 mlkem-native `637d076aa113d8faaec2277ed4a46b657acaf35f`의 Nucleo 설정, 기존 Zephyr 4.4.1 FN-DSA harness |
| 설정 일치 | 기존 L2와 Kconfig byte-identical |
| API 측정 | 크기별·API별 10 batch × 10회 = **100회**, 각 batch warm-up 10회 |
| 입력 | 동일한 결정적 seed 10개; 각 batch에서는 같은 입력 반복 |
| 시간 측정 | Zephyr 64-bit cycle timer; interrupt enabled, DWT 사전 교차검사 |
| 집계 | batch 평균 10개의 upper median, 정렬 후 6번째; 정수 반올림 전 total/calls 사용 |

100개 서로 다른 키가 아니라 **10개 입력을 각각 10회 측정**했다.
성능용 perf는 산술 self-test OFF, audit는 self-test ON으로 분리했다.
이는 D0/D1 산술 선택 옵션이 아니다. 실제 로그의 I/D cache enable bit를 확인했으며
`CONFIG icache=1/dcache=1`이라는 지원 설정 출력과 실행 중 cache ON을 혼동하지 않는다.

## 4. 전체 API 결과

단위 cycles/call. 개선율 = `100*(D0-D1)/D0`; **양수는 빨라짐, 음수는 느려짐**.

| 크기 | 연산 | D0 주소 통제 대조군 | D1 | 개선율 |
|---|---|---:|---:|---:|
| 512 | 키생성 | 46,522,075.10 | 46,489,021.70 | +0.071049% |
| 512 | 서명 | 17,369,508.10 | 17,369,508.00 | +0.000001% |
| 512 | 검증 | 323,070.30 | 323,070.30 | +0.000000% |
| 1024 | 키생성 | 243,814,524.30 | 243,716,892.30 | +0.040044% |
| 1024 | 서명 | 37,222,532.20 | 37,222,531.70 | +0.000001% |
| 1024 | 검증 | 624,979.30 | 624,961.30 | +0.002880% |

같은 입력끼리 비교한 키생성 개선은 10개 batch 모두 양수였다.

- 512: batch별 +0.048287~+0.077368%; 전체 산술평균 기준 +0.064153%.
- 1024: batch별 +0.023395~+0.058112%; 전체 산술평균 기준 +0.036935%.

서명·검증은 이 RNS NTT/iNTT를 호출하지 않으며 관련 바이너리도 주소까지 동일하다.
검증의 batch별 차이는 양·음 방향으로 모두 나타난다
(512 약 ±0.0354%, 1024 약 ±0.0179% 이내).
검증 표의 +0.002880%를 알고리즘 개선으로 해석하지 않는다.

이 표는 최종 순차 실행 한 쌍의 10개 입력 결과이며, 다수 독립 세션을 이용한
통계적 유의성/일반적 실행시간 분포의 입증은 아니다.
이번에는 NTRU solve 전체의 별도 계측이나 새로운 연산비중 프로파일링은 수행하지 않았다.

## 5. NTT/iNTT 단독 결과

`PRIMES[0]`에서 각 logn·방향별 10 batch × 100회.
gm/igm 배열 생성은 제외하지만 함수 내부 root/twist 준비와 H1 최종 scaling은 포함한다.
전 소수의 평균 성능표가 아니다. 단위 cycles/call.

| logn | n | NTT D0 → D1 | NTT 개선율 | iNTT D0 → D1 | iNTT 개선율 |
|---|---:|---:|---:|---:|---:|
| 4 | 16 | 343.82 → 337.82 | +1.745099% | 389.80 → 390.80 | −0.256542% |
| 5 | 32 | 772.82 → 747.82 | +3.234906% | 847.80 → 828.80 | +2.241095% |
| 6 | 64 | 1,614.82 → 1,587.82 | +1.672013% | 1,748.80 → 1,722.80 | +1.486734% |
| 7 | 128 | 3,699.82 → 3,650.82 | +1.324389% | 3,998.80 → 3,925.80 | +1.825548% |
| 8 | 256 | 8,180.82 → 8,111.82 | +0.843436% | 8,615.80 → 8,515.80 | +1.160658% |
| 9 | 512 | 18,255.82 → 18,128.82 | +0.695669% | 19,533.80 → 19,262.80 | +1.387339% |
| 10 | 1024 | 39,960.82 → 39,781.82 | +0.447939% | 42,014.80 → 41,660.80 | +0.842560% |

NTT는 전 크기에서 0.45~3.23% 개선됐다.
iNTT는 logn5..10에서 0.84~2.24% 개선됐지만,
**logn4는 389.80 → 390.80, 1사이클(0.2565%) 느려졌다.**
작은 inverse 전용 분기를 포함한 전체 경계 변경의 결과다.
이 1사이클의 정확한 개별 명령별 기여를 분리 계측한 것은 아니다.

개선 범위는 NTRU solve 안의 RNS 변환 일부다. CRT/Bezout/FFT 등은 그대로이므로
커널 개선율과 키생성 전체 개선율이 같지 않다.

## 6. 검증과 한계

| 검사 | 결과 | 범위 |
|---|---|---|
| RNS NTT/iNTT | **PASS**, 308개 소수 × logn4..10 = 2,156세트 | forward/inverse/roundtrip mismatch 모두 0, scalar C oracle 비교 |
| rounding Montgomery | **PASS**, 18,923,520 lane case | mismatch/range error 0, signed/canonical 경계 입력 |
| 오차 | modular error 0, inverse bit-exact | FP 근사를 도입하지 않은 정수 연산 |
| q=12289 NTT 회귀 | 512/1024 PASS | mq 코드는 미변경 |
| KAT/digest | perf/audit host digest 일치; full의 D0/D1 20개 batch digest도 동일 | 기존 결정적 benchmark 벡터; upstream 전체 테스트/FIPS 인증을 뜻하지 않음 |
| 서명검증/변조 거부 | PASS | 정상 서명·signature bit 변조; 별도 audit 메시지 변조 포함 |
| 보드 상태 | exit 0, fault 검사 PASS, ECC 유지 | 최종 네 run 모두 validation_errors=[] |
| 상수시간 구조 | 정적 소스/디스어셈블리 검토 완료 | 공개 logn/카운터 기반 분기·주소, 기존 VPT 유지 |
| 동적 누출/형식적 CT 증명 | **미수행** | dudect/TVLA/전력·EM 실험 또는 전체 FN-DSA CT 증명과 구분 |

계수 의존 분기/주소, BL/BLX 외부 호출, 나눗셈, FP 연산/변환,
계수 stack spill을 새로 추가하지 않았다. logn<4 C fallback은 유지했다.
정적 검토는 변경 커널의 구조에 대한 것이며 키생성 전체가 상수시간이라는 주장은 아니다.

호스트 배열 경계 검사 4개, 기존 검증 도구 회귀검사 21개 PASS.
D1의 산술 parser·provenance·runner 함수가 검증된 H1과 동일한 것도 확인했다.
유한 개수의 테스트 통과를 모든 가능한 입력의 전수검증으로 해석하지 않는다.

## 7. 메모리와 재현 식별

| 항목 | 결과 |
|---|---:|
| D1 regular NTT | 1,166 B; D0 850 B |
| D1 iNTT | 1,770 B; D0 1,400 B |
| D1 small NTT | 1,030 B; D0 724 B |
| 원본 D0 대비 ITCM 증가 | **992 B** |
| perf ITCM / DTCM | 110,244 / 225,728 B |
| audit ITCM / DTCM | 116,056 / 234,304 B |
| 용량 | 각 262,144 B 안에 들어감 |
| 추가 배열 / DTCM 증가 | 없음 / 0 B |
| 스택 프레임 | regular 112 B, small 104 B, 기존과 같음 |

대조군은 패딩을 넣었으므로 D1과 같은 공간을 차지한다.
992 B는 패딩 없는 원본 H1/D0(ITCM 109,252 B) 대비 증가량이다.

```text
D0 원본 kgen_mp31_cm55.s
c574a589db5d1eca36e711cec10cbe81c8761a09d4779eebce415e87d6d11872
D1 kgen_mp31_cm55.s
463137bc8fba5d660e39dcf05e839b81971864d00545e888d73363598eb086c6
D0 주소 대조군 perf ELF
61c5ea58b709a618a68293297caf2048763127a9f05403884c49c8f980cc7bf4
D1 perf ELF
98dcfe6d8850a3bb36748b9c982621f0f081f1bcdad6ac8dc846bbe430ff79b1
공통 Kconfig
29add21e434a3054715e66a9711d44653b8362c0370b249dfbfd5744d14eb0ca
```

## 8. 로그와 재실행

- [D0 perf 원시 로그](../experiments/d0_layout/profiling/results/d0_layout-boundary_v2-perf/runs/full-20260915T113934Z/raw.log)
- [D0 audit 원시 로그](../experiments/d0_layout/profiling/results/d0_layout-boundary_v1-audit/runs/pilot-20260915T113506Z/raw.log)
- [D1 perf 원시 로그](../D1_vld4_last/profiling/results/d1-boundary_v2-perf/runs/full-20260915T114226Z/raw.log)
- [D1 audit 원시 로그](../D1_vld4_last/profiling/results/d1-boundary_v1-audit/runs/pilot-20260915T113127Z/raw.log)
- [모든 batch 수치·개선율·해시](../results/comparison.json)
- [정적 검사/디스어셈블리](../results/static_audit/)
- [빌드 및 호스트 검사 로그](../results/repro_logs/)
- [빌드·보드 명령](../README.md)

각 run에 raw.log, 판정, 소스 31개, ELF/map/config와 build manifest를 함께 보관했다.
복사돼 있던 과거 H1 로그는 이번 표에 사용하지 않았다.
집계 재현(보드 접근 없음):

```sh
python3 -B fn-dsa_m55/ntt_ntrusolve/4th_array_compare/audit_array.py perf
python3 -B fn-dsa_m55/ntt_ntrusolve/4th_array_compare/audit_array.py audit
python3 -B fn-dsa_m55/ntt_ntrusolve/4th_array_compare/summarize_array.py
```

실행 중 기록: 처음 D1 full이 아직 보드를 점유한 상태에서 D0 pilot을 요청한 실수가 있었고,
D0 요청은 OpenOCD init 단계에서 거부되어 `VALIDATED=False`였다.
그 실패 기록과 첫 D1 full은 최종 API 표에서 제외했다.
D0/D1 모두 `boundary_v2`로 **완전 순차 재측정**한 유효한 full만 위 표에 사용했다.
산술/커널 표는 각각 단독으로 완료한 `boundary_v1-audit`의 유효한 기록이다.
실패 로그를 삭제하거나 성공으로 바꾸지 않았다.

## 결론

**D1 후보의 구현·검증·측정은 완료**다. 작은 커널 개선은 있지만
전체 키생성은 약 0.04~0.07% 개선에 그쳤고 코드 992 B가 늘었다.
D0는 보존했으며 이 결과만으로 D1을 통합 ref에 자동 반영하지 않았다.
