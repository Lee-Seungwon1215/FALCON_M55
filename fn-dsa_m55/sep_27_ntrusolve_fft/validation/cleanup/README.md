# A17 소스 정리와 재검증 — 2026-09-28

현재 코드: `../../A_tw_bridge`. 미사용 코드 삭제·선언/주석 정리이며 새로운
산술 최적화나 SLOTHY 적용이 아니다. 회전상수 패딩 압축도 하지 않았다.

## 변경 내용

- 호출되지 않던 native FP64 FFT/iFFT와 주변 보조 함수, DS 연속 계산 실험
  함수 및 해당 선언을 제거했다. 미사용 `kgen_ds_q32.h`도 제거했다.
- C/assembly 선언을 로컬 `kgen_fft_cm55.h`로 모으고 매개변수 의미를 적었다.
- 실제 구조가 double 입출력/2×FP32 MVE FFT라는 점과 logn<4 경계를 명시했다.
- `poly_big_to_fixed()`와 double/DS 경계의 가독성을 정리했다.
- `mq_cm55.s`의 미사용 `fndsa_stage3_mul_probe` 진단 함수만 제거했다.
  NTT 본체와 다른 어셈블리는 그대로다. 현재 검증에서 사용하는 두 공유 매크로
  테스트 진입점은 유지하며 키생성 ELF에는 들어가지 않는다.

삭제한 코드와 헤더는 [정리 전 A17 전체 스냅샷](../source_snapshots/A17_fp64_invnorm.tar.gz)에서
복구할 수 있다. [이전 README](README_before_cleanup.md)도 보존했다.

## 변경 범위 확인

`python3 -B validation/cleanup/check.py`는 보존된 A17의 해시를 확인하고,
변경한 C·헤더 안에 남은 함수 **126개**의 실행 토큰을 비교한다. 공백/주석과 기존 if/else의
중괄호 추가를 제외한 계산식은 동일하다. 원본 Q32 및 DS 회전상수는 바이트 단위로
동일하며, 변경하지 않은 파일과 어셈블리도 검증한다. 이 검사는 정형 의미 증명이 아니다.
[검사 결과와 현재 소스 해시](scope.json).

## 재검증 완료

최종 소스로 15개 측정/검사 모드를 다시 빌드하고 연결된 NUCLEO-N657X0-Q에서
실행했다. 정리 전 통과 기록을 이어받지 않고, 각 로그·ELF·현재 암호 소스 36개를
해시로 연결했다. [전체 실행 목록과 집계](summary.json),
[정리 후 소스 스냅샷](../source_snapshots/A17_cleanup.tar.gz).

조건은 기존과 같다: CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz,
ITCM/DTCM 각각 256 KiB, 코드 ITCM·상수/데이터/스택 DTCM, 캐시 OFF·ECC ON,
GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard`,
`-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
정리 작업은 빌드 선택 옵션이나 다른 후보 소스 연결을 추가하지 않았다.

| 요청한 검사 | 정리 후 결과 |
| --- | --- |
| 속도 | 크기별 워밍업 3회 뒤 키생성 100회. 아래 표처럼 정리 전과 사실상 동일 |
| 오차 | 고정소수점 FFT/iFFT 5,120건 일치. 나눗셈 1,018,184값, 회전상수 곱셈 1,001,024값 검사 통과. FP64 invnorm의 기존 수치 차이는 아래에 별도 명시 |
| KAT | 기본 300 + 추가 300 = **600/600 일치**. 성능·프로파일링의 각 200개 키도 불일치 없음 |
| 서명·검증 | 서명 KAT **90/90**, 정상 API **64/64** 통과, 잘못된 입력 **3,902/3,902** 거부 |
| 상수시간 관련 검사 | invnorm 5종 비교 × 2개 크기 × 20,000회 = **200,000회**. 최대 `abs(t)=2.8256 < 5`, 설정한 Welch 경고 기준 미검출. 전체 상수시간 증명은 아님 |

입력 변환 220,672건, 쌍 변환 68,608건, 조건 처리 220,672건과 기존 커널
640건도 통과했다. 모든 보드 실행은 `CFSR=HFSR=0`으로 끝났다.
호스트 UBSan 검사도 오류 없이 끝났다.

### 수치·타이밍 검사의 정확한 의미

- FP64 invnorm 일반 시험: 130,944개 값 중 7개가 기존 고정소수점과 다르고,
  최대 차이는 **4 Q32 LSB = 약 9.31×10⁻¹⁰**이다. 640건의 후보 판정 차이는 0이다.
