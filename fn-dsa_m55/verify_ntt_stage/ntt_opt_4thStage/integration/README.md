# Stage-4 promotion to ntt_opt

2026-09-13: 512·1024 모두 S1B_S2B_S3A를 채택해 `ntt_opt/mq_cm55.s`에 직접 반영했다.
통합 경로에서 다시 빌드하고 pilot, 100회 full 측정, 사후 로그 검증을 통과했다.

- [최종 결과·로그·재현 방법](../../ntt_opt/result.md)
- [통합 전 1~3단계 기준 소스·ELF](before/README.md)
- [통합 full 승인](results/integrated/full_validated.json)
- [소스·실행 이미지·컴파일 설정 감사](results/integrated/static_audit.json)
- [원시 batch 및 후보/기준 비교](results/integrated/comparison.json)

`build_integrated.sh`는 현재 `ntt_opt` 전체를 별도 `build-ntt-opt-stage4`에 빌드한다.
다른 후보의 소스를 include하거나 build 옵션으로 assembly 조각을 조합하지 않는다.
기존 stage-3 및 stage-4의 기준점 runner는 `before/`의 보존본을 사용한다.
