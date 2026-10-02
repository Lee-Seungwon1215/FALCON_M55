# FN-DSA NTT 함수 단독 비교

> 이 폴더는 K1 full-iGM 변경까지 포함한 **K2 과거 실험**을 보존한다. 현재 `ntt_opt` / K4C의 직접 재측정은 [../ntt_k4c/result.md](../ntt_k4c/result.md)를 참조한다. 과거 수치·소스·펌웨어·원시 로그는 교체하지 않았다.

원본 `M55_ref`와 당시 K2 통합본의 **4개 변환 함수**만
독립적으로 비교한다. 새로운 MVE C 인트린식 비교군을 만드는 실험이 아니다.
키생성·서명·검증 전체 코드는 링크하지 않으며 그 API 성능도 주장하지 않는다.

| 함수 | original | optimized |
|---|---|---|
| mqpoly_int_to_ntt / mqpoly_ntt_to_int | mq_cm4.s | mq_cm55.s |
| mp_NTT / mp_iNTT | kgen_mp31.c + 기존 M4 인라인 ASM 보조 연산 | kgen_mp31_cm55.s |

원본/최적화본은 모두 **같은 M55에서 실행**한다. M4 보드와 M55 보드를 비교하는 실험이 아니다.
최적화본은 공통 q-NTT 1~4단계와 RNS D1 이후 K1/K2 변경을 포함한 **Slothy 미적용** 통합본이다. K4C는 포함하지 않는다.

## 구조와 독립성

- `original/`: 원본 함수, 원본 mq 상수표, 기존 C 산술 보조 함수.
- `optimized/`: MVE 함수, 대응 Barrett 표, logn<4 C fallback.
- `bench/`: API 선언, RNS 소수·root 생성, 정확성 및 단독 측정 코드.
- `board/`: 로컬 보드 설정·시작 코드·링커·출력 shim.
- `tests/`: 추출·로그 검증 도구의 실패 검출 회귀검사.
- `results/`: 세션별 raw log·검증·모든 소수별 수치, 생성된 비교 JSON/CSV.
- `result.md`: 보드 측정 성공 후 생성하는 최종 비교표.

암호 소스는 로컬 일반 파일이며 다른 후보의 include/심볼릭 링크를 쓰지 않는다.
`extract.py`는 출처 파일의 함수/표를 기계적으로 추출하는 **일회성 도구**다.
RNS K1은 보존된 K0/D1 소스를 입력으로 삼아 full inverse-root 변환을 재현한다.
빌드할 때 실행하거나 원본 프로젝트의 C/S를 끌어오지 않는다. `extraction.json`은
원본 파일 SHA-256과 로컬 추출본 SHA-256을 기록한다. 함수 이름에 `orig_`/`opt_`를
붙이고 배치 section을 지정했지만 산술 본문은 바꾸지 않았다.
공통 mq 파일은 NTT/iNTT 및 매크로만 추출했다. RNS ASM은 작은 경로·stride 상수 등
의존성을 함께 보존했으며 호출하지 않는 probe section은 최종 ELF에서 제거된다.

SDK/컴파일러는 기존 고정 `measurement_mlkem_native/env`를 사용한다.
보드 로딩만 기존 `ntt_opt_slothy/measurement/exec_board.py` 및 그 RAM 로더를 재사용한다.
따라서 암호 코드는 독립적이지만, SDK/하드웨어 도구까지 배포용으로 vendoring한 것은 아니다.
일반 빌드 설정과 배치용 linker는 필요하며, 최적화를 빌드 옵션으로 생성하지 않는다.

## 정확성

- q=12289: logn=2..10 × 경계/무작위 8패턴 = 72 세트.
- RNS: 308개 소수 × logn=0..10 × 8패턴 = 27,104 세트.
- forward 원본/최적화 대조, 각 구현의 왕복 복원, 동일한 별도 spectral 입력의 inverse 대조.
- 모든 결과의 계수 범위, 배열 앞·뒤 및 사용하지 않는 영역 canary 검사.
- 독립 직접 다항식 평가(DFT): q의 작은 크기와 512/1024, RNS 전 소수의 logn<=4
  및 첫 소수의 512/1024. 총 1,548 세트. butterfly 구현과 독립인 정의로 교차검사.
- q의 0과 12289는 허용된 동일 잉여류로 비교한다. RNS는 [0,p) 범위에서 bit-exact 비교한다.

