# C 직접 입출력 host 검사

실행: Apple clang, -O2 -ffp-contract=off -fno-fast-math,
-fsanitize=undefined,float-cast-overflow. 대상은 실제 C adapter 코드를
추출한 validation/host_adapters.c이며, MVE 어셈블리는 별도 보드에서 검사합니다.

```text
C_HOST_ADAPTER input_count=1846200 differences=0 round_count=589968 differences=0 invalid_rejected=5/5
```

일반 bounded solver 입력, len=0, 양/음수, sc=0/31/62 경계와
음수 부호 확장을 포함합니다. 입력값의 실수 정확도는 원본 Q32 생성값과
비교합니다. 반올림은 signed half ± 2^-34 주변을 검사합니다.
모든 입력의 일반 동등성 증명은 아닙니다.
