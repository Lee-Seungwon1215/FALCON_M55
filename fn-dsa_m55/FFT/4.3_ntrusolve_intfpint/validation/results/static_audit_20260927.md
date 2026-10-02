# C 정적 검사 메모

대상: 최종 kgen_fft_mve.c SHA-256
`cad6f5318319d36000da1aed1f541349a852fcebc578f29113ef0e943b4cfb8e`.
GCC 15.2.1, Cortex-M55, O3, fpv5-d16, no-fast-math, ffp-contract=off.

## 분기·산술

- `fndsa_ds_from_big()`의 비밀 스케일은 원본과 같은 고정 길이 전체 limb
  스캔 및 마스크로 처리한다. secret scale로 직접 주소를 계산하지 않는다.
- `fndsa_ds_to_k()`의 `&&`가 만들었던 FP 잔차 조건 `bne`는 제거했다.
  최종 disassembly의 조건 분기는 공개 배열 길이 및 반복 제어이며,
  잔차 비교는 두 항을 모두 실행하고 IT/정수 마스크로 처리한다.
- `fndsa_ds_inverse()`는 정규화된 FP32 `vdiv.f32` seed와 명시적 FMA
  보정을 사용한다. refinement residual 자체를 추가 FDIV로 나누지 않는다.
- root 코드에 입력별 원본 fallback이나 알려진 KAT seed의 특례가 없다.
- 점별 산술은 C의 scalar FP32/FMA, FFT butterfly는 MVE FP32 어셈블리다.

이는 검사한 코드에 대한 정적 관찰이며, 전체 라이브러리 상수시간 증명이나
전력/EM 부채널 검사가 아니다. 나눗셈 normal 범위 밖/모든 subnormal
조합의 시간 특성을 증명하지 않았다. 키생성 거부 재시도 자체는 가변이다.

## 컴파일러 stack-usage

독립 감사 에이전트가 실제 compile command에 `-fstack-usage`를 추가하여
별도 임시 object를 만들었고, 기존 측정 ELF/소스는 변경하지 않았다.

| 함수 | static bytes |
|---|---:|
| solve_NTRU_intermediate | 16,568 |
| solve_NTRU_depth0 | 16,568 |
| fndsa_ds_from_big | 400 |
| ds_ifft_run | 376 |
| fndsa_ds_to_k | 48 |

일반 유효 temp 경로의 보수적 호출 체인은 약 18 KiB 미만이며 main stack
예약은 64 KiB다. 실제 최악 입력의 stack watermark 증명은 아니다.
