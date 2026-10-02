# process_block_final — 단일 Keccak 1~5단계 통합본

[sha3_cm55.s](sha3_cm55.s)의 `fndsa_sha3_process_block()` 한 함수에
채택한 IO3 + T8 + R9 + C4 + I4 코드를 **직접 통합**했다.
다른 후보 파일을 빌드 옵션이나 외부 link로 가져오는 구현이 아니다.
SLOTHY는 적용하지 않았다.

실물 M55에서 원본 13,383 → 통합 11,482 cycles, **1.1656배**.
통합 시작점인 IO3 단독보다 **1.1028배** 빨라졌다.
이는 단일 Keccak 함수 전체의 결과이며, 전체 FN-DSA API 성능 배율은 아니다.
조건·누적 측정·KAT·로그는 [result.md](result.md).

## 파일과 변경 범위

| 파일 | 역할 |
| --- | --- |
| [sha3_cm55.s](sha3_cm55.s) | 1~5단계 통합 생산 ASM, 동일 공개 함수/ABI |
| [sha3_cm4.s](sha3_cm4.s) | 변경하지 않은 원본 비교군 |
| [sha3.c](sha3.c) | 기존 SHAKE/SHA3 API; 변경 없음 |
| [Makefile](Makefile) | 이 폴더 소스만 빌드; 기존 local sha3_cm55.s 등록 유지 |
| [validation](validation) | 생산 코드와 분리된 검사·계측 도구 |
| [validation/candidates](validation/candidates) | 각각 측정한 누적 통합 checkpoint 소스 |

1단계는 MVE 비트 변환이고, 2~5단계는 채택한 scalar 정수 ASM 배치다.
한 상태를 처리하는 함수이지 x4 메시지 병렬 함수가 아니다.
기존 helper/inject·round constants와 NTT·FFT·샘플러 소스는 그대로다.
`process_block`~`process_block5` 및 `Final_code/Before_slothy`는 수정하지 않았다.

통합 스택 frame은 **200 B**로 원본보다 16 B 늘었다.
R9 RC 포인터 및 R14 라운드 카운터를 θ/π 임시 사용 전후에 보존한다.
Q0..Q7과 D0..D15의 alias를 피하도록 MVE 변환은 상태 레지스터가
살아 있지 않은 입력/출력 경계에서만 실행한다.
새 외부 scratch/heap은 없다.

## 독립 라이브러리 빌드

FALCON workspace root에서 실행:

```sh
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
make -C process_block_final CROSS_COMPILE="$PWD/fn-dsa_m55/measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-"
```

산출물: `process_block_final/build/libfndsa_m55.a`.
실제 보드 펌웨어에는 startup·TCM 배치·sysrng 등의 환경이 별도로 필요하다.

## 측정·검사 재현

보드는 실물 NUCLEO-N657X0-Q여야 하며, 동시에 다른 도구가 보드를 사용하면 안 된다.
아래 명령의 ref/mve 구분은 **검사 도구에서 원본과 후보를 비교하기 위한 것**이다.
생산 코드에 후보 선택 옵션을 추가하지 않는다.

```sh
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh

# 원본과 통합본: 전체 함수, 생산 명령 그대로
bash process_block_final/validation/kernel_compare/build.sh ref-plain
python process_block_final/validation/kernel_compare/run.py ref-plain
bash process_block_final/validation/kernel_compare/build.sh mve-plain
python process_block_final/validation/kernel_compare/run.py mve-plain

# 초기 계산 진입 위치를 맞춘 진단용 대조
bash process_block_final/validation/kernel_compare/build.sh ref-aligned
python process_block_final/validation/kernel_compare/run.py ref-aligned
bash process_block_final/validation/kernel_compare/build.sh mve-aligned
python process_block_final/validation/kernel_compare/run.py mve-aligned

# 전체 KAT·서명검증·API 경계 검사
bash process_block_final/validation/build.sh mve 24 kat
python process_block_final/validation/run.py mve kat
bash process_block_final/validation/build.sh mve 24 sigkat
python process_block_final/validation/run.py mve sigkat
bash process_block_final/validation/build.sh mve 24 api
python process_block_final/validation/run.py mve api

# 집계 및 정적 통합 감사
python process_block_final/validation/kernel_compare/analyze.py
python process_block_final/validation/kernel_compare/experiments.py
python process_block_final/validation/static_audit.py
```

최종 통합본: 키생성 KAT **300/300**, 서명 KAT **90/90**,
Keccak oracle·SHAKE128/256·ABI·메모리 guard 통과.
상수시간 관련 검사는 정적 분석과 zero/random 각 1,000회 관측이다.
형식적 상수시간 증명 또는 전력/EM 검증을 완료했다는 뜻은 아니다.

복사돼 있던 IO-only 문서는 [이전 README](validation/imported_README.md),
[이전 result](validation/imported_result.md)에 보존했다.
원본 라이선스는 [LICENSE](LICENSE)에 유지한다.
