# 전체 MVE Keccak 지연 원인 분석과 후속 최적화

2026-09-29, 단일 `fndsa_sha3_process_block()` 대상. 최종 채택본 **A14**.
모든 상태 산술은 MVE 정수 ASM이며 주소·공개 카운터·ABI만 스칼라다.
SLOTHY/FP 산술/x4 상태 API는 사용하지 않았다.

## 결론

| 구현 | cycles/호출 | 최초 전체 MVE 대비 | 원본 대비 |
| --- | ---: | ---: | ---: |
| 원본 M4 ASM, 같은 M55에서 실행 | 13,382 | — | 1.00000× |
| 이전 C9 혼합형 | 12,521 | — | 1.06876× |
| 최초 전체 MVE A0 | 17,689 | 1.00000× | 0.75652× |
| **최종 전체 MVE A14** | **12,504** | **1.41467×** | **1.07022×** |

A0 대비 **29.312%**, 원본 대비 **6.561%** 사이클 감소.
C9와는 17 cycles(0.136%) 차이라 큰 추가 개선으로 주장하지 않는다.
C9 수치는 같은 프로그램의 직전 보존 기록이고, 이번 최종 반복 비교는 원본/A14를 다시 실행했다.
**전체 MVE의 성능 저하를 해결하여 혼합형 수준까지 회복한 결과**다.
시험한 후보 중 최저값이지 가능한 모든 설계의 전역 최적해는 아니다.
FN-DSA 전체 키생성·서명·검증 속도를 이번에 다시 측정한 결과도 아니다.

## 먼저 확인한 지연 원인

A0를 별도 계측하여 C9의 기존 비중표를 그대로 재사용하지 않았다.
24라운드 모두 timestamp를 기록하고, 77개 tap의 인접 계측 비용을 보정했다.

| 구간 | C9 혼합형 | A0 전체 MVE | A0−C9 |
| --- | ---: | ---: | ---: |
| 입출력·비트 분리/복원 | 2,021 | 1,627 | −394 |
| θ + ρ/π | 5,976 | 9,336 | **+3,360** |
| χ + 다음 열 XOR | 4,320 | 5,760 | **+1,440** |
| 초기화·ι·제어·복귀/계측 잔여 | 204 | 966 | +762 |
| 합계 | 12,521 | 17,689 | +5,168 |

따라서 “벡터 입출력 변환이 느려서”가 주원인은 아니었다.
A0의 라운드에는 반복 gather, 회전 준비, 패딩/중복 처리, 별도 ι 읽기·쓰기가 늘었고,
load/store와 ALU가 몰려 명령 중첩 여지가 적었다.
단계별 시간과 후보 비교가 이를 뒷받침하지만 개별 cache/bank stall event를 센 것은 아니다.
특정 hazard가 정확히 몇 cycles를 차지했다고 단정하지 않는다.

A0 raw: [trace](full_mve_profile/results/trace/20260929T142554Z/raw.log),
[계측 없는 커널](results/mve/20260929T141622Z/result.md).
A0 trace 총 18,150−77×6=17,688 cycles, 커널 17,689와 약 1 cycle 차이.
C9의 별도 계측은 [기존 보고서](phase_profile/result.md).
두 버전 간 구간값은 intrusive 계측의 추정치다.

## 실제 시험한 후보

모든 행은 같은 보드/커널 harness, 100표본×64호출의 빈 루프 차감값(정수 반올림).
모든 후보가 독립 Keccak oracle 1,024회, SHAKE256 7벡터, ABI/guard 검사를 통과했다.
**전체 FN-DSA KAT는 마지막 최종 소스에서 별도로 재검사했다.**

