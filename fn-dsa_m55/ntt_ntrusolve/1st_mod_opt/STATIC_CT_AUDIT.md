# Plantard 후보 정적 constant-time 감사

감사일: 2026-09-15

GNU Arm 15.2.1의 `arm-none-eabi-nm -S`와
`arm-none-eabi-objdump -d --disassemble=<symbol>`로 최종 self-test ELF의
`fndsa_mp_NTT`와 `fndsa_mp_iNTT`를 각각 분리해 검사했다.

## 요약

| 후보/함수 | bytes | instructions | conditional/unconditional branches | calls | UDIV/SDIV |
|---|---:|---:|---:|---:|---:|
| P1 l32 scalar NTT | 0x5ac | 486 | 9 | 0 | 0 |
| P1 l32 scalar iNTT | 0x5fe | 508 | 8 | 0 | 0 |
| P2 full NTT | 0x552 | 378 | 10 | 0 | 0 |
| P2 full iNTT | 0x60e | 425 | 9 | 0 | 0 |
| P2 hybrid NTT | 0x3e0 | 276 | 12 | 0 | 0 |
| P2 hybrid iNTT | 0x460 | 308 | 10 | 0 | 0 |

## 분기 분류

- P2 함수 첫 branch는 공개 `logn<4` 여부에 따른 C fallback tail branch다.
  `logn>=4`에서는 C 함수나 다른 helper를 호출하지 않고 S 함수 안에서
  끝난다.
- full의 32회 context loop는 modulus마다 동일한 고정 횟수다.
- NTT/iNTT의 나머지 branch 조건은 공개 logn parity, layer counter,
  root-group counter, coefficient-block counter다.
- hybrid의 추가 branch는 공개 logn parity로 Plantard context와 odd
  singleton layer를 선택한다.
- P1 C compiler output의 branch도 공개 logn/parity와 고정
  layer/group/element loop뿐이다. `raw>=p` canonicalization에는 branch가
  생성되지 않았다.

## 주소 분류

- coefficient load/store base는 호출자가 준 공개 배열 base이고 offset은
  공개 transform index다. coefficient 값은 주소 생성에 사용되지 않는다.
- root 주소는 공개 gm/igm base, layer/group index에서 계산된다.
- P2의 `VLD4/VST4`와 `VLD[R]W [base,q7]`의 `q7`은
  `{0,8,16,24}` 고정 stride vector이며 secret 데이터가 아니다.
- stack slot은 고정 frame offset이고 modulus/root context만 저장한다.

## 산술

- original Plantard coefficient path는 unsigned `VMULH.U32`, `VMUL.I32`,
  `VADD.I32`만 사용한다.
- inverse Plantard 차이 보정은 `VPT.S32`/`VADDT.I32` predication이다.
- division instruction과 data-dependent retry/loop가 없다.
- MVE root preparation은 공개 root/modulus에만 의존한다.

## 범위

이 감사는 disassembly의 제어흐름·주소 형태에 대한 정적 검사다. formal
constant-time proof나 전력/EM TVLA를 수행했다는 의미는 아니다.
