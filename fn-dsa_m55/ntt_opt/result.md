# FN-DSA M55 공통 NTT: 1~4단계 통합 결과

2026-09-13: **512·1024 모두 `S1B_S2B_S3A`로 통일하여 통합·재빌드·보드 검증 완료.**
활성 소스는 이 폴더의 [mq_cm55.s](mq_cm55.s)이다.

## 반영한 내용

- `ntt_opt_4thStage/combinations/S1B_S2B_S3A/mq_cm55.s` 내용을
  `ntt_opt/mq_cm55.s`에 직접 반영했다. 후보 소스를 빌드 설정으로 끌어오지 않는다.
- S1-B: 독립 곱의 동종 명령을 모아 배치.
- S2-B: 인접 layer의 독립 연산을 교차 배치.
- S3-A: twiddle load와 사용 사이에 독립 명령을 배치.
- 키생성/서명/검증별로 다른 NTT 구현을 선택하는 분기는 추가하지 않았다.
- 1단계 8×16-bit MVE, 2단계 512의 `2+3+2` / 1024의 `2+2+2+2`
  및 마지막 2-layer, 3단계 B1 Barrett 수식·상수표를 유지했다.
- 암호 C/H/S 중 수정한 파일은 `mq_cm55.s` 하나다.
  `mq.c`, FFT, sampler, NTRU solver 및 기존 후보 폴더는 변경하지 않았다.

통일한 이유: S3-C의 1024 keygen/verify 추가 이득은 S3-A 대비 각각 약
0.004%, 0.083%였고 서명은 느려졌다. S3-C 후보의 코드도 2,256 B 더 크다.
미세한 작업별 최저값을 위해 두 구현을 유지하지 않고 S1B_S2B_S3A를 채택했다.
[12개 후보 비교](../ntt_opt_4thStage/combinations/RESULTS.md).

## 통합 경로 재측정

단위: 전체 API의 upper median cycle/call. **NTT 함수 단독 시간이 아니다.**

| degree | 키생성 | 서명 | 검증 |
|---:|---:|---:|---:|
| 512 | 51,716,563 | 17,145,671 | 323,007 |
| 1024 | 260,368,536 | 36,737,446 | 624,898 |

| degree / 작업 | 1~3단계 기준 | 선택 후보 측정 | 통합 경로 측정 | 통합 − 후보 |
|---|---:|---:|---:|---:|
| 512 keygen | 51,722,695 | 51,716,562 | 51,716,563 | 1 |
| 512 sign | 17,150,930 | 17,145,670 | 17,145,671 | 1 |
| 512 verify | 323,738 | 323,007 | 323,007 | 0 |
| 1024 keygen | 260,391,747 | 260,368,536 | 260,368,536 | 0 |
| 1024 sign | 36,748,666 | 36,737,445 | 36,737,446 | 1 |
| 1024 verify | 626,546 | 624,898 | 624,898 | 0 |

대표값의 차이는 0~1 cycle이다. 실행 코드·초기 데이터는 동일하므로 이 차이를
새로운 성능 변화로 해석하지 않는다. 표의 1~3단계 기준은 통합 전 보존본이다.

## 측정 조건

- 실제 NUCLEO-N657X0-Q / Cortex-M55 r1p1, probe `003C00223335510735383531`.
- CPU / SYSCLK / HCLK **800 / 400 / 200 MHz**, I/D cache OFF, TCM ECC ON.
- ITCM vectors/code, DTCM 상수·데이터·스택; 각각 256 KiB 구성, main stack 64 KiB.
- GNU Arm **15.2.1**, Zephyr **4.4.1**, 최종 유효 **-O3**,
  `-mcpu=cortex-m55 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard`.
- `FNDSA_ASM_CORTEXM4=1`, `FNDSA_ASM_CORTEXM55=1`, `CONFIG_FPU=y` 유지.
- degree·작업별 **10개 입력 batch × 10회 = 100회 측정**.
  batch마다 별도 10회 warm-up. 100개 독립 입력을 쓰는 시험은 아니다.
- `k_cycle_get_64()`로 10-call block을 재고 10개 block의 upper median / 10을 보고.
  인터럽트 허용. API 내부 재시도는 포함; seed 준비·로그·출력 digest·변조 검사는 제외.
