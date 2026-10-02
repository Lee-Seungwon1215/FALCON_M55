# S1 + S2 + S3 충돌 해결 기록

작업일: 2026-09-13. 범위는 각 조합 폴더의 `mq_cm55.s` 안에 있는
공통 `mqpoly_int_to_ntt()`와 `mqpoly_ntt_to_int()`이다.
후보 충돌 해결 당시에는 `ntt_opt`, 개별 S1/S2/S3 후보, `mq.c`, FFT·sampler를
수정하지 않았다. 이후 최종 채택에서 S1B_S2B_S3A만 `ntt_opt`에 직접 반영했다.
[통합 기록](../../ntt_opt/result.md).

## 무엇을 해결했나

기존 12개 조합도 파일 전체에는 세 기법이 있었지만, 서로 겹치는 두 구간에서
S3의 적용을 줄여 충돌을 피했다. 이번에는 그 구간의 레지스터 배치와 명령 순서를
함께 다시 작성했다. 세 개의 완성된 함수를 이어 붙이는 방식이 아니다.

| 충돌 구간 | 이전 처리 | 이번 처리 |
|---|---|---|
| S2-B + S3-B, 512 forward 3-layer | `q7`이 임시값과 preload에 동시에 필요하여 두 번째 쌍의 early-load를 생략 | 균일 twiddle을 GPR에 유지하고 scalar-vector 곱을 사용. 다음 데이터를 담은 `q7`을 덮어쓰지 않음 |
| S2-A/B + S3-C, forward/inverse 4개 steady kernel | 산술 body가 모두 끝난 후 다음 반복을 읽음 | 현재 값의 마지막 사용·저장 직후 해당 레지스터를 다음 반복 load에 재사용. 남은 독립 산술과 겹침 |

따라서 `S1A/B × S2A/B × S3A/B/C` **12개 모두 S1 한 가지 + S2 한 가지 +
S3 한 가지**를 자기 소스 안에서 직접 구현한다. 적용 가능한 공통 커널을 대상으로
하며, 모든 명령 또는 모든 butterfly에 세 기법이 동시에 존재한다는 뜻은 아니다.

v1 대비 기계어가 바뀐 것은 8개 조합이다. `S2-A + S3-A/B` 네 조합은
이미 충돌 없이 결합돼 있었으므로 연산 코드를 유지하고 문서만 정정했다.
정적 감사에서 이 네 조합의 MQ 함수 기계어가 v1과 동일한 것을 확인했다.

## 1. S2-B의 레지스터 압력 줄이기

대상 매크로: `MQ3_MVE_CT_MUL2_CROSS_LAYER`.

- root와 twist는 기존처럼 GPR의 하위/상위 16비트에 들어 있다.
- 동일한 상수를 모든 lane에 쓰는 곳은 `VDUP`으로 별도 Q 레지스터를 만드는
  대신 `VQRDMULH.S16`, `VMUL.I16`, `VMLA.I16`의 scalar-vector 형식을 쓴다.
- 합·차와 두 곱을 네 개의 Q 레지스터 안에서 처리한다. 곱셈의 몫 근사 임시값은
  더 이상 필요 없는 입력 레지스터를 재사용한다.
- 합의 다음-layer 곱을 시작한 뒤 차의 보정을 수행하여 S2-B의 교차-layer
  배치를 유지한다. S1-A/B의 곱셈 명령 상대 순서도 유지한다.
- `q0`은 일부 경로에서 `s0`~`s3` 루프 상태와 겹치므로 임의 scratch로 쓰지 않는다.
- 마지막 packed layer처럼 lane마다 twiddle이 다른 곳은 벡터 상수를 유지한다.

`S1A_S2B_S3B`와 `S1B_S2B_S3B`의 512 forward 3-layer에서는
`q4 ← [r1+192]`, `q7 ← [r1+224]`를 먼저 읽는다. 첫 쌍 계산이 `q7`을 보존하고,
둘째 쌍 계산은 첫 결과 `q4`를 보존한다. 둘 다 계산한 후 저장한다.
추가 stack spill은 없다.

같은 개선 매크로를 모든 S2-B 조합에 일관되게 적용했다. 따라서 이번 수정은
**순서 변경뿐 아니라 동일 수식의 명령어 선택 변경도 포함**한다. 완전히 동일한
instruction multiset에서 세 독립 요인만 바꾼 실험이라고 주장하지 않는다.

