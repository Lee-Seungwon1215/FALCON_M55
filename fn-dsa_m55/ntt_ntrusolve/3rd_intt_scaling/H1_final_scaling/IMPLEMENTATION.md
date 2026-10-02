# H1 final scaling — 구현 원리와 검증 범위

변경 대상은 `kgen_mp31_cm55.s`의 RNS iNTT뿐이다. 이 파일 외의 암호 C/H/S는 H0와 동일하다.
2-layer, forward logn4/6 전용 경로, M1_improve Montgomery, C fallback은 유지한다.

## 정수 수식

`p < 2^31`, `R=2^32`, `n=2^logn`이다. 원본 `igm`은 `u=wR/2 mod p`를 저장한다.
H0 버터플라이는 다음을 계산한다(모든 나눗셈은 모듈러 역원 곱셈).

```
sum  = (a+b)/2 mod p
diff = Montgomery(a-b,u) = (a-b)w/2 mod p
```

H1의 중간 레이어는 `2u mod p`를 레지스터에서 만든 뒤 다음을 계산한다.

```
sum  = (a+b) mod p
diff = Montgomery(a-b,2u) = (a-b)w mod p
```

중간 변환은 선형이므로 모든 레이어에서 빠진 `1/2`의 곱은 마지막의 `1/n`으로 보정할 수 있다.
MVE 경로의 logn4..10에서는 `R/n = 2^(32-logn) < p`이므로 시프트 하나로
`1/n`의 Montgomery 표현을 얻는다. 부동소수점이나 정수 나눗셈 명령은 사용하지 않는다.

마지막 차분 회전상수는 함수 호출당 한 번 다음처럼 준비한다.

```
v = 2 * Montgomery(igm[1],R/n) mod p = wR/n mod p
```

마지막 레이어의 차분은 원래 있던 Montgomery 곱셈에 `v`를 사용한다.
합 출력에는 `R/n`으로 Montgomery 곱셈을 한 뒤 바로 저장한다.
따라서 최종 스케일링을 위한 별도의 전체 배열 read/write pass는 없다.

## 코드 구분

- `MP31_IROOT`: shared `igm`은 변경하지 않고 읽은 root만 canonical modular doubling.
- `MP31_GS`: 단계별 `MP31_HALF` 제거. 합은 `[0,p)`, 차분은 `(-p,p)` 유지.
- `MP31_FINAL_ROOT`: 마지막 차분 root를 한 번 준비. `vmov r7/r8,s0`는 비트 이동이다.
- `.Lintt_final_two_loop`: logn4/6/8/10의 마지막 2-layer. 마지막 두 합만 별도 scaling.
- `.Lintt_odd_loop`: logn5/7/9의 마지막 1-layer. 합 scaling과 차분 scaling을 저장 전에 완료.

`MP31_MONT`의 `VHADD`는 rounding Montgomery의 여분 합 비트를 보존하는 연산이다.
inverse normalization과 무관하므로 제거하지 않았다.

## 범위와 ABI

canonical 입력의 합을 32-bit에서 더한 뒤 p를 빼면 수학적 값은 `[-p,p-2]`에 들어간다.
이 범위는 signed32에 들어가므로 기존 VPT/VADDT 보정이 정확하게 `[0,p)`를 만든다.
차분은 `[-p+1,p-1]`이므로 기존 M1 signed Montgomery 계약을 만족한다.
상수 복원과 최종 보정에도 같은 canonical Montgomery/덧셈을 사용한다.
단계별 `/2`만 제거했으며 modular reduction을 생략하는 lazy arithmetic은 도입하지 않았다.

지역 프레임 8 B + GPR 저장 40 B + MVE 저장 64 B = 112 B. H0와 동일하다.
계수 spill이나 새 scratch 배열은 없다. `igm`은 다른 호출에서도 재사용되므로 절대로 덮어쓰지 않는다.

## 주소 통제

H1의 iNTT는 1400 B이며 원본 H0는 970 B다. 전체 ELF ITCM 사용량 차이는 alignment 포함 432 B다.
이를 다른 함수의 성능 변화와 혼동하지 않도록 `../experiments/h0_layout`에 H0 전체 복사본을 두고,
return 뒤 실행되지 않는 공간만 채워 H1과 일치시켰다. H0 원본은 유지했다.
대조군의 일부 ADR 명령은 늘어난 상수 거리 때문에 넓은 인코딩으로 조립되어 함수 크기가 974 B다.
수식·명령 순서는 바뀌지 않으며 이 대조군 자체를 새로 측정한다.

`../audit_scaling.py`는 iNTT 슬롯 밖의 모든 allocated byte·주소·크기가 같은지 검사한다.
이 검사는 성능용 및 산술 audit용 ELF 각각에 적용한다.

## 상수시간 해석

새 일반 분기는 공개 logn, layer/group counter, 정해진 배열 경계 비교만 사용한다.
gather offset은 고정된 `0,8,16,24`이며 root 주소도 공개 크기/인덱스에서 나온다.
계수에 따른 분기·테이블 주소·정수 나눗셈·FP 변환을 추가하지 않았다.
VPT/VADDT 데이터 조건부 정규화는 기존 방식을 유지한다.

정적 소스/디스어셈블리 검토이지, 통계적 timing leakage 검사나 형식적 상수시간 증명은 아니다.
키 생성 전체의 후보 재시도까지 상수시간이라고 주장하지 않는다.
