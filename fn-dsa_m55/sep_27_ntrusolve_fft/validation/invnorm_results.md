# A17: A16에 기존 native-FP64 invnorm 적용

아래는 정리 전 A17의 고정된 실행 기록이다. 현재 소스의 미사용 코드 정리와
재측정은 [정리 후 검증](cleanup/README.md)에 별도로 기록한다.

2026-09-28. 요청한 구현 반영과 M55 재검사를 완료했다. 현재
`A_tw_bridge`는 **A17 = A16 + 키 후보 검사 FP64 invnorm**이다.
이번에 변경한 암호 소스는 [kgen_fxp.c](../A_tw_bridge/kgen_fxp.c)의
`vect_invnorm_fft()` 하나이며, NTT·NTRU FFT·서명·검증 소스는 변경하지 않았다.
외부 `M55_ref`, `ntt_opt`와 B18도 그대로다. A16의 측정 결과를 새 소스의
통과 결과로 재사용하지 않고, 13개 검사를 새로 실행했다.

## 적용 방식과 범위

- 실제 키 후보 검사에서 호출하는 공개 인자 `e=0` 경로에 이전 native-FP64
  제곱합과 정규화된 역수 계산을 적용했다.
- 기존 Q32 입력·출력 인터페이스는 유지한다. 복소수 한 쌍씩 실수부·허수부를
  각각 double로 변환하고, FP64로 계산한 결과만 Q32로 되돌린다.
- 전체 크기의 double 임시 배열은 추가하지 않았다. 상위·하위 정수 단어를
  각각 double 배열에 저장하는 구현도 아니다.
- 공개 인자 `e != 0`은 기존 고정소수점 구현을 유지한다. 비밀 입력에 따라
  빠른 구현을 선택하거나 KAT 입력을 예외 처리하지 않는다.
- 다른 경로의 소스를 링크하거나 빌드 옵션으로 구현을 선택하지 않는다.
  기존 파일에 직접 작성했으며, SLOTHY는 적용하지 않았다.

**이 함수의 호출 위치는 NTRU solve 내부가 아니라 키 후보의 직교 노름 검사다.**
따라서 아래 추가 개선은 A16의 NTRU solve FFT 최적화 효과와 구분해야 한다.

## 커널: 입력·출력 변환을 포함한 전체 함수 호출

동일 ELF에 포함된 원본 고정소수점 함수를 대조군으로 사용했다.
크기별 10회 준비 후 100회 호출, IRQ 마스킹, 타이머 비용 포함이다.
새 함수 수치는 `Q32 → FP64 → Q32` 비용까지 포함한다.

| 함수 | n | 원본 고정소수점 cycles/call | A17 cycles/call | 속도 배율 | 시간 감소 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `vect_invnorm_fft()` | 512 | 464,175.01 | 117,837.00 | 3.9391배 | 74.6137% |
| `vect_invnorm_fft()` | 1024 | 928,303.01 | 235,597.00 | 3.9402배 | 74.6207% |

[커널·정확성·시간 분포 로그](results/A_tw_bridge/invnorm/20260928T032423Z/raw.log),
[소스/ELF/로그 해시 및 측정 설정](results/A_tw_bridge/invnorm/20260928T032423Z/manifest.json).
이전 double 입출력 직접 커널의 약 7.23배와는 측정 경계가 다르다.
현재 고정소수점 호출부에 연결한 성능으로는 **약 3.94배**를 사용한다.

## 전체 키생성

크기별 서로 다른 upstream 입력 `test0`부터 `test99`까지 100개를 사용했다.
제외한 준비 호출 3회, 실패 후보·재시도·인코딩 포함, 검사는 타이머 밖,
IRQ 허용, 프로파일 훅 없는 측정이다. A16과 같은 측정 프로그램·입력·배치
정책을 사용했지만 모든 함수의 주소를 고정한 비교는 아니다.
다른 프로젝트의 10개 입력 × 10회 반복 결과와 혼합하지 않는다.

| 구현 | 512 평균 cycles | 1024 평균 cycles |
| --- | ---: | ---: |
| M55_ref: 동일 100개 입력 기존 기록 | 62,738,244.34 | 261,716,429.63 |
| ntt_opt: 동일 100개 입력 기존 기록 | 56,951,253.03 | 243,157,429.30 |
| A16: 변경 전 반복 측정 | 53,777,061.10 | 234,700,263.98 |
| A17: 첫 측정 | 51,437,565.73 | 224,193,235.31 |
| A17: 같은 ELF 재측정 | 51,437,565.73 | 224,193,235.43 |

| 비교 | 512 | 1024 |
| --- | ---: | ---: |
| A16 대비 시간 감소 | 4.3504% | 4.4768% |
| A16 대비 속도 배율 | 1.0455배 | 1.0469배 |
| M55_ref 대비 누적 속도 배율 | 1.2197배 | 1.1674배 |

M55_ref 대비 누적 수치는 **기존 NTT + A16 NTRU FFT + 이번 후보 검사 invnorm**을
모두 포함한다. FFT만의 효과나 이번 함수만의 전체 개선율이 아니다.
종전의 전체 키생성 1.7배 목표는 아직 달성하지 못했다.
두 A17 실행은 각각 200개 출력 키 및 NTRU 방정식 검사를 통과했다.

- [A16 반복 측정](results/A_tw_bridge/keygen/20260927T234807Z/raw.log)
- [A17 첫 측정](results/A_tw_bridge/keygen/20260928T032732Z/raw.log)
- [A17 반복 측정](results/A_tw_bridge/keygen/20260928T033015Z/raw.log)
- [이전 baseline 기록과 조건](packed_layout_results.md)

