# B: Q32 → 연속2×FP32 → Q32 NTRU 근사 계산

**실험 후보이며 채택 불가:** 원본 키생성 KAT가294/300이다.
현재 측정값과 정확성 제한은 [result.md](result.md)에 정리한다.
C 구현을 복사한 것이 아니라, 이 폴더에 사용자가 넣은 ntt_opt 복사본에서
독립적으로 작성했다. 다른 후보의 소스를 include·링크하지 않는다.

## 적용 범위

| 구간 | 처리 |
| --- | --- |
| intermediate, logn>=4 | 원본 poly_big_to_fixed → Q32입력1회 변환 → 연속DS FFT·역수·점별곱·iFFT → Q32출력1회 변환 → 원본 fxr_round |
| depth0, logn>=4 | 원본 정수→Q32 → 분자·분모 DS FFT·나눗셈·iFFT → Q32 → 원본 정수반올림·RNS |
| logn<4 | 원본 고정소수점 유지, 공개 크기로 선택 |
| 키 후보 검사 | FFT/iFFT 원본 유지; e=0 invnorm만 공통 FP64나눗셈 개선 |
| NTT·CRT·Bezout·정수갱신·서명·검증 | 원본 ntt_opt 유지 |

실수값 하나는 hi+lo float 두 개이며, 복소수는 실수부2개+허수부2개로
총4개 float다. NTRU 근사 구간에 double 배열은 없다.
함수 사이마다 Q32 배열로 돌아가지 않고, 역수 배열도 반복 사이에 DS로 보관한다.

## 소스

- kgen_ntru.c: DS작업 배열 소유권 및 구간 연결.
- kgen_ds.h: 내부 표현·함수 선언.
- kgen_fft_mve.c: 로컬 상수표, Q32경계 변환, FFT반복 제어, DS주변 산술.
- kgen_fft_cm55.s: MVE FP32 butterfly 직접 어셈블리.
- kgen_fxp.c: 공통 invnorm 개선만 반영. 공개 FFT/iFFT는 원본.

FFT기반은 이전4.1의 검증된 DS butterfly·상수표를 이 폴더로 독립 이식했다.
C 후보의 코드를 공유하지 않는다. 점별곱·역수·나눗셈은 현재 스칼라 DS
FMA 잔차 산술이며, 모든 주변 연산까지 MVE어셈블리화했다고 주장하지 않는다.
반면 FFT/iFFT butterfly는 MVE어셈블리를 실제 호출한다.

기존 rt1/k/t2 중첩 공간을 덮어쓰지 않도록8KiB 정렬 작업 배열2개를
호출자 스택에 둔다. 전역 scratch가 없어 재진입 가능하고, 외부 temp버퍼
크기 요구사항은 바꾸지 않았다. 전체 최악 스택 사용의 형식적 증명은 아니다.

## 정확성과 예외 처리

연속DS는 원본 Q32의 곱셈 절삭·제곱합·나눗셈 반올림·modulo2^64 wrap을
그대로 재현하지 않는다. 일부 KAT 통과나 작은 중간 오차를 전체 동등성으로
해석하지 않는다. 실제 입력 fixture에서 해당 수치 의미 차이를 확인했지만,
현재 실패6건 전부의 최초 반복을 각각 새로 추적하여 확정한 것은 아니다.

출력 변환에서는 TwoSum 잔차로 반정수 경계의1LSB 오류를 수정했다.
NaN·Inf·표현 범위 밖 출력 및 비정상 분모는 전체계수 검사 후 실패 상태를
반환하며, solver는 SOLVE_ERR_REDUCE로 처리한다.
원본 재실행 fallback이나 seed별 예외 처리로 KAT를 숨기지 않는다.
이 예외 실패·전체 키생성 재시도까지 포함한 상수시간을 주장하지 않는다.

## 새 측정과 기존 기록

새 검증은 validation/에서만 실행한다.
[측정 방법](validation/README.md), [결과](result.md)를 참조한다.
기존 build/·profiling/ 및 복사된 프로파일 문서는 이전 ntt_opt 기록이다.
원래 README/result 내용은 validation/legacy/에 그대로 보존했다.
기존 ntt_opt, M55_ref, C 후보에는 파일을 수정하지 않았다.
