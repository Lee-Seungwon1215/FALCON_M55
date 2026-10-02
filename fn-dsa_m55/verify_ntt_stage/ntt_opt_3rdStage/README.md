# FN-DSA M55 NTT 3단계: 3명령 모듈러 곱셈 비교

## 결론

`ref`(2단계 최종 코드), M1(3명령 Montgomery), B1(3명령 Barrett)을 같은
NUCLEO-N657X0-Q에서 비교했다. 세 구현 모두 오차·known-answer·서명 검증·변조
거부·정적 상수시간 검사를 통과했다. 속도는 **B1 Barrett이 모든 degree와
operation에서 가장 빨랐다.**

이 단계의 결과만 기준으로 하면 다음 통합 후보는
`b1_3instruction_Barrett`이다. 2026-09-13에 `mq.c`와 `mq_cm55.s`를
`../ntt_opt`에 함께 병합하고, 그 경로를 직접 다시 빌드해 pilot과 full
보드 검증까지 통과했다. 통합 결과는
[`../ntt_opt/README.md`](../ntt_opt/README.md)에 정리했다.

후속 4단계 통합으로 현재 `ntt_opt`는 S1B_S2B_S3A까지 포함한다.
이 문서의 1~3단계 기준은
[`../ntt_opt_4thStage/integration/before`](../ntt_opt_4thStage/integration/before/README.md)에
보존했다. 이 디렉터리의 `run_stage3.py ntt_opt ...`도 그 역사적 보존본을 사용한다.
현재 통합 코드의 실행 방법은 [`../ntt_opt/result.md`](../ntt_opt/result.md)를 참고한다.

## 후보 구현

| 이름 | 상수 곱셈의 핵심 3명령 | 정규화 | 전용 상수 위치 |
|---|---|---|---|
| M0 `ref` | 기존 MVE Montgomery reduction | 기존 방식 | 기존 `mq_GM`, `mq_iGM` |
| M1 | `VMUL` → `VQRDMULH` → `VQRDMLAH` | 두 번의 조건부 `+q`와 조건부 `-q` | `m1_3instruction_montgomery/mq.c` |
| B1 | `VQRDMULH` → `VMUL` → `VMLA` | 한 번의 조건부 `+q` | `b1_3instruction_Barrett/mq.c` |

B1의 수식은 알려진 twiddle용 Barrett reduction이다. GAS가 필요한
scalar-vector `VMLS` 형식을 받아들이지 않으므로 quotient 근삿값의 부호를 미리
반전하고, 동치인 `VMLA`로 세 번째 명령을 구현했다. 따라서 초기에 적었던
`VMLS` 설명과 실제 최종 명령은 다르지만 계산식은 같다.

각 후보의 `mq.c` 끝에 별도 include 없이 다음 네 개의 1,024-entry `int16_t`
배열을 직접 추가했다.

- forward root와 보정상수
- inverse root와 보정상수

총 전용 상수 크기는 후보당 8,192 B이다. 생성기는
`generate_stage3_tables.py`, 어셈블리 생성기는
`generate_stage3_assembly.py`이다.

## 빌드·측정 조건

- 보드: NUCLEO-N657X0-Q, Cortex-M55 r1p1
- CPU/SYSCLK/HCLK: 800/400/200 MHz
- 코드: ITCM (`0x10000000` 영역)
- 전역 상수·데이터·스택: DTCM (`0x30000000` 영역)
- 실행 중 I-cache/D-cache OFF (`CCR=0x611`)
- ITCM/DTCM enable: 각각 `0x49`
- TCM ECC enable/check: 실행 전후 `MSCR=0x1300a`
- GNU Arm 15.2.1, Zephyr 4.4.1, `-O3`, MVE 활성화
- `mlkem-native` Nucleo 실행기와 보드 설정 유지
- degree·operation마다 10개 고정 입력 batch
- 각 batch에서 10회 warm-up 후 10회 연속 측정
- 표의 값은 10개 block의 upper median을 10으로 나눈 cycle/call

로그의 `CONFIG icache=1 dcache=1`은 Zephyr 빌드 기능이 존재한다는 뜻이다.
실제 측정 중 cache 상태는 core `CCR` 비트로 확인했으며 둘 다 꺼져 있다.

## 실제 보드 성능

괄호는 같은 실행 조건의 M0 `ref` 대비 개선율이다. 양수는 더 빠르다는 뜻이다.

| degree | 구현 | keygen | sign | verify |
|---:|---|---:|---:|---:|
| 512 | M0 `ref` | 51,751,758 | 17,179,252 | 328,371 |
| 512 | M1 Montgomery | 51,750,343 (+0.003%) | 17,178,468 (+0.005%) | 328,346 (+0.008%) |
| 512 | **B1 Barrett** | **51,722,695 (+0.056%)** | **17,150,930 (+0.165%)** | **323,738 (+1.411%)** |
| 1024 | M0 `ref` | 260,594,160 | 36,857,452 | 644,596 |
| 1024 | M1 Montgomery | 260,526,914 (+0.026%) | 36,822,394 (+0.095%) | 638,819 (+0.896%) |
| 1024 | **B1 Barrett** | **260,391,745 (+0.078%)** | **36,748,666 (+0.295%)** | **626,546 (+2.800%)** |

