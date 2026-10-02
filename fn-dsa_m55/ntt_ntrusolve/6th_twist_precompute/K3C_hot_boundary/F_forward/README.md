# K3-C F-only

K2에서 NTT 마지막 두 layer의 root/twist load만 packed table 방식으로 바꾼
독립 후보다. `kgen_mp31.c`와 `kgen_mp31_cm55.s`에 직접 구현되어 있다.

- 정확성·오차·KAT·서명검증·변조 거부·정적 상수시간 회귀: PASS
- NTT 커널: K2 대비 2.32~3.28% 개선
- 전체 키생성: 512는 0.494%, 1024는 0.305% 느림
- BSS: K2 대비 12,192 B 증가
- 판정: 기각

전체 비교와 로그는 [../result.md](../result.md)에 있다.
