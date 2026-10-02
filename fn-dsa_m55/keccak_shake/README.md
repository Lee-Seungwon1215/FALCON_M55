# Keccak/SHAKE — single-state 전체 MVE 구현

현재 [sha3_cm55.s](sha3_cm55.s)는 **모든 상태 계산이 MVE 정수 ASM인 최종 시험 채택본 A14**다.
주소·공개 카운터·ABI 저장/복귀만 스칼라다. FP 산술, SLOTHY, 외부 후보 링크,
구현 선택용 빌드 옵션은 사용하지 않았다.

| 구현 | process_block cycles/호출 |
| --- | ---: |
| 원본 M4 ASM을 동일 M55에서 실행 | 13,382 |
| 이전 혼합형 C9 | 12,521 |
| 최초 전체 MVE A0 | 17,689 |
| **현재 전체 MVE A14** | **12,504** |

A0보다 **29.312% 사이클 감소 / 1.41467배**, 원본보다 **6.561% 감소 / 1.07022배**다.
C9 대비 차이는 17 cycles, 약 0.136%에 불과하므로 사실상 유사한 성능으로 해석한다.
전역 최적해나 FN-DSA 전체 키생성/서명/검증 개선율을 의미하지 않는다.

- [현재 결과 요약](result.md)
- [원인 분석·14개 수정 후보·검증 로그](validation/full_mve_optimization.md)
- [초기 A0 전체 MVE 기록 — 과거 결과](validation/full_mve_result.md)
- [이전 C9 혼합형 실험 — 과거 결과](validation/keccak_ref_experiments.md)

## 현재 구현

| 부분 | 방법 |
| --- | --- |
| 내부 상태 표현 | low32/high32 두 정수 평면. 경계의 기존 표현은 보존 |
| 입력·출력 | 연속 영역 VLD2/VST2, tail gather/scatter, 공개 lane-0 predicate |
| 비트 분리/복원 | 경계 lane 21..24만 K_MERGE4/K_SPLIT4; 모두 MVE |
| θ | 벡터 XOR, cross-word shift/VSRI, 독립 low/high 연산 교차 배치 |
| ρ·π | 공개 주소표 gather, 사전 계산한 양/음 shift, 다음 묶음 주소 미리 읽기 |
| 마지막 ρ·π lane | 고정 주소·즉시값 회전·predicated MVE 저장, 스칼라 fallback 없음 |
| χ·열 parity | 다음 행 load와 VBIC/VEOR 교차 배치, Q 레지스터 역할 순환 |
| ι | 첫 행 χ와 다음 열 parity에 결합. 별도 상태 재읽기/재저장 제거 |

25개 lane의 **한 Keccak 상태**를 처리한다. 네 독립 상태의 x4 구현이 아니다.
`keccak_ref`의 low/high 표현·재사용 원리와 M55 논문의 명령 중첩 원리를 참고했지만
x4 API나 코드를 그대로 연결하지 않았다.

원본 private `bit_split_1..5` / `bit_merge_1..5` 및 inject 정의는 보존되어 있으나,
현재 `process_block`에는 함수 호출이 없다. 기존 helper 단독 측정값은 새 MVE 변환
성능이 아니다. 실제 변환 비용은 process_block 총시간에 포함되어 있다.

암호 소스 변경은 이 폴더의 `sha3_cm55.s` 하나다. `sha3.c`, NTT/FFT/sampler,
`Final_code/Before_slothy`는 이번에 변경하지 않았다.

## 인터페이스·메모리

- 공개 경계: lane 0..20은 canonical uint64, 21..24는 even/odd. 기존 M4 ABI와 동일.
- 내부 low/high는 정수 비트 분할이다. double hi/lo나 부동소수점 근사가 아니다.
- A 320 B, B 480 B, C/D 각 64 B, 메타데이터 16 B: 프레임 944 B.
- ABI 및 최악 정렬 여유 포함 자체 최대 스택 1,056 B. 전체 호출 체인 high-water 값은 아니다.
- R4–R11/D8–D15 보존. 모든 주소·회전량·루프·predicate는 공개 값이다.
- 원본 1,284 B helper/inject가 byte-identical임을 빌드 감사로 확인한다.
- 함수+라운드 상수 3,196 B; ASM .text 4,480 B; 추가 배치 상수표 704 B.

## 검증과 재현

M55에서 키생성 KAT **300/300**, 서명 KAT **90/90**, 정상 API **64건**,
비정상 입력 **3,902건 거부**, guard/fault 오류 0을 확인했다.
독립 Keccak oracle 1,024회, SHAKE256 7벡터, ABI 16회도 통과했다.
zero/random 각 1,000회의 관찰 시간은 동일했다. 정적 감사도 통과했다.
이것은 모든 입력의 정확성·상수시간 형식 증명이나 전력/전자파 검증은 아니다.

워크스페이스 루트에서:

```sh
make -C fn-dsa_m55/keccak_shake CROSS_COMPILE=/path/to/arm-none-eabi-
bash fn-dsa_m55/keccak_shake/validation/build.sh mve
python3 fn-dsa_m55/keccak_shake/validation/run.py mve
python3 fn-dsa_m55/keccak_shake/validation/static_audit.py

bash fn-dsa_m55/keccak_shake/validation/build.sh mve 24 kat
python3 fn-dsa_m55/keccak_shake/validation/run.py mve kat
bash fn-dsa_m55/keccak_shake/validation/build.sh mve 24 sigkat
python3 fn-dsa_m55/keccak_shake/validation/run.py mve sigkat
bash fn-dsa_m55/keccak_shake/validation/build.sh mve 24 api
python3 fn-dsa_m55/keccak_shake/validation/run.py mve api
python3 fn-dsa_m55/keccak_shake/validation/analyze.py <결과폴더>
```

`ref/mve` 선택은 측정 프로그램의 비교군 구분이다. 배포 구현은 이 폴더의 소스를 직접
빌드한다. 보드 실행은 공유 lock으로 직렬화하며 pinned N657 외에는 접근하지 않는다.
현재 구간 계측은 `validation/full_mve_profile`; 예전 `validation/phase_profile`은
C9 전용이다. 다른 시점의 비중표를 현재 코드의 결과로 해석하면 안 된다.