| 후보 | 출발점 | 변경 | cycles | 판정·로그 |
| --- | --- | --- | ---: | --- |
| A0 | 최초 전체 MVE | even/odd 내부 표현 | 17,689 | [기준](results/mve/20260929T141622Z/result.md) |
| A1 | A0 | θ에서 연속 load 활용, 다섯 번째 보정값의 불필요한 gather 감소 | 17,569 | [유지](results/mve/20260929T142742Z/result.md) |
| A2 | A1 | source-row ρ/π, 보정값 Q6/Q7 유지, 공개 mask 선택·scatter | 18,673 | [탈락](results/mve/20260929T142932Z/result.md) |
| A3 | A1 | 내부 canonical low/high 표현, 회전과 상수 준비 단순화 | 16,380 | [유지](results/mve/20260929T143237Z/result.md) |
| A4 | A3 | θ를 별도 연속 pass로 적용, ρ/π에서 D gather 제거 | 16,812 | [탈락](results/mve/20260929T143436Z/result.md) |
| A5 | A3 | χ 다음 행 입력 네 개를 현재 행 저장 전에 prefetch | 16,188 | [유지](results/mve/20260929T143605Z/result.md) |
| A6 | A5 | ι를 첫 행 χ/열 parity에 결합 | 15,636 | [유지](results/mve/20260929T143745Z/result.md) |
| A7 | A6 | prefetch를 VBIC/VEOR 사이로 분산, Q 역할 순환 | 14,196 | [유지](results/mve/20260929T144153Z/result.md) |
| A8 | A7 | 마지막 ρ/π lane을 고정 주소·즉시 회전·MVE predicate로 처리 | 13,764 | [유지](results/mve/20260929T144311Z/result.md) |
| A9 | A8 | 음수 shift량도 상수표에 저장하여 매회 계산 제거 | 13,620 | [유지](results/mve/20260929T144357Z/result.md) |
| A10 | A9 | 고정 회전을 shift+VSRI로 단축 | 13,332 | [유지](results/mve/20260929T144448Z/result.md) |
| A11 | A10 | ρ/π load·XOR·shift·store 교차 배치 | 12,708 | [유지](results/mve/20260929T144551Z/result.md) |
| A12 | A11 | 다음 ρ/π 묶음의 공개 주소표 미리 읽기 | 12,660 | [유지](results/mve/20260929T144704Z/result.md) |
| A13 | A12 | θ low/high 독립 회전·저장 교차 배치 | 12,564 | [유지](results/mve/20260929T144749Z/result.md) |
| **A14** | A13 | 연속 상태 입출력을 VLD2/VST2로 분리·결합 | **12,504** | [채택](results/mve/20260929T144842Z/result.md) |
| 최종 정리 | A14 | 사용하지 않는 상수표 제거·주석 정정 | **12,504** | [동일 성능](results/mve/20260929T145011Z/result.md) |

A2는 보정값 재사용만 바꾼 독립 실험이 아니라 mask/scatter까지 함께 바뀐 후보다.
따라서 “scatter 하나 때문에 정확히 1,104 cycles 손해”처럼 원인을 분리해 주장하지 않는다.
A4는 메모리 왕복을 늘리는 대신 gather를 줄였지만 전체로는 손해였다.
최종 소스에는 탈락 후보 분기나 구현 선택 매크로가 없다.
각 후보 전체 소스는 해당 결과 폴더의 `sources.tar.gz` → `production/sha3_cm55.s`에 보존했다.

## 참고한 코드·논문과 적용 범위

1. [keccak_ref의 handwritten x4 코드](../../../keccak_ref/common/keccak_m55/asm_x4/hand/keccakx4_hand.S)
   - `KX4_THETA_APPLY`, `KX4_RHOPI_STEP`, `KX4_CHI_ROW`의 low/high 정수 표현,
     보정값 재사용, 입력을 레지스터에 유지하는 방식을 검토했다.
   - x4는 **서로 독립적인 네 상태**를 처리하므로 우리 단일 상태 API에 그대로 붙이지 않았다.
   - 내부 low/high 표현(A3)과 재사용 실험(A2/A4)으로 재설계했다.
