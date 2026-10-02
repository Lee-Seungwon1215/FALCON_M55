# ref_slothy — RNS Slothy A 최종 통합 결과

2026-09-17 KST. 이 폴더의 실제 소스로 audit/perf 펌웨어를 새로 빌드하고
NUCLEO-N657X0-Q에서 정확성·KAT·서명검증 및 전체 API 100회 측정을 완료했다.

## 현재 구성

- 공통 q=12289 NTT/iNTT: 기존 Slothy A, 변경 없음.
- RNS NTT/iNTT: K4-C + 이번 Slothy A. `kgen_mp31_cm55.s`에 직접 구현.
- `kgen_mp31.c`와 나머지 C/H/S는 baseline과 동일.
- `ref_preslothy`, `ntt_opt`, `ntt_opt_slothy`는 이번 작업에서 변경하지 않았다.
- 최종 assembly SHA-256: `fdfa9fd82115a6b4f4014b5d43f574f39461e7c28ccf2be251eeda1b1b7b27c4`.
- 최종 파일은 [측정한 A](../5th_slothy/slothyA/kgen_mp31_cm55.s)와 byte-identical.
  새 경로 audit/perf ELF에서도 세 RNS 함수의 기계어·시작 주소가 A와 같다.

## K4-C 대비 개선

기준은 이번 실험의 baseline(q-NTT Slothy A + RNS K4-C)이다.
`ref_preslothy`와의 전체 Slothy 누적 효과 또는 M4 대비 배수가 아니다.
동일 M55·입력·컴파일러·빌드옵션·고정 함수 배치에서 비교했다.

| 대상 | n=512 | n=1024 |
|---|---:|---:|
| RNS `mp_NTT()` 커널 | 6.9364% 개선 | 7.9679% 개선 |
| RNS `mp_iNTT()` 커널 | 16.9112% 개선 | 15.8903% 개선 |
| 전체 키생성 | 0.4448% 개선 | 0.2756% 개선 |

커널 값은 후보 A의 prime[0], 방향별 10×100회 평균이다. 역순 재측정과 최종 경로
재검증도 완료했다. 전체 API 값은 아래 최종 경로 100회 측정의 산술평균이다.

| 크기 | 연산 | baseline cycles/call | 최종 ref_slothy cycles/call | 개선율 |
|---:|---|---:|---:|---:|
| 512 | 키생성 | 52,455,131.07 | 52,221,788.25 | +0.4448% |
| 512 | 서명 | 17,990,451.46 | 17,990,418.76 | +0.0002% |
| 512 | 검증 | 315,613.70 | 315,591.90 | +0.0069% |
| 1024 | 키생성 | 265,475,880.47 | 264,744,239.33 | +0.2756% |
| 1024 | 서명 | 38,641,380.65 | 38,641,358.54 | +0.0001% |
| 1024 | 검증 | 618,035.60 | 618,079.21 | -0.0071% |

서명·검증은 RNS 최적화의 적용 대상이 아니며 위 미세 차이를 그 연산의 최적화
효과로 주장하지 않는다. 양수는 사이클 감소, 음수는 증가다.

## A를 선택한 이유

- 세 RNS 함수 본문 합계: baseline 3,754 B, A 3,754 B, B 6,694 B.
- B는 전체 키생성에서 A보다 512 0.0095%, 1024 0.0041% 빨랐지만 2,940 B 증가.
- 큰 크기 iNTT는 A가 B보다 빠르다.
- 따라서 코드 크기 증가 없는 A를 기본 통합본으로 채택했다. B는 실험 폴더에 보존했다.
- 측정용 빈 슬롯 패딩 및 동일하게 추가한 stride literal은 위 함수 본문 합계에서 제외한다.

## 측정 조건

GCC 15.2.1, 암호 소스 -O3, CPU/SYSCLK/HCLK=800/400/200 MHz.
ITCM/DTCM 각각 256 KiB 구성, 런타임 I/D cache OFF, ECC 검사 ON.
기존 mlkem-native 기반 설정과 ECC 대응을 유지: 코드는 ITCM 하위 128 KiB,
상수·데이터·스택은 DTCM. 명목상 upstream과 완전히 같은 상수 배치는 아니다.
NTT/iNTT/small 함수 주소는 0x10000400/0x10001000/0x10002000으로 고정했다.
다른 함수들의 주소·크기도 후보 간 동일하다. 다른 링크 배치의 절대 사이클과 섞지 않는다.

전체 API: 10개 고정 seed 배치, batch마다 warmup 10회 + timed 10회 = 총 timed 100회.
KAT/digest와 변조 검사는 timed block 밖에서 수행했다.
원래 설정대로 interrupt는 켜져 있고 타이머는 64-bit Zephyr cycle counter다.

## 검증 결과와 한계

- 308개 소수 × logn=4..10, 2,156 설정: forward/inverse/roundtrip 불일치 0, 최대 모듈러 오차 0.
- signed 입력을 포함한 Montgomery 18,923,520 cases: 불일치·범위 오류 0.
- 독립 iNTT 입력 및 4종 패턴, 17,248 cases: 불일치·정규 범위 오류·buffer guard 오류 0.
- 공통 q-NTT 512/1024 oracle, 프로젝트 deterministic host KAT/digest, 정상 서명검증·변조 거부 통과.
- 별도 호스트 명령 에뮬레이션 2,944개 검사: 레지스터·메모리·접근 trace 일치.
- 정적 상수시간 회귀점검: 추가 secret-dependent branch/address 없음. B의 추가 guard도 공개 정보만 사용.
- 단, 형식적 상수시간 증명, dudect, 전력/EM leakage 검사는 수행하지 않았다.

## 로그와 재현

- [전체 A/B 비교](../5th_slothy/result.md)
- [구현 원리와 출처](../5th_slothy/IMPLEMENTATION.md)
- [최종 audit 원시 로그](../5th_slothy/measurement/results/ref_slothy-audit-adopted_a/runs/pilot-20260917T033049Z/raw.log)
- [최종 100회 원시 로그](../5th_slothy/measurement/results/ref_slothy-perf-adopted_a/runs/full-20260917T033122Z/raw.log)
- [최종 source/ELF/배치 감사](../5th_slothy/measurement/results/integrated_static_audit.json)
- [복사되어 있던 이전 q-NTT 결과 보존본](measurement/results/legacy_qntt_result_before_rns_slothy.md)

```sh
bash measurement/build_rns_slothy.sh audit
python3 measurement/run_rns_slothy.py audit pilot --label NEW_LABEL
bash measurement/build_rns_slothy.sh perf
python3 measurement/run_rns_slothy.py perf pilot --label NEW_LABEL
python3 measurement/run_rns_slothy.py perf full --label NEW_LABEL
```

측정 도구는 공용이며, 암호 구현 소스는 모두 이 ref_slothy 폴더에서 컴파일한다.
