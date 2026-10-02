# K4-B M55 측정 도구

상위 K4-B 폴더의 로컬 암호 소스 전체를 고정 공용 Zephyr/보드 harness로 빌드한다.
다른 후보의 암호 소스를 link하거나 빌드 옵션으로 선택하지 않는다.

```sh
bash build_m55.sh audit
bash build_m55.sh perf
python3 -B m55.py check --built audit
python3 -B m55.py check --built perf
python3 -B audit_k4b.py
```

보드 측정은 지정 NUCLEO-N657X0-Q를 단독으로 사용한다. run마다 raw log,
validation, ELF/map/config, 암호 소스와 manifest가 보존된다. manifest 파일명
`h1_build.json`은 archive 호환을 위해 유지하지만 내용은 K4-B 경로와 해시다.

`audit_k4b.py`는 보존된 K2 ELF와 K4-B ELF의 기계어 구조를 비교한다. 이 검사는
동적 leakage 검사나 형식적 증명이 아니다.

