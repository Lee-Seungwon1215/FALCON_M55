# Stage 2 추가 개선 — forward NTT의 복사·주소·dispatch 비용

> **이전 실험 기록.** 이 문서의 “현재”는 logn=4/6 전용 경로를 추가하기 전 시점을 뜻한다.
> 최신 L2/L3 소스와 측정은 [SMALL_LOGN_RESULT.md](SMALL_LOGN_RESULT.md)를 참조한다.

측정일: 2026-09-15. 실제 연결된 NUCLEO-N657X0-Q / STM32N657 / Cortex-M55 r1p1.

## 결론

구현, 순차 후보 측정, 최종 보드 검증과 **키생성·서명·검증 각각 100회 측정**을 완료했다.
현재 소스는 [L3_three_layer/kgen_mp31_cm55.s](L3_three_layer/kgen_mp31_cm55.s)다.

- NTT의 `logn=5,7,8,9,10`은 이제 L2보다 **2.5855~3.5082% 빠르다**.
- `logn=4/6`은 개선 전 L3보다는 빨라졌지만, L2보다 각각 1.5965% / 0.7225% 느리다.
- 전체 키생성은 수정 전 L3 대비 512 **0.0910%**, 1024 **0.0461%** 개선됐다.
  L2 대비로도 각각 **0.0564% / 0.0303% 개선**으로 역전했다. 두 크기 모두 동일 seed 10개 배치에서 전부 이겼다.
- **iNTT는 수정하지 않았다.** 코드 및 직접 측정 median이 수정 전 L3와 같다.
- 서명/검증의 이번 전후 차이는 작고 일정한 개선 방향이 없다. 기존 L3의 L2 대비 서명 약 1.29% 악화는 남아 있다.

따라서 **forward NTT의 실제 개선은 확인했지만, 이 폴더 전체를 모든 API의 새 기준으로 자동 채택하지는 않는다.**
현재 L3에 변경을 남겼고 L2, 1단계 후보, `ntt_opt` 및 다음 단계 폴더는 변경하지 않았다.
이전 L3 결과는 [초기 보고서](result.md)와 원본 소스/ELF/로그에 보존했다.

## 1. 직접 구현한 세 변경

암호 소스 변경은 `kgen_mp31_cm55.s` 하나다. 별도 C 함수, intrinsics, 후보별 외부 include나 링크 선택을 추가하지 않았다.
측정·감사·집계 Python 스크립트와 문서는 재현용이며 암호 실행 경로가 아니다.

| 순서 | 이전 | 현재 | 변경 범위 |
|---|---|---|---|
| 1. 복사 제거 | 뒤 절반의 q6/q7 값을 q0/q1로 복사한 뒤 계산 | q6/q7에서 바로 계산하고 해당 결과를 저장 | CT3 tile당 VMOV 2개 제거 |
| 2. 주소 재사용 | 각 stream load/store마다 계수 주소 재계산 | r10에 오른쪽 절반 base를 한 번 계산하고 재사용. stream 0/4는 base에 직접 접근 | forward 전용 MP31_FAT/FLOAD/FSTORE |
| 3. 공개 dispatch 단축 | logn별 compare chain으로 nibble 계획 생성, pass마다 shift/store | 공개 logn으로 CT3 시작-layer mask를 읽고 현재 layer bit 검사 | MP31_PLAN_F와 forward outer loop |

코드 위치는 주소 매크로 약 182행, 계획 선택 229행, forward 진입/dispatch 273행,
CT3 본체 363행, q6/q7 직접 사용 409행, mask/padding 443행이다.

forward의 공개 mask는 `logn=4..10`에서 `0,1,0,4,9,16,36`이다.
bit 번호는 이미 소비한 layer 수다. 실제 계획은 기존과 같은
`22 / 32 / 222 / 232 / 332 / 2232 / 2332`이며 자동 검사로 재확인했다.
logn<4의 기존 C fallback은 그대로다.

M1 rounding Montgomery, canonical `[0,p)` 보정, root/twist 값, 배열 순서,
inverse의 signed difference 및 매 단계 half를 바꾸지 않았다. 3단계 inverse scaling을 진행한 것이 아니다.
CRT/Bezout/FFT/sampler/q=12289 NTT도 그대로다.

