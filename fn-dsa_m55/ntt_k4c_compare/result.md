# M55_ref 대 K4C 포함 ntt_opt: 전체 API 재측정

2026-09-28 실물 NUCLEO-N657X0-Q 재측정. 아래는 **전체 API** 시간이며,
NTT 단독 커널 배율이 아니다. 예전 K2·SLOTHY·FFT 측정값은 합치지 않았다.

## 주 결과

원본은 `../M55_ref`, 최적화는 `../ntt_opt`이다. 최적화에는 공통 q-NTT와
**K4C RNS NTT/iNTT**가 들어 있고, FFT 최적화 및 SLOTHY는 없다.
암호 구현 자체는 이번 측정에서 수정하지 않았다.

각 칸은 **100회 산술평균 cycles/call**이다. 고정 입력 10개를 각각 10회 측정했다.
감소율 = `(원본 − 최적화) / 원본 × 100`, 배율 = `원본 / 최적화`.

| 크기 | 전체 연산 | M55_ref cycles | ntt_opt cycles | 사이클 감소율 | 속도 배율 |
| --- | --- | ---: | ---: | ---: | ---: |
| 512 | 키생성 | 57,447,591.74 | 51,717,038.23 | 9.9753% | 1.110806배 |
| 512 | 서명 | 18,265,777.38 | 17,976,442.80 | 1.5840% | 1.016095배 |
| 512 | 검증 | 366,759.00 | 317,433.00 | 13.4492% | 1.155390배 |
| 1024 | 키생성 | 280,951,477.99 | 261,663,168.48 | 6.8654% | 1.073714배 |
| 1024 | 서명 | 39,215,813.97 | 38,604,817.90 | 1.5580% | 1.015827배 |
| 1024 | 검증 | 725,746.21 | 621,480.10 | 14.3667% | 1.167771배 |

## 동일 조건과 배치 확인

- CPU/SYSCLK/HCLK: 800/400/200 MHz. I/D 캐시 OFF, TCM ECC ON.
- ITCM 코드, DTCM 상수·데이터·스택. TCM 각각 256 KiB.
- GCC 15.2.1, `-O3`, 원본 M4 어셈블리 ON. 동일 메시지·seed·측정 프로그램.
- 입력별/연산별 워밍업 10회 후 10회를 한 블록으로 계측한다.
- IRQ 및 SysTick 활성화. 64-bit cycle timer를 DWT와 교차 확인했다.
- 키 후보 재시도·인코딩 등 API 내부 작업을 포함한다. seed 준비·digest·변조 검사는 제외한다.
- 100개 서로 다른 seed의 평균은 아니다. 과거 다른 입력 집합의 절대 사이클과 직접 혼합하면 안 된다.
- 두 ELF의 공통 함수 256개, 공통 데이터 심볼 146개 및 작업 버퍼·스택 주소가 일치한다.
- q-NTT/RNS 코드 및 NTT 상수에는 같은 크기의 영역을 예약했다. 변경된 영역 내부 주소까지 동일하지는 않다.
- 빌드 출력의 FLASH/RAM은 링크 영역 이름이다. 실제 실행 주소는 ITCM `0x10000000`, DTCM `0x30000000`이다.

## 정확성 및 반복 확인

각 실행 전 같은 ELF의 pilot를 통과했다. 본 측정의 출력 digest 22줄(크기별 10개 입력과
누적 digest)이 host 기준과 일치하고 두 구현끼리도 일치한다. 정상 서명 검증 및 변조
서명 거절을 통과했으며 q-NTT 직접 비교·왕복 오차는 0이다. 최적화 Barrett 표 검사도 통과했다.
ECC는 시작/종료 모두 ON이고 CFSR/HFSR/AFSR는 0이다.