## 정확성, KAT, 서명·검증

| 검사 | 결과 |
| --- | --- |
| invnorm 단독 원본 비교 | 130,944개 값 중 7개 다름, 최대 4 Q32 LSB |
| 후보 직교 노름 판정 비교 | 640/640 동일 |
| 배열 경계 및 `e != 0` 원본 경로 | 실패 0 |
| 원래 키생성 KAT + NTRU 방정식 | 300/300 통과 |
| 독립 입력 추가 KAT + NTRU 방정식 | 300/300 통과 |
| 서명 KAT·정상 검증·변조 거부 | 90/90 통과 |
| 호스트 일반 및 UBSan/float-cast-overflow 검사 | 동일 정확성 결과, sanitizer 오류 없음 |

4 Q32 LSB는 약 `9.313225746e-10`이다. **중간값 전체가 비트 단위로 같다는
뜻이 아니다.** 최종 키 KAT 및 시험한 판정은 같았지만, 이것만으로 모든
입력의 출력 동등성이나 원본 판정 경계에서의 동등성을 증명하지는 않는다.
사용 경로의 계약은 양의 normal 제곱합과 표현 가능한 역수이며,
0·비정상 부동소수점·임의 overflow 입력 전부를 지원한다고 주장하지 않는다.

원래 fixed FFT, 입력 변환, 정수 나눗셈 및 root-product 회귀 검사도 통과했다.
현재 소스에 대응하는 모든 실행과 해시는
[current_validation.json](current_validation.json),
[evidence_check.json](evidence_check.json)에 기록했다.

| 검사 모드 | 실행 UTC 2026-09-28 | 원시 로그 |
| --- | --- | --- |
| invnorm | 032423Z | [log](results/A_tw_bridge/invnorm/20260928T032423Z/raw.log) |
| kat | 032300Z | [log](results/A_tw_bridge/kat/20260928T032300Z/raw.log) |
| extra | 032520Z | [log](results/A_tw_bridge/extra/20260928T032520Z/raw.log) |
| sigkat | 032723Z | [log](results/A_tw_bridge/sigkat/20260928T032723Z/raw.log) |
| keygen | 033015Z | [log](results/A_tw_bridge/keygen/20260928T033015Z/raw.log) |
| profile | 032815Z | [log](results/A_tw_bridge/profile/20260928T032815Z/raw.log) |
| kernel | 032858Z | [log](results/A_tw_bridge/kernel/20260928T032858Z/raw.log) |
| fixed_input | 032900Z | [log](results/A_tw_bridge/fixed_input/20260928T032900Z/raw.log) |
| input_pair | 032907Z | [log](results/A_tw_bridge/input_pair/20260928T032907Z/raw.log) |
| input_predicate | 032910Z | [log](results/A_tw_bridge/input_predicate/20260928T032910Z/raw.log) |
| fixed_division | 032925Z | [log](results/A_tw_bridge/fixed_division/20260928T032925Z/raw.log) |
| fixed_fft | 032931Z | [log](results/A_tw_bridge/fixed_fft/20260928T032931Z/raw.log) |
| rootmul | 032936Z | [log](results/A_tw_bridge/rootmul/20260928T032936Z/raw.log) |

## 하드웨어 명령과 상수시간 검사 범위

최종 ELF의 `fndsa_vect_invnorm_fft`를 역어셈블해 `VMUL.F64`,
`VMLA.F64`, `VADD.F64`, `VDIV.F64`, `VRINTM.F64`, `VCVT` 사용을 확인했다.
native 경로에서 소프트웨어 double 산술 보조 함수 호출은 없었다.
분기와 주소는 공개 `e`, 크기와 반복 인덱스에 의존한다.

32개 입력군 × 20회를 별도 측정했다. 512는 117,837~117,839 cycles,
1024는 235,597~235,598 cycles였다. 입력군별 최소값에도 1 cycle 차이가
관찰되어 완전히 같은 시간이라고 표현하지 않는다. 시험 범위에서 작은
변동이라는 결과이며, 전체 상수시간 증명이나 전력/전자기 누설 검증은 아니다.

## 측정 조건과 메모리

NUCLEO-N657X0-Q, CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz.
코드 ITCM 256 KiB, 상수·데이터·스택 DTCM 256 KiB, 캐시 OFF, ECC ON.
GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard`,
`-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
기존 M4 어셈블리와 MVE NTT 설정을 유지했다. Fault/ECC 오류 보고는 0이었다.

서명 검사 ELF 기준 ITCM은 A16 126,676 B에서 A17 127,024 B로 **348 B 증가**,
DTCM은 **251,496 B로 동일**하다. DTCM에는 예약 main stack 64 KiB가 포함되며,
잔여 공간은 10,648 B이다. 전체 실행 경로의 최대 stack 사용량 증명은 아니다.

변경 전후 소스는 [A16 snapshot](source_snapshots/A16_deinterleave_ht1.json),
[A17 snapshot](source_snapshots/A17_fp64_invnorm.json)에 기록했다.
`check_scope.py`는 A16 대비 변경한 암호 파일이 `kgen_fxp.c`뿐인지 검사한다.
`scope_check.json`의 `orthonorm_exact_source_equal`은 호출자 함수 본문이
같다는 의미이며, 그 안에서 호출하는 invnorm까지 같다는 의미는 아니다.
