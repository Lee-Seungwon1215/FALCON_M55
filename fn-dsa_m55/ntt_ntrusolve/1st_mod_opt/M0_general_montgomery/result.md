# FN-DSA M55 NTRU-solver NTT: M0 결과

2026-09-14 기준으로 `mp_NTT()`와 `mp_iNTT()`의 **MVE 4×32-bit 일반
Montgomery 구현**을 완료하고 실제 NUCLEO-N657X0-Q에서 정확성·KAT·서명
검증·100회 성능·정적 상수시간 구조를 확인했다.

결론은 다음과 같다.

- FN-DSA-512 전체 키 생성: **9.46% 개선**.
- FN-DSA-1024 전체 키 생성: **5.97% 개선**.
- 서명·검증은 이 함수들을 사용하지 않으므로 실질적인 변화가 없다.
- 308개 RNS 소수와 `logn=4..10`의 C/어셈블리 비교에서 오차는 **0**이다.
- 현재 M0는 정확성과 성능이 모두 검증된 1단계 후보이다. M1/P1 또는 이후
  layer/scheduling 최적화와의 비교는 아직 하지 않았다.

## 구현 범위

활성 구현은 [`kgen_mp31_cm55.s`](kgen_mp31_cm55.s)이다.

- `fndsa_mp_NTT`: Cooley–Tukey forward NTT.
- `fndsa_mp_iNTT`: Gentleman–Sande inverse NTT와 기존 단계별 halving.
- MVE 한 벡터에 31-bit residue 네 개를 담는 `4×32-bit` 처리.
- 기존 C와 같은 2-layer 병합 및 root 순서.
- 마지막/첫 radix-4 묶음은 `VLD4`/`VST4`와 gather root load 사용.
- `logn >= 4`만 MVE 경로이며 `logn < 4`는 보존한 C 함수로 이동.
- q=12289 공통 NTT, FFT, sampler, CRT, Bezout은 이번 단계에서 변경하지 않음.

