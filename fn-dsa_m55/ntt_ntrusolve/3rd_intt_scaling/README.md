# Stage 3 — iNTT scaling

- `H0_stagewise_half/`: 최신 L2/M1_improve 기반, 레이어별 절반 보정. 암호 소스 변경 없음.
- `H1_final_scaling/`: 중간 절반 보정을 제거하고 마지막 레이어에 최종 scaling 통합.
  [구현 및 M55 결과](H1_final_scaling/result.md), [수식과 범위](H1_final_scaling/IMPLEMENTATION.md).
- `experiments/h0_layout/`: H0 전체 복사본의 iNTT return 뒤에 padding을 넣은 주소 통제 대조군.
  별도 최적화 후보가 아니며 H0 산술은 유지한다.
- `experiments/ntru_total/`: `solve_NTRU` 전체 시간만 계측하는 별도 진단.
- `results/`: 정적 검사 및 원시 로그에서 재계산한 비교 결과.

2026-09-15 H0/H1 보드 산술·KAT/digest·서명검증·변조 거부·100회/API 측정 통과.
H1은 iNTT 5.36~13.39%, 키생성 512/1024는 0.2913%/0.1864% 개선.
정적 상수시간 구조는 검토했지만 동적 누출 검사/형식적 증명은 수행하지 않았다.
H0/L2/통합 ref로 자동 반영하지 않았다.

## 대조군 재실행

저장소 루트 기준이며 보드 실행은 순서대로 한다. H1 재실행은
[H1 도구 설명](H1_final_scaling/profiling/README.md)을 따른다.
아래 도구는 후보별 전체 소스 경로만 선택한다. 암호 구현을 섞거나 H1을 빌드 옵션으로 선택하지 않는다.

```sh
bash fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/build_compare.sh h0_layout audit
bash fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/build_compare.sh h0_layout perf
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/compare_tools.py h0_layout run audit pilot --label new_run
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/compare_tools.py h0_layout run perf pilot --label new_run
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/compare_tools.py h0_layout run perf full --label new_run
```

`audit_scaling.py perf|audit`는 배치와 정적 구조를 검사한다.
`summarize_scaling.py`는 기록된 `final_v1` 결과만 읽어 `results/comparison.json`을 재생성한다.
새 실험을 집계하려면 스크립트 상단의 검증 결과 경로를 그 실험에 맞게 지정한다.
