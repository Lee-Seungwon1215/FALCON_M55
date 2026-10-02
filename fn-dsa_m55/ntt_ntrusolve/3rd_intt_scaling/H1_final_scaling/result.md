# H1_final_scaling — 구현 및 M55 측정 결과

측정일: 2026-09-15. 구현·산술 audit·보드 KAT/digest·서명검증·변조 거부·전체 API 측정 완료.

H0 대비 iNTT 단독은 **5.36~13.39%**, 전체 키생성은 **512: 0.2913%, 1024: 0.1864%** 개선됐다.
서명·검증에는 의미 있는 성능 변화가 관찰되지 않았다. H0/L2 원본은 변경하지 않았다.

## 1. 구현 범위와 비교 기준

암호 C/H/S 31개 중 변경 파일은 [kgen_mp31_cm55.s](kgen_mp31_cm55.s) 하나다.

- H0: 최신 L2 + M1_improve, 각 iNTT 레이어에서 절반 보정.
- H1: 동일한 2-layer iNTT에서 중간 절반 보정을 제거하고 마지막 레이어에 `n^-1 mod p` 보정 통합.
- `igm`은 원본 half-scaled 상수를 유지한다. 읽은 root만 레지스터에서 복원한다.
- 마지막 차분 root에는 scaling을 미리 곱하고, 마지막 합에는 scaling 곱셈을 추가한 뒤 저장한다.
  전체 배열을 별도로 다시 순회하는 scaling pass는 없다.
- forward NTT, logn4/6 전용 forward 경로, M1 Montgomery의 `VHADD`, logn<4 C fallback,
  q=12289 `mq_cm55.s`, FFT/sampler/CRT/Bezout은 변경하지 않았다.
- H1 산술은 어셈블리에 직접 작성했다. H0/H1 알고리즘을 빌드 옵션·다른 후보 소스 링크로 선택하지 않는다.
  공용 빌드·보드 검증 harness만 재사용한다.

[구현 수식·레지스터·상수시간 검토](IMPLEMENTATION.md)에 상세 원리가 있다.

성능 대조군은 [H0 전체 복사본 + 주소 정렬용 padding](../experiments/h0_layout/README.md)이다.
H0 원본은 그대로 보존하고, 대조군 복사본의 iNTT return 뒤에 실행되지 않는 공간만 추가했다.
padding으로 상수 거리가 늘면서 H0의 ADR 두 개가 넓은 인코딩으로 조립된다(970 → 974 B).
따라서 아래 수치는 과거 L2 로그가 아니라 **이 주소 통제 대조군을 새로 측정한 결과**다.
perf/audit/NTRU 진단 ELF 각각에서 iNTT 슬롯 밖의 모든 allocated section 주소·크기·바이트가
H1과 동일한 것을 검사했다. 이 비교는 함수 위치 변화가 서명·검증에 미치는 영향을 통제한다.

## 2. 빌드·보드 조건

| 항목 | H0와 H1의 공통 조건 |
|---|---|
| 실제 보드 | NUCLEO-N657X0-Q, STM32N657, Cortex-M55 r1p1 |
| ST-LINK | `003C00223335510735383531` |
| CPU / SYSCLK / HCLK | 800 / 400 / 200 MHz, runtime clock decode 확인 |
| 메모리 | ITCM 256 KiB에 코드, DTCM 256 KiB에 상수·데이터·스택 |
| 캐시 / ECC | I/D cache OFF (`CCR=0x611`), TCM ECC ON (`MSCR=0x1300a`) |
| 컴파일러 | GNU Arm GCC 15.2.1 20251203 (15.2.Rel1) |
| 주요 옵션 | `-mcpu=cortex-m55 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16`, 최종 `-O3`, `-fno-reorder-functions` |
| MVE 경로 | `FNDSA_MVE_MP31=1`, H1 내부 C 18개 + 어셈블리 6개 직접 컴파일 |
| 공용 환경 | 고정 mlkem-native `637d076aa113d8faaec2277ed4a46b657acaf35f`, Zephyr 4.4.1 기반 기존 L2 harness |
| 설정 일치 | perf/audit 모두 기존 L2와 Kconfig byte-identical |
| 전체 API 성능 | 크기별·API별 10 batch × 10회 = 100회, batch마다 10회 warm-up |
| 입력 | batch별 결정적 seed 10개, H0/H1 동일; batch 내부에서는 같은 seed 반복 |
| 시간 측정 | 기존 Zephyr 64-bit cycle timer, interrupt enabled; DWT는 사전 timer 교차검사에만 사용 |
| 집계 | 10개 batch 평균의 upper median(정렬 후 6번째), 원시 total/calls로 계산 |

