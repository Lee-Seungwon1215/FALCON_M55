# K4-B 구현 검토

## 1. 기준과 변경 파일

K4-A와 효과를 분리하기 위해 K4-B도 K2 `ref_preslothy`에서 시작했다. 두 audit
manifest의 top-level 암호 소스 SHA-256을 대조하면 다른 파일은
`kgen_mp31_cm55.s` 하나뿐이다.

## 2. GS2 scheduling

K2 ordinary GS2는 `q0..q3`를 연속 load하고 계산을 모두 마친 뒤 네 결과를
연속 store한다. K4-B의 `MP31_GS2_TILE_K4B`는 같은 instruction multiset을
다음 순서로 재배치한다.

```text
load q0, q1
first inverse-root preparation
load q2
first GS difference
load q3
remaining first GS + second GS + parent-root preparation
finish q0/q2 GS
start final q1/q3 Montgomery
store final q0
continue Montgomery
store final q2
finish reduction
store final q1, q3
```

마지막 GS에서 `q0/q2`는 `q1/q3` reduction 전에 이미 최종값이다. 따라서 두
store를 Montgomery dependency chain 사이로 옮겨도 결과가 바뀌지 않는다.
각 stream pointer는 원래와 동일한 주소에서 정확히 16바이트 증가한다.

## 3. 적용 경계

적용 위치는 `.Lintt_two_inner` 하나다. 다음 경로는 K2 그대로다.

- initial VLD4 GS2 및 transposed store
- second GS2 transpose boundary
- even final-two scaling
- odd final-one scaling
- forward NTT와 small forward dispatcher 전체

따라서 `logn=4..6`은 변하지 않고, ordinary GS2 pass가 존재하는
`logn=7..10`만 영향을 받는다.

## 4. register·메모리·상수시간

- coefficient: `q0..q3`
- root/twist: `q4`, `q5`
- scratch: `q6`, `q7`

Q register 8개를 모두 사용하며 새 spill이나 stack frame 변경이 없다. 모든 branch는
기존 public `logn`과 loop counter에만 의존한다. coefficient는 주소 또는 scalar
branch 조건에 사용되지 않는다. 호출, 나눗셈, FP32/FP64 명령도 추가하지 않았다.

정적 감사에서는 K2와 K4-B의 symbol 주소·크기, mnemonic multiset, branch
sequence, memory-address multiset을 비교한다. forward NTT 두 symbol은 전체
instruction stream이 K2와 같다. 이는 구조적 회귀 검사이며 형식적 상수시간
증명이나 dudect/TVLA·전력/EM 검사는 아니다.