이는 독립 프로젝트 안의 유한 입력 정수 정확성/경계 회귀다. K1 전체 통합본의
결정적 KAT/digest와 서명·검증은 [별도 통합 검사](../../ntt_ntrusolve/ref_preslothy/K1_FULL_IGM.md)에서
수행했다. 모든 입력 증명, 형식적 상수시간 증명, dudect/TVLA/전력·EM 검사를 뜻하지 않는다.

## 측정 정의

- NUCLEO-N657X0-Q, CPU/SYSCLK/HCLK 800/400/200 MHz.
- 코드 ITCM, 상수/데이터/스택 DTCM, 각각 256 KiB. 캐시 OFF, TCM ECC ON.
- 기존 로컬 rodata→DTCM/ECC 시작 조치를 유지한다. 수정 없는 upstream ML-KEM 이미지라는 뜻은 아니다.
- 동일 GCC 15.2.1, -O3, -fno-reorder-functions. 원본 C의 자동 벡터화를 강제로 끄지 않는다.
- 동일 ELF에 두 구현을 함께 넣어 정확성 대조. 시간은 동일한 noinline 호출 하네스와
  **동일한 데이터 주소**를 사용한다. 원본/최적화 호출 순서는 배치마다 번갈아 바뀐다.
- 각 조건마다 10 warmup + **10 batch × 100 call**. DWT CYCCNT, 시간 구간만 IRQ OFF.
- 배치마다 입력을 다시 복사한다. 100회 안에서는 이전 변환 출력을 다시 변환한다.
  동일 입력 하나를 매 호출 다시 복사하는 실험이 아니라, 양쪽의 동일 변환 시퀀스다.
- 입력 복사, 외부 gm/igm 생성, 비교/로그는 시간 밖. 함수 내부 root/twist 준비·scaling,
  진입/복귀, 공통 호출 루프 및 타이머 비용은 포함한다. 임의의 오버헤드 차감은 하지 않는다.
- 공통 q: logn=9/10 정·역변환 각각. RNS: 308개 소수 × logn=4..10 정·역 각각.
  작은 logn<4는 정확성 검사만 하며 MVE 개선으로 보고하지 않는다.
- 대표값은 10개 batch total/100의 **중앙값(5·6번째 평균)**. 원본·최적화 각각 min/max도 보존.
- RNS 대표 표는 첫 소수 및 308개 소수별 중앙값의 동일가중 평균을 구분한다.
  실제 키생성 호출빈도로 가중한 성능이 아니다. 전체 API 개선율로 환산하지 않는다.

## 배치 대조

`ab`와 `ba`는 같은 코드를 빌드하고 원본/최적화 kernel **슬롯**만 교환한다.
모든 커널은 기본 64 KiB ITCM 안이며 나머지 코드·데이터 주소가 같은지 검사한다.
두 구현의 내부 길이가 달라 개별 함수 진입 주소를 완전히 같게 만든 실험은 아니다.
함수 내부 명령 정렬도 최적화의 일부다. 결과는 두 레이아웃 모두 공개하며 빠른 쪽만 고르지 않는다.

## 실행

프로젝트 루트에서:

```sh
bash fn-dsa_m55/function_compare/ntt/build.sh ab ba
python3 -B fn-dsa_m55/function_compare/ntt/audit.py layouts
python3 -B fn-dsa_m55/function_compare/ntt/tests/inspect_kernels.py
python3 -B -m unittest discover -s fn-dsa_m55/function_compare/ntt/tests -v
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python -B fn-dsa_m55/function_compare/ntt/run.py ab
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python -B fn-dsa_m55/function_compare/ntt/run.py ba
python3 -B fn-dsa_m55/function_compare/ntt/report.py
```

보드 작업은 직렬 실행한다. 지정 M55 probe `003C00223335510735383531`만 사용하며,
Flash 쓰기·지우기를 하지 않는다. 새 세션 로그는 이전 로그를 덮어쓰지 않는다.
승인된 세션은 `results/ab/validated.json`, `results/ba/validated.json`으로 구분한다.
실패한 개발 실행 로그도 보존하지만 최종 통계에는 포함하지 않는다.

함수 위치: 원본 공통 NTT/iNTT는 `original/mq_cm4.s`, 원본 RNS는
`original/kgen_mp31.c`이다. 최적화본은 `optimized/mq_cm55.s`와
`optimized/kgen_mp31_cm55.s`에 직접 들어 있다. 정적 기계어 요약은
`results/kernel_inspection.json`, 전체 디스어셈블리는 `build/ab/firmware.dis`이다.

원본 FN-DSA 저작권/라이선스는 `LICENSE.c-fn-dsa`를 보존했다.
보드 파일에는 upstream mlkem-native의 원래 저작권·SPDX 표시를 보존했다.
