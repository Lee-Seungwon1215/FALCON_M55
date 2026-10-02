# FN-DSA M55 NTT stage 4: manual instruction scheduling

이 단계는 통합 전 `ntt_opt`의 stage 1~3 코드를 고정 기준으로 비교했다.
그 기준 소스·ELF는 [integration/before](integration/before/README.md)에 보존했다.
후보 보완에는 스케줄링뿐 아니라 S2-B의 scalar-vector 명령 선택 변경도 포함한다.

**2026-09-13 최종 채택:** 512·1024 모두 `S1B_S2B_S3A`를 현재
[`../ntt_opt`](../ntt_opt)에 직접 반영하고 통합 경로의 100회 측정까지 통과했다.
[통합 결과·재현 방법](../ntt_opt/result.md).

| 후보 | 변경 축 | 상태 | 기준 대비 전체 API 결과 |
|---|---|---|---|
| `S1-A_staggered` | 독립 modular multiply 두 개의 dependency chain 교차 | 구현·검증·100회 측정 완료 | 6개 degree/연산 모두 0.002%~0.051% 개선 |
| `S1-B_phase-grouped` | 같은 종류의 multiply 명령을 phase별 배치 | 구현·검증·100회 측정 완료 | 6개 degree/연산 모두 0.004%~0.131% 개선; S1-A보다 빠름 |
| `S2-A_same-layer` | 동일 layer butterfly 사이 interleave | 구현·검증·100회 측정 완료 | 기준과 측정상 동일; 단독 채택 이득 없음 |
| `S2-B_cross_layer` | 인접 layer 사이 interleave | 구현·검증·100회 측정 완료 | keygen 동일; sign 0.0017%~0.0026%, verify 0.0297%~0.0511% 개선 |
| `S3-A_twiddle-preload` | twiddle 선행 load | 구현·검증·100회 측정 완료 | 6개 API 모두 0.0022%~0.0814% 개선; S3 일반 우선 후보 |
| `S3-B_early-load-late-store` | 입력 조기 load·출력 지연 store | 구현·검증·100회 측정 완료 | 6개 API 모두 0.0003%~0.0198% 개선; S3-A보다 느림 |
| `S3-C_cross-iteration` | 반복 간 software pipeline | 구현·검증·100회 측정 완료 | 1024 keygen/verify 개선, 나머지 4개 퇴행; 코드 +2,256 B |

## S1-A 결과

기존 직렬 순서:

```text
QH A -> MUL A -> MLA A -> QH B -> MUL B -> MLA B
```

S1-A staggered 순서:

```text
QH A -> MUL A -> QH B -> MUL B -> MLA A -> MLA B
```

S1-A는 `mq_cm55.s`에서 인접하고 독립적인 10쌍/20개 Barrett 곱셈에만
적용했다. 분기·메모리 접근·명령 수는 기준과 동일하다. NTT 오차 0, KAT,
서명검증, 변조 거부, fault 검사와 정적 상수시간 구조 감사를 모두 통과했다.

| degree | 연산 | 기준 cycle | S1-A cycle | 개선율 |
|---:|---|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,721,543 | 0.002227% |
| 512 | sign | 17,150,930 | 17,150,065 | 0.005043% |
| 512 | verify | 323,738 | 323,642 | 0.029654% |
| 1024 | keygen | 260,391,745 | 260,384,705 | 0.002704% |
| 1024 | sign | 36,748,666 | 36,745,786 | 0.007837% |
| 1024 | verify | 626,546 | 626,226 | 0.051074% |

세부 구현·검증 기록은
[`S1-A_staggered/README.md`](S1-A_staggered/README.md), 원시 로그는
[`results/s1a/runs/full-20260913T075011Z/raw.log`](results/s1a/runs/full-20260913T075011Z/raw.log)에 있다.

## S1-B 결과

S1-B는 같은 10쌍/20개 Barrett 곱셈을 다음과 같이 명령 종류별로 묶는다.

