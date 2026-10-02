# B 구현의 NTT·FFT·sampling 함수 지도

확인일: 2026-09-12. 대상은 `fn-dsa_m55/ref`의 현재 B 구현이다.

## 1. 범위와 확인 방법

- 원본 HEAD: `a5f15894bf1a68017074650d5298cecf9bb29a79`.
- B 빌드 감사에 기록된 소스 35개와 현재 파일의 SHA-256을 비교: 변경 없음.
- 최종 B ELF: `build-dtcm/zephyr/zephyr.elf`.
- ELF SHA-256: `c415762b0c572db02f144fb77ac78a02e8af571544faab2dfa4334a5dfe1b65f`.
- 실제 `compile_commands.json`의 옵션으로 C 파일을 전처리하여 활성 분기를 확인했다.
  전처리 출력은 메모리에서만 분석했으며, 컴파일·링크 결과물을 갱신하지 않았다.
- 기존 ELF의 `nm` 심볼과 `objdump`의 직접 호출·tail call을 소스와 대조했다.
- M4 어셈블리 ON, SSE2/AVX2/NEON/RV64D 분기 OFF인 B가 대상이다.
  GCC 자동 MVE는 포함되지만, 별도의 수동 MVE FN-DSA 백엔드는 없다.
- 보드 실행·리셋·성능 재측정·암호 소스 변경은 하지 않았다.

이 문서의 “사용”은 해당 API의 활성 소스 호출 경로를 뜻한다. 매회 호출 횟수나
실행 시간 비중을 새로 측정한 것은 아니다. 재귀 깊이·재시도·입력에 따라 실행이
달라지며, 인라인 함수는 독립적인 ELF 심볼이나 `bl` 명령으로 남지 않을 수 있다.

목록은 NTT/FFT 변환, 그 표현에서 사용하는 다항식 연산, Gaussian/ffSampling,
Hash-to-Point와 난수 공급의 연결을 다룬다. 키 인코딩·전체 CRT 구현·OS 함수의
모든 하위 함수까지 나열하는 전체 프로그램 함수 목록은 아니다.

## 2. 결론: 공통 함수와 전용 함수가 섞여 있다

| 함수 계열 | 키생성 | 서명 | 검증 | 공유 관계 |
|---|---|---|---|---|
| `mqpoly_int_to_ntt` | 사용 | 사용 | 사용 | q=12289 공통 정방향 NTT |
| `mqpoly_ntt_to_int` | 호출하지 않음 | 사용 | 사용 | q=12289 공통 역방향 NTT |
| `mp_NTT`, `mp_iNTT` | 사용 | 없음 | 없음 | NTRU 전용 31비트 소수 NTT |
| `vect_FFT`, `vect_iFFT` | 사용 | 없음 | 없음 | 키생성 전용 고정소수점 FFT |
| `fpoly_FFT`, `fpoly_iFFT` | 없음 | 사용 | 없음 | 서명 전용 FP64 에뮬레이션 FFT |
| `sample_f` | 사용 | 없음 | 없음 | f와 g가 같은 키생성 샘플러 사용 |
| `ffsamp_fft`, `sampler_next` 계열 | 없음 | 사용 | 없음 | 서명 전용 Gaussian sampling |
| `hash_to_point` | 없음 | 사용 | 사용 | 메시지의 결정적 균등 매핑 공유 |

512와 1024에 각각 별도의 최상위 NTT/FFT/샘플러 본체를 작성한 구조는 아니다.
대부분 같은 함수에 `logn=9/10`을 전달한다. 키생성 NTRU·서명 ffSampling에서는
재귀 깊이에 따라 더 작은 `logn`으로도 같은 함수를 재사용한다. `sample_f`는
같은 함수 안에서 512/1024용 분포 테이블을 고른다.

### 이름과 구현 파일을 읽는 방법

