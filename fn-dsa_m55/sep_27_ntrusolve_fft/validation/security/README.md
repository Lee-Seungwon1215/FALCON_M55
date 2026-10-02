# A17 보안 검증 검토 — 2026-09-28

이 문서의 수치·36개 파일 불변 판정은 **정리 전 A17** 기록이다.
이후 미사용 소스를 제거한 현재 코드의 재검사는
[A17 정리 후 기록](../cleanup/README.md)에서 별도로 확인한다.
정리 전 통과를 변경된 소스의 재검사로 재사용하지 않는다.

## 판정

**사용자가 확정한 속도·오차·KAT·서명검증·상수시간의 다섯 항목 검사는 완료했다.**
2026-09-28 범위 명확화에 따라, 배포용 난수 연결·키 수명 관리·전력/전자기 및
fault injection 검사·전체 정형 증명은 이번 완료 조건에 포함하지 않는다.
아래의 배포 관련 미완료 목록은 다섯 항목 검사 완료를 막는 조건이 아니다.
단, 검사 완료는 오차 0이나 전체 보안 인증을 뜻하지 않는다.
실행한 검사에서는 후보 판정 불일치, 정상 서명 실패, 변조 허용, 가드 훼손 또는
설정한 통계 기준을 넘는 invnorm 시간차를 발견하지 못했다. 그러나 이를
모든 입력의 정확성·상수시간·물리적 부채널 안전성 증명으로 바꾸어 말하지 않는다.

### 요청한 다섯 항목의 최종 정리

| 항목 | A17 결과 | 해석 |
| --- | --- | --- |
| 속도 | 전체 키생성: M55_ref 대비 512 **1.2197배**, 1024 **1.1674배**; Q32 입출력 포함 invnorm 약 **3.94배** | 전체 배율은 기존 NTT + NTRU FFT + 후보 invnorm의 누적 효과; 1.7배 목표는 미달 |
| 오차 | 기존 invnorm 비교 최대 **4 Q32 LSB**; 추가 실제 후보 8,832쌍에서 판정 불일치 **0** | 추가 3,186,560개 값 중 1개는 1 LSB 차이. 모든 중간값의 비트 동등성은 아님 |
| KAT | 원본 **300/300**, 독립 입력 **300/300** 통과 | 현재 A17 소스와 대응하는 기록 |
| 서명검증 | 기존 서명 KAT **90/90**; 추가 정상 **64/64**, 부정 입력 **3,902/3,902** 거부 | 실제 M55 본체 실행 |
| 상수시간 검사 | 기존 변경 커널의 코드/ELF·입력군 검사에 더해 invnorm **20만 회**, 최대 절대 Welch t **1.3952 < 5** | 시험 범위에서 시간차 미검출. 전체 키생성은 후보 재시도 때문에 seed별 시간이 다름 |

성능과 기존 검사의 원시 기록은 [A17 결과](../invnorm_results.md), 변경 커널의
시간 검사 이력은 [상수시간 검사 기록](../ct_results.md), 추가 검사는 아래에 있다.
범위 명확화 시에는 소스·ELF·로그 해시와 통계 집계를 재확인했으며,
보드 측정을 새로 실행하거나 암호 코드를 변경하지 않았다.
`summary.json`의 `INCOMPLETE_SECURITY_ASSESSMENT`는 더 넓은 보안 보증 상태이며,
위 다섯 항목 검사가 실행되지 않았거나 KAT가 실패했다는 뜻이 아니다.

A17의 암호 소스 `.c/.h/.s` **36개는 보존된 A17 해시와 모두 동일**하다.
이번 작업은 검증 코드와 기록만 추가했으며, 원본·A16·A17의 산술이나
NTT/FFT/서명/검증 구현을 변경하지 않았다. 이전 성능 수치는 그대로이며,
새 보안 검사 펌웨어의 실행 시간을 전체 성능 수치로 대체하지 않는다.

## 결과 요약

