# Step ④: KAT-compatible fixed-point / FP64 division hybrid

이 폴더는 **기존 고정소수점 결과를 유지하는 별도 실험 후보**다. 상위
`1st_native_fp64`의 순수 FP64 실험 및 `../../ref`는 변경하지 않았다.
통합 `ntt_opt`에 자동 채택하지도 않았다.

## 바꾼 것과 그대로 둔 것

독립적인 전체 소스 복사본이며, `../../ref`와 다른 암호 소스는
**`kgen_fxp.c` 하나뿐**이다. 다른 후보의 소스를 링크하거나 빌드 옵션으로
백엔드를 선택하지 않는다.

- 변경: `solve_NTRU_intermediate()`가 호출하는 portable
  `vect_inv_mul2e_fft()`의 두 나눗셈.
- FP64의 역할: 정확한 Q32.32 몫을 구하기 위한 **근삿값** 계산.
- 정수의 역할: 근삿값을 정확히 보정하고, 원본 반올림·부호·0 분모 결과를 복원.
- 유지: Q32.32 자료형, 정수→fixed 변환, FFT/iFFT, 복소 곱셈, 정수 `k` 반올림,
  NTT/CRT/Bezout 및 `F,G` 정수 갱신.
- 유지: `solve_NTRU_depth0()`, 키 후보 검사, 서명, 검증, 원본
  `inner_fxr_div()` 및 AVX2 별도 구현.

따라서 **전체 FFT를 native double로 바꾼 구현이 아니다.** 느려졌던 FP64
반복 구간을 계속 사용하는 것도 아니다. 반복 구간은 원래 고정소수점 코드이며,
이번에 빨라지는 대상은 그 앞의 역수 준비 나눗셈이다.

## 방법

1. 부호를 분리하고 정수 비트값 `a=|x|`, `b=|y|`를 얻는다.
2. 하드웨어 FP64로 `2^32 / b`를 계산한다. `b=0`일 때에도 분기하지 않고
   나눗셈에는 `b=1`을 공급한다. VDIV의 두 피연산자는 항상 양의 정규수다.
3. 64-bit 몫을 두 개의 32-bit 자리로 나누어 추정한다.
4. 각 자리를 32×64→96-bit 정수 곱셈·뺄셈으로 검사한다. 항상 동일한 횟수의
   과대/과소 보정을 수행한다. 반복 보정 루프는 없다.
5. 정확한 나머지로 원본의 magnitude rounding을 수행하고 부호를 복원한다.
6. fixed 분모가 0인 경우에는 원본 bit-loop의 특수한 비트 결과를 마스크로 선택한다.

0 분모는 실제 원본 실행에서도 관찰됐다. 이를 새 거절 조건으로 바꾸거나
IEEE 무한대로 처리하면 원본 동작/KAT가 달라질 수 있으므로 그대로 보존한다.

정확성의 범위와 수식은 [division_design.md](division_design.md), 수치와 로그는
[result.md](result.md)에 정리한다.

## 상수시간 검사 범위

일반적인 C 비교·마스크 선택만으로는 충분하지 않았다. GCC가 이를 조건부 메모리
접근 및 IT 조건부 명령으로 바꿨고, 실제 보드에서 입력별 시간차가 관찰됐다.
현재 코드는 명시적인 borrow/zero 비트 및 `volatile` 중간값으로 이를 방지한다.

이 처리는 **현재 GCC/M55 바이너리의 역어셈블리와 실측으로 확인**한다.
컴파일러/옵션을 바꾸면 재검사해야 한다. 유한한 입력 검사와 정적 검토를
전체 알고리즘의 상수시간·부채널 안전성 증명이라고 부르지 않는다.
키생성 자체에는 원래 후보 거절/재시도에 따른 실행시간 차이가 있다.

## 재현

호스트:

```sh
python3 -B validation/division_test.py
python3 -B validation/host.py
```

보드 빌드 및 실행: 아래 label을 각각 사용한다.
`ref-perf`, `hybrid-perf`, `ref-profile`, `hybrid-profile`, `kernels`, `kat`.

```sh
bash validation/build.sh hybrid-perf
python3 -B validation/run_board.py hybrid-perf
python3 -B validation/static_audit.py
python3 -B validation/analyze.py
```

`static_audit.py`는 네 hybrid ELF가 모두 필요하고, `analyze.py`는 여섯 label의
최종 소스 측정이 모두 필요하다. `build_manifest.json`으로 소스/ELF 변경을 검사하므로
소스를 수정했다면 먼저 다시 빌드한다. 보드 실행은 한 번에 하나만 허용한다.

암호 코드는 이 폴더에서 직접 빌드한다. 공통 Zephyr/보드 부트·링커 환경은 기존
`measurement_mlkem_native`를 사용한다. 이것은 다른 후보의 암호 구현을 끌어오는
방식이 아니다. 계측용 NTRU 복사본은 `validation/build/*/generated`에 생성하며
성능 모드에서는 원본과 동일하고, profile 모드에만 타이머를 삽입한다.

## 선행연구와의 관계

- [Falcon M4 논문](../../../../../REFERENCE/falcon_m4.pdf) §2.3–2.4:
  고정소수점/에뮬레이션 연산과 표적 장치 비용을 검토하는 배경.
- [FP64 accuracy 논문](../../../../../REFERENCE/fp64_accuracy.pdf) §6.2–6.3:
  실수 근사 계산의 정확성 및 나눗셈 검증 범위를 구분하는 근거.
- [ARMv8 Falcon 논문](../../../../../REFERENCE/ARMv8_falcon.pdf) §IV-A:
  나눗셈/역수 계산 비용을 별도로 보는 참고 자료.

**두 자리 FP64 몫 추정 + 정확한 96-bit 정수 보정은 이번에 설계한 방법**이며,
이 논문들에 동일한 완성 코드가 실려 있다는 의미는 아니다. 특정 KAT 통과만으로
모든 입력에서의 수치 정확성이나 암호학적 안전성이 증명된다고 주장하지 않는다.
