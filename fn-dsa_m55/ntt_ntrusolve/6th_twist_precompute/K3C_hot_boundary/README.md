# K3-C hot-boundary root/twist experiment

K2 `ref_preslothy`의 일반 root 배열은 그대로 두고, MVE가 연속 load할 수 있는
`{root, twist}` 벡터를 NTT 경계 두 layer에 대해서만 미리 만든 실험이다.

- `F_forward`: NTT 마지막 두 layer만 packed table 사용
- `I_inverse`: iNTT 첫 두 layer만 packed table 사용
- `FI_combined`: 두 방향 모두 사용

구현은 각 후보의 `kgen_mp31.c`와 `kgen_mp31_cm55.s`에 직접 들어 있으며,
후보를 외부에서 링크하거나 빌드 옵션으로 선택하지 않는다. NTRU solve가 생성한
`logn` root table로 `logn-1` 변환도 수행하므로 두 크기의 packed region을 함께
생성한다.

정확성·KAT·서명검증·변조 거부·정적 상수시간 회귀는 모두 통과했다. 그러나
커널만 보면 2.1~3.3% 빨라진 반면 table 준비 비용 때문에 전체 키생성은 모두
느려졌다. 따라서 K3-C는 **기각**하며 통합 기준본은 계속 K2
`ntt_ntrusolve/ref_preslothy`다.

상세 수치와 재현 로그는 [result.md](result.md), 정적 검사는
[static_ct.json](static_ct.json)에 있다.