C 코드의 `mqpoly_int_to_ntt`는 헤더 매크로로 실제 심볼
`fndsa_mqpoly_int_to_ntt`에 연결된다. 두 이름이 별도 알고리즘은 아니다.
대부분의 공개 내부 함수도 같은 `fndsa_` 접두 규칙을 따른다.

또한 `mq.c`에 같은 이름의 C 구현이 보이더라도 B에서는 해당 C 분기가 제외되고
`mq_cm4.s`의 어셈블리 정의가 선택될 수 있다. C fallback만 고쳐서는 B에 반영되지
않는다. [실제 빌드 선택](app/CMakeLists.txt), [명명 규칙](../ref/inner.h).

## 3. q=12289 NTT: 키생성·서명·검증의 공통 계열

| 함수 | 키생성 | 서명 | 검증 | B 구현 위치 / 역할 |
|---|---|---|---|---|
| `mqpoly_int_to_ntt` | f 역원 검사, pk 계산 | G 복원, 서명값 계산 | s2 변환 | `mq_cm4.s`: 정방향 NTT |
| `mqpoly_ntt_to_int` | 없음 | G 복원, 서명값 계산 | s2·h 곱 복원 | `mq_cm4.s`: 역방향 NTT |
| `mqpoly_mul_ntt` | 직접 호출 없음 | G 및 서명값 계산 | s2·h 계산 | `mq_cm4.s`: NTT 영역 점별 곱 |
| `mqpoly_div_ntt` | h=g/f | h=g/f 재계산 | 없음 | `mq.c`: NTT 영역 점별 나눗셈 |
| `mqpoly_is_invertible` | f 후보 검사 | 없음 | 없음 | `mq.c`: 내부에서 공통 정방향 NTT 호출 |

`mqpoly_mul_ntt`/`mqpoly_div_ntt`는 입력을 다시 NTT로 변환하는 함수가 아니다.
이미 NTT 표현인 배열에 곱셈/나눗셈을 수행한다. 특히 `mqpoly_div_ntt`는 자체
배치 역원 계산을 수행하며, 단순히 `mqpoly_mul_ntt`를 호출하는 wrapper가 아니다.

이 경로의 보조 다항식 함수도 공유된다.

| 보조 함수 | 사용 단계 | B 구현 |
|---|---|---|
| `mqpoly_small_to_int` | 키생성·서명 | `mq_cm4.s`: 작은 부호 있는 계수 → 내부 mod-q 표현 |
| `mqpoly_signed_to_int` | 서명·검증 | `mq_cm4.s`: 부호 있는 계수 → 내부 mod-q 표현 |
| `mqpoly_int_to_small` | 서명 | `mq.c`: 복원한 G를 작은 정수로 변환·검사 |
| `mqpoly_int_to_ext` | 키생성·검증 | `mq_cm4.s`: 내부/외부 잔여값 표현 변환 |
| `mqpoly_ext_to_int` | 검증·서명 소스에 등장 | `inner.h`: B에서는 아무 작업도 하지 않는 inline 함수; 외부 표현을 그대로 내부 표현으로 사용할 수 있음 |
| `mqpoly_add` | 서명 | `mq_cm4.s`: 다항식 덧셈 |
| `mqpoly_sub` | 서명·검증 | `mq_cm4.s`: 다항식 뺄셈 |

M4 ASM 계열의 내부 표현은 0과 q를 모두 0의 표현으로 허용한다. 따라서 외부
표현 [0,q-1]을 받아들이는 `ext_to_int`는 B에서 no-op이고, 반대 방향의
`int_to_ext`는 q를 0으로 정규화한다. 두 함수가 서로의 별칭인 것은 아니다.

정수 표현 변환 `int_to_ext`는 iNTT와 다르다. 조사한 커밋의 pk는 h의 NTT 표현을
인코딩한다. 따라서 keygen에서 `mqpoly_div_ntt` 다음에 `mqpoly_int_to_ext`가
있어도 그것을 역변환으로 읽으면 안 된다. 검증에서도 pk h를 새로 NTT하지 않고
디코딩한 NTT 표현을 사용한다.