- 기존 고정 seed 생성, 메시지 `blah`, raw mode, 빈 context 그대로.
- `mlkem-native` Nucleo pin `637d076aa113d8faaec2277ed4a46b657acaf35f` 기반 환경을 유지했다.
  기존 DTCM 상수 배치·초기화 대응과 FPU 설정을 포함하므로 upstream 무수정 환경과
  같다는 뜻은 아니다. [공통 환경 설명](../measurement_mlkem_native/README.md).

## 검증

| 항목 | 결과 |
|---|---|
| 전체 C/H/S 소스 | 선택 후보와 byte-identical |
| 컴파일 명령·Zephyr .config | 선택 후보와 동일 |
| 최종 ELF 실행·데이터 영역 | 모든 allocated section의 주소·크기·내용 동일 |
| 함수 기계어 | 선택 후보와 동일 |
| 512/1024 NTT 시험 입력 | forward oracle / inverse round-trip / oracle round-trip mismatch 0, max modular error 0 |
| B1 상수곱 | root/twist 2,048쌍의 결정적 시험 입력, mismatch 0 |
| 고정-seed KAT 회귀 | host digest 22개 일치 |
| 키생성·서명·검증 | PASS |
| 1-bit 변조 서명 거부 | PASS |
| fault / ECC | CFSR/HFSR/AFSR=0, 실행 전후 TCM ECC ON |
| 정적 상수시간 구조 | 검증된 후보와 소스·기계어 동일, 새로운 입력 의존 branch/address 없음 |
| 명령어 모델 회귀 | 10,352개 PASS 재확인 |

KAT는 기존 host oracle과의 회귀 비교이며 NIST 공식 인증을 뜻하지 않는다.
시험 입력 전체 공간을 전수 검사한 것은 아니다. 상수시간 검사는 수정 NTT 경로의
정적 구조 확인이며 형식적 증명·통계적 timing leakage·전력/EM TVLA는 수행하지 않았다.

## 메모리 및 식별값

- ITCM 코드: **106,236 B**, 현재 사용하는 하위 128 KiB 안의 여유 **24,836 B**.
- DTCM 예약량: **225,728 / 262,144 B**, 여유 **36,416 B**.
- main stack 사용 상한: **9,624 B**.
- `mq_cm55.s` SHA-256: `0d1c14bed961466f649d1d818732d82ba3d1f1cf87c2ca441b37edaecf5d13f9`.
- 전체 C/H/S tree SHA-256: `e5c13189883685fea042fc3d74d23cf396afa29a94bd26a54d5a3bb2caac6172`.
- 통합 ELF SHA-256: `4be43c0818f0744c7287a77c39aa98f00b80e71432d0d553670dbe20ac9592c6`.

ELF 파일 전체에는 debug 경로 등이 포함되므로 후보 ELF와 전체 파일 hash는 다르다.
실제로 실행되는 영역과 데이터 영역은 바이트 단위로 동일하다.

## 로그·보존·재현

- [통합 full 원시 로그](../ntt_opt_4thStage/integration/results/integrated/runs/full-20260913T120522Z/raw.log)
- [full 승인 manifest](../ntt_opt_4thStage/integration/results/integrated/full_validated.json)
- [소스·기계어·설정 감사](../ntt_opt_4thStage/integration/results/integrated/static_audit.json)
- [이전 기준·후보·통합의 원시 batch 비교](../ntt_opt_4thStage/integration/results/integrated/comparison.json)
- [통합 전 1~3단계 소스·ELF 보존본](../ntt_opt_4thStage/integration/before/README.md)

기존 후보와 과거 raw log는 보존했다. 과거 runner의 stage-3 `ntt_opt`와
stage-4 `baseline` 이름은 보존한 1~3단계 source/ELF를 가리킨다.
**현재 1~4단계 통합 코드는 아래 전용 실행기로 측정한다.**

작업공간 루트에서:

```sh
bash fn-dsa_m55/ntt_opt_4thStage/build_integrated.sh
python3 fn-dsa_m55/ntt_opt_4thStage/audit_integrated.py
python3 fn-dsa_m55/ntt_opt_4thStage/run_integrated.py pilot
python3 fn-dsa_m55/ntt_opt_4thStage/run_integrated.py full
python3 fn-dsa_m55/ntt_opt_4thStage/audit_integrated.py --require-full
```

활성 build는 `measurement_mlkem_native/build-ntt-opt-stage4`이며,
전체 소스 경로는 `ntt_opt`이다. 희소 ELF를 사용하고 주소 사이의 큰 간격을
포함하는 flat BIN은 사용하지 않는다.

