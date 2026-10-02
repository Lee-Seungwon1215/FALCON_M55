# NTRU solve FFT 실험 결과

**목표 1.7배는 아직 달성하지 못했다. 기존 M55_ref/ntt_opt는 변경하지 않았다.**

## 조건

NUCLEO-N657X0-Q, STM32N657 Cortex-M55, 800 MHz, 코드 ITCM 256 KiB, 데이터·상수·스택 DTCM 256 KiB, I/D cache OFF, TCM ECC ON. GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard`, `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`. M4 어셈블리는 켜고, ntt_opt 이후 후보에는 기존 MVE NTT도 그대로 유지했다.

각 크기에서 동일 upstream seed 100개, warmup 3회 제외, 실패 후보와 재시도·키 인코딩 포함. KAT/NTRU 방정식 검사는 시간 밖에서 수행. 아래 전체 성능은 계측 hook 없는 빌드이다. 커널은 IRQ를 막았고, 전체 키생성은 공통 Zephyr 실행 조건에서 IRQ를 허용했다. 동일 배치 정책이지만 함수 주소가 모두 고정된 실험은 아니므로 미세한 차이는 배치 영향도 포함한다.

## 현재 소스의 전체 키생성 요약

| 구현 | 512 cycles | M55_ref 대비 | 1024 cycles | M55_ref 대비 |
| --- | ---: | ---: | ---: | ---: |
| [baseline_m55 / 20260927T141357Z](validation/results/baseline_m55/keygen/20260927T141357Z/manifest.json) | 62,738,244.34 | 1.0000× | 261,716,429.63 | 1.0000× |
| [baseline_ntt / 20260927T142645Z](validation/results/baseline_ntt/keygen/20260927T142645Z/manifest.json) | 56,951,253.03 | 1.1016× | 243,157,429.30 | 1.0763× |
| [A_tw_bridge / 20260928T045736Z](validation/results/A_tw_bridge/keygen/20260928T045736Z/manifest.json) | 51,437,073.05 | 1.2197× | 224,191,126.63 | 1.1674× |
| [B_continuous_ds / 20260927T211520Z](validation/results/B_continuous_ds/keygen/20260927T211520Z/manifest.json) | 56,396,713.53 | 1.1124× | 241,332,393.02 | 1.0845× |

이 표의 A/B 성능은 현재 암호 소스 해시와 일치하는 실행만 사용한다. 완료한 검증 항목은 아래 current_validation.json에서 별도로 확인한다. 배율은 원본 시간 ÷ 후보 시간이다.

## 전체 키생성: 과거 버전과 반복을 포함한 모든 실측

| 경로·run (UTC) | 512 cycles | M55_ref 대비 | 1024 cycles | M55_ref 대비 |
| --- | ---: | ---: | ---: | ---: |
| [A_tw_bridge / 20260927T141916Z](validation/results/A_tw_bridge/keygen/20260927T141916Z/manifest.json) | 59,822,108.05 | 1.0487× | 250,923,180.77 | 1.0430× |
| [A_tw_bridge / 20260927T144050Z](validation/results/A_tw_bridge/keygen/20260927T144050Z/manifest.json) | 57,959,780.59 | 1.0824× | 246,082,944.45 | 1.0635× |
| [A_tw_bridge / 20260927T145142Z](validation/results/A_tw_bridge/keygen/20260927T145142Z/manifest.json) | 57,255,578.88 | 1.0958× | 244,331,097.49 | 1.0712× |
| [A_tw_bridge / 20260927T145843Z](validation/results/A_tw_bridge/keygen/20260927T145843Z/manifest.json) | 59,127,571.10 | 1.0611× | 249,544,181.82 | 1.0488× |
| [A_tw_bridge / 20260927T150312Z](validation/results/A_tw_bridge/keygen/20260927T150312Z/manifest.json) | 56,246,084.02 | 1.1154× | 241,723,484.70 | 1.0827× |
| [A_tw_bridge / 20260927T151545Z](validation/results/A_tw_bridge/keygen/20260927T151545Z/manifest.json) | 56,256,308.59 | 1.1152× | 241,743,902.58 | 1.0826× |
| [A_tw_bridge / 20260927T154621Z](validation/results/A_tw_bridge/keygen/20260927T154621Z/manifest.json) | 56,256,308.92 | 1.1152× | 241,743,902.19 | 1.0826× |
| [A_tw_bridge / 20260927T164817Z](validation/results/A_tw_bridge/keygen/20260927T164817Z/manifest.json) | 55,394,596.20 | 1.1326× | 238,879,145.04 | 1.0956× |
| [A_tw_bridge / 20260927T165420Z](validation/results/A_tw_bridge/keygen/20260927T165420Z/manifest.json) | 55,394,595.48 | 1.1326× | 238,879,145.49 | 1.0956× |
| [A_tw_bridge / 20260927T172643Z](validation/results/A_tw_bridge/keygen/20260927T172643Z/manifest.json) | 54,765,620.62 | 1.1456× | 237,610,758.09 | 1.1015× |
| [A_tw_bridge / 20260927T172946Z](validation/results/A_tw_bridge/keygen/20260927T172946Z/manifest.json) | 54,765,620.59 | 1.1456× | 237,610,757.98 | 1.1015× |
| [A_tw_bridge / 20260927T185939Z](validation/results/A_tw_bridge/keygen/20260927T185939Z/manifest.json) | 54,620,522.07 | 1.1486× | 237,010,994.74 | 1.1042× |
| [A_tw_bridge / 20260927T190419Z](validation/results/A_tw_bridge/keygen/20260927T190419Z/manifest.json) | 54,620,522.69 | 1.1486× | 237,010,994.05 | 1.1042× |
| [A_tw_bridge / 20260927T194553Z](validation/results/A_tw_bridge/keygen/20260927T194553Z/manifest.json) | 54,320,119.24 | 1.1550× | 236,219,621.12 | 1.1079× |
| [A_tw_bridge / 20260927T195159Z](validation/results/A_tw_bridge/keygen/20260927T195159Z/manifest.json) | 54,320,118.67 | 1.1550× | 236,219,621.83 | 1.1079× |
| [A_tw_bridge / 20260927T200643Z](validation/results/A_tw_bridge/keygen/20260927T200643Z/manifest.json) | 54,268,516.27 | 1.1561× | 235,984,647.93 | 1.1090× |
| [A_tw_bridge / 20260927T200944Z](validation/results/A_tw_bridge/keygen/20260927T200944Z/manifest.json) | 54,268,516.48 | 1.1561× | 235,984,647.11 | 1.1090× |
| [A_tw_bridge / 20260927T202124Z](validation/results/A_tw_bridge/keygen/20260927T202124Z/manifest.json) | 54,168,122.18 | 1.1582× | 235,699,617.36 | 1.1104× |
| [A_tw_bridge / 20260927T202433Z](validation/results/A_tw_bridge/keygen/20260927T202433Z/manifest.json) | 54,168,121.70 | 1.1582× | 235,699,616.15 | 1.1104× |
| [A_tw_bridge / 20260927T212510Z](validation/results/A_tw_bridge/keygen/20260927T212510Z/manifest.json) | 53,946,545.18 | 1.1630× | 235,115,934.69 | 1.1131× |
| [A_tw_bridge / 20260927T212904Z](validation/results/A_tw_bridge/keygen/20260927T212904Z/manifest.json) | 53,946,545.42 | 1.1630× | 235,115,934.24 | 1.1131× |
| [A_tw_bridge / 20260927T214227Z](validation/results/A_tw_bridge/keygen/20260927T214227Z/manifest.json) | 53,869,413.04 | 1.1646× | 234,922,906.40 | 1.1141× |
| [A_tw_bridge / 20260927T214601Z](validation/results/A_tw_bridge/keygen/20260927T214601Z/manifest.json) | 53,869,412.69 | 1.1646× | 234,922,906.90 | 1.1141× |
| [A_tw_bridge / 20260927T215922Z](validation/results/A_tw_bridge/keygen/20260927T215922Z/manifest.json) | 53,814,104.58 | 1.1658× | 234,793,060.72 | 1.1147× |
| [A_tw_bridge / 20260927T220207Z](validation/results/A_tw_bridge/keygen/20260927T220207Z/manifest.json) | 53,814,104.34 | 1.1658× | 234,793,059.77 | 1.1147× |
| [A_tw_bridge / 20260927T234522Z](validation/results/A_tw_bridge/keygen/20260927T234522Z/manifest.json) | 53,777,061.09 | 1.1666× | 234,700,263.92 | 1.1151× |
| [A_tw_bridge / 20260927T234807Z](validation/results/A_tw_bridge/keygen/20260927T234807Z/manifest.json) | 53,777,061.10 | 1.1666× | 234,700,263.98 | 1.1151× |
| [A_tw_bridge / 20260928T032732Z](validation/results/A_tw_bridge/keygen/20260928T032732Z/manifest.json) | 51,437,565.73 | 1.2197× | 224,193,235.31 | 1.1674× |
| [A_tw_bridge / 20260928T033015Z](validation/results/A_tw_bridge/keygen/20260928T033015Z/manifest.json) | 51,437,565.73 | 1.2197× | 224,193,235.43 | 1.1674× |
| [A_tw_bridge / 20260928T044452Z](validation/results/A_tw_bridge/keygen/20260928T044452Z/manifest.json) | 51,437,072.64 | 1.2197× | 224,191,128.60 | 1.1674× |
| [A_tw_bridge / 20260928T045736Z](validation/results/A_tw_bridge/keygen/20260928T045736Z/manifest.json) | 51,437,073.05 | 1.2197× | 224,191,126.63 | 1.1674× |
| [B_continuous_ds / 20260927T141651Z](validation/results/B_continuous_ds/keygen/20260927T141651Z/manifest.json) | 75,580,409.67 | 0.8301× | 288,643,203.77 | 0.9067× |
| [B_continuous_ds / 20260927T142300Z](validation/results/B_continuous_ds/keygen/20260927T142300Z/manifest.json) | 73,202,779.01 | 0.8570× | 282,788,571.10 | 0.9255× |
| [B_continuous_ds / 20260927T143341Z](validation/results/B_continuous_ds/keygen/20260927T143341Z/manifest.json) | 69,705,019.91 | 0.9001× | 274,231,511.15 | 0.9544× |
| [B_continuous_ds / 20260927T143927Z](validation/results/B_continuous_ds/keygen/20260927T143927Z/manifest.json) | 61,915,441.18 | 1.0133× | 254,873,214.58 | 1.0268× |
| [B_continuous_ds / 20260927T144814Z](validation/results/B_continuous_ds/keygen/20260927T144814Z/manifest.json) | 60,927,776.29 | 1.0297× | 252,665,830.54 | 1.0358× |
| [B_continuous_ds / 20260927T153140Z](validation/results/B_continuous_ds/keygen/20260927T153140Z/manifest.json) | 60,202,399.94 | 1.0421× | 250,916,084.33 | 1.0430× |
| [B_continuous_ds / 20260927T153908Z](validation/results/B_continuous_ds/keygen/20260927T153908Z/manifest.json) | 59,826,982.72 | 1.0487× | 249,997,361.46 | 1.0469× |
| [B_continuous_ds / 20260927T154535Z](validation/results/B_continuous_ds/keygen/20260927T154535Z/manifest.json) | 59,826,983.23 | 1.0487× | 249,997,361.37 | 1.0469× |
| [B_continuous_ds / 20260927T160136Z](validation/results/B_continuous_ds/keygen/20260927T160136Z/manifest.json) | 59,531,271.25 | 1.0539× | 249,261,734.57 | 1.0500× |
| [B_continuous_ds / 20260927T161150Z](validation/results/B_continuous_ds/keygen/20260927T161150Z/manifest.json) | 59,501,014.05 | 1.0544× | 249,200,552.94 | 1.0502× |
| [B_continuous_ds / 20260927T161547Z](validation/results/B_continuous_ds/keygen/20260927T161547Z/manifest.json) | 59,501,014.12 | 1.0544× | 249,200,552.39 | 1.0502× |
| [B_continuous_ds / 20260927T162702Z](validation/results/B_continuous_ds/keygen/20260927T162702Z/manifest.json) | 59,032,875.16 | 1.0628× | 247,983,506.39 | 1.0554× |
| [B_continuous_ds / 20260927T163301Z](validation/results/B_continuous_ds/keygen/20260927T163301Z/manifest.json) | 59,032,874.79 | 1.0628× | 247,983,506.14 | 1.0554× |
| [B_continuous_ds / 20260927T171009Z](validation/results/B_continuous_ds/keygen/20260927T171009Z/manifest.json) | 57,946,321.84 | 1.0827× | 245,794,206.26 | 1.0648× |
| [B_continuous_ds / 20260927T171504Z](validation/results/B_continuous_ds/keygen/20260927T171504Z/manifest.json) | 57,946,322.03 | 1.0827× | 245,794,207.02 | 1.0648× |
| [B_continuous_ds / 20260927T174111Z](validation/results/B_continuous_ds/keygen/20260927T174111Z/manifest.json) | 57,693,564.16 | 1.0874× | 245,165,387.58 | 1.0675× |
| [B_continuous_ds / 20260927T174525Z](validation/results/B_continuous_ds/keygen/20260927T174525Z/manifest.json) | 57,693,564.37 | 1.0874× | 245,165,387.35 | 1.0675× |
| [B_continuous_ds / 20260927T175621Z](validation/results/B_continuous_ds/keygen/20260927T175621Z/manifest.json) | 57,432,851.46 | 1.0924× | 243,932,694.73 | 1.0729× |
| [B_continuous_ds / 20260927T180021Z](validation/results/B_continuous_ds/keygen/20260927T180021Z/manifest.json) | 57,432,851.94 | 1.0924× | 243,932,694.45 | 1.0729× |
| [B_continuous_ds / 20260927T180928Z](validation/results/B_continuous_ds/keygen/20260927T180928Z/manifest.json) | 57,276,736.26 | 1.0954× | 243,544,928.93 | 1.0746× |
| [B_continuous_ds / 20260927T181434Z](validation/results/B_continuous_ds/keygen/20260927T181434Z/manifest.json) | 57,276,736.52 | 1.0954× | 243,544,929.69 | 1.0746× |
| [B_continuous_ds / 20260927T182927Z](validation/results/B_continuous_ds/keygen/20260927T182927Z/manifest.json) | 57,164,877.71 | 1.0975× | 243,270,787.04 | 1.0758× |
| [B_continuous_ds / 20260927T183346Z](validation/results/B_continuous_ds/keygen/20260927T183346Z/manifest.json) | 57,164,877.46 | 1.0975× | 243,270,787.75 | 1.0758× |
| [B_continuous_ds / 20260927T203221Z](validation/results/B_continuous_ds/keygen/20260927T203221Z/manifest.json) | 57,072,076.49 | 1.0993× | 243,021,160.02 | 1.0769× |
| [B_continuous_ds / 20260927T203532Z](validation/results/B_continuous_ds/keygen/20260927T203532Z/manifest.json) | 57,072,076.59 | 1.0993× | 243,021,160.02 | 1.0769× |
| [B_continuous_ds / 20260927T204502Z](validation/results/B_continuous_ds/keygen/20260927T204502Z/manifest.json) | 57,003,810.45 | 1.1006× | 242,854,316.22 | 1.0777× |
| [B_continuous_ds / 20260927T204831Z](validation/results/B_continuous_ds/keygen/20260927T204831Z/manifest.json) | 57,003,810.54 | 1.1006× | 242,854,316.45 | 1.0777× |
| [B_continuous_ds / 20260927T205536Z](validation/results/B_continuous_ds/keygen/20260927T205536Z/manifest.json) | 56,886,404.81 | 1.1029× | 242,566,913.19 | 1.0789× |
| [B_continuous_ds / 20260927T205914Z](validation/results/B_continuous_ds/keygen/20260927T205914Z/manifest.json) | 56,886,405.00 | 1.1029× | 242,566,913.16 | 1.0789× |
| [B_continuous_ds / 20260927T211158Z](validation/results/B_continuous_ds/keygen/20260927T211158Z/manifest.json) | 56,396,713.72 | 1.1124× | 241,332,393.04 | 1.0845× |
| [B_continuous_ds / 20260927T211520Z](validation/results/B_continuous_ds/keygen/20260927T211520Z/manifest.json) | 56,396,713.53 | 1.1124× | 241,332,393.02 | 1.0845× |
| [baseline_m55 / 20260927T141357Z](validation/results/baseline_m55/keygen/20260927T141357Z/manifest.json) | 62,738,244.34 | 1.0000× | 261,716,429.63 | 1.0000× |
| [baseline_ntt / 20260927T142645Z](validation/results/baseline_ntt/keygen/20260927T142645Z/manifest.json) | 56,951,253.03 | 1.1016× | 243,157,429.30 | 1.0763× |

## 현재 후보와 추가 효과

A의 현재 소스는 A17-cleanup(A16 + FP64 invnorm, 미사용 코드 정리): [정리 후 재검증](validation/cleanup/README.md)을 별도로 기록했다. 사용자의 2026-09-28 요청에 따라 후보 직교 노름 검사의 invnorm(e=0)에 예전 native FP64 제곱합·역수를 적용했다. Q32 ABI와 주변 FFT/iFFT는 유지하며 계수별 입출력 변환을 포함한다. [추가 함수·전체 측정](validation/invnorm_results.md)을 참조한다. 이전 A16까지의 NTRU 구현은 다음과 같다. 중간 축소의 계산 규칙은 원래 고정소수점으로 유지하되, FFT 입력 변환 poly_big_to_fixed와 NTRU 내부 역수 계산의 Q32 나눗셈을 정수 MVE로 병렬화했다. 역수 배열은 고정소수점 그대로이며, 전역 inner_fxr_div와 후보 검사는 변경하지 않았다. A9의 회전상수 전용 정수 MVE 곱셈과 벡터 덧셈·원래 단계별 half를 A10에서는 하나의 butterfly 어셈블리 반복문으로 합쳤다. 3072바이트 임시 배열을 64바이트 작업공간으로 줄이고, NTRU intermediate의 forward logn>=5, inverse logn>=4에서 사용한다. 그보다 작은 크기와 후보 노름 검사의 FFT는 원본을 유지한다. A11은 logn=1 입력 변환에서 두 계수×두 자리를 MVE lane에 배치해 모든 자리의 마스크 선택을 병렬 처리한다. A12는 logn>=2의 자리 선택 마스크를 벡터 비교·OR로 단축한다. 모든 입력 자리는 조건 없이 읽는다. A13은 큰 FFT의 마지막 두 레이어와 iFFT의 처음 두 레이어에서 서로 다른 회전상수를 쓰는 butterfly 네 개를 묶어 정수 MVE로 처리한다. 원래 3곱과 단계별 half를 유지한다. A14는 실제 회전상수 성분의 범위로 두 곱셈을 단축하고, 독립적인 곱의 계산 순서와 레지스터 수명을 바꿔 임시 공간을 256에서 160바이트로 줄인다. 합친 상수의 곱은 일반 연산을 유지한다. A15는 짧은 레이어의 최종 실수부·허수부 결과를 레지스터에서 직접 소비해 스택 저장·재읽기 8회를 없앤다. forward는 오프셋 표 읽기가 1회 추가된다. 또한 공개된 크기 16에서 같은 벡터 경로가 이기는 것을 별도로 확인해 forward 하한을 logn=5에서 4로 낮췄다. 현재 forward/inverse 모두 logn>=4에 적용되며, 그보다 작은 크기와 후보 노름 검사는 여전히 원본이다. A16은 ht=1 레이어의 회전상수와 inverse 입력을 VLD4로 읽고 forward 결과를 VST4로 저장한다. ht=2의 원래 gather 배치는 유지하며, 공개된 ht/direction별 네 반복문으로 내부 분기를 피한다. 대신 코드가 1,540바이트 늘고, 데이터·스택 할당량은 그대로다. depth0만 double 경계 + DS FFT/iFFT + FP64 나눗셈을 사용한다. A4/A5에서 발견한 입력별 시간차는 고정 명령열 판정으로 수정했다. 최초 TW 전체 구간 교체와 구분한다. B는 B18: DS 배열을 유지하고 계수별 정확한 정수 보조 연산을 합쳤으며, 입력 표현 변환·최종 k 반올림·점별 곱셈·역수·나눗셈의 표현 경계를 4개씩 처리한다. Q32 곱셈과 나눗셈 자체는 원래 정수 규칙을 유지한다. B9는 모든 입력 자리를 순서대로 읽는 마스크 선택 작업까지 4개 계수씩 MVE로 처리한다. B10은 기존 64단계 Q32 나눗셈도 네 계수에 병렬 적용하며, 근사 FP 나눗셈으로 바꾸거나 원래 반올림 규칙을 완화하지 않았다. B11은 점별 곱셈의 디코딩·정확한 Q32 3곱·인코딩을 한 어셈블리 루프로 통합하고 각 Q32 곱도 정수 MVE로 네 계수씩 처리한다. B12는 작은 크기(logn=1..3)의 고정소수점 입력 변환도 자체 정수 MVE 어셈블리로 처리한다. B13은 큰 입력의 자리 선택·FP32 변환도 하나의 루프로 합치고 작은 C 경로를 분리하여 큰 경로의 레지스터 저장 비용을 줄였다. B14는 입력 인코더의 다섯 오차 보존 덧셈만 피연산자 범위에 근거해 FastTwoSum으로 단축했다. B15는 큰 입력 자리 선택의 마스크만 벡터 비교·OR로 단축하며 모든 자리 읽기는 유지한다. B16은 디코더의 floor·소수 부분 관계가 보장되는 세 곳에서만 오차 보존 덧셈을 단축한다. B17은 같은 디코더의 정수 지수 추출·상수 설정·자리올림 명령을 동일 비트 규칙으로 단축한다. B18은 변하지 않는 역수의 DS 표현을 한 번만 디코딩해 기존 rt3 버퍼에 저장한다. 반복 중에는 이 캐시를 읽으며, 준비 비용도 I_mul 비중과 전체 시간에 포함한다. 디코더·반올림의 일반 TwoSum과 큰 FFT의 DS 표현·정밀도 선택 기준은 변경하지 않았다.

| 후보 | 512: ntt_opt 대비 시간 변화 | 1024: ntt_opt 대비 시간 변화 |
| --- | ---: | ---: |
| A_tw_bridge / 20260928T045736Z | -9.6823% | -7.8000% |
| B_continuous_ds / 20260927T211520Z | -0.9737% | -0.7506% |

음수는 시간 감소, 양수는 느려짐. M55_ref 대비 이득 전체를 새 FFT 최적화의 성과로 해석하면 안 된다.

## 원래 기준의 최적화 가능 범위

분모는 키생성 전체. 분자는 NTRU intermediate/depth0의 입력 변환, FFT, 역수·곱셈·나눗셈, iFFT, 정수 k 반올림. `I_update`는 NTT 등 정수 다항식 갱신이므로 제외한다. 이 비중 표는 후보 직교노름 검사를 포함하지 않으므로 A17의 추가 invnorm 효과까지 설명하는 표는 아니다.

| 기준 | 512 | 1024 |
| --- | ---: | ---: |
| baseline_m55 / 20260927T140919Z | 11.87569% | 7.39278% |
| baseline_ntt / 20260927T140452Z | 13.05836% | 7.95020% |
| A_tw_bridge / 20260928T050312Z | 8.52098% | 4.98718% |
| B_continuous_ds / 20260927T211338Z | 12.23101% | 7.27812% |

계측 hook 포함 비중이며 위의 비계측 전체 사이클과 혼합해 정확한 가속률로 주장하지 않는다. M55_ref에서 대상 시간이 약 11.88%/7.39%이다. 다른 작업량을 고정하면, 이 시간을 0으로 줄여도 약 1.135배/1.080배가 한계다. 이는 그 전제에서의 Amdahl 추정이며 모든 새 알고리즘에 대한 불가능성 증명은 아니다. 이미 채택한 NTT 이득까지 포함하려면 다른 계산이 필요하다: 같은 계측 빌드의 M55_ref 전체를 (ntt_opt 전체 − 그 FFT 대상 시간)으로 나눈 이상적 추정은 약 1.26배/1.17배이다. 이 역시 다른 작업량을 고정하고 FFT 비용을 0으로 놓은 가정이지 실측 성과가 아니다. 1.7배에는 전체 시간의 41.18% 제거가 필요하다. 반복 횟수/정수 갱신/다른 단계를 바꾸는 것은 현재 커널 최적화와 별도 범위·정확성 검토가 필요하다.

## 세부 검증 및 근거

- [전체 측정 요약](validation/measurement_summary.md), [JSON](validation/summary.json).
- [크기별 커널·변환·오차·입력별 시간](validation/kernel_summary.md). 변환 미포함 성능과 실제 경계 비용을 구분한다.
- [실험별 변경 기록](research/experiment_log.md). A0–A16, B0–B18를 구분한다.
- [A7 고정소수점 입력 변환](validation/fixed_input_results.md). 원본 Q32 비트 비교와 크기별 실제 호출 비용.
- [B 경계 연산 검증](validation/boundary_results.md). 단독 개선과 전체 개선을 구분한다.
- [B9 입력 자리 선택·변환](validation/selection_results.md). 원본 정수 비트와 FP32 결과를 별도 검사한다.
- [B10 네 계수 나눗셈](validation/division_results.md), [설계·출처](research/division_design.md). 전체 키생성 배율과 단독 나눗셈 배율은 다르다.
- [A8 Q32 배열 직접 나눗셈](validation/fixed_division_results.md). 표현 변환 없는 NTRU 역수 계산 및 전체 키생성 재측정.
- [B11 점별 곱셈 통합](validation/point_fusion_results.md), [설계·출처](research/point_fusion_design.md). 변환 포함 커널과 전체 효과를 구분한다.
- [B12 작은 FFT 입력 변환](validation/b12_fixed_input_results.md). 원본 비트 일치, 작은 크기 비용과 전체 효과를 분리한다.
- [B13 큰 입력 변환 통합](validation/input_fusion_results.md). 같은 ELF의 이전 방식과 비교하며, 변환 및 함수 호출 비용을 포함한다.
- [B14 인코더 합 연산 단축](validation/encoder_fastsum_results.md), [범위 분석·출처](research/encoder_fastsum_design.md). 유한 비트 비교와 전체 성능을 별도로 기록한다.
- [B15 큰 입력 선택 마스크 단축](validation/b15_predicate_input_results.md). B의 원본 비트·표현 경계·전체 검증을 독립 수행한다.
- [B16 디코더의 오차 보존 덧셈 단축](validation/b16_decoder_fastsum_results.md), [적용 조건·출처](research/decoder_fastsum_design.md). 중간 zero 부호와 최종 raw 비트 일치를 구분한다.
- [B17 디코더의 정수·상수 명령 단축](validation/b17_decoder_words_results.md), [동일 비트 규칙](research/decoder_words_design.md). FP 계산 순서는 유지한다.
- [B18 변하지 않는 역수 디코딩 캐시](validation/b18_inverse_cache_results.md), [메모리 수명·동일 계산 규칙](research/inverse_cache_design.md). 준비 비용을 포함하며 Babai 반복은 바꾸지 않는다.
- [A9 회전상수 전용 곱셈과 정확한 MVE FFT](validation/twiddle_results.md), [설계·범위](research/twiddle_multiply_design.md). 단독 곱셈과 변환 전체 이득을 구분한다.
- [A10 butterfly 통합·임시 저장 감소](validation/fusion_results.md), [설계·레지스터 수명](research/fused_butterfly_design.md). 새 경로의 정확성·커널·전체 효과를 별도 검증한다.
- [A11 작은 입력의 두 자리 동시 처리](validation/paired_input_results.md), [원본 계산 규칙 대응](research/paired_input_design.md). 단독 실험과 본체 검증을 구분한다.
- [A12 네 계수 입력의 마스크 단축](validation/predicate_input_results.md), [접근·산술 규칙](research/predicate_input_design.md). 새 소스의 비교와 전체 효과를 분리한다.
- [A13 짧은 레이어의 butterfly 묶음 처리](validation/packed_tail_results.md), [레인 배치·연산 규칙](research/packed_tail_design.md). 큰 커널과 전체 키생성 배율을 구분한다.
- [A14 상수 성분 곱셈·임시 저장 단축](validation/packed_root_lifetime_results.md), [범위·정확한 곱셈·레지스터 수명](research/packed_root_lifetime_design.md). 곱셈만 바꾼 실험과 결합 실험을 구분한다.
- [A15 짧은 레이어의 결과 직접 사용·크기 16 경로](validation/packed_finish_results.md), [레지스터 수명·공개 크기 조건](research/packed_finish_design.md). 결과 저장 제거와 크기 하한 변경을 별도로 측정한다.
- [A16 짧은 레이어의 재배열 메모리 접근](validation/packed_layout_results.md), [배치·레지스터·접근 범위](research/packed_layout_design.md). 회전상수만 바꾼 실험과 계수 입출력까지 바꾼 실험을 구분한다.
- [상수시간 관련 발견·수정·유한 검사](validation/ct_results.md). A4/A5 기록은 최종 안전성 통과로 취급하지 않는다.
- [현재 소스 해시와 일치하는 검증](validation/current_validation.json). 다른 버전의 통과를 이어받지 않는다.
- [기록·ELF 해시 및 외부 원본 불변 재확인](validation/evidence_check.json). 재현: `python validation/verify_evidence.py`.
- [검증 범위·한계](validation/validation_limits.md). 유한 KAT/오차/시간 검사는 보편적 동등성·상수시간 증명이 아니다.
- [A17 정리 후 요청 범위의 다섯 검사](validation/cleanup/README.md). 현재 소스의 재검증과 정리 전 기록을 구분한다. 수치 차이와 유한 검사 한계는 명시하며, 배포 준비·물리 부채널 검사는 이번 요청 범위 밖이다.
- [원래 유지한 소스 검사](validation/scope_check.json). A17의 후보 invnorm 변경과 이후 미사용 코드 정리를 구분해 검사한다.
- [모든 로컬 논문 독해 기록](research/reading_log.md), [추가 일차 문헌](research/additional_sources.md).
- [1.7배 목표의 현재 범위 재검토](validation/scope_feasibility.md), [새 문헌과 실제 solver 대조](research/babai_scope_review.md). 동일 호출 횟수·조건부 시간 계산이며 새 보드 실측이 아니다.
- [요구사항별 완료 감사](validation/requirements_audit.md), [같은 seed별 전체 성능 비교](validation/paired_keygen_audit.md). 평균뿐 아니라 입력별 목표 미달도 확인했으며 전체 목표는 미완료다.
- [미달 목표·남은 연구·미증명 범위](research/remaining_work.md). 모든 가능한 기법을 소진했다는 주장은 하지 않는다.
- 소스 스냅샷은 `validation/source_snapshots/`, 실행 ELF·원시 로그·해시는 `validation/results/`.
- 재현: `bash validation/build.sh <candidate> <mode>` 후 공통 venv Python으로 `validation/run_board.py <candidate> <mode>`. 보드 실행은 항상 한 개씩. SLOTHY 실행·생성 및 다른 후보의 암호 코드 링크 없음.

## 검증 로그 목록

| 후보 | 검사 | run |
| --- | --- | --- |
| A_tw_bridge | extra | [20260927T150355Z](validation/results/A_tw_bridge/extra/20260927T150355Z/manifest.json) |
| A_tw_bridge | extra | [20260927T151629Z](validation/results/A_tw_bridge/extra/20260927T151629Z/manifest.json) |
| A_tw_bridge | extra | [20260927T164953Z](validation/results/A_tw_bridge/extra/20260927T164953Z/manifest.json) |
| A_tw_bridge | extra | [20260927T172726Z](validation/results/A_tw_bridge/extra/20260927T172726Z/manifest.json) |
| A_tw_bridge | extra | [20260927T190023Z](validation/results/A_tw_bridge/extra/20260927T190023Z/manifest.json) |
| A_tw_bridge | extra | [20260927T194637Z](validation/results/A_tw_bridge/extra/20260927T194637Z/manifest.json) |
| A_tw_bridge | extra | [20260927T200727Z](validation/results/A_tw_bridge/extra/20260927T200727Z/manifest.json) |
| A_tw_bridge | extra | [20260927T202207Z](validation/results/A_tw_bridge/extra/20260927T202207Z/manifest.json) |
| A_tw_bridge | extra | [20260927T212554Z](validation/results/A_tw_bridge/extra/20260927T212554Z/manifest.json) |
| A_tw_bridge | extra | [20260927T214311Z](validation/results/A_tw_bridge/extra/20260927T214311Z/manifest.json) |
| A_tw_bridge | extra | [20260927T220005Z](validation/results/A_tw_bridge/extra/20260927T220005Z/manifest.json) |
| A_tw_bridge | extra | [20260927T234605Z](validation/results/A_tw_bridge/extra/20260927T234605Z/manifest.json) |
| A_tw_bridge | extra | [20260928T032520Z](validation/results/A_tw_bridge/extra/20260928T032520Z/manifest.json) |
| A_tw_bridge | extra | [20260928T044903Z](validation/results/A_tw_bridge/extra/20260928T044903Z/manifest.json) |
| A_tw_bridge | extra | [20260928T050051Z](validation/results/A_tw_bridge/extra/20260928T050051Z/manifest.json) |
| A_tw_bridge | fft_alignment | [20260927T190715Z](validation/results/A_tw_bridge/fft_alignment/20260927T190715Z/manifest.json) |
| A_tw_bridge | fft_context | [20260927T191836Z](validation/results/A_tw_bridge/fft_context/20260927T191836Z/manifest.json) |
| A_tw_bridge | fft_fusion | [20260927T194014Z](validation/results/A_tw_bridge/fft_fusion/20260927T194014Z/manifest.json) |
| A_tw_bridge | fft_placement | [20260927T191506Z](validation/results/A_tw_bridge/fft_placement/20260927T191506Z/manifest.json) |
| A_tw_bridge | fft_replay | [20260927T192254Z](validation/results/A_tw_bridge/fft_replay/20260927T192254Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T172407Z](validation/results/A_tw_bridge/fixed_division/20260927T172407Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T173029Z](validation/results/A_tw_bridge/fixed_division/20260927T173029Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T190248Z](validation/results/A_tw_bridge/fixed_division/20260927T190248Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T194501Z](validation/results/A_tw_bridge/fixed_division/20260927T194501Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T200551Z](validation/results/A_tw_bridge/fixed_division/20260927T200551Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T202031Z](validation/results/A_tw_bridge/fixed_division/20260927T202031Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T212418Z](validation/results/A_tw_bridge/fixed_division/20260927T212418Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T214135Z](validation/results/A_tw_bridge/fixed_division/20260927T214135Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T215830Z](validation/results/A_tw_bridge/fixed_division/20260927T215830Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260927T234429Z](validation/results/A_tw_bridge/fixed_division/20260927T234429Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260928T032925Z](validation/results/A_tw_bridge/fixed_division/20260928T032925Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260928T045041Z](validation/results/A_tw_bridge/fixed_division/20260928T045041Z/manifest.json) |
| A_tw_bridge | fixed_division | [20260928T050236Z](validation/results/A_tw_bridge/fixed_division/20260928T050236Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T185809Z](validation/results/A_tw_bridge/fixed_fft/20260927T185809Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T194449Z](validation/results/A_tw_bridge/fixed_fft/20260927T194449Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T200539Z](validation/results/A_tw_bridge/fixed_fft/20260927T200539Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T202020Z](validation/results/A_tw_bridge/fixed_fft/20260927T202020Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T212259Z](validation/results/A_tw_bridge/fixed_fft/20260927T212259Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T212406Z](validation/results/A_tw_bridge/fixed_fft/20260927T212406Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T213737Z](validation/results/A_tw_bridge/fixed_fft/20260927T213737Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T214004Z](validation/results/A_tw_bridge/fixed_fft/20260927T214004Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T214123Z](validation/results/A_tw_bridge/fixed_fft/20260927T214123Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T215459Z](validation/results/A_tw_bridge/fixed_fft/20260927T215459Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T215556Z](validation/results/A_tw_bridge/fixed_fft/20260927T215556Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T215818Z](validation/results/A_tw_bridge/fixed_fft/20260927T215818Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T220756Z](validation/results/A_tw_bridge/fixed_fft/20260927T220756Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T221008Z](validation/results/A_tw_bridge/fixed_fft/20260927T221008Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260927T234418Z](validation/results/A_tw_bridge/fixed_fft/20260927T234418Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260928T032931Z](validation/results/A_tw_bridge/fixed_fft/20260928T032931Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260928T045050Z](validation/results/A_tw_bridge/fixed_fft/20260928T045050Z/manifest.json) |
| A_tw_bridge | fixed_fft | [20260928T050246Z](validation/results/A_tw_bridge/fixed_fft/20260928T050246Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T164349Z](validation/results/A_tw_bridge/fixed_input/20260927T164349Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T172906Z](validation/results/A_tw_bridge/fixed_input/20260927T172906Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T185846Z](validation/results/A_tw_bridge/fixed_input/20260927T185846Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T194454Z](validation/results/A_tw_bridge/fixed_input/20260927T194454Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T200512Z](validation/results/A_tw_bridge/fixed_input/20260927T200512Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T200544Z](validation/results/A_tw_bridge/fixed_input/20260927T200544Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T202025Z](validation/results/A_tw_bridge/fixed_input/20260927T202025Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T212411Z](validation/results/A_tw_bridge/fixed_input/20260927T212411Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T214129Z](validation/results/A_tw_bridge/fixed_input/20260927T214129Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T215823Z](validation/results/A_tw_bridge/fixed_input/20260927T215823Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260927T234423Z](validation/results/A_tw_bridge/fixed_input/20260927T234423Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260928T032900Z](validation/results/A_tw_bridge/fixed_input/20260928T032900Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260928T045007Z](validation/results/A_tw_bridge/fixed_input/20260928T045007Z/manifest.json) |
| A_tw_bridge | fixed_input | [20260928T050202Z](validation/results/A_tw_bridge/fixed_input/20260928T050202Z/manifest.json) |
| A_tw_bridge | input_pair | [20260927T200201Z](validation/results/A_tw_bridge/input_pair/20260927T200201Z/manifest.json) |
| A_tw_bridge | input_pair | [20260927T200909Z](validation/results/A_tw_bridge/input_pair/20260927T200909Z/manifest.json) |
| A_tw_bridge | input_pair | [20260927T202349Z](validation/results/A_tw_bridge/input_pair/20260927T202349Z/manifest.json) |
| A_tw_bridge | input_pair | [20260927T212846Z](validation/results/A_tw_bridge/input_pair/20260927T212846Z/manifest.json) |
| A_tw_bridge | input_pair | [20260927T214543Z](validation/results/A_tw_bridge/input_pair/20260927T214543Z/manifest.json) |
| A_tw_bridge | input_pair | [20260927T220149Z](validation/results/A_tw_bridge/input_pair/20260927T220149Z/manifest.json) |
| A_tw_bridge | input_pair | [20260927T234749Z](validation/results/A_tw_bridge/input_pair/20260927T234749Z/manifest.json) |
| A_tw_bridge | input_pair | [20260928T032907Z](validation/results/A_tw_bridge/input_pair/20260928T032907Z/manifest.json) |
| A_tw_bridge | input_pair | [20260928T045017Z](validation/results/A_tw_bridge/input_pair/20260928T045017Z/manifest.json) |
| A_tw_bridge | input_pair | [20260928T050212Z](validation/results/A_tw_bridge/input_pair/20260928T050212Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260927T201720Z](validation/results/A_tw_bridge/input_predicate/20260927T201720Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260927T202352Z](validation/results/A_tw_bridge/input_predicate/20260927T202352Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260927T212850Z](validation/results/A_tw_bridge/input_predicate/20260927T212850Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260927T214547Z](validation/results/A_tw_bridge/input_predicate/20260927T214547Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260927T220153Z](validation/results/A_tw_bridge/input_predicate/20260927T220153Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260927T234753Z](validation/results/A_tw_bridge/input_predicate/20260927T234753Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260928T032910Z](validation/results/A_tw_bridge/input_predicate/20260928T032910Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260928T045022Z](validation/results/A_tw_bridge/input_predicate/20260928T045022Z/manifest.json) |
| A_tw_bridge | input_predicate | [20260928T050219Z](validation/results/A_tw_bridge/input_predicate/20260928T050219Z/manifest.json) |
| A_tw_bridge | invnorm | [20260928T032128Z](validation/results/A_tw_bridge/invnorm/20260928T032128Z/manifest.json) |
| A_tw_bridge | invnorm | [20260928T032423Z](validation/results/A_tw_bridge/invnorm/20260928T032423Z/manifest.json) |
| A_tw_bridge | invnorm | [20260928T045104Z](validation/results/A_tw_bridge/invnorm/20260928T045104Z/manifest.json) |
| A_tw_bridge | invnorm | [20260928T050301Z](validation/results/A_tw_bridge/invnorm/20260928T050301Z/manifest.json) |
| A_tw_bridge | kat | [20260927T140736Z](validation/results/A_tw_bridge/kat/20260927T140736Z/manifest.json) |
| A_tw_bridge | kat | [20260927T145031Z](validation/results/A_tw_bridge/kat/20260927T145031Z/manifest.json) |
| A_tw_bridge | kat | [20260927T145738Z](validation/results/A_tw_bridge/kat/20260927T145738Z/manifest.json) |
| A_tw_bridge | kat | [20260927T150226Z](validation/results/A_tw_bridge/kat/20260927T150226Z/manifest.json) |
| A_tw_bridge | kat | [20260927T151500Z](validation/results/A_tw_bridge/kat/20260927T151500Z/manifest.json) |
| A_tw_bridge | kat | [20260927T164713Z](validation/results/A_tw_bridge/kat/20260927T164713Z/manifest.json) |
| A_tw_bridge | kat | [20260927T172507Z](validation/results/A_tw_bridge/kat/20260927T172507Z/manifest.json) |
| A_tw_bridge | kat | [20260927T185853Z](validation/results/A_tw_bridge/kat/20260927T185853Z/manifest.json) |
| A_tw_bridge | kat | [20260927T194508Z](validation/results/A_tw_bridge/kat/20260927T194508Z/manifest.json) |
| A_tw_bridge | kat | [20260927T200558Z](validation/results/A_tw_bridge/kat/20260927T200558Z/manifest.json) |
| A_tw_bridge | kat | [20260927T202038Z](validation/results/A_tw_bridge/kat/20260927T202038Z/manifest.json) |
| A_tw_bridge | kat | [20260927T212425Z](validation/results/A_tw_bridge/kat/20260927T212425Z/manifest.json) |
| A_tw_bridge | kat | [20260927T214142Z](validation/results/A_tw_bridge/kat/20260927T214142Z/manifest.json) |
| A_tw_bridge | kat | [20260927T215836Z](validation/results/A_tw_bridge/kat/20260927T215836Z/manifest.json) |
| A_tw_bridge | kat | [20260927T234436Z](validation/results/A_tw_bridge/kat/20260927T234436Z/manifest.json) |
| A_tw_bridge | kat | [20260928T032300Z](validation/results/A_tw_bridge/kat/20260928T032300Z/manifest.json) |
| A_tw_bridge | kat | [20260928T044645Z](validation/results/A_tw_bridge/kat/20260928T044645Z/manifest.json) |
| A_tw_bridge | kat | [20260928T045823Z](validation/results/A_tw_bridge/kat/20260928T045823Z/manifest.json) |
| A_tw_bridge | kernel (timing rejected; numerical only) | [20260927T145300Z](validation/results/A_tw_bridge/kernel/20260927T145300Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T145537Z](validation/results/A_tw_bridge/kernel/20260927T145537Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T150021Z](validation/results/A_tw_bridge/kernel/20260927T150021Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T150943Z](validation/results/A_tw_bridge/kernel/20260927T150943Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T151147Z](validation/results/A_tw_bridge/kernel/20260927T151147Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T151343Z](validation/results/A_tw_bridge/kernel/20260927T151343Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T165324Z](validation/results/A_tw_bridge/kernel/20260927T165324Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T172903Z](validation/results/A_tw_bridge/kernel/20260927T172903Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T190202Z](validation/results/A_tw_bridge/kernel/20260927T190202Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T194816Z](validation/results/A_tw_bridge/kernel/20260927T194816Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T200906Z](validation/results/A_tw_bridge/kernel/20260927T200906Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T202346Z](validation/results/A_tw_bridge/kernel/20260927T202346Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T212732Z](validation/results/A_tw_bridge/kernel/20260927T212732Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T214449Z](validation/results/A_tw_bridge/kernel/20260927T214449Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T220143Z](validation/results/A_tw_bridge/kernel/20260927T220143Z/manifest.json) |
| A_tw_bridge | kernel | [20260927T234743Z](validation/results/A_tw_bridge/kernel/20260927T234743Z/manifest.json) |
| A_tw_bridge | kernel | [20260928T032858Z](validation/results/A_tw_bridge/kernel/20260928T032858Z/manifest.json) |
| A_tw_bridge | kernel | [20260928T045001Z](validation/results/A_tw_bridge/kernel/20260928T045001Z/manifest.json) |
| A_tw_bridge | kernel | [20260928T050155Z](validation/results/A_tw_bridge/kernel/20260928T050155Z/manifest.json) |
| A_tw_bridge | profile_probe | [20260927T192720Z](validation/results/A_tw_bridge/profile_probe/20260927T192720Z/manifest.json) |
| A_tw_bridge | rootmul | [20260927T213803Z](validation/results/A_tw_bridge/rootmul/20260927T213803Z/manifest.json) |
| A_tw_bridge | rootmul | [20260927T214540Z](validation/results/A_tw_bridge/rootmul/20260927T214540Z/manifest.json) |
| A_tw_bridge | rootmul | [20260927T220146Z](validation/results/A_tw_bridge/rootmul/20260927T220146Z/manifest.json) |
| A_tw_bridge | rootmul | [20260927T234746Z](validation/results/A_tw_bridge/rootmul/20260927T234746Z/manifest.json) |
| A_tw_bridge | rootmul | [20260928T032936Z](validation/results/A_tw_bridge/rootmul/20260928T032936Z/manifest.json) |
| A_tw_bridge | rootmul | [20260928T045058Z](validation/results/A_tw_bridge/rootmul/20260928T045058Z/manifest.json) |
| A_tw_bridge | rootmul | [20260928T050254Z](validation/results/A_tw_bridge/rootmul/20260928T050254Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T150439Z](validation/results/A_tw_bridge/sigkat/20260927T150439Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T151712Z](validation/results/A_tw_bridge/sigkat/20260927T151712Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T165135Z](validation/results/A_tw_bridge/sigkat/20260927T165135Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T172808Z](validation/results/A_tw_bridge/sigkat/20260927T172808Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T190107Z](validation/results/A_tw_bridge/sigkat/20260927T190107Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T194721Z](validation/results/A_tw_bridge/sigkat/20260927T194721Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T200811Z](validation/results/A_tw_bridge/sigkat/20260927T200811Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T202251Z](validation/results/A_tw_bridge/sigkat/20260927T202251Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T212637Z](validation/results/A_tw_bridge/sigkat/20260927T212637Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T214355Z](validation/results/A_tw_bridge/sigkat/20260927T214355Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T220049Z](validation/results/A_tw_bridge/sigkat/20260927T220049Z/manifest.json) |
| A_tw_bridge | sigkat | [20260927T234649Z](validation/results/A_tw_bridge/sigkat/20260927T234649Z/manifest.json) |
| A_tw_bridge | sigkat | [20260928T032723Z](validation/results/A_tw_bridge/sigkat/20260928T032723Z/manifest.json) |
| A_tw_bridge | sigkat | [20260928T044949Z](validation/results/A_tw_bridge/sigkat/20260928T044949Z/manifest.json) |
| A_tw_bridge | sigkat | [20260928T050140Z](validation/results/A_tw_bridge/sigkat/20260928T050140Z/manifest.json) |
| A_tw_bridge | twiddle | [20260927T184341Z](validation/results/A_tw_bridge/twiddle/20260927T184341Z/manifest.json) |
| A_tw_bridge | twiddle_fft | [20260927T184830Z](validation/results/A_tw_bridge/twiddle_fft/20260927T184830Z/manifest.json) |
| A_tw_bridge | twiddle_fft | [20260927T185259Z](validation/results/A_tw_bridge/twiddle_fft/20260927T185259Z/manifest.json) |
| B_continuous_ds | arithmetic | [20260927T143131Z](validation/results/B_continuous_ds/arithmetic/20260927T143131Z/manifest.json) |
| B_continuous_ds | arithmetic | [20260927T143511Z](validation/results/B_continuous_ds/arithmetic/20260927T143511Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T155959Z](validation/results/B_continuous_ds/decoding/20260927T155959Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T160856Z](validation/results/B_continuous_ds/decoding/20260927T160856Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T163124Z](validation/results/B_continuous_ds/decoding/20260927T163124Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T170648Z](validation/results/B_continuous_ds/decoding/20260927T170648Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T171324Z](validation/results/B_continuous_ds/decoding/20260927T171324Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T173852Z](validation/results/B_continuous_ds/decoding/20260927T173852Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T174449Z](validation/results/B_continuous_ds/decoding/20260927T174449Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T174653Z](validation/results/B_continuous_ds/decoding/20260927T174653Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T175941Z](validation/results/B_continuous_ds/decoding/20260927T175941Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T181340Z](validation/results/B_continuous_ds/decoding/20260927T181340Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T183257Z](validation/results/B_continuous_ds/decoding/20260927T183257Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T203502Z](validation/results/B_continuous_ds/decoding/20260927T203502Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T204247Z](validation/results/B_continuous_ds/decoding/20260927T204247Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T204742Z](validation/results/B_continuous_ds/decoding/20260927T204742Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T205320Z](validation/results/B_continuous_ds/decoding/20260927T205320Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T205816Z](validation/results/B_continuous_ds/decoding/20260927T205816Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T210938Z](validation/results/B_continuous_ds/decoding/20260927T210938Z/manifest.json) |
| B_continuous_ds | decoding | [20260927T211437Z](validation/results/B_continuous_ds/decoding/20260927T211437Z/manifest.json) |
| B_continuous_ds | division | [20260927T170403Z](validation/results/B_continuous_ds/division/20260927T170403Z/manifest.json) |
| B_continuous_ds | division | [20260927T170513Z](validation/results/B_continuous_ds/division/20260927T170513Z/manifest.json) |
| B_continuous_ds | division | [20260927T171330Z](validation/results/B_continuous_ds/division/20260927T171330Z/manifest.json) |
| B_continuous_ds | division | [20260927T174457Z](validation/results/B_continuous_ds/division/20260927T174457Z/manifest.json) |
| B_continuous_ds | division | [20260927T175949Z](validation/results/B_continuous_ds/division/20260927T175949Z/manifest.json) |
| B_continuous_ds | division | [20260927T181348Z](validation/results/B_continuous_ds/division/20260927T181348Z/manifest.json) |
| B_continuous_ds | division | [20260927T183306Z](validation/results/B_continuous_ds/division/20260927T183306Z/manifest.json) |
| B_continuous_ds | division | [20260927T203510Z](validation/results/B_continuous_ds/division/20260927T203510Z/manifest.json) |
| B_continuous_ds | division | [20260927T204750Z](validation/results/B_continuous_ds/division/20260927T204750Z/manifest.json) |
| B_continuous_ds | division | [20260927T205824Z](validation/results/B_continuous_ds/division/20260927T205824Z/manifest.json) |
| B_continuous_ds | division | [20260927T211450Z](validation/results/B_continuous_ds/division/20260927T211450Z/manifest.json) |
| B_continuous_ds | encoding (timing rejected; numerical only) | [20260927T152954Z](validation/results/B_continuous_ds/encoding/20260927T152954Z/manifest.json) |
| B_continuous_ds | encoding (timing rejected; numerical only) | [20260927T153236Z](validation/results/B_continuous_ds/encoding/20260927T153236Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T154222Z](validation/results/B_continuous_ds/encoding/20260927T154222Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T154531Z](validation/results/B_continuous_ds/encoding/20260927T154531Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T154832Z](validation/results/B_continuous_ds/encoding/20260927T154832Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T161446Z](validation/results/B_continuous_ds/encoding/20260927T161446Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T162358Z](validation/results/B_continuous_ds/encoding/20260927T162358Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T162610Z](validation/results/B_continuous_ds/encoding/20260927T162610Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T163109Z](validation/results/B_continuous_ds/encoding/20260927T163109Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T171309Z](validation/results/B_continuous_ds/encoding/20260927T171309Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T174434Z](validation/results/B_continuous_ds/encoding/20260927T174434Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T175926Z](validation/results/B_continuous_ds/encoding/20260927T175926Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T180800Z](validation/results/B_continuous_ds/encoding/20260927T180800Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T181315Z](validation/results/B_continuous_ds/encoding/20260927T181315Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T182456Z](validation/results/B_continuous_ds/encoding/20260927T182456Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T183231Z](validation/results/B_continuous_ds/encoding/20260927T183231Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T203114Z](validation/results/B_continuous_ds/encoding/20260927T203114Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T204354Z](validation/results/B_continuous_ds/encoding/20260927T204354Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T205428Z](validation/results/B_continuous_ds/encoding/20260927T205428Z/manifest.json) |
| B_continuous_ds | encoding | [20260927T211050Z](validation/results/B_continuous_ds/encoding/20260927T211050Z/manifest.json) |
| B_continuous_ds | extra | [20260927T150106Z](validation/results/B_continuous_ds/extra/20260927T150106Z/manifest.json) |
| B_continuous_ds | extra | [20260927T154035Z](validation/results/B_continuous_ds/extra/20260927T154035Z/manifest.json) |
| B_continuous_ds | extra | [20260927T161259Z](validation/results/B_continuous_ds/extra/20260927T161259Z/manifest.json) |
| B_continuous_ds | extra | [20260927T162922Z](validation/results/B_continuous_ds/extra/20260927T162922Z/manifest.json) |
| B_continuous_ds | extra | [20260927T171124Z](validation/results/B_continuous_ds/extra/20260927T171124Z/manifest.json) |
| B_continuous_ds | extra | [20260927T174248Z](validation/results/B_continuous_ds/extra/20260927T174248Z/manifest.json) |
| B_continuous_ds | extra | [20260927T175741Z](validation/results/B_continuous_ds/extra/20260927T175741Z/manifest.json) |
| B_continuous_ds | extra | [20260927T181130Z](validation/results/B_continuous_ds/extra/20260927T181130Z/manifest.json) |
| B_continuous_ds | extra | [20260927T183047Z](validation/results/B_continuous_ds/extra/20260927T183047Z/manifest.json) |
| B_continuous_ds | extra | [20260927T203307Z](validation/results/B_continuous_ds/extra/20260927T203307Z/manifest.json) |
| B_continuous_ds | extra | [20260927T204547Z](validation/results/B_continuous_ds/extra/20260927T204547Z/manifest.json) |
| B_continuous_ds | extra | [20260927T205621Z](validation/results/B_continuous_ds/extra/20260927T205621Z/manifest.json) |
| B_continuous_ds | extra | [20260927T211243Z](validation/results/B_continuous_ds/extra/20260927T211243Z/manifest.json) |
| B_continuous_ds | fixed_input | [20260927T175449Z](validation/results/B_continuous_ds/fixed_input/20260927T175449Z/manifest.json) |
| B_continuous_ds | fixed_input | [20260927T181123Z](validation/results/B_continuous_ds/fixed_input/20260927T181123Z/manifest.json) |
| B_continuous_ds | fixed_input | [20260927T183040Z](validation/results/B_continuous_ds/fixed_input/20260927T183040Z/manifest.json) |
| B_continuous_ds | fixed_input | [20260927T203128Z](validation/results/B_continuous_ds/fixed_input/20260927T203128Z/manifest.json) |
| B_continuous_ds | fixed_input | [20260927T204408Z](validation/results/B_continuous_ds/fixed_input/20260927T204408Z/manifest.json) |
| B_continuous_ds | fixed_input | [20260927T205442Z](validation/results/B_continuous_ds/fixed_input/20260927T205442Z/manifest.json) |
| B_continuous_ds | fixed_input | [20260927T211104Z](validation/results/B_continuous_ds/fixed_input/20260927T211104Z/manifest.json) |
| B_continuous_ds | kat | [20260927T141514Z](validation/results/B_continuous_ds/kat/20260927T141514Z/manifest.json) |
| B_continuous_ds | kat | [20260927T142114Z](validation/results/B_continuous_ds/kat/20260927T142114Z/manifest.json) |
| B_continuous_ds | kat | [20260927T143656Z](validation/results/B_continuous_ds/kat/20260927T143656Z/manifest.json) |
| B_continuous_ds | kat | [20260927T144628Z](validation/results/B_continuous_ds/kat/20260927T144628Z/manifest.json) |
| B_continuous_ds | kat | [20260927T153021Z](validation/results/B_continuous_ds/kat/20260927T153021Z/manifest.json) |
| B_continuous_ds | kat | [20260927T153739Z](validation/results/B_continuous_ds/kat/20260927T153739Z/manifest.json) |
| B_continuous_ds | kat | [20260927T160048Z](validation/results/B_continuous_ds/kat/20260927T160048Z/manifest.json) |
| B_continuous_ds | kat | [20260927T160926Z](validation/results/B_continuous_ds/kat/20260927T160926Z/manifest.json) |
| B_continuous_ds | kat | [20260927T162614Z](validation/results/B_continuous_ds/kat/20260927T162614Z/manifest.json) |
| B_continuous_ds | kat | [20260927T170813Z](validation/results/B_continuous_ds/kat/20260927T170813Z/manifest.json) |
| B_continuous_ds | kat | [20260927T174024Z](validation/results/B_continuous_ds/kat/20260927T174024Z/manifest.json) |
| B_continuous_ds | kat | [20260927T175534Z](validation/results/B_continuous_ds/kat/20260927T175534Z/manifest.json) |
| B_continuous_ds | kat | [20260927T180841Z](validation/results/B_continuous_ds/kat/20260927T180841Z/manifest.json) |
| B_continuous_ds | kat | [20260927T182812Z](validation/results/B_continuous_ds/kat/20260927T182812Z/manifest.json) |
| B_continuous_ds | kat | [20260927T203135Z](validation/results/B_continuous_ds/kat/20260927T203135Z/manifest.json) |
| B_continuous_ds | kat | [20260927T204415Z](validation/results/B_continuous_ds/kat/20260927T204415Z/manifest.json) |
| B_continuous_ds | kat | [20260927T205449Z](validation/results/B_continuous_ds/kat/20260927T205449Z/manifest.json) |
| B_continuous_ds | kat | [20260927T211111Z](validation/results/B_continuous_ds/kat/20260927T211111Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T145627Z](validation/results/B_continuous_ds/kernel/20260927T145627Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T154219Z](validation/results/B_continuous_ds/kernel/20260927T154219Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T161443Z](validation/results/B_continuous_ds/kernel/20260927T161443Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T163106Z](validation/results/B_continuous_ds/kernel/20260927T163106Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T171306Z](validation/results/B_continuous_ds/kernel/20260927T171306Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T174431Z](validation/results/B_continuous_ds/kernel/20260927T174431Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T175923Z](validation/results/B_continuous_ds/kernel/20260927T175923Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T181312Z](validation/results/B_continuous_ds/kernel/20260927T181312Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T183229Z](validation/results/B_continuous_ds/kernel/20260927T183229Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T203448Z](validation/results/B_continuous_ds/kernel/20260927T203448Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T204728Z](validation/results/B_continuous_ds/kernel/20260927T204728Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T205802Z](validation/results/B_continuous_ds/kernel/20260927T205802Z/manifest.json) |
| B_continuous_ds | kernel | [20260927T211423Z](validation/results/B_continuous_ds/kernel/20260927T211423Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T153700Z](validation/results/B_continuous_ds/rounding/20260927T153700Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T154822Z](validation/results/B_continuous_ds/rounding/20260927T154822Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T161449Z](validation/results/B_continuous_ds/rounding/20260927T161449Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T163113Z](validation/results/B_continuous_ds/rounding/20260927T163113Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T171313Z](validation/results/B_continuous_ds/rounding/20260927T171313Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T174438Z](validation/results/B_continuous_ds/rounding/20260927T174438Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T175930Z](validation/results/B_continuous_ds/rounding/20260927T175930Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T181329Z](validation/results/B_continuous_ds/rounding/20260927T181329Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T183246Z](validation/results/B_continuous_ds/rounding/20260927T183246Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T203451Z](validation/results/B_continuous_ds/rounding/20260927T203451Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T204731Z](validation/results/B_continuous_ds/rounding/20260927T204731Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T205805Z](validation/results/B_continuous_ds/rounding/20260927T205805Z/manifest.json) |
| B_continuous_ds | rounding | [20260927T211426Z](validation/results/B_continuous_ds/rounding/20260927T211426Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T150534Z](validation/results/B_continuous_ds/sigkat/20260927T150534Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T154121Z](validation/results/B_continuous_ds/sigkat/20260927T154121Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T161345Z](validation/results/B_continuous_ds/sigkat/20260927T161345Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T163009Z](validation/results/B_continuous_ds/sigkat/20260927T163009Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T171209Z](validation/results/B_continuous_ds/sigkat/20260927T171209Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T174334Z](validation/results/B_continuous_ds/sigkat/20260927T174334Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T175827Z](validation/results/B_continuous_ds/sigkat/20260927T175827Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T181215Z](validation/results/B_continuous_ds/sigkat/20260927T181215Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T183132Z](validation/results/B_continuous_ds/sigkat/20260927T183132Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T203352Z](validation/results/B_continuous_ds/sigkat/20260927T203352Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T204632Z](validation/results/B_continuous_ds/sigkat/20260927T204632Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T205706Z](validation/results/B_continuous_ds/sigkat/20260927T205706Z/manifest.json) |
| B_continuous_ds | sigkat | [20260927T211327Z](validation/results/B_continuous_ds/sigkat/20260927T211327Z/manifest.json) |
