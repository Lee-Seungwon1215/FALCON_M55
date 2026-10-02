# keccak_ref 기반 후속 비교 — 2026-09-29

범위: `sha3_cm55.s`의 단일 상태 `fndsa_sha3_process_block()`.
`sha3.c`, inject, split/merge 본문, 다른 암호 함수는 수정하지 않았다.
후보는 매번 실제 `.s` 본문을 교체해서 빌드했다. 배포용 후보 선택 매크로,
다른 구현 디렉터리에 대한 링크, SLOTHY는 사용하지 않았다.
각 측정 폴더의 `sources.tar.gz` 안 `production/sha3_cm55.s`가 그 후보의 소스다.

## 비교 기준과 측정

이전 채택 MVE: 12,569 cycles. 원본 M4 ASM을 M55에서 실행: 13,382 cycles.
분리/복원, 함수 진입/복귀, 전체 24라운드를 포함한 동일 프로그램의 값이다.
N657 serial `003C00223335510735383531`, CPU 800 MHz, cache OFF,
코드 ITCM/데이터·스택 DTCM, GCC 15.2.1 `-O3`.
워밍업 5배치, 100표본 × 64호출, DWT/빈 루프 보정, IRQ OFF.
후보별 ELF/map/소스 해시/전체 상태 oracle/ABI/입력 클래스 타이밍을 보존했다.
측정 도구의 `mve` 디렉터리 이름은 로컬 `sha3_cm55.s` 선택을 의미한다.
아래 scalar 비교 후보가 MVE를 사용했다는 뜻은 아니다.

## 결과

| 후보 | 구현 차이 | cycles | 실행 폴더 |
| --- | --- | ---: | --- |
| C1 | χ 중복 load 제거: 역순 배치 + VSHLC 레지스터 창 | 14,752 | [131744Z](results/mve/20260929T131744Z/result.md) |
| C2 | keccak_ref 단일 상태 4라운드 결합·지연 회전, S0–S31 상태 보관 | 13,820 | [132120Z](results/mve/20260929T132120Z/result.md) |
| C3 | C2와 같은 결합, 상태를 DTCM에 보관 | 13,310 | [132438Z](results/mve/20260929T132438Z/result.md) |
| C4 | ρ·π까지 MVE: 공개 gather 인덱스 + lane별 벡터 shift/OR | 15,017 | [132604Z](results/mve/20260929T132604Z/result.md) |
| C5 | C4의 회전 결과를 χ에 직접 전달, 중간 ρ·π 배열 없앰 | 16,120 | [132807Z](results/mve/20260929T132807Z/result.md) |
| C6 | 원래 벡터 χ 유지, 스칼라 tail 입력은 이미 읽은 Q 레지스터에서 전달 | 12,569 | [132916Z](results/mve/20260929T132916Z/result.md) |
| C7 | 기존 혼합 구조에서 ρ·π 두 입력을 먼저 읽고 독립 계산 교차 배치: (0,1)+(2,3)+4 | 12,521 | [133031Z](results/mve/20260929T133031Z/result.md) |
| C8 | C7의 묶음 경계를 변경: 0+(1,2)+(3,4) | 12,521 | [133219Z](results/mve/20260929T133219Z/result.md) |
| **C9** | **C7 + C6 결합; 동일 속도에서 코드 크기가 작은 조합 선택** | **12,521** | [133304Z](results/mve/20260929T133304Z/result.md) |

C1–C9의 모든 커널 검사는 통과했다. 표는 반올림한 평균 사이클이다.
일부 배치에서 64호출 합계가 1 cycle 증가한 경우가 있으며 원시 통계에 남겼다.

## 확인된 사실과 해석의 구분

- 기존 채택본 χ의 고유 입력은 라운드당 200 B지만 load 명령의 데이터 크기 합은
  600 B(벡터 load 30개 + scalar load 30개)였다. ρ·π의 B store는 240 B였다.
  이는 명령 분석이지 계측한 시간 비중이나 물리 버스 transaction 수가 아니다.
- C1은 χ 입력 읽기를 200 B로 줄였지만 느려졌다. 레지스터 창을 만드는
  추가 명령과 의존성이 생겼다. 정확히 각 stall이 몇 cycle인지는 미측정이다.
- C2→C3에서 메모리 보관이 더 빨랐다. FP 레지스터에 정수 비트를 보관하는
  것이 DTCM load/store보다 항상 유리하지 않음을 이 조건에서 확인했다.
