# 본체 안전 검사 수정 및 M55 KAT 재검사

> 이 기록 이후 같은 수정 본체로 성능·연산비중도 재측정했다. 최신 측정은
> [performance_profile_result.md](performance_profile_result.md). 성능 및 입력
> 의존 시간 문제는 재측정에서도 남아 있었다. 아래는 guard/KAT 검증 시점의 기록이다.

2026-09-23. **`q32_trial` 본체 반영과 M55 재검사 완료.** 진단용 사본에서만
검증했던 누산 안전 상한을 실제 [kgen_inner.h](q32_trial/kgen_inner.h:877)의
`fp64_k_update_ok()`에 직접 적용했다. 아래 검사 범위에서 원본과 모두 일치한다.
성능·상수시간 문제까지 해결했다는 뜻은 아니며, 통합 연구 ref는 교체하지 않았다.

## 변경 내용

| 항목 | 이전 | 이번 본체 |
|---|---|---|
| 작은 크기 정수 갱신의 안전 검사 | 모든 계수에 `abs(k[i]) <= INT32_MAX >> logn` | `sum(abs(k[i])) <= 2^32-2` |
| 적용 크기 | logn=1..3 | 동일 |
| FP→정수 변환 유효성 검사 | 유지 | 유지 |
| FFT 저장 형식 | 실수부·허수부 각각 double 하나 | 동일 |

계수마다 일률적인 제한을 걸면서 안전한 k까지 거부했던 부분을 수정했다.
검사를 없애거나 특정 seed를 예외 처리한 것이 아니다. 원본 KAT 기대값과
FFT 산술·보정 함수는 변경하지 않았다. 이전 진단 시점과 비교한 암호 소스
변경은 **`q32_trial/kgen_inner.h` 한 파일뿐**이다.

안전 상한의 전제는 기존 작은 크기 `poly_sub_scaled()`의 31-bit limbs와
초기 carry=0이다. B=2^31, S=Σ|k[i]|라 할 때 `|carry| <= S+1`이 유지되고,
모든 부분 누산합은 `|z| <= B(S+1)`이다. 따라서 `S <= 2^32-2`이면
`|z| <= 2^63-2^31 < 2^63`으로 int64 범위를 넘지 않는다. 절댓값은 unsigned로
구해 `INT32_MIN`에서도 overflow가 없다. 더 큰 크기의 기존 경로는 그대로다.

본체 헤더 SHA-256:
`85aeb8782d289695d39cfff873339892d4b8c60909e8b05f1b18e0a4002e49e4`

수정 전 헤더는 [복원용 tar.gz](build/q32_trial-before-l1-guard-20260923.tar.gz)에
보존했다. 현재 `reference/`와 나머지 암호 소스가 이전 기록과 같은지도 검사했다.

## 재검사 결과

| 검사 | 범위 | 결과 |
|---|---|---|
| M55 키생성 원본 KAT | 256/512/1024, 각 100개 | **300/300 일치**, NTRU 식·계수 범위 PASS |
| M55 키+서명 원본 KAT | logn=2..10, 각 10개 | **90/90 일치** |
| 이전 불일치 seed의 M55 전체 키생성 | 512: 1198, 7470 / 1024: 1691, 4395, 10491 | **5/5 원본 키 digest 일치** |
| M55 정상 서명 검증·변조 거부 | 서명 KAT 90개 + 위 5개 | **95/95 PASS** |
| M55와 호스트 키생성 KAT 실제 digest 비교 | 같은 300개 입력 | **300/300 일치** |
| 호스트 원본 KAT·서명·검증/self test | 실제 수정된 본체 빌드 | **PASS** |
| 호스트 추가 결정적 키 비교 | 512/1024 각 10,000개 | **20,000/20,000 원본과 일치**, NTRU 식·범위 PASS |
| 본체 guard 경계값·무작위 검사 | Python 정수 oracle 및 진단 guard와 대조 | **30,845/30,845 PASS** |

추가 seed는 `fp64-audit-20260923-<index>`, index=1000..10999이다.
20,000개 추가 키 비교는 **호스트 검사**이며, 보드에서 20,000개를 실행했다고
주장하지 않는다. 5개 회귀시험도 임의 입력 전체의 동등성을 증명하지 않는다.

보드 펌웨어는 `q32_trial`의 실제 소스를 직접 빌드했다. 진단용으로 생성한
암호 번역 단위나 별도 guard 대체 구현을 링크하지 않았다. 호스트·보드의 소스
hash와 ELF·로그 hash, 300개 실제 digest를 결과 수집기에서 대조했다.
보드 3회 실행 모두 환경 검증을 통과했고 CFSR/HFSR/AFSR는 0이었다.

## M55 환경

- NUCLEO-N657X0-Q, serial `003C00223335510735383531`, CPU 800 MHz, cache OFF.
- ITCM 코드 / DTCM 데이터·상수·스택, 각각 256 KiB 설정.
- GCC 15.2.1, `-O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math`.
- 기존 M4 정수 ASM과 M55 MVE NTT 경로 활성화.
- 전체 암호 소스를 포함하는 KAT·서명 KAT·회귀시험 펌웨어 3개를 각각 빌드·실행.

## 로그

- [최종 수집 결과 및 hash](results/guard-integration-summary/20260923T095651Z/summary.json)
- [M55 키생성 KAT](results/q32_trial-kat/20260923T095214Z/raw.log), [실행 메타데이터](results/q32_trial-kat/20260923T095214Z/run.json)
- [M55 서명 KAT](results/q32_trial-sigkat/20260923T095613Z/raw.log), [실행 메타데이터](results/q32_trial-sigkat/20260923T095613Z/run.json)
- [M55 이전 불일치 5개 회귀시험](results/q32_trial-guard_repro/20260923T095133Z/raw.log), [실행 메타데이터](results/q32_trial-guard_repro/20260923T095133Z/run.json)
- [호스트 결과](results/guard-integrated-host/20260923T095033Z/summary.json), [KAT 로그](results/guard-integrated-host/20260923T095033Z/kat.log), [20,000개 키 로그](results/guard-integrated-host/20260923T095033Z/extended.log)

## 남은 문제와 판정 범위

**해결:** 알려진 5개 실제 키 불일치의 직접 원인인 과도한 guard 거부를
본체에서 수정했고, 위 전체 KAT·회귀시험을 다시 통과했다.

**미해결:** 단일-double 산술 전체의 중간값 bit-exact 동등성은 성립하지 않으며,
이전 곱셈 경계값 반례는 그대로다. 임의의 모든 seed에서 같은 키를 만드는지도
증명하지 않았다. `fp64q_floor`의 입력 의존 분기와 기존 FFT 보정 비용은 이번
guard 수정 대상이 아니었다. 성능·상수시간을 이번 본체로 다시 측정하지 않았고,
이전 실패가 해결됐다고 판단하지 않는다. 따라서 연구용 후보의 guard 수정만
검증한 것이며 전체 FP64 최적화나 배포 보안성을 승인한 것은 아니다.
