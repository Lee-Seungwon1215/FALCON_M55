# B_three_plus

활성 상태 3개 이상이면 MVE x4, 그보다 적으면 상태별 기존 단일 Keccak을 호출한다.
구현은 이 폴더의 shake_independent4.c에 직접 작성했다. 다른 후보 include/링크,
정책 선택용 빌드 옵션은 없다. 이 폴더의 Makefile로 독립 라이브러리를 빌드한다.

단일 전환 시 기존 CM4 ABI와 canonical x4 배치 사이의 상태 변환 및 임시 상태
삭제 비용까지 측정한다. 키생성/서명/검증의 수학 및 요청별 난수열은 유지한다.
다른 계산 파일은 전체-x4 실험 코드의 독립 복사본이며, 관련 헤더·설명도
현재 선택 정책에 맞게 정리했다. 단일 API는 기존 단일 SHAKE 경로를 유지한다.

기준: ../ref_prefix (기존 prefix-only). 검사와 결과는 ../validation 및 ../result.md.
실물 N657 control/profile, 원본 출력 일치·스트림·서명 검증 검사 완료.
최종 코드에 채택하지 않았다. 전체 비교는 [result.md](../result.md)를 참고한다.
