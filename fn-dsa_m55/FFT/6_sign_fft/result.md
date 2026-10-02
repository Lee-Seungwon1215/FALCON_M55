# 서명 FFT/iFFT 수작업 FP64 ASM 결과

이 문서는 **LDL 변경 전 A5 기록**이다. 현재 추가된 LDL 최적화 결과는
[ldl_result.md](ldl_result.md)에 별도로 기록했다.

측정일: 2026-09-28. 대상은 **서명의 `fpoly_FFT()`, `fpoly_iFFT()` 두 함수**다.
현재 채택본은 [sign_fft_cm55.s](sign_fft_cm55.s)의 A5 구현이다.
이전 C native FP64보다 빨라졌지만 **추가 개선은 커널 1.36~4.81%, 전체 서명 0.124~0.148%**다.
원본 에뮬레이션 대비 약 3.2배인 기존 전환 효과와, 이번 ASM의 증분 효과를 구분한다.

## 변경 범위

- `sign_fft_cm55.s` 추가: 두 함수 전체의 반복·주소 계산·FP64 연산·입출력을 직접 작성.
- `sign_fpoly.c`: 두 C 함수와 입출력 helper 제거. GM 비트는 그대로이며
  `fndsa_sign_gm`이라는 단일 상수표를 ASM 및 기존 split/merge가 공유한다.
- Makefile: 새 .s 한 개를 소스 목록에 추가. 다른 후보 연결/생산 구현 선택 옵션 없음.
- 다른 36개 생산 .c/.h/.s, 기존 함수의 계산, 표의 비트는 동결 C 기준과 동일함을
  `validation/analyze.py`가 검사한다. Final_code/Before_slothy, M55_ref, ntt_opt는 수정하지 않았다.
- FP64 스칼라 유지. FP32, Q32 재표현, fused FMA, SLOTHY는 적용하지 않았다.

## 커널: 현재 C FP64와 직접 비교

같은 ELF, 같은 입력·배열 주소. 준비/비교/출력은 계측 밖이며,
함수 호출·입출력·iFFT 정규화는 포함한다. 구현별 warm-up 3회와 100회 측정,
실행 순서는 원본/C/ASM 세 구현을 순환한다. 대표값은 upper median cycles/call.

| 함수 | n | 원본 정수 에뮬레이션 | 현재 C FP64 | 새 ASM | C 대비 사이클 감소 | 원본 대비 속도 |
|---|---:|---:|---:|---:|---:|---:|
| `fpoly_FFT()` | 512 | 602,975 | 190,425 | **187,178** | **1.71%** | 3.221배 |
| `fpoly_iFFT()` | 512 | 626,292 | 200,914 | **191,249** | **4.81%** | 3.275배 |
| `fpoly_FFT()` | 1024 | 1,353,794 | 427,504 | **421,686** | **1.36%** | 3.210배 |
| `fpoly_iFFT()` | 1024 | 1,403,665 | 448,998 | **429,621** | **4.32%** | 3.267배 |

최종 동일 생산 소스로 세 번의 커널 실행에서 대표값이 동일했다.
마지막 두 번에는 ABI 검사도 포함했다. 이번에는 측정 ELF·호출 배치가 달라졌으므로
과거 C 전환 보고서의 수치와 혼합하지 않았다. 위 표는 모두 이번 동일 ELF의 실측값이다.
같은 절대 코드 주소로 강제 배치한 실험은 아니며, 메모리 배치 정책·데이터 주소는 동일하다.

## 전체 서명

평균 cycles/sign. 같은 메시지·키·seed 목록·계측 프로그램을 사용했다.
원본은 이번에 100회 재측정했고, C FP64와 ASM은 각 100회를 두 번 반복했다.
seeded signing API 전체(재시도·키 준비·인코딩 포함)를 계측한다.
키생성/외부 검증/출력 fingerprint 계산은 계측 밖이다.

| n | Before_slothy 원본 | 현재 C FP64 | 새 ASM | C 대비 사이클 감소 | 원본 대비 속도 |
|---|---:|---:|---:|---:|---:|
| 512 | 18,017,473.49 | 14,873,579.47 | **14,851,581.47** | **0.148%** | 1.213배 |
| 1024 | 38,739,603.70 | 31,682,009.63 | **31,642,697.63** | **0.124%** | 1.224배 |

- 원본 대비 전체 서명 사이클 감소: 512 **17.57%**, 1024 **18.32%**.
- 이번 ASM으로 추가 감소한 시간: 512 약 21,998 cycles/sign, 1024 약 39,312 cycles/sign.
- C와 ASM의 반복 두 번은 100회 합계에서 최대 1 cycle 차이로 재현됐다.
- 512 fingerprint `9895079d`, 1024 `a020dd02`가 세 구현에서 동일했다.
- 커널 개선률을 전체 서명 개선률로 읽으면 안 된다. 이미 FP64로 바뀐 FFT를 더 줄인
  증분 효과이고, LDL·split/merge·sampler 등의 비용은 그대로 남는다.