소스 진입점: [keygen_inner](../ref/kgen.c), [sign_step1](../ref/sign.c),
[sign_core](../ref/sign_core.c), [inner_verify](../ref/vrfy.c).
구현: [mq_cm4.s](../ref/mq_cm4.s), [mq.c](../ref/mq.c).

## 4. NTRU용 31비트 NTT: 별도의 키생성 전용 계열

q=12289 NTT와 달리, 여러 31비트 소수 p에 대해 큰 정수를 RNS로 다룬다.
배열은 `uint32_t`이고 p·Montgomery 상수·변환 테이블을 인자로 전달한다.

| 함수 | 역할 | 파일 |
|---|---|---|
| `mp_NTT` | 소수 p에 대한 정방향 NTT | `kgen_mp31.c` |
| `mp_iNTT` | 소수 p에 대한 역방향 NTT | `kgen_mp31.c` |
| `mp_mkgmigm` | 정/역 변환 테이블을 함께 생성 | `kgen_mp31.c` |
| `mp_mkgm` | 정방향 변환 테이블 생성 | `kgen_mp31.c` |
| `mp_mkigm` | 역방향 변환 테이블 생성 | `kgen_mp31.c` |

소스상의 직접 호출 관계는 다음과 같다.

| 호출자 | 이 계열에서 호출하는 함수 |
|---|---|
| `make_fg_zero` | `mp_mkgm`, `mp_NTT` |
| `make_fg_step` | `mp_mkgm`, `mp_mkigm`, `mp_NTT`, `mp_iNTT` |
| `solve_NTRU_intermediate` | `mp_mkgm`, `mp_mkgmigm`, `mp_NTT`, `mp_iNTT` |
| `solve_NTRU_depth0` | `mp_mkgm`, `mp_mkigm`, `mp_NTT`, `mp_iNTT` |
| `poly_sub_scaled_ntt` | `mp_mkgmigm`, `mp_NTT`, `mp_iNTT` |
| `poly_sub_kf_scaled_depth1` | `mp_mkgm`, `mp_mkigm`, `mp_NTT`, `mp_iNTT` |

`solve_NTRU`가 deepest → intermediate → depth0 순서로 깊이별 처리를 관리한다.
`solve_NTRU_deepest`는 `make_fg_deepest`를, `solve_NTRU_intermediate`는
`make_fg_intermediate`를 호출한다. 이 두 `make_fg_*` 함수는 다시 같은
`make_fg_zero`와 `make_fg_step`을 재사용한다. 따라서 간접 호출 경로에서도
동일한 NTT 본체가 사용되며, 깊이마다 독립된 NTT 본체가 있는 것은 아니다.

기본 모듈러 산술은 `kgen_inner.h`의 `mp_*` inline 함수와 일부 정수/DSP
인라인 어셈블리를 사용한다. q-NTT의 `mq_*` 산술층과는 별개다.
현재 B에서 `mp_NTT`를 바꾸면 키생성에 영향을 주지만 서명/검증에는 직접 영향이 없다.
[NTT 구현](../ref/kgen_mp31.c), [호출자](../ref/kgen_ntru.c),
[정수 다항식 갱신](../ref/kgen_poly.c).

## 5. FFT: 키생성 fxr와 서명 fpr가 완전히 다른 계열

### 5.1 키생성 — fxr, 32.32 고정소수점

활성 키생성 경로에서 사용하는 벡터/FFT 계열은 아래와 같다.

