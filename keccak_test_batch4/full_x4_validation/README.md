# 전체 SHAKE x4 경로 검사

현재 `keccak_test_batch4`의 실제 소스를 복사해 측정한다. 암호 코드는 다른
후보를 링크하거나 빌드 옵션으로 선택하지 않는다. 비교군만 기존
`Final_code/Before_slothy`의 이름을 바꾼 시험용 소스다.

- 키생성: 후보 생성의 연속 SHAKE와 최종 공개키 해시 모두 x4.
- 서명: mu, f||g 해시, seed 유도, nonce/샘플러의 추가 출력, Hash-to-Point,
  counter 재시도 모두 x4. 기존 단일 API는 원래 단일 SHAKE를 유지한다.
- 검증: 기존 batch4의 공개키 해시, mu, Hash-to-Point x4 경로 유지.
- **전체 x4 엔진 사용 ≠ 매 호출에서 네 요청 모두 유효하게 병렬 처리.**
  서명 계산 본체는 공유 scratch를 이용해 순차 실행하므로 부족분에서 일부
  lane만 유효할 수 있다. 마스크별 호출 횟수와 전체 시간을 별도로 확인한다.
- 한 lane의 미소비 바이트/상태를 다른 lane에 섞거나 버리지 않는다.
  보충 전 미소비 바이트를 앞으로 이동하며, 부분 배치는 한 블록만 보충한다.
- 재시도와 활성 lane 선택의 전체 상수시간을 증명한 구현은 아니다.

## 재현

```sh
bash keccak_test_batch4/full_x4_validation/build.sh keygen control
bash keccak_test_batch4/full_x4_validation/build.sh keygen profile
bash keccak_test_batch4/full_x4_validation/build.sh sign control
bash keccak_test_batch4/full_x4_validation/build.sh sign profile
source fn-dsa_m55/measurement_mlkem_native/env/environment.sh
python keccak_test_batch4/full_x4_validation/run.py keygen control
python keccak_test_batch4/full_x4_validation/run.py keygen profile
python keccak_test_batch4/full_x4_validation/run.py sign control
python keccak_test_batch4/full_x4_validation/run.py sign profile
python keccak_test_batch4/full_x4_validation/analyze.py
```

빌드는 순차 실행한다. STM32N6 SDK의 거대한 flat BIN은 재생성 가능한 빌드
산출물이고 사용하지 않아 스크립트가 삭제한다. ELF/map/raw log는 보존한다.
보드는 N657 serial `003C00223335510735383531`만 RAM 로딩한다. Flash/M4는 변경하지 않는다.

control은 타이밍 계측 없는 암호 코드, profile은 함수별 probe가 있는 코드다.
profile의 배치 구간에서 단일 Keccak 호출이 1회라도 있으면 실패 처리한다.
검증 배치도 별도 watch로 단일 Keccak 호출이 없는지 확인한다.

매 모드: 키생성 40입력/크기, 서명100입력/크기 + 각4건 warmup. 서명 fixture는
메모리 한도 때문에 크기별 두 키를 네 요청에 교차 사용하며 입력/seed는 독립적이다.
과거 네 키 fixture 측정과 절대 cycle을 직접 섞지 않는다. 같은 ELF의 원본 대조를 사용한다.

추가 검사: SHAKE rate 경계, 비대칭 소비량, 0/1/2/7 블록 큐, 미소비 상태 보존,
counter1..26 초기화, 혼합512/1024, 선택적 키 출력, raw/prehash/external-mu,
정상 검증 및 한 lane만 변조했을 때의 분리. 이것은 회귀/차등 검사이며
공식 전체 KAT suite나 모든 입력 동등성/상수시간 증명을 의미하지 않는다.

수정 전 prefix-only C/ASM은 `baseline/prefix_only_20261001.tar.gz`에 보존했다.
