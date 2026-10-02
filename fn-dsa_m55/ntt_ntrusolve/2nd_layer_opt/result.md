# Stage 2 결과 — L2 기준 vs L3 layer 병합

> **초기 실험 기록 — 현재 소스의 결과가 아님.** 아래 수치와 채택 판단은 forward 추가 개선 전 L3에 대한 것이다.
> 중간 개선은 [NTT_TUNING_RESULT.md](NTT_TUNING_RESULT.md), 최신 logn=4/6 개선은 [SMALL_LOGN_RESULT.md](SMALL_LOGN_RESULT.md)를 참조한다.
> 초기 소스·ELF·로그와 아래 보고서는 비교 이력으로 보존한다.

측정일: 2026-09-15. 실제 연결된 NUCLEO-N657X0-Q / STM32N657 / Cortex-M55 r1p1.

## 결론

L3의 직접 어셈블리 구현, 산술 검증, KAT/서명 회귀, 정적 구조 감사와 100회 성능 측정은 완료했다.
그러나 **이번 L3 전체 구현은 L2보다 키생성에서 512: 0.0346%, 1024: 0.0158% 느렸다.**
같은 입력의 10개 배치 모두 L2가 빨랐다. 따라서 **현재 기준은 L2 = M1_improve로 유지**하고 L3는 검증된 실험군으로 보관한다.
`ntt_opt`, 1단계 후보 및 다음 단계 폴더에는 이를 자동 승격하지 않았다.

일부 logn의 iNTT 및 logn=9 NTT는 개선됐으므로 “3-layer는 언제나 느리다”는 결론은 아니다.
아직 추가 scheduling/Slothy를 적용하지 않은, 아래 특정 구현·배치·보드 조건의 결과다.

## 무엇을 구현했나

암호 소스 변경은 [L3의 kgen_mp31_cm55.s](L3_three_layer/kgen_mp31_cm55.s) 하나다.
[L2](L2_two_layer/)의 모든 최상위 C/H/S는 1단계 M1_improve와 byte-identical하다.
두 후보의 `mq_cm55.s`, CRT, Bezout, FFT, sampler 및 C fallback은 같다.

- scalar GPR root/twist + MVE 4×32-bit의 depth-first 3-layer CT/GS.
- 32개 계수마다 원래 배열에 중간 벡터 2개만 저장/reload. 별도 계수 scratch 없음.
- M1 rounding Montgomery, canonical correction, signed GS 차이, 각 inverse layer의 half 보존.
- 마지막 CT2 / 첫 GS2 VLD4/VST4 보존, logn<4는 원래 C.
- 후보의 암호 코드를 다른 폴더·Makefile·링커 선택으로 끌어오지 않음.
- 빌드/측정/감사 스크립트는 암호 코드가 아닌 재현 도구다.

설계와 정확한 논문 출처는 [README](README.md)에 정리했다. 3-layer 외에 그 구현에 필요한
root 공급·dispatch·코드 배치도 바뀌므로 **순수 병합만의 기여도를 분리한 실험은 아니다.**

## 전체 성능

단위는 CPU cycles/call. **개선율 = 100 × (L2 − L3) / L2**이며 음수는 느려졌다는 뜻이다.
표는 10개의 batch 평균 중 upper median(정렬 후 6번째)을 사용한다.
10개 seed × seed마다 10회 = 작업별 100회이며, 각 batch/작업에 10회 warm-up이 별도로 있다.
100개의 독립 seed를 사용한 것은 아니다.

| degree | 작업 | L2 cycles | L3 cycles | L3 개선율 | 같은 입력 배치에서 L3 승 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 46,676,611.9 | 46,692,781.0 | -0.0346% | 0/10 |
| 512 | sign | 17,145,561.6 | 17,365,412.2 | -1.2823% | 0/10 |
| 512 | verify | 323,017.3 | 323,070.3 | -0.0164% | 2/10 |
| 1024 | keygen | 244,326,106.6 | 244,364,810.8 | -0.0158% | 0/10 |
| 1024 | sign | 36,737,446.1 | 37,213,315.1 | -1.2953% | 0/10 |
| 1024 | verify | 624,908.3 | 625,018.3 | -0.0176% | 2/10 |

키생성의 같은 seed 대조에서 L3의 추가 비용은 다음과 같다.

- 512: 호출당 16,057.4~16,322.9 cycles.
- 1024: 호출당 37,714.4~49,669.9 cycles.

참고로 보통의 median(5·6번째 평균)을 쓰면 keygen은 512: L2 46,058,121.3 / L3 46,074,343.9,
1024: L2 222,286,356.6 / L3 222,324,619.7 cycles다.
이전 표와 비교할 때 upper median과 standard median을 섞으면 안 된다.

**서명·검증 해석:** 수정한 RNS NTT/iNTT는 서명·검증 경로에서 호출되지 않는다.
특히 서명 약 1.29% 악화는 NTRU NTT 계산이 느려져서 발생한 것으로 해석할 수 없다.
암호 소스가 같아도 추가 assembly 때문에 뒤 함수들의 주소/명령 정렬이 달라졌다.
코드 배치 영향이 의심되지만, 해당 함수 주소를 고정한 별도 인과 실험은 하지 않았으므로 근본 원인을 확정하지 않는다.