| 함수 | 직접 사용하는 상위 함수 | 역할 |
|---|---|---|
| `vect_FFT` | `check_ortho_norm`, `solve_NTRU_intermediate`, `solve_NTRU_depth0` | FFT |
| `vect_iFFT` | 위와 같음 | iFFT |
| `vect_set` | `check_ortho_norm` | 작은 정수 계수 → fxr |
| `vect_mul_realconst` | `check_ortho_norm` | 실수 상수 곱 |
| `vect_adj_fft` | `check_ortho_norm` | 복소 켤레 처리 |
| `vect_mul_selfadj_fft` | `check_ortho_norm` | 자기수반 다항식과 곱 |
| `vect_invnorm_fft` | `check_ortho_norm` | 제곱노름 합의 역수 |
| `vect_mul_fft` | `solve_NTRU_intermediate` | FFT 영역 복소 곱 |
| `vect_inv_mul2e_fft` | `solve_NTRU_intermediate` | 역수와 스케일 조정 |
| `vect_div_selfadj_fft` | `solve_NTRU_depth0` | FFT 영역 나눗셈 |

추가로 `poly_big_to_fixed` (`kgen_poly.c`)가 큰 정수 계수를 스케일된 fxr로
변환하고, `fxr_round`가 Babai 보정 다항식 k의 정수 계수를 만든다.
최하위 산술층은 `kgen_inner.h`의 `fxr_*`이며, 나눗셈은
`fxr_div`/`fxr_inv` → `inner_fxr_div` (`kgen_fxp.c`)로 연결된다.
곱셈/제곱 등에는 B의 M4 정수/DSP 인라인 어셈블리가 사용된다.

`vect_add`, `vect_mul2e`, `vect_norm_fft`도 소스에 정의돼 있지만, 조사한 현재
키생성 경로에서는 호출되지 않는다. 정의 목록과 실제 호출 목록을 구분해야 한다.
[고정소수점 FFT/벡터 구현](../ref/kgen_fxp.c), [fxr 산술](../ref/kgen_inner.h).

### 5.2 서명 — fpr, FP64 비트 표현/정수 에뮬레이션

활성 서명 경로에서 사용하는 다항식/FFT 계열은 아래와 같다.

| 함수 | 직접 사용하는 상위 함수 | 역할 |
|---|---|---|
| `fpoly_FFT` | `basis_to_FFT`, `fpoly_apply_basis` | FFT |
| `fpoly_iFFT` | `sign_core` | 샘플링 결과를 계수 표현으로 복원 |
| `fpoly_set_small` | `basis_to_FFT` | 작은 정수 계수 → fpr |
| `fpoly_neg` | `basis_to_FFT` | 기저의 부호 조정 |
| `fpoly_gram_fft` | `sign_core` | FFT 기저의 Gram 행렬 계산 |
| `fpoly_apply_basis` | `sign_core` | 메시지 다항식을 FFT로 변환하고 목표 벡터 계산 |
| `fpoly_mulconst` | `fpoly_apply_basis` | ±1/q 배율 적용; B에서는 인라인됨 |
| `fpoly_LDL_fft` | `ffsamp_fft_inner` (ASM) | LDL 분해 |
| `fpoly_split_selfadj_fft` | `ffsamp_fft_inner` (ASM) | 자기수반 다항식을 재귀 하위 문제로 분할 |
| `fpoly_split_fft` | `ffsamp_fft_inner` (ASM) | 일반 FFT 다항식 분할 |
| `fpoly_merge_fft` | `ffsamp_fft_inner` (ASM) | 하위 문제 결과 병합 |
| `fpoly_mul_fft` | `ffsamp_fft_inner`, `fpoly_apply_basis` | FFT 영역 복소 곱 |
| `fpoly_sub`, `fpoly_add` | `ffsamp_fft_inner` (ASM) | 재귀 샘플링 목표 벡터 갱신 |

이 함수들은 `sign_fpoly.c`에 있다. **이름 끝의 `_fft`는 대부분 입력이 이미
FFT 표현이라는 뜻**이다. `fpoly_LDL_fft`나 `fpoly_mul_fft`가 내부에서
`fpoly_FFT`를 반복 호출하는 것으로 읽으면 안 된다.

