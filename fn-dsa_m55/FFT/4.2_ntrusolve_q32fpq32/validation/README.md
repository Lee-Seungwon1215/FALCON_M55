# B 후보의 독립 검증

## 현재 Q32 규칙 보정판

최신 판정은 [result.md](../result.md)에 있다. 추가 모드는
`extra` (새 seed 300개 원본 비교), `q32timing` (보정 함수만 8종 입력 시간 비교)이다.
`host_q32_rules.c`, `host_q32_precision.c`가 현재 helper를 직접 include한다.
`audit_q32_elf.py MODE`는 ELF의 새 helper 분기를 확인한다.

아래의 `host_ds_math.c`와 fixture의 비정상 분모 거부 설명은 **보정 전 진단 기록**이다.
현재 나눗셈은 원본 정수 나눗셈의 raw-zero 분모 동작을 그대로 따르므로,
이전 “0 분모이면 거부” 기준을 현재 코드의 합격 조건으로 사용하지 않는다.
현재 소스에서는 `kat`, `extra`, `sigkat`, `keygen_current`, `kernels`,
`q32timing`을 재빌드·보드 실행했다.
그 결과에도 일반 입력 bit-exact 및 전체 상수시간이 증명된 것은 아니다.

정상 구현은 상위 B 폴더의 소스만 빌드한다. C 후보를 참조하거나 링크하지 않는다.
다른 후보의 런타임 선택 빌드옵션은 사용하지 않으며, 일반적인 소스 등록과
측정 프로그램 종류 선택만 한다. SDK·보드 초기화·로더는 공통 측정 기반이다.

```sh
sh fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/validation/build.sh kat
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/FFT/4.2_ntrusolve_q32fpq32/validation/run_board.py kat
```

NUCLEO-N657X0-Q, 800 MHz, 캐시 OFF, ITCM 코드와 DTCM 데이터·스택 각256KiB,
GCC15.2.1, -O3, -mfpu=fpv5-d16, -ffp-contract=off, -fno-fast-math,
기존 NTT 어셈블리 활성화 조건이다. 보드는 공유 잠금을 얻고 순서대로만 실행한다.

| 모드 | 검사 |
| --- | --- |
| kat | 원본 기대값 그대로 256/512/1024 각100, 정확한 NTRU 방정식 검사 |
| sigkat | 4..1024 총90 서명 KAT·검증·변조 거부 |
| kernels | logn4..10의 연결 구간을 원본 Q32와 같은 입력으로100회, 준비10회, IRQ OFF |
| fixtures | 과거 실제 NTRU 입력6개를 단계별 비교, 출력 반정수 경계54개, 알려진1LSB 반례, 비정상입력 거부 |
| keygen_current | 각512/1024 원본 test0..99, 준비3회, 전체 키생성 및 재시도 포함, IRQ ON64bit SysTick |

커널 op0은 FFT→역수 준비, op1은 준비한 역수를 사용한 FFT→점별곱→iFFT,
op2는 분자·분모의 FFT→나눗셈→iFFT이다. 입력 Q32→DS와 출력 DS→Q32 변환을
포함한다. op1의 반복 불변 역수 준비는 계측 밖이며, 이는 실제 solver 사용과 같다.
8개 입력군 ×100회의 시간 비교도 수행한다. 유한한 시간 표본과 명령 검토는
전체 상수시간 증명, 전력/EM 분석 또는 모든 입력 동등성 증명이 아니다.

`frozen_cases.inc`는 이전 FFT 검증에서 기록한 원본 Q32 정수 비트 입력이다.
stage0은 입력 변환,1은 f FFT,2는 역수,3은 F FFT,4는 점별곱,5는 iFFT이다.
case27만 원본 역수를 진단용으로 다시 입력해서 잔여 차이를 분리한다.
정상 암호 구현에는 이 원본 재실행/대체가 존재하지 않는다.
중간 관찰용 export가 유효 범위 밖이면0으로 안전 치환할 수 있으므로 해당
거대 raw 차이를 실제 유효 Q32 값 사이의 오차로 해석하면 안 된다.

`host_ds_math.c`는 로컬 DS 산술을 복사하고 VFMA만 host fmaf로 바꾼 독립 수치 검사다.
61,000개 정상 분모와6개 비정상 입력을 검사한다. M55 시간 검사가 아니다.
`host_q32_fixture.c`는 원본 고정소수점 제곱합의 절삭 및 모듈러 wrap 원인을 확인한다.

예외값 검사에 실패하면 solver는 기존 SOLVE_ERR_REDUCE로 실패를 알린다.
정상 입력을 위한 고정 길이 산술은 유지하지만, 이 실패 후 재시도까지 포함한
키생성 전체를 상수시간이라고 주장하지 않는다. 원본 KAT 기대값은 변경하지 않았다.