## 2. S3-C의 반복 간 겹치기 복원

대상은 `MQ_S3C_CT2_STEADY`, `MQ_S3C_F2_STEADY`,
`MQ_S3C_GS2_STEADY`, `MQ_S3C_GS2_WIDE_STEADY`이다.

1. 현재 반복의 출력이 완성되고 기존 값의 마지막 사용이 끝났는지 확인한다.
2. 현재 출력을 저장한다.
3. 같은 레지스터에 다음 반복 입력을 읽는다.
4. 다른 레지스터에 남아 있는 현재 반복의 산술과 저장을 마무리한다.

S1/S2에 따라 마지막 사용 시점이 다르므로 S2-A와 S2-B의 tail을 각각 작성했다.
기존 prologue, 공개 반복 횟수, 마지막 반복의 epilogue 경계는 그대로다.
epilogue에는 **다음 반복의 입력 load가 없으므로** 입력 버퍼의 추가 padding을
가정하지 않는다. 이것은 `PRFM` 힌트가 아니라 실제 `VLDRH`를 앞당긴 것이다.

## 논문 근거와 우리 적용의 구분

쪽수는 로컬 PDF의 첫 페이지를 1로 센 번호이다.

- [Polynomial multiplication on embedded vector architectures](../../../REFERENCE/m55_ntt-ftt_opt.pdf),
  pp.17–18, §6.4.2: modulus/root를 GPR에 두는 scalar-vector 연산으로 벡터
  레지스터 부담을 줄이고, 곱·가감산·load/store를 함께 배치한다.
  원문의 해당 커널은 32-bit이며 여기의 FN-DSA `q=12289`, 16-bit Barrett
  코드를 그대로 제공하는 것은 아니다. 우리는 이미 검증한 B1 수식에 원리를 적용했다.
- [Fast and Clean: Auditable high-performance assembly via constraint solving](../../../REFERENCE/m55_slothy.pdf),
  pp.13–15, §4.4–4.6: 값의 생존 구간이 겹치지 않도록 레지스터를 배정하고,
  반복 간 load/store 이동에는 prologue/epilogue와 의존성 제약이 필요하다.
  이번 코드는 그 원리를 따라 **수동 작성**했으며 SLOTHY를 실행해 얻은 결과는 아니다.
- 같은 SLOTHY 논문 p.15가 설명하는 것처럼 prologue/epilogue는 코드 크기를 늘린다.
  S3-C는 속도뿐 아니라 코드 증가도 함께 비교한다.

이 논문들이 우리 12개 조합의 성능 순위까지 보장하지는 않는다. 순위는 연결된
NUCLEO-N657X0-Q에서 동일 입력·옵션·횟수로 직접 측정한다.

## 보존 및 재현

- 수정 전 12개 assembly와 검증 문서:
  [`revision_before/sources-v1.tar.gz`](revision_before/sources-v1.tar.gz).
- 수정 전 대표 2개(`S1B_S2B_S3B/C`)의 전체 C/H/S와 ELF도
  `revision_before/`에 보존했다. 이전 ELF로 수정 전 측정을 새로 수행했다.
- [`../run_combinations.py`](../run_combinations.py): 완성된 후보의 ELF를
  선택하는 시험 실행기. 소스 조각을 합치지 않는다. 정확한 source/ELF hash로
  pilot을 통과한 경우에만 full 측정을 허용한다.
- [`../check_combination_revision.py`](../check_combination_revision.py):
  수정한 매크로와 반복 경계의 명령어 모델 회귀 검사 10,352개.
- [`../audit_combinations.py`](../audit_combinations.py): 수정 전후 분기·스택
  명령 비교, 다른 함수의 기계어 불변 확인, 공통 컴파일 옵션 확인,
  원시 로그에서 NTT 오차·KAT·fault·ECC·cycle summary 재검사.

보드 로그와 모델 검사를 합쳐 판단한다. 모델은 제한된 명령만 지원하고 미지원
명령은 실패 처리한다. 정적 감사는 상수시간의 형식적 증명이나 전력/EM TVLA가 아니다.
이번 KAT는 기존 고정-seed host oracle과의 출력 digest 비교이며 NIST 공식 인증을
의미하지 않는다. 모든 가능한 키·메시지에 대한 전수 검증도 아니다.