이것은 이번 입력 집합의 정확성 검사이며 전체 공식 KAT, 모든 입력의 동등성 또는
상수시간 증명을 새로 수행했다는 뜻은 아니다. RNS 상세 커널 검증은
[독립 커널 결과](../function_compare/ntt_k4c/result.md)를 참조한다.

동일 ELF/입력으로 실행 순서를 뒤집어 각 연산 100회를 한 번 더 측정했다.
**주 표는 첫 100회 결과이며**, 확인 반복을 합쳐 다른 모집단처럼 표시하지 않았다.

| 크기 | 연산 | 1차 감소율 | 역순 반복 감소율 | 원본 평균 변화(cycles) | 최적화 평균 변화(cycles) |
| --- | --- | ---: | ---: | ---: | ---: |
| 512 | 키생성 | 9.9753% | 9.9753% | +0.21 | -0.45 |
| 512 | 서명 | 1.5840% | 1.5840% | -0.19 | +0.06 |
| 512 | 검증 | 13.4492% | 13.4492% | +0.00 | +0.00 |
| 1024 | 키생성 | 6.8654% | 6.8654% | +0.78 | -0.03 |
| 1024 | 서명 | 1.5580% | 1.5580% | +0.12 | -0.02 |
| 1024 | 검증 | 14.3667% | 14.3667% | +0.00 | +0.01 |

## 원시 로그와 재현 자료

### k4c_v1 — ref → ntt_opt

- `ref`: 2026-09-28T02:24:12.739832+00:00 → 2026-09-28T02:25:54.979838+00:00 (UTC). [raw.log](results/ref-k4c_v1/runs/full-20260928T022412Z/raw.log), [run.json](results/ref-k4c_v1/runs/full-20260928T022412Z/run.json), [소스·빌드 해시](results/ref-k4c_v1/runs/full-20260928T022412Z/provenance.json)
- `ntt_opt`: 2026-09-28T02:26:07.407896+00:00 → 2026-09-28T02:27:43.115073+00:00 (UTC). [raw.log](results/ntt_opt-k4c_v1/runs/full-20260928T022607Z/raw.log), [run.json](results/ntt_opt-k4c_v1/runs/full-20260928T022607Z/run.json), [소스·빌드 해시](results/ntt_opt-k4c_v1/runs/full-20260928T022607Z/provenance.json)
- [기계 판독 결과](results/comparison-k4c_v1.json)

### k4c_reverse_v1 — ntt_opt → ref

- `ref`: 2026-09-28T02:31:02.805773+00:00 → 2026-09-28T02:32:45.066563+00:00 (UTC). [raw.log](results/ref-k4c_reverse_v1/runs/full-20260928T023102Z/raw.log), [run.json](results/ref-k4c_reverse_v1/runs/full-20260928T023102Z/run.json), [소스·빌드 해시](results/ref-k4c_reverse_v1/runs/full-20260928T023102Z/provenance.json)
- `ntt_opt`: 2026-09-28T02:28:38.569569+00:00 → 2026-09-28T02:30:14.336118+00:00 (UTC). [raw.log](results/ntt_opt-k4c_reverse_v1/runs/full-20260928T022838Z/raw.log), [run.json](results/ntt_opt-k4c_reverse_v1/runs/full-20260928T022838Z/run.json), [소스·빌드 해시](results/ntt_opt-k4c_reverse_v1/runs/full-20260928T022838Z/provenance.json)
- [기계 판독 결과](results/comparison-k4c_reverse_v1.json)

- [메모리 배치 검사](results/layout_audit.json)
- [전체 BATCH 원시 사이클 CSV](results/api-batches.csv)
- [빌드·실행 방법](README.md)

각 실행 폴더에는 실제 ELF·map·config·소스 사본도 보존한다.

NTT 단독 3~4배와 전체 API 배율이 다른 이유는 나머지 NTRU/FFT/샘플러/SHAKE 등은
이번 최적화 대상이 아니기 때문이다. 이 실행은 연산비중 프로파일링이 아니라 API 성능 비교다.