```text
QH A -> QH B -> MUL A -> MUL B -> MLA A -> MLA B
```

서로 다른 twiddle을 쓰는 packed 구간도 기존 root/twist 생성 명령을 두
phase로 나눠 추가 명령 없이 구현했다. 기준·S1-A·S1-B의 분기, 메모리,
곱셈 명령 수와 object 크기는 동일하다.

| degree | 연산 | 기준 cycle | S1-A cycle | S1-B cycle | 기준 대비 개선율 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,721,543 | 51,720,391 | 0.004455% |
| 512 | sign | 17,150,930 | 17,150,065 | 17,149,202 | 0.010075% |
| 512 | verify | 323,738 | 323,642 | 323,546 | 0.059307% |
| 1024 | keygen | 260,391,745 | 260,384,705 | 260,374,037 | 0.006801% |
| 1024 | sign | 36,748,666 | 36,745,786 | 36,741,465 | 0.019595% |
| 1024 | verify | 626,546 | 626,226 | 625,728 | 0.130557% |

세부 기록은 [`S1-B_phase-grouped/README.md`](S1-B_phase-grouped/README.md),
원시 로그는
[`results/s1b/runs/full-20260913T080417Z/raw.log`](results/s1b/runs/full-20260913T080417Z/raw.log)에 있다.

## S2-A 결과

S2-A는 기준의 각 butterfly를 끝낸 다음 번 것을 시작하던 순서를
같은 layer의 독립한 butterfly 두 개가 같은 phase를 연속 수행하도록
바꾸었다.

```text
기준: butterfly A 완료 -> butterfly B 완료
S2-A:  sum A/B -> reduction A/B -> difference A/B -> reduction A/B
```

forward CT 12쌍과 inverse GS 10쌍에 적용했다. inverse L0는 레지스터
점유 때문에 load 이동 없이 쌍으로 묶을 수 없어 S3 실험과의 분리를 위해
제외했다. 분기·메모리·산술 명령 수와 object 크기는 기준과 동일하다.

| degree | 연산 | 기준 cycle | S1-B cycle | S2-A cycle | S2-A-기준 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,720,391 | 51,722,694 | -1 |
| 512 | sign | 17,150,930 | 17,149,202 | 17,150,930 | 0 |
| 512 | verify | 323,738 | 323,546 | 323,738 | 0 |
| 1024 | keygen | 260,391,745 | 260,374,037 | 260,391,745 | 0 |
| 1024 | sign | 36,748,666 | 36,741,465 | 36,748,666 | 0 |
| 1024 | verify | 626,546 | 625,728 | 626,546 | 0 |

512 keygen의 1 cycle 차이는 0.000001933%로 유의한 이득이 아니다.
대응 batch 60개를 비교해도 S2-A 우세 10, 동일 41, 기준 우세 9이므로
**S2-A는 단독으로는 채택하지 않는다.** NTT 오차 0, KAT, 서명검증,
변조 거부, fault 검사와 정적 상수시간 구조 감사는 모두 통과했다.
세부 기록은 [`S2-A_same-layer/README.md`](S2-A_same-layer/README.md), 원시 로그는
[`results/s2a/runs/full-20260913T082009Z/raw.log`](results/s2a/runs/full-20260913T082009Z/raw.log)에 있다.

## S2-B 결과

S2-B는 현재 layer의 출력이 준비된 시점에 다음 layer의 가능한 twiddle
곱 또는 첫 butterfly 연산을 발행한다. forward 7곳과 inverse 5곳에
적용했으며, twiddle load와 메모리 접근은 움직이지 않았다.

```text
기준: layer L 완료 -> layer L+1 시작
S2-B: L 출력 준비 -> 가능한 L+1 연산 시작 -> L의 독립 tail 완료
```

