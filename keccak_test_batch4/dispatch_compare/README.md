# 단일/x4 선택 정책 실험

완료된 전체 측정·정확성 검사는 [result.md](result.md), 원시 수치와 조건은
[measurements.md](measurements.md)에 정리한다.

| 폴더 | 역할 |
|---|---|
| `ref_prefix` | 이전 prefix-only 기준: 처음 일정량 x4, 부족한 나머지는 원래 단일 SHAKE |
| `A_four_only` | 활성 상태 4개일 때만 x4 |
| `B_three_plus` | 활성 상태 3개 이상이면 x4 |
| `C_two_plus` | 활성 상태 2개 이상이면 x4 |
| `validation` | 실제 N657의 동일 입력 paired 측정·상태 전환·서명 검증 |

각 후보는 독립적인 C/H/ASM 전체 소스를 갖는다. 생산 정책은 해당 폴더
`shake_independent4.c`에 직접 작성되어 있으며 다른 후보 코드의 include/링크,
정책 선택용 빌드 옵션은 없다. 일반 Makefile은 자기 폴더만 빌드한다.

기존 `keccak_test_batch4` 루트의 전체-x4 실험 및
`Final_code/Before_slothy`는 교체하지 않았다.
`prepare_copies.py`는 최초 복사를 위한 보존 스크립트이며 기존 폴더가 있으면
덮어쓰지 않고 중단한다. 다시 실행할 필요가 없다.

재현:

```sh
bash validation/build.sh C_two_plus keygen control
python3 validation/run.py C_two_plus keygen control
```

서명·검증은 `sign`, 호출 경로 검사는 `profile`을 사용한다.
측정 파일의 `CANDIDATE`는 독립 소스 트리 선택만 담당한다.
측정용 namespace 및 고정 text 슬롯은 비교 펌웨어에만 존재한다.
슬롯 밖 암호 함수·상수 주소는 `audit_layout.py`로 검사하며,
남아 있는 비암호 SDK/libc 주소 차이도 숨기지 않고 `layout_audit.json`에 남긴다.

`analyze.py`는 각 후보의 최신 유효 pinned 실행을 읽어
`measurements.md` 및 `summary.json`을 생성한다. 이전 unpinned 실행도 로그를
보존하지만 최종 성능 표와 섞지 않는다. 반복 실행은 같은 입력을 사용하므로
검사 건수를 합쳐서 고유 표본 수로 간주하지 않는다.