| 항목 | 실제 수행·관찰 | 판정 범위 |
| --- | --- | --- |
| 기존 KAT/정확한 NTRU 방정식 | 보존된 원본 300 + 독립 입력 300건 통과, 현재 소스 해시 재확인 | 이 600개 입력에 대한 증거; 이번에 다시 600개를 실행한 것은 아님 |
| 기존 서명 KAT | 보존된 90건 통과, 현재 소스 해시 재확인 | 기존 벡터에 대한 증거 |
| 실제 Gaussian 후보 비교 | 8,832쌍, 합격/탈락 판정 차이 0 | 전처리 필터에서 탈락할 후보도 포함한 넓은 집합; 모두 최종 키는 아님 |
| invnorm 중간값 | 3,186,560개 중 1개가 원본과 1 Q32 LSB 차이 | 원본 raw 비트 완전 동등성은 아님 |
| 수치 사용 범위 | 시험한 분모가 양의 normal이고 역수가 signed Q32 범위에 들어감 | 모든 가능한 후보에 대한 범위 증명은 아님 |
| 신규 전체 API 검사 | 512/1024 각각 32개 키, 정상 서명·검증 총 64건 통과 | A17 본체와 M55 어셈블리 실제 실행 |
| 신규 부정 입력 검사 | 3,902건 전부 거부 | 서명/공개키/메시지/context 변조, 길이 오류, 빈 임시 버퍼 |
| M55 배열 경계·입력 불변 | 기록된 가드 훼손 0, invnorm 입력 변경 0 | 가드는 경계 밖 읽기 및 전체 stack 사용을 증명하지 못함 |
| UBSan + float-cast-overflow | 호스트 C 경로의 8,832쌍 검사 통과 | M55 어셈블리는 호스트 sanitizer 대상 아님 |
| AddressSanitizer | 런타임 초기화 실패, 최소 대조 프로그램도 main 진입 전에 같은 실패 | **미완료**, 통과로 계산하지 않음 |
| invnorm 통계적 시간 검사 | 20만 측정, 최대 절대 Welch t = 1.3952, 탐지 기준 5 미만 | 시험한 입력군에서만 차이 미검출; 보편적 CT 증명 아님 |
| 수동 코드/ELF 검토 | invnorm의 공개 e 분기·공개 길이 반복, native FP64 명령 확인 | 전체 프로그램 정보흐름 정형 검증 아님 |
| 보드 fault/ECC | 새 두 실행 모두 오류 레지스터 0, 기존 cache/TCM/ECC 정책 유지 | fault injection 저항성 검사가 아님 |
| 실서비스 난수 연결 | 현 M55 빌드의 sysrng는 길이 > 0이면 실패 반환 | seeded 벤치마크용 환경; 배포 준비 미완료 |

## 수치 차이의 원인 확인

같은 SHAKE seed와 원본 Gaussian `sample_f()`를 사용하고, 원본 고정소수점 FFT
출력을 두 invnorm 함수에 동시에 넣었다. 두 결과 각각에 원래의 켤레·상수곱·
self-adjoint 곱·iFFT·노름 계산을 적용해 최종 후보 판정을 비교했다.
`logn=2..7` 각각 64쌍, `logn=8` 256쌍, `logn=9/10` 각각 4,096쌍이다.
작은 비표준 크기는 테스트 커버리지일 뿐, 안전한 배포 크기로 권장하지 않는다.

실제 샘플 `logn=9, sample=3620, index=30`에서 다음 차이를 재현했다.

| 항목 | Q32 raw word |
| --- | --- |
| a.real | `fffffff469c622d9` |
| a.imag | `00000002dbd685be` |
| b.real | `fffffffe4abcf58d` |
| b.imag | `000000030d372d77` |
| 원본 invnorm 결과 | `0000000001a7c065` |
| A17 invnorm 결과 | `0000000001a7c064` |

Python 정수/Fraction으로 독립 계산했다. 네 Q32 입력을 정확한 유리수로 해석한
제곱합은 `2852911963779576992239 / 18446744073709551616`이고, 원본처럼 각
제곱을 Q32로 버림한 분모 raw는 `0x9aa81b5bac`이다. 이 두 분모의 역수를
각각 Q32로 반올림하면 위의 A17/원본 결과가 정확히 재현된다.
**이 사례는 캐리 누락이 아니라 제곱별 버림 규칙의 차이**다.
이는 이 한 사례의 원인 확인이지, 모든 FP 오차 사례의 증명은 아니다.