Montgomery 곱은 [Becker et al., *Polynomial multiplication on embedded
vector architectures*, ePrint 2021/998, Algorithm 4](https://eprint.iacr.org/2021/998)
형태를 현재 FN-DSA의 `p0i = -p^-1 mod 2^32` 표현에 맞췄다.

```text
hi = high_s32(a * b)
lo = low32(a * b)
u  = lo * (-p0i)                 # p^-1 mod 2^32
z  = hi - high_s32(u * p)
if z < 0: z += p                 # MVE predication, branch 없음
```

M0에는 rounding Montgomery, Plantard, 3-layer 병합, inverse 최종 일괄 scaling,
Slothy scheduling을 넣지 않았다.

## 전체 API 성능

단위는 cycle/call이며 10개 batch의 **upper median**이다. 각 batch는 10회
warm-up 후 10회 측정하므로 degree·작업별 총 100회이다. 키 생성의 내부 rejection
sampling 때문에 batch 간 분산이 크며, 양쪽은 같은 고정 seed와 같은 입력 순서를 썼다.

| degree | 작업 | pre-Slothy 기준 | M0 | 차이 | 개선율 |
|---:|---|---:|---:|---:|---:|
| 512 | 키 생성 | 51,716,563 | 46,824,803 | -4,891,760 | **9.4588%** |
| 512 | 서명 | 17,145,671 | 17,145,671 | 0 | 0.0000% |
| 512 | 검증 | 323,007 | 323,031 | +24 | -0.0074% |
| 1024 | 키 생성 | 260,368,534 | 244,813,221 | -15,555,313 | **5.9743%** |
| 1024 | 서명 | 36,737,446 | 36,737,446 | 0 | 0.0000% |
| 1024 | 검증 | 624,898 | 624,925 | +27 | -0.0043% |

검증의 24/27 cycle 증가는 각각 0.01% 미만이고 수정 함수가 검증 경로에 없으므로
최적화 효과가 아니라 실행 잡음으로 본다.

키 생성 분포도 같은 방향이다.

| degree | 구현 | p1 | p50/upper median | p99 |
|---:|---|---:|---:|---:|
| 512 | 기준 | 47,918,045 | 51,716,563 | 73,657,371 |
| 512 | M0 | 43,026,286 | 46,824,803 | 68,756,379 |
| 1024 | 기준 | 176,683,452 | 260,368,534 | 452,676,744 |
| 1024 | M0 | 161,907,804 | 244,813,221 | 436,341,869 |

이 수치는 전체 keygen API 시간이다. `mp_NTT()`/`mp_iNTT()` 단독 cycle이 아니며
NTRU solve 밖의 후보 생성·검사·공개키 계산 등도 포함한다.

### M1 비교를 위한 M0 재측정

2026-09-14 09:45 UTC에 동일한 M0 ELF와 같은 NUCLEO-N657X0-Q에서 full 측정을
다시 실행했다. KAT digest 22개, 정상 서명 검증, 변조 거부 및 fault 검사를 통과했다.

| degree | 작업 | 최초 M0 | M0 재측정 | 차이 |
|---:|---|---:|---:|---:|
| 512 | 키 생성 | 46,824,803 | 46,824,803 | 0 |
| 512 | 서명 | 17,145,671 | 17,145,671 | 0 |
| 512 | 검증 | 323,031 | 323,031 | 0 |
| 1024 | 키 생성 | 244,813,221 | 244,813,220 | -1 |
| 1024 | 서명 | 36,737,446 | 36,737,446 | 0 |
| 1024 | 검증 | 624,925 | 624,925 | 0 |

이 재측정은 기존 M0 결과를 사실상 동일하게 재현했다. M1과의 직접 비교에는 이
새 로그를 사용한다.

## 측정 조건

- 실제 NUCLEO-N657X0-Q, Cortex-M55 r1p1, probe
  `003C00223335510735383531`.
- CPU / SYSCLK / HCLK: **800 / 400 / 200 MHz**.
- I/D cache OFF, TCM ECC ON.
- 코드·vector는 ITCM 주소 영역, 상수·데이터·스택은 DTCM, 각각 256 KiB 구성.
- GNU Arm **15.2.1**, Zephyr **4.4.1**, 최종 유효 **`-O3`**.
- `-mcpu=cortex-m55 -mthumb`, hard-float 및 MVE 사용.
- 기존 q=12289 `mq_cm55.s` 1~4단계 pre-Slothy 구현은 기준/M0에 동일.
- `mlkem-native` Nucleo 환경 pin
  `637d076aa113d8faaec2277ed4a46b657acaf35f`.
- `k_cycle_get_64()`로 10-call block을 측정하고 upper median/10을 보고.
- 인터럽트 허용. API 내부 재시도는 포함하고 seed 준비·로그·digest 계산은 제외.

## 정확성·KAT·서명 검증

| 검사 | 최종 결과 |
|---|---|
| RNS NTT 전수 교차검사 | 308 primes × `logn 4..10` = 2,156 test cases |
| forward C 대 MVE | mismatch 0 |
| inverse C 대 MVE | mismatch 0 |
| NTT→iNTT round-trip | mismatch 0 |
| 최대 모듈러 coefficient 오차 | **0** |
| 기존 q=12289 NTT 512/1024 회귀 | forward/round-trip mismatch 0, max error 0 |
| host 전체 `test_fndsa` | SHA3/SHAKE, codec, q math, fpoly, sampler, keygen, verify, self, KAT degree 2..10 PASS |
| 보드 full KAT 회귀 | host digest 22개와 기준/M0 모두 일치 |
| 정상 키 생성·서명·검증 | 512/1024 PASS |
| 1-bit 변조 서명 거부 | 512/1024 PASS |
| fault/ECC | CFSR/HFSR/AFSR=0, 실행 전후 TCM ECC ON |

host `test_fndsa`는 C 회귀 시험이고 MVE 어셈블리를 직접 실행하지 않는다. MVE는
보드의 308-prime 전수 교차검사와 전체 API KAT가 담당한다. KAT 회귀는 현재 저장된
host oracle과의 일치이며 NIST 인증을 뜻하지 않는다.

검증 도중 두 문제가 시험에 의해 발견되어 최종 코드에서 수정됐다.

1. inverse 중간 loop에서 데이터 포인터 `r11`을 root 임시값으로 재사용해
   UNALIGNED HardFault가 발생했던 문제.
2. 5번째 AAPCS 인자 `p0i`의 저장 위치를 `sp+80`으로 잘못 계산한 문제. 실제
   frame은 core save 40 B + MVE save 64 B + local 8 B이므로 `sp+112`가 맞다.

위 실패 실행은 성능 결과에 포함하지 않았다. 표와 승인 manifest는 두 문제를 수정한
최종 ELF만 사용한다.

## 상수시간 구조 검사

최종 기계어에서 확인한 내용은 다음과 같다.

- `fndsa_mp_NTT`: MVE 명령 165개, `VPT` 보정 27개.
- `fndsa_mp_iNTT`: MVE 명령 210개, `VPT` 보정 27개.
- 조건 분기는 `logn < 4` fallback, 공개 `logn`의 odd/even 선택, 공개 loop counter에만
  존재한다.
- coefficient 값으로 분기하거나 coefficient 값으로 load/store 주소를 선택하지 않는다.
- Montgomery와 add/sub의 조건부 보정은 branch 대신 MVE predication을 쓴다.

따라서 수정 경로는 기존 constant-time 설계의 **정적 제어흐름 조건**을 유지한다.
이는 형식적 constant-time 증명, 통계적 timing leakage 시험, 전력/EM TVLA를
수행했다는 뜻은 아니다.

## 메모리와 식별값

| 항목 | 기준 | M0 | 변화 |
|---|---:|---:|---:|
| 실행 코드 영역 | 106,236 B | 108,188 B | +1,952 B (+1.84%) |
| DTCM 예약량 | 225,728 B | 225,728 B | 0 |
| main stack 사용 상한 | 9,624 B | 9,624 B | 0 |

전수검사용 audit ELF는 비교 배열 때문에 코드 108,988 B, RAM 234,112 B이며 성능
ELF에는 이 배열과 검사 코드가 들어가지 않는다.

- `kgen_mp31_cm55.s` SHA-256:
  `3e18757264fe0802dd832c292f0e45b156c64a69e45911b90d347ff6bfe52694`.
- M0 C/H/S tree SHA-256:
  `3a89139bcaa0c8b6d17a4d4bca875cb18daff508b84fdf781825f122ba2d15b2`.
- 기준 ELF SHA-256:
  `23bb727ece4d08ab92845513bc335425120e2d590914686d55e1fb74ee8e8fef`.
- M0 성능 ELF SHA-256:
  `109e21d9cc9cf255221fbbc86673d42b75b42e297452ffb60d62322e0fcbab40`.
- M0 audit ELF SHA-256:
  `4e0e970f4f3cea60592ebab3fd1b8526ba29dcaf5a354ac9b941887560ccb86f`.

## 로그와 재현

- [기준 full raw log](../results/ref/runs/full-20260914T082708Z/raw.log)
- [M0 full raw log](../results/m0/runs/full-20260914T082905Z/raw.log)
- [M0 재측정 full raw log](../results/m0/runs/full-20260914T094508Z/raw.log)
- [308-prime audit raw log](../results/m0_audit/runs/pilot-20260914T083137Z/raw.log)
- [기준 full 승인 manifest](../results/ref/full_validated.json)
- [M0 full 승인 manifest](../results/m0/full_validated.json)
- [audit 승인 manifest](../results/m0_audit/pilot_validated.json)
- [host full digest oracle](../../../measurement_mlkem_native/host/full.log)
- [재현 가능한 빌드 스크립트](../build_m0.sh)
- [검증·측정 runner](../run_m0.py)

작업공간 루트에서:

```sh
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/build_m0.sh ref
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/build_m0.sh m0
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/build_m0.sh m0_audit

source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m0.py m0_audit pilot
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m0.py ref pilot
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m0.py m0 pilot
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m0.py ref full
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m0.py m0 full
```

`full`은 같은 source tree와 ELF hash가 `pilot`을 먼저 통과했을 때만 실행된다.
