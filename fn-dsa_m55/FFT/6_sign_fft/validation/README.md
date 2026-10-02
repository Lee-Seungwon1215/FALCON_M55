# 서명 FFT·LDL·split·merge 검증

생산 라이브러리에 포함되지 않는 시험 도구다. 현재 결과는
[../schedule_result.md](../schedule_result.md)와 `schedule_summary.json`에 정리한다.

## 현재 코드 재검사

workspace root에서 각 mode를 build한 후 연결된 M55에서 실행한다.

```sh
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh poly
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py poly
# poly 대신 ldl, kernel, sign, sigkat, kat, extra, api도 같은 순서로 실행
# poly/ldl/sign은 동일 ELF로 보드 실행을 한 번 더 반복
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign original
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign original
# original sign도 한 번 더 실행
```

- `poly`: logn=1…10 split/merge 원본·native C·현재 ASM, 5,120개 배열 비트 비교.
  원본과 native C는 이 폴더에 동결한 단독 함수다. 입력 불변·guard·ABI 20회,
  각 크기/방향 8입력군×100회 timing screen.
- `ldl`: 같은 방식의 세 구현 비교, 원본 대비 1,280배열, ABI 10회,
  8입력군×100회 및 나눗셈 20입력군×100회×32반복 검사.
- `kernel`: 변경하지 않은 FFT/iFFT 회귀검사. 3,840배열 비교, ABI 20회,
  원본·동결 native C·현재 ASM 성능, 입력군별 시간 및 왕복오차.
- 커널 시간은 입력 준비·복사·검증·출력을 제외하되 함수 호출·입출력·저장복원은 포함한다.
  warm-up 3회 후 구현당 100회, 동일 버퍼에서 구현 순서를 순환한다.
- `sign`: 내부 계측 OFF. 각 크기 10개 준비 키 중 마지막 키로 100개 seed 서명.
  warm-up 3회, API 전체 시간만 DWT/IRQ OFF 계측. 정상 검증·변조 거부·출력 지문도 확인한다.
- `sign original`: **수정하지 않은 M55_ref**의 같은 서명 프로그램.
  원본의 M4/M55 ASM 활성화 매크로 두 개만 시험 빌드에 지정한다. O3·FP·메모리 조건은 동일.
  원본을 ASM OFF/C-only로 재정의한 비교가 아니다.
- `sigkat`: 기존 서명 KAT 90개 및 정상/변조 검증.
- `kat`/`extra`: 기존/추가 키생성 KAT 300개씩, NTRU 방정식 검사.
- `api`: 정상 64건, 잘못된 입력 3,902건, 버퍼 guard 검사.

## 통합 연산비중 — 과거 보고서 보존

```sh
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign_detail
bash fn-dsa_m55/FFT/6_sign_fft/validation/build.sh sign_control
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign_detail
python3 fn-dsa_m55/FFT/6_sign_fft/validation/run_board.py sign_control
# 두 실행을 한 번 더 반복한 뒤 모든 검사 집계:
python3 -B fn-dsa_m55/FFT/6_sign_fft/validation/analyze_schedule.py
```

배타적 시간 합은 내부 계측 ON 서명 API의 100%다. 중첩 시간은 중복 집계하지 않는다.
현재 다섯 ASM 함수는 시험용 wrapper를 사용하며, 재귀 ASM의 직접 호출도
**build 아래 복사본에서만** wrapper로 바꾼다. 생산 ASM은 수정하지 않는다.
control로 계측 및 배치 변화 비용을 별도 확인한다. sampler 시간 전체가 FP64 산술은 아니다.

`analyze_schedule.py`는 현재 생산 소스 SHA, 원시 로그/ELF SHA, 성공 여부,
비중 합·예상 재귀 호출 수, 변경 범위, 세 함수의 기계어 등을 확인한다.
현재 JSON에는 후보 기록과 최종 반복 측정, CT 스크리닝 및 최종 비중이 모두 들어간다.
이전 `sign_profile_result.md`·`sign_profile/data.json`는 덮어쓰지 않는다.

## 역사적 도구와 결과

`analyze.py`는 FFT-only, `analyze_ldl.py`는 native C LDL-only,
`sign_profile/analyze.py`는 수동 스케줄링 이전의 보고서 작성기로 보존했다.
현재 코드는 `analyze_schedule.py`로 집계한다. 과거 `sign_native` 빌드는
당시 소스 스냅샷용이며 현재 세 ASM 통합 소스에 사용하는 모드가 아니다.
`baseline`은 Final_code/Before_slothy이며 **이번 작업 직전 코드와는 다르다**.
이번 직전 기준은 `pre_schedule_sources.tar.gz` 및 후보 목록의 `before` 실행이다.

## 조건과 한계

NUCLEO-N657X0-Q / serial 003C00223335510735383531,
CPU/SYS/HCLK 800/400/200 MHz, ITCM 코드·DTCM 상수/데이터/스택(각 256 KiB),
cache OFF, ECC ON, GCC 15.2.1, pinned mlkem-native 플랫폼 / Zephyr 4.4.1.
O3, fpv5-d16, hard-float, FP contraction OFF, fast-math OFF.

runner는 serial/lock, ELF load compare, fault·TCM·ECC 설정, 컴파일 명령,
소스 SHA와 실행 중 변경을 확인한다. 로그·ELF·역어셈블·생산 소스 archive를 보존한다.
보드 검사 중에는 소스나 검증 코드를 수정하지 않는다.
유한 입력 비트 비교/경험적 타이밍 검사이며 전체 입력 동등성이나 형식적 상수시간 증명,
전력·EM TVLA는 아니다. 같은 메모리 정책이지 모든 함수 절대 주소를 맞춘 비교는 아니다.
