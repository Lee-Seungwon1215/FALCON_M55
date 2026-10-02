# FN-DSA M55 NTRU-solver NTT: P1 `l=64` Plantard 결과

2026-09-14 기준으로 `mp_NTT()`와 `mp_iNTT()`의 **유효한 corrected
improved Plantard `l=64`, `alpha=1` 구현**을 완료하고 실제
NUCLEO-N657X0-Q에서 정확성, KAT, 서명 검증, 100회 성능 및 정적
상수시간 구조를 확인했다.

결론은 다음과 같다.

- 정수 모델과 M55 보드에서 coefficient 오차는 모두 **0**이다.
- FN-DSA KAT, 정상 서명 검증, 변조 서명 거부 및 fault 검사를 통과했다.
- 그러나 M0 MVE Montgomery보다 전체 키 생성이 512에서 **39.42%**,
  1024에서 **23.93% 느리다**.
- 따라서 이번 P1은 `l=64` Plantard의 **유효성 확인용 기준 구현**으로
  보존하되, 현재 형태를 최종 최적화 코드로 채택하지 않는다.

## 구현 내용

활성 구현은 [`kgen_mp31.c`](kgen_mp31.c)의 다음 세 구성요소이다.

1. `mp31_plant64_init()`은 각 공개 RNS 소수 `p`에 대해
   `p^-1 mod 2^128`과 `-2^128 mod p`를 계산한다.
2. `mp31_plant64_prepare()`는 기존 Montgomery-R32 형식의 공개 root를
   128-bit Plantard 상수로 변환한다.
3. `mp31_plant64_mul()`은 128-bit 중간값을 32-bit limb 곱으로 정확하게
   계산하고 결과를 `[0,p)`로 복원한다.

사용한 식은 다음과 같다.

```text
b  = -w*2^128 mod p
bp = b*p^-1 mod 2^128
z  = a*bp mod 2^128
r  = ((signed_high64(z) + 2)*p) >> 64
```

