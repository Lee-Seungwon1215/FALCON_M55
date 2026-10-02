# K2 root-preparation pipeline 통합 결과

## 결론

K2를 채택했다. `mp_NTT()`와 `mp_iNTT()`의 수학식, root 표, load/store 횟수,
분기 구조는 그대로 두고 다음 root의 load와 `root*p0i` 준비를 앞선 butterfly의
독립 연산 사이로 이동했다. 구현은 [kgen_mp31_cm55.s](kgen_mp31_cm55.s)에 직접
작성했으며 후보 선택용 링크·빌드 옵션은 추가하지 않았다.

K1과 K2는 코드 크기와 전체 ELF의 499개 심볼 주소·크기가 모두 동일하다.
따라서 아래 K1→K2 차이는 함수 배치 변화가 아니라 명령 스케줄 변화다.

## 구현 범위

- 정방향 CT2: 앞 root의 두 번째 Montgomery가 끝난 뒤 다음 root를 준비하고,
  그 사이에 앞 butterfly의 add/sub를 완료한다.
- 역방향 GS2: Montgomery 결과를 목적 레지스터로 옮기기 전에 다음 root를 준비한다.
- 같은 원리를 정방향 마지막 2-layer, 역방향 첫/마지막 layer와 작은
  `logn=4/6` 전용 경로에도 적용했다.
- 계수·root 메모리 접근 순서, Montgomery 산술, 최종 `1/n`, 외부 배열 순서는 유지했다.
- q=12289 NTT, CRT/Bezout, FFT, sampler는 변경하지 않았다.

## 독립 함수 속도: K1 → K2

NUCLEO-N657X0-Q, 800/400/200 MHz, ITCM 코드, DTCM 데이터·스택, I/D cache OFF,
ECC ON, GCC 15.2.1 `-O3` 조건이다. 308개 RNS 소수 각각에 대해 10개 배치,
배치당 100회 측정한 중앙값을 먼저 구한 뒤 동일 가중 평균했다. AB/BA 배치 결과는
모든 조건에서 동일했다. 양수는 K2 개선이다.

| logn / n | K1 NTT | K2 NTT | NTT 개선 | K1 iNTT | K2 iNTT | iNTT 개선 |
|---|---:|---:|---:|---:|---:|---:|
| 4 / 16 | 332.11 | 324.11 | 2.40884% | 352.11 | 350.11 | 0.56800% |
| 5 / 32 | 742.11 | 726.11 | 2.15601% | 751.11 | 743.11 | 1.06509% |
| 6 / 64 | 1,582.11 | 1,534.11 | 3.03392% | 1,531.11 | 1,523.11 | 0.52250% |
| 7 / 128 | 3,645.11 | 3,549.11 | 2.63367% | 3,506.11 | 3,474.11 | 0.91269% |
| 8 / 256 | 8,106.11 | 7,850.11 | 3.15811% | 7,496.11 | 7,464.11 | 0.42689% |
| 9 / 512 | 18,123.11 | 17,611.11 | 2.82512% | 17,043.11 | 16,915.11 | 0.75104% |
| 10 / 1024 | 39,776.11 | 38,496.11 | 3.21801% | 36,465.11 | 36,337.11 | 0.35102% |

현재 K2와 기존 C/M4 구현의 절대 함수 비교는
[`function_compare/ntt/result.md`](../../function_compare/ntt/result.md)에 있다.
대표적으로 `mp_NTT()`는 512/1024에서 3.2116/3.2081배,
`mp_iNTT()`는 3.8182/3.8897배다.

## 전체 FN-DSA 속도: K1 → K2

동일한 499개 심볼 배치에서 각 연산 총 100회 측정한 upper median이다.

| degree | 연산 | K1 cycles | K2 cycles | K2 개선 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 46,445,322 | 46,399,782 | 0.098051% |
| 512 | 서명 | 17,197,790 | 17,197,899 | -0.000634% |
| 512 | 검증 | 323,130 | 323,070 | 0.018568% |
| 1024 | 키생성 | 243,618,714 | 243,479,951 | 0.056959% |
| 1024 | 서명 | 36,841,898 | 36,841,897 | 0.000003% |
| 1024 | 검증 | 625,070 | 625,018 | 0.008319% |