이로 인한 최종 노름 차이의 관찰 최대값은 약 `0.00027469`이었다.
시험 집합에서 원본 노름과 판정 경계의 최소 거리는 512에서 `0.35427`,
1024에서 `0.10814`였고 판정 반전은 없었다. 이 최소 거리는 관찰값이며,
다른 seed에서도 같은 여유가 존재한다고 가정해서는 안 된다.

전체 안전성 결론에는 모든 허용 후보의 FP64/2×FP32 오차 상한과 판정 경계,
분모·변환 범위 분석이 더 필요하다. KAT 일치는 이러한 분석의 대체물이 아니다.

## 시간 검사와 ELF 검토

입력 준비와 입력군 선택은 타이머 밖에 두고, 같은 주소의 버퍼에서 같은
준비 호출을 한 후 invnorm 함수 전체를 측정했다. IRQ 마스킹, 캐시 OFF,
800 MHz, ITCM 코드/DTCM 데이터 조건이다. 각 크기·입력군에서 20,000회,
총 200,000회이며, 두 class 순서는 무작위로 섞었다.
준비 호출 200,000회는 통계 표본 수에 포함하지 않는다.

| 입력군 | 512 Welch t | 1024 Welch t |
| --- | ---: | ---: |
| 동일 입력에 임의 class 부여: 음성 대조 | -0.2220 | -0.6832 |
| 고정 Gaussian spectrum 대 무작위 Gaussian spectrum | 1.0482 | 0.3347 |
| 구성한 정수 크기 차이 | -1.3952 | 1.3261 |
| f=g=1의 spectrum 대 Gaussian spectrum | 0.9563 | -0.3040 |
| 정수 대 작은 분수: normal·Q32 표현 가능 입력 | 0.5537 | -0.5442 |

이번 ELF에서 512는 117,838~117,839 cycles, 1024는 235,598~235,599 cycles였다.
계측 펌웨어 배치가 다른 이전 커널 ELF와의 1-cycle 차이를 새 성능 변화로 해석하지 않는다.
앞선 3입력군/120,000회 실행도 보존했다. 이를 최종 5입력군의 독립 반복으로
잘못 합산하지 않고, 위 표는 마지막 실행 200,000회만 사용한다.

