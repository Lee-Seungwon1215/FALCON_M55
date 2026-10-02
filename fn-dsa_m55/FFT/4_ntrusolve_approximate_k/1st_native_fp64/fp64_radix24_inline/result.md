# FP64 계산량 감소 3단계: 실제 M55 결과

측정일: 2026-09-22. **3단계 구현, 13개 보드 실행 및 원본/후보 source·ELF
대조 완료. R3가 새 세 후보 중 가장 빠르다. 직전 16-bit FP64 ASM 대비
전체 키생성 cycle은 512에서 12.0203%, 1024에서 10.5879% 감소했다.**
세 후보 각각 원본 KAT 300/300을 유지했다. 기존 후보와 통합 ref는
변경하지 않았다.

## 구현

| 후보 | 경로 | 누적 변경 |
|---|---|---|
| R1 | [fp64_radix24](../fp64_radix24/) | 16-bit 4자리 → 24+24+16, 계수 부분곱 15→8 |
| R2 | [fp64_radix24_twiddle](../fp64_radix24_twiddle/) | R1 + FFT/iFFT 회전상수 분해와 wrapped 실수부+허수부 합 재사용 |
| R3 | 현재 폴더 | R2 + 실수 곱셈 함수 호출 제거, 복소수 helper 내부에서 계산 결합 |

각 후보의 변경 암호 파일은 `kgen_fxp.c` 하나다. R3의 실제 GCC ELF에는
큰 복소수 helper 호출 1회가 남고, R2의 작은 실수 곱셈 helper 3회 호출은
없어졌다. 모든 함수 호출을 0회로 만들었다는 뜻은 아니다.

8개 계수 부분곱은 직접 쓴 inline assembly의 VMUL 4개와 비융합 VMLA
4개로 계산한다. 분해·carry·정규화는 C double 산술이며 실제 FP64/VCVT
명령으로 컴파일된다. 직접 ASM이라고 해서 함수 전체를 손으로 쓴 것은
아니다. 원본 signed 보정·절삭·wrap·3-product 복소수 곱·iFFT half는 유지했다.

KAT 호환 two-double 구현의 계산량을 줄인 실험이며 일반적인
single-double 실수 FFT로 바꾼 것이 아니다. [설계와 정확성 범위](design.md).

## 조건

NUCLEO-N657X0-Q의 실제 연결 ST-LINK `003C00223335510735383531` 한 대에서
순차 실행. 800 MHz, cache OFF, ITCM/DTCM 각각 256 KiB 설정,
코드 하위 128 KiB ITCM 및 상수/데이터/스택 DTCM 정책이다.
기존 pinned mlkem-native `637d076aa113d8faaec2277ed4a46b657acaf35f` 기반
플랫폼을 사용하며 외부 flash에 저장하는 실험이 아니다.

GCC 15.2.1, `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math
-fno-strict-aliasing -fstack-usage`. 기존 M4/M55 ASM·MVE MP31 ON.
64 KiB stack 예약. 기준과 후보 모두 같은 harness·입력·옵션·배치 정책이다.
개별 함수 주소 자체는 고정하지 않았다.

전체 keygen: 각 크기 1회 warm-up 후 `test0`~`test99` 100개 seed.
DWT로 IRQ OFF 구간만 측정하고 출력/서명/검증은 시간에서 제외한다.
100개 입력 한 배치 결과이지 반복 배치 신뢰구간이 아니다.
profile은 별도 펌웨어이고 perf 전체 시간에 섞지 않는다.
원본 fixed 기준에는 기존 NTT 최적화가 있다. 태초 M4/FN-DSA 전체 ref가 아니다.

## 전체 키 생성: 새 세 후보

단위 cycles/key, 100개 seed 산술평균. 감소율의 양수는 cycle 절약이다.

| 후보 | 512 | 1024 | 바로 전 단계 대비 512 / 1024 감소 |
|---|---:|---:|---:|
| R1 | 195,261,612.62 | 616,588,172.75 | 이전 16-bit ASM 대비 7.4873% / 6.5061% |
| R2 | 188,826,586.01 | 597,985,947.49 | 3.2956% / 3.0170% |
| R3 | **185,694,030.30** | **589,669,326.12** | **1.6590% / 1.3908%** |

같은 harness로 재측정한 기존 FP64 C 대비 개선:

