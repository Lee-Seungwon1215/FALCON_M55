# K4-A M55 측정 도구

이 디렉터리의 도구는 상위 K4-A 후보의 **로컬 암호 소스 전체**를 빌드한다.
구현 선택용 옵션이나 다른 후보의 암호 소스 링크를 사용하지 않는다. 공용으로
고정한 Zephyr/보드 harness와 SDK만 재사용한다.

## 빌드와 검사

```sh
bash build_m55.sh audit
bash build_m55.sh perf
python3 -B m55.py check --built audit
python3 -B m55.py check --built perf
python3 -B audit_k4a.py
```

## 보드 측정

보드 작업은 연결된 지정 NUCLEO-N657X0-Q를 단독으로 순차 사용한다.

```sh
python3 -B m55.py run audit pilot --label k4a_forward_audit_v1
python3 -B m55.py run perf pilot --label k4a_forward_perf_v1
python3 -B m55.py run perf full --label k4a_forward_perf_v1
```

`full`은 같은 label/ELF의 performance pilot 통과가 필요하다. 검증기는 설정,
fault register, KAT/digest, 정상 서명·검증, 변조 거부, 정확한 검사량과 소스/ELF
provenance를 확인한다. run마다 raw log, validation, ELF/map/config, 암호 소스와
manifest를 보존한다.

manifest 파일명 `h1_build.json`은 기존 검증 도구와 archive 형식 호환을 위해
유지했지만, 내용의 `source_dir`과 SHA-256은 K4-A를 가리킨다. 정적 상수시간
검사는 `audit_k4a.py`가 보존된 K2 ELF와 K4-A ELF를 대조한다. 이는 동적
누출 검사나 형식적 증명이 아니다.