B1은 동일한 10개 입력을 batch별로 직접 대응시켰을 때도 6개
degree-operation 조합의 모든 batch에서 `ref`보다 빨랐다. keygen 전체에서의
개선율이 작은 것은 NTT 외 NTRU solver 등의 비중이 훨씬 크기 때문이다.
verify는 NTT 비중이 상대적으로 커서 효과가 더 잘 드러난다.

최종 ELF의 executable text와 global rodata는 다음과 같다.

| 구현 | executable text | ref 대비 | global rodata | ref 대비 |
|---|---:|---:|---:|---:|
| M0 `ref` | 105,168 B | - | 50,780 B | - |
| M1 | 107,100 B | +1,932 B | 58,972 B | +8,192 B |
| B1 | 105,500 B | +332 B | 58,972 B | +8,192 B |

세 구현 모두 stack 사용 상한은 9,624 B로 같았다.

## 오차·KAT·서명 검증

| 검사 | M0 | M1 | B1 |
|---|---:|---:|---:|
| 512 forward oracle mismatch | 0 | 0 | 0 |
| 512 forward+inverse mismatch | 0 | 0 | 0 |
| 1024 forward oracle mismatch | 0 | 0 | 0 |
| 1024 forward+inverse mismatch | 0 | 0 | 0 |
| 최대 modular error | 0 | 0 | 0 |
| full fixed-input digest 22개와 host 일치 | PASS | PASS | PASS |
| 키생성·서명·정상 서명 검증 | PASS | PASS | PASS |
| 1-bit 변조 서명 거부 | PASS | PASS | PASS |
| `CFSR/HFSR/AFSR` | 모두 0 | 모두 0 | 모두 0 |

추가로 `reduction_model_check.c`가 `a=0..12289`, `w=0..12288`의
151,031,810개 입력쌍을 각 후보에 대해 전수검사했다. 두 후보 모두 modulo q
정답과 일치했다. 정규화 전 출력 범위는 M1 `[-16836,16836]`, B1
`[-8447,8447]`이었다.

실제 보드에서는 후보별로 forward 1,024개와 inverse 1,024개 전용 상수곱을
MVE 명령으로 직접 실행해 모두 확인했다. 이어 독립 scalar oracle과 512/1024
전체 NTT 계수를 비교하고 inverse round-trip까지 검사했다.

여기서 KAT 검사는 실제 보드 어셈블리 경로에서 고정 seed로 만든 20개
`sk || pk || sig` SHAKE256 digest와 degree별 aggregate digest 2개를 host 정답과
대조한 것이다. upstream `test_fndsa`의 host KAT만 실행한 것이 아니므로 이번
어셈블리 변경도 직접 검증된다.

## 상수시간 검사

정적 소스 감사와 최종 ELF 역어셈블 감사를 수행했다.

- M1/B1 상수 곱셈 macro 안에는 조건 분기가 없다.
- 계수 정규화는 `VCMP`/`VPST`의 lane predication으로 처리한다.
- 최종 ELF에서 M1은 `VQRDMULH`/`VQRDMLAH`가 각각 57개 site,
  B1은 `VQRDMULH`/`VMLA`가 각각 57개 site 존재한다.
- 추가된 분기는 공개값 `logn`, 구현 선택 여부, 고정 loop counter만 사용한다.
- root/twist와 데이터 주소 진행도 공개 degree와 고정 loop index에만 의존한다.
- 비밀 계수를 이용한 gather/scatter 또는 table index를 추가하지 않았다.
- `mq.c`는 생성 상수를 끝에 append한 것 외에는 `ref`와 동일하며, 다른 C/H/S
  파일은 `mq_cm55.s`를 제외하고 `ref`와 동일하다.

따라서 이번 변경으로 새 secret-dependent branch/address가 생기지 않았다는
정적 검사는 PASS이다. 다만 이는 소스·명령 수준 검사이며 전력/EM TVLA나
마이크로아키텍처 수준의 완전한 누설 부재 증명은 아니다.

## 결과 파일

- M0 full: `results/ref/runs/full-20260913T052835Z/raw.log`
- M1 full: `results/m1/runs/full-20260913T053026Z/raw.log`
- B1 full: `results/b1/runs/full-20260913T053219Z/raw.log`
- 각 실행의 ELF·소스 hash gate: `results/*/full_validated.json`
- 스칼라 전수검사: `reduction_model_check.c`

full run에 사용된 ELF SHA-256은 다음과 같다.

- M0: `d480f63c2ab9ae0cf36385e3157039032a51268bc5eef3258184724c3c72c154`
- M1: `fbfac72d5a62f6499352f1740eaa8bd662f4d286f2ae41e28b0c220a7191f23c`
- B1: `13d0eaf22133d81ab48bdae84a7d779e6fbe1d5e682e1b0883b3bbf07f1c4d09`

## 구현 중 잡은 통합 오류

pilot 차단 검사로 다음 문제를 찾아 최종 측정 전에 수정했다.

1. forward 테이블 선택이 저장된 `logn`이 아니라 이미 0으로 덮인 `r0`를 비교함
2. inverse 첫 두 레이어에서 twist vector를 butterfly 임시값으로 덮음
3. `q0`와 `s0..s3`가 같은 물리 레지스터라는 점 때문에 저장 상태가 손상됨
4. 1024 inverse 반복 경로가 중간에 기존 `iGM` 주소로 되돌아감

최종 pilot/full 결과와 위 해시는 네 수정 이후 코드 기준이다.
