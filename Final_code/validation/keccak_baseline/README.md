# 원본 Keccak M55 커널 베이스라인

최적화 전 `Final_code/Before_slothy/sha3_cm4.s`를 **같은 M55**에서 직접 측정한다.
암호 구현은 변경하지 않는다. 이 프로젝트는 측정 프로그램일 뿐, 새로운 Keccak 구현이 아니다.

## 세 측정 대상

1. `fndsa_sha3_process_block(state, 17)` 전체: 상태 입출력, 분리·복원, 24라운드, ABI 저장·복원을 포함한다.
2. 비트 분리 보조 루틴 묶음: `bit_split_5` 4회 + `bit_split_1` 1회.
3. 비트 복원 보조 루틴 묶음: `bit_merge_5` 4회 + `bit_merge_1` 1회.

두 보조 루틴은 `1~5`개 lane을 처리하는 진입점을 공유한다. 별도의 C 함수 세 개라는 뜻은 아니다.
`bit_split_1/5`, `bit_merge_1/5`의 개별 사이클도 측정한다.
묶음은 원본에서 관찰한 호출 횟수대로 **별도 연속 호출**한 값이다. 호출자 측 load/store는 포함하지 않는다.
원본 안에 계측 코드를 심은 정확한 exclusive 구간 시간이 아니며, 1번에 2·3번을 더하면 중복이다.

## 원본을 그대로 보존하는 방법

- `generate.py`는 원본 전체 뒤에 별도 `.text.keccak_bench` 섹션의 측정 어댑터만 덧붙인다.
- 원본의 명령, 분기, 상수, private ABI, 함수 본문은 변경하지 않는다.
- `audit.py`는 원본만 조립한 object와 측정 object의 `.text` 바이트 전체를 비교한다.
- 보조 루틴의 private ABI를 어댑터가 처리한다. APSR.GE=0110을 설정하고 C ABI의 callee-saved 레지스터를 복원한다.
- 분리·복원 입력 레지스터 적재와 결과 저장은 해당 보조 루틴의 측정 구간 밖이다.

## 측정 조건

- NUCLEO-N657X0-Q, ST-Link serial `003C00223335510735383531`만 사용.
- Cortex-M55 800 MHz, I/D cache OFF, ITCM/DTCM 각각 256 KiB 설정.
- 코드 ITCM, 데이터·스택 DTCM. 일반 rodata는 기존 검증된 DTCM linker 배치 사용.
- GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mthumb -mfloat-abi=hard -mfpu=fpv5-d16`.
- `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- 원본 ASM의 `.cpu cortex-m4`를 그대로 둔다. 원본 파일 내부의 round constants도 이동하지 않는다.
- DWT CYCCNT, 계측 구간 interrupt OFF. 샘플 저장 후 구간 밖에서 SWO 출력.
- 대상별 워밍업 5개 배치 후 100개 표본. 표본마다 64회 호출, 총 6,400회/대상/실행.
- 빈 타이머·루프 배치를 같은 반복 수로 측정해서 뺀다. 원본 BL 및 함수 반환 비용은 남긴다.
- `raw.log`와 `analysis.json`에 보정 전 수치, 보정값, 평균·중앙값·최솟값·최댓값·표준편차를 모두 보존한다.
- 512/1024 모두 같은 Keccak-f[1600], SHAKE256 rate=136 bytes(17 lanes)를 사용하므로 커널 기준선은 공통이다.

## 현재 원본의 표현 규칙 주의

원본 주석은 rate에 따라 분리·복원할 lane 수를 고른다고 설명한다. 그러나 현재 소스에서는
rate를 r14(LR)에 보관한 다음 BL로 덮어쓰고, 그 r14를 다시 rate 비교에 사용한다.
기존 전체 프로파일의 실제 호출 횟수는 split/merge 각각 `_5` 4회, `_1` 1회였다.
따라서 이 원본의 함수 경계에서는 lane 0~20이 일반 표현, 21~24가 even/odd 비트 분리 표현이다.
SHAKE256 흡수·출력 rate가 168 bytes로 바뀐다는 뜻이 아니다. rate는 여전히 136 bytes다.

이 베이스라인에서는 해당 코드를 수정하지 않는다. 독립적인 Keccak C oracle과 비교할 때만
테스트 코드가 마지막 4개 lane의 저장 표현을 맞춘다. SHAKE 출력은 Python hashlib과 직접 비교한다.

## 정확성 및 측정 유효성

- `_1~5` 각각 1,024개 입력: 0, all-ones, 단일 비트, 결정적 의사난수.
- bit extraction/interleave oracle 및 split→merge 왕복 확인: 5,120개 입력 조합.
- 독립적인 C Keccak-f[1600] oracle과 256개 초기 상태 × 연속 4회 = 1,024회 모든 lane 비교.
- Python hashlib SHAKE256: 길이 0/3/135/136/137/272/1024 입력의 256-byte 출력 7개 비교.
- 상태 guard 보존, CFSR/HFSR/AFSR=0, TCM/ECC 설정 확인, 생산 소스 SHA-256 보존.
- FN-DSA 전체 KAT·키생성·서명·검증을 이번 커널 프로젝트에서 다시 실행하는 것은 아니다.
- 상수시간의 형식적 증명, 모든 입력의 동등성 증명도 아니다.

## 재실행

```sh
bash Final_code/validation/keccak_baseline/build.sh
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python Final_code/validation/keccak_baseline/run.py
python Final_code/validation/keccak_baseline/analyze.py Final_code/validation/keccak_baseline/results/<run>
```

보드 실행은 기존 공유 lock 두 개를 사용한다. 측정 ELF, map, disassembly, 컴파일 명령, 원본 해시,
생성 소스, 원시 로그와 검사 결과를 실행별 디렉터리에 저장한다.

향후 최적화본은 같은 입력·반복·클럭·메모리 정책으로 비교하고, 원본도 함께 재측정한다.
격리 커널과 전체 FN-DSA 펌웨어는 주소 배치 및 호출 환경이 다르므로 기존 전체 프로파일의
함수당 추정 사이클과 이 직접 측정값을 섞어 개선율을 계산하지 않는다.
