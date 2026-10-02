# M55 TCM 시작 오류 원인 조사 — 2026-09-10

최신 문서 대조: [RM0486/공식 예제/Arm TRM과 설정 비교](manual_crosscheck.md).

최신 원인 조사: [확장 ITCM wait-state 의존성 분리](root_cause_waitstate.md).
후속 69개 독립 사례에서 읽기 시 ITCM 기본 wait-state 설정이 실패/정상을
가르는 것을 확인했다. 아래 내용은 그 전 단계의 주소 배치 조사 기록이다.

후속 갱신: 사용자 요청으로 [로컬 메모리/시작 초기화 수정](workaround.md)을
적용했고 두 번의 파일럿이 통과했다. 아래는 수정 전 원인 분리 실험 기록이다.

## 결론

**동일한 명령 바이트·동일한 입력에서도 코드와 읽을 데이터의 확장 ITCM 위치
조합에 따라 ECC 오류가 발생함을 독립 테스트로 재현했다.** FN-DSA API와
Zephyr 전체 실행 없이도 발생하며, MVE 없는 정수 LDM/STM 복사에서도 재현된다.
따라서 FN-DSA 수학 연산, M4 전용 어셈블리, 단순한 MVE 미지원 때문에 생긴
오류로 설명할 수 없다.

현재 확인한 직접적인 실패 조건은 **서로 다른 64 KiB 확장 ITCM 창에 있는
명령 실행과 데이터의 연속 읽기 조합**이다. 이 표현은 시험한 주소 조합에 대한
관찰이며, 모든 bank/접근 패턴을 포괄하는 실리콘 결함 명세가 아니다.
ST FLEXMEM 통합 하드웨어의 제한인지, 추가 설정이 필요한지는 아직 미확정이다.

## 결정적인 통제 실험

원본 측정 ELF의 Zephyr `memcpy` 376바이트를 그대로 복사해 아래 주소에서
실행했다. 함수 내부 분기는 모두 함수 안의 PC-relative 분기이며 외부 호출이나
literal pool은 없어 이 진단에서 동일한 바이트로 재배치했다. 원본 입력은
`0x100243b8`부터 140바이트, 목적지는 `0x30000000`이다. 실제 복사된 140바이트를
ELF의 `datas + device_states + k_mutex_area`와 바이트 단위로 대조했다.

| 코드 실행 위치 | 원본 MVE memcpy / 입력 ITCM `0x100243b8` | 정수 LDM/STM 복사 / 동일 입력 | 원본 MVE memcpy / 동일 바이트를 DTCM `0x30008000`에 배치 |
|---|---|---|---|
| AXISRAM `0x34081000` | 정확히 복사 | 정확히 복사 | 정확히 복사 |
| 기본 ITCM `0x10001000` | 정확히 복사 | 정확히 복사 | 정확히 복사 |
| 확장 ITCM 창 1 `0x1001302c` | **ECC fault** | **ECC fault** | 정확히 복사 |
| 확장 ITCM 창 2 `0x10021000` — 입력과 같은 창 | 정확히 복사 | 정확히 복사 | 정확히 복사 |
| 확장 ITCM 창 3 `0x10031000` | **ECC fault** | **ECC fault** | 정확히 복사 |

MVE 원본의 ITCM 입력 시험은 새 reset/load 세션에서 다시 수행해 같은 결과를
얻었다. 복사 시험은 **주소 조합당 1회** 실행한 원인 분리 시험이지 성능/안정성
장기 측정이 아니다. 성공은 정상 종료만이 아니라 140바이트 전체 일치까지
요구한다. 실패 시 부분 복사 데이터도 ELF와 달랐으며 유효 출력으로 인정하지 않는다.

원본 MVE 실패에서 반복 확인한 값:

```text
input   = 0x100243b8, length = 140
BFAR    = 0x100243e4
CFSR    = 0x00008200  (PRECISERR | BFARVALID)
HFSR    = 0x40000000  (FORCED)
AFSR    = 0x00020000  (PECC)
```

