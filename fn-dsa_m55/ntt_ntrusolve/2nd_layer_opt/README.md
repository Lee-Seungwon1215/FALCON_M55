# NTRU solve Stage 2 — RNS NTT/iNTT layer 병합

이 단계는 **키생성 → NTRU solve → 31-bit 소수별 `mp_NTT()` / `mp_iNTT()`**만 대상으로 한다.
CRT, Bezout, FFT, sampler, q=12289의 `mq_cm55.s`는 바꾸지 않았다.

- `L2_two_layer`: `M1_improve` 기반 2-layer 기준 + 이번 logn=4/6 전용 제어 경로.
- `L3_three_layer`: 같은 소스에서 `kgen_mp31_cm55.s`만 직접 수정한 3-layer 실험군이다.
- [현재 L2/L3: logn=4/6 제어 비용 개선·정확성·실측](SMALL_LOGN_RESULT.md)
- [직전 L3: forward NTT 추가 개선 및 재측정 — 과거 기록](NTT_TUNING_RESULT.md)
- [초기 L2/L3 비교와 layer 위치 실험 — 과거 기록](result.md)

## 2026-09-15 logn=4/6 작은 크기 개선

두 폴더의 assembly에 동일한 `fndsa_mp_NTT_small` 경로를 직접 작성했다.
logn=4는 2+2, logn=6은 2+2+2이며 레이어 선택표·카운터 stack 접근을 제거했다.
CT2 산술/메모리 명령 순서는 유지했고 명령 스케줄링·Slothy는 적용하지 않았다.
logn4/6 직접 cycles는 양쪽 모두 343.82 / 1614.82다.
logn5에는 7 cycles 분기 비용이 추가되며, logn>=7 및 iNTT median은 유지된다.
logn<4의 계산은 기존 C fallback이지만 진입 경로는 달라졌다.
최신 비교는 `experiments/small_hot_control` 대 `experiments/small_final`이다.
두 후보의 전 소수 오차·KAT·서명 회귀와 각 API 100회 측정을 완료했다.
배치 일치 비교에서 키생성은 개선됐지만, 직전 원본 대비 서명 불이익이 있으므로 전체 폴더를 자동 승격하지 않는다.
초기 L2와 달리 현재 L2는 더 이상 M1-improve와 byte-identical하지 않다.
원본·중간 결과 및 다른 단계 폴더는 보존했다.

## 이전 forward NTT 추가 개선 — L3

현재 `L3_three_layer/kgen_mp31_cm55.s`에는 초기 L3에 더해 다음 세 변경이 들어 있다.

1. 뒤 절반 계산에서 `q6/q7`을 직접 사용하여 tile당 불필요한 `VMOV` 2개 제거.
2. forward 전용 `MP31_FLOAD/FSTORE`에서 오른쪽 절반 base 주소를 재사용.
3. 공개 `logn`으로 읽는 CT3 시작-layer bit mask로 forward 계획 선택/dispatch 단축.

병합 계획, M1 Montgomery와 범위 보정, inverse의 모든 명령은 그대로다.
순차 후보를 실제 보드에서 각각 검사·측정했고, 원래 L3도 다시 100회 측정했다.
forward 마지막 CT2 앞의 실행되지 않는 `.org` padding으로 기존 CT2와 이후 모든 코드의
주소/바이트를 보존했다. 다른 함수의 배치 변화가 이번 전후 비교에 섞이지 않게 하는 장치이며,
외부 링크나 빌드옵션으로 다른 후보를 선택하는 방식이 아니다.
NTT 내부 명령 배치는 변하므로 모든 차이를 개별 명령 지연으로만 해석하지는 않는다.

이 중간 결과는 `experiments/ntt_final`에, 초기 L3는 기존 `results/l3`와
`experiments/ntt_before`에 보존했다. 이 중간 작업 당시에는 L2를 변경하지 않았다.

## 논문과 기존 mq 코드에서 가져온 부분

1. [Polynomial multiplication on embedded vector architectures](../../../REFERENCE/m55_ntt-ftt_opt.pdf), §6.4.2, pp.17–18:
   2-layer 병합, scalar GPR의 root/twist, 마지막 2-layer의 VLD4 사용.
   이 논문은 레지스터 spill 때문에 3-layer는 구현하지 않았다고 명시한다.
2. [Fast and Clean / SLOTHY](../../../REFERENCE/m55_slothy.pdf), §8.2.2–8.2.4, pp.32–35:
   32-bit Dilithium NTT의 3-layer 및 제한된 spill을 다룬다(Listing 11).
   표 3은 2+2+2+2와 3+3+2를 비교한다. 이 단계에서는 그 **병합·레지스터 관리 발상**을 사용했고, SLOTHY 자체는 실행하지 않았다.
3. [기존 mq_cm55.s](../../ntt_opt/mq_cm55.s): 앞 절반을 먼저 완성한 뒤 뒤 절반을 계산하는 depth-first 흐름과 원래 배열의 중간값 저장 방식을 참고했다.

논문의 Dilithium/Kyber modulus와 여기의 거의 31-bit인 RNS 소수는 다르다.
따라서 논문의 lazy reduction, 3-instruction Barrett, non-canonical 출력 순서는 가져오지 않았다.
기존 M1의 R=2^32 Montgomery, 범위 보정과 정확한 출력 순서를 유지했다.
새 코드의 **두 벡터 중간 저장 배치**는 위 자료를 바탕으로 설계한 우리 구현이며, 논문 코드를 그대로 복사한 것이 아니다.

