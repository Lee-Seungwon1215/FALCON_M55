# logn=4/6 전용 NTT — 제어 비용 단축

측정일: 2026-09-15. 대상은 NTRU solve의 **forward `mp_NTT()` 중 logn=4/6**이다.
수동 명령 스케줄링, SLOTHY, Montgomery 산술 변경, iNTT scaling은 적용하지 않았다.

## 확인된 직접 측정 결과

L2와 L3의 `kgen_mp31_cm55.s` 안에 동일한 작은 크기 전용 경로를 직접 작성했다.
`logn=4`는 2+2, `logn=6`은 2+2+2로 처리한다. 별도 후보 파일이나 빌드옵션으로 kernel을 선택하지 않는다.

| 후보 | logn | 기존 cycles | 전용 경로 cycles | 절감 | 개선율 |
|---|---:|---:|---:|---:|---:|
| L2 | 4 | 375.82 | 343.82 | 32 | +8.5147% |
| L2 | 6 | 1660.82 | 1614.82 | 46 | +2.7697% |
| L3 | 4 | 381.82 | 343.82 | 38 | +9.9523% |
| L3 | 6 | 1672.82 | 1614.82 | 58 | +3.4672% |

즉, 이 두 크기에서 **L3가 L2보다 느렸던 6/12 cycles 차이가 없어지고 두 후보의 성능이 같아졌다.**
이는 3-layer 병합의 추가 이득이 아니라, 두 후보에 공통으로 적용한 작은 크기 제어 최적화다.
양수 개선율은 `100 × (기준 − 후보) / 기준`이다.

### 다른 크기에 대한 영향

| logn | L2 이전 → 이후 | L3 이전 → 이후 |
|---:|---:|---:|
| 5 | 765.82 → 772.82 | 741.82 → 748.82 |
| 7 | 3699.82 → 3699.82 | 3589.82 → 3589.82 |
| 8 | 8180.82 → 8180.82 | 7893.82 → 7893.82 |
| 9 | 18255.82 → 18255.82 | 17783.82 → 17783.82 |
| 10 | 39960.82 → 39960.82 | 38836.82 → 38836.82 |

**logn=5는 크기 분기 때문에 7 cycles 느려졌다.** L2는 약 0.9141%, L3는 약 0.9436% 증가다.
logn>=7은 원래 진입 경로를 그대로 지나며 위 median이 유지됐다.
logn<4는 원래 C 계산으로 돌아가지만 진입 분기가 추가된다. 해당 크기의 직접 cycles는 이번 표에서 측정하지 않았다.
그 비용도 전체 키생성 측정에는 포함된다.
모든 logn4..10 iNTT의 직접 median은 각 후보의 기존 수치와 같다.

직접 측정은 첫 번째 RNS 소수에 대해 방향/logn별 **10 batches × 100 calls**다.
batch `total/100`의 median이며 로그의 버림 처리된 정수 `per_call`을 쓰지 않았다.
내부 root/twist 준비·진입/종료·분기 비용을 포함하고 외부 gm/igm 생성은 제외한다.
308개 소수 전체의 평균 속도나 키생성 전체 개선율로 해석하면 안 된다.

## 구현 범위

