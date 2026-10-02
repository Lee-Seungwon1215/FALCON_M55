# K3-A separate precomputed twist experiment

이 경로는 채택된 K2 `ref_preslothy`를 보존한 채 시험한 독립 후보다.
`mp_mkgm()`, `mp_mkigm()`, `mp_mkgmigm()`이 각 root의
`low32(root*p0i)`를 두 개의 별도 1024-word 표에 미리 계산하고,
`mp_NTT()`/`mp_iNTT()`가 공개 root index로 그 값을 읽는다.

구현은 이 폴더의 `kgen_mp31.c`와 `kgen_mp31_cm55.s`에 직접 들어 있다.
다른 후보를 링크하거나 빌드 옵션으로 선택하지 않는다. 빌드 조건은 K2와 같은
NUCLEO-N657X0-Q 800/400/200 MHz, ITCM 코드, DTCM 데이터·스택,
I/D cache OFF, ECC ON, GCC 15.2.1 `-O3`이다.

## 중요한 제약

- twist 표 두 개로 BSS가 정확히 8192 B 증가한다.
- 표가 process-global mutable state이므로 이 실험 구현은 재진입 가능하지 않다.
- FN-DSA의 기존 caller-owned 임시영역은 변경하거나 덮어쓰지 않는다.
- 정적 명령 흐름은 상수시간 회귀검사를 통과했지만, 형식 증명이나
  dudect/TVLA·전력/EM 누출검사는 아니다.
- 속도와 메모리 양쪽에서 K2보다 불리하므로 통합 기준본으로 채택하지 않는다.

상세 결과와 로그 경로는 [result.md](result.md)에 있다.

