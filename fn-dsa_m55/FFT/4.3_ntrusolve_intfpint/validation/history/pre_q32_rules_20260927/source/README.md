# C 독립 후보: 정수 → 2×FP32 → 정수

사용자가 복사한 `ntt_opt`에서 **B와 독립적으로** 구현한 실험입니다. B의 소스를 가져오거나 링크하지 않습니다.

**현재는 채택 불가 실험 후보입니다. 원본 키생성 KAT는 294/300 일치합니다.** 정확한 NTRU 방정식은 300/300 통과하지만 그것만으로 원본 KAT 유지 조건이 충족되는 것은 아닙니다. 최종 수치·한계·원시 로그는 [result.md](result.md)를 확인하세요.

## 구현 경로

- `solve_NTRU_intermediate()`, 공개 크기 `logn >= 4`: 정수 limb → 직접 DS 입력 → MVE FFT → DS 역수·점곱 → MVE iFFT → 직접 정수 k.
- `solve_NTRU_depth0()`, `logn >= 4`: 정수 분자/분모 → 직접 축소 DS 입력 → FFT·나눗셈·iFFT → 직접 정수 k.
- `logn < 4`: 원본 고정소수점 경로. B와 같은 공개 크기 정책입니다.
- NTT·CRT·Bezout·정수 다항식 갱신·서명·검증은 변경하지 않았습니다.
- 공통 invnorm만 기존 `4.1`에서 독립적으로 가져온 Q32 제곱합 + FP64 나눗셈을 적용했습니다. 키 후보 검사의 공개 FFT/iFFT는 그대로입니다.

실수 성분 하나가 `hi + lo`인 FP32 두 개입니다. 복소수는 실수부 DS 한 쌍과 허수부 DS 한 쌍입니다. 연속 계산 구간에는 double 배열도, 중간 Q32 입력·출력 배열도 없습니다. 정수 입력의 원본 비트 선택 규칙은 레지스터 단위 limb 추출에 남습니다.

## 파일

| 파일 | 역할 |
|---|---|
| `kgen_ntru.c` | 두 NTRU 구간의 독립 연결과 작업공간 수명 |
| `kgen_fxp.c` | 공통 invnorm 반영만 |
| `kgen_ds.h` | 내부 DS 형식·함수 선언 |
| `kgen_fft_mve.c` | 로컬 상수표, FFT 제어, 직접 입출력 변환, DS 산술 |
| `kgen_fft_cm55.s` | 직접 MVE FP32 butterfly 어셈블리 |

MVE 어셈블리와 상수표는 이전 `4.1`/stage-11 기반을 각자 독립 포팅했습니다. C용 정수 경계·나눗셈 보정·반올림·solve 연결은 이 폴더에서 작성했습니다. 주변 점별 연산은 첫 실험에서 scalar FP32 + FMA이며 FFT/iFFT butterfly가 MVE 어셈블리입니다.

두 로컬 작업공간은 각각 8 KiB입니다. 전역 가변 scratch 없이 재진입 가능하고, 기존 k/NTT 임시 영역 alias는 그대로 유지합니다.

## 정확성과 보안 경계

- 비밀 scale로 메모리를 직접 인덱싱하지 않고 원본처럼 전체 limb를 스캔/마스킹합니다.
- 정규화 FP32 reciprocal seed 1회, 잔차 곱셈 보정 2회로 나눗셈을 구현했습니다.
- 최종 반올림은 Q32 배열 없이 원본 경계의 두 단계 반올림 규칙을 처리합니다. 음수 반정수 주변도 검증합니다.
- NaN/Inf/범위 초과를 정수 캐스팅 전에 마스킹하고 reduction 실패로 반환합니다. 실패 seed 특례나 원본 재실행 fallback은 없습니다.
- FFT·점별 계산의 **모든 내부 Q32 절삭/overflow 규칙까지 에뮬레이션한 것은 아닙니다.** 남은 KAT 불일치를 숨기면 안 됩니다.
- 유한 입력의 시간 검사와 정적 분기 검사이지, 전체 입력 상수시간 증명이나 전력/EM 평가는 아닙니다.

## 빌드·실측

실제 C 펌웨어 재현 경로는 복사된 과거 Makefile/profiling이 아니라 `validation/`입니다.

```sh
sh validation/build.sh kat
sh validation/build.sh ds
sh validation/build.sh sigkat
sh validation/build.sh keygen_current
sh validation/build.sh fixtures
```

공유 환경 Python으로 `validation/run_board.py MODE`를 호출합니다. 한 보드에서는 한 번에 하나만 실행합니다. 소스·ELF·로그 SHA-256, 빌드 옵션, fault/TCM/ECC, 원본 KAT를 검사합니다. 다른 후보의 암호소스를 빌드 옵션으로 대체하지 않습니다.

복사된 이전 NTT README/result는 `validation/legacy/`에 보존했습니다. 기존 `build/`, `profiling/` 및 profile 문서는 과거 기록이며 **C 결과가 아닙니다.**