따라서 100회는 서로 다른 키 100개가 아니라 **10개 입력을 각각 10번 측정한 것**이다.
성능용 perf와 산술 audit 펌웨어는 분리했다. 감사용 probe는 perf에서 사용하지 않는다.
실제 build manifest에 전체 compile command와 해시가 남아 있다.

## 3. 전체 API — 각 100회

단위는 cycles/call. 개선율은 `(H0-H1)/H0×100`; **양수는 빨라짐, 음수는 느려짐**이다.

| 크기 | 연산 | H0 주소 통제 대조군 | H1 | 개선율 |
|---|---|---:|---:|---:|
| 512 | 키생성 | 46,657,970.40 | 46,522,074.80 | **+0.291259%** |
| 512 | 서명 | 17,194,827.10 | 17,194,828.30 | −0.000007% |
| 512 | 검증 | 323,070.30 | 323,130.30 | −0.018572% |
| 1024 | 키생성 | 244,269,933.70 | 243,814,522.10 | **+0.186438%** |
| 1024 | 서명 | 36,835,754.70 | 36,835,754.10 | +0.000002% |
| 1024 | 검증 | 624,964.30 | 624,964.30 | 0.000000% |

같은 seed끼리 비교한 키생성 개선율도 10개 batch 모두 양수다.
512는 0.1981~0.3171%, 1024는 0.1112~0.2640%다.
100회 전체 산술평균을 사용하면 각각 0.2635%, 0.1710% 개선이다.
입력별 NTRU 재시도 횟수가 달라 키생성의 입력 간 편차가 크므로 통계량을 혼용하면 안 된다.

서명·검증은 이 RNS iNTT를 호출하지 않으며 바이너리도 주소까지 동일하다.
검증의 미세 차이는 batch별로 양·음 방향 모두 나타난다(512 약 ±0.036% 이내).
이를 H1의 알고리즘상 성능 손실/이득으로 해석할 근거는 없다.
독립 세션을 여러 번 반복해 통계적 유의성을 입증한 결과는 아니다.

## 4. iNTT 단독 — logn별

`PRIMES[0]`에서 logn/방향별 10 batch × 100회.
아래는 각 batch `total/100`의 upper median이며 단위는 cycles/call이다.
배열 `gm/igm` 생성은 타이밍 밖이고, 함수 안에서 하는 root 복원·twist 준비·최종 보정은 포함된다.

| logn | n | H0 iNTT | H1 iNTT | 개선율 |
|---|---:|---:|---:|---:|
| 4 | 16 | 429.80 | 389.80 | +9.3067% |
| 5 | 32 | 895.80 | 847.80 | +5.3583% |
| 6 | 64 | 1,977.80 | 1,748.80 | +11.5785% |
| 7 | 128 | 4,424.80 | 3,998.80 | +9.6276% |
| 8 | 256 | 9,876.80 | 8,615.80 | +12.7673% |
| 9 | 512 | 22,023.80 | 19,533.80 | +11.3060% |
| 10 | 1024 | 48,507.80 | 42,014.80 | +13.3855% |

forward NTT upper median은 모든 logn에서 H0/H1이 정확히 같다.
logn4..10 순서로 `343.82, 772.82, 1614.82, 3699.82, 8180.82, 18255.82, 39960.82` cycles다.
산술 정확성은 아래처럼 전 소수에 대해 검사했지만, 이 단독 속도 표는 전 소수 평균이 아니다.

## 5. NTRU solve 전체 — 별도 진단

`solve_NTRU`의 진입·종료만 계측했다. 내부 NTT별 계측은 넣지 않았다.
각 크기 **10개 결정적 seed**로 생성한 키의 모든 NTRU 재시도 시간을 합산했다.
아래는 `NTRU_TOTAL.total / 10`, 즉 **키 1개당 NTRU solve 누적 시간의 평균**이다.
위 API 100회 성능과는 별도 펌웨어/집계이며 계측 오버헤드를 빼지 않았다.