## L3 구현

- MVE `4×32-bit` lane. q=12289 코드의 `8×16-bit`와 다르다.
- `MP31_SMONT`: root와 twist를 `r0`, `r6`으로 공급한다. 기존 M1과 같은 VMUL → VQRDMULH ×2 → VHADD → 음수 보정이다.
- 7개의 root/twist 쌍을 모두 레지스터에 보관하지 않고 사용 순서대로 읽는다.
- 3-layer CT: 4개 sum과 2개 difference를 유지하고, 나머지 difference 2개만 원래 배열에 임시 저장한다.
- 3-layer GS: 앞 절반의 2개 결과를 유지하고 2개만 임시 저장한 뒤, 뒤 절반을 계산하고 최종 pair를 차례로 저장한다.
- 32개 계수 tile당 벡터 load/store: 최초 load 8 + 임시 store 2 + reload 2 + 최종 store 8 = 20회.
- 별도의 계수 scratch 배열은 없다. 함수 지역 스택은 공개 loop 상태용 16바이트이고 ABI 레지스터 저장 104바이트가 별도로 있다.
- 매 butterfly의 canonical `[0,p)` 결과, GS signed difference `(-p,p)`, 단계별 modular half, gm/igm와 최종 메모리 순서를 유지한다.
- forward 마지막 두 layer / inverse 첫 두 layer의 VLD4/VST4는 유지한다. `logn<4`는 기존 C 경로다.

L2와 L3 비교는 병합만의 이론적 효과가 아니다. L3 구현에 필요한 scalar root 공급, 공개 dispatch 및 코드 배치 변경도 포함된다.
동일 scalar-root L2 대조군은 이번 단계에서 만들지 않았다. 따라서 결과를 “3-layer만의 인과적 개선율”로 표현하면 안 된다.

## 최종 L3 계획

표는 **실제 실행 순서**다. NTRU solve 안에서는 512/1024 키생성 모두 여러 logn을 호출한다.

| logn | forward NTT | inverse NTT |
|---:|---|---|
| 4 | 2+2 | 2+2 |
| 5 | 3+2 | 2+3 |
| 6 | 2+2+2 | 2+2+2 |
| 7 | 2+3+2 | 2+3+2 |
| 8 | 3+3+2 | 2+3+3 |
| 9 | 2+2+3+2 | 2+3+2+2 |
| 10 | 2+3+3+2 | 2+3+3+2 |

`experiments/early`, `middle`, `late`에 시험한 계획의 원본 assembly와 보드 로그가 있다.
`results/l3_audit`는 위 조합을 처음 검증한 **추가 개선 전** 버전이다.
현재 소스의 검증은 `experiments/small_final/results/l3_audit`를 참조한다.
고정된 2-layer 경계를 유지하면서 logn 7/9/10의 3-layer 위치를 비교했으며,
모든 가능한 radix 분할·경계 변경·scheduling을 전수 탐색한 것은 아니다.

## 재실행

암호 구현의 선택은 `.s` 안에 직접 적혀 있다. 아래 스크립트는 **폴더 전체를 빌드/측정하는 도구**이며 다른 후보의 kernel을 연결하지 않는다.
보드는 한 개이므로 board runner는 동시에 실행하면 안 된다.

```sh
bash fn-dsa_m55/ntt_ntrusolve/2nd_layer_opt/build_layer.sh l3_audit
python3 fn-dsa_m55/ntt_ntrusolve/2nd_layer_opt/audit_small_ntt.py l3_audit --label small_repeat
python3 fn-dsa_m55/ntt_ntrusolve/2nd_layer_opt/run_layer.py l3_audit pilot --label small_repeat
bash fn-dsa_m55/ntt_ntrusolve/2nd_layer_opt/build_layer.sh l3
python3 fn-dsa_m55/ntt_ntrusolve/2nd_layer_opt/audit_small_ntt.py l3 --label small_repeat
python3 fn-dsa_m55/ntt_ntrusolve/2nd_layer_opt/run_layer.py l3 pilot --label small_repeat
python3 fn-dsa_m55/ntt_ntrusolve/2nd_layer_opt/run_layer.py l3 full --label small_repeat
```

L2 재측정은 위 `l3`를 `l2`로 바꾼다. 기존 `small_final` 기록 보존을 위해 재실행 label은 새로 정한다.
`audit_small_ntt.py`는 보존된 `small_hot_control` ELF와 현재 빌드의 주소·바이트 및 정적 구조를 비교한다.
`summarize_small_ntt.py`는 보존된 original/control/small_final 측정을 집계한다.
label을 생략하면 초기 결과의 validated 포인터를 갱신하므로 위처럼 별도 label을 사용한다.
이전 `audit_layer.py` / `summarize_layer.py` 출력은 초기 실험 기록으로 보존했다.
이전 `audit_ntt_tuning.py`는 이번 작은 경로를 추가하기 전 L3용이므로 현재 소스에 그대로 적용하지 않는다.

`full`은 같은 ELF와 소스 해시의 `pilot`이 먼저 통과해야 실행된다.
최종 실행 폴더에 raw log, 판정 JSON, assembly, ELF, map, Kconfig를 보관한다.
audit 빌드에는 산술 self-test가 들어가고 full 성능 빌드에는 들어가지 않는다.
상수시간 검사는 정적 구조 검사다. 통계적 timing leakage 검사나 형식적 증명, 물리적 부채널 보안 증명은 수행하지 않았다.
