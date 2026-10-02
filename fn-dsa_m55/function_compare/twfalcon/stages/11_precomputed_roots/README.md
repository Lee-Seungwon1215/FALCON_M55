# 11단계 — 회전상수 사전 변환 실험

2026-09-26 KST. **개선 가능: 기존 10단계보다 30.32~34.45% 시간이 줄었고,
네 공개 FFT/iFFT 함수 모두 M55_ref 함수 본문 기준보다 빨라졌다.**
측정 대상은 함수 전체이며 입출력 double↔2×FP32 변환도 포함한다.
전체 키 생성 개선율을 뜻하지 않는다.

후속 전체 키 생성 측정에서는 현재 통합 후보가 M55_ref보다
**512에서 7.01%, 1024에서 9.15% 느렸다.** 동일 입력 100개/크기를
실행 순서를 뒤집어 두 번 확인했고 KAT·생성 키는 모두 일치했다.
따라서 아래 커널 개선과 전체 키 생성 성능 목표 달성은 구분해야 한다.
[전체 키 생성 상세 결과](keygen_result.md).

추가 진단에서 위 회귀의 큰 원인은 변경하지 않은 정수 루틴의 코드 위치였다.
**정수 루틴 주소를 통제한 무계측 대조에서는 전체 키 생성이 4.14% / 4.17%
개선**됐다. 작은 FFT와 주변 Q32 보정의 손해는 여전히 남는다.
정상 구현은 변경하지 않은 진단 결과다. [원인 분석·새 대조 결과](integration_diagnosis.md).

## 구현

작업 경로는 `../../integration_candidate`다. 정상 `M55_ref`, `ntt_opt`,
`fft_keygen`, 채택된 FP64 invnorm은 수정하지 않았다.

- `tw32_fft_mve.c`: DS FFT/iFFT의 Q32 상수 변환을 사전 변환 상수표 읽기로 교체.
  큰 레이어는 기존 broadcast를 유지하고, 작은 ht=1/2 레이어는 상수표 포인터를
  기존 MVE 어셈블리에 직접 전달한다. 6 KiB 임시 상수표와 채우기 루프를 제거했다.
- `tw32_gm_ds32.c`, `.h`: 기존 `q32_tw()`와 비트 단위로 동일한 상수 2,048개.
  런타임 초기화나 lazy cache는 없다. float의 정확한 16진 리터럴로 저장한다.
- 상수 표현은 `hi + lo`의 2×FP32다. 기존 packed assembly의 12-byte stride를
  그대로 쓰기 위한 세 번째 float는 모두 0인 패딩이며, triple-float 산술을
  다시 도입한 것이 아니다.
- `tw32_bridge.c`, `tw32_primitives_cm55.s`, `kgen_fxp.c`, `kgen_inner.h`는
  이전 실행의 SHA-256과 동일하다. 입출력 변환, butterfly 산술 순서,
  iFFT 최종 스케일링, invnorm, NTRU의 나머지 계산은 변경하지 않았다.
- `../../tools/precompute_ds_roots.py`는 오프라인 재생성·검증 도구다.
  빌드 때 실행하거나 다른 후보에 링크해 구현을 대체하지 않는다.
  새 상수 C 파일을 일반 소스로 빌드한다.

## 비교 조건

- NUCLEO-N657X0-Q / Cortex-M55, 800 MHz.
- 기존 mlkem-native 기반 설정: 코드 ITCM, 데이터·상수·스택 DTCM,
  각각 256 KiB, 캐시 OFF, 측정 중 인터럽트 OFF, TCM_CONTROL=0x99.
- GCC 15.2.1, `-O3`, `-mfpu=fpv5-d16`, `-ffp-contract=off`, `-fno-fast-math`.
  FZ/DN OFF인 기존 FP 환경 유지.
- **동일 ELF**에 이전 on-demand 후보, 이번 precomputed 후보, 공개 alias,
  M55_ref와 본문/helper가 동일한 고정소수점 기준을 넣었다.
- 항목별 5배치 × 100회, 각 배치 10회 warmup. 동일 입력, backend 순서 교대.
  입력 생성·복사·검사·출력은 타이머 밖이다. iFFT 입력 FFT 생성도 계측 밖이다.
