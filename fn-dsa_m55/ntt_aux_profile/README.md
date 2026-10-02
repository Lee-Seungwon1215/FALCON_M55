# NTT 보조 연산 프로파일러

`../ntt_ntrusolve/ref_preslothy`에서 다음 네 범주를 측정한다.

1. RNS NTT 상수표 생성: `mp_mkgm`, `mp_mkigm`, `mp_mkgmigm`
2. 공통 q=12289 `mqpoly_mul_ntt`
3. 공통 q=12289 `mqpoly_div_ntt`
4. RNS+NTT 영역 점별 연산: 재귀 하강, lifting, Babai 관련 곱셈·모듈러 나눗셈, 축소용 곱셈·차감

`instrument.py`는 원본을 수정하지 않고 `build/{control,detailed}/generated`에
삽입 계측본을 만든다. RNS 9개 루프만 감싸며 NTT 변환·CRT·RNS 변환·복사는 제외한다.
GCC cleanup을 이용하여 early return에도 계측을 닫는다. `profile.c`는 중첩 구간을
배타적으로 집계하므로 각 API의 합계가 100%이다.

`control`은 API 및 solve_NTRU 전체만, `detailed`는 네 범주까지 계측한다.
상세 비중은 detailed의 전체 시간을 분모로 사용한다. control 대비 차이는
계측 비용 및 코드 배치 영향이며 개별 항목에서 임의로 빼지 않는다.

기존 단계 프로파일과 입력, 컴파일러, 옵션, Kconfig, 메모리 배치를 비교하는
검증을 `provenance.py`가 수행한다. 과거 프로파일 결과와 원본 암호 코드는 보존한다.
공통 계측 workload 및 보드 loader만 재사용하며 다른 후보의 암호 코드를 가져오지 않는다.

```sh
bash fn-dsa_m55/ntt_aux_profile/build.sh all
python3 -B fn-dsa_m55/ntt_aux_profile/run.py control
python3 -B fn-dsa_m55/ntt_aux_profile/run.py detailed
python3 -B fn-dsa_m55/ntt_aux_profile/test_profile.py -v
python3 -B fn-dsa_m55/ntt_aux_profile/report.py
```

보드 실행은 M55 probe `003C00223335510735383531`만 대상으로 하며 하드웨어 접근 승인이 필요하다.
측정 중 같은 보드를 다른 작업에서 사용하지 않는다. RAM 실행이며 flash를 쓰지 않는다.

결과: [ntt_aux_profile_result.md](../ntt_ntrusolve/ref_preslothy/ntt_aux_profile_result.md).
원본 로그, SHA-256, 하드웨어 레지스터 및 출력 지문 검증은 `results/`에 보존한다.
정상 서명·변조 거부와 기존 입력의 출력 지문을 확인하지만 전체 KAT 또는 상수시간 증명은 아니다.