2. [Polynomial multiplication on embedded vector architectures](../../../REFERENCE/m55_ntt-ftt_opt.pdf), §3.2–3.3, pp.8–10
   - 8개 Q 레지스터의 제약, MVE instruction overlap, VLD2/VST2의 배치 원리를 참고했다.
   - A7/A11/A12의 수동 레지스터·명령 배치 및 A14 입출력에 적용했다.
3. [Fast and Clean: Auditable high-performance assembly via constraint solving](../../../REFERENCE/m55_slothy.pdf),
   §3.2.2, §5.3, §6.2(pp.20–21)
   - M55의 별도 vector LSU/산술 실행 경로, dual-beat, 일부 주소 정렬에서
     `VSTx; ?; VLDx`가 만드는 ST-LD hazard, 실제 보드 검증 필요성을 참고했다.
   - 이 원리로 **사람이 직접 스케줄링**했다. SLOTHY 실행·생성 코드는 사용하지 않았다.
   - 논문의 특정 latency 모델이 모든 명령·정렬에서 정확하다는 가정은 하지 않았다.

이번에는 관련 코드와 두 논문의 해당 절을 읽고 적용했다.
REFERENCE 전체 논문을 새로 모두 정독했다거나 위 논문이 이 단일 Keccak 구현을 제시했다고 주장하지 않는다.

## 최종 구간별 재측정

분모는 `process_block()` 12,504 cycles. 최종 소스 SHA가 같은 plain/trace 한 쌍으로 측정했다.
ι가 χ에 합쳐졌으므로 최종 χ 행에는 ι 비용도 들어 있다.

| 구간 | A0 | 최종 A14 | 최종 비중 |
| --- | ---: | ---: | ---: |
| 입출력·비트 분리/복원 | 1,627 | **425** | 3.399% |
| θ + ρ/π | 9,336 | **7,536** | 60.269% |
| χ + 다음 열 XOR (최종은 ι 포함) | 5,760 | **4,320** | 34.549% |
| 초기화·제어·복귀/계측 잔여 (A0는 별도 ι 포함) | 966 | **223** | 1.783% |
| 합계 | 17,689 | **12,504** | 100% |

저하의 주요 구간을 실제로 줄였으며, 현재도 가장 큰 부분은 θ·ρ·π다.
C9와 비교하면 최종 θ·ρ·π는 여전히 1,560 cycles 더 들지만,
입출력·표현 변환이 1,596 cycles 줄어 전체가 비슷한 수준에 도달한다.
즉 **24라운드 자체가 C9보다 대폭 빨라졌다는 의미는 아니다.**

[plain](full_mve_profile/results/plain/20260929T145339Z/raw.log) /
[trace](full_mve_profile/results/trace/20260929T145343Z/raw.log) /
[집계 JSON](full_mve_profile/summary.json).

- plain .text는 실제 소스 .text와 byte-identical.
- trace는 정적 8곳, 동적 77개 tap(+192 B). R2/R3가 죽어 있는 경계에서만 기록.
- trace 총 12,964 cycles, 보정 462 cycles → 12,502. plain 12,504와 약 2 cycle 차이.
- 남은 약 2 cycle은 전체 계측 교란 점검이며 각 구간의 오차 상한은 아니다.
- 표는 계측 보정 추정치이고 하드웨어 stall counter 분석은 아니다.

## 정확성·KAT·상수시간 점검

최종 정리 소스 SHA-256:
`fe2febdb478c0bb4cb5ab3150a512b80b2c897ee921e1133e5fcac796e2733ca`.