| degree | 연산 | 기준 cycle | S1-B cycle | S2-B cycle | S2-B 기준 대비 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 51,722,695 | 51,720,391 | 51,722,695 | 0% |
| 512 | sign | 17,150,930 | 17,149,202 | 17,150,642 | 0.001679% |
| 512 | verify | 323,738 | 323,546 | 323,642 | 0.029654% |
| 1024 | keygen | 260,391,745 | 260,374,037 | 260,391,746 | -0.000000384% |
| 1024 | sign | 36,748,666 | 36,741,465 | 36,747,706 | 0.002612% |
| 1024 | verify | 626,546 | 625,728 | 626,226 | 0.051074% |

대응 batch에서 sign·verify 40개는 모두 기준보다 빨랐고 keygen은
측정상 동일했다. S2-B는 조합 후보로 유지하지만, 단독 후보 중에는
여전히 S1-B가 6개 degree/연산 모두 더 빠르다. NTT 오차 0, KAT,
서명검증, 변조 거부, fault 검사와 정적 상수시간 구조 감사를 통과했다.
세부 기록은 [`S2-B_cross_layer/README.md`](S2-B_cross_layer/README.md), 원시 로그는
[`results/s2b/runs/full-20260913T085019Z/raw.log`](results/s2b/runs/full-20260913T085019Z/raw.log)에 있다.

## S3 결과

S3-A/B/C는 각각 현재 iteration twiddle load-use 거리, 같은 iteration의
입력/출력 배치, 반복 간 software pipeline을 독립적으로 시험했다.

| degree | 연산 | 기준 | S3-A | S3-B | S3-C | S3 최선 |
|---:|---|---:|---:|---:|---:|---|
| 512 | keygen | 51,722,695 | **51,721,172** | 51,722,311 | 51,723,584 | S3-A |
| 512 | sign | 17,150,930 | **17,149,415** | 17,150,545 | 17,158,420 | S3-A |
| 512 | verify | 323,738 | **323,487** | 323,674 | 323,990 | S3-A |
| 1024 | keygen | 260,391,745 | 260,386,135 | 260,391,042 | **260,385,717** | S3-C |
| 1024 | sign | 36,748,666 | **36,745,607** | 36,748,282 | 36,758,816 | S3-A |
| 1024 | verify | 626,546 | **626,036** | 626,482 | 626,084 | S3-A |

S3-A와 S3-B는 각각 60개 대응 batch가 모두 기준보다 빨랐다. S3-C는
1024 keygen·verify 20개에서는 모두 빨랐지만 나머지 40개에서는 모두
느렸고 object code가 10,500 B에서 12,756 B로 증가했다. 따라서 전체
API용 우선 후보는 **S3-A**이며, S3-C는 1024 keygen 특화 및 조합 상호작용
확인용으로만 유지한다. 세 후보 모두 NTT 오차 0, KAT, 서명검증, 변조
거부, fault 검사와 정적 상수시간 구조 감사를 통과했다.

- [S3-A 세부 기록](S3-A_twiddle-preload/README.md) · [full log](results/s3a/runs/full-20260913T091151Z/raw.log)
- [S3-B 세부 기록](S3-B_early-load-late-store/README.md) · [full log](results/s3b/runs/full-20260913T091429Z/raw.log)
- [S3-C 세부 기록](S3-C_cross-iteration/README.md) · [full log](results/s3c/runs/full-20260913T091620Z/raw.log)

## S1 × S2 × S3 combination 구현 상태

`combinations/`의 12개 조합은 각 디렉터리의 `mq_cm55.s` 안에 직접
구현했다. 다른 후보 파일을 include하거나 Makefile·CMake 변수로 조합하지
않으며, 각 소스의 SHA-256도 서로 다르다.

| S1 | S2 | S3 | 직접 소스 | M55 전체 링크 | 보드 pilot |
|---|---|---|---|---|---|
| A | A | A/B/C | 완료 | PASS | 3/3 PASS |
| A | B | A/B/C | 완료 | PASS | 3/3 PASS |
| B | A | A/B/C | 완료 | PASS | 3/3 PASS |
| B | B | A/B/C | 완료 | PASS | 3/3 PASS |