## NTT/iNTT 직접 측정

각 logn/방향마다 10 batches × 100 calls. 표는 batch total/100의 median이고 정수 per_call 로그의 버림을 피했다.
첫 번째 RNS 소수의 성능이며, 308개 소수 전체 평균 성능은 아니다.
함수 내부 root/twist 준비, 진입/종료와 공개 dispatch가 포함된다. 외부 gm/igm 생성은 제외된다.

| logn | NTT L2 | NTT L3 | 개선율 | iNTT L2 | iNTT L3 | 개선율 |
|---:|---:|---:|---:|---:|---:|---:|
| 4 | 375.82 | 384.82 | -2.3948% | 429.80 | 437.80 | -1.8613% |
| 5 | 765.82 | 769.82 | -0.5223% | 895.80 | 892.80 | 0.3349% |
| 6 | 1660.82 | 1681.82 | -1.2644% | 1977.80 | 1997.80 | -1.0112% |
| 7 | 3699.82 | 3699.82 | 0.0000% | 4424.80 | 4406.80 | 0.4068% |
| 8 | 8180.82 | 8274.82 | -1.1490% | 9876.80 | 9837.80 | 0.3949% |
| 9 | 18255.82 | 18224.82 | 0.1698% | 22023.80 | 21909.80 | 0.5176% |
| 10 | 39960.82 | 40387.82 | -1.0685% | 48507.80 | 48363.80 | 0.2969% |

logn=4/6에는 3-layer가 없는데도 L3가 느리다. 기존 L2에 비해 계획 선택 및 dispatch가 추가된 비용이 포함되기 때문이다.
큰 logn에서도 저장/reload 감소가 그대로 실행시간 감소가 되지는 않는다. root/주소 계산, 범위 보정,
의존성 및 코드 배치가 함께 작용한다. 실제 pipeline stall을 PMU로 분해 측정하지는 않았다.

## 3-layer 위치 비교

| logn | 시험 | forward 계획 | NTT cycles | inverse 계획 | iNTT cycles |
|---:|---|---|---:|---|---:|
| 7 | early | 3+2+2 | 3720.82 | 2+2+3 | 4424.80 |
| 7 | middle | 2+3+2 | 3699.82 | 2+3+2 | 4406.80 |
| 7 | late | 2+3+2 | 3699.82 | 2+3+2 | 4406.80 |
| 9 | early | 3+2+2+2 | 18329.82 | 2+2+2+3 | 21999.80 |
| 9 | middle | 2+3+2+2 | 18308.82 | 2+2+3+2 | 21981.80 |
| 9 | late | 2+2+3+2 | 18224.82 | 2+3+2+2 | 21909.80 |
| 10 | early | 3+3+2+2 | 40576.82 | 2+2+3+3 | 48525.80 |
| 10 | middle | 2+3+3+2 | 40387.82 | 2+3+3+2 | 48363.80 |
| 10 | late | 3+2+3+2 | 40408.82 | 2+3+2+3 | 48381.80 |

최종 L3는 logn7=middle, logn9=late, logn10=middle이다.
logn4/5/6/8의 계획은 세 시험에서 동일하다. logn7의 middle/late도 같은 계획으로 재측정됐다.
최종 조합은 다시 all-prime audit를 통과했다.
이는 2-layer 경계를 유지한 대표 배치 비교이며 모든 radix/경계/스케줄링 전수 탐색은 아니다.

## 정확성·안전성 검사

| 검사 | 결과와 범위 |
|---|---|
| 독립 정수 Montgomery 모델 재실행 | 308 primes, 15,769,600 cases, mismatch 0. 기존 산술식 검사이며 병합/assembly 실행 모델은 아님 |
| 실제 M55 M1 vector 매크로 probe | 18,923,520 cases, mismatch/range error 0. 기존 vector-root 매크로 검사 |
| 실제 최종 L3 scalar-root 포함 전체 transform | 308 primes × logn4..10 = 2,156 forward/inverse 쌍, forward/inverse/roundtrip mismatch 0, 최대 modular error 0 |
| 기존 q=12289 NTT 회귀 | 512/1024 mismatch 0 |
| 호스트 전체 test_fndsa | self-test 및 내장 KAT logn2..10 PASS. 호스트 C 경로이며 MVE 검사를 대체하지 않음 |
| 보드 결정론적 KAT/digest | 각 full 실행의 22개 digest/AUDIT가 기존 호스트 oracle와 일치 |
| 서명 검증·변조 거부 | L2/L3 pilot 및 full PASS |
| Fault/ECC | CFSR/HFSR/AFSR=0, TCM_MSCR 시작/끝 0x1300a |
| 정적 상수시간 구조 | 변경한 경로에서 계수 의존 branch/address 발견 안 됨. 아래 한계 참조 |