| 검사 | 최종 결과 |
| --- | --- |
| 독립 canonical Keccak oracle | 1,024회, 25개 lane 모두 bit 일치 |
| SHAKE256 | hashlib 7벡터, 경계·다중 block 포함, 일치 |
| 기존 helper 회귀 | 5,120건 통과 (활성 MVE helper의 독립 성능 검사가 아님) |
| ABI | 16건, R4–R11/D8–D15 보존 |
| [키생성 KAT·NTRU 방정식](results/mve_kat/20260929T145122Z/raw.log) | **300/300, mismatches=0** |
| [서명 KAT·검증·변조 거부](results/mve_sigkat/20260929T145235Z/raw.log) | **90/90, mismatches=0** |
| [API·가드](results/mve_api/20260929T145253Z/raw.log) | 정상64, 비정상3902 거부, failures=0, guards=0 |
| 하드웨어 | CFSR/HFSR/AFSR=0, TCM/ECC 정상 |
| 독립 라이브러리 | 기존 Makefile 빌드 통과 |
| 정적 감사 | [통과](static_audit.json) |

원본 ABI와 SHAKE 스트림·패딩·라운드 상수를 바꾸지 않았다.
정수 비트 연산이므로 FP 근사 오차는 없고, 시험 결과의 bit 오차는 0이다.
KAT 통과는 전체 입력 공간의 동등성 형식 증명은 아니다.

정적 감사에서는 실제 ELF의 조건 분기가 공개 24라운드 루프 하나이고 호출이 없음을 확인했다.
스칼라 상태 계산은 없으며, scalar memory는 ABI 저장과 old-SP 저장/복원뿐이다.
공개 gather 표를 독립 forward ρ/π 좌표와 대조했고, 마지막 lane 주소·회전·predicated store,
ι 상수의 zero padding도 검사했다. 모든 유효 주소는 공개 상수/포인터에서 나온다.
내부 padding의 불필요한 계산값은 실제 25개 lane으로 재유입되지 않도록 검토했다.

zero/random 각1,000회의 raw 단일 호출은 모두 12,507 cycles였다.
관측 분산이 모두0이므로 Welch t는 정의되지 않는다.
제한된 타이밍·정적 검사는 상수시간 형식 증명, 전력/전자파 또는 fault 공격 평가가 아니다.

## 조건·메모리·범위

NUCLEO-N657X0-Q(serial 003C00223335510735383531), 800 MHz, ITCM 코드,
DTCM 데이터·스택(각256 KiB), cache OFF, GCC15.2.1, -O3.
동일 입력·진입주소 0x10000844, 5배치 예열, 100표본×64회, DWT/IRQ OFF/빈 루프 차감.
보드는 공유 lock으로 직렬화했다. lock이 점유된 동안의 진단 실행 1회는 보드 접근 전에
거부되었고 API 종료 뒤 재실행했다. 유효하지 않은 측정값을 성능표에 사용하지 않았다.

| 항목 | A0 | 최종 |
| --- | ---: | ---: |
| 함수+라운드 상수 | 5,416 B | 3,196 B |
| ASM .text (보존 helper 포함) | 6,700 B | 4,480 B |
| 배치 상수표 | 896 B | 704 B |
| 자체 최대 스택 (ABI/정렬 포함) | 1,056 B | 1,056 B |

스택은 명령 기반 상한이고 전체 호출 체인 high-water 실측이 아니다.
현재 소스는 [sha3_cm55.s](../sha3_cm55.s)에 직접 구현했다.
`sha3.c`, 다른 암호 소스, 원본 `sha3_cm4.s`, 외부 Final_code는 변경하지 않았다.
A0/C9를 몰래 되돌린 것이 아니며 `process_block` 경로는 마지막 lane까지 MVE다.

커널 ELF SHA-256:
`961261f33af014a872db01b6f21187f1646ffd1f0af79d098883d32876c21c60`.
각 결과 폴더에는 ELF/map/역어셈블리/원본 소스 archive/해시/유효성 manifest를 보존했다.

최종 연속 재측정: [원본 13,382 cycles](results/ref/20260929T145455Z/result.md),
[최종 12,504 cycles](results/mve/20260929T145459Z/result.md).
최종 두 실행의 평균 12,504.00015625, 중앙값/최소 12,504, 최대 12,504.015625 cycles.
최대값은 64회 배치에 1 cycle이 더해진 경우다. 최종 ELF 해시도 동일했다.