| 후보 | 512 cycle 감소율 | 1024 cycle 감소율 |
|---|---:|---:|
| R1 | 6.8999% | 5.9460% |
| R2 | 9.9681% | 8.7836% |
| R3 | **11.4617%** | **10.0522%** |

기존 FP64 C는 209,733,076.99 / 655,568,513.49 cycles/key,
원본 fixed는 57,007,002.15 / 243,375,295.54 cycles/key였다.
따라서 **R3도 fixed보다 512에서 3.2574배, 1024에서 2.4229배 시간이
걸린다.** 개선된 FP64 실험 후보이지 fixed보다 빠른 최종 FFT가 아니다.
기존 C도 이미 hardware FP64였으므로 이 변화는 software double을
hardware로 바꾼 효과가 아니다.

이전 16-bit ASM의 재측정은 211,064,606.87 / 659,495,898.14 cycles/key였다.
R3 대비 **12.0203% / 10.5879% cycle 감소**이며, R3를 이 FP64 실험군의
후속 연구 기준으로 사용할 수 있다. 그러나 fixed보다 여전히 느리므로
기존 성능용 통합 ref를 교체하지 않았다.

전체 성능을 계측한 6개 구현 및 R3 profile에서 200개 입력의 키·결정적
서명 digest가 모두 동일했다. 다른 키나 재시도 결과를 비교한 것이 아니다.
각 보드 실행의 fault 상태와 TCM/ECC 상태 검사도 통과했다.

## 커널에서 관찰한 변화

동일한 raw 입출력 wrapper로 곱셈을 256회 호출한 최소 cycle / 256:
FP64 C는 1,381.015625, R1/R2는 1,194.015625, R3는 1,168.015625였다.
wrapper 변환·호출·loop·sink 비용을 포함하며 FP64 명령 한 개의 latency가
아니다. R3에서는 wrapper 안으로 곱셈 body가 전개될 수 있으므로 순수
부분곱 연산 수만의 효과로 분리해서 해석하지 않는다.

NTRU 실입력 case 16, 내부 logn=9의 반복 커널 평균:

| 후보 | 같은 ELF의 기존 FP64 C | 후보 cycles/반복 |
|---|---:|---:|
| R1 | 14,076,734.00 | 12,781,936.00 |
| R2 | 14,076,222.00 | 12,013,930.00 |
| R3 | 14,071,868.28 | 11,762,064.00 |

반복 커널은 FFT→점별 곱→iFFT→반올림이며 입력 변환·정수 해 갱신은
제외된다. 10회 warm-up 후 100회, 순서를 교대했다. 모든 19개 사례의
값은 집계 JSON에 있다. 후보별 ELF 주소가 달라 기준 C도 미세하게
달라지므로 위 숫자는 같은 ELF 내 baseline과 함께 해석한다.

## 최종 후보의 ④ 구간 프로파일

별도 R3 profile 펌웨어에서 측정한 cycle 합을 100개 키로 나눴다.
서로 다른 크기의 반복 호출이 합산된 값이지 반복 한 번의 시간이 아니다.

| 크기 | 구간 | calls/100 keys | cycles/key |
|---|---|---:|---:|
| 512 | 입력 변환→FFT→역수 준비 | 879 | 4,720,999.47 |
| 512 | 반복 입력 변환→FFT→점별 곱→iFFT→정수 k | 92,174 | 129,682,802.06 |
| 1024 | 입력 변환→FFT→역수 준비 | 1,107 | 10,608,474.07 |
| 1024 | 반복 입력 변환→FFT→점별 곱→iFFT→정수 k | 251,354 | 351,020,764.20 |

반복 구간은 정확한 정수 NTRU 해 갱신 전에 끝난다.
⑤ depth0 및 후보 검사 경로는 이번 변경 대상이 아니다.

## 검증 결과

다음은 **R1/R2/R3 각각** 통과한 결과다.

