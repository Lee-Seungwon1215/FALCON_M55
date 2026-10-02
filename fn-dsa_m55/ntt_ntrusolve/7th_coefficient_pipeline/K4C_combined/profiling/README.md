# K4-C M55 측정 도구

상위 K4-C 폴더의 로컬 암호 소스 전체를 빌드한다. 구현 선택용 옵션이나 다른
후보의 암호 소스 링크는 사용하지 않으며 공용 Zephyr/NUCLEO harness와 SDK만
재사용한다.

```sh
bash build_m55.sh audit
python3 m55.py run audit pilot --label k4c_combined_audit_v1
python3 audit_k4c.py
bash build_m55.sh perf
python3 m55.py run perf pilot --label k4c_combined_perf_v1
python3 m55.py run perf full --label k4c_combined_perf_v1
```

`full`은 동일 label/ELF의 pilot 통과가 필요하다. 각 run에는 raw log,
검증 결과, ELF/map/config, 소스와 build manifest가 보존된다. manifest 이름
`h1_build.json`은 기존 검증 도구와 archive 형식 호환을 위해 유지한다.
