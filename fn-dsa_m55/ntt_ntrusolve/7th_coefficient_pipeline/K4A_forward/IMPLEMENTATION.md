# K4-A 구현 검토

## 1. 기준과 변경 파일

기준은 Slothy 적용 전 채택본 `ntt_ntrusolve/ref_preslothy`의 K2이다.
두 audit manifest의 31개 C/H/S 파일 SHA-256을 대조하면 달라진 암호 소스는
`kgen_mp31_cm55.s` 하나뿐이다. K4-A는 K3 실험군을 계승하지 않는다.

## 2. coefficient pipeline

K2의 ordinary CT2 tile은 `q0..q3` 네 stream을 먼저 모두 읽은 뒤 root 준비,
Montgomery 곱셈과 butterfly를 수행하고 결과 네 개를 연속 저장했다. 이 순서는
연속 load 뒤의 사용 대기와 연속 store 구간을 그대로 노출한다.

K4-A의 `MP31_CT2_TILE_K4A`는 같은 명령 multiset을 다음과 같이 재배치한다.

```text
load q0, q2
root load/duplicate/prepare
load q1
first Montgomery low multiply
load q3
remaining Montgomery + butterfly
...
last q3 Montgomery low multiply
store final q0
last q3 Montgomery high multiply
store final q1
remaining reduction + butterfly
store final q2, q3
```

`q0/q1`은 마지막 q3 multiplication 전에 이미 최종값이므로 일찍 저장해도
수학적 결과가 바뀌지 않는다. q0/q1 store 주소는 아직 증가하지 않은 각 stream
pointer이고, q2/q3도 원래 pointer에 저장한다. 모든 pointer는 마지막에 정확히
16바이트씩 증가한다.

## 3. 적용 위치

- regular path: `.Lntt_two_inner`
- even small path: `.Lsmall_two_inner`

penultimate transpose boundary와 final VST4 boundary, odd initial layer는 K2를
그대로 유지했다. 따라서 `logn=4/5`에는 변화가 없고 `logn=6..10`의 반복되는
ordinary CT2 pass만 빨라진다. inverse NTT는 source와 기계어 모두 K2와 같다.

## 4. register와 메모리

- 계수: `q0..q3`
- 현재 root와 prepared twist: `q4`, `q5`
- Montgomery 및 butterfly scratch: `q6`, `q7`

MVE의 Q register 8개를 모두 사용하므로 다음 tile을 vector register에 통째로
미리 읽는 cross-iteration 방법은 spill 없이 불가능하다. K4-A는 한 tile 안의
독립성만 사용하며 stack frame, 메모리 접근 수, 주소 형식, 상수표를 바꾸지 않는다.

## 5. 정확성과 상수시간 관점

- modular arithmetic 순서와 각 연산의 피연산자는 K2와 동일하다.
- branch와 loop bound는 기존과 동일하며 public `logn` 및 public counter에만
  의존한다.
- coefficient를 주소 계산이나 scalar branch 조건에 사용하지 않는다.
- coefficient-dependent MVE predicate는 기존 modular normalization과 동일하다.
- 호출, 정수 나눗셈, FP32/FP64 명령을 추가하지 않았다.

정적 감사에서는 K2와 K4-A의 함수 주소·크기, mnemonic multiset, branch의
offset/mnemonic/operand sequence, memory address multiset이 동일함을 검사한다.
`fndsa_mp_iNTT()`는 전체 instruction stream이 동일하다. 이는 구조적 회귀
검사이며 형식적 상수시간 증명이나 dudect/TVLA·전력/EM 검사는 아니다.

## 6. 측정 경계

직접 커널 측정에는 함수 진입/복귀와 내부 root 준비가 포함되고, 외부 root table
생성과 입력 복사는 제외된다. 전체 API 측정은 키생성·서명·검증을 각각 10개
batch × batch당 10회 실행한다. 기준과 후보는 동일 보드, 동일 Kconfig,
GCC 15.2.1 `-O3`, 동일 입력과 동일 TCM 배치를 사용한다.