마지막 `r`은 centered 값에서 `[0,p)`로 branch 없이 정규화한다. 근거는
[corrected improved Plantard 논문](https://eprint.iacr.org/2022/956.pdf)의
수정된 범위 조건과 저자들의
[공개 구현](https://github.com/UIC-ESLAS/ImprovedPlantardArithmetic)이다.

31-bit RNS 소수는 `l=32`, `alpha=1`의 수정된 조건
`p < 2^(l-alpha-1) = 2^30`을 만족하지 않는다. 반면 `l=64`에서는 모든
소수가 조건을 충분히 만족한다. 따라서 이 실험은 잘못된 `l=32` 확장이
아니라 유효한 `l=64` 경로를 사용한다.

중요한 범위 제한은 다음과 같다.

- P1 성능 ELF에는 `kgen_mp31_cm55.s`를 링크하지 않았다.
- 현재 P1은 정확성 우선의 **scalar C + exact 32-bit limbs** 구현이다.
- M0는 4×32-bit MVE 어셈블리이므로 P1 대 M0 결과에는 reduction 방식뿐
  아니라 scalar 대 vector 실행 방식의 차이도 포함된다.
- q=12289 공통 NTT, FFT, sampler, CRT 및 Bezout은 변경하지 않았다.

## 정확성 및 오차

| 검사 | 결과 |
|---|---:|
| host exact-integer 모델 | 10,092,544 cases, mismatch 0 |
| 사용한 RNS 소수 | 308개 전부 |
| 보드 NTRU NTT 감사 | `logn=4..10`, 2,156 input cases (각 forward+inverse) |
| forward Plantard 대 독립 Montgomery | mismatch 0 |
| inverse Plantard 대 독립 Montgomery | mismatch 0 |
| NTT→iNTT round-trip | mismatch 0 |
| 최대 coefficient 모듈러 오차 | **0** |
| q=12289 NTT 512/1024 회귀 | mismatch 0, max error 0 |
| host `test_fndsa` | SHAKE/SHA3, codec, q math, fpoly, sampler, keygen, verify, self, KAT degree 2..10 PASS |
| 보드 full KAT digest | 22개 host oracle과 일치 |
| 정상 서명 검증 / 1-bit 변조 거부 | 512/1024 PASS |
| fault / ECC | CFSR/HFSR/AFSR=0, 실행 전후 TCM ECC ON |

감사용 ELF는 생산 Plantard 변환과 별도로 단순 1-layer Montgomery oracle을
포함하고, 각 coefficient를 직접 대조한다. 감사용 코드와 배열은 성능 ELF에
포함되지 않는다.

## 전체 API 성능

단위는 cycle/call이다. 각 degree·연산마다 10개 고정-seed batch를 사용했고,
각 batch는 10회 warm-up 후 10회를 측정했으므로 총 100회이다. 표는 정렬된
10개 batch의 upper median을 사용한다.

| degree | 작업 | M0 MVE Montgomery | P1 scalar `l=64` | 차이 | P1 변화율 |
|---:|---|---:|---:|---:|---:|
| 512 | 키 생성 | 46,824,803 | 65,280,829 | +18,456,026 | **+39.4151%** |
| 512 | 서명 | 17,145,671 | 17,199,326 | +53,655 | +0.3129% |
| 512 | 검증 | 323,031 | 323,070 | +39 | +0.0121% |
| 1024 | 키 생성 | 244,813,220 | 303,385,259 | +58,572,039 | **+23.9252%** |
| 1024 | 서명 | 36,737,446 | 36,844,970 | +107,524 | +0.2927% |
| 1024 | 검증 | 624,925 | 624,979 | +54 | +0.0086% |

같은 seed의 batch를 직접 짝지어 비교해도 P1 키 생성은 모두 느렸다.

- 512: batch당 +18,455,369~+20,102,982 cycles.
- 1024: batch당 +54,688,394~+62,455,475 cycles.

수정한 함수는 NTRU solve의 키 생성 경로에만 사용된다. 서명과 검증의 작은
변화는 Plantard 수행 시간이 아니라 ELF 코드 배치 및 실행 잡음에 따른 변화로
해석해야 한다.

pre-Slothy scalar 기준과 비교해도 P1 키 생성은 512에서 26.23%, 1024에서
16.52% 느렸다. 즉, 이번 구현은 MVE가 빠져서만 M0에 진 것이 아니라 현재의
여러 limb long-multiply 비용 자체도 충분히 크다.

## 측정 조건

- 실제 NUCLEO-N657X0-Q, Cortex-M55 r1p1, probe
  `003C00223335510735383531`.
- CPU / SYSCLK / HCLK: **800 / 400 / 200 MHz**.
- 동일한 `mlkem-native` Nucleo 메모리 배치와 TCM ECC 초기화 사용.
- GNU Arm **15.2.1**, Zephyr **4.4.1**, 최종 유효 **`-O3`**.
- `-mcpu=cortex-m55 -mthumb`, 동일 q=12289 `mq_cm55.s` 사용.
- 인터럽트 허용. 키 생성 내부 rejection sampling은 측정에 포함.

## 정적 상수시간 구조 검사

최종 성능 ELF의 `fndsa_mp_NTT`와 `fndsa_mp_iNTT`를 disassemble하여 확인했다.

- Plantard 곱과 보정은 coefficient 값에 따른 branch 없이 `UMULL`, `UMLAL`,
  carry 명령과 IT predication으로 생성됐다.
- 조건 분기는 공개 `logn`, layer/root loop counter에만 존재한다.
- coefficient 값으로 load/store 주소를 선택하지 않는다.
- FP16/FP32/FP64 명령과 `__aeabi` long-multiply/divide helper 호출이 없다.
- 두 변환의 유일한 함수 호출은 공개 modulus context를 만드는
  `mp31_plant64_init()`이다.

따라서 수정 경로는 기존 constant-time 설계의 정적 제어흐름 조건을 유지한다.
이는 형식적 constant-time 증명이나 전력/EM TVLA를 수행했다는 뜻은 아니다.

## 메모리와 식별값

| 항목 | M0 | P1 | 변화 |
|---|---:|---:|---:|
| 실행 코드 영역 | 108,188 B | 109,316 B | +1,128 B |
| DTCM 예약량 | 225,728 B | 225,728 B | 0 |
| main stack 사용 상한 | 9,624 B | 9,624 B | 0 |

감사용 P1 ELF는 실행 코드 111,772 B, RAM 234,176 B이다.

- `kgen_mp31.c` SHA-256:
  `379532b0557ef2fb60a1c227aa0d5e611190337cc4aeb8ab4f732c1d36d6416c`.
- P1 C/H/S tree SHA-256:
  `9ba9350fbc283d411c8ff6580c86b43d8a6bbb176165deb2cb48f238609369dd`.
- 성능 ELF SHA-256:
  `827bf987900885211759f9f6f7c807119c256b41ae2ff0570c3328b45ad963eb`.
- 감사 ELF SHA-256:
  `51053ac20118e597619754e886ddf84b68512c05bdfa37ced43fccc825ae1955`.

## 판단과 다음 단계

이번 실험으로 `l=64` corrected improved Plantard가 FN-DSA의 31-bit RNS
소수에서 정확하게 동작한다는 점은 확인했다. 하지만 Cortex-M55에는 이 식에
필요한 128-bit 곱을 한 번에 처리하는 정수 명령이 없어서, 현재 C 코드는 여러
`UMULL/UMLAL`과 carry 처리를 수행한다. 그 비용이 32-bit Montgomery MVE보다
크다.

따라서 다음 단계에서 Plantard를 계속 평가한다면 별도 후보로
`32×64/64×64 long multiply`를 직접 스케줄링한 어셈블리 또는 MVE hybrid를
구현해야 한다. 그 결과도 M0보다 빠르지 않으면 Plantard 후보는 중단하고
M1-improve Montgomery를 유지하는 것이 타당하다.

## 로그와 재현

- [P1 full raw log](../results/p1/runs/full-20260914T141529Z/raw.log)
- [P1 full 승인 manifest](../results/p1/full_validated.json)
- [P1 308-prime audit raw log](../results/p1_audit/runs/pilot-20260914T141457Z/raw.log)
- [P1 audit 승인 manifest](../results/p1_audit/pilot_validated.json)
- [M0 비교 raw log](../results/m0/runs/full-20260914T094508Z/raw.log)
- [정수 모델](../check_p1_model.py)
- [빌드 스크립트](../build_p1.sh)
- [보드 검증·측정 runner](../run_p1.py)

작업공간 루트에서 다음과 같이 재현한다.

```sh
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/check_p1_model.py
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/build_p1.sh p1
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/build_p1.sh p1_audit
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_p1.py p1_audit pilot
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_p1.py p1 pilot
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_p1.py p1 full
```

`full`은 동일 source tree와 ELF가 먼저 pilot 검증을 통과해야 실행된다.
