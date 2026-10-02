# Stage 4: NTRU-solver NTT/iNTT array-boundary comparison

최신 H1(`L2 + M1_improve + final scaling`)를 다시 읽고 구성한 실험이다.
범위는 `mp_NTT()`/`mp_iNTT()`의 **인접한 CT2/GS2 구간 사이 재배열 위치**다.
q=12289의 `mq_cm55.s`, CRT, Bezout, FFT, sampler는 변경하지 않는다.

## 폴더 이름과 실제 코드의 차이

폴더 이름은 보존했다. 하지만 복사되어 있던 H1은 **이미 마지막 NTT 구간에서
VLD4를 사용**하므로, 이름 그대로 구현하면 D0/D1이 같은 코드가 된다.

| 실제 역할 | D0_vst4_previous | D1_vld4_last |
|---|---|---|
| 기준 | 채택한 H1, 암호 소스 보존 | H1의 재배열 위치만 변경한 실험군 |
| NTT 경계 | 직전 plain store → 마지막 VLD4 | 직전 VST4 → 마지막 plain load |
| iNTT 경계 | 첫 GS2 VST4 → 다음 GS2 plain load | 첫 GS2 plain store → 다음 GS2 VLD4 |
| 외부 입출력 순서 | 기존 순서 | 기존 순서 유지 |
| 산술·정규화 | M1_improve / H1 | 그대로 유지 |

즉 **현재 D1은 이름과 달리 forward의 `VST4 previous` 대안**이다.
번호만 보고 기법을 해석하지 말고 위 표를 기준으로 한다.

## 근거와 적용 범위

- [Fast and Clean](../../../REFERENCE/m55_slothy.pdf), §8.2.2, Listing 10,
  PDF pp.32–34: penultimate VST4와 final VLD4를 대안으로 제시한다.
  §8.2.3에서는 연구의 Cortex-M55 NTT에서 전자가 유리했다고 보고한다.
  해당 연구는 Kyber/Dilithium이므로 FN-DSA의 31-bit 소수에서도 유리한지는 별도 측정한다.
- [Polynomial multiplication on embedded vector architectures](../../../REFERENCE/m55_ntt-ftt_opt.pdf),
  §6.4.2, pp.17–18: 32-bit 네 lane, 2-layer 병합, 최종 두 layer의 VLD4.
- inverse의 대칭 경계 이동은 위 전치 원리에서 도출한 **이번 구현의 적용**이다.
  논문이 FN-DSA의 이 iNTT 코드를 직접 제시했다는 뜻은 아니다.

추가 buffer나 table은 없다. 16-word(4×4) 타일이 잠시 전치된 채 저장되며
다음 구간이 이를 소비한다. 반환 시 순서는 원래대로다. `logn=4..10` MVE 경로에 적용하며
`logn<4` C fallback, 기존 gm/igm, 최종 1/n 정규화는 유지한다.
이 단계는 Slothy나 산술 방식 비교가 아니다.

## 측정

암호 구현은 D1의 `kgen_mp31_cm55.s`에 직접 작성했다. 후보 선택용 매크로나
타 후보 소스 링크는 추가하지 않았다. `profiling/` 도구는 전체 로컬 소스를 빌드한다.

D0 원본은 변경하지 않는다. `experiments/d0_layout/source`는 D0의 완전한 복사본에
반환 뒤의 **실행되지 않는 패딩만** 넣은 측정 대조군이다. D1과 세 커널의 시작 주소,
모든 allocated section의 위치/크기, 커널 슬롯 밖 모든 byte가 동일함을 검증한다.
패딩을 선택하는 빌드 옵션으로 D1의 연산을 구현한 것이 아니다.

```sh
python3 -B prepare_control.py
bash build_compare.sh audit
bash build_compare.sh perf
bash D1_vld4_last/profiling/build_m55.sh audit
bash D1_vld4_last/profiling/build_m55.sh perf
python3 -B audit_array.py audit
python3 -B audit_array.py perf
python3 -B -m unittest discover -s tests -v
```

보드 실행은 반드시 **이전 프로세스 종료 확인 후 순차로** 한다. 새 실행에는 새 label을 사용한다.
성능 `full`은 동일 ELF의 같은 label `pilot` 통과가 필요하다.

```sh
python3 -B compare_tools.py run audit pilot --label NEW_LABEL
python3 -B D1_vld4_last/profiling/m55.py run audit pilot --label NEW_LABEL
python3 -B compare_tools.py run perf pilot --label NEW_LABEL
python3 -B compare_tools.py run perf full --label NEW_LABEL
python3 -B D1_vld4_last/profiling/m55.py run perf pilot --label NEW_LABEL
python3 -B D1_vld4_last/profiling/m55.py run perf full --label NEW_LABEL
```

최종 기록은 [D1 result.md](D1_vld4_last/result.md), 기계 판독 결과는
`results/comparison.json`, 정적 검사는 `results/static_audit/`에 둔다.
복사된 과거 `profiling/results/` 기록은 이번 D0/D1 실험 증거로 사용하지 않는다.
