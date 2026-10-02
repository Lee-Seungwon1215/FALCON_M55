# K4-C 구현 검토

## 기준과 구성

기준은 Slothy 적용 전 채택본 `ntt_ntrusolve/ref_preslothy`의 K2다. K4-C는
K4-A의 forward macro와 K4-B의 inverse macro를 같은
[`kgen_mp31_cm55.s`](kgen_mp31_cm55.s)에 직접 배치했다. 그 외 암호 소스는
K2와 동일하다.

## forward CT2

`MP31_CT2_TILE_K4A`는 네 coefficient vector를 모두 읽은 뒤 계산하는 K2 순서를
다음처럼 재배치한다.

1. `q0`, `q2`를 먼저 load한다.
2. root 준비와 첫 Montgomery dependency 사이에 `q1`, `q3`를 load한다.
3. 이미 확정된 `q0`, `q1`을 마지막 Montgomery dependency 사이에 store한다.
4. 마지막 butterfly 뒤 `q2`, `q3`을 store한다.

regular `.Lntt_two_inner`와 small `.Lsmall_two_inner`에 적용된다. 해당 ordinary
CT2 반복부가 없는 `logn=4/5`는 K2와 동일하다.

## inverse GS2

`MP31_GS2_TILE_K4B`는 같은 arithmetic/data dependency를 보존하면서 coefficient
load를 첫 GS/root 준비 사이에 분산하고, 완료된 출력의 store를 마지막
Montgomery dependency 사이로 이동한다. `.Lintt_two_inner`에만 적용된다.
ordinary GS2 반복부가 없는 `logn=4..6`은 K2와 동일하다.

## 안전성 불변식

- 산술 명령과 피연산자, branch와 loop bound는 K2와 같다.
- 메모리 접근 횟수와 주소 형식은 같다.
- coefficient를 주소나 scalar branch 조건에 사용하지 않는다.
- stack spill, scratch buffer, 함수 호출, 정수 나눗셈, FP32/FP64 명령을
  추가하지 않는다.
- forward 기계어는 독립 K4-A와, inverse 기계어는 독립 K4-B와 정확히 같다.

[`profiling/audit_k4c.py`](profiling/audit_k4c.py)는 보존된 네 ELF를 비교해
위 불변식을 디스어셈블리 수준에서 확인한다. 이는 구조적 상수시간 회귀 검사이며
형식적 증명이나 dudect/TVLA·전력/EM 누출 검사는 아니다.

## 측정 경계

직접 커널 측정은 함수 진입/복귀와 내부 root/twist 준비를 포함하며 외부 테이블
생성과 입력 복사는 제외한다. 전체 API는 각 크기·연산별 10 batch × 10 call,
총 100회이며 각 batch 전에 10회 warm-up한다.