합·제곱합은 정수로 누적하고 분석 시 Fraction을 사용해 큰 값의 차에서 발생하는
상쇄 오차를 피했다. 원시 합계, 분산, class별 개수는 [summary.json](summary.json)에 있다.
일차·비절삭 Welch 검사이며, 다중 절삭/고차 검사를 포함한 완전한 dudect 실행은 아니다.
방법과 한계는 [dudect 저자 구현](https://github.com/oreparaz/dudect)을 참고했다.
그 문서 역시 검사 통과가 상수시간 증명이 아니라고 명시한다.

링크된 invnorm은 `VMUL.F64`, `VMLA.F64`, `VADD.F64`, `VDIV.F64`,
`VRINTM.F64`, `VCVT`를 사용한다. native 경로에 소프트웨어 double 호출은 없고,
분기는 공개 `e`와 공개 길이 반복에 해당한다. 원본 FFT의 Q32 버림, inverse half,
공개 회전상수 기반 assembly dispatch도 소스 및 기존 설명과 대조했다.
packed 메모리 모델은 254 coefficient block/127 root block, root 곱 모델은
1,024,528건을 다시 통과했다. 이러한 수동 검토·모델 검사는 ARM 명령어 전부의
정형 의미 검증이나 레지스터/메모리 전체 정보흐름 증명이 아니다.

전체 키생성은 원래 후보 거부·재시도가 있어 seed마다 시간이 다르다.
이번 결과를 전체 키생성 고정 시간이나 전력/전자기 누설 방지로 표현하지 않는다.

## 이번 요청 범위 밖: 실제 배포 전에 남은 항목

1. **수치 안전성**: FP64 invnorm 및 retained depth0 2×FP32 경로에 대해
   허용 입력 범위와 최악 오차·판정 여유를 분석해야 한다. 현재 유한 KAT와
   후보 비교만으로 모든 seed의 원본 동등성 또는 출력 안전성을 증명하지 못했다.
2. **메모리/stack**: ASan 실행 환경을 복구하거나 별도 지원 환경에서 검사하고,
   MVE 경계 밖 읽기와 전체 호출 경로 stack 최대량을 검증해야 한다.
   보드의 `CONFIG_HW_STACK_PROTECTION=y`, 64 KiB main stack 예약, 가드 통과는
   이 증명의 대체물이 아니다. 현재 `CONFIG_INIT_STACKS`는 꺼져 있다.
3. **부채널**: 현재 통계는 invnorm에 대한 유한 타이밍 검사다. 전체 경로의
   정보흐름 검토와 목표 위협모델에 맞는 전력/EM·fault 검사는 완료하지 않았다.
   물리 측정에는 별도 계측 장비와 실험 구성이 필요하다.
4. **난수·키 수명 관리**: 현재 `sysrng.c`는 Unix/Windows RNG 구현만 갖고,
   이 M55 빌드에서 nonzero 길이는 0(실패)을 반환한다. 실제 object도
   `clz r0,r1; lsrs r0,r0,#5; bx lr`로 확인했다. 예측 가능한 seed로
   자동 대체하지 않고 실패하는 구조지만, seeded 벤치마크가 난수원 검증을
   대신하지는 않는다. 실제 서비스는 검증된 엔트로피 공급 방법을 정해야 한다.
   `sign.c`의 temporary-area zeroization은 원래부터 호출자 책임이며,
   키 삭제·디버그/로그 접근 정책도 배포 환경에서 정해야 한다.

이 항목들은 모두 A17이 새로 만든 취약점이라는 뜻이 아니다. 라이브러리
최적화 실험의 통과 결과와 시스템 배포 보안 승인을 구분하기 위한 미완료 목록이다.
알고리즘/플랫폼 정책을 임의 변경하지 않았으며, 외부 보안 감사나 ST 문의도 보내지 않았다.

## 재현과 증거

- [최종 invnorm M55 로그](../results/A_tw_bridge/security_invnorm/20260928T040218Z/raw.log),
  [manifest](../results/A_tw_bridge/security_invnorm/20260928T040218Z/manifest.json)
- [추가 전체 API M55 로그](../results/A_tw_bridge/security_api/20260928T040141Z/raw.log),
  [manifest](../results/A_tw_bridge/security_api/20260928T040141Z/manifest.json)
- [첫 3입력군 실행](../results/A_tw_bridge/security_invnorm/20260928T035648Z/raw.log)
- [호스트 UBSan](results/host_ubsan_20260928T040422Z/manifest.json)
- [수치 차이 재현](results/host_witness_20260928T040521Z/raw.log)
- [ASan 실패](results/host_asan_20260928T040039Z/raw.log),
  [FN-DSA 없는 최소 대조 프로그램의 동일 실패](results/host_asan_probe_20260928T040420Z/raw.log)
- [집계·정확한 유리수 비교](summary.json), [링크된 assembly](A17_disassembly.txt),
  [assembly 출처](disassembly_manifest.json), [RNG object](sysrng_disassembly.txt)
- 기존 24개 A/B 검증 로그의 무결성 및 baseline 63개 파일 불변 재확인:
  `python3 -B validation/verify_evidence.py` → `EVIDENCE_OK runs=24 baseline_files=63`.

```sh
bash validation/build.sh A_tw_bridge security_invnorm
bash validation/build.sh A_tw_bridge security_api
# 보드 실행은 같은 measurement venv의 python으로 순차 실행한다.
python -B validation/run_board.py A_tw_bridge security_invnorm
python -B validation/run_board.py A_tw_bridge security_api
python3 -B validation/security/run_host.py ubsan
python3 -B validation/security/run_host.py witness
python3 -B validation/security/analyze.py 20260928T040218Z 20260928T040141Z
```

현재 상태를 논문에 적는다면 **“원본/독립 KAT 및 기능·경계 검사 통과,
시험한 입력군에서 유의한 invnorm 시간차 미검출”**이라고 한정한다.
**“모든 입력에 대해 동등함”, “보안 검증 완료”, “부채널 안전성 증명”**은 쓰지 않는다.