`basis_to_FFT`는 `sign_core.c`의 준비 함수로 f,g,F,G 네 다항식을 같은
`fpoly_FFT`에 전달한다. `fpoly_apply_basis`도 그 `fpoly_FFT`를 재사용한다.
B의 샘플링 이후 서명값 계산은 iFFT 뒤 q-NTT 경로를 사용한다. 파일의
SSE2/NEON/RV64D 전용 “FFT에 계속 머무르는 후처리”는 현재 활성 분기가 아니다.

`fpoly_muladj_fft`, `fpoly_mulownadj_fft` 정의는 이 B의 활성 서명 호출 경로에서
사용되지 않는다. 반대로 `fpoly_mulconst`는 독립 ELF 심볼이 없어도 실제로 사용된다.

하위 FP64 에뮬레이션 산술은 다음과 같이 공유된다.

- `fpr_scaled`, `fpr_of32`, `fpr_add`, `fpr_mul`, `fpr_sqr`, `fpr_div`,
  `fpr_sqrt`: B에서는 `sign_fpr_cm4.s`의 정의를 사용.
- `FPR_ADD_SUB` 매크로 → 커스텀 호출 규약의 `fndsa_fpr_add_sub` 어셈블리.
- `FPC_MUL` 매크로 → `fpr_mul`과 `fpr_add`/`fpr_sub`를 조합.
- `fpr_sub`, `fpr_neg`, `fpr_half`, `fpr_inv`, `fpr_rint`, `fpr_floor`,
  `fpr_trunc` 등: `sign_inner.h`의 inline/매크로 계층.

따라서 이 산술층 개선은 서명 FFT뿐 아니라 LDL·ffSampling·샘플러의 해당
산술에도 영향을 줄 수 있다. 키생성의 `fxr`에는 전파되지 않는다.
[서명 FFT/다항식 구현](../ref/sign_fpoly.c), [호출 준비](../ref/sign_core.c),
[fpr 인터페이스](../ref/sign_inner.h), [B의 fpr ASM](../ref/sign_fpr_cm4.s).

## 6. Sampling: 키생성과 서명이 서로 다른 샘플러

### 6.1 키생성

```text
keygen_inner
  ├─ sample_f(..., f)       ── shake_next_u16
  ├─ f의 역원 존재 검사
  └─ sample_f(..., g)       ── shake_next_u16
```

f와 g는 **동일한 `sample_f`**를 사용한다. 후보가 탈락하면 이 과정이 반복된다.
`sample_f`는 `kgen_gauss.c`의 C 함수이며 `KGDist_512`/`KGDist_1024` 테이블을
선택한다. 서명의 `sampler_next`나 `fndsa_gaussian0_helper`를 호출하지 않는다.

### 6.2 서명

```text
sign_core
  └─ ffsamp_fft                       [C wrapper]
      └─ fndsa_ffsamp_fft_inner       [M4 ASM, 재귀]
          ├─ fpoly_LDL_fft
          ├─ fpoly_split_* / fpoly_merge_fft
          ├─ fpoly_add/sub/mul_fft
          ├─ 자기 자신을 작은 logn으로 호출
          └─ ffsamp_fft_deepest       [C, logn=1]
              └─ sampler_next        [C]
                  ├─ GAUSSIAN        [매크로]
                  │   ├─ shake_next_u64 / shake_next_u16
                  │   └─ fndsa_gaussian0_helper [M4 ASM]
                  └─ ber_exp         [C inline]
                      ├─ expm_p63    [C + 정수 인라인 ASM]
                      └─ shake_next_u8
```

