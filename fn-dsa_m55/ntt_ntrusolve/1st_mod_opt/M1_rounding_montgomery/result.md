# M1 rounding Montgomery 구현·검증 결과

2026-09-14. M1 폴더에 복사되어 있던 M0를 수정하여 구현을 완료했다.
실제 NUCLEO-N657X0-Q에서 곱셈 경계값, NTT/iNTT, KAT 회귀, 서명·변조 거부,
작업별 100회 측정을 통과했다. M0 및 다른 후보의 암호 소스는 수정하지 않았다.

이 문서는 복사되어 있던 M0 결과를 대체한다. 원래 M0 결과와 로그는
[별도 M0 결과](../M0_general_montgomery/result.md)에 그대로 있다.

## 구현한 내용

활성 암호 소스 변경은 [kgen_mp31_cm55.s](kgen_mp31_cm55.s) 하나다.
폴더 최상위 C/H/S 파일 31개 비교에서 나머지 30개는 M0와 byte-identical이다.

- mp_NTT와 mp_iNTT의 logn >= 4 MVE 경로를 rounding Montgomery로 교체.
- MVE 4×32-bit, 기존 2-layer CT/GS, root 순서, 정규 표현 [0,p)를 유지.
- 기존 gm/igm은 변경하지 않는다. inverse root의 half scale 및 단계별 halving도 유지.
- logn < 4는 기존 일반 Montgomery C 경로로 이동한다. 작은 변환까지 교체한 것은 아니다.
- CRT, Bezout, FFT, sampler, q=12289 mq_cm55.s는 변경하지 않았다.
- intrinsics나 다른 후보 파일을 끌어오는 방식이 아니라 이 .s에 직접 구현했다.
- 별도 전용상수 테이블이나 작업 버퍼는 만들지 않았다.

암호 소스 외에는 공용 measurement_mlkem_native/app/benchmark.c에 M1 곱셈
검사를 추가하고, 이 stage에 M1 빌드·실행·host/model/기계어 검사 스크립트를
추가했다. 공용 검사는 audit 빌드에서만 활성화되며 다른 후보의 구현을 연결하지 않는다.

### 31-bit 범위 보정

R=2^32, p0i=-p^-1 mod R이고, 입력 a와 원래 root b는 [0,p), p<2^31이다.

```text
twist = low32(b * p0i)                    # root를 읽을 때 q5에 준비
l = signed32(low32(a * twist))            # VMUL
h = floor(2*a*b/R + 1/2)                  # VQRDMULH
c = floor(2*l*p/R + 1/2)                  # VQRDMULH
z = floor((h+c)/2)                       # VHADD.S32
if z < 0: z += p                         # VPT / VADDT, scalar branch 없음
```

핵심은 3명령 VQRDMLAH 방식이 아니라 **4명령 + 정규화 2명령**이다.
root 전용상수 준비에는 별도로 VMUL 1개가 든다. root를 읽은 뒤 여러 곱셈이
쓰는 경우에만 이 준비 비용이 분산된다. 따라서 모든 곱셈이 무조건 1명령씩
줄어든다는 뜻은 아니다. M1은 rounding과 root 전처리를 함께 적용한 후보이므로
M0 대비 차이를 rounding 하나만의 효과로 분리해 해석하지 않는다.

q5는 M0에서 p를 보관했지만, M1에서는 root*p0i를 보관한다.
보정용 VQRDMULH는 GPR의 p(r3)를 직접 사용하므로 레지스터나 버퍼가 추가되지 않는다.
r4는 M0의 +p^-1 대신 호출자가 주는 p0i=-p^-1을 그대로 유지한다.

정확성의 대수적 근거:

