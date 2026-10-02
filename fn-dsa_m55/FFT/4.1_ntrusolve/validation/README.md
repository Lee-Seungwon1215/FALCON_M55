# 로컬 소스 검증·측정

모든 candidate 모드는 상위 디렉터리의 실제 소스를 빌드한다. 기존 NTT ASM은
계속 켜며 컴파일러 15.2.1, -O3, -mfpu=fpv5-d16, -ffp-contract=off,
-fno-fast-math를 공통 적용한다. NUCLEO-N657X0-Q, 800 MHz, cache OFF,
코드 ITCM / 데이터·상수·스택 DTCM 각 256 KiB. 하드웨어 실행은 반드시 순차다.

```sh
sh fn-dsa_m55/FFT/4.1_ntrusolve/validation/build.sh kernels
fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/FFT/4.1_ntrusolve/validation/run_board.py kernels
```

- `kernels`: 원본 함수 본문을 이름만 변경한 `ref_fxp.c`와 동일 ELF 비교.
  backend 0=원본, 1=현재 공개 함수(또는 invnorm 직접 구현), 2=MVE 후보.
  op 0=FFT, 1=iFFT, 2=invnorm. 변환을 포함하고 입력 복사·검사는 제외.
  동일 입력 스트림, 10 warmup +100 calls/크기·방향·backend, IRQ OFF.
  8개 입력군 ×100회의 시간 검사도 수행한다. 차이 계수·Q32 LSB 최대 오차를
  함께 기록한다. 중간값 차이는 곧 KAT 실패를 뜻하지 않는다.
- `kat`: 원본 KAT를 변경하지 않은 256/512/1024 각100, 정확한 NTRU 방정식 검사.
- `breakdown`: 정상 구현을 변경하지 않는 진단 전용. 현재 MVE C 소스를 테스트
  translation unit에 이름만 바꾸어 포함하고 입력 Q32→DS / 계산 / 출력 DS→Q32를
  분리 계측한다. 같은 ELF의 정상 함수·무계측 대조본과 출력 및 시간 차이를 확인한다.
  정상 최적화 구현을 대체하는 기능이 아니며, 결과는 `../fft_slowdown_diagnosis.md`에 있다.
- `sigkat`: 4..1024의 서명 KAT·검증·변조 거부 90개.
- `keygen_current`, `keygen_ntt`, `keygen_ref`: 각각 현재/ntt_opt/M55_ref를
  같은 프로그램으로 측정. 원본 KAT seed test0..99, 크기별100개, warmup3.
  64-bit SysTick의 확장을 위해 IRQ ON. 모든 재시도·키 인코딩 포함.
- `keylayout_current`, `keylayout_ntt`, `keylayout_ref`: 위와 같은 비교에
  공통 정수 루틴 8개 주소만 일치시키는 **진단용 배치 통제**를 추가한다.
  이것은 최적화 구현을 빌드 설정으로 대체하거나 채택하는 기능이 아니다.
- `kat_invnorm`: 최초 invnorm-only 소스 단계의 역사적 실행 이름. 지금 재빌드하면
  현재 소스로 실행되므로 당시 단계 결과는 저장된 manifest/hash로 구분한다.

`run_board.py`는 보드 잠금, ELF 신선도·컴파일 옵션, 소스 SHA-256 전후 동일성,
KAT 완료 표식, fault/ECC/TCM 상태를 검사하고 raw.log와 manifest.json을 남긴다.
소스는 보드 실행 도중 수정하지 않는다. 두 기준 소스는 비교군으로만 직접 빌드하며
최적화 candidate 펌웨어에는 기준 구현을 링크하지 않는다(커널 비교용 oracle 제외).

초기 커널 로그(045346Z 이전 포함)는 구현 중간 단계이며 backend마다 입력 RNG를
이어 사용했다. 최종 커널 프로그램은 각 backend에서 RNG를 같은 값으로 초기화한다.
최종 성능 판정에는 이 수정 이후 로그만 사용한다.

초기 스칼라 경계 변환은 느리고 입력별 시간 차이도 있어 폐기했다. invnorm도
native 제곱합 버전의 드문 1 LSB 차이를 확인하여 원본 Q32 제곱합으로 고쳤다.
`test_host_invnorm.c`는 0 입력을 포함한 1,023,000개 출력 계수 비교용이다.

결과·메모리·시간 검사는 유한한 실험이다. 형식적 CT 증명 또는 전력/EM 검증은 아니다.