| 함수/매크로 | 역할 | B 구현 위치 |
|---|---|---|
| `ffsamp_fft` | 샘플링 진입점 | `sign_sampler.c` |
| `ffsamp_fft_inner` | LDL·분할·샘플링을 재귀적으로 진행 | `sign_sampler_cm4.s` |
| `ffsamp_fft_deepest` | 가장 작은 하위 문제를 처리하고 1차원 샘플러 호출 | `sign_sampler.c` |
| `sampler_next` | 중심 mu·폭에 맞는 정수 Gaussian 값 하나 생성 | `sign_sampler.c` |
| `GAUSSIAN` | 난수 취득·기본 분포 샘플러 연결 | `sign_sampler.c`의 매크로 |
| `fndsa_gaussian0_helper` | 표를 이용한 half-Gaussian 기본 샘플러 | `sign_sampler_cm4.s` |
| `ber_exp` | 확률적 거부/수락 판정 | `sign_sampler.c`, B에서는 inline |
| `expm_p63` | 거부 판정용 exp(-x) 근사값 | `sign_sampler.c`, B에서는 inline; 정수 곱셈 ASM 포함 |

`ffsamp_fft_inner`의 C 정의도 소스에 있지만 B에서는 제외된다. 전체 샘플러가
어셈블리인 것은 아니다. 재귀 진행과 Gaussian0 핵심은 ASM, deepest와
`sampler_next` 등은 C/인라인 ASM의 조합이다.
[키생성 샘플러](../ref/kgen_gauss.c), [서명 샘플러](../ref/sign_sampler.c),
[선택된 샘플러 ASM](../ref/sign_sampler_cm4.s).

### 6.3 검증: Gaussian sampling 없음, Hash-to-Point는 있음

검증은 `sample_f`, `sampler_next`, `ffsamp_fft`를 호출하지 않는다.
하지만 서명과 같은 `hash_to_point` (`util.c`)를 호출한다. 이것은 nonce와 mu를
SHAKE에 넣고 q 범위의 계수를 얻는 **결정적 균등 rejection mapping**이다.
서명의 Gaussian sampling과 별도다. 검증에서 새로운 비밀 난수를 뽑는 것도 아니다.

### 6.4 난수 공급은 SHAKE 계열을 공유

`prng_next_u8/u16/u64`는 현재 `shake_next_u8/u16/u64`의 매크로 별칭이다.
이 inline 접근 함수들은 필요할 때 `shake_extract`를 호출하고,
`shake_extract`/`shake_inject`의 블록 처리는 `fndsa_sha3_process_block`을 사용한다.
이 핵심은 B에서 `sha3_cm4.s`의 어셈블리다. 키생성·서명·검증의 SHAKE 처리는
이 기반을 공유한다. SHAKE 시간은 이전 프로파일에서 sampling/Hash-to-Point와
배타적으로 집계했으므로 그 비율을 중복 합산하지 않는다.

## 7. 어느 함수를 개선하면 어디에 영향을 주는가

| 수정 대상 | 직접 영향을 받는 단계 |
|---|---|
| q 정방향 NTT (`mqpoly_int_to_ntt`) | 키생성·서명·검증 |
| q 역방향 NTT / 점별 곱 | 현재 경로에서는 서명·검증 |
| q 나눗셈 (`mqpoly_div_ntt`) | 키생성·서명 |
| RNS NTT (`mp_NTT`, `mp_iNTT`) | 키생성 |
| 고정소수점 FFT/산술 (`vect_*`, `fxr_*`) | 키생성 |
| 서명 FFT/FP64 산술 (`fpoly_*`, `fpr_*`) | 서명 |
| `sample_f` | 키생성 |
| `sampler_next` / Gaussian0 / BerExp | 서명 |
| `hash_to_point` | 서명·검증 |
| SHAKE/Keccak 공통 핵심 | 키생성·서명·검증 |

“영향”은 해당 코드가 사용된다는 의미이지 속도 향상을 보장하거나 기여율을
측정했다는 의미가 아니다. 현재 B 조건의 연산 비중 재측정은 별도 작업이다.
특히 키생성의 NTRU 기타/CRT 비용과 검증의 SHAKE 비용도 커서, NTT·FFT·sampling
세 이름만으로 모든 주요 비용이 포함된다고 해석해서는 안 된다.