- 이 실험에서 **전체 키생성·전체 검증 속도는 재측정하지 않았다.**

## 실제로 채택한 방법과 탈락 후보

[후보별 소스·수치 기록](validation/asm_experiments.md).
기본 ASM → 두 butterfly 교차 배치 → 비융합 VMLA/VMLS → 경계 레이어 전용 처리 →
경계 2레이어 병합 → iFFT 저장 시 정규화 → 전체 2레이어 병합 순서로 실측했다.
기본 ASM만으로는 FFT가 C보다 느렸고, 단순히 명령 수를 줄여도 빨라지지 않는 후보가 있었다.

최종 A5는 네 복소수(8개 D 레지스터), 세 복소 회전상수(6개), 임시값(2개)을
d0..d15에 배치한다. 두 레이어 사이의 저장/재읽기를 없애고, 회전상수는 그룹 안에서 재사용한다.
512는 복소 FFT 8개 레이어를 2+2+2+2, 1024는 9개를 2+2+2+2+1로 처리한다.

iFFT 출력의 크기 보정은 원본 `fpr_div2e()`와 같은 비트 규칙이다.
64비트 값에서 `e << 52`를 빼므로 하위 32비트는 변하지 않고 상위 워드만 조정하면 된다.
뺄셈 전후 부호 비트 차이로 원본과 동일한 복원 마스크를 만들어 signed zero도 유지한다.
최종 저장에 이 처리를 합쳤다. 이는 실수값을 두 double의 hi/lo 표현으로 바꾸는 기법이 아니다.

## 정확성·KAT·서명검증

| 검사 | 결과 |
|---|---|
| 원본 대 ASM | logn=1..10, 128입력 × 3경로 = 3,840 변환/실행, 불일치 0 |
| 원본 대 동결 C FP64 | 같은 3,840 경우에서 불일치 0 |
| 버퍼 guard | 오류 0 |
| ABI | 양방향 logn=1..10, 20회에서 r4..r11/d8..d15 보존; 두 번 모두 오류 0 |
| FFT→iFFT 왕복 오차 | 작은 정수 입력 최대 절대 오차 3.410605131648e-13 |
| 기본 키생성 KAT | 300/300 일치, NTRU 방정식 검사 통과 |
| 추가 키생성 KAT | 300/300 일치 |
| 서명 KAT | 90/90 일치, 두 번 반복; 정상 수락·변조 거부 |
| API 회귀 검사 | 정상 64건, 잘못된 입력 3,902건 거부; failures=0, guards=0 |
| 전체 서명 성능 시험 | 모든 정상 검증·변조 거부·fingerprint 통과 |
| 하드웨어 | 이번 ASM의 모든 실행에서 CFSR/HFSR/AFSR=0, TCM/ECC 조건 통과 |

원본 대비 출력 오차 0과 FFT 왕복 오차는 다른 지표다.
왕복에는 원본과 동일한 FP64 반올림 오차가 남는다.
유한한 시험이며 모든 가능한 입력의 동등성/오차 상한을 형식 증명한 것은 아니다.
원본 계약 밖의 NaN/Inf/subnormal은 동등성 주장 범위 밖이다.

## 상수시간 관련 검사

생성 기계어를 점검했다. 비밀에 따른 분기·주소·회전상수 인덱스는 없고,
분기는 공개 logn·레이어·루프 횟수에만 의존한다.
스케일링 마스크는 계수 비트에서 계산하지만 제어 흐름이나 주소에 사용하지 않는다.
FP64 나눗셈·제곱근·수치 형변환·함수 호출·fused FMA도 없다.

| n | 방향 | 8입력군 × 100회에서 min–max | 입력군 평균 최대 차이 |
|---|---|---:|---:|
| 512 | FFT | 187,177–187,178 | 0.01 cycles |
| 512 | iFFT | 191,248–191,249 | 0.01 cycles |
| 1024 | FFT | 421,685–421,686 | 0.01 cycles |
| 1024 | iFFT | 429,620–429,621 | 0.01 cycles |

성능 표와 CT 표는 계측 호출 위치가 달라 약 1 cycle 차이가 있다.
**이 검사는 정적 검토와 경험적 타이밍 스크리닝이며, 전체 서명/장치의 상수시간 형식 증명,
전력·EM 누설 검사는 아니다.** 기계어: [FFT](validation/fndsa_fpoly_FFT.dis),
[iFFT](validation/fndsa_fpoly_iFFT.dis).

## 보드·빌드·메모리

