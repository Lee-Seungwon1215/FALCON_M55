# RNS Slothy 구현과 검증 범위

## 변하지 않은 것

K4-C의 31-bit rounding Montgomery, 4×32-bit MVE, 2-layer CT/GS,
H1 final scaling, D1 transpose, full inverse roots 및 C fallback을 유지했다.
q=12289 `mq_cm55.s`는 기존 Slothy A 그대로다. FFT, sampler, CRT, Bezout,
상수표 생성, RNS 점별 곱셈은 이번 변경 대상이 아니다.

## A

`kgen_mp31_cm55.s`의 일반 forward/inverse, 작은 even-forward, odd layer,
transpose 경계 및 inverse final-two 공유 본문을 포함한 12개 구간을 최적화했다.
매크로를 확장한 뒤 실제 Slothy CP-SAT에 명령 순서와 제한된 벡터 레지스터
할당을 맡겼다. 48-unit 단위로 각 경계의 모든 레지스터를 보존했다.
이는 제한된 탐색이며 전역 최적해라는 주장이 아니다.

메모리 명령은 하나의 순서 토큰으로 연결한다. post-index 명령의 base register
갱신은 입출력으로 모델링한다. VPT/VADDT와 VLD4/VST4는 각각 원자적 묶음이다.
GPR, q0, partial-register view는 고정하고 spill을 허용하지 않았다.
적용되지 않은 명령 형식은 오류로 중단한다.

## B

A의 각 반복을 `[a;b]`로 나눈 후 `b;a`를 Slothy로 재배치했다.
최종 코드는 `a; (b;a)^(N-1); b`이며 N=1에서는 가운데 루프를 건너뛴다.
pointer 종료 루프는 a에 첫 stream의 post-index가 있는지에 따라 공개 end
pointer만 조정한다. count 종료 루프는 공개 counter를 한 번 줄인다.
logn=4가 중간 본문으로 진입하는 inverse final-two는 A만 적용했다.

이는 m55_slothy.pdf §7.5의 halving heuristic이며, Slothy native full
software-pipelining solver를 켰다는 뜻은 아니다. A와 B는 별도 후보이고
B 자체가 A에 반복 간 겹치기를 추가한 경우다.

## 모델과 검사의 한계

프로젝트 adapter는 보수적 비용 모델을 사용한다. 실제 M55의 모든 forwarding,
bank conflict, 명령별 latency를 완전히 모델링하지 않는다. 후보 채택은 모델
예상 cycle이 아니라 동일한 실보드 측정으로 결정한다.

Slothy CFG 검사 외에 register-version/memory dependency graph 검사를 수행했다.
별도 명령 에뮬레이터는 adapter/solver를 import하지 않으며, 32-bit 명령의
수치·predicate·post-index·gather/structure access를 실행해 2,944개 조합을 비교한다.
이는 유용한 회귀검사지만 형식적 ISA 동등성 증명은 아니다.

보드에서는 308개 소수의 forward/inverse/왕복, signed Montgomery, 독립 iNTT
입력과 경계 패턴, buffer guards, 프로젝트 host KAT/digest, 정상 서명 검증 및
변조 거부를 확인했다. timing 측정은 prime[0]에서만 했으므로 모든 소수의 성능을
직접 재본 값으로 해석하지 않는다.

상수시간은 기존 공개 분기/주소 성질을 유지했는지 정적으로 확인했다.
비밀값 조건은 원래처럼 lane predication을 사용한다. 새로운 분기 조건은
공개 반복 횟수 또는 배열 traversal pointer뿐이다. 통계적 leakage 검사,
전력/EM 분석, 형식적 상수시간 증명은 수행하지 않았다.

## 배치와 실제 코드의 구분

세 후보 모두 GNU function sections와 동일한 stride literal 사본을 갖는다.
벤치마크 linker는 RNS NTT/iNTT/small 시작점을 고정하고 나머지 함수 주소도
같게 유지한다. 이것은 코드 크기에 따른 배치 영향을 통제하기 위한 측정 조건이며,
다른 후보의 함수를 링크해서 구현을 선택하는 장치가 아니다.

실제 구현은 각 폴더의 완전한 `kgen_mp31_cm55.s` 안에 있다. 일반 GNU
`.text.*` 수집 링크에서도 구현을 사용할 수 있지만, 배치가 달라진 펌웨어에서
이번 표의 절대 cycle이 그대로 나온다고 가정하면 안 된다.

## 출처

- REFERENCE/m55_slothy.pdf, *Fast and Clean*, §§4.1–4.8 (pp.11–16),
  §§4.11–4.13 (pp.17–18), §7.5 (p.28): scheduling, allocation, memory/flags,
  split windows 및 halving heuristic.
- REFERENCE/m55_ntt-ftt_opt.pdf, *Polynomial multiplication on embedded vector
  architectures*, §6.4.2 (pp.17–18), §6.4.5 (p.19): Montgomery/add/sub/load/store
  interleaving, boundary layout, inverse scaling fusion.
- 논문의 기법을 현재 FN-DSA 31-bit RNS에 적용한 설계다. 논문의 Kyber/Dilithium
  수치나 NTT 표현을 FN-DSA에 그대로 대입한 재현 실험은 아니다.