| 검사 | 범위 / 결과 |
|---|---|
| 실제 보드 곱셈 | random 1,000,000쌍 + 경계 36,864쌍, 원본 fixed/FP64 C/후보 raw 일치 |
| Python 독립 모델 | 1,036,864쌍, signed 정수 oracle과 일치. 보드 random checksum도 `c665dcb55f68554d` 일치 |
| 변경하지 않은 add/half/div | 각각 random 100,000쌍 회귀 검사 PASS |
| 실제 NTRU 중간 입력 | 19개 사례, 각 10 warm-up + 100회, 준비/반복 raw 및 정수 k 일치 |
| FFT/iFFT 직접 비교 | logn 1..10 × 20종 입력, 총 81,840 coefficient positions에서 세 backend 일치 |
| 보드 원본 keygen KAT | **300/300**: 256·512·1024 각각 100개; 256은 진단 크기 |
| KAT 키 정수 방정식 / 범위 | 모두 PASS |
| 전체 keygen perf | 512·1024 각 100개 키의 서명·검증·변조 서명 거부 PASS |
| 입력별 timing | primitive 20종, FFT/iFFT logn 1..10 × 20종, 각 20 trial. 같은 연산·크기에서 입력별 최소 cycle 동일, 최대 trial 흔들림 1 cycle |
| 실제 ELF | 곱셈/복소수 helper의 조건분기·IT 없음, software double helper / fixed FFT fallback / fused FMA 없음 |

R3의 inlined 실수 곱셈은 production ELF에서 별도 symbol이 없으므로
그것을 별도 함수로 감사했다고 주장하지 않는다. 곱셈이 들어간 복소수
helper와 FFT/점별 곱/역수 준비 body를 함께 감사하고, standalone primitive는
커널 ELF에서 확인했다.

오차 0은 시험한 raw 값과 원본 사이의 차이가 0이라는 뜻이며 이상적인
실수 FFT의 근사 오차 0이 아니다. 상수시간은 소스/ELF 검토 및 유한 입력군
timing 관찰이며 완전한 증명·dudect·전력/EM 분석은 아니다. 전체 keygen은
후보 재시도로 가변 시간이다. host Python 모델이 Arm ASM을 실행하거나
sanitizer로 검증한 것처럼 취급하지 않는다.

## 메모리

| perf | R1 | R2 | R3 |
|---|---:|---:|---:|
| 링커 FLASH 영역 | 106,584 B | 107,392 B | 108,896 B |
| 링커 RAM 영역 | 220,296 B | 220,296 B | 220,296 B |
| 관찰 stack watermark 사용량 | 18,696 B | 18,696 B | 18,696 B |

링커 FLASH는 여기서 외부 flash 실행을 뜻하지 않는다.
R3는 R1보다 FLASH 영역 2,312 B 증가했고 RAM 예약 및 관찰 stack peak는
같았다. 관찰 peak는 모든 입력에서의 최대 사용량 증명이 아니다.

## 재현 및 원문

[README](README.md)의 label로 독립 소스 빌드/실행 가능.
원문은 [validation/results](validation/results/)의 각 label 아래에 보존하며,
`run.json`에 source/ELF/계측본/빌드 설정/raw log hash가 있다.
검증 중 소스와 실행 파일이 바뀌지 않았는지도 전후 검사한다.

- [독립 산술 모델](validation/results/model.json)
- [ELF 정적 감사](validation/results/static/summary.json)
- [빌드 로그](validation/results/build_logs/)
- [최종 집계](validation/results/summary.json)

| 구현 | 전체 키생성 raw log |
|---|---|
| fixed | [ref-perf](validation/results/ref-perf/20260922T070002Z/raw.log) |
| FP64 C | [c-perf](validation/results/c-perf/20260922T070050Z/raw.log) |
| 이전 16-bit ASM | [old-perf](validation/results/old-perf/20260922T070250Z/raw.log) |
| R1 | [r1-perf](validation/results/r1-perf/20260922T064617Z/raw.log) |
| R2 | [r2-perf](validation/results/r2-perf/20260922T065123Z/raw.log) |
| R3 | [asm-perf](validation/results/asm-perf/20260922T065624Z/raw.log) |

- R1 [KAT](validation/results/r1-kat/20260922T064422Z/raw.log) /
  [정확성·커널·CT](validation/results/r1-kernels/20260922T064225Z/raw.log)
- R2 [KAT](validation/results/r2-kat/20260922T064932Z/raw.log) /
  [정확성·커널·CT](validation/results/r2-kernels/20260922T064810Z/raw.log)
- R3 [KAT](validation/results/kat/20260922T065434Z/raw.log) /
  [정확성·커널·CT](validation/results/kernels/20260922T065314Z/raw.log) /
  [구간 profile](validation/results/asm-profile/20260922T065813Z/raw.log)