- NUCLEO-N657X0-Q / STM32N657, ST-Link `003C00223335510735383531`.
- 기존 pinned mlkem-native 플랫폼 / Zephyr 4.4.1.
- CPU/SYSCLK/HCLK 800/400/200 MHz, ITCM 코드 / DTCM 상수·데이터·스택, 각각 256 KiB.
- cache OFF, ECC ON. 측정 중 IRQ OFF, KAT/API는 원래 IRQ 상태 유지.
- GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard`,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 생산 라이브러리 standalone make 빌드 및 단일 FFT/iFFT 심볼 정의 확인 완료.

| 서명 성능 펌웨어 예약량 | 원본 | C FP64 | 새 ASM |
|---|---:|---:|---:|
| ITCM (링커 표시 FLASH) | 124,532 B | 124,128 B | 125,476 B |
| DTCM (링커 표시 RAM) | 245,496 B | 245,496 B | 245,496 B |

C FP64보다 ITCM **1,348 B 증가**. 두 함수 본체 합은 C 528 B, ASM 1,862 B
(리터럴 풀/정렬을 포함하는 전체 펌웨어 증가량과 구분).
ASM 고정 프레임은 logn>1에서 112 B다. DTCM 예약량은 stack high-water 실측값이 아니다.
별도 서명 KAT 펌웨어도 ITCM 127,872 B / DTCM 251,496 B로 범위 안이다.
추가 속도 이득이 작으므로 코드 크기 증가와 함께 판단해야 한다.

## 이전 ECC 이력과 현재 제한

이전 C 전환 실험의 builtin-memcpy 중간 바이너리에서는 서명 KAT가
`CFSR=0x100, HFSR=0x2, AFSR=0x10000000`으로 중단된 이력이 있다.
[이전 진단 로그](validation/results/candidate_sigkat/20260928T072548Z/raw.log).
직접 VLDR/VSTR C 버전 및 이번 최종 ASM에서는 재현되지 않았다.
ECC를 끄거나 클럭/캐시를 바꿔 통과시킨 것은 아니다.
그러나 **이전 하드웨어 ECC 문제의 근본 원인을 해결했다는 뜻은 아니다.**
이전 전체 기록·문서는 [C 기준 백업](validation/native_c_baseline.tar.gz)에 보존했다.

## 소스와 로그

- [실행 방법](validation/README.md), [기계 집계](validation/summary.json).
- [후보별 측정](validation/asm_experiments.md).
- `sign_fft_cm55.s` SHA256: `285a52ecc2b6eaf3f66a591c8b01b27362e78888df94acbbe8db5e2ba4163e81`.
- `sign_fpoly.c` SHA256: `92aded616f3eb7820338ed6f17e93b1aca14ec5c06b2c1ff2cf86f953d0821a0`.
- 각 실행 디렉터리에 raw.log, manifest.json, benchmark.elf, compile_commands.json,
  disassembly.txt, production_sources.tar.gz를 보존했다.

- baseline_sign: [20260928T083725Z](validation/results/baseline_sign/20260928T083725Z/raw.log)
- candidate_api: [20260928T083543Z](validation/results/candidate_api/20260928T083543Z/raw.log)
- candidate_extra: [20260928T083459Z](validation/results/candidate_extra/20260928T083459Z/raw.log)
- candidate_kat: [20260928T083414Z](validation/results/candidate_kat/20260928T083414Z/raw.log)
- candidate_kernel: [20260928T082942Z](validation/results/candidate_kernel/20260928T082942Z/raw.log), [20260928T083215Z](validation/results/candidate_kernel/20260928T083215Z/raw.log), [20260928T083820Z](validation/results/candidate_kernel/20260928T083820Z/raw.log)
- candidate_sigkat: [20260928T083255Z](validation/results/candidate_sigkat/20260928T083255Z/raw.log), [20260928T083809Z](validation/results/candidate_sigkat/20260928T083809Z/raw.log)
- candidate_sign: [20260928T083620Z](validation/results/candidate_sign/20260928T083620Z/raw.log), [20260928T083740Z](validation/results/candidate_sign/20260928T083740Z/raw.log)
- candidate_sign_native: [20260928T083606Z](validation/results/candidate_sign_native/20260928T083606Z/raw.log), [20260928T083755Z](validation/results/candidate_sign_native/20260928T083755Z/raw.log)
# 후속 LDL 변경 안내

아래는 LDL 변경 전 FFT/iFFT A5 측정 기록이다. 현재 소스에는 LDL FP64 전환이
추가되었으며, 그 변경만의 커널·서명 성능 및 검증 결과는 [ldl_result.md](ldl_result.md)에 있다.
기존 A5 로그·소스 archive·측정값은 그대로 보존한다.
