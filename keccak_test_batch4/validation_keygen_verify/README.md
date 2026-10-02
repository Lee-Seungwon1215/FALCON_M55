# 독립 키생성·검증 4건 배치 검사

이 폴더는 `keccak_test_batch4` **자체의 소스**를 빌드한다.
hybrid 쪽에서 검증한 키생성/검증 구현을 소스 파일로 직접 이식했으며,
빌드 옵션이나 외부 후보 라이브러리로 backend를 선택하지 않는다.
키생성·검증의 원본 비교군만 `Before_slothy`에서 외부 함수 이름을 바꾸어
테스트 이미지에 넣는다. 나머지 산술 코드는 같은 이미지에서 공유한다.

```sh
bash keccak_test_batch4/validation_keygen_verify/build.sh
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python keccak_test_batch4/validation_keygen_verify/run.py
python keccak_test_batch4/validation_keygen_verify/analyze.py
```

서명 회귀·성능 및 서명 배치→검증 배치 연결 검사는 별도 이미지에서 실행한다:

```sh
bash keccak_test_batch4/validation/build.sh
python keccak_test_batch4/validation/run.py
python keccak_test_batch4/validation/analyze.py
python keccak_test_batch4/validation/audit_sources.py
```

두 보드 실행은 같은 ST-Link와 board lock을 사용하므로 동시에 실행하지 않는다.
RAM에 ELF를 적재하며 Flash는 쓰거나 지우지 않는다. ITCM 코드/DTCM 상수·데이터,
800 MHz, cache OFF, ECC ON 등 기존 pinned 설정을 사용한다.

키생성·검증은 interrupt ON 64-bit timer, 서명은 interrupt OFF DWT timer다.
각 이미지 안의 원본/배치 조건은 같지만 세 연산의 raw cycles를 서로 섞어 집계하지 않는다.
SHAKE 난수 바이트를 서로 다른 요청에 섞지 않으며, 한 건 API를 x4로 바꾸지 않는다.

원본 키/서명 fixture는 portable `fn-dsa_ref`에서 만든다. 원본 소스를 바꾸면
`build/fixtures/expected.h`도 다시 생성해야 한다. `result.md`에는 고유 입력 수와
반복 포함 검사 수를 구별해 적는다. 테스트 키는 실제 사용하지 않는다.

`results`에는 ELF, map, 소스 hash/archive, disassembly, fixture, raw log 및 manifest가
보존된다. 작업 전 파일은 `baseline/before_keygen_verify.tar.gz`에 보존했다.
