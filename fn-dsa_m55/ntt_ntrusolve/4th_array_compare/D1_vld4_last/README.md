# D1 — array-boundary experiment on adopted H1

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
