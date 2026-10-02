# 5단계: SLOTHY A/B 실험

이 폴더의 `ref`는 1~4단계가 끝난 `ntt_opt`의 보존본이다.
`slothyA`와 `slothyB`는 각각 **독립적인 전체 소스 트리**이며, 최종 실행 명령은
각 폴더의 `mq_cm55.s`에 직접 들어 있다. 빌드 시 다른 후보의 어셈블리 조각을
include하거나 조합하지 않는다. 기존 `../ntt_opt`는 변경하지 않았다.

| 후보 | 구현 |
|---|---|
| ref | MVE 8×16-bit, 512 232/1024 2222, B1 Barrett, S1B+S2B+S3A |
| slothyA | 위 기준 코드에서 반복 내부 명령 스케줄링·MVE 레지스터 배정 |
| slothyB | A를 출발점으로 반복 경계를 넘는 halving software-pipelining 탐색 |

A/B는 논문의 후보 이름이 아니라 이 실험에서 붙인 이름이다. B는 A의 처리를
포함하므로 별도의 A+B 후보는 없다. 속도가 더 빠른지는 [실측 결과](RESULTS.md)로 판단한다.

후속 [실행 위치 고정 진단](layout_diagnostic/RESULTS.md)도 함께 확인한다.
동일 주소 대조에서 기존 B의 큰 서명 지연은 사라졌으며, 계산 소스 수정 없이
기본/확장 ITCM 배치 영향을 분리했다. 원래 ref/A/B 소스와 실측 ELF는 그대로 보존했다.

## 정확한 적용 범위

두 함수 `fndsa_mqpoly_int_to_ntt`, `fndsa_mqpoly_ntt_to_int` 안의 아래 10개 구간이다.
함수별/키생성·서명·검증별로 다른 코드를 선택하지 않는다.

| 계산 구간 | A | B |
|---|---|---|
| 512 NTT: 첫 CT2 / CT3 / packed CT2 | 반복 내부 최적화 | halving 경계 최적화 시도 |
| 512·1024 NTT: 마지막 2-layer | 반복 내부 최적화 | halving 경계 최적화 |
| 512·1024 iNTT: 첫 2-layer | 반복 내부 최적화 | halving 경계 최적화 |
| 512 iNTT: packed GS2 / GS3 / 마지막 wide GS2 | 반복 내부 최적화 | halving 경계 최적화 시도 |
| 1024 NTT·iNTT: 중간 4개의 2-layer pass | 공유 산술 구간 최적화 | A와 같은 산술 스케줄 유지 |

1024 중간 pass의 full-vector/half-vector 분기는 공개 크기에 따른 안전한 로드 폭
선택이므로 유지했다. **그 구간까지 modulo scheduling을 적용했다는 뜻은 아니다.**
512 NTT CT3 및 iNTT 마지막 wide GS2에서는 현재 해에 실제 반복 간 교차 이동이 0개다.
나머지 6개 halving 구간에서는 반복 간 이동을 확인했다.
구간별 정확한 기록은 `results/comparison.json`의 `coverage`에 있다.

NTT layer 배치, q=12289, Barrett 산술, 8×16-bit lane, `mq.c`의 표는 그대로다.
pointwise multiply, 31-bit NTRU NTT, FFT, sampler, native-double은 이번 범위가 아니다.

## 안전하게 SLOTHY에 전달한 방법

사용한 실제 SLOTHY commit은 `55983e6760e98aece5359055085a7def96c688b7`이다.
보관 위치는 `tooling/slothy`, 별도 Python 환경은 `tooling/venv`다.
SLOTHY/OR-Tools를 사용했으며, 자체 정렬 스크립트를 SLOTHY라고 부르는 것이 아니다.

이 버전의 Armv8.1-M parser가 기존 코드를 전부 인식하지 못하므로
`tooling/fndsa_slothy_adapter.py`에 제한적인 입력 어댑터를 추가했다.

- 대부분은 단일 명령 단위다. `VCMP→VPST→VADDT`, 완전한 VLD2/VLD4/VST4 묶음은
  분리 불가능한 단위로 처리한다. 부분 기록과 연속 Q-register 제약을 보존한다.
- 모든 GPR, q0의 S-register 상태, 부분 D/S-register 사용은 고정한다.
  각 분할 구간의 밖에서 살아 있는 모든 물리 레지스터도 보존한다.
- memory token으로 **모든 메모리 접근의 원래 순서를 보존**한다. 메모리 alias를
  추측하거나 자동 address-offset fixup을 수행하지 않는다. 이 제약 때문에 탐색 범위는 좁다.