- C4는 병렬화 범위를 넓혔지만 주소/shift 상수 읽기, gather, 여러 벡터 shift/OR가
  추가됐다. C5는 중간 저장을 없애면서 χ 재배열과 parity 집계를 추가했다.
  줄어든 메모리 명령만으로 전체 속도를 예측할 수 없었다.
- C6은 중복 scalar load를 없앴지만 시간은 동률이었다.
- C7/C8은 기존 채택본보다 48 cycles, 약 0.382% 감소했다.
  C9은 그 속도를 유지하며 기존 채택본보다 ASM `.text`가 16 B 작았다.
  최종적으로 C9을 채택했고, 중복 매크로 본문을 정리한 뒤에도 `.text` SHA-256은
  `d6822e4ad1a9f0c33e507662bd737a021ea57f17245cf1c018061af5242fad24`로 동일했다.
- 최종 χ는 중복 scalar load를 없애 읽는 양이 600→480 B/round로 줄었다.
  겹치는 벡터 load 30개와 스칼라 다섯 번째 열 계산은 여전히 남아 있다.
- 광범위한 MVE 확대가 이번 조건에서 이기지 못했으며, 이는 M55의 모든 단일 상태
  최적화 가능성을 소진했거나 하드웨어 한계를 증명했다는 뜻은 아니다.
- 이 결과는 단일 상태 커널에 대한 것이다. 네 독립 상태를 처리하는 x4의
  처리량, SHAKE 전체, FN-DSA 전체 성능으로 환산하지 않았다.

## 기법의 출처

- `keccak_ref/common/keccak_m55/keccak_round_macros.inc`:
  Keccak 팀/ Alexandre Adomnicai의 CC0 기반 `eorror`, `bicror`,
  `KeccakThetaRhoPiChi`, 4라운드 in-place 및 지연 회전. C2/C3에 직접 적용.
- `keccak_ref/common/keccak_m55/keccak_state_backend.inc`:
  `state_load/state_store`와 FP 레지스터 상태 보관. C2/C3의 비교 근거.
- 같은 round macros의 `xor5_pair`:
  독립 작업의 load/계산 교차 배치를 참고. C7/C8은 이를 θ가 아닌 ρ·π에
  적용해 직접 설계한 후보이며 해당 매크로의 복사본은 아니다.
- `keccak_ref/common/keccak_m55/asm_x4/hand/keccakx4_hand.S`:
  `KX4_CHI_ROW`의 입력 재사용, `KX4_RHOPI_STEP`의 상태 재사용.
  C1/C5/C6은 이 원리를 단일 상태 구조로 새로 설계한 것이며 x4 코드를 그대로 이식한 것은 아니다.
- x4는 네 독립 상태이고 현재 API는 한 상태다. 한 SHAKE 스트림의 연속 블록을
  네 독립 상태로 바꿔 KAT을 유지하는 최적화는 하지 않았다.

## 검증 범위

각 유효 후보: helper 5,120건, 전체 Keccak 상태 1,024회, Python hashlib SHAKE256
7벡터, ABI 16회, guard/fault 검사 통과. zero/random 각각 1,000회 타이밍 검사.
최종 C9 정리본에 대해 전체 FN-DSA 키생성 KAT 300/300, 서명 KAT 90/90,
API 정상 64건/비정상 3,902건 거부(오류·guard 0)를 재검사해 통과했다.
최종 증거: [키생성](results/mve_kat/20260929T133446Z/raw.log),
[서명](results/mve_sigkat/20260929T133553Z/raw.log),
[API](results/mve_api/20260929T133603Z/raw.log).
소스 정리 후 [최종 측정](results/mve/20260929T133443Z/result.md)과
[역순 재측정](results/mve/20260929T133625Z/result.md)에서도 12,521 cycles를 확인했다.
탈락 후보 전체를 전체 FN-DSA KAT까지 통과했다고 해석하면 안 된다.
단위 차이는 0이지만 모든 입력의 동등성·상수시간 형식 증명은 아니다.

탐색 중 C2의 첫 빌드에서 공통 helper 전처리 부분 누락으로 링크 오류가 발생했다.
보드 로더는 stale audit 검사로 실행을 거부했다. helper를 복구하고 1,284 B
byte-identical 검사를 통과한 재빌드만 표의 유효 측정에 포함했다.