1. l의 정의에 의해 a*b+l*p=k*R인 정수 k가 존재한다.
2. 두 rounded-high 결과의 합 h+c는 2*k 또는 tie에서 2*k+1이다.
3. VHADD의 산술 절반 처리는 두 경우 모두 k를 낸다. 음수 tie도 포함한다.
4. h와 c 각각은 signed 32-bit에 들어간다. 둘의 합은 넘을 수 있지만
   VHADD가 추가 합산 비트를 반영하므로 포화/래핑으로 잃지 않는다.
5. -p/2 <= k < p이므로 음수 lane에 p를 한 번 더하면 [0,p)의 정답이다.

이 분석은 a,b가 위의 정규 입력 범위에 있다는 계약에 의존한다.
lazy/out-of-range 표현으로 확장하려면 범위를 다시 검증해야 한다.
곱셈 내의 절반 처리는 doubling-high의 스케일을 상쇄하는 것이며,
NTT/iNTT의 수학적 정규화를 임의로 바꾼 것이 아니다.

근거는 [Neon NTT, Algorithm 8, PDF 12쪽](../../../../REFERENCE/Neon_NTT.pdf)의
rounding Montgomery 원리와
[Polynomial multiplication on embedded vector architectures, PDF 17쪽](../../../../REFERENCE/m55_ntt-ftt_opt.pdf)의
MVE rounding/known-factor 구현이다. 31-bit 전체 범위를 위한 VHADD 결합은
여기서 별도로 분석·검사한 변형이지 논문의 작은 소수용 3명령 구현을 그대로 복사한 것이 아니다.
VHADD의 합산 후 절반 의미는
[Armv8-M ARM C2.4.355, PDF 1139–1140쪽](https://community.arm.com/cfs-file/__key/communityserver-discussions-components-files/471/DDI0553B_5F00_y_5F00_armv8m_5F00_arm.pdf#page=1140)에 따른다.

## 정확성·KAT·서명 검증

| 검사 | 결과 |
|---|---|
| 독립 정수 모델: 308 primes, forward/inverse roots, 경계값·샘플 | 6,938,624건, mismatch 0 |
| 모델에서 실제로 검사한 rounding tie | 315,289건 |
| 모델에서 h+c가 signed 32-bit를 넘는 경우 | 705,463건 |
| 실제 M55 곱셈 매크로 대 기존 scalar Montgomery | 10,092,544건, mismatch 0, range error 0 |
| 실제 M55 NTT: 308 primes × logn 4..10 | 2,156개 polynomial test case, forward mismatch 0 |
| 실제 M55 iNTT 및 NTT→iNTT | inverse mismatch 0, round-trip mismatch 0 |
| NTT 비교 최대 모듈러 coefficient 오차 | 0 |
| q=12289 512/1024 회귀 | mismatch 0, max error 0 |
| host test_fndsa | SHAKE/SHA3, codec, q math, fpoly, sampler, keygen, verify, self, KAT degree 2..10 PASS |
| 보드 전체 API KAT 회귀 | 기존 독립 host oracle digest 22개와 일치 |
| 정상 서명 검증 / 1-bit 변조 서명 거부 | 512/1024 PASS |
| fault 상태 / TCM ECC | CFSR=HFSR=AFSR=0, 시작·종료 ECC ON |

보드 곱셈 검사는 308개 소수의 1024개 forward root 및 1024개 inverse root마다
12개 경계값과 4개 결정적 샘플을 검사한다. 0, 1, p-1, p-2 및
2^30-1, 2^30, 2^30+1 등을 포함한다. 전체 계수 공간의 수십억 값을 전수 검사한 것은 아니다.

fndsa_mp31_monty4_probe는 실제 MP31_MONT 매크로를 호출하는 검사용 entry이다.
별도 section에 두었으며 성능 ELF에서 제거됐음을 nm으로 확인했다.
검사 버퍼·검사 시간은 성능 ELF와 측정 구간에 포함되지 않는다.

host test_fndsa는 macOS arm64의 기본 NEON backend 회귀 시험이지 MVE 실행 시험이 아니다.
처음 NEON=0으로 강제한 host 빌드는 복사본에 이미 존재하던 scalar signing 경로의
mqpoly_sqnorm_int_to_signed C 정의 비활성화 때문에 링크하지 못했다.
이번 범위를 벗어난 C 코드는 고치지 않고 기존 host oracle과 같은 native backend로
회귀 시험했다. MVE와 M4 호환 서명 경로는 위의 실제 보드 시험으로 확인했다.
KAT는 저장된 기준값과의 회귀 일치이며 NIST 인증을 의미하지 않는다.

## 성능: M0와 M1

단위 cycle/call. 10개 batch의 upper median이며 각 batch는 10회 warm-up과
10회 측정이다. 따라서 degree·작업별 측정 100회, warm-up 별도 100회다.
동일한 고정 seed, 메시지, 입력 순서 및 키 생성 내부 rejection을 포함한다.

| degree | 작업 | M0 재측정 | M1 측정 | M1 cycle 차이 | 감소율 |
|---:|---|---:|---:|---:|---:|
| 512 | 키 생성 | 46,824,803 | 46,739,582 | -85,221 | 0.1820% |
| 512 | 서명 | 17,145,671 | 17,145,671 | 0 | 0.0000% |
| 512 | 검증 | 323,031 | 323,089 | +58 | -0.0180% |
| 1024 | 키 생성 | 244,813,220 | 244,533,885 | -279,335 | 0.1141% |
| 1024 | 서명 | 36,737,446 | 36,737,446 | 0 | 0.0000% |
| 1024 | 검증 | 624,925 | 624,920 | -5 | 0.0008% |

이 표는 전체 API 측정이다. mp_NTT/mp_iNTT 단독 개선율이 아니다.
서명·검증은 이번에 수정한 RNS transform을 호출하지 않으므로 해당 미세 차이를
알고리즘 개선 효과로 해석하지 않는다.

M1은 09:29 UTC, M0 재측정은 09:45 UTC에 같은 보드에서 실행했다. M0의 새
upper median은 기존 기록과 512에서 동일했고 1024에서는 1 cycle만 달랐다.
고정 seed가 같은 batch끼리 비교해도 M1 keygen은 512의 10/10개 batch에서
85,004~91,666 cycle, 1024의 10/10개 batch에서 264,512~294,708 cycle 적었다.
따라서 현재 빌드·보드 조건에서는 작은 개선이 반복 측정으로 확인됐다.

성능 ELF에서 NTT 시작 주소는 양쪽 0x10000330으로 같지만,
iNTT는 M0 0x10000694, M1 0x10000684이다. 후속 코드 배치도 달라진다.
이번 결과는 M0와 M1이라는 **완성된 구현 전체의 차이**이며 rounding 명령 자체만의
순수 microbenchmark는 아니다. 0.1~0.2% 수준의 효과를 더 정밀하게 분리하려면
함수 위치 고정과 교차 반복(예: M0→M1→M0→M1)이 추가로 필요하다.

### 유지한 빌드·보드 조건

- NUCLEO-N657X0-Q, Cortex-M55 r1p1, ST-LINK 003C00223335510735383531.
- CPU/SYSCLK/HCLK = 800/400/200 MHz, I/D cache OFF, TCM ECC ON.
- 코드·vector ITCM 256 KiB, 상수·데이터·스택 DTCM 256 KiB 구성.
- linker 출력의 FLASH 영역명은 ITCM 주소 0x10000000을 뜻한다. 물리 Flash 실행이 아니다.
- 기존 M0와 동일한 mlkem-native Nucleo pin 637d076aa113d8faaec2277ed4a46b657acaf35f 기반 환경.
  FN-DSA용 rodata DTCM 배치 및 FPU 설정 등 기존 이식 조정을 그대로 유지했다.
- GNU Arm GCC 15.2.1, Zephyr 4.4.1, 최종 application 옵션 -O3.
- -mcpu=cortex-m55 -mthumb -mfloat-abi=hard, M4 호환 assembly 및 MVE MP31 경로.
- M0와 M1의 Zephyr .config 파일은 byte-identical.
- 인터럽트 허용, k_cycle_get_64 block timing.
- 로그·digest·seed 준비는 측정 밖, API 내부 연산과 재시도는 측정 안.

## 상수시간 관련 검사

M1 최종 기계어를 M0와 비교했다.

- 두 함수의 scalar branch opcode 순서와 load/store operand가 동일하다.
- 새 곱셈은 coefficient에 따라 분기하거나 주소를 선택하지 않는다.
- root 및 소수는 공개 값이며 전용상수는 공개 root에서 계산한다.
- 음수 보정은 VPT/VADDT predication으로 한다.
- NTT/iNTT 각각 VQRDMULH 18개, VHADD 9개, VPT 27개가 정적으로 배치된다.
- 일반 VMULH 및 포화 누적 VQRDMLAH는 해당 MVE transform 본체에서 사라졌다.
- logn<4 fallback, odd/even 선택, loop 횟수는 기존 공개 logn/인덱스에 의존한다.

이는 정적 구조 검사와 범위 분석이다. 형식적 정보흐름 증명,
dudect류 통계적 timing leakage 검사, 전력/EM TVLA는 수행하지 않았다.
따라서 "상수시간 보안이 완전히 증명됐다"고 주장하지 않는다.

## 메모리

| 성능 ELF 항목 | M0 | M1 | 차이 |
|---|---:|---:|---:|
| 코드 영역 | 108,188 B | 108,156 B | -32 B |
| DTCM 예약량 | 225,728 B | 225,728 B | 0 |
| main stack 측정 사용 상한 | 9,624 B | 9,624 B | 0 |

NTT 본체는 866→850 B, iNTT 본체는 1,058→1,042 B다.
전용상수 표와 추가 scratch buffer는 없다.
검사용 audit ELF는 코드 110,228 B, RAM 234,176 B이며 성능용과 구분한다.

## 로그·식별값·재현

- [M1 full raw log](../results/m1/runs/full-20260914T092909Z/raw.log)
- [M1 full 승인 manifest](../results/m1/full_validated.json)
- [M1 보드 곱셈·NTT audit log](../results/m1_audit/runs/pilot-20260914T092827Z/raw.log)
- [M1 audit 승인 manifest](../results/m1_audit/pilot_validated.json)
- [비교에 사용한 M0 재측정 raw log](../results/m0/runs/full-20260914T094508Z/raw.log)
- [M1 host 회귀 로그](../results/m1/host/test_fndsa.log)
- [독립 정수 모델 결과](../results/m1/model.json)
- [기계어·소스 변경 검사 및 hash](../results/m1/build_audit.json)
- [최종 성능 ELF disassembly](../results/m1/disassembly.txt)

M1 assembly SHA-256:
c2227c83890eee1b6c49729910f325a0867cff5c8160481628175aadeed4c2a0

M1 performance ELF SHA-256:
03c96595ff8b5c7671e0f79f31d265fed410d73fac15706d610872782f4c9451

M1 audit ELF SHA-256:
aab12b1a73defc245e4264fab59c1f741e850391344fc557be472418a9379edf

작업공간 루트에서:

```sh
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/build_m1.sh m1_audit
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/build_m1.sh m1
bash fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/check_m1_host.sh
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/check_m1_model.py
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/audit_m1_build.py
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m1.py m1_audit pilot
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m1.py m1 pilot
python3 fn-dsa_m55/ntt_ntrusolve/1st_mod_opt/run_m1.py m1 full
```

보드 실행은 별도 하드웨어 접근 승인이 필요하다. full은 같은 ELF와 C/H/S hash의
pilot 통과를 먼저 확인한다. M1을 다른 ref 경로에 통합하거나 M0를 덮어쓰지는 않았다.
