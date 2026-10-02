# 채택 완료 — Slothy A

2026-09-17: `slothyA/kgen_mp31_cm55.s`를 `../ref_slothy`에 직접 반영했다.
다른 C/H/S와 기존 q-NTT Slothy A는 유지했다. `ref_preslothy`, `ntt_opt`,
`ntt_opt_slothy`는 변경하지 않았다.

이유: A는 K4-C보다 모든 측정 logn의 forward/inverse에서 빠르며 RNS 함수
본문 크기 증가가 없다. B는 전체 키생성에서 A보다 512 0.0095%, 1024 0.0041%
추가로 빨랐지만 코드가 2,940 B 증가한다. 따라서 A를 기본값으로 채택하고 B는 보존한다.

- 세 후보 각각 전체 API 100회 측정 완료.
- 정순/역순 두 번의 커널 측정과 모든 정확성 검사 완료.
- 최종 ref_slothy에서 새 audit/perf 빌드, 보드 검사, 전체 API 100회 재측정 완료.
- 최종 RNS assembly는 A와 byte-identical, ELF 기계어 및 시작 주소도 일치.
- 최종 assembly SHA-256: fdfa9fd82115a6b4f4014b5d43f574f39461e7c28ccf2be251eeda1b1b7b27c4.

[A/B 전체 비교](result.md), [최종 경로 결과](../ref_slothy/result.md),
[정적·배치 감사](measurement/results/integrated_static_audit.json).

상수시간은 정적 회귀점검까지이며 형식 증명이나 leakage 통계 검사를 완료했다는 뜻이 아니다.