병합·depth-first 처리의 논문 출처는 [설계 README](README.md#논문과-기존-mq-코드에서-가져온-부분)에 있다.
이번 복사 제거, base 재사용 및 mask 배치는 그 위에 적용한 **자체 코드 분석·보드 실험 결과**이며,
논문에서 이 세 코드 변경이나 아래 개선율을 그대로 가져왔다고 주장하지 않는다.

## 2. 순서대로 측정한 NTT cycles

각 logn/방향에 **10 batches × 100 calls**. `total/100`의 median이다.
로그의 정수 `per_call` 버림값 대신 원래 total을 사용했다.
첫 번째 RNS 소수의 성능이며 308개 소수 전체의 평균 성능은 아니다.
함수 내부 root/twist 준비와 진입/종료·dispatch가 포함되고, 외부 gm/igm 생성은 제외된다.

| logn | L2 | 수정 전 L3 | ① 복사 제거 | ② 주소도 재사용 | ③ dispatch도 변경 = 최종 | 최종 vs L2 |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 375.82 | 384.82 | 384.82 | 384.82 | 381.82 | -1.5965% |
| 5 | 765.82 | 769.82 | 766.82 | 745.82 | 741.82 | +3.1339% |
| 6 | 1660.82 | 1681.82 | 1681.82 | 1681.82 | 1672.82 | -0.7225% |
| 7 | 3699.82 | 3699.82 | 3687.82 | 3603.82 | 3589.82 | +2.9731% |
| 8 | 8180.82 | 8274.82 | 8226.82 | 7890.82 | 7893.82 | +3.5082% |
| 9 | 18255.82 | 18224.82 | 18176.82 | 17840.82 | 17783.82 | +2.5855% |
| 10 | 39960.82 | 40387.82 | 40195.82 | 38851.82 | 38836.82 | +2.8128% |

양수는 cycles 감소, 음수는 느려짐이다. `100 × (기준 − 후보) / 기준`으로 계산했다.
③을 별도 최종 빌드로 재검증·재측정했고 위 7개 median이 다시 동일하게 나왔다.
단, logn8은 ②만 적용했을 때보다 ③에서 **3 cycles 느려졌다**. 모든 부분이 단계마다 단조롭게 좋아진 것은 아니다.
이번에는 크기별 ②/③ 혼합을 추가하지 않고 동일한 ③ dispatch 구현을 남겼다.

### 실제 병목에 대한 근거

CT3 tile은 32개 계수를 처리하며 logn5/7/8/9/10에서 총 실행 횟수가 각각 1/4/16/16/64다.

- ①의 절감: tile당 **3 cycles**. 전체 차이가 위 실행 횟수에 정확히 비례했다.
- ②의 추가 절감: tile당 **21 cycles**. 이 차이도 같은 비율로 관측됐다.
- 따라서 이 구현에서는 **불필요한 벡터 복사와 반복 주소 계산이 실제 비용이었다**는 실측 근거가 있다.

이는 해당 명령 배치에서 관측한 차이다. 모든 MVE/스칼라 명령의 일반적 latency를 측정했다는 뜻이 아니다.
forward 내부 명령 정렬도 바뀌므로 전체 차이를 개별 명령 지연이나 특정 PMU stall로 분해해 확정하지는 않았다.

## 3. iNTT는 유지

수정 전 L3, ①, ②, ③, 최종 빌드 모두 아래 median이 같았다.

| logn | L2 iNTT | 수정 전/후 L3 iNTT | L2 대비 개선율 |
|---:|---:|---:|---:|
| 4 | 429.80 | 437.80 | -1.8613% |
| 5 | 895.80 | 892.80 | +0.3349% |
| 6 | 1977.80 | 1997.80 | -1.0112% |
| 7 | 4424.80 | 4406.80 | +0.4068% |
| 8 | 9876.80 | 9837.80 | +0.3949% |
| 9 | 22023.80 | 21909.80 | +0.5176% |
| 10 | 48507.80 | 48363.80 | +0.2969% |

이 이득은 초기 L3부터 있던 결과이지 이번 forward 수정의 추가 이득이 아니다.

## 4. 전체 키생성·서명·검증 100회

수정 전 L3와 수정 후 L3 모두 이번에 production 펌웨어로 다시 측정했다.
L2 열은 같은 설정의 기존 2026-09-15 측정이다. 이번에 L2를 새로 측정하지는 않았다.
각 degree/API마다 **10개 seed × 10회 = 100회**, 각 batch/API에 warm-up 10회가 별도다.
100개의 독립 seed가 아니다. 표는 10개 batch 평균을 정렬한 **6번째 값(upper median)** 이다.
일반 median(5번째와 6번째의 평균)과 개별 batch 값은 comparison.json에 함께 저장했다.

| degree | API | L2 cycles | 수정 전 L3 cycles | 수정 후 L3 cycles | 수정 전 대비 | L2 대비 |
|---:|---|---:|---:|---:|---:|---:|
| 512 | keygen | 46,676,611.9 | 46,692,780.4 | 46,650,269.2 | +0.0910% | +0.0564% |
| 512 | sign | 17,145,561.6 | 17,365,412.4 | 17,365,412.3 | +0.0000% | -1.2823% |
| 512 | verify | 323,017.3 | 323,070.3 | 323,070.3 | 0.0000% | -0.0164% |
| 1024 | keygen | 244,326,106.6 | 244,364,809.8 | 244,252,177.2 | +0.0461% | +0.0303% |
| 1024 | sign | 36,737,446.1 | 37,213,314.4 | 37,213,424.0 | -0.0003% | -1.2956% |
| 1024 | verify | 624,908.3 | 625,018.3 | 624,979.3 | +0.0062% | -0.0114% |

keygen은 양쪽 기준 모두 **10/10 배치에서 개선**됐다. 같은 seed끼리 비교한 절감 범위:

| degree | 수정 전 L3 대비 절감 cycles/call | L2 대비 절감 cycles/call |
|---:|---:|---:|
| 512 | 42,401.6~44,762.9 | 26,233.6~28,440.6 |
| 1024 | 107,182.1~118,302.5 | 64,840.6~78,508.3 |

NTT 안의 일부 경로만 변경했으므로, NTT 직접 개선율이 키생성 전체 개선율이 되지는 않는다.
키생성은 다양한 logn의 NTT/iNTT와 그 밖의 NTRU 연산, 후보 생성/검사 등을 수행한다.
위 값은 NTRU solve 전체나 모든 NTT 호출을 가중 합산한 별도 프로파일링 결과가 아니다.

서명/검증은 RNS NTT를 호출하지 않는다. 이번 전후 비교에서 해당 함수들의 코드와 주소는 동일하다.
서명/검증의 같은 seed 차이는 약 ±110 cycles/call 이내이며, 전 배치에 일관된 개선은 없다.
따라서 표의 미세한 차이를 NTT 최적화로 얻은 서명/검증 이득이라고 보지 않는다.
L2와 L3 사이의 **기존 서명 약 1.29% 차이**는 이 실험으로 해결되지 않았다.
코드 배치 영향이 의심되지만, L2와 L3의 전체 배치를 같게 만든 별도 실험이 아니므로 그 원인을 확정하지 않는다.

## 5. 주소·빌드·메모리 통제

이번 L3 전후 비교는 마지막 CT2 앞의 실행되지 않는 `.org` padding으로 아래를 유지했다.

- `mp_NTT` 진입: `0x10000330`.
- 마지막 CT2: `0x1000090a` (`mp_NTT + 0x5da`).
- `mp_iNTT` 진입: `0x10000a64`.
- **마지막 CT2부터 뒤의 모든 text 바이트가 동일**하고, 전체 alloc section의 주소/크기도 동일하다.
- text 외의 로드되는 section도 동일하다. BSS 등 NOBITS section은 주소/크기를 비교했다.
- audit 및 production ELF에서 각각 검사했다. 초기 L3 production ELF와 이번 수정 전 재측정 ELF 해시도 같다.

새 mask 표는 공개 logn으로 읽는 assembly 내부 22바이트 상수다.
제어 흐름은 표와 padding을 분기하여 건너뛴다. padding을 제거한 별도 크기 최적화는 측정하지 않았다.
**L2와 L3의 전체 주소를 맞춘 것은 아니다.** 이번 추가 변경의 전후 비교를 통제한 것이다.

- 보드 probe: `003C00223335510735383531`.
- CPU 800 MHz / SYSCLK 400 MHz / HCLK·PCLK 200 MHz.
- GCC 15.2.1 20251203 / Zephyr 4.4.1. 동일 Kconfig, LTO 없음.
- `-mcpu=cortex-m55 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard`, 최종 유효 `-O3`.
  공통 명령줄 앞의 `-O2`보다 뒤에 `-O3`가 온다.
- 코드/벡터 ITCM, 전역 rodata·데이터·스택 DTCM. assembly 내부 상수 표는 text에 남는다.
  FLEXMEM ITCM/DTCM 각각 256 KiB. 기존 ITCM 데이터 접근 회피용 startup/rodata 설정 유지.
  즉 **mlkem-native Nucleo 기반 로컬 설정**이며 upstream 무수정 그대로라는 뜻은 아니다.
- 런타임 CCR=`0x611`로 IC/DC enable bit 17/16은 0. Kconfig `ICACHE=y/DCACHE=y`와 구분한다.
- 동일 seed, 반복 수, timer, IRQ 상태 `PRIMASK=0/BASEPRI=0`.
- audit 펌웨어에만 RNS 산술 self-test를 넣었고, 전체 성능에는 production 펌웨어를 사용했다.

| production 메모리 | 수정 전 L3 | 수정 후 L3 |
|---|---:|---:|
| ITCM 점유 | 110,204 B | 110,204 B |
| DTCM 점유(예약 스택 포함) | 225,728 B | 225,728 B |
| 전체 main-stack 실측 상한 | 9,624 B | 9,624 B |
| NTT/iNTT 호출 frame(ABI 저장 포함) | 120 B | 120 B |

DTCM 여유는 36,416 B. 로컬 링커의 별도 코드 128 KiB 상한까지 여유는 20,868 B다.
수정 전 L3의 크기를 padding으로 유지했으므로 이번에 메모리가 줄었다고 주장하지 않는다.

## 6. 정확성·KAT·상수시간 검사

순차 후보와 최종 빌드 모두 보드 audit를 통과했고, 최종 production pilot/full도 통과했다.

| 검사 | 최종 결과 / 범위 |
|---|---|
| 실제 M55 M1 vector 산술 매크로 회귀 | 18,923,520 cases, mismatch/range error 0. 기존 vector 매크로 검사 |
| 실제 M55 RNS transform | 308 primes × logn4..10 = 2,156 forward/inverse 쌍. forward/inverse/roundtrip mismatch 0, 최대 modular error 0 |
| q=12289 NTT 회귀 | 512/1024 mismatch 0 |
| 보드 결정론적 KAT/digest | production pilot 4개, full 22개 digest/AUDIT가 기존 호스트 oracle와 일치 |
| 서명 검증·변조 거부 | pilot/full PASS |
| Fault/ECC | CFSR/HFSR/AFSR=0, TCM_MSCR 시작/끝 0x1300a |
| 정적 구조 감사 | 새로운 계수 의존 scalar branch/address 없음. 공개 mask 계획 검사, iNTT·산술 매크로 불변 확인 |

RNS NTT는 정수 modular arithmetic이며 근사 허용 오차를 두지 않는다. **시험한 결과가 모두 정확히 일치했다.**
위 KAT는 현재 저장소/호스트 oracle 기준이며 미래 표준의 공식 인증을 의미하지 않는다.
호스트 C KAT를 새 MVE assembly의 실행 검사로 대체하지 않았다.

새 r10 base와 r12 주소는 공개 group/stride/lane만 사용한다. 계획 표의 index도 공개 logn이다.
조건 분기는 공개 logn/layer/loop counter/포인터 비교에 의존하며, 기존 계수 보정의 MVE predication은 유지했다.
새 함수 호출, 나눗셈, FP 변환, 계수 vector stack spill을 추가하지 않았다. ABI frame/저장·복원도 같다.

**한계:** 정적 상수시간 구조 감사와 유한 입력 테스트다. 형식적 증명, dudect/TVLA 등의 통계적 timing/leakage 시험,
전력·EM 부채널 시험은 수행하지 않았다. 전체 FN-DSA의 상수시간/보안을 새로 증명한 것이 아니다.

## 7. 원본 로그·재현

- [수정 전 L3 audit](experiments/ntt_before/results/l3_audit/runs/pilot-20260915T074231Z/raw.log)
- [① 복사 제거 audit](experiments/ntt_nomove/results/l3_audit/runs/pilot-20260915T074506Z/raw.log)
- [② 주소 재사용 audit](experiments/ntt_address/results/l3_audit/runs/pilot-20260915T074731Z/raw.log)
- [③ dispatch 단축 audit](experiments/ntt_dispatch/results/l3_audit/runs/pilot-20260915T074857Z/raw.log)
- [최종 audit / 직접 NTT-iNTT cycles](experiments/ntt_final/results/l3_audit/runs/pilot-20260915T075441Z/raw.log)
- [수정 전 L3 새 100회 측정](experiments/ntt_before/results/l3/runs/full-20260915T075212Z/raw.log)
- [수정 후 L3 새 100회 측정](experiments/ntt_final/results/l3/runs/full-20260915T075834Z/raw.log)
- [기존 L2 100회 측정](results/l2/runs/full-20260915T070416Z/raw.log)
- [전체 수치, 일반 median과 paired samples](experiments/ntt_final/comparison.json)
- [production 배치·소스 감사](experiments/ntt_final/production_layout_audit.json)
- [audit 배치·소스 감사](experiments/ntt_final/audit_layout_audit.json)
- [실제 forward disassembly](experiments/ntt_final/production_ntt_disassembly.txt)
- [재실행 명령](README.md#재실행)

각 run 폴더에는 해당 시점의 assembly, ELF, map, Kconfig, raw.log, run.json을 보존했다.
최종 source SHA256: `039964c93023256c96098b91c0275f568d8191072e95ca1488ec76b4d8ee840b`.
최종 production ELF SHA256: `1546c6211c671e6f583461699a1695a76dac5e7378ae4cdfdf556494612879d0`.
최종 audit ELF SHA256: `7d145b9a06e746948a0fab56004b8fe9471d4fe59e4c78c65d90702dc63a9e05`.

실행 중 자동 승인 서비스의 capacity 오류로 호출이 일시 거절된 적이 있다.
대상/펌웨어 확인 후 같은 승인 절차로 재시도하여 정상 종료했다. 이를 보드 fault나 성능 실패로 집계하지 않았다.
