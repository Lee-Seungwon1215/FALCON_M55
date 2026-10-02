# 10단계: 작은 FFT/iFFT 레이어의 그룹 간 4-lane 패킹

측정일: 2026-09-25 KST. 디렉터리 시각은 UTC다.

## 결론

**직전 9단계 대비 FFT/iFFT 계산 코어 시간이 54.33~56.98% 감소했다.**
두 작은 레이어가 차지하던 병목은 해결 방향이 맞았고, 코어만 비교하면 단독 Q32 기준보다 22.01~31.45% 짧다.
그러나 **현재 공개 함수 전체는 M55_ref 원본 함수 본문을 포함한 고정소수점 기준보다 19.83~38.77% 느리다.**
변환·상수 준비를 포함해 원본을 이겨야 한다는 채택 조건은 아직 충족하지 못했다.
이번 구현은 독립 실험 및 통합 후보에만 유지하고, 정상 M55_ref/ntt_opt/fft_keygen은 교체하지 않았다.

## 직접 바꾼 구현

- `tw32_mve/tw32_primitives_cm55.s`에 `ds32_tail_fwd4()` / `ds32_tail_inv4()`를 직접 작성했다.
- ht=1: 네 그룹의 butterfly를 한 벡터로 처리. x 계수 인덱스 [0,2,4,6], y [1,3,5,7].
- ht=2: 두 그룹을 묶음. x [0,1,4,5], y [2,3,6,7].
- 각 lane에 해당 그룹의 서로 다른 twiddle을 읽는다. ht=2에서는 같은 twiddle이 두 lane씩 반복된다.
- 고정 공개 오프셋을 쓰는 MVE gather/scatter로 실제 계수 배열에 직접 접근한다.
  C 임시 ds4 배열로 패딩/복사하는 과정을 새 경로에서 없앴다.
- 어셈블리를 그룹마다 호출하지 않고, 한 레이어 전체에 한 번 호출한다.
  작은 두 레이어의 asm 호출은 512: 192→2회, 1024: 384→2회.
- 표현은 실수부/허수부 각각 2×FP32(hi+lo) 그대로다.
  TwoSum, FMA 잔차, 저차항 누적, 정규화 순서를 변경하지 않았다.
- iFFT의 마지막 2/n 스케일링도 유지했다. 두 레이어를 서로 병합하지 않았다.
- 적용 범위는 logn=4..10의 ht=1/2 경로. logn=2/3의 작은 입력 경로는 그대로 보존했다.
- C의 변환 루프에 공개 크기 기반 직접 호출을 추가했다. 빌드 옵션/링크 치환으로 구현을 선택하지 않았다.
  CMake에 추가한 것은 새 검사용 소스뿐이다.

통합 후보의 동일 asm은 해시까지 일치한다. 다만 통합 후보는 기존과 같이 회전상수를 필요할 때 변환한다.
작은 레이어는 6 KiB 임시 root 배열을 예약된 64 KiB 스택 안에서 사용하여 한 번에 전달한다.
24 KiB 영구 상수표를 추가하지 않았다. 단독 비교는 기존과 같이 사전 변환된 상수표를 쓴다.

## 코어 성능: 같은 펌웨어에서 9단계와 비교

단위 cycles/call, 10 batches × 100 calls, batch 평균의 상위 중앙값.
입력/출력 표현 변환과 상수표 초기화는 제외했다. 같은 입력·버퍼 주소, 실행 순서 교대.
코드 주소까지 동일하게 고정한 실험은 아니다.

| n | 연산 | Q32 단독 코어 | 직전 9단계 | 이번 10단계 | 9단계 대비 시간 감소 | 9단계 대비 배율 | Q32 대비 시간 감소 |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | fft | 115,427 | 209,195 | **90,026** | **56.97%** | 2.32배 | 22.01% |
| 512 | ifft | 140,281 | 224,449 | **96,553** | **56.98%** | 2.32배 | 31.17% |
| 1024 | fft | 256,511 | 437,586 | **199,825** | **54.33%** | 2.19배 | 22.10% |
| 1024 | ifft | 312,344 | 469,285 | **214,123** | **54.37%** | 2.19배 | 31.45% |

여기서 FFT/iFFT 두 코어는 네 공개 entry point가 공유하는 실제 변환이다.
Q32 단독 코어는 이 비교 프로젝트의 Q32 연산 구현이다. 아래 표는 별도로 M55_ref 함수 본문을 보존한 기준과 비교한다.
두 표는 타이머 경계·함수 배치·상수 준비 정책이 다르므로 cycle을 서로 빼서 개별 변환 비용이라고 단정하면 안 된다.

## 작은 두 레이어의 변화

이 표의 '전'은 직전 [레이어 계측](../../results/20260924T144221Z/layer_profile.md),
'후'는 이번 레이어 계측이다. 서로 다른 ELF이므로 개별 구간 개선율은 참고값이며,
주 성능 결론은 위의 동일 ELF 비교를 사용한다.
비중의 분모는 각각 계측된 FFT/iFFT 코어이며 키 생성 전체가 아니다.

