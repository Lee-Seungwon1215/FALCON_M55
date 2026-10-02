# Before_slothy 검증 도구

생산 소스와 별도로 둔 보드 회귀검사이다. 암호 구현은 항상
`Final_code/Before_slothy`의 20개 C + 8개 ASM 파일을 직접 컴파일한다.
서명 FFT/iFFT의 `sign_fft_cm55.s`도 포함한다.
다른 후보의 암호 소스나 구현 선택용 `-DFNDSA_*` 옵션은 사용하지 않는다.

기존 `sep_27_ntrusolve_fft/validation`의 KAT·서명/API·성능 시험과
`ntt_ntrusolve/5th_slothy/measurement/app/benchmark.c`의 검사 helper만 재사용한다.
후자의 디렉터리 이름이 slothy인 것은 시험 코드의 출처일 뿐이며,
**SLOTHY로 생성한 암호 어셈블리를 연결하지 않는다.**

## 실행

FALCON workspace root에서:

```sh
bash Final_code/validation/build.sh ntt
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python Final_code/validation/run_board.py ntt
```

모드: `ntt`, `kat`, `extra`, `sigkat`, `api`, `keygen`.
서명 비중 측정 모드: `sign_profile`, `sign_detail`, `sign_control`.
이 모드들은 현재 원본의 서명 C 파일 4개를 빌드 디렉터리에 복사해 계측하며,
생산 소스는 수정하지 않는다. [서명 FFT 비중 결과](sign_profile/result.md) 참조.
FFT/iFFT는 측정용 `fft_probes.c`에서 수정하지 않은 실제 ASM 호출을 감싼다.
`sign_control`은 내부 계측과 이 probe 없이 실제 ASM을 직접 호출한다.
`sign_detail`은 LDL·split·merge·mul·add·sub·deepest까지 추가 분리한다.
[함수별 상세 결과와 계측 영향](sign_profile/detail_result.md)을 참고한다.
보드 실행은 N657의 고정 ST-Link serial만 사용하고 공용 잠금을 잡는다.
M4 보드는 건드리지 않는다. 보드 접근 권한과 연결이 필요하다.

실행 결과는 `results/<mode>/<UTC timestamp>/`에 저장하며 ELF와 컴파일 명령도 보존한다.
현재 실행부터 disassembly와 생산 소스 archive, 프로파일 모드의 계측 소스 archive도 보존한다.
`manifest.json`의 `valid_measurement`가 true인지와 개별 시험 완료 조건을 확인한다.
키생성 성능은 100회 평균이며 이전 upper-median 표와 혼용하지 않는다.

## 정리 전후 객체 확인

아래 객체 동일성 기록은 서명 FFT A5 반영 전 NTT 정리 당시의 검사이다.
현재 서명 FFT 변경까지 동일하다는 의미가 아니다.

```sh
# 원본은 이미 snapshots/original/Before_slothy에 복원되어 있다.
make -C Final_code/Before_slothy
python Final_code/validation/compare_objects.py
```

`build/object_audit/report.json`에 섹션 크기·SHA-256을 기록한다.
공통 NTT의 명시적 삭제를 제외한 26개 객체의 할당 코드·상수 섹션은 동일하다.
이 검사는 재배치 후 ELF 전체 동등성이나 상수시간의 형식적 증명이 아니다.

정리 전 전체 소스·문서·Makefile은 `snapshots/Before_slothy_before_ntt_cleanup.tar.gz`에 보존했다.
복구할 때 현재 소스를 바로 덮어쓰지 말고 별도 디렉터리에 풀어 비교한다.

현재 결과와 검증 한계는 [../Before_slothy/result.md](../Before_slothy/result.md)에 기록했다.
