# process_block — 입력·출력 및 비트 변환만 최적화

단일 Keccak `fndsa_sha3_process_block()`의 **입력·출력과 비트 분리·복원만**
Cortex-M55 MVE 정수 ASM으로 변경한 독립 실험이다.
θ·ρ·π·χ·ι와 초기/다음 라운드 열 XOR 계산은 원본 그대로다.
네 메시지를 묶는 x4 구현이 아니라, **한 상태 안의 네 64-bit word**를 병렬로 변환한다.

실물 M55 결과: 입출력 구간 **1.515배**, 함수 전체 **1.057배**.
자세한 조건·검증·로그는 [result.md](result.md).

## 구현 파일과 범위

| 파일 | 역할 |
| --- | --- |
| [sha3_cm4.s](sha3_cm4.s) | 변경하지 않은 원본 비교군. 생산 Makefile에서는 빌드하지 않음 |
| [sha3_cm55.s](sha3_cm55.s) | 실제 채택한 IO-only 구현. 같은 공개 함수 이름과 ABI |
| [sha3.c](sha3.c) | 원본 유지. SHAKE/SHA3 API·패딩·흡수·출력 로직 변경 없음 |
| [Makefile](Makefile) | 이 폴더 소스만 직접 빌드. 생산 backend는 `sha3_cm55.s`로 고정 |
| [validation](validation) | 계측·oracle·KAT·보드 실행 도구. 생산 코드와 분리 |

기존 NTT K4C와 키생성/서명 FFT 구현은 복사본 그대로 유지했다.
다른 후보의 소스를 include/link하지 않으며, 빌드 옵션으로 최적화 후보를 선택하지 않는다.
기존 `sign_fft_cm55.s`, `sign_ldl_cm55.s`, `sign_split_merge_cm55.s`도
독립 라이브러리가 완성되도록 Makefile에 등록했다. 해당 함수 코드는 변경하지 않았다.

`process_block2`~`process_block5`와 `Final_code/Before_slothy`에는 이 변경을 반영하지 않았다.
후속 과정도 각각 원본에서 출발하는 비누적 실험이다.

## IO-only 계산 흐름

1. D 레지스터에 Keccak 상태를 넣기 **전에**, 외부 버퍼의 20개 word를
   `VLD2/VST2`로 네 개씩 읽고 MVE `4×32-bit`에서 even/odd 비트 분리.
2. 남은 1개 word는 원본 정수 비트 변환을 inline으로 처리.
3. 원본 pre-rotation·상태 배치·24라운드 계산을 그대로 실행.
4. 원본 최종 재배열을 외부 버퍼로 저장한 **후에**, 역변환을 MVE로 처리.

주요 매크로: `IO_SWAP`, `IO_MIDDLE_BYTES`, `IO_PACK`,
`IO_SPLIT4`/`IO_MERGE4`, `IO_BOUNDARY`.
마스크는 Q4–Q7에 한 번 준비하고 다섯 묶음에 재사용한다.
halfword packing은 `VMOV + VSLI + VSRI` 세 명령으로 처리한다.
다섯 묶음은 unroll했고, 새로운 임시 상태 배열은 만들지 않았다.

Q0–Q7은 원본의 D0–D15 상태 저장 레지스터와 겹친다.
따라서 MVE 변환은 **D-state가 살아 있지 않은 진입/종료 경계에서만** 실행한다.
스택은 원본과 동일한 184 B이며 D8–D15 및 R4–R11 보존 시험을 통과했다.

### 유지해야 하는 원본의 실제 경계 표현

원본 주석은 처음 `r`개 word를 변환한다고 설명하지만, 해당 소스에서는
`r14`를 rate와 LR로 함께 사용하며 첫 `BL bit_split_5`/`BL bit_merge_5`가
rate 값을 덮어쓴다. 이 보드·코드에서 실제로 관찰한 경계는
**A[0..20] 일반 표현, A[21..24] even/odd split 표현**이다.
SHAKE256의 `r=17`에서도 이 실제 동작을 유지했다.

이번 작업은 그 rate 처리 자체를 고치는 실험이 아니다.
입출력 정확성은 위 실제 계약과 독립 canonical Keccak oracle을 연결해 검사했다.
향후 rate 분기나 상태 저장 형식을 수정할 때 이 점을 다시 확인해야 한다.

## 독립 라이브러리 빌드

```sh
# FALCON workspace root에서
make -C process_block CROSS_COMPILE=/path/to/arm-none-eabi-
```

산출물: `process_block/build/libfndsa_m55.a`.
Cortex-M55 hard-float ABI, C `-O3 -ffp-contract=off -fno-fast-math`.
Keccak 변경은 부동소수점 산술이 아니라 **정수 MVE 비트 연산**이다.
실제 펌웨어의 startup·TCM 배치는 별도로 필요하다.

## 검사 재현

```sh
bash process_block/validation/build.sh mve 24
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python process_block/validation/run.py mve

# mode를 kat / sigkat / api로 바꿔 각각 실행
bash process_block/validation/build.sh mve 24 kat
python process_block/validation/run.py mve kat

# mode: plain / aligned / io / bits / core; ref와 mve를 각각 실행
bash process_block/validation/io_profile/build.sh mve-plain
python process_block/validation/io_profile/run.py mve-plain
python process_block/validation/io_profile/analyze.py
python process_block/validation/static_audit.py
```

검증용 ref/mve 구분·계측·주소 고정은 시험 도구에만 있다.
생산 파일은 항상 전체 24라운드, 동일 ABI의 직접 작성 ASM이다.
전체 상수시간의 형식적 증명이나 전력/EM 검증을 완료했다는 뜻은 아니다.

복사되어 있던 이전 README·결과 문서는
[imported_README.md](validation/imported_README.md),
[imported_result.md](validation/imported_result.md)에 보존했다.
이전 `stage_profile_result.md`/`ntru_fft_profile_result.md`는 이번 Keccak 결과가 아니다.
원본 라이선스는 [LICENSE](LICENSE)에 유지한다.
