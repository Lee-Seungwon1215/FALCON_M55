# Stage-4 combination validation — v2

검사일: 2026-09-13. **12/12 조합 빌드·pilot·100회 full 측정과 사후 로그 검증 완료.**
이 문서의 기준 코드는 통합 전 1~3단계 보존본이다. 현재 `ntt_opt`에는
S1B_S2B_S3A가 반영됐으며 [통합 검증 결과](../../ntt_opt/result.md)는 별도로 기록했다.
결과 비교는 [RESULTS.md](RESULTS.md), 충돌 해결과 논문 근거는 [REVISION.md](REVISION.md).
이 문서는 현재 v2 소스 기준이다. v1 검증 기록은
[수정 전 archive](revision_before/sources-v1.tar.gz)에 보존했다.

## 검증 결과와 범위

| 검사 | 결과 | 범위·한계 |
|---|---|---|
| M55/MVE 조립·펌웨어 링크 | 12/12 PASS | 각 폴더의 mq_cm55.s 직접 컴파일, 다른 후보 파일 include 없음 |
| 성능 측정 | 12/12 완료 | degree·작업별 100회. 10개 고정 입력을 각각 10회 반복 |
| NTT 정확성 | 12/12 오차 0 | 512/1024의 고정 시험 다항식에 대한 scalar forward oracle, inverse round-trip, oracle round-trip 비교 |
| B1 상수곱 | 12/12 mismatch 0 | 양방향 root/twist 2,048쌍, 각 쌍에 결정적 시험 입력 1개. 모든 계수의 전수 검사는 아님 |
| KAT 회귀 | 12/12 PASS | 각 full run의 고정-seed digest 22개가 기존 host oracle과 일치. NIST 공식 인증 KAT를 뜻하지 않음 |
| 정상/변조 서명 | 12/12 PASS | 정상 키생성·서명·검증, 각 batch의 1-bit 변조 서명 거부 |
| fault / ECC | 12/12 PASS | CFSR/HFSR/AFSR=0, 실행 전후 TCM ECC 활성 |
| cache / clock | 12/12 일치 | CCR에서 I/D cache OFF, CPU/SYSCLK/HCLK 800/400/200 MHz |
| main stack | 모두 9,624 B 상한 | 64 KiB 예약 stack의 watermark 검사 |
| 정적 구조 감사 | 12/12 PASS | v1 대비 분기·스택 명령열 불변. 기준 코드와 비교해 MQ 안의 변경 함수는 NTT/iNTT뿐 |
| 명령어 모델 회귀 | 10,352개 PASS | tail 재배치, 레지스터 보존, 반복 1/2/3/4/8/16/32회 경계. 형식적 증명 아님 |

상수시간 검사는 **수정된 NTT 경로의 소스·기계어 정적 구조**에 대한 것이다.
전체 FN-DSA의 보안 증명, 통계적 timing-leakage 검사, 전력/EM TVLA는 수행하지 않았다.
FP/FFT/sampler의 새 구현 또는 정밀도 변경도 이번 범위가 아니다.

`mq.c` 및 나머지 C/H/S는 `ntt_opt`와 같고, 변경된 암호 소스 파일은
`mq_cm55.s` 하나뿐이다. 모든 후보의 정규화한 컴파일 명령과 Zephyr `.config`는
기준과 같다. v1 대비 8개 조합의 기계어를 변경했고, 이미 호환되던 4개는 유지했다.

## 현재 소스 식별값

아래 hash는 full 측정 ELF의 pilot 승인 때 사용한 현재 소스와 일치한다.
ELF·전체 source tree·raw log hash는 각 manifest와 `results/comparison.json`에 있다.

| 조합 | mq_cm55.s SHA-256 | ITCM 코드 B | 정적 감사 |
|---|---|---:|---|
| S1A_S2A_S3A | `ab527614e8b476973b1b0af00ae5f80042d4c623cd5895d1cd0ef6fc60243c26` | 106,316 | [JSON](results/S1A_S2A_S3A/static_audit.json) |
| S1A_S2A_S3B | `32eda7a4118311608e2b9b293f9a2c21f4d1588c15c3c65acb20e2060cbdcf55` | 106,316 | [JSON](results/S1A_S2A_S3B/static_audit.json) |
| S1A_S2A_S3C | `32a81b2fbf5da75a2f4399de5b7091eaffd787d09120a178bab5c9bf9e6dd960` | 108,556 | [JSON](results/S1A_S2A_S3C/static_audit.json) |
| S1A_S2B_S3A | `e00e76787718dbeca9b8b9e6bfe95fad999d43b3018716115c9b846fd8a9c307` | 106,236 | [JSON](results/S1A_S2B_S3A/static_audit.json) |
| S1A_S2B_S3B | `d3bcb229019f06444db44276ae4b3b6c4ec729d13a4525f5e86c07fd7031406e` | 106,236 | [JSON](results/S1A_S2B_S3B/static_audit.json) |
| S1A_S2B_S3C | `121d1d1a577cd688360dc817dac81b00b08c4bf4fa089303b963628e741107a3` | 108,492 | [JSON](results/S1A_S2B_S3C/static_audit.json) |
| S1B_S2A_S3A | `51e67ad68ba64d13e6cd231dbdfaa02632e2467bdb5ceaca90ee41139d1788de` | 106,316 | [JSON](results/S1B_S2A_S3A/static_audit.json) |
| S1B_S2A_S3B | `89764cef74960bed8ee670a6c772efff2d1d743a98357fd7b3629d0e938b974f` | 106,316 | [JSON](results/S1B_S2A_S3B/static_audit.json) |
| S1B_S2A_S3C | `202655c7a90e4d1e986b2f96467668d937c4ad88cc014b1de4bb672b943f9065` | 108,556 | [JSON](results/S1B_S2A_S3C/static_audit.json) |
| S1B_S2B_S3A | `0d1c14bed961466f649d1d818732d82ba3d1f1cf87c2ca441b37edaecf5d13f9` | 106,236 | [JSON](results/S1B_S2B_S3A/static_audit.json) |
| S1B_S2B_S3B | `3258408c5e22a43014cbdf611194018722ac595ea7a115d728b0eaaa436ea700` | 106,236 | [JSON](results/S1B_S2B_S3B/static_audit.json) |
| S1B_S2B_S3C | `53071a453d74e5bcc3342f70153f6b2bfcd715689f237bfe8da6ba885873d7e8` | 108,492 | [JSON](results/S1B_S2B_S3C/static_audit.json) |

- [명령어 모델 결과](results/revision_model.json)
- [전체 cycle·paired 비교·로그 식별값](results/comparison.json)
- 각 `results/<조합>/static/`에 수정 전 object와 현재 object, 최종 firmware
  역어셈블 및 정규화한 컴파일 명령을 저장했다.
- `mq.c` SHA-256: `58ca9a7d8b58862016cd43d24eca43343f3d2479981afdd6c1a9819f56a718a9`.

메모리·컴파일러·환경 상세와 모든 full 원시 로그 링크는 [RESULTS.md](RESULTS.md)에 있다.