계산은 정수 modular arithmetic이므로 허용 근사 오차를 두지 않는다. **검사한 모든 계수는 정확히 일치**했다.
위 KAT는 이 저장소 버전/호스트 oracle 기준이며 미확정 FN-DSA 표준에 대한 인증을 의미하지 않는다.

정적 검사는 disassembly의 branch와 core flag 작성 지점을 추출해 직접 검토했다.
분기는 logn, layer 계획, group/loop counter 또는 포인터 비교에 의존한다.
계수 부호 보정은 VPT/VADDT lane predication이고 계수로 주소나 scalar 분기를 고르지 않는다.
계수 영역은 공개 group/stride/lane으로만 접근한다. C fallback은 변경하지 않았다.
r4-r11 및 d8-d15 저장/복원, 8-byte stack 정렬, 5번째 인수의 SP+120 접근을 확인했다.
새 계수 stack spill은 없으며 함수 호출/정수 나눗셈/FP 변환 명령도 추가하지 않았다.

**한계:** 이는 정적 구조 감사 + 유한한 테스트다.
형식적 상수시간 증명, dudect/TVLA 등 통계적 leakage 시험, 전력/EM 부채널 시험은 수행하지 않았다.
전체 FN-DSA의 보안을 새로 증명한 것도 아니다.

## 동일 측정 조건과 실제 메모리

- 보드 probe: `003C00223335510735383531`.
- CPU 800 MHz / SYSCLK 400 MHz / HCLK 및 PCLK 200 MHz.
- GCC 15.2.1 20251203, Zephyr 4.4.1, 같은 Kconfig(바이트 단위 일치).
- `-mcpu=cortex-m55 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard`, 최종 유효 `-O3`.
  명령줄 앞의 -O2 뒤에 -O3가 오므로 최종 옵션은 -O3다.
- 같은 M4 호환 assembly 및 MVE MP31 선택 정의, LTO 없음.
- 두 빌드 모두 코드/벡터 ITCM, 전역 상수·데이터·스택 DTCM. FLEXMEM 구성은 각각 256 KiB.
- **런타임 CCR=0x611: IC/DC enable bit 17/16은 둘 다 0.** Kconfig의 ICACHE=y/DCACHE=y는 런타임 ON 증거가 아니다.
- 기존 ITCM 데이터 읽기 문제 회피용 rodata→DTCM 링크 및 startup 조치는 두 빌드에서 같다.
  따라서 mlkem-native Nucleo 기반 로컬 설정이며 upstream을 수정 없이 그대로 사용했다는 뜻은 아니다.
- 같은 입력·warm-up·반복 수·timer, production IRQ 상태 PRIMASK=0/BASEPRI=0.
- `mp_NTT` 시작은 둘 다 0x10000330. `mp_iNTT`는 L2 0x10000684 / L3 0x10000a64.
  나머지 함수 주소까지 동일하게 고정한 배치는 아니다.

| 메모리 | L2 | L3 | 차이 |
|---|---:|---:|---:|
| ITCM 점유 | 108,076 B | 110,204 B | +2,128 B |
| DTCM 점유(예약 스택 포함) | 225,728 B | 225,728 B | 0 B |
| 전체 main-stack 실측 상한 | 9,624 B | 9,624 B | 0 B |
| NTT/iNTT 호출 frame(ABI 저장 포함) | 112 B | 120 B | +8 B |

L3의 DTCM 남는 공간은 36,416 B다.
현재 로컬 링커는 코드에 128 KiB 상한을 추가로 두므로, 실제 코드 상한까지의 여유는 20,868 B다.
단순히 설정상 ITCM 256 KiB에서 뺀 수치와 구분해야 한다.

## 원본·재현 자료

- [L2 full raw log](results/l2/runs/full-20260915T070416Z/raw.log)
- [L3 full raw log](results/l3/runs/full-20260915T070750Z/raw.log)
- [최종 L3 all-prime audit](results/l3_audit/runs/pilot-20260915T070254Z/raw.log)
- [L2 all-prime audit](results/l2_audit/runs/pilot-20260915T065820Z/raw.log)
- [호스트 KAT](results/host/test_fndsa.log)
- [Montgomery 모델](results/static_audit/montgomery_model.json)
- [정적 감사·메모리·함수 주소](results/static_audit/audit.json)
- [전체 수치와 paired samples](results/comparison.json)
- [앞쪽 배치](experiments/early/results/l3_audit/runs/pilot-20260915T065930Z/raw.log), [중간 배치](experiments/middle/results/l3_audit/runs/pilot-20260915T065757Z/raw.log), [뒤쪽 배치](experiments/late/results/l3_audit/runs/pilot-20260915T070028Z/raw.log)
- [빌드·보드 실행·결과 재계산 방법](README.md#재실행)

처음 sandbox 내부 실행은 USB open 실패로 측정을 시작하지 못했다.
하드웨어 접근 권한으로 재실행한 이후 위 모든 시험은 정상 종료했다.
실패 로그도 experiments/middle에 남겼으며 성능 집계에는 포함하지 않았다.
