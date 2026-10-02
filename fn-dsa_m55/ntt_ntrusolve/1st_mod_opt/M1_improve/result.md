# M1-improve signed-difference Montgomery 구현·검증 결과

측정일: 2026-09-14  
보드: NUCLEO-N657X0-Q, Cortex-M55 r1p1

M1 rounding Montgomery를 유지하면서 inverse GS butterfly의 차이를
Montgomery 곱셈 전에 정규화하던 중복 작업을 제거했다. 독립 정수 모델,
실제 MVE 곱셈, 308개 RNS 소수의 NTT/iNTT, 전체 KAT, 서명 검증과 변조 거부,
정적 상수시간 구조 검사 및 100회 성능 측정을 통과했다.

## 구현 범위

활성 암호 소스 변경은
[`kgen_mp31_cm55.s`](kgen_mp31_cm55.s) 하나다. M1의 다른 C/H/S 파일은
byte-identical하다.

M1의 inverse butterfly는 다음과 같이 차이를 먼저 `[0,p)`로 만들었다.

```text
d = a - b
if d < 0: d += p
out = Montgomery(d, root)
```

M1-improve는 아래처럼 signed 차이를 직접 사용한다.

```text
d = a - b                  # -p < d < p
out = MontgomerySigned(d, root)
```

`a,b`가 `[0,p)`이고 모든 소수가 `p < 2^31`이므로 `d`는 signed 32-bit에
정확히 들어간다. Montgomery 곱셈은 모듈러 합동을 보존하므로 곱셈 전에
`p`를 더하는 작업은 필요하지 않다. rounding Montgomery의 VMUL,
두 VQRDMULH, VHADD 및 결과 정규화는 그대로 유지한다. 결과만 한 번
`[0,p)`로 되돌리므로 다음 butterfly의 입력 계약도 바뀌지 않는다.

- `mp_NTT()`: M1과 같은 연산 순서 유지
- `mp_iNTT()`: GS의 `MP31_SUB`를 직접 `VSUB.I32`로 교체
- 각 정적 GS 전개에서 `VPT.S32`와 `VADDT.I32` 하나씩 제거
- 전체 iNTT 본문에서 `VPT` 27 -> 18, `VADDT` 27 -> 18
- gm/igm, 레이어 병합, stage-wise halving, 메모리 형식은 변경하지 않음
- Plantard, 추가 lazy layer, 최종 일괄 scaling, Slothy는 포함하지 않음

## 정확성 검사

| 검사 | 결과 |
|---|---:|
| 독립 정수 모델 | 308 primes, 15,769,600건, mismatch 0 |
| 그중 signed-difference 입력 | 8,830,976건, mismatch 0 |
| 실제 M55 Montgomery 매크로 | 18,923,520건, mismatch 0, range error 0 |
| 실제 M55 NTT/iNTT | 308 primes x logn 4..10 = 2,156 transforms, 모두 0 mismatch |
| q=12289 NTT 회귀 | degree 512/1024 모두 mismatch 0 |
| 호스트 전체 test_fndsa/KAT | degree 2..10 PASS |
| 보드 KAT digest | host oracle와 일치 |
| 서명 검증/변조 거부 | PASS/PASS |
| CFSR/HFSR/AFSR | 모두 0 |

독립 모델은 [`check_m1_improve_model.py`](../check_m1_improve_model.py), 보드
감사 원본은
[`raw.log`](../results/m1_improve_audit/runs/pilot-20260914T120031Z/raw.log),
호스트 회귀 원본은
[`test_fndsa.log`](../results/m1_improve/host/test_fndsa.log)에 있다.

## 성능

측정 조건은 기존 M1과 같다.

- CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz
- I-cache/D-cache ON
- 동일 GCC 15.2.1, 동일 최적화·링커·DTCM 실행 설정
- degree별 10 warm-up, 10 batches x 10 calls = 작업별 100회
- 표의 값은 batch total을 10으로 나눈 값들의 upper median
- M1과 M1-improve의 `mp_NTT` 시작 주소는 모두 `0x10000330`
- M1과 M1-improve의 `mp_iNTT` 시작 주소는 모두 `0x10000684`

| degree | 작업 | M1 cycles | M1-improve cycles | 차이 | 변화율 |
|---:|---|---:|---:|---:|---:|
| 512 | keygen | 46,739,582 | 46,676,612 | -62,970 | -0.1347% |
| 512 | sign | 17,145,671 | 17,145,561 | -110 | -0.0006% |
| 512 | verify | 323,089 | 323,017 | -72 | -0.0223% |
| 1024 | keygen | 244,533,885 | 244,326,106 | -207,779 | -0.0850% |
| 1024 | sign | 36,737,446 | 36,737,445 | -1 | 약 0% |
| 1024 | verify | 624,920 | 624,908 | -12 | -0.0019% |

이 변경은 NTRU solve의 iNTT에만 사용되므로 의미 있는 차이는 keygen에서만
기대된다. sign/verify 차이는 코드 배치 또는 측정 해상도 수준으로 해석한다.

동일 seed의 배치별 keygen 대조에서도 M1-improve가 모두 빨랐다.

- degree 512: 10/10 승, 호출당 62,967~68,235 cycles 절감
- degree 1024: 10/10 승, 호출당 194,996~220,448 cycles 절감

M0와 비교한 누적 keygen 개선은 degree 512에서 148,191 cycles(0.3165%),
degree 1024에서 487,114 cycles(0.1990%)다. M0→M1의 rounding Montgomery
효과와 M1→M1-improve의 signed-difference 제거 효과를 합한 수치다.

본 측정 원본은
[`raw.log`](../results/m1_improve/runs/full-20260914T120108Z/raw.log)에 있다.

## 코드 크기와 스택

| 항목 | M1 | M1-improve | 차이 |
|---|---:|---:|---:|
| 성능 이미지 FLASH 사용량 | 108,156 B | 108,076 B | -80 B |
| ELF `text` | 169,548 B | 169,468 B | -80 B |
| 링크 RAM 데이터 | 225,728 B | 225,728 B | 0 B |
| 측정된 stack upper bound | 9,624 B | 9,624 B | 0 B |

## 상수시간 범위

[`audit_m1_improve_build.py`](../audit_m1_improve_build.py)로 M1과 기계어를
대조했다.

- scalar branch opcode 순서 동일
- load/store operand 구조 동일
- 제거된 명령은 고정 횟수의 `VPT`/`VADDT`뿐
- 새로운 데이터 의존 분기 또는 데이터 의존 주소 없음
- 성능 ELF에서 test-only multiplication probe가 제거됨

이는 정적 구조 검사이며 formal constant-time proof나 dudect/TVLA와 같은
동적 누설 검사는 아니다.

## 재현 명령

```sh
python3 check_m1_improve_model.py
./check_m1_improve_host.sh
./build_m1_improve.sh m1_improve_audit
./build_m1_improve.sh m1_improve
python3 audit_m1_improve_build.py
python3 run_m1_improve.py m1_improve_audit pilot
python3 run_m1_improve.py m1_improve pilot
python3 run_m1_improve.py m1_improve full
```

성능 ELF SHA-256:
`06ada2ab3feef9108a096eeb4dc9074bcf9c8695aa8c175f7dc173d131982547`

감사 ELF SHA-256:
`35a45f9de26661f3c80da6340ea205b7ee660099967083a10f95109dbdbce329`

어셈블리 SHA-256:
`84dea93a6feec84a359e20e3614906329cc7345e91330c0b2333068045780969`
