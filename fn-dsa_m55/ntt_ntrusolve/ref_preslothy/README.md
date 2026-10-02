# D1 + K1 full-iGM + K2 root pipeline — Slothy 적용 전 통합본

현재 소스에는 D1 위에 **K1 full inverse-root iNTT**와
**K2 root-preparation software pipeline**이 추가 적용되어 있다.
M55 빌드의 inverse root 표를 `wR/2`에서 `wR`로 바꾸고 `mp_iNTT()` 내부의 반복적인
modular doubling을 제거했으며, 다음 root 준비를 앞 butterfly의 독립 연산과 겹쳤다.
M4/일반 C와 AVX2의 기존 half-root 계약은 유지한다.

K1의 구현·성능·오차·KAT·서명검증·상수시간 회귀 결과는
[K1_FULL_IGM.md](K1_FULL_IGM.md), K2 결과는
[K2_ROOT_PIPELINE.md](K2_ROOT_PIPELINE.md)에 정리했다. 아래 내용은 K1/K2 이전
D1 단계의 이력이다.

구현 완료. 암호 소스 변경은 [kgen_mp31_cm55.s](kgen_mp31_cm55.s) 하나다.
타 후보의 구현을 빌드 옵션이나 링크로 선택하지 않는다.

**폴더 이름 주의:** 최신 H1/D0가 이미 final VLD4를 사용하고 있었다.
따라서 이번 D1은 NTT의 **penultimate VST4 → final plain load** 대안을 구현했다.
iNTT는 first plain store → second VLD4로 대응되는 경계를 이동했다.
자세한 D0/D1 정의와 논문 근거는 [상위 README](../README.md)를 따른다.

- 기반: L2 + M1_improve + H1 final scaling, Slothy 미적용.
- 적용: NTRU-solver `mp_NTT()`/`mp_iNTT()`, `logn=4..10`.
- 유지: 정수 Montgomery, gm/igm, 입력/출력 순서, H1의 마지막 1/n 스케일링.
- 제외: q=12289 NTT, CRT/Bezout, FFT, sampler, 3-layer 및 Slothy.
- 검증/측정: [result.md](result.md).
- 구현 원리/상수시간 검토: [IMPLEMENTATION.md](IMPLEMENTATION.md).
- 새 빌드: `profiling/build/stage4-m55-{audit,perf}`.
- 새 로그: `profiling/results/d1-boundary_v1-audit`,
  최종 성능 `profiling/results/d1-boundary_v2-perf`.

과거 H1에서 복사된 build/results 파일은 이번 결과의 근거가 아니다.
측정 manifest 파일명 `h1_build.json`은 검증 도구 호환을 위해 유지했지만
그 안의 source_dir, 31개 소스 해시, ELF 해시는 실제 D1을 가리킨다.
