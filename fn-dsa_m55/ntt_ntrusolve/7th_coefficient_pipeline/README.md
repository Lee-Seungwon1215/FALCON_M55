# 7th stage: coefficient memory pipeline

이 단계는 채택 기준 `ref_preslothy`의 K2에서 coefficient load/store와 MVE
산술의 실행을 겹치는 후보를 분리해 평가한다.

현재 완료된 후보:

- [`K4A_forward`](K4A_forward/README.md): forward RNS NTT의 ordinary CT2
  tile만 재배치. 정확성·KAT·서명검증·정적 상수시간 회귀 PASS.
- [`K4B_inverse`](K4B_inverse/README.md): inverse RNS NTT의 ordinary GS2
  tile만 재배치. 정확성·KAT·서명검증·정적 상수시간 회귀 PASS.
- [`K4C_combined`](K4C_combined/README.md): K4-A forward와 K4-B inverse를
  어셈블리 소스에 직접 통합. 두 커널 이득을 그대로 유지하며 모든 검사 PASS.

K4-A와 K4-B는 모두 K2에서 독립 분기한 ablation 후보이며 서로의 변경을 포함하지
않는다. K4-C는 두 독립 결과를 확인한 뒤 별도 소스에 직접 통합한 후보이며,
K2 대비 키생성은 512에서 0.083259%, 1024에서 0.053728% 개선됐다.
