# Before_slothy NTT 정리·통합 재검증

측정일: 2026-09-28. 이 문서는 **Final_code/Before_slothy에서 직접 컴파일한 결과**이다.
기존의 2026-09-13 공통 NTT 측정 문서는 정리 전 백업에 보존했다.

## 유지한 구현과 정리 범위

- 공통 q-NTT/iNTT: S1B_S2B_S3A.
- RNS NTT/iNTT: **K4C**. 계산 명령과 수동 스케줄 유지.
- 키생성 FFT: **A17** 유지.
- **SLOTHY 미적용**. After_slothy와 원 연구 후보는 수정하지 않았다.

제거: 미사용 `fndsa_stage3_mul_probe`, 동일한 매크로의 중복 정의,
일반 루프의 도달 불가능한 512 전용 분기, `mq.c`의 폐기된 `#if 0` 함수.
실제 서명에서 사용하는 `mqpoly_sqnorm_int_to_signed`의 ASM 구현은 유지했다.

주석: K4C 계보, Barrett 곱셈, full inverse root `wR` 및 최종 `1/n` 계약을 명확히 했다.
M55 설정은 `fndsa_m55_config.h`에 고정했다. Makefile은 이 경로의
20개 C + 7개 ASM 파일을 직접 빌드하며 외부 후보를 가져오지 않는다.
M4/Windows용 복사 Makefile은 제거했고 정리 전 백업으로 복구할 수 있다.

## 컴파일 결과 비교

[객체 비교 보고서](../validation/build/object_audit/report.json).

| 대상 | 정리 전 | 정리 후 | 확인 |
|---|---:|---:|---|
| mq_cm55.s text | 10,420 B | 10,328 B | **92 B 감소** |
| kgen_mp31_cm55.s text | 3,856 B | 3,856 B | 코드 동일 |
| 나머지 포함 총 26개 객체 | — | — | 할당되는 코드·상수 섹션 byte-identical |

위 비교는 독립 객체의 섹션 바이트 비교이며 최종 ELF 전체 동일성을 뜻하지 않는다.
분기·진단 코드를 삭제하여 공통 NTT 및 이후 함수의 링크 주소는 달라질 수 있다.
이 때문에 실제 보드 회귀검사를 추가했다.

빌드는 성공했다. 기존 upstream `fndsa.h`의 미사용 static 함수 경고와
측정용 printf 래퍼 관련 경고는 남아 있으며, 이번 정리에서 경고를 숨기는 옵션은 추가하지 않았다.

## 실제 M55 검사

| 항목 | 결과 |
|---|---|
| 공통 NTT/iNTT | logn=2..10의 C oracle·왕복 검사: 모듈러 오차 0 |
| RNS rounding Montgomery | 18,923,520 lane 검사: 불일치 0, 범위 오류 0 |
| RNS NTT/iNTT | 308개 소수 × logn=4..10 = 2,156 변환 쌍: 정·역변환 및 왕복 불일치 0 |
| RNS 경계·버퍼 검사 | 17,248건: 불일치 0, guard 오류 0 |
| 원본 키생성 KAT | 300/300 일치, NTRU 방정식 검사 통과 |
| 추가 키생성 KAT | 300/300 일치 |
| 서명 KAT | 90/90 일치, 정상 서명 수락·변조 서명 거부 |
| API 입력 검사 | 정상 64건 통과, 잘못된 입력 3,902건 거부, guard 오류 0 |
| 키생성 성능 실행 | 512·1024 각 100회, KAT/NTRU 방정식 불일치 0 |
| 하드웨어 | 정상 완료한 모든 실행에서 CFSR/HFSR/AFSR=0, TCM/ECC 설정 확인 |