- 이전 후보의 테스트용 복사본은 함수명만 `old10_`으로 구분했다.
  이름 변경을 되돌리면 `../../tests/stage10_snapshot/` 원본과 전체 파일이 일치한다.
  후보 선택을 위한 빌드 옵션이나 함수 가로채기는 없다.
- 타이머 호출 지점은 `noinline,noclone`으로 고정했다. 함수/내부 workspace 위치까지
  완전히 동일한 것은 아니지만, 같은 데이터 배치 정책의 같은 이미지 비교다.

## 함수 전체 결과

단위는 cycle/call, 500회 산술평균을 반올림했다.
`vect_FFT()`와 `vect_FFT_fp64()`는 같은 실제 코어를 호출하며 iFFT도 동일하다.
`_fp64` 이름은 double 입출력 API 이름으로, 이번 butterfly 산술은 2×FP32 MVE다.

| n | 함수 쌍 | M55_ref | 이전 10단계 | 사전 변환 후보 | 이전 대비 시간 감소 | M55_ref 대비 시간 감소 | M55_ref 대비 배속 |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | vect_FFT / vect_FFT_fp64 | 126,039 | 175,009 | **114,719** | **34.45%** | **8.98%** | **1.099×** |
| 512 | vect_iFFT / vect_iFFT_fp64 | 143,336 | 180,316 | **122,436** | **32.10%** | **14.58%** | **1.171×** |
| 1024 | vect_FFT / vect_FFT_fp64 | 280,633 | 369,110 | **248,351** | **32.72%** | **11.50%** | **1.130×** |
| 1024 | vect_iFFT / vect_iFFT_fp64 | 318,470 | 380,909 | **265,402** | **30.32%** | **16.66%** | **1.200×** |

표의 이번 후보는 `_fp64` 공개 함수 수치다. alias는 각각 114,721 / 122,438 /
248,353 / 265,404 cycles로 약 2 cycles 차이이며, 네 함수 모두 결론은 같다.
과거 다른 ELF의 측정값을 섞지 않고 기준도 이번 이미지에서 다시 측정했다.

## 정확성·KAT·검증·시간 특성

변경 후 같은 네 구간도 다시 계측했다. 상수 준비 비중이 실제로 감소했다.

| n | 함수 | 변경 전 상수 준비 cycles | 변경 후 cycles | 전 비중 | 후 비중 |
| ---: | --- | ---: | ---: | ---: | ---: |
| 512 | FFT | 61,917 | 1,811 | 34.946% | **1.564%** |
| 512 | iFFT | 62,043 | 2,835 | 33.976% | **2.298%** |
| 1024 | FFT | 124,043 | 3,635 | 33.229% | **1.452%** |
| 1024 | iFFT | 124,297 | 5,699 | 32.249% | **2.133%** |

이 표는 계측 이미지 각각의 함수 전체를 분모로 쓴 진단 결과다. 최종 성능
판정은 위 무계측 same-image 비교로 했다. 새 표의 준비 구간은 포인터 준비와
broadcast이고, 어셈블리 안의 상수 load는 계산 구간에 들어간다.
후속 계측은 원래 함수보다 0.67~0.94% 느렸고 출력 8,800/8,800건이 일치했다.
입출력 변환의 절대 cycle은 그대로이나 전체 시간이 줄어 그 비중은 약 18~21%로
올라갔다. 변환이 새로 느려진 것이 아니다.

아래 검증 결과는 무계측 후보와 전체 펌웨어의 결과다.

| 항목 | 결과 |
| --- | --- |
| 회전상수 자체 | M55에서 2,048개 × 3 float = **6,144/6,144 components 비트 일치** |
| 컴파일된 상수표 | ELF 데이터와 오프라인 계산의 **6,144 components 비트 일치** |
| 함수 출력 | logn=2..10, 정수/소수 입력 포함 **3,600/3,600건 byte 일치** |
| 성능 측정 중 출력 | 이전 후보/이번 후보/alias **6,600/6,600건 byte 일치** |
| 전체 키 생성 KAT·NTRU 방정식 | **300/300 PASS**, 256/512/1024 각 100건 |
| 서명 KAT·서명검증·변조 거부 | **90/90 PASS**, logn=2..10 |
| 입력 클래스별 시간 | 8종 × 512/1024 × FFT/iFFT: 클래스 평균 차이 **0.01 cycle**, 전체 샘플 범위 **1 cycle** |
| 보드 상태 | CFSR/HFSR/AFSR=0, TCM/ECC 검사 PASS |

