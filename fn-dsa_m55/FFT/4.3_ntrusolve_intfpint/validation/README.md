# C Q32 규칙 보정판 검증

본체 KAT·키생성 모드의 암호 소스는 이 후보의 상위 폴더만 사용한다.
`bridge_compare`만 예외적으로 TW의 가역 namespace 비교 복사본을 함께 빌드한다.
이것은 측정 대조군이며 본체 구현이나 빌드 선택을 바꾸지 않는다.
최신 판정과 로그는 [result.md](../result.md)에 있다.

| 모드 | 검사 |
| --- | --- |
| kat | 원본 256/512/1024 각 100, NTRU 정수 방정식 |
| extra | 새 seed 300개, 원본 oracle와 비교 |
| sigkat | 원본 서명 KAT·검증·변조 거부 90개 |
| keygen_current | 전체 키생성, 크기별 100회 |
| ds | 커널·연결 구간·시간 클래스·직접 반올림 경계 |
| q32timing | 보정 함수만 3크기·3연산·8입력 종류·각 100회 |
| bridge_compare | 원본 Q32 / TW / 4.3의 FFT·iFFT, double 입출력 변환 포함 및 내부 계산 별도 비교 |

`bash validation/build.sh MODE`로 만든 뒤 공유 환경 Python으로
`validation/run_board.py MODE`를 실행한다. 보드는 순차 점유한다.
구체적인 클럭·메모리·옵션은 result.md에 기록했다.

현재 helper를 직접 검증하는 호스트 프로그램은
`host_q32_rules.c`, `host_q32_precision.c`다.
`audit_q32_elf.py MODE`는 ELF의 새 helper 분기와 FP32 명령을 보고한다.
이전 나눗셈/fixture 진단은 보정 전 규칙을 설명하는 자료이며 현재 구현의 증명이 아니다.
특히 현재 나눗셈은 원본 raw-zero 분모 동작을 따르고 새로 거부하지 않는다.

KAT 통과, 유한한 산술 표본, 조건 분기 검사, 몇 가지 입력의 시간 검사는
모든 입력의 동등성이나 전체 상수시간 증명이 아니다.

변환 포함 비교는 [bridge_conversion_result.md](../bridge_conversion_result.md)에 있다.
`prepare_bridge_control.py`로 비교 소스를 준비하고 `--check`로 원본과의
가역 변환(namespace·공유 workspace 배치만 변경)을 검사한다.
산술 코드는 수정하지 않는다. `summarize_bridge_compare.py RUN1 RUN2 --out OUT`
는 검증된 같은 ELF·공유 workspace 실행만 집계한다.