| n | 연산 | 두 레이어 cycles 전 | 후 | 구간 시간 감소 | 코어 비중 전 | 후 |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 512 | fft | 148,106 | 24,694 | 83.33% | 69.11% | 27.19% |
| 512 | ifft | 152,516 | 25,560 | 83.24% | 67.88% | 25.79% |
| 1024 | fft | 296,138 | 49,142 | 83.41% | 66.17% | 24.52% |
| 1024 | ifft | 304,964 | 50,872 | 83.32% | 64.95% | 23.30% |

새 코드의 큰 레이어·ht=2·ht=1·scaling·나머지를 합치면 100%다.
[개별 레이어/합계 JSON](../../results/20260924T150011Z/layer_summary.json)에 34개 레이어를 모두 저장했다.
새 계측본은 현재 비계측본보다 0.44~2.75% 정도 길다. 타이머 비용을 임의로 빼지 않았다.
로그의 `control`은 이제 **이전 9단계**이며, 계측 오버헤드 측정을 위한 동일 구현이 아니다.

## 공개 함수 전체: 아직 기준보다 느림

최종 로그: [kernels/20260924T151012Z](../../integration_candidate/validation/results/kernels/20260924T151012Z/raw.log).
100회 평균, warmup 10회, backend 실행 순서 교대. IRQ mask.
내부 double↔2×FP32 변환과 상수 준비를 포함한다. 외부 입력 초기화·복사는 제외한다.

기준 `vect_FFT_fixed()` / `vect_iFFT_fixed()`의 본문과 핵심 fxr/fxc helper가
`fn-dsa_m55/M55_ref`와 같은지 [소스 검사](../../results/20260924T150011Z/fixed_reference_audit.json)했다.
이 표는 과거 M55_ref 전체 펌웨어 수치가 아니라, 그 원본 함수를 같은 측정 이미지에 넣은 결과다.

| 함수 | n | M55_ref 고정소수점 함수 | 이번 공개 함수 | 기준 대비 시간 증가 |
| --- | ---: | ---: | ---: | ---: |
| `vect_FFT_fp64()` | 512 | 125,906.01 | 174,718.00 | **+38.77%** |
| `vect_FFT()` | 512 | 125,906.01 | 174,718.00 | **+38.77%** |
| `vect_iFFT_fp64()` | 512 | 143,330.00 | 180,480.00 | **+25.92%** |
| `vect_iFFT()` | 512 | 143,330.00 | 180,479.00 | **+25.92%** |
| `vect_FFT_fp64()` | 1024 | 280,372.01 | 368,791.00 | **+31.54%** |
| `vect_FFT()` | 1024 | 280,372.01 | 368,791.00 | **+31.54%** |
| `vect_iFFT_fp64()` | 1024 | 318,464.01 | 381,601.00 | **+19.83%** |
| `vect_iFFT()` | 1024 | 318,464.01 | 381,600.00 | **+19.83%** |

로그의 backend=`fp64`는 예전 측정기의 이름이며, `*_fp64()` entry point를 의미한다.
이번 FFT/iFFT 내부는 native FP64가 아니라 **2×FP32 MVE**다.
유지한 FP64 invnorm은 변경하지 않았으며 별도 검사에서 Q32 차이 0이었다.
계산 코어 개선을 공개 함수 전체의 Q32 대비 개선이라고 보고하지 않는다.
남은 후보는 bridge의 표현 변환과 통합 후보의 반복 상수 준비 비용이다. 각각의 기여도는 이번에 따로 계측하지 않았다.

입력 변환만 포함한 단독 benchmark도 전보다 43.69~46.05% 줄었지만 Q32보다 0.99~21.41% 느렸다.
이 단독 benchmark에는 출력 변환은 포함되지 않는다.

## 정확성·KAT·서명검증

| 검사 | 결과 |
| --- | --- |
| 새 작은 레이어 vs 기존 비-span asm, logn 4..10·ht1/2·정렬·4패턴 | **224/224 raw byte 일치** |
| 기존 span 회귀 | **1,408/1,408 일치** |
| 전체 FFT/iFFT vs 이전 7단계, logn 2..10 | **180/180 raw byte 일치** |
| 현재/이전 9단계/현재 계측본, warmup 포함 | **880/880 raw byte 일치** |
| 단독 Q32 FFT 최대 차이 / round-trip | **135 / 3,607 Q32 LSB**, 직전 실험과 같음 |
| 키 생성 KAT + NTRU 방정식 | **300/300, mismatch 0** |
| 서명 KAT·검증·변조 거부 | **90/90** |
| canary, fault registers | 손상 0, CFSR/HFSR/AFSR=0 |

