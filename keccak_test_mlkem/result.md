# mlkem — M55 SHAKE256x4 측정 결과

2026-09-30, 현재 이 폴더 소스를 연결된 NUCLEO-N657X0-Q에서 직접 빌드·측정했다.

| 항목 | 이 후보 cycles | 기존 단일 PRNG/Keccak 대비 |
|---|---:|---:|
| Keccak 4개 상태 합계 | 30,583.25 | 1.8895× |
| x4 refill 544B (출력 작성 포함) | 38,552.375 | 원본에는 동일 API 없음 |
| PRNG 32KiB | 2,676,722 | 1.3534× |
| 전체 서명 512 | 10,678,400 | 1.0130× |
| 전체 서명 1024 | 22,279,079 | 1.0160× |

원본은 `Final_code/Before_slothy`다. 4상태는 원본 단일 permutation 4회와 비교하며,
단일 호출이 이 배율만큼 빨라졌다는 뜻이 아니다. 서명 표본은 크기별 32개 seed/고정 키 1개다.

Keccak oracle 512 state permutations, SHAKE256x4 8 seeds × 2,176 bytes,
혼합 크기 읽기·경계·guard, 정상 서명 68개·변조 거부 136개 통과.
세 x4 후보끼리 서명 digest가 일치하며 원래 단일 PRNG 서명과는 의도적으로 다르다.
원래 FN-DSA 서명 KAT 준수/종합 보안 인증을 주장하지 않는다.

[구현과 원본과의 차이](README.md) · [전체 후보 비교 및 조건](../keccak_test_hybrid/result.md) · [원시 로그](../keccak_test_mlkem/validation/results/mlkem/20260930T053728Z/raw.log).
