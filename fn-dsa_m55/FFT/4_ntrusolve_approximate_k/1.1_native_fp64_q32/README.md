# 1.1_native_fp64_q32 — NTRU ④ 단일-double 연구 기준선

이 폴더는 `ntt_opt`의 기존 NTT 최적화를 유지하고, 키생성의
`solve_NTRU_intermediate()`에서 근사 k 계산에 FP64를 사용하는 독립 소스다.
실수부·허수부 각각 double 하나를 사용하며, 원본 Q32.32 계산 규칙을 맞추기 위한
절삭·wrap·half·나눗셈 보정과 최신 L1 안전 검사를 포함한다.

이식 원본은 `function_compare/fft_native_fp64/q32_trial`이다.
루트 암호 소스 31개는 복사 당시 원본과 동일하며, 다른 폴더의 암호 코드를
include하거나 링크해서 실행하지 않는다. 소스/검사 자료의 출처와 SHA-256은
[origin_manifest.json](validation/origin_manifest.json)에 있다.

## 범위와 상태

- 변경 범위: NTRU ④의 입력 변환 → FFT → 역수·점별 곱셈 → iFFT → 정수 k.
- 유지: NTT/RNS, CRT, Bezout, 정확한 정수 해 갱신, depth0, 후보 검사,
  서명 FFT/sampler, 검증.
- `ntt_opt`와 다른 암호 파일: `kgen_inner.h`, `kgen_fxp.c`,
  `kgen_poly.c`, `kgen_ntru.c`.
- `mq_cm55.s`, `kgen_mp31_cm55.s`는 기존 NTT 구현과 동일하다.
- 새 경로의 빌드·M55 검증·성능 기록은 [result.md](result.md)에 정리한다.
- **연구용 FP64 기준선이지, 고정소수점보다 빠르거나 모든 입력에서
  동등성·상수시간을 보장하는 최종 배포 구현은 아니다.** 알려진 산술 경계값
  반례와 입력 의존 시간 문제가 남아 있다.

## 현재 유효한 빌드·검사 경로

이 폴더에서 아래 명령을 실행한다. `validation/build.sh`는 항상
**이 폴더 루트의 소스**를 빌드한다. 프로파일만 NTRU의 빌드용 사본에
서로 겹치지 않는 타이머 구간을 삽입하며 계산식·guard는 바꾸지 않는다.

```sh
bash validation/build.sh kat
python3 -B validation/run_board.py kat

bash validation/build.sh sigkat
python3 -B validation/run_board.py sigkat

bash validation/build.sh guard_repro
python3 -B validation/run_board.py guard_repro

bash validation/build.sh perfct
python3 -B validation/run_board.py perfct
python3 -B validation/run_board.py perfct

bash validation/build.sh keyprofile
python3 -B validation/run_board.py keyprofile
```

NTRU solve 전체를 분모로 ④ FP64 함수 4개·⑤ 고정소수점 함수 3개와
입력 변환·반올림·나머지를 분리하려면 다음 전용 모드를 사용한다.
`keyprofile`은 기존대로 ④의 근사 k 구간만 계측하므로 분모가 다르다.

```sh
bash validation/build.sh ntruprofile
bash validation/build.sh ntrucontrol
python3 -B validation/run_board.py ntruprofile
python3 -B validation/run_board.py ntrucontrol
python3 -B validation/run_board.py ntruprofile

python3 -B validation/analyze_ntru_profile.py \
  --detail <첫 ntruprofile 결과 경로> \
  --control <ntrucontrol 결과 경로> \
  --repeat <두 번째 ntruprofile 결과 경로>
```

각 실행은 512/1024 각각 `test0`..`test99` 100개 키를 생성하고 KAT·NTRU 식을
검사한다. 실패한 NTRU 호출도 전체 시간에 포함한다. 암호 원본은 수정하지 않으며
생성된 계측 사본에서 타이머 삽입문을 제거하면 원본과 바이트 단위로 일치한다.
`ntrucontrol`은 NTRU 진입/반환만 계측한다. 계측 overhead와 코드 배치 영향은
결과에 포함하고, 대조 실행과의 차이를 임의로 빼지 않는다.
최신 전체 NTRU 함수별 표·사이클·로그는
[ntru_full_profile_result.md](ntru_full_profile_result.md)에 있다.

키 후보의 직교노름 검사(`check_ortho_norm`)에서 사용하는 추가 FFT 영역 함수는
다음 별도 모드로 측정한다. 분모는 **전체 키생성**과 **직교노름 검사** 두 가지이며,
NTRU 전체 프로파일의 백분율과 직접 더하지 않는다. 거절된 후보도 포함한다.

```sh
bash validation/build.sh orthoprofile
bash validation/build.sh orthocontrol
python3 -B validation/run_board.py orthoprofile
python3 -B validation/run_board.py orthocontrol
python3 -B validation/run_board.py orthoprofile

python3 -B validation/analyze_ortho_profile.py \
  --detail <첫 orthoprofile 결과 경로> \
  --control <orthocontrol 결과 경로> \
  --repeat <두 번째 orthoprofile 결과 경로>
```

`vect_invnorm_fft`, `vect_adj_fft`, `vect_mul_selfadj_fft`, `vect_mul_realconst`를
각각 분리하고 같은 검사에서 호출되는 fixed FFT/iFFT·입력 변환·노름 합도 계측한다.
키생성 전체 타이머는 `fndsa_keygen_seeded_temp()` 호출을 감싸며,
KAT·NTRU 방정식 검사·출력은 타이머 밖에 있다.
직교노름 타이머는 함수 진입 후부터 마지막 비교/반환 직전까지다.
`orthocontrol`은 키생성 전체와 직교노름 전체 타이머만 유지한다.
개별 함수 시간은 호출 준비·타이머 경계 비용을 포함한 호출 구간 시간이다.
측정 표와 원시 기록은 [ortho_profile_result.md](ortho_profile_result.md)에 있다.

보드 실행은 지정 N657 serial `003C00223335510735383531` 한 대에서 순차 수행한다.
800 MHz, cache OFF, ITCM 코드/DTCM 상수·데이터·스택, GCC 15.2.1,
`-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math` 조건이다.
기존 `measurement_mlkem_native`의 부트·링커·Zephyr 및 보드 로더만 재사용한다.

각 실행에서 새 결과 경로가 출력된다. 다음 수집기에 실제 경로들을 전달한다.

```text
python3 -B validation/analyze.py
  --kat <kat 결과 경로>
  --sigkat <sigkat 결과 경로>
  --guard <guard_repro 결과 경로>
  --perf <perfct 1차 결과 경로>
  --repeat-perf <perfct 2차 결과 경로>
  --profile <keyprofile 결과 경로>
```

분석 도구는 이전 경로의 결과와 소스 hash도 대조한다. 이 비교 자료 의존성은
암호 소스의 빌드/실행 의존성이 아니다.

## 복사되어 있던 NTT 문서·빌드 구분

이전 README·result·전체 단계 프로파일은 [validation/legacy](validation/legacy)에
원문을 보존했다. 루트 `stage_profile_result.md`, `ntru_fft_profile_result.md`도
고정소수점 기준의 과거 기록이며 현재 FP64 결과가 아니다.

루트 `build/`, `profiling/`, `bench_cm4/` 및 기존 Makefile들은 이번
FP64 이식 결과로 인증한 측정 경로가 아니다. 삭제하지 않았지만, 새 기준선의
빌드·M55 검사는 위 `validation/` 진입점을 사용한다.