서명은 이 RNS 커널의 직접 사용 비중이 사실상 없으므로 512의 109-cycle 차이는
K2 효과로 해석하지 않는다. 기대한 주효과는 NTRU solve가 포함된 키생성에 나타났고,
전체 API에서는 다른 큰 단계에 희석돼 약 0.06~0.10%다.

## 오차·KAT·서명검증

| 검사 | 결과 |
|---|---|
| 독립 q-NTT | 72세트, mismatch/range/canary 0 |
| 독립 RNS | 27,104세트, mismatch/range/canary 0 |
| 독립 직접 DFT 대조 | 1,548세트 PASS |
| 통합 RNS 정확성 | 308소수 × logn 4..10 = 2,156변환, forward/inverse/roundtrip mismatch 0, 최대 modular error 0 |
| Montgomery lane | 18,923,520건, mismatch/range error 0 |
| q=12289 회귀 | 512·1024 forward/roundtrip/oracle와 곱셈표 PASS |
| 고정 입력 프로젝트 KAT/digest 512 | `9fd7c627fa100863e8f684339f3eb3835fc55a24066f4dd34aea05d555d8eadd` |
| 고정 입력 프로젝트 KAT/digest 1024 | `c543754d19ef263221b2316acac8ad5c34502886750fdd5bfffd4f5487c018bb` |
| 정상 서명 검증 | PASS |
| 서명 변조 거부 | PASS |
| fault | CFSR/HFSR/AFSR = 0 |

두 digest는 K1과 bit-for-bit 동일하다. 여기서 KAT는 이 프로젝트의 고정 입력
결정적 회귀값이며 FIPS 인증 KAT라는 뜻은 아니다.

## 상수시간 회귀

정적 disassembly 대조는 PASS다.

- `mp_NTT`: 1,166 B, 312명령, branch 11개, memory 명령 49개로 K1/K2 동일.
- `mp_iNTT`: 1,562 B, 418명령, branch 15개, memory 명령 64개로 K1/K2 동일.
- 두 함수 모두 mnemonic multiset과 branch 위치·종류가 동일하다.
- iNTT의 한 stride load만 `[r11,q7]`에서 `[r11,q6]`로 바뀌었다. q6에는 같은
  공개 stride 상수를 먼저 적재하므로 계수 기반 주소가 아니다.
- 새 데이터 의존 분기·주소·테이블 lookup은 없다. 모든 loop/dispatch는 공개 `logn`과
  공개 counter에만 의존한다.

이 검사는 구조적 회귀 검사이며 형식적 상수시간 증명이나 dudect/TVLA 동적 누출
검사를 대체하지 않는다. 상세 수치는
[k2_static_ct.json](profiling/results/k2_static_ct.json)에 보존했다.

## 근거 로그

- [독립 AB raw](../../function_compare/ntt/results/ab/20260916T080905Z/raw.log)
- [독립 BA raw](../../function_compare/ntt/results/ba/20260916T081342Z/raw.log)
- [통합 audit raw](profiling/results/d1-k2_root_pipeline_audit-audit/runs/pilot-20260916T082122Z/raw.log)
- [통합 audit manifest](profiling/results/d1-k2_root_pipeline_audit-audit/runs/pilot-20260916T082122Z/run.json)
- [통합 100회 raw](profiling/results/d1-k2_root_pipeline_perf-perf/runs/full-20260916T082212Z/raw.log)
- [통합 100회 manifest](profiling/results/d1-k2_root_pipeline_perf-perf/runs/full-20260916T082212Z/run.json)

K2 perf ELF SHA-256:
`bb6189ec9b9eaff4da0f7c2bfe4e9be8935f20fcb1fbe12420373897412b8198`.
K2 audit ELF SHA-256:
`d53cd515657c17a593a8532d2d2b36ca774492b4acf2f2524c4995857d5ec1da`.
