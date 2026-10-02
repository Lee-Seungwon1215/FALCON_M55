# K1 full-iGM 통합 결과

측정일: 2026-09-16. 대상은 NTRU-solver의 RNS `mp_iNTT()`다.

## 구현

- M55 전용 `mp_mkgmigm()`/`mp_mkigm()`이 inverse root를 `wR/2`가 아닌 `wR`로 생성한다.
- `kgen_mp31_cm55.s`의 각 root 사용 지점에서 modular doubling을 제거했다.
- H1의 unscaled GS와 마지막 `1/n` scaling은 유지했다.
- `fndsa_mp_iNTT_c()`는 같은 full-root 계약의 독립 C oracle이자 `logn<4` fallback이다.
- `FNDSA_MVE_MP31=0`인 일반 C/M4 및 AVX2 경로는 기존 half-root 계약을 유지한다.
- 새 배열, 함수 포인터 선택, 외부 링크, 빌드 옵션 기반 후보 선택은 추가하지 않았다.

## 빌드·측정 조건

| 항목 | 조건 |
|---|---|
| 보드 | NUCLEO-N657X0-Q, STM32N657, Cortex-M55 r1p1 |
| 클럭 | CPU/SYSCLK/HCLK = 800/400/200 MHz |
| 메모리 | 코드 ITCM, 상수·데이터·스택 DTCM, 각 256 KiB |
| 캐시/ECC | I/D cache OFF, TCM ECC ON |
| 컴파일러 | GNU Arm GCC 15.2.1, 최종 `-O3`, MVE MP31 ON |
| 전체 API | 크기·연산별 10 batch × 10 call = 100회, batch당 warm-up 10회 |
| 집계 | 10개 batch 평균의 upper median |

## 성능

K0는 이 폴더의 K1 적용 직전 D1/half-iGM이다. 양수는 개선이다.

| 크기 | 연산 | K0 cycles | K1 cycles | 개선율 |
|---|---|---:|---:|---:|
| 512 | 키생성 | 46,489,021 | 46,445,322 | +0.093999% |
| 512 | 서명 | 17,369,508 | 17,197,790 | +0.988618% |
| 512 | 검증 | 323,070 | 323,130 | −0.018572% |
| 1024 | 키생성 | 243,716,892 | 243,618,714 | +0.040284% |
| 1024 | 서명 | 37,222,531 | 36,841,898 | +1.022588% |
| 1024 | 검증 | 624,961 | 625,070 | −0.017441% |

검증은 이 RNS iNTT를 호출하지 않으므로 −0.02% 수준의 차이는 최적화 효과로 해석하지 않는다.
K0/K1 전체 펌웨어는 코드 크기가 달라 뒤쪽 함수 주소가 완전히 고정된 대조군은 아니다.
따라서 전체 API의 약 0.04~1.02% 차이에는 배치 영향이 섞일 수 있다. 반면 함수 단독
AB/BA 실험은 같은 ELF와 같은 데이터 주소에서 순서를 교환했으며 두 배치 결과가 일치했다.
함수 단독 K0→K1 결과는 logn 4..10에서 **8.57~12.46%** 개선됐고,
대표 크기는 512에서 19,257.11→17,043.11 cycles, 1024에서
41,655.11→36,465.11 cycles다. `fndsa_mp_iNTT`는 1,770→1,562 B로 208 B 줄었다.

## 검증

| 검사 | 결과 | 범위 |
|---|---|---|
| RNS NTT/iNTT 오차 | PASS | 308개 소수 × logn 4..10 = 2,156세트; forward/inverse/round-trip mismatch 0, modular error 0 |
| Montgomery 경계값 | PASS | 18,923,520 lane case; mismatch 0, range error 0 |
| q=12289 회귀 | PASS | 512/1024 forward·round-trip·oracle error 0 |
| 결정적 KAT/digest | PASS | 512 `9fd7…eadd`, 1024 `c543…18bb`; K0와 동일, host expected digest 일치 |
| 서명·검증 | PASS | 정상 서명 검증 성공, signature 변조 거부 |
| 보드 오류 | PASS | exit 0, CFSR/HFSR/AFSR 0, ECC 설정 유지 |
| 정적 상수시간 회귀 | PASS | K0/K1 iNTT 분기 및 load/store 명령 종류·개수·순서 동일; 새 data-dependent 분기·주소 없음 |

상수시간 판정은 변경 커널의 정적 구조 회귀다. 형식 증명, dudect, TVLA, 전력/EM
누설 측정이나 FN-DSA 전체의 상수시간 증명을 뜻하지 않는다. 결정적 digest 역시 이 프로젝트의
고정 입력 KAT이며 FIPS 인증이나 외부 표준 KAT 전체를 뜻하지 않는다.

## 메모리와 식별자

- perf 코드: K0 110,244 B → K1 109,292 B, **952 B 감소**.
- perf 데이터/스택: 225,728 B로 동일.
- K1 perf ELF SHA-256: `10e732b8262a10c127862669942947faee4ddf2e07f58ff78ba7ecd42447704e`
- K1 audit ELF SHA-256: `559fea8dd5ae7f13729d8d0f9a8fe5e64d7989731e931fdf67d2dc8e1b5a5909`
- `kgen_mp31_cm55.s`: `96fb447cb61dff799744f2ff0ee92bac3dadaf47f63ead14684380b2c824f2b2`
- `kgen_mp31.c`: `c41e661b6cf9d6a1ac5f71cb007f37eab9667efcde928b7f76ea01155bcaedbc`

## 로그

- [감사 raw.log](profiling/results/d1-k1_full_igm_audit_v2-audit/runs/pilot-20260916T074406Z/raw.log)
- [감사 run.json](profiling/results/d1-k1_full_igm_audit_v2-audit/runs/pilot-20260916T074406Z/run.json)
- [성능 raw.log](profiling/results/d1-k1_full_igm_perf-perf/runs/full-20260916T074512Z/raw.log)
- [성능 run.json](profiling/results/d1-k1_full_igm_perf-perf/runs/full-20260916T074512Z/run.json)
- [정적 상수시간 회귀](profiling/results/k1_static_ct.json)
- [함수 단독 비교](../../function_compare/ntt/result.md)

실패한 첫 audit는 기존 half-root C oracle과 K1 assembly를 잘못 비교해
`inverse_mismatches`를 발생시켰고 통계에서 제외했다. round-trip은 0이었지만 결과를 채택하지 않았으며,
full-root C oracle로 수정한 `audit_v2`만 위 판정에 사용했다.