모든 pilot에서 FN-DSA-512/1024 forward NTT oracle, inverse round-trip 및
oracle round-trip의 mismatch와 최대 modular error가 0이었다. 고정 seed
digest도 12개 모두 같았고 키생성·서명·검증 및 1-bit 변조 서명 거부가
PASS했다. main stack 사용 상한은 모두 9,624 B였다.

겹치는 스케줄은 다음 원칙으로 합쳤다.

- `S1 + S2-A`: 같은-layer butterfly 배치를 유지하고, 그 앞의 독립 twiddle
  곱 두 개를 선택한 S1-A/S1-B 순서로 수행한다.
- `S1 + S2-B`: S2-B의 layer 경계에서 전용 결합 매크로를 호출하고, 그
  매크로 내부 두 곱을 선택한 S1 순서로 수행한다.
- `S2-B + S3-B`: 512 3-layer에서 균일 twiddle을 GPR에 유지하는
  scalar-vector 연산으로 Q 레지스터 부담을 줄였다. 충돌하던 `q7` preload와
  첫 결과를 모두 보존하여 해당 쌍에도 early-load/late-store를 적용했다.
  추가 spill은 없다.
- `S2 + S3-C`: S1/S2 의존성을 지키면서 현재 결과의 마지막 사용·저장
  직후에 다음 반복을 읽는다. 현재 반복의 남은 독립 산술과 실제로 겹친다.
  기존 prologue/epilogue와 마지막 반복의 경계는 유지한다.

추가한 결합 매크로에는 입력값에 따른 branch나 주소 선택이 없다. 새 분기는
공개 `logn`과 고정 loop counter에만 의존한다. 따라서 기존의 정적
상수시간 구조를 유지하지만, 이는 소스·역어셈블 수준의 검사이며 전력/EM
TVLA를 뜻하지 않는다. **12개 조합의 100회 full 성능 비교와 사후 로그 검증을
모두 완료했다.** NTT 오차 0, 고정-seed host digest 22개 일치, 정상·변조
서명 검증, fault/ECC 검사에 모두 통과했다.

이번 측정에서 512의 세 API는 `S1B_S2B_S3A`가 최저 cycle이었다.
1024의 keygen/verify는 `S1B_S2B_S3C`, sign은 `S1B_S2B_S3A`가 최저였다.
전체 결과와 원시 로그는 [`combinations/RESULTS.md`](combinations/RESULTS.md)에 있다.
최저값이 작업별로 나뉘지만 차이가 작아 최종적으로는 512·1024 모두
`S1B_S2B_S3A`를 `ntt_opt`에 통합했다. 기존 비교 표의 기준은 보존한 1~3단계 코드다.

레퍼런스에 근거한 충돌 해결과 변경 범위는
[`combinations/REVISION.md`](combinations/REVISION.md)에 기록했다.
이번 S2-B 개선에는 동일 수식의 명령어 선택 변경도 포함된다.

조합별 현재 소스 hash와 pilot/full 검증 기록은
[`combinations/VALIDATION.md`](combinations/VALIDATION.md)에 정리했다.

## 재측정 실행기

`run_stage4.py`는 이미 빌드된 정확한 ELF와 C/H/S source hash를 확인하고
pilot 통과 후에만 full 측정을 허용한다. 후보 등록과 결과 저장 경로를
stage 4 구조에 맞춘 wrapper이며, 실제 검증 규칙은 검증된 stage 3 runner를
재사용한다.

```sh
python3 run_stage4.py s1a pilot
python3 run_stage4.py s1a full
python3 run_stage4.py s1b pilot
python3 run_stage4.py s1b full
python3 run_stage4.py s2a pilot
python3 run_stage4.py s2a full
python3 run_stage4.py s2b pilot
python3 run_stage4.py s2b full
python3 run_stage4.py s3a pilot
python3 run_stage4.py s3a full
python3 run_stage4.py s3b pilot
python3 run_stage4.py s3b full
python3 run_stage4.py s3c pilot
python3 run_stage4.py s3c full
```