- 긴 구간은 48-unit 단위로 나눠 탐색한다. spills는 허용하지 않는다.
- M55 실행 유닛 모델을 바탕으로 미지원 명령 묶음에는 보수적인 비용을 사용한다.
  이 모델의 예상 cycle은 실제 보드 cycle도, Arm의 공식 지연시간 보증도 아니다.

B의 halving 구조는 다음과 같다. `a`, `b`는 A 반복문을 나눈 앞/뒤 부분이다.

```text
원본:  [a; b]를 N회
B:     a; [SLOTHY로 재배치한 b; a]를 N-1회; b
```

선택된 루프의 공개 반복 수는 2 이상이다: 512 wide/packed=16,
512 CT3/GS3=2, 공유 final/first2=512에서 16, 1024에서 32.
추가 padding이나 배열 밖 선행 로드를 가정하지 않는다.
루프 counter를 먼저 한 번 줄이고 끝부분을 별도로 실행한다.
B의 코드 증가로 512 iNTT packed setup의 ADR 거리를 벗어나는 곳에는 가까운
4-byte 주소 상수 하나를 복제했다. twiddle 표 내용·개수와 실행 ADR+LDR 방식은 같다.

이 B 구현은 `SlothyBase`의 선형 최적화로 `b;a` 경계를 푸는 **halving heuristic**이다.
`config.sw_pipelining.enabled=True`인 일반 modulo-scheduling backend를 돌린 결과와는
구분해야 한다. 선택한 방법·패키지 버전·파일 hash는 `tooling/logs/provenance.json`에 기록했다.

## 검증과 재현

```sh
# 생성 결과를 바꾸지 않고 현재 후보를 검사/빌드한다.
tooling/venv/bin/python tooling/check_schedule.py
bash build.sh ref
bash build.sh slothyA
bash build.sh slothyB
tooling/venv/bin/python audit.py

# 동일한 기존 M55 harness; 보드는 하나이므로 순차 실행한다.
../measurement_mlkem_native/env/build-venv/bin/python run.py ref pilot
../measurement_mlkem_native/env/build-venv/bin/python run.py ref full
../measurement_mlkem_native/env/build-venv/bin/python run.py slothyA pilot
../measurement_mlkem_native/env/build-venv/bin/python run.py slothyA full
../measurement_mlkem_native/env/build-venv/bin/python run.py slothyB pilot
../measurement_mlkem_native/env/build-venv/bin/python run.py slothyB full
tooling/venv/bin/python audit.py --require-full
```

다시 탐색하려면 `tooling/venv/bin/python tooling/generate.py --timeout 8`을 실행한다.
이 명령은 A/B의 `mq_cm55.s`와 탐색 manifest를 다시 생성한다. 동등한 해가 여러 개이고
병렬 solver 탐색은 비결정적일 수 있으므로, 다시 생성한 뒤에는 반드시 재검증·재빌드·재측정한다.
현재 해는 `tooling/logs/manifest.json`에 입력/출력/앞뒤 처리까지 기록되어 있고,
`audit.py`가 그 기록에서 재구성한 전체 assembly와 실제 파일이 같은지 확인한다.

검증 단계는 실제 SLOTHY selfcheck, 별도 정수 ISA interpreter 816개 상태·메모리
접근 회귀시험, object-level 변경 범위/빌드 설정/stack/분기 구조 검사,
보드의 NTT oracle·roundtrip·표 검사, 고정-seed host digest와의 KAT 회귀시험,
정상 및 변조 서명 검증, fault/ECC 확인이다.
**정적 상수시간 구조 확인은 형식적 CT 증명, dudect 통계 검정, 전력/EM TVLA가 아니다.**
KAT도 공식 인증 KAT가 아니라 이 저장소의 고정 입력 회귀검사다.

## 논문과의 연결

- [Fast and Clean: Auditable high-performance assembly via constraint solving](../../REFERENCE/m55_slothy.pdf):
  §4.3~4.5 명령 재배치·레지스터 할당·software pipelining,
  §4.11~4.13 live-through 상태·메모리 의존성·주소 처리,
  PDF p.28 splitting/halving heuristic. 이 실험은 해당 원리를 제한적으로 적용한다.
- [M55 NTT/FFT 최적화 논문](../../REFERENCE/m55_ntt-ftt_opt.pdf):
  조건부 모듈러 보정과 load/store·산술 배치 설명을 참고하되,
  이번 단계에서 기존 Barrett/NTT 데이터 흐름 자체는 바꾸지 않았다.

SLOTHY selfcheck는 어댑터가 올바른 의존성을 제공했다는 전제의 검사다.
개발 중 분할 경계의 미사용 레지스터 보존 누락을 독립 interpreter가 탐지하여
전 물리 레지스터를 live-through로 보존하도록 수정했다. 최종 생성본은 그 수정 이후의 해다.