| 크기 | H0 cycles/key | H1 cycles/key | 개선율 | 두 후보의 NTRU 호출 수 / 키 10개 |
|---|---:|---:|---:|---:|
| 512 | 41,508,111.60 | 41,371,057.20 | **+0.330187%** | 모두 11회 |
| 1024 | 185,035,551.30 | 184,586,424.10 | **+0.242725%** | 모두 17회 |

키 fingerprint는 512 `b69b316a`, 1024 `bf1ee4eb`로 두 후보가 같다.
이는 진단의 입력·산출물 일치 확인이며 암호학적 KAT를 대체하지 않는다.
별도의 SHAKE256 KAT/digest 검증은 perf/audit에서 수행했다.

해석: 빨라진 것은 NTRU solve 전체가 아니라 **그 안의 RNS iNTT**다.
forward NTT, CRT, Bezout, 고정소수점 FFT 등은 그대로다.
따라서 iNTT의 5~13% 개선이 키생성 전체의 같은 개선율로 이어지지 않는다.
이 진단은 전체 NTRU 시간만 측정하므로 새로운 내부 연산비중표로 해석하면 안 된다.

## 6. 검증 결과와 한계

| 검사 | 실제 결과 | 범위/한계 |
|---|---|---|
| RNS NTT/iNTT 정확성 | PASS; 308개 소수 × logn4..10 = 2,156개 변환 세트, forward/inverse/roundtrip mismatch 0 | 기존 scalar C oracle과 비교, 모든 가능한 입력의 전수검사는 아님 |
| rounding Montgomery | PASS; 18,923,520 lane case, mismatch 0, range error 0 | canonical/signed 입력 및 경계값 검사, 기존 M1 매크로 유지 |
| 정수 오차 | 위 검사에서 modular error 0 및 inverse bit-exact | 부동소수점 근사 연산을 도입하지 않음 |
| q=12289 NTT | 512/1024 PASS | 기존 mq 경로 회귀검사 |
| KAT/digest | H0/H1 perf/audit 모두 host digest 일치; full의 20개 batch digest도 서로 일치 | 기존 benchmark의 결정적 벡터; upstream `test_fndsa` 전체나 FIPS 인증 시험을 수행했다는 뜻은 아님 |
| 서명검증·변조 거부 | PASS | 정상 서명 및 signature bit 변조; audit에는 메시지 변조 검사도 포함 |
| 보드 실행 | 모두 exit 0, CFSR/HFSR/AFSR 0, ECC 유지 | 이번 실행에서 fault 없음 |
| 상수시간 구조 | 정적 소스/디스어셈블리 검토 완료 | 새 분기·주소는 공개 logn/loop index/bound에만 의존; 기존 VPT 정규화 유지 |
| 동적 누출/형식적 상수시간 증명 | **미수행** | 정적 검토와 구분; 키생성 전체가 상수시간이라는 주장 아님 |

새 iNTT에 coefficient-dependent branch/address, 정수 나눗셈, FP 변환/계산,
외부 함수 BL/BLX 호출, 계수 stack spill을 추가하지 않았다.
공개 logn<4의 기존 C fallback은 그대로다.
[perf 정적 판정](../results/static_audit/perf_audit.json),
[audit 정적 판정](../results/static_audit/audit_audit.json),
[iNTT disassembly](../results/static_audit/perf_intt_disassembly.txt)에 근거를 보관했다.

## 7. 메모리와 소스 식별

| 항목 | 결과 |
|---|---:|
| H1 iNTT 함수 크기 | 1,400 B |
| 원본 H0 iNTT 함수 크기 | 970 B (주소 통제 복사본 974 B) |
| 원본 H0 대비 H1 전체 ITCM 증가 | alignment 포함 432 B |
| perf ELF ITCM 사용 | 109,252 / 262,144 B |
| perf ELF DTCM 사용 | 225,728 / 262,144 B |
| audit ELF ITCM / DTCM | 115,064 / 234,304 B |
| iNTT stack frame | 112 B, H0와 동일 |
| 추가 scratch 배열 / DTCM 증가 | 없음 / 0 B |