정수 LDM 시험도 CFSR/AFSR가 같고 BFAR는 `0x100243c4` 또는 `0x100243e4`였다.
Arm의 AFSR 정의에서 PECC는 수정 불가능 ECC에 따른 precise fault이다.
[Cortex-M55 r1p1 TRM, 표 5-4](https://documentation-service.arm.com/static/6622c173fabc8c11c7b53a92).

## 배제하거나 범위를 좁힌 가설

- **확장 TCM 미활성화/크기 부족:** ITCMCR/DTCMCR 모두 `0x49`이고,
  단일 LDR 시험 35개 조합 × 10,000회가 모두 통과했다. 다른 값을 각 주소에
  기록한 뒤 읽고 해당 창의 다른 코드로 분기하는 35개 조합 × 10,000회도
  모두 통과했다. 확장 영역 자체가 항상 접근 불가능한 상황은 아니다.
- **MVE만의 문제:** MVE가 전혀 없는 LDM/STM 루틴도 같은 창 조합에서 실패했다.
  따라서 단순 `MVE OFF`가 일반적인 해결책이라고 볼 수 없다.
- **FN-DSA/M4 구현 또는 Zephyr 스케줄러 문제:** 작은 AXISRAM 제어 코드가
  복사 루틴만 호출해도 재현된다. 암호 함수·Zephyr main·스케줄러는 실행하지 않는다.
- **800 MHz에서만의 문제:** 독립 시험은 클럭을 변경하지 않은 부트 상태이며,
  `RCC_CFGR1=0`, `HSICFGR=0x8c800000`은 HSI/1 선택(명목 CPU 64 MHz)이다.
  최종 재현에서 `CCR=0x201`로 I/D cache enable 비트도 꺼져 있었다.
  즉 이 오류에는 800 MHz 동작이 필요하지 않다. 이는 외부 계측으로 주파수를
  교정했다는 뜻은 아니다. 해석은 고정 ST HAL의 `SystemCoreClockUpdate()`와
  레지스터 정의에 따랐다.
- **전송 누락/단순 미초기화:** 이전 검사에서 ELF section 전체가 일치했고,
  모든 독립 시험도 CPU 정렬 STRD로 ITCM/DTCM 각 256 KiB를 초기화한 뒤
  적재했다. 위치만 바꾸면 동일 입력·명령으로 정확히 복사된다.

단일 LDR 통과와 LDM/MVE 연속 읽기 실패를 혼동하면 안 된다. 모든 스칼라
명령이 정상이라는 결론도, 모든 확장 ITCM 접근이 실패한다는 결론도 아니다.

## 기존 프로그램에서 왜 나타났나

실제 FN-DSA 측정 ELF의 `memcpy`는 `0x1001302c`에 있고 `.data` 초기값은
`0x100243b8`에 있다. 이는 독립 시험에서 실패한 조합과 동일하다. 원본 프로그램의
첫 fault 위치/주소/상태도 독립 시험과 일치했다.

기준으로 빌드한 ML-KEM OPT1 ELF는 ITCM 끝이 `0x1000f2b4`라 전체가 첫 64 KiB에
들어간다. 따라서 원본 ML-KEM startup이 통과하더라도 FN-DSA처럼 확장 ITCM의
여러 창에 코드/상수가 걸치는 실행이 안전하다는 증거는 아니다.

`memcpy`만 AXISRAM에서 실행한 이전 진단은 첫 복사를 넘긴 뒤
`z_sys_init_run_level`의 명령 fetch에서 FECC가 발생했다. 그러므로 memcpy 하나를
대체하는 것만으로 전체 FN-DSA 실행이 해결된다고 판단하지 않는다.

## 외부 자료와 판단 한계

ST 커뮤니티에도 STM32N657의 확장 ITCM 창을 가로지르는 접근에서 ECC 오류를
재현했다는 보고가 있다. 현재 관찰과 유사하나, 공개된 ST 답변은 Nucleo/DK에서
재현되는지 확인하는 질문이며 공식 결함 확인이나 해결책은 아니다.
[사용자 재현 보고와 ST 답변](https://community.st.com/stm32-mcus-products-25/reproducible-ecc-error-in-tcm-memory-following-a-certain-access-pattern-with-stm32n657i0-158561).

현재 보드 한 대·256/256 KiB 설정·시험한 주소/데이터에 관한 결과다. 다른 실리콘
revision/보드에서도 같은지, 정확한 내부 ECC 경로/타이밍 문제인지는 ST 확인이
필요하다. RAMCFG의 관찰값만으로 미설정이나 원인을 확정하지 않았다. 공식 RM0486
전체 PDF는 이번 환경에서 다운로드에 실패해 관련 본문을 직접 확인하지 못했다.

## 다음 조치 후보 — 아직 구현에 적용하지 않음

**코드는 ITCM, 읽을 상수/초기값은 DTCM에 두는 배치를 별도 진단 빌드에서
검증하는 것이 근거 있는 다음 단계다.** 데이터만 DTCM에 옮긴 독립 시험은
원래 실패한 코드 위치를 포함해 5/5 통과했다. 다만 이것은 전체 FN-DSA의
해결 보장이 아니며, 함수 내부 literal pool 등 남은 ITCM 데이터 읽기도 확인해야 한다.

이는 상수가 ITCM에 있던 기준 배치와 달라지므로, 적용할 경우 `mlkem-native`와
동일하다고 숨기지 말고 포팅을 위한 명시적 변경으로 기록해야 한다. 사용자의 이번
요청은 원인 조사이므로 실제 `ref`, 측정 ELF, 링크 배치, ECC/캐시/클럭을 바꾸는
해결 패치는 적용하지 않았고 새 성능 측정도 실행하지 않았다.

## 재현 자료

- [실험 소스](tcm_probe.s), [실행 스크립트](run_tcm_probe.py)
- [사후 감사 스크립트](audit_tcm_probe.py), [검증 JSON](tcm_audit.json)
- [단일 읽기 35개 통과](../runs/tcm-scalar-matrix-20260910T012837Z/results.json)
- [서로 다른 데이터와 분기 35개 통과](../runs/tcm-scalar-matrix-20260910T013038Z/results.json)
- [원본 MVE 복사 첫 재현](../runs/tcm-scalar-matrix-20260910T013405Z/raw.log)
- [정수 LDM/STM 복사 재현](../runs/tcm-scalar-matrix-20260910T013623Z/raw.log)
- [DTCM 입력 통제 시험](../runs/tcm-scalar-matrix-20260910T013742Z/raw.log)
- [원본 MVE 복사 반복 확인 및 캐시/클럭 상태](../runs/tcm-scalar-matrix-20260910T013948Z/raw.log)

초기 진단 harness 준비 실패(`012628Z`: reset/examine 전이,
`012739Z`: Thumb 함수 주소를 데이터 주소로 사용할 때의 정렬 문제)는 위 결과에
포함하지 않았다. 복사 시험의 초기 JSON에 남은 `iterations=10000`은 단일 읽기용
필드였고 복사는 각 1회다. LDM 시험의 초기 `actual_zephyr_memcpy` 표기도 분기
플래그를 재사용한 것이며 실제 명령은 저장된 disassembly의 순수 정수 루틴이다.
정확한 분류/횟수/바이트 검증은 최종 `tcm_audit.json`을 기준으로 한다.

모든 실험은 M55 시리얼 `003C00223335510735383531`만 사용했다. 각 독립 시험의
벡터/스택은 진단용 AXISRAM에 두고 IRQ를 막았으며, RAMCFG 상태를 읽기 위해
그 주변장치 클럭만 켰다. 매 시험 후 리셋하고 디버거를 종료했다. 이 조건들은
오류 분리용이며 성능 측정 조건이 아니다. M4 및 Flash는 수정하지 않았다.
