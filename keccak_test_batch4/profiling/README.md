# batch4 적용 전/후 Keccak·SHAKE 비중

생산 코드는 수정하지 않고 계측용 복사본만 생성한다. `control`은 내부 probe가
없는 실행, `profile`은 함수 경계에 ABI 보존 ASM probe를 붙인 실행이다.
각 이미지에서 같은 입력으로 원본 4회 호출과 batch4를 교대로 실행한다.
암호 코드와 비교군 및 계측 버퍼를 모두 한 이미지에 넣으면 TCM 용량을 넘으므로
키생성과 서명은 별도 펌웨어로 측정한다. 보드의 TCM 설정은 변경하지 않는다.
원본 서명 비교군은 기존 validation/reference의 이름만 바꾼 Before_slothy이며,
키생성 비교군도 Before_slothy의 공개 이름만 바꾼 복사본이다.

- 512/1024 각각 키생성 10배치(40키), 서명 25배치(100서명), 별도 warm-up 1배치.
- 키생성 prefix 64블록/요청, 서명 112블록/요청.
- N657 800 MHz, cache OFF, 기존 ITCM 코드/DTCM 상수·데이터 배치, ECC ON.
- 키생성·서명 모두 IRQ ON, 64-bit SoC cycle counter. 이전 서명 DWT/IRQ OFF
  측정과 raw cycle 수치를 직접 섞지 않는다.
- 생성한 모든 키와 서명을 원본과 byte-exact 대조. 서명 검증과 변조 거부는 계측 밖.
- 함수 자체 시간(exclusive) 합계를 사용하므로 SHAKE 내부 Keccak을 중복 합산하지 않는다.
- 단일 Keccak에는 bit_split/merge와 상태 입출력도 포함한다.
- 배치 준비/관리: prepare, absorb, export_lane, block, sampler_extract, 내부 clear의
  하위 계측 호출을 제외한 시간. x4 출력 저장은 별도 카테고리다.
- **인라인 u8/u16/u64 읽기, Gaussian 내부의 짧은 prefix 읽기, API 분기·루프는
  강제 함수화하지 않는다. 이 비용은 `other`에 남는다.** 따라서 전체 버퍼 비용을
  완전히 분리했다고 주장하지 않는다. 계측 대상 경계는 과거 SHA3 프로파일과 같다.
- 빈 wrapper 보정을 적용하되 정확한 비침습 시간 분해가 아닌 추정치다. raw,
  보정값, control 대비 오차, 함수 호출 횟수를 함께 보존한다.
- x4 호출 수는 네 상태를 계산한 횟수이며 네 배 하면 state-permutation 수다.
  이는 유효 소비 바이트 비율과 같지 않다. 미사용 선생성도 계산에 포함된다.

```sh
bash keccak_test_batch4/profiling/build.sh keygen control
bash keccak_test_batch4/profiling/build.sh keygen profile
bash keccak_test_batch4/profiling/build.sh sign control
bash keccak_test_batch4/profiling/build.sh sign profile
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python keccak_test_batch4/profiling/run.py keygen control
python keccak_test_batch4/profiling/run.py keygen profile
python keccak_test_batch4/profiling/run.py sign control
python keccak_test_batch4/profiling/run.py sign profile
python keccak_test_batch4/profiling/analyze.py
```

runner는 기존 공유 보드 잠금과 고정 N657 serial을 사용한다. RAM ELF만 적재한다.
STM32N6 SDK가 자동 생성하는 불필요한 512-MiB flat BIN만 build.sh에서 제거하며,
ELF/map/log/source hash는 보존한다. 계측은 전체 보안/상수시간 검증을 대신하지 않는다.
