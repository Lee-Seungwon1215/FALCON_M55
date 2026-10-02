# H1 — M55 빌드·측정 도구

현재 H1은 **최신 L2에 final scaling을 직접 구현한 후보**다.
2026-09-15 보드 검증·측정을 완료했으며 수치와 로그는 [결과 보고서](../result.md)에 있다.
이 문서는 재실행 도구 사용법이다.

## 구현과 측정 도구의 분리

암호 C/헤더/어셈블리는 상위 `H1_final_scaling/`에서 직접 사용한다.
`kgen_mp31_cm55.s`와 `mq_cm55.s`도 반드시 이 폴더의 파일을 빌드한다.
다른 후보의 소스·오브젝트를 가져오거나 링크로 알고리즘을 선택하지 않는다.

최신 L2의 `build_layer.sh` / `run_layer.py`와 같은
`fn-dsa_m55/measurement_mlkem_native/`의 고정된 Zephyr 보드 harness 및 검증 runner를 재사용한다.
따라서 **암호 구현은 독립된 복사본이지만, 이 폴더만 복사해 어디서나 빌드되는 독립 SDK는 아니다.**
공용 도구나 H0/L2 소스를 이번 정리에서 변경하지 않는다.

## 설정

- NUCLEO-N657X0-Q, 기존 L2의 mlkem-native 고정 커밋 `637d076aa113d8faaec2277ed4a46b657acaf35f`.
- 기존 L2와 같은 GNU Arm toolchain 15.2.Rel1 및 소스별 최종 `-O3`.
- 같은 Nucleo config/overlay, FPU 설정, DTCM 상수 배치용 linker와 TCM 초기화 도구.
- 측정 조건: CPU 800 MHz / SYSCLK 400 MHz / HCLK 200 MHz, 코드 ITCM,
  상수·데이터·스택 DTCM, I/D cache OFF, TCM ECC 유지. 실제 로그와 ELF 배치를 확인했다.
- `FNDSA_MVE_MP31=1`로 이 폴더의 기존 MVE 어셈블리 경로 활성화.
- `perf`: 산술 self-test OFF. `audit`: 기존 전 소수·signed Montgomery self-test ON.
  이 구분은 H0/H1 보정 알고리즘 선택 옵션이 아니다.
- 성능 full: 512/1024 각각 키생성·서명·검증 10 batch × 10회 = 100회,
  각 batch 10회 warm-up. 같은 입력과 host digest 사용.

## 명령

이 디렉터리에서 실행한다. `check`, `m55`, `audit`는 보드에 접근하지 않는다.

```sh
make check
make m55
make audit
```

빌드 후 compile commands에서 H1 소스 경로·어셈블리·MVE 옵션·최종 `-O3`를 확인한다.
빌드 전후 소스 해시, ELF/map/.config 해시와 L2 Kconfig 일치 여부를 manifest에 기록한다.
산술 코드는 빌드 중 변경되면 실패하며, 측정 직전에도 소스/ELF 변경 여부를 재검사한다.

아래 명령부터는 **보드를 리셋하고 RAM 펌웨어를 로드한다.** 보드 사용 승인을 받은 뒤
다른 측정 작업이 없는지 확인하고 순서대로 실행한다. 기존 label 대신 새 label을 사용한다.

```sh
make audit-pilot LABEL=h1_first
make pilot LABEL=h1_first
make full LABEL=h1_first
```

`full`은 같은 label에서 정확히 같은 perf ELF/소스의 pilot 통과가 필요하다.
audit 판정은 308개 소수, mismatch/range error 0 및 logn별 140개 cycle batch를 확인한다.
검사량도 정확히 확인한다: logn4..10의 2,156개 변환 세트, rounding 18,923,520개 lane case,
cycle batch별 100회. total은 양수 64-bit 값이고 `per_call == total // 100`이어야 한다.
중복·누락·잘못된 형식의 기록, 0회 검사, 잘못된 실패 위치 표시는 거부한다.
이 횟수는 고정된 benchmark.c의 16개 canonical + 14개 signed 입력 패턴에 대응한다.
향후 실제 검사를 변경하면 parser의 기대값과 회귀검사를 함께 갱신해야 한다.
이는 상수시간 형식적 증명이나 통계적 누출 검사를 대신하지 않는다.
공용 runner는 KAT/digest, 정상 서명 검증·변조 거부, 반복 횟수, TCM ECC와 fault register를 검사한다.
H0/H1 함수 배치 통제와 상수시간 구조 검사는 상위 stage의 `audit_scaling.py`에서 수행한다.
H0 원본은 변경하지 않고 [주소 대조군](../../experiments/h0_layout/)의 전체 복사본에
실행되지 않는 padding을 넣어 iNTT 밖의 주소·바이트를 H1과 맞췄다.

## 저장 위치

- `build/m55-perf/`, `build/m55-audit/`: ELF, map, config, compile commands, `h1_build.json`.
- `results/h1-<label>-<kind>/runs/<mode>-<UTC>/`: raw log, 검증 판정,
  실제 빌드 소스 복사본·ELF·map·config·build manifest·산술 audit 판정.
- `../result.md`: 최종 결과를 사람이 구분해 정리하는 보고서. 도구가 자동으로 성공 수치를 쓰지 않는다.

## 예전 C-only 프로파일링 파일

복사돼 있던 설정과 문서는 `Makefile.legacy`, `README.legacy.md`에 보관했다.
기존 `bench.c`, `instrument.py`, `run_board.py` 등도 보존했지만 위 새 명령에서는 사용하지 않는다.
기존 `TARGET=m55 INSTRUMENT=...` 명령은 현재 Makefile에서 오류로 차단한다.
그 경로는 C-only/AXI SRAM 설정으로, H1 MVE 성능 비교에 사용하면 안 된다.

## 검증 도구 자체의 회귀검사

저장소 루트에서 실행한다. 소스 변경 시뮬레이션은 임시 fixture에서만 수행하고
보드 실행은 mock으로 대체하므로 실제 보드나 암호 소스를 건드리지 않는다.

```sh
python3 -B -m unittest discover -s fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/tests -v
```

2026-09-15 기준 21개 테스트 통과. 기존 H0/H1 audit 로그도 강화된 parser로 재검사한다.
상위 `summarize_scaling.py` 역시 원시 audit 로그를 다시 검사하며 구형 판정 JSON만 신뢰하지 않는다.