상수시간 관련 변경 검토: 새 비밀 의존 분기나 주소 계산은 추가하지 않았다.
삭제한 분기는 공개 크기·루프 단계만 검사하던 부분이며, RNS 산술은 객체 코드가 동일하다.
**이번 작업은 전체 상수시간의 형식적 증명이나 새 Welch/전력·EM 검증을 수행했다는 뜻이 아니다.**
RNS 작은 C 경로(logn<4)는 이번 독립 RNS 커널 표에 포함하지 않았으며 전체 키생성 KAT에서 실행된다.

첫 NTT 실행은 새 시험 드라이버가 지원하지 않는 logn=1을 호출해 fault가 발생했다.
원 ASM도 logn>=2를 전제로 한다. 드라이버를 실제 지원 범위로 수정한 뒤 위 전체 검사를 재실행했다.
이 실패 로그는 숨기지 않고 남겼으며 정상 결과에 포함하지 않았다:
[초기 잘못된 입력 시험](../validation/results/ntt/20260928T060205Z/raw.log).

## 키생성 성능 확인

단위는 전체 seeded keygen **평균 cycle/call**이다. 실패 후보·재시도·공개키·인코딩 포함.
각 크기 100개 기존 KAT seed, warm-up 3회. 검증·출력은 측정 구간 밖이다.

| 크기 | 현재 정리 후 평균 | upper median |
|---|---:|---:|
| 512 | 51,436,753.62 | 43,554,656 |
| 1024 | 224,197,403.73 | 176,858,694 |

참고로 [기존 A17 정리 후 기록](../../fn-dsa_m55/sep_27_ntrusolve_fft/validation/cleanup/README.md)은
51,437,073.05 / 224,191,126.63 cycles였다.
현재 값의 차이는 각각 **−0.00062% / +0.00280%**로, 실질적인 개선·퇴보로 해석하지 않는다.
이것은 동일 시험 프로그램·입력·설정의 이전 기록과의 참고 비교이지, 함수 주소를 고정한 새 A/B 실험은 아니다.
이번 작업에서 전체 서명·검증의 성능은 새로 측정하지 않았다.

## 측정 조건

- NUCLEO-N657X0-Q / STM32N657, ST-Link `003C00223335510735383531`.
- CPU / SYSCLK / HCLK: **800 / 400 / 200 MHz**.
- 코드 ITCM, 상수·데이터·스택 DTCM, 각각 256 KiB; I/D cache OFF, ECC ON.
- GNU Arm GCC 15.2.1, Zephyr 4.4.1, `-O3 -mfpu=fpv5-d16 -mfloat-abi=hard`,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`.
- keygen 시험 ELF: ITCM 예약 111,716 B, DTCM 예약 213,224 B.
  링커의 FLASH/RAM 표시는 이 구성에서 각각 ITCM/DTCM 주소 영역의 별칭이다.
- RNS 곱셈 probe는 독립 섹션이므로 시험에서만 유지된다. keygen ELF에서는 제거됨을 확인했다.
- 생산 소스는 이 경로의 파일만 사용. 기존 검사 코드·fixture와 플랫폼 지원만 재사용했다.

## 로그와 재현

각 실행 디렉터리의 `manifest.json`에는 소스·ELF·로그 SHA-256, 컴파일 명령과 검사 결과가 있다.

- [NTT/RNS](../validation/results/ntt/20260928T060350Z/raw.log)
- [원본 KAT](../validation/results/kat/20260928T060357Z/raw.log)
- [추가 KAT](../validation/results/extra/20260928T060442Z/raw.log)
- [서명 KAT](../validation/results/sigkat/20260928T060525Z/raw.log)
- [API 검사](../validation/results/api/20260928T060536Z/raw.log)
- [키생성 성능](../validation/results/keygen/20260928T060558Z/raw.log)
- [재현 도구 설명](../validation/README.md)

[정리 전 전체 백업](../validation/snapshots/Before_slothy_before_ntt_cleanup.tar.gz)의 SHA-256:
`fcad6972156e3960b18e8a14eb56929b14b3124346c3c9f15c1ea888e8c69894`.