통합 커널의 별도 900-input 오차 측정은 FFT 최대 144 LSB, iFFT 최대 8 LSB였다.
두 FFT entry 각각 204,400계수 중 188,689개, 두 iFFT entry 각각 204,400계수 중 156,866개가 Q32 중간값과 달랐다.
따라서 그 엄격한 Q32 중간값 동등성 검사는 `KERNEL_DONE result=1`이며 **실패**로 보존한다.
이는 전체 키 생성 KAT 불일치가 아니다. `valid_measurement=true`는 로그/환경 검증 결과이지,
Q32 중간값 동등성 통과라는 뜻이 아니다.
KAT 통과만으로 모든 입력의 동등성을 증명한 것은 아니다.

- [KAT 로그](../../integration_candidate/validation/results/kat/20260924T150433Z/raw.log)
- [서명·검증 로그](../../integration_candidate/validation/results/sigkat/20260924T150607Z/raw.log)
- [단독 커널 로그](../../results/20260924T150011Z/raw.log)

## 상수시간 검사와 측정기 보정

- 실제 ELF에서 새 loop의 FP 명령 순서가 기존 span과 일치했다.
  iFFT의 공개 twiddle 허수부 부호 반전 4개만 C에서 asm으로 이동했다.
- loop 조건 분기는 공개 blocks 카운터 하나. gather/scatter 오프셋은 고정 공개 표에서만 읽는다.
- logn 4..10의 모든 계수 인덱스가 각 레이어에서 정확히 한 번 처리되는지 별도 검사했다.
- 단독 4개 입력 클래스: 512/1024 FFT·iFFT의 변동 0~1 cycle.
- 처음 공개 함수 측정에서는 같은 함수가 여러 호출 위치에 인라인/복제되어 클래스 평균과 범위가 달랐다.
  이 로그 [150730Z](../../integration_candidate/validation/results/kernels/20260924T150730Z/raw.log)는 그대로 보존했다.
- **측정 함수만** `noinline,noclone`으로 고정한 최종 측정에서는
  1024 FFT·iFFT 5개 입력 클래스의 시간 차이가 0~1 cycle였다. invnorm 클래스는 0 cycle.
  FFT/iFFT/bridge 암호 코드는 두 실행 사이에 변경하지 않았다.
- 따라서 초기 시간 차이를 새 산술의 입력 의존성으로 단정하지 않는다.
  다만 이 검사는 유한한 timing probe와 구조 검사이며, 전체 부채널 안전성의 형식 증명은 아니다.
- 단독 비교는 FZ/DN on, 통합 함수/KAT는 기존 기본 FP 환경을 유지했다.
  결과는 각 측정 환경 안에서 비교한 값이다.

[명령/주소/분기 검사 JSON](../../results/20260924T150011Z/tail_audit.json).

## 메모리와 재현

새 asm 루프의 벡터 메모리 명령은 FFT 52개 / iFFT 58개이며, 네 개 모두 유효한 butterfly를 처리한다.
사유 임시 스택 접근은 4/12개, 사유 프레임은 32/64 B다.
ABI 보존까지 포함한 asm 스택은 136/168 B다. 고정 오프셋 표는 96 B다.
통합 후보의 임시 root 배열 6 KiB는 이 숫자와 별도이며, 예약 main stack 안에서 사용한다.

- 단독 비교 펌웨어: 코드 99,440 B, RAM 예약 256,640 / 262,144 B (여러 oracle·계측용 표 포함).
- KAT 펌웨어: 코드 111,292 B, RAM 예약 206,568 B.
- 서명 회귀 펌웨어: 코드 127,220 B, RAM 예약 238,632 B.
- 최종 공개 함수 측정 펌웨어: 코드 66,612 B, RAM 예약 226,752 B.
- 정상 구현은 교체하지 않았다. `stages/10_packed_tail/`의 .c/.s/.h는 이번 단독 구현 스냅샷이다.

보드 NUCLEO-N657X0-Q, CPU/SYSCLK/HCLK 800/400/200 MHz,
ITCM 코드·DTCM 데이터/스택, cache off, GCC 15.2.1 -O3, C fast-math/contraction off.
TCM control=0x99, MSCR=0x1300a. 원시 로그와 source/ELF 해시는 각 결과 디렉터리에 저장했다.

```sh
# 기준 디렉터리: fn-dsa_m55/function_compare/twfalcon
python3 tools/audit_layers.py
sh build.sh
python3 tools/audit_tail.py
../../measurement_mlkem_native/env/build-venv/bin/python run_board.py
# 통합 후보 검증 (보드 실행은 한 번에 하나씩)
sh integration_candidate/validation/build.sh kat
../../measurement_mlkem_native/env/build-venv/bin/python integration_candidate/validation/run_board.py kat
sh integration_candidate/validation/build.sh sigkat
../../measurement_mlkem_native/env/build-venv/bin/python integration_candidate/validation/run_board.py sigkat
sh integration_candidate/validation/build.sh kernels
../../measurement_mlkem_native/env/build-venv/bin/python integration_candidate/validation/run_board.py kernels
```