출력 일치는 **직전 2×FP32 후보와의 동등성**이다. 고정소수점 M55_ref와 모든
중간값이 같아졌다는 주장이 아니다. 이전 후보에 있던 Q32 중간값 차이는 별개이며,
이번 변경이 새로운 차이를 추가하지 않았음을 시험한 것이다.

상수표 주소와 반복 횟수는 공개 logn/layer/group에만 의존한다. DS FFT/iFFT의
컴파일 결과에서 상수 변환용 `__aeabi_l2d` 호출이 없어졌고, 어셈블리 산술은
변경되지 않았다. 이 소스·기계어 확인과 입력 클래스 실험은 **전체 상수시간의
형식 증명이나 전력/전자기 부채널 검증을 대체하지 않는다.**

## 메모리

상수표 자체는 24 KiB다. 통합 KAT/서명 펌웨어에서는 더 이상 사용되지 않는
기존 `tw_gm_q32` 16 KiB가 기본 unused-section 제거로 빠져 **DTCM 순증가 8 KiB**.
Q32 기준과 이전 후보도 함께 넣은 비교용 이미지는 두 상수표를 함께 갖는다.

| 통합 펌웨어 | 기존 DTCM | 이번 DTCM | 증가 | 256 KiB 중 여유 | ITCM 코드 변화 |
| --- | ---: | ---: | ---: | ---: | ---: |
| 키 생성 KAT | 206,568 B | 214,760 B | +8,192 B | 47,384 B | −1,144 B |
| 서명·검증 KAT | 238,632 B | 246,824 B | +8,192 B | **15,320 B** | −1,148 B |

이 사용량은 예약된 main stack 64 KiB를 포함한다. 임시 상수표 제거로 실제
호출 시 스택 필요량은 줄지만, 스택 예약 크기는 바꾸지 않았다. 현재 펌웨어에는
들어가지만 추가 기능/버퍼를 붙일 때는 메모리 재확인이 필요하다.

## 판단 및 적용 범위

**이 실험은 채택할 가치가 있다.** 반복 상수 변환·임시표 준비가 실질적 병목이었고,
이를 제거하자 입출력 변환 비용을 포함하고도 네 함수 모두 M55_ref를 이겼다.
정상 최종 ref로 자동 전파하지 않았으며, 현재 변경은 이 독립 통합 후보에만 있다.
커널 실험 직후에는 전체 키 생성 속도를 재측정하지 않았으나, 후속 측정에서
전체 속도 목표는 아직 미달임을 확인했다. 위의 전체 키 생성 결과를 참고한다.

## 증거 및 재실행

- [같은 이미지 성능·타이밍 원시 로그](../../integration_candidate/validation/results/twiddlebench/20260926T083005Z/raw.log)
- [수치 JSON](../../integration_candidate/validation/results/twiddlebench/20260926T083005Z/summary.json)
- [상수·동일 소스·기계어 감사](../../integration_candidate/validation/results/twiddlebench/20260926T083005Z/audit.json)
- [메모리 감사](../../integration_candidate/validation/results/twiddlebench/20260926T083005Z/memory.json)
- [전체 키 생성 KAT](../../integration_candidate/validation/results/kat/20260926T083107Z/raw.log)
- [서명 KAT·검증·변조 거부](../../integration_candidate/validation/results/sigkat/20260926T083301Z/raw.log)
- [변경 후 네 구간 프로파일](../../integration_candidate/validation/results/bridgeprofile/20260926T083412Z/bridge_profile.md)
- 변경 전 ELF의 원래 실행 manifest 일치를 확인한 사용량: [before_memory.json](before_memory.json).

```sh
sh fn-dsa_m55/function_compare/twfalcon/integration_candidate/validation/build.sh twiddlebench
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/function_compare/twfalcon/integration_candidate/validation/run_board.py twiddlebench
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/function_compare/twfalcon/tools/precompute_ds_roots.py --check
```

전체 검사도 `validation/build.sh kat`, `validation/run_board.py kat` 및
`sigkat`으로 동일하게 실행한다. 메모리 감사는 해당 두 ELF를 먼저 빌드한 뒤
`tools/summarize_precomputed.py <twiddlebench-result-directory>`로 실행한다.
