# 변환 포함 FFT/iFFT 재측정 — 2026-09-27

결론: **4.3 커널에 double 입출력 변환을 붙이면 원본 고정소수점보다
1.127~1.225배 빠르다. 같은 조건의 기존 TW보다 시간은 1.459~2.553% 줄었다.**
앞서 제시한 1.40~1.47배는 변환을 제외한 내부 커널 수치였다.
이번 결과는 전체 키생성 결과가 아니며, TW 본체에 채택한 결과도 아니다.

## 비교 범위와 결과

TW와 4.3 모두 다음 전체 호출을 DWT로 측정했다.

`double → 2×FP32 생성 → FFT 또는 iFFT → double 복원`

4.3에는 원래 double 입출력 함수가 없으므로 **비교용 어댑터를 새로 작성**했다.
실제 계산은 수정하지 않은 `fndsa_ds_fft()` / `fndsa_ds_ifft()`가 한다.
TW는 `integration_candidate/tw32_bridge.c`와 stage-11 커널을 사용했다.
원본은 Q32 입출력의 `vect_FFT()` / `vect_iFFT()`이며, M55_ref와 함수 본문·
회전상수·`kgen_inner.h` 전체가 동일함을 확인했다. 원본에 double 변환을 덧붙이지 않았다.

단위는 평균 cycles. 표시는 소수 셋째 자리까지 유지했다.

| 함수 | n | 원본 Q32 | TW 변환 포함 | 4.3 + 변환 어댑터 | 원본 대비 속도 배율 | TW 대비 시간 감소 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| FFT | 512 | 125,906.000 | 114,618.002 | 111,692.000 | 1.1273× | 2.553% |
| iFFT | 512 | 143,329.002 | 121,793.000 | 119,736.001 | 1.1970× | 1.689% |
| FFT | 1024 | 280,372.004 | 248,090.001 | 242,301.002 | 1.1571× | 2.333% |
| iFFT | 1024 | 318,463.005 | 263,863.003 | 260,014.000 | 1.2248× | 1.459% |

속도 배율 = 원본 cycles / 후보 cycles.
시간 감소 = (비교 대상 cycles − 후보 cycles) / 비교 대상 cycles × 100.
4.3의 원본 대비 시간 감소는 각각 11.289%, 16.461%, 13.579%, 18.353%다.

## 내부 계산만 보면

| 함수 | n | TW 내부 cycles | 4.3 내부 cycles | 4.3 전체−내부 |
| --- | ---: | ---: | ---: | ---: |
| FFT | 512 | 89,956.002 | 89,633.002 | 22,058.998 |
| iFFT | 512 | 97,675.002 | 97,677.000 | 22,059.001 |
| FFT | 1024 | 198,884.003 | 198,226.004 | 44,074.998 |
| iFFT | 1024 | 215,937.004 | 215,939.005 | 44,074.995 |

**4.3 내부 FFT/iFFT가 TW 내부보다 훨씬 빠른 것은 아니다.**
특히 iFFT 내부는 사실상 같은 시간이다. 전체 호출에서 보이는 차이는 주로
변환 어댑터·자료구조·호출 문맥 쪽에 있다. TW의 기존 workspace는 3-plane
구조와 사용하지 않는 세 번째 plane의 초기화를 유지하고, 4.3은 2-plane이다.
새 어댑터는 실수부·허수부 변환을 함께 작성하여 생성된 명령 순서도 다르다.
각 요인의 기여도를 따로 분리한 실험은 아니므로 그중 하나만 원인이라고 단정하지 않는다.

`전체−내부`는 별도 호출 측정의 차이이며 순수 변환 명령만 직접 계측한 값은 아니다.
이번에는 invnorm·주변 Q32 곱셈/나눗셈·전체 NTRU solve를 측정하지 않았다.

## 측정 조건

- 연결된 NUCLEO-N657X0-Q, 800 MHz, 코드 ITCM / 데이터·상수·스택 DTCM,
  각각 256 KiB, 캐시 OFF. TCM_CONTROL=0x99, ECC 설정과 fault 레지스터 확인.
- GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -ffp-contract=off
  -fno-fast-math -fno-strict-aliasing`. 모든 후보와 TW 비교 소스에 같은 옵션 확인.
- 동일 ELF, 동일 double 입출력 버퍼 `0x300167c0`.
  TW와 4.3은 union으로 같은 DTCM workspace 시작 주소 `0x30011780`을 순차 사용한다.
  각 구현 내부의 고유한 plane 간격은 유지한다. 함수들의 ITCM 주소까지 같게 고정한 것은 아니다.
- 각 함수/크기/backend를 5배치 × 100회 측정하고 같은 ELF를 두 번 실행했다.
  배치마다 10회 warm-up 제외. 호출 순서를 순환하고 측정 구간에서 IRQ 차단.
- 입력 준비, memcpy, 결과 비교, 출력 로그는 타이머 밖이다. TW/4.3의 표현 변환은 안이다.
  iFFT는 두 FP 후보에 동일한 TW forward 출력 값을 입력한다.
  원본 Q32에는 그 값을 Q32로 표현한 입력을 주므로 표현 정밀도는 원래부터 다르다.
- 같은 seed로 재실행했으므로 독립 seed 집합을 두 배로 셌다고 해석하면 안 된다.
  전체 10배치 평균값의 범위는 최대 0.02 cycle, 개별 측정 min/max 차이는 최대 1 cycle.
- ELF 크기: ITCM 69,432 B / DTCM 210,248 B. 기존 64 KiB main stack 예약 포함.

처음 서로 다른 workspace에 배치한 진단에서는 TW가 더 느리게 측정됐다.
따라서 그 값은 최종 비교에 사용하지 않고, 공유 workspace 판을 두 번 실행한 결과만
집계했다. 배치 변경 시 코드 주소/정렬도 함께 바뀌므로 최초 차이를 특정 DTCM bank
하나의 문제로 확정하지 않는다. 이 1.5~2.6% 차이도 실제 통합 뒤 재측정해야 한다.

## 검증 범위

- logn 4~10 × FFT/iFFT × 100 입력 = 1,400개에서 TW/4.3 double 출력 byte 일치.
  정수 입력과 Q32 분수 입력을 섞었다.
- 성능 측정 중 실행당 8,800개 FP 출력 비교도 일치. canary 오류 0, fault 0.
- **원본 고정소수점과 FP 중간 출력 자체가 bit-exact인 것은 아니다.**
  별도 정확성 입력에서 FFT 최대 차이는 512: 138, 1024: 263 Q32 LSB(올림),
  iFFT는 두 크기 모두 5 LSB(올림)였다.
- 이번에는 전체 키생성 KAT·서명 검증·전체 상수시간 검사를 새로 실행하지 않았다.
  기존 [KAT 결과](result.md)는 본체에 대한 이전 검사이며, 이번 커널 비교와 구분한다.
- 4.3 본체 35개 C/H/S 파일이 최초 측정 전후 변경되지 않았음을 hash로 확인했다.
  TW 비교 복사본은 namespace와 공유 workspace 배치 변경을 되돌리면 원본과 정확히 같다.
  TW 본체도 수정하지 않았다. 통합 채택은 하지 않았다.

## 재현·원시 기록

비교 소스: [board_bridge_compare.c](validation/board_bridge_compare.c),
[workspace 선언](validation/bridge_workspace.h),
[TW 비교 복사본 검증기](validation/prepare_bridge_control.py).

```sh
python3 validation/prepare_bridge_control.py --check
bash validation/build.sh bridge_compare
# 공유 측정 환경 Python으로 실행. USB 보드 접근 권한 필요.
python3 validation/run_board.py bridge_compare
```

- [1회 원시 로그](validation/results/bridge_compare/20260927T132137Z/raw.log),
  [manifest](validation/results/bridge_compare/20260927T132137Z/manifest.json)
- [2회 원시 로그](validation/results/bridge_compare/20260927T132305Z/raw.log),
  [manifest](validation/results/bridge_compare/20260927T132305Z/manifest.json)
- [자동 집계](validation/results/bridge_compare/shared_workspace_summary/summary.md),
  [전체 수치 JSON](validation/results/bridge_compare/shared_workspace_summary/summary.json),
  [측정 ELF](validation/results/bridge_compare/shared_workspace_summary/benchmark.elf),
  [전체 컴파일 명령](validation/results/bridge_compare/shared_workspace_summary/compile_commands.json)
- [최초 별도 workspace 진단 로그 — 최종 평균에서 제외](validation/results/bridge_compare/20260927T131804Z/raw.log)

최종 두 실행 ELF SHA-256:
`a82279c5f148416b69fce79872914d10eee359cd49da32ec583e94a4743bd156`.
