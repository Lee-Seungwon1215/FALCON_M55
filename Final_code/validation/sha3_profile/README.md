# SHAKE / Keccak 함수별 계측

결과: [result.md](result.md), 기계 판독 데이터: [data.json](data.json).

`Final_code/Before_slothy`의 생산 소스는 수정하지 않는다. `generate.py`가
SHA3 두 파일의 계측용 복사본과 ABI 보존 wrapper를 build 디렉터리에 만든다.
control은 생산 소스를 그대로, coarse는 상위 함수만, detail은 private
bit_split/merge 진입점까지 계측한다. 빌드 옵션은 계측 모드만 선택하며
암호 알고리즘 후보나 다른 폴더의 구현을 선택하지 않는다.

`build.sh`, `run.py`, `analyze.py`의 실행 순서는 result.md에 있다.
runner는 기존 공유 보드 잠금과 고정 N657 serial을 사용한다. 같은 보드의
다른 측정과 동시에 실행하지 않는다.

비율은 하위 함수와 중복되지 않는 자체 시간이다. 빈 wrapper 보정 추정과
보정 전 측정치를 구분한다. 원본/계측 소스, ELF, 역어셈블리, 로그 및
컴파일 명령은 각 results 실행 디렉터리에 보존한다.

현재 workload는 512/1024 각각 키생성 10회, 서명/검증 100회이며 결정적
입력을 사용한다. 별도의 전체 KAT 및 상수시간 증명 작업은 이번 범위가 아니다.