진입 분기는 [L2:127](L2_two_layer/kgen_mp31_cm55.s#L127),
[L3:273](L3_three_layer/kgen_mp31_cm55.s#L273)에 있고, 전용 본체는
[L2:474](L2_two_layer/kgen_mp31_cm55.s#L474), [L3:761](L3_three_layer/kgen_mp31_cm55.s#L761)에 있다.
두 폴더의 최상위 C/H/S 31개를 M1-improve와 대조했으며 차이는 `kgen_mp31_cm55.s` 하나뿐이다.

- 공개 진입부에서 logn<=6을 작은 크기 dispatcher로 보낸다.
- logn<4는 기존 C fallback, logn=5는 원래 NTT 경로로 돌아간다.
- logn=4/6은 `fndsa_mp_NTT_small`이라는 파일 내부 라벨에서 계산한다. 새 공개 C API는 없다.
- 첫 일반 CT2는 group 1개. 이후 stride가 4이면 마지막 CT2로, 16이면 group 4개인 일반 CT2를 한 번 더 실행한다.
- layer counter의 stack load/store, layer 계획표, 2-layer/3-layer 선택 검사를 제거했다.
- 마지막 group 수는 공개 root 포인터의 진행량에서 `(r8-gm)/2`로 구한다. 각각 4와 16이 된다.
- 별도 local stack은 없으며 ABI 저장 104 B만 쓴다. 5번째 인수 p0i는 현재 SP+104에 있다.
- 기존 CT2 butterfly/group 본체 및 마지막 VLD4/VST4 본체의 **산술·메모리 명령 순서는 유지**했다.
- 기존 Montgomery 정규화, canonical 출력과 배열 순서, gm/igm 값은 그대로다.
- iNTT, CRT, Bezout, FFT, sampling 및 q=12289 NTT 소스는 변경하지 않았다.

`.p2align` 및 `adr.w`로 명령 정렬/폭을 명시했지만 load/multiply/add를 서로 교차 배치하거나
software pipeline을 만들지는 않았다. 새 경로는 기존 NTT와 같은 입력 `.text` section에 직접 둔다.
이는 배포 소스 안의 배치이며 외부 링커 파일이나 Makefile로 다른 후보를 불러오는 방식이 아니다.

## 실패 후보도 보존

처음에는 작은 경로를 별도 `.text.fndsa_mp_NTT_small` section에 놓았다.
링크 결과 실제 주소가 0x10010084로 배치됐고, 기존 NTT는 0x10000330이었다.

| L2 시험 | logn4 | logn6 | 판정 |
|---|---:|---:|---|
| 첫 전용 경로: 별도 text subsection | 436.82 | 2097.82 | 느려서 탈락 |
| 명령 폭/정렬 및 제어를 보완, 같은 subsection | 437.82 | 2112.82 | 여전히 느려서 탈락 |
| 보완한 동일 경로를 기존 NTT의 text section에 배치 | 343.82 | 1614.82 | 작은 크기 개선 확인 |

두 번째와 세 번째는 계산·제어 소스가 같고 section 배치가 달라진 비교다.
따라서 배치 영향이 크다는 실측 근거가 있지만, **64 KiB 경계가 원인이라고 단정하거나 특정 버스/캐시 stall을 확정하지 않는다.**
분기 거리와 literal 위치도 달라지며 PMU 원인 분해는 수행하지 않았다.
모든 위 시험은 정확성 검사를 통과했으며, 속도가 느렸던 후보를 선택하지 않았다.

## 전체 키생성·서명·검증 — 각 100회 측정 완료

각 degree/API는 동일한 10개 seed × 10회 = 100회이며, batch마다 10회 warm-up이 별도다.
아래 단위는 cycles/call, 10개 batch 평균을 정렬한 **upper median(6번째 값)**이다.
일반 median과 개별 배치 값도 [comparison.json](experiments/small_final/comparison.json)에 보존했다.

- **직전 원본**: 작은 전용 경로를 추가하기 전 L2 / 직전 forward 개선 후 L3.
- **동일 배치 대조군**: 최종본과 같은 추가 코드·주소를 유지하되 logn4/6은 기존 경로로 실행.
  logn<4는 대조군도 최종본과 같은 C fallback 진입 경로를 쓰므로, 그 추가 비용은 원본 대비 열에 반영된다.
- **최종본**: 같은 배치에서 logn4/6 전용 경로 활성화. logn5의 추가 분기 비용도 포함.
- 개선율은 양수=빠름, 음수=느림.

| 구현 | degree·API | 직전 원본 | 동일 배치 대조군 | 최종본 | 대조군 대비 | 원본 대비 |
|---|---|---:|---:|---:|---:|---:|
| L2 | 512 keygen | 46,676,611.9 | 46,678,572.6 | 46,657,969.4 | +0.0441% | +0.0399% |
| L2 | 512 sign | 17,145,561.6 | 17,169,993.9 | 17,169,884.6 | +0.0006% | -0.1419% |
| L2 | 512 verify | 323,017.3 | 323,070.3 | 323,070.3 | +0.0000% | -0.0164% |
| L2 | 1024 keygen | 244,326,106.6 | 244,333,778.0 | 244,269,931.6 | +0.0261% | +0.0230% |
| L2 | 1024 sign | 36,737,446.1 | 36,786,089.8 | 36,786,089.1 | +0.0000% | -0.1324% |
| L2 | 1024 verify | 624,908.3 | 624,964.3 | 624,961.3 | +0.0005% | -0.0085% |
| L3 | 512 keygen | 46,650,269.2 | 46,652,228.8 | 46,627,222.9 | +0.0536% | +0.0494% |
| L3 | 512 sign | 17,365,412.3 | 17,643,159.8 | 17,643,160.2 | -0.0000% | -1.5994% |
| L3 | 512 verify | 323,070.3 | 323,070.3 | 323,070.3 | +0.0000% | +0.0000% |
| L3 | 1024 keygen | 244,252,177.2 | 244,259,735.8 | 244,182,378.5 | +0.0317% | +0.0286% |
| L3 | 1024 sign | 37,213,424.0 | 37,832,164.5 | 37,832,165.3 | -0.0000% | -1.6627% |
| L3 | 1024 verify | 624,979.3 | 625,070.4 | 625,018.2 | +0.0084% | -0.0062% |

### 해석 및 채택 한계

키생성은 L2/L3, 512/1024 모두 원본 대비와 동일 배치 대조군 대비 **동일 seed 10개 배치 전부 개선**됐다.
대조군 대비 절감은 L2 512/1024 각각 20,603.2 / 63,846.4 cycles,
L3는 25,005.9 / 77,357.3 cycles다. 목표 NTT 구간은 개선됐지만 전체 키생성 개선폭은 작다.

**서명은 이번 RNS NTT를 호출하지 않는다.** 동일 배치 대조군과 최종본 사이의 서명 upper median 차이는
L2 최대 109.3 cycles, L3 최대 0.8 cycles이며 서명 알고리즘 개선으로 해석하지 않는다.
L3 1024 검증의 +0.0084%도 10개 배치 중 3개만 빨랐으므로 안정적인 검증 개선으로 주장하지 않는다.

반면 전용 경로가 없던 직전 원본 대비 서명은 L2 **0.1324~0.1419%**,
L3 **1.5994~1.6627% 악화**됐다. 모든 같은-seed 서명 배치에서 악화됐다.
새 코드 추가로 다른 함수 주소가 변한 대조군에서 이미 이 현상이 나타나므로,
목표 경로의 계산이 서명을 느리게 만든 것이 아니라 **이번 펌웨어의 배치 변경에 따른 불이익과 일치하는 관측**이다.
정확한 instruction-fetch/메모리 내부 원인은 확정하지 않았다.

따라서 **logn4/6 NTT 개선은 달성했지만, 이 두 폴더 전체를 모든 API의 새 기준으로 자동 승격하지 않았다.**
검증된 전용 경로를 L2/L3에 남기고 원본 로그·소스를 보존했다.
1단계 후보, `ntt_opt`, 이후 단계 폴더는 변경하지 않았다.
스케줄링 없이 작은 크기 제어를 개선한 실험으로 구분하며, 배치와 logn5 분기 비용까지
최종 통합 시 채택 여부에 반영해야 한다.

## 정확성·보안 검사

선택한 경로는 L2/L3 모두 실제 M55에서 다음을 통과했다.

- 308 primes × logn4..10 = 2,156 forward/inverse transform 쌍:
  forward/inverse/roundtrip mismatch 0, 최대 modular error 0.
- 기존 M1 vector 산술 매크로 회귀 18,923,520 cases: mismatch/range error 0.
- 기존 q=12289 NTT 512/1024 회귀: mismatch 0.
- pilot의 결정론적 digest/AUDIT 4개가 기존 호스트 oracle와 일치.
- audit와 production pilot을 각각 재검증했고, L2/L3 production full의 digest/AUDIT 22개도 각각 호스트 oracle와 일치.
- 서명검증·변조거부 PASS, CFSR/HFSR/AFSR=0, TCM_MSCR 시작/끝 0x1300a.

상수시간 검사는 정적 구조 감사다. 크기 선택, stride 종료 검사, group/주소 계산은 공개 값에만 의존한다.
계수 의존 scalar branch/address, 새 함수 호출, 나눗셈, FP 변환, 계수 stack spill을 추가하지 않았다.
계수 보정에 쓰는 기존 MVE predication은 유지했다.
**형식적 증명, dudect/TVLA, 전력·EM 누설 검사는 수행하지 않았다.**

audit 및 production의 L2/L3 네 ELF를 각각 배치 일치 대조군과 검사했다.
할당된 section 중 바뀐 것은 진입부 주소 `0x10000330`, `0x10000332`, `0x10000333`의 3 bytes뿐이다.
나머지 할당된 코드/데이터 bytes·주소·크기 및 Kconfig는 각각 대조군과 동일하다.
전용 경로 주소는 L2 `0x10000a60`, L3 `0x100012b0`이다.
이 동일성은 **이번 matched control 대 최종본**에 대한 것이며, 전용 경로가 아예 없던 과거 원본과 동일하다는 뜻은 아니다.

## 조건·메모리

- NUCLEO-N657X0-Q / Cortex-M55 r1p1, probe `003C00223335510735383531`.
- CPU 800 MHz / SYSCLK 400 MHz / HCLK·PCLK 200 MHz.
- GCC 15.2.1 20251203, Zephyr 4.4.1, 최종 유효 `-O3`, LTO 없음.
- `-mcpu=cortex-m55 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard` 유지.
- 코드/벡터 ITCM, 전역 rodata·데이터·스택 DTCM, assembly 내부 작은 상수는 text.
- runtime CCR=0x611: I/D cache enable bit는 0. TCM ECC 활성.
- mlkem-native Nucleo 기반 기존 로컬 startup/rodata 배치 유지. upstream 무수정 구성이라는 뜻은 아니다.
- 같은 설정·입력·timer를 사용하며 산술 self-test는 audit 펌웨어에만 있다.

추가 작은 경로는 상수/비교용 빈 공간을 포함해 **744 B**다.
production ITCM 점유는 L2 108,820 B, L3 110,948 B이고 DTCM 점유는 둘 다 225,728 B다.
DTCM 여유는 36,416 B. 128 KiB 로컬 코드 상한까지의 L3 여유는 20,124 B다.
최종 production full의 stack watermark 사용 상한은 둘 다 9,624 B / 예약 65,536 B로 기존과 같다.
작은 경로의 상수 앞 `.org` 빈 공간은 실행되지 않으며 비교 과정에서 후속 코드 주소를 유지하기 위한 것이다.

## 보존 로그

- [L2 첫 전용 경로](experiments/small_probe/results/l2_audit/runs/pilot-20260915T083528Z/raw.log)
- [L2 정렬/폭 보완](experiments/small_aligned/results/l2_audit/runs/pilot-20260915T083846Z/raw.log)
- [선택한 L2 경로: 정확성·직접 cycles](experiments/small_hot/results/l2_audit/runs/pilot-20260915T084039Z/raw.log)
- [선택한 L3 경로: 정확성·직접 cycles](experiments/small_hot/results/l3_audit/runs/pilot-20260915T084155Z/raw.log)
- [초기 L2 원본 결과](results/l2/runs/full-20260915T070416Z/raw.log)
- [이번 작업 직전 L3 결과](experiments/ntt_final/results/l3/runs/full-20260915T075834Z/raw.log)

각 보드 run 폴더에 실제 소스, ELF, map, Kconfig, raw.log, run.json을 보관했다.
자동 승인 서비스의 capacity 오류로 일부 실행 요청이 거절됐으나, 이를 보드 fault나 실패한 성능 결과로 집계하지 않는다.

### 최종 재검증 및 전체 측정

- [L2 최종 정확성·NTT/iNTT 직접 cycles](experiments/small_final/results/l2_audit/runs/pilot-20260915T085514Z/raw.log)
- [L2 동일 배치 대조군 100회](experiments/small_hot_control/results/l2/runs/full-20260915T084800Z/raw.log)
- [L2 최종 100회](experiments/small_final/results/l2/runs/full-20260915T085635Z/raw.log)
- [L2 production 정적/배치 감사](experiments/small_final/l2_static_audit.json)
- [L2 audit 정적/배치 감사](experiments/small_final/l2_audit_static_audit.json)
- [L3 최종 정확성·NTT/iNTT 직접 cycles](experiments/small_final/results/l3_audit/runs/pilot-20260915T085834Z/raw.log)
- [L3 동일 배치 대조군 100회](experiments/small_hot_control/results/l3/runs/full-20260915T085245Z/raw.log)
- [L3 최종 100회](experiments/small_final/results/l3/runs/full-20260915T085947Z/raw.log)
- [L3 production 정적/배치 감사](experiments/small_final/l3_static_audit.json)
- [L3 audit 정적/배치 감사](experiments/small_final/l3_audit_static_audit.json)

L2 최종 assembly SHA-256: `7f338f2abb7083dcf26c7ffc838d92b67fc02f990bd12f910abde7308d9a6c81`.
L3 최종 assembly SHA-256: `1added18ccbf6b370992a4eacf0f4ac56ac6c2441a8fbaa01234af12d674c7a5`.