주소 통제 대조군은 padding을 넣었으므로 H1과 동일한 ITCM 크기다.
정상 H0 크기와 비교한 증가량을 그 대조군 크기 차이(0 B)와 혼동하면 안 된다.
공간은 두 TCM 모두 범위 안이며 H1의 이득은 코드 약 432 B 증가와 교환된다.

```
H1 kgen_mp31_cm55.s SHA256
c574a589db5d1eca36e711cec10cbe81c8761a09d4779eebce415e87d6d11872

H0 주소 대조군 perf ELF SHA256
5710acd160a93c6aeb451fb5c6fcd787dbf96ee0f1b13a795414cdd8d4ffe467

H1 perf ELF SHA256
7b375800022f1de5a83b26f678e3bafb614e137dc25d61e369b59b63e5f24594

공통 Kconfig SHA256
29add21e434a3054715e66a9711d44653b8362c0370b249dfbfd5744d14eb0ca
```

## 8. 원시 로그·재현

- [H0 산술 audit 로그](../experiments/h0_layout/profiling/results/h0_layout-final_v1-audit/runs/pilot-20260915T103343Z/raw.log)
- [H1 산술 audit 로그](profiling/results/h1-h1_final_v1-audit/runs/pilot-20260915T102921Z/raw.log)
- [H0 full 100회 로그](../experiments/h0_layout/profiling/results/h0_layout-final_v1-perf/runs/full-20260915T103603Z/raw.log)
- [H1 full 100회 로그](profiling/results/h1-final_v1-perf/runs/full-20260915T104516Z/raw.log)
- [H0 NTRU 진단 로그](../experiments/ntru_total/h0_layout/results/control/runs/20260915T104902Z/raw.log)
- [H1 NTRU 진단 로그](../experiments/ntru_total/h1/results/control/runs/20260915T104937Z/raw.log)
- [기계 판독 비교 결과·batch 값·해시](../results/comparison.json)
- [H1 build manifest](profiling/build/m55-perf/h1_build.json)
- [H1 빌드·보드 재실행법](profiling/README.md), [NTRU 진단 재실행법](../experiments/ntru_total/README.md)

각 run 폴더에 raw log, 판정 JSON, 측정 소스, ELF, map, config가 함께 있다.
저장된 결과를 다시 집계하려면 저장소 루트에서 실행한다(보드 접근 없음).

```sh
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/audit_scaling.py perf
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/audit_scaling.py audit
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/summarize_scaling.py
```

결론: **H1 구현 및 이번 검증·측정은 완료**다. 작은 폭이지만 10개 입력 모두에서 키생성이 개선됐다.
이 결과만으로 H0/L2 또는 통합 ref를 자동 교체하지 않았으며, H1 후보 안에만 구현을 유지한다.

## 9. 검증 도구 보강 — 성능 구현 변경 없음

2026-09-15 코드 검토에서 발견한 두 문제를 수정했다.

- NTRU 진단 실행기가 C 파일뿐 아니라 모든 C/H/S와 생성 C·ELF·설정의 빌드 당시 해시를
  실행 전후 및 archive 생성 후에 확인한다. 재빌드 누락·실행 중 변경은 성공 처리하지 않는다.
- 산술 parser는 오류 0뿐 아니라 변환 2,156세트·rounding 18,923,520건·배치별 100회,
  cycle 값과 중복/누락도 검사한다. 결과 집계기도 원시 audit 로그를 이 parser로 재검사한다.

호스트 회귀검사 21개 통과. H0/H1 진단 펌웨어를 새 절차로 다시 빌드했으며
각 ELF 전체와 암호 소스가 기존 측정 archive와 byte-identical임을 확인했다.
기존 H0/H1 audit 원시 로그도 강화된 검사에 통과했고 위 성능 수치는 변하지 않았다.
기존 archive·원시 로그·기존 판정 JSON은 덮어쓰지 않았다.
**이 보강에서는 보드 재측정을 하지 않았고 암호 C/H/S도 변경하지 않았다.**

[NTRU 빌드 일치 검사](../experiments/ntru_total/README.md),
[회귀검사 코드](../tests/test_validation.py),
[검증 도구 사용법](profiling/README.md)을 참고한다.
