# 전체 MVE 전용 구간 계측

배포 `sha3_cm55.s`를 수정하지 않고 generated copy에만 8개 정적 tap을 넣는다.
24라운드 전체에서 77회 실행한다. R2/R3가 dead인 경계만 사용하며 flags/Q/SP를 보존한다.
소스 SHA가 같은 plain/trace만 결합할 수 있다. 모든 보드 실행은 공통 lock을 사용한다.

```sh
bash fn-dsa_m55/keccak_shake/validation/full_mve_profile/build.sh plain
bash fn-dsa_m55/keccak_shake/validation/full_mve_profile/build.sh trace
python3 fn-dsa_m55/keccak_shake/validation/full_mve_profile/run.py plain
python3 fn-dsa_m55/keccak_shake/validation/full_mve_profile/run.py trace
python3 fn-dsa_m55/keccak_shake/validation/full_mve_profile/analyze.py <plain 결과 경로> <trace 결과 경로>
```

최종 A14: [plain](results/plain/20260929T145339Z/raw.log),
[trace](results/trace/20260929T145343Z/raw.log), [집계](summary.json).
전체 12,504 cycles 중 입출력425, θ·ρ/π7,536, χ·parity·ι4,320,
나머지223 cycles. ι가 χ에 결합되어 있는 버전이라는 점에 유의한다.

A0의 [trace](results/trace/20260929T142554Z/raw.log)는 다른 소스다.
A0 분석에는 동일 A0의 계측 없는 커널 기록을 비교했고, 최종 plain/trace와 혼합하지 않는다.
이전 `../phase_profile`은 C9 전용이며 이 디렉터리와 별개다.

계측 보정 뒤 A14 총시간은 plain과 약2 cycle 차이지만, 이것은 각 구간의 오차 상한이 아니다.
상세 설명은 [최적화 보고서](../full_mve_optimization.md)를 참조한다.
