# H0 주소 일치 대조군 — 측정용

H0_stagewise_half의 C/H/S 전체 복사본이다. 다른 후보의 함수 조각을 연결하지 않는다.
`source/kgen_mp31_cm55.s`에는 iNTT의 return/size 뒤에 실행되지 않는 `.org` padding만 추가했다.
H0의 계산 명령은 유지하며, H1 v1과 iNTT 진입 위치·stride table·forward small helper 및
뒤에 놓인 함수·상수·데이터의 주소를 일치시키기 위한 대조군이다.
H0 원본 폴더는 변경하지 않는다. 이것은 세 번째 최적화 후보가 아니다.

실제 일치 여부는 `../../audit_scaling.py`의 ELF 검사로 확인한다.

```sh
bash fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/build_compare.sh h0_layout audit
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/compare_tools.py h0_layout run audit pilot --label final_v1
bash fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/build_compare.sh h0_layout perf
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/compare_tools.py h0_layout run perf pilot --label final_v1
python3 -B fn-dsa_m55/ntt_ntrusolve/3rd_intt_scaling/compare_tools.py h0_layout run perf full --label final_v1
```
