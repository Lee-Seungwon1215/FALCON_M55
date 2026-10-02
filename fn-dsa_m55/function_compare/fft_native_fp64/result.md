# 단일-double FFT의 KAT 불일치 분석·보정 결과

> **최신 상태:** 이후 추가 시험에서 발견한 5개 키 불일치의 원인인 guard를
> 본체에 수정했다. 새 M55 KAT 300/300·서명 KAT 90/90·회귀시험 5/5와
> 호스트 추가 키 20,000/20,000이 통과했다. 최신 기록은
> [guard_integration_result.md](guard_integration_result.md).
> 아래는 초기 소스의 결과이며, 성능·상수시간 문제와 임의 입력 동등성 증명은
> 여전히 미해결이다. 기존 로그와 hash를 현재 본체 측정값으로 해석하면 안 된다.

2026-09-23. **실수부 double 하나 + 허수부 double 하나**를 유지한 보정 후보를
구현하고 실제 NUCLEO-N657X0-Q에서 재검사했다. 기존 26/300 KAT 불일치는
이번 시험에서 0/300이 됐다. 통합 연구 ref는 교체하지 않았다.

당시 기계판독 결과와 소스 hash는 [summary.json](summary.json)에 있다.

## 1. 결과 요약

| 검사 | 원본 fixed | 일반 native FP64 | 보정 후보 `q32_trial` |
|---|---:|---:|---:|
| M55 키생성 KAT, 256/512/1024 각 100개 | 300/300 | 274/300 | **300/300** |
| 호스트 키생성 KAT | 300/300 | 274/300 | **300/300** |
| 호스트 원본 전체 key+signature KAT | PASS | FAIL | **PASS** |
| M55 원본 key+signature KAT, logn=2..10 각 10개 | 이번 별도 미실행 | 이번 별도 미실행 | **90/90** |
| 위 M55 서명의 정상 검증·서명 변조 거부 | — | — | **90/90** |
| 추가 호스트 seed, 512/1024 각 1,000개: 원본과 sk/pk digest 비교 | 기준 | 이번 추가 비교 제외 | **2,000/2,000 일치** |
| 동일 입력 28개 단독 재생: 최종 정수 k | 기준 | 모두 차이 있음 | **28/28 일치**, invalid 0 |

호스트 KAT에서는 upstream `test_keygen_self`, `check_keypair`, `test_verify`,
`test_self`, `test_kat`를 실행했다. 추가 2,000개 입력에서도 정수 NTRU 관계와
계수 범위를 검사했다. M55 keygen KAT의 실제 digest 300개는 각 backend의 호스트
digest와 일치했다. 기대값을 수정하거나 불일치 seed를 예외 처리하지 않았다.

**아직 보장하지 않는 것:** 임의의 모든 seed에 대한 원본 동등성, 모든 중간값
bit-exact, 고정소수점 대비 성능 향상, 전체 상수시간·전력/EM 안전성.
이 후보는 연구용이며 검증 범위를 넘어 최종 배포본으로 채택하지 않는다.

## 2. 동일 입력 M55 단독 실행

원본 상태에서 처음 다른 k가 나왔던 26개 입력과, 역수 준비를 원본 결과로
고정했을 때 남는 후속 사례 2개를 raw word 그대로 사용했다.

```text
동일 raw f/F 입력
 → 입력 변환
 → f의 FFT
 → re²+im²
 → 역수 준비 나눗셈
 → F의 FFT
 → 점별 복소수 곱셈
 → iFFT
 → 정수 k
```

한 펌웨어 안에서 원본 fixed 함수와 FP64 함수를 각각 호출하고 모든 단계의
출력을 해시했다. 일반 FP64의 기록 385줄, 최종 보정본의 기록 307줄은 각각
호스트와 M55에서 모두 일치했다. 기록 수 차이는 다른 k의 상세 출력이 사라졌기
때문이며, 사례 수와 검사 단계는 동일하다.

