# K3-B interleaved root/twist experiment

이 경로는 채택된 K2 `ntt_ntrusolve/ref_preslothy`를 보존한 독립 실험 후보다.
`mp_mkgm()`, `mp_mkigm()`, `mp_mkgmigm()`이 각 root와
`low32(root*p0i)`를 `{root, twist}` 순서로 interleave한 두 개의 표에 저장한다.
`mp_NTT()`/`mp_iNTT()`는 scalar root에서 `LDRD`, 연속 네 쌍에서 MVE
`VLD20.32/VLD21.32`, 간격이 있는 공개 root index에서 gather load를 사용한다.

구현은 이 폴더의 `kgen_mp31.c`와 `kgen_mp31_cm55.s`에 직접 들어 있다.
다른 후보를 링크하거나 빌드 옵션으로 선택하지 않는다. 빌드 조건은 K2와 같은
NUCLEO-N657X0-Q 800/400/200 MHz, ITCM 코드, DTCM 데이터·스택,
I/D cache OFF, ECC ON, GCC 15.2.1 `-O3`이다.

## 결론과 제약

- 정확성·KAT·서명 검증·변조 거부·정적 상수시간 회귀는 통과했다.
- K2보다 NTT/iNTT와 전체 키생성이 느려 **기각**한다.
- 두 개의 2048-word 표 때문에 BSS가 정확히 16,384 B 증가한다.
- 표가 process-global mutable state이므로 이 실험 구현은 재진입 가능하지 않다.
- 정적 검사는 형식 증명이나 dudect/TVLA·전력/EM 누출검사가 아니다.
- 통합 기준본은 계속 `ntt_ntrusolve/ref_preslothy`의 K2다.

상세 수치와 로그 경로는 [result.md](result.md)에 있다.
