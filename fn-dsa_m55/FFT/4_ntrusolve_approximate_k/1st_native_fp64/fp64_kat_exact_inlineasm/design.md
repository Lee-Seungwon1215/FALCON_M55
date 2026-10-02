# fp64e_mul() inline assembly 설계

## 바꾸지 않은 것

일반적인 single-double 실수 곱셈으로 바꾸는 실험이 아니다.
기존 KAT 호환 C 후보의 `fp64_exact { double hi, lo; }`를 유지한다.
두 필드는 Q32.32 raw 값의 상·하위 unsigned 32-bit word를 각각 정확한
double 정수 값으로 저장한다. 결과도 동일한 canonical 범위
`0 <= hi, lo <= 2^32-1`로 돌려준다.

원본과 동일한 결과는 signed raw X,Y에 대해
`floor(X*Y / 2^32) mod 2^64`다. FFT 구조, 3-product 복소수 곱셈,
중간 절삭, wrap, 반올림, iFFT 단계별 half는 바꾸지 않았다.
④ `solve_NTRU_intermediate()`의 근사 k 경로만 기존 FP64 후보에서
전환되어 있으며 ⑤ depth0, 후보 검사, NTT/CRT/Bezout 및 서명·검증은
이번 수정 대상이 아니다.

## 부분곱과 정확성 범위

1. 각 32-bit word를 B=2^16의 두 자리로 분해한다.
2. convolution column 0~5를 계산한다. 계수 부분곱 수는
   `1+2+3+4+3+2=15`로 C 후보와 같다.
3. column별 carry를 추출하고 결과 자리 2~5만 조립한다.
4. signed 보정 후 high word를 modulo 2^32로 정규화한다.

각 자리는 65535 이하, column 합은 2^35 미만으로 binary64에서
정확히 표현된다. carry 변환 값도 unsigned 32-bit 범위 안이다.
`VCVT.U32.F64`는 양수의 소수부를 버리고 `VCVT.F64.U32`로 정확히
복원한다. 반올림 모드를 따르는 `VCVTR`를 사용하지 않는다.

X,Y의 sign bit를 sx,sy라 할 때 high word 보정은
`-sx*Y_low - sy*X_low`다. 어셈블리는 두 항을 d14에 먼저 합한다.
이 합은 정확한 비음수 정수이고 2^33 미만이다. 2^33 bias를 더한 뒤
빼므로 중간값도 정확한 비음수 정수 범위 안이며, modulo 결과는 같다.
이러한 계산 순서 변경은 일반 실수의 결합법칙을 가정한 것이 아니라
해당 정수 범위의 정확 표현 성질을 사용한 것이다.

`VMUL/VMLA/VMLS.F64`는 하드웨어 FP64 명령이다. 여기의 VMLA/VMLS는
비융합 명령이며 VFMA/VFMS로 치환하지 않는다. 계수 부분곱을 정수
UMULL 등에 맡기거나 기존 fixed FFT로 fallback하는 경로는 없다.
sign bit 추출과 carry 변환의 정수 처리는 남아 있다.

## 레지스터와 C 연결

| 레지스터 | 역할 |
|---|---|
| d0~d3 | 입구: x.hi, x.lo, y.hi, y.lo; 분해 후 a0~a3 |
| d4~d7 | b0~b3 |
| d8 / d9 | convolution column / carry |
| d10 / d11 | 결과 low / high |
| d12 / d13 | 2의 거듭제곱 scale 상수 |
| d14 | signed 보정 합 |
| d0 / d1 | 출구: 결과 high / low |

operand split의 독립적인 multiply와 convert를 단계별로 배치했다.
extended asm에서 d0~d3는 read/write operand, d4~d14는 clobber,
sign 추출용 GPR은 early-clobber다. 상수표 주소는 입력이며 `memory`
clobber를 선언했다. callee-saved 레지스터 저장·복구는 컴파일러에
맡긴다. 직접 스택을 조작하거나 별도 ABI를 강제하지 않는다.

함수의 스택 저장, 레지스터 이동, call 비용은 성능 측정에 포함된다.
명령을 직접 작성했다고 이러한 비용이나 계산량이 자동으로 없어지지 않는다.
함수 호출 제거, 전체 FFT 어셈블리화, 새로운 곱셈 알고리즘은 이번 실험에
섞지 않았다.

## 검증 경계

- 원본 fixed, C 후보, ASM의 raw 결과 비교: 임의 100만 쌍 및 경계값 쌍.
- Python 임의 정밀도 signed 정수 모델의 checksum과 보드 결과 대조.
- 실제 NTRU 입력 19개에서 준비/반복 구간 raw 값 및 정수 k 비교.
- 원본 upstream keygen KAT 300개, 전체 키 생성 및 서명·검증·변조 거부.
- 같은 ELF에서 곱셈, FFT/iFFT 타이밍 비교 및 입력군별 관찰.
- production ELF의 분기·명령·외부 호출과 ABI 저장·복구 검토.

유한 테스트와 입력군 타이밍 관찰은 전체 정확성/상수시간의 기계적 증명이
아니다. 시험한 raw 오차 0은 이상적인 실수 FFT의 근사 오차 0을 의미하지
않는다. host C 기준의 기존 sanitizer 결과를 이번 보드 inline assembly의
sanitizer 통과라고 인용하지 않는다.