이 범위에서 **M55의 캐리 누락이나 함수 반환/레지스터 배치 오류라는 증거는
발견하지 못했다.** 같은 수치 차이가 호스트와 보드에서 재현됐다.

2개 후속 사례의 `fixed_inverse` 선택은 원인 분리를 위한 시험 프로그램에만 있다.
실제 `q32_trial` 키생성 경로에는 원본 FFT/역수 준비로 돌아가는 fallback이 없다.

## 3. 확인한 원인

1. **매 곱셈 뒤의 절삭:** 원본은 Q32.32 하위 비트를 버리지만 일반 double은 유지한다.
   작은 `re²+im²`에서는 이 차이가 역수에서 크게 확대된다.
2. **복소 곱셈 그래프:** 원본의 `ac, bd, (a+b)(c+d)`와 일반 FP64의
   `ac, bd, ad, bc`는 중간 절삭을 포함하면 같은 계산이 아니다.
3. **범위 wrap 및 iFFT half:** 원본 64-bit 범위 처리와 단계별 half의 반올림
   순서를 일반 IEEE 연산은 자동으로 재현하지 않는다.
4. **0 분모:** 원본 제곱합이 0인 상태에서 원본 정수 나눗셈 bit-loop는
   특정 비트 결과를 낸다. 일반 FP64 guard는 NaN을 내므로 처리 의미가 다르다.

대표 `512/test43`에서 원본 분모는 약 `6.9849193e-9`, 일반 FP64는 `7.3136384e-9`였다.
최종 k의 한 계수가 원본 25, 일반 FP64 23이었다. 보정 후보에서는 이 k가 25로 일치한다.
이는 허수부 캐리를 실수부로 옮기는 문제가 아니라 원본의 수치 규칙을 유지하는 문제다.

## 4. 실제 보정

`native` 대비 암호 수정은 아래 두 파일이다. 소스 전체는 각 폴더에 독립적으로 존재한다.

| 파일 | 변경 |
|---|---|
| [kgen_inner.h](q32_trial/kgen_inner.h) | `fp64q_floor`, `fp64q_wrap`, add/sub/mul/half/div 보정, 원본 3-product 복소 곱셈 |
| [kgen_fxp.c](q32_trial/kgen_fxp.c) | FP64 FFT/iFFT·점별 곱셈·역수 준비에서 보정 사용 |

배열은 계속 `double`이며 복소수 하나는 16바이트다. hi/lo 두 double로 성분을
쪼개지 않았다. ELF의 FFT에서 `vadd.f64`, `vsub.f64`, `vmul.f64`를 확인했으며
`__aeabi_d*` 소프트웨어 double helper 심볼은 없었다. 이 사실만으로 빠르다는
의미는 아니다. IEEE floor/부호 처리를 위한 일시적 정수 비트 조작은 남긴다.

이 방식의 정확한 분류는 **단일-double 저장 + FP64 산술 + Q32.32 호환 보정**이다.
무보정 native IEEE FFT도, 원본 정수 FFT도, 이전 두-double/성분 구현도 아니다.
현재는 보수적으로 원본 연산 경계마다 보정했다. 최소 비용의 보정 집합인지는 아직 검증하지 않았다.

### 0 분모의 추가 처리

첫 보정본도 최종 KAT는 300/300이었지만, 고정 입력 중 8개에 NaN/invalid가 남았다.
이를 그대로 성공으로 숨기지 않고 원본 bit-loop의 0 분모 결과를 분석했다.

원본 signed raw 입력 x에 대해 0 분모 출력의 signed raw 값은 범위 내에서:

```text
-sign(x) × floor((abs(x) + 2^30) / 2^31)
```

후보는 이를 단일 double 수치에서 계산하고 마스크로 선택한다. FP64 divider에는
0 대신 1을 공급하므로 0 나눗셈 자체를 실행하지 않는다. 일반 나눗셈과 이
예외 처리 모두 동일한 소스 경로에서 계산하며 seed별 분기는 없다.
재검사 후 28개 모두 invalid 없이 k가 일치했다.

