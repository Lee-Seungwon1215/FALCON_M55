# Final_code / Before_slothy

현재 채택한 M55 통합 구현: **공통 q-NTT S1B_S2B_S3A + RNS NTT K4C + 키생성 FFT A17**.
SLOTHY는 적용하지 않았다. `After_slothy` 및 이전 연구 후보 디렉터리는 이번 정리에서 변경하지 않았다.

## 소스 구성

| 부분 | 실제 구현 |
|---|---|
| 공통 q=12289 NTT/iNTT | `mq_cm55.s`; Barrett 상수표는 `mq.c` |
| NTRU solve의 RNS NTT/iNTT | `kgen_mp31_cm55.s`: K4C. 작은 크기의 C 경로 및 상수표 생성은 `kgen_mp31.c` |
| 키생성 FFT A17 | `kgen_fft_cm55.s/.h`, `kgen_fft_mve.c`, `kgen_fft_bridge.c`, `kgen_ds.h`, `kgen_fxp.c`, `kgen_poly.c`, `kgen_ntru.c`, `kgen_inner.h` |
| 유지한 기존 스칼라 ASM | `codec_cm4.s`, `sha3_cm4.s`, `sign_fpr_cm4.s`, `sign_sampler_cm4.s` |

이름에 `cm4`가 있는 네 파일은 M55에서도 사용하는 기존 루틴이다. 임의로 삭제하거나 MVE로 교체한 것으로 해석하지 않는다.

공통 NTT의 지원 범위는 `logn=2..10`이다. RNS NTT는 `logn<4`에서 C 경로를 사용한다.
K4C의 inverse 상수표는 **full root `wR`**이며 마지막에 `1/n`을 적용한다.
기존 half-root `wR/2` 표와 혼용하면 안 된다.

## 독립적인 M55 빌드

```sh
make CROSS_COMPILE=/path/to/arm-none-eabi-
```

산출물은 `build/libfndsa_m55.a`이다. GCC 15.2.1에서 확인했다.

- CPU/ABI: `-mcpu=cortex-m55 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard`
- C: `-O3 -ffp-contract=off -fno-fast-math -fno-strict-aliasing`
- 구현 선택은 `fndsa_m55_config.h`에 고정되어 있다. `-DFNDSA_MVE_MP31=1` 등을 외부에서 지정할 필요가 없다.
- 다른 후보의 소스를 include/link하거나 빌드 옵션으로 최적화 후보를 선택하지 않는다.
- 이 트리는 M55 전용이다. 데스크톱 또는 M4용으로 빌드하려 하면 명시적으로 실패한다.
- 실제 펌웨어에는 해당 보드의 startup·메모리 배치·런타임이 별도로 필요하다. 라이브러리만 빌드한 것은 보드 실행 검증과 다르다.

예전 `Makefile.cm4`, `Makefile.win32`와 데스크톱 Makefile은 이 통합 구현에 맞지 않아 제거/교체했다.
원본은 아래 정리 전 백업에 보존되어 있다.

## 정리한 항목

- 미사용 공통 NTT 진단 함수 `fndsa_stage3_mul_probe` 제거.
- 동일한 `MQ_MUL_X8`/ `MQ_MVE_MMUL` 매크로를 하나로 통합.
- 512 전용 경로로 이미 분기한 뒤 일반 루프에 남아 있던 중복 크기 검사 제거.
- `mq.c`의 `#if 0` 폐기 함수 제거. **실제 서명에서 사용하는 ASM 함수는 유지**.
- K4C/Barrett/full inverse root에 맞게 설명 수정.
- M55 설정 누락으로 다른 RNS 경로가 선택되는 문제 방지.
- 기존 기록은 새 통합 코드의 측정 결과가 아님을 구분.

K4C의 계산 명령·스케줄과 A17 FFT의 계산은 변경하지 않았다.
공통 NTT의 명령 배치는 정리 과정에서 이동하므로 성능을 무조건 동일하다고 가정하지 않는다.

## 검증과 기록

[현재 정리 및 재검증 결과](result.md)를 참고한다.
검증 도구는 [../validation](../validation)에 두어 생산 소스와 구분했다.
암호 소스 27개는 모두 이 디렉터리에서 직접 컴파일한다.
외부에서 재사용하는 것은 기존 시험 입력·검사 코드와 보드 startup/측정 도구뿐이다.

```sh
# FALCON workspace root에서
bash Final_code/validation/build.sh ntt
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python Final_code/validation/run_board.py ntt
# kat, extra, sigkat, api, keygen도 동일한 형식
```

정리 전 전체 소스·문서·Makefile 백업:
[Before_slothy_before_ntt_cleanup.tar.gz](../validation/snapshots/Before_slothy_before_ntt_cleanup.tar.gz).

`stage_profile_result.md`, `ntru_fft_profile_result.md`는 **이전 ntt_opt 측정 기록**이며,
A17을 포함한 현재 통합본의 연산 비중으로 사용하면 안 된다.
원본 라이선스는 [LICENSE](LICENSE)에 유지했다.