- 실제 Gaussian 후보 8,832개, 계수 3,186,560개 시험: 1개 값에서 1 LSB 차이,
  후보 판정 차이 0이다. 이는 정리 전과 같은 결과이며 모든 입력의 중간값 동등성을
  뜻하지 않는다. [상세 집계](security/summary.json).
- 해당 차이의 단일 입력 재현은 정수 캐리 유실이 아니라 제곱 후 Q32 절삭 규칙 차이임을
  확인했다. [호스트 재현 로그](../security/results/host_witness_20260928T045803Z/raw.log),
  [UBSan 로그](../security/results/host_ubsan_20260928T045802Z/raw.log).
- 단순 입력군 순차 측정에는 1~2 cycle 범위 차이가 남는다. 주소를 고정하고 순서를
  무작위화한 추가 invnorm 시험에서는 위 Welch 기준을 넘지 않았다.
  첫 번째 차수의 유한 표본 검사이며, 완전한 dudect/비간섭 증명이나 전력·전자기 검사가 아니다.
  키생성 전체는 후보 거절·재시도로 실행 시간이 달라진다.

분석 JSON의 `INCOMPLETE_SECURITY_ASSESSMENT`는 더 넓은 보안 인증을 완료했다는
주장을 하지 않는다는 의미다. 요청한 다섯 항목의 회귀검사는 위 한계를 명시하고 완료했다.

## 성능·크기 변화

단위는 키생성 한 번의 평균 cycles이다. 계측을 넣은 profile 시간이 아닌 별도
keygen 실행값을 사용했다.

| 크기 | 정리 전 A17 | 정리 후 A17 | cycle 변화 | 기존 M55_ref 대비 배율 |
| --- | ---: | ---: | ---: | ---: |
| 512 | 51,437,565.73 | 51,437,073.05 | −0.000958% | 1.2197× |
| 1024 | 224,193,235.43 | 224,191,126.63 | −0.000941% | 1.1674× |

약 0.001% 차이를 새로운 성능 개선으로 해석하지 않는다. M55_ref 대비 배율은
이전 동일 조건 기준 기록과 비교한 **NTT + FFT + invnorm의 누적 효과**이며,
이번 정리만의 효과도 FFT만의 효과도 아니다. 1.7× 목표는 아직 달성하지 않았다.
FP64 invnorm의 Q32 입출력을 포함한 속도는 512/1024 모두 기존 함수 대비 약 3.94×로 유지됐다.

- 암호 소스: **40,680 → 39,888줄**, **792줄 감소**. 바이트 수는 25,811 감소.
- 키생성 ELF `text`: **110,988 → 110,924 B**, 미사용 진단 함수 **64 B 감소**.
  다른 삭제 함수는 기존에도 최종 실행 파일에 포함되지 않았으므로 소스 감소만큼 ELF가 줄지는 않는다.
- `rodata=81,352 B`, `datas=76 B`, `bss=61,351 B`, `noinit=67,904 B`: 모두 동일.
  이 수치 자체가 최악 스택 사용량의 증명은 아니다.
- 회전상수의 8 KiB 패딩은 유지했다. 12-byte stride 어셈블리를 바꾸는 작업은
  단순 정리가 아닌 별도 최적화이므로 이번에 섞지 않았다.

## 주요 원시 기록

나머지 15개 실행 전체 경로는 [summary.json](summary.json)에 있다.

- [키생성](../results/A_tw_bridge/keygen/20260928T045736Z/raw.log)
- [기본 KAT](../results/A_tw_bridge/kat/20260928T045823Z/raw.log),
  [추가 KAT](../results/A_tw_bridge/extra/20260928T050051Z/raw.log)
- [서명 KAT](../results/A_tw_bridge/sigkat/20260928T050140Z/raw.log),
  [API 정상·음성 검사](../results/A_tw_bridge/security_api/20260928T050358Z/raw.log)
- [invnorm 일반 검사](../results/A_tw_bridge/invnorm/20260928T050301Z/raw.log),
  [실제 후보·추가 타이밍 검사](../results/A_tw_bridge/security_invnorm/20260928T050423Z/raw.log)
- [전체 성능·프로파일링 결과](../../result.md)

검증 집계 재생성 명령(프로젝트 루트 기준):

```sh
python3 -B validation/check_scope.py
python3 -B validation/report.py
python3 -B validation/verify_evidence.py
python3 -B validation/cleanup/summarize.py
```

빌드는 완료됐으나 원래 공개 헤더의 미사용 static 함수
`fndsa_hashed_vrfykey_from_signkey` 경고는 남아 있다. 이번 정리에서 공개 API는 바꾸지 않았다.