IEEE floor helper 112,593개 입력, 0 분모 수식 100,025개 입력의 호스트 검사는
모두 통과했다. 이 시험은 표현 가능한 입력의 수식/primitive 검사이며 원본
64-bit 입력을 single double로 옮기는 모든 정보 손실을 없앤다는 주장이 아니다.

## 5. 남은 제한과 다음 평가

최종 k는 일치했지만 일부 단계의 값은 여전히 다르다. 28개 사례 중 원본 fixed 값을
double로 변환한 값과 수치 차이가 있는 사례 수는 다음과 같다.

| 단계 | 차이가 있는 사례 수 |
|---|---:|
| f의 FFT | 0 |
| 제곱합 | 6 |
| native 역수 준비 출력 | 5 |
| 실제 사용한 역수 출력(2개 진단 control 포함) | 4 |
| F의 FFT | 1 |
| 점별 곱셈 | 2 |
| iFFT | 2 |
| 최종 정수 k | **0** |

따라서 “모든 중간 비트가 원본과 같다”는 해결이 아니라, **현재 KAT와 추가
입력에서 최종 결과가 일치하는 후보를 확보한 것**이다. 단일 binary64의 정밀도
한계가 사라진 것은 아니다. 더 넓은 seed 검사와 경계/오차 분석이 필요하다.

이 기록 작성 시점에는 성능 커널 재측정, 새 보정의 상수시간 역어셈블리/실측,
스택 watermark/최악 입력 분석을 수행하지 않았다. 이후 성능·타이밍 검사를
진행했으며 실패 결과는 [후속 보고서](followup_result.md)에 있다.
스택 watermark/최악 입력 분석은 여전히 별도 과제다. 기존 `ntt_opt` 및 FFT
연구 ref는 교체하지 않았다.

## 6. 보드 환경과 로그

- NUCLEO-N657X0-Q, ST-LINK `003C00223335510735383531`.
- CPU 800 MHz, cache OFF, ITCM code / DTCM data·rodata·stack, 각각 256 KiB 설정.
- GCC 15.2.1, `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math`.
- 기존 M4 어셈블리 및 M55 MVE NTT 사용 조건 유지.
- 완료된 각 실행에서 CFSR/HFSR/AFSR=0, TCM_CONTROL=0x99, ECC 설정을 확인했다.
- 성능 계측이 아닌 정확성 진단 실행이다.

| 자료 | 로그 |
|---|---|
| 일반 FP64 단계별 M55 재현 | [raw.log](results/native-stages/20260923T054223Z/raw.log) |
| 원본 M55 keygen KAT | [raw.log](results/reference-kat/20260923T054643Z/raw.log) |
| 일반 FP64 M55 keygen KAT | [raw.log](results/native-kat/20260923T054601Z/raw.log) |
| 최종 보정본 M55 단계별 비교 | [raw.log](results/q32_trial-stages/20260923T055311Z/raw.log) |
| 최종 보정본 M55 keygen KAT | [raw.log](results/q32_trial-kat/20260923T055314Z/raw.log) |
| 최종 보정본 M55 key+signature KAT / 검증 / 변조 | [raw.log](results/q32_trial-sigkat/20260923T055623Z/raw.log) |
| 최종 호스트 전체 KAT | [raw.log](build/host-q32_trial-kat/raw.log) |
| 추가 2,000개 키, 원본 | [raw.log](build/host-reference-extended/raw.log) |
| 추가 2,000개 키, 보정본 | [raw.log](build/host-q32_trial-extended/raw.log) |
| IEEE floor 및 0 분모 primitive | [summary.json](build/floor-probe/summary.json) |

이전 0 분모 보정 전 보드 실행과 실패한 최초 math.h 빌드 로그도 보존했다.
이전 소스 두 파일은 `build/q32_before_zero_division.tar.gz`에 있다.
