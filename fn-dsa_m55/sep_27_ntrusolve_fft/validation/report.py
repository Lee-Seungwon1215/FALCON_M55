#!/usr/bin/env python3
"""Build a traceable report from valid completed runs, with explicit scope."""
import json,re,subprocess,sys,hashlib
from pathlib import Path
p=Path(__file__).resolve().parent;r=p.parent
subprocess.run([sys.executable,str(p/'summarize.py')],check=True,stdout=subprocess.DEVNULL)
data=json.loads((p/'summary.json').read_text())
def last(c,m):return [v for v in data if v['candidate']==c and v['mode']==m][-1]
def means(v):return [v['mean_cycles'][str(d)] for d in (512,1024)]
base=last('baseline_m55','keygen');ntt=last('baseline_ntt','keygen')
current={}
for c in ('A_tw_bridge','B_continuous_ds'):
    hashes={str(f):hashlib.sha256(f.read_bytes()).hexdigest()
            for f in (r/c).glob('*.[chs]')}
    current[c]={}
    for mode in ('kat','extra','sigkat','keygen','profile','kernel','encoding','rounding','decoding','fixed_input','input_pair','input_predicate','division','fixed_division','fixed_fft','rootmul','fft_alignment','fft_placement','fft_context','fft_replay','profile_probe','fft_fusion','invnorm'):
        for v in reversed(data):
            if v['candidate']!=c or v['mode']!=mode:continue
            m=json.loads((p/v['manifest']).read_text())
            if all(m['source_sha256'].get(k)==s for k,s in hashes.items()):
                current[c][mode]=v['run'];break
(p/'current_validation.json').write_text(json.dumps(current,indent=2)+'\n')
def current_run(c,m):
    run=current.get(c,{}).get(m)
    return next((v for v in data if v['candidate']==c and v['mode']==m
                 and v['run']==run),None)
lines=['# NTRU solve FFT 실험 결과','',
 '**목표 1.7배는 아직 달성하지 못했다. 기존 M55_ref/ntt_opt는 변경하지 않았다.**','',
 '## 조건','',
 'NUCLEO-N657X0-Q, STM32N657 Cortex-M55, 800 MHz, 코드 ITCM 256 KiB, '
 '데이터·상수·스택 DTCM 256 KiB, I/D cache OFF, TCM ECC ON. '
 'GCC 15.2.1, `-O3 -mcpu=cortex-m55 -mfpu=fpv5-d16 -mfloat-abi=hard`, '
 '`-ffp-contract=off -fno-fast-math -fno-strict-aliasing`. '
 'M4 어셈블리는 켜고, ntt_opt 이후 후보에는 기존 MVE NTT도 그대로 유지했다.','',
 '각 크기에서 동일 upstream seed 100개, warmup 3회 제외, 실패 후보와 재시도·키 인코딩 포함. '
 'KAT/NTRU 방정식 검사는 시간 밖에서 수행. 아래 전체 성능은 계측 hook 없는 빌드이다. '
 '커널은 IRQ를 막았고, 전체 키생성은 공통 Zephyr 실행 조건에서 IRQ를 허용했다. '
 '동일 배치 정책이지만 함수 주소가 모두 고정된 실험은 아니므로 미세한 차이는 배치 영향도 포함한다.','',
 '## 현재 소스의 전체 키생성 요약','',
 '| 구현 | 512 cycles | M55_ref 대비 | 1024 cycles | M55_ref 대비 |',
 '| --- | ---: | ---: | ---: | ---: |']
for c in ('baseline_m55','baseline_ntt','A_tw_bridge','B_continuous_ds'):
    v=last(c,'keygen') if c.startswith('baseline_') else current_run(c,'keygen')
    if v is None:
        lines.append(f'| {c} | 현재 소스 미측정 | — | 현재 소스 미측정 | — |')
        continue
    a,b=means(v);x,y=means(base)
    lines.append(f'| [{c} / {v["run"]}](validation/{v["manifest"]}) | {a:,.2f} | {x/a:.4f}× | {b:,.2f} | {y/b:.4f}× |')
lines+=['','이 표의 A/B 성능은 현재 암호 소스 해시와 일치하는 실행만 사용한다. '
        '완료한 검증 항목은 아래 current_validation.json에서 별도로 확인한다. '
        '배율은 원본 시간 ÷ 후보 시간이다.','',
 '## 전체 키생성: 과거 버전과 반복을 포함한 모든 실측','',
 '| 경로·run (UTC) | 512 cycles | M55_ref 대비 | 1024 cycles | M55_ref 대비 |',
 '| --- | ---: | ---: | ---: | ---: |']
for v in data:
    if v['mode']!='keygen':continue
    a,b=means(v);x,y=means(base)
    link='validation/'+v['manifest']
    lines.append(f'| [{v["candidate"]} / {v["run"]}]({link}) | {a:,.2f} | {x/a:.4f}× | {b:,.2f} | {y/b:.4f}× |')
lines+=['','## 현재 후보와 추가 효과','',
        'A의 현재 소스는 A17-cleanup(A16 + FP64 invnorm, 미사용 코드 정리): '
        '[정리 후 재검증](validation/cleanup/README.md)을 별도로 기록했다. '
        '사용자의 2026-09-28 요청에 따라 '
        '후보 직교 노름 검사의 invnorm(e=0)에 예전 native FP64 제곱합·역수를 적용했다. '
        'Q32 ABI와 주변 FFT/iFFT는 유지하며 계수별 입출력 변환을 포함한다. '
        '[추가 함수·전체 측정](validation/invnorm_results.md)을 참조한다. '
        '이전 A16까지의 NTRU 구현은 다음과 같다. 중간 축소의 계산 규칙은 원래 고정소수점으로 유지하되, '
        'FFT 입력 변환 poly_big_to_fixed와 NTRU 내부 역수 계산의 Q32 나눗셈을 정수 MVE로 병렬화했다. '
        '역수 배열은 고정소수점 그대로이며, 전역 inner_fxr_div와 후보 검사는 변경하지 않았다. '
        'A9의 회전상수 전용 정수 MVE 곱셈과 벡터 덧셈·원래 단계별 half를 A10에서는 '
        '하나의 butterfly 어셈블리 반복문으로 합쳤다. 3072바이트 임시 배열을 64바이트 작업공간으로 줄이고, '
        'NTRU intermediate의 forward logn>=5, inverse logn>=4에서 사용한다. '
        '그보다 작은 크기와 후보 노름 검사의 FFT는 원본을 유지한다. '
        'A11은 logn=1 입력 변환에서 두 계수×두 자리를 MVE lane에 배치해 모든 자리의 마스크 선택을 병렬 처리한다. '
        'A12는 logn>=2의 자리 선택 마스크를 벡터 비교·OR로 단축한다. 모든 입력 자리는 조건 없이 읽는다. '
        'A13은 큰 FFT의 마지막 두 레이어와 iFFT의 처음 두 레이어에서 서로 다른 회전상수를 쓰는 '
        'butterfly 네 개를 묶어 정수 MVE로 처리한다. 원래 3곱과 단계별 half를 유지한다. '
        'A14는 실제 회전상수 성분의 범위로 두 곱셈을 단축하고, 독립적인 곱의 계산 순서와 '
        '레지스터 수명을 바꿔 임시 공간을 256에서 160바이트로 줄인다. 합친 상수의 곱은 일반 연산을 유지한다. '
        'A15는 짧은 레이어의 최종 실수부·허수부 결과를 레지스터에서 직접 소비해 스택 저장·재읽기 8회를 없앤다. '
        'forward는 오프셋 표 읽기가 1회 추가된다. 또한 공개된 크기 16에서 같은 벡터 경로가 이기는 것을 '
        '별도로 확인해 forward 하한을 logn=5에서 4로 낮췄다. 현재 forward/inverse 모두 logn>=4에 적용되며, '
        '그보다 작은 크기와 후보 노름 검사는 여전히 원본이다. '
        'A16은 ht=1 레이어의 회전상수와 inverse 입력을 VLD4로 읽고 forward 결과를 VST4로 저장한다. '
        'ht=2의 원래 gather 배치는 유지하며, 공개된 ht/direction별 네 반복문으로 내부 분기를 피한다. '
        '대신 코드가 1,540바이트 늘고, 데이터·스택 할당량은 그대로다. '
        'depth0만 double 경계 + DS FFT/iFFT + FP64 나눗셈을 사용한다. '
        'A4/A5에서 발견한 입력별 시간차는 고정 명령열 판정으로 수정했다. '
        '최초 TW 전체 구간 교체와 구분한다. B는 B18: DS 배열을 유지하고 계수별 정확한 정수 보조 연산을 합쳤으며, '
        '입력 표현 변환·최종 k 반올림·점별 곱셈·역수·나눗셈의 표현 경계를 4개씩 처리한다. '
        'Q32 곱셈과 나눗셈 자체는 원래 정수 규칙을 유지한다. B9는 모든 입력 자리를 순서대로 읽는 '
        '마스크 선택 작업까지 4개 계수씩 MVE로 처리한다. B10은 기존 64단계 Q32 나눗셈도 '
        '네 계수에 병렬 적용하며, 근사 FP 나눗셈으로 바꾸거나 원래 반올림 규칙을 완화하지 않았다. '
        'B11은 점별 곱셈의 디코딩·정확한 Q32 3곱·인코딩을 한 어셈블리 루프로 통합하고 '
        '각 Q32 곱도 정수 MVE로 네 계수씩 처리한다. B12는 작은 크기(logn=1..3)의 고정소수점 입력 변환도 '
        '자체 정수 MVE 어셈블리로 처리한다. B13은 큰 입력의 자리 선택·FP32 변환도 하나의 루프로 합치고 '
        '작은 C 경로를 분리하여 큰 경로의 레지스터 저장 비용을 줄였다. '
        'B14는 입력 인코더의 다섯 오차 보존 덧셈만 피연산자 범위에 근거해 FastTwoSum으로 단축했다. '
        'B15는 큰 입력 자리 선택의 마스크만 벡터 비교·OR로 단축하며 모든 자리 읽기는 유지한다. '
        'B16은 디코더의 floor·소수 부분 관계가 보장되는 세 곳에서만 오차 보존 덧셈을 단축한다. '
        'B17은 같은 디코더의 정수 지수 추출·상수 설정·자리올림 명령을 동일 비트 규칙으로 단축한다. '
        'B18은 변하지 않는 역수의 DS 표현을 한 번만 디코딩해 기존 rt3 버퍼에 저장한다. '
        '반복 중에는 이 캐시를 읽으며, 준비 비용도 I_mul 비중과 전체 시간에 포함한다. '
        '디코더·반올림의 일반 TwoSum과 큰 FFT의 DS 표현·정밀도 선택 기준은 변경하지 않았다.','',
        '| 후보 | 512: ntt_opt 대비 시간 변화 | 1024: ntt_opt 대비 시간 변화 |','| --- | ---: | ---: |']
for c in ('A_tw_bridge','B_continuous_ds'):
    v=current_run(c,'keygen')
    if v is None:
        lines.append(f'| {c} | 현재 소스 미측정 | 현재 소스 미측정 |')
        continue
    a,b=means(v);x,y=means(ntt)
    lines.append(f'| {c} / {v["run"]} | {(a/x-1)*100:+.4f}% | {(b/y-1)*100:+.4f}% |')
lines+=['','음수는 시간 감소, 양수는 느려짐. M55_ref 대비 이득 전체를 새 FFT 최적화의 성과로 해석하면 안 된다.','',
        '## 원래 기준의 최적화 가능 범위','',
        '분모는 키생성 전체. 분자는 NTRU intermediate/depth0의 입력 변환, FFT, 역수·곱셈·나눗셈, iFFT, 정수 k 반올림. '
        '`I_update`는 NTT 등 정수 다항식 갱신이므로 제외한다. 이 비중 표는 후보 직교노름 검사를 '
        '포함하지 않으므로 A17의 추가 invnorm 효과까지 설명하는 표는 아니다.','',
        '| 기준 | 512 | 1024 |','| --- | ---: | ---: |']
for c in ('baseline_m55','baseline_ntt','A_tw_bridge','B_continuous_ds'):
    v=last(c,'profile') if c.startswith('baseline_') else current_run(c,'profile')
    if v is None:
        lines.append(f'| {c} | 현재 소스 미측정 | 현재 소스 미측정 |')
        continue
    lines.append(f'| {c} / {v["run"]} | {v["scope_percent"]["512"]:.5f}% | {v["scope_percent"]["1024"]:.5f}% |')
lines+=['','계측 hook 포함 비중이며 위의 비계측 전체 사이클과 혼합해 정확한 가속률로 주장하지 않는다. '
        'M55_ref에서 대상 시간이 약 11.88%/7.39%이다. 다른 작업량을 고정하면, 이 시간을 0으로 줄여도 '
        '약 1.135배/1.080배가 한계다. 이는 그 전제에서의 Amdahl 추정이며 모든 새 알고리즘에 대한 불가능성 증명은 아니다. '
        '이미 채택한 NTT 이득까지 포함하려면 다른 계산이 필요하다: 같은 계측 빌드의 M55_ref 전체를 '
        '(ntt_opt 전체 − 그 FFT 대상 시간)으로 나눈 이상적 추정은 약 1.26배/1.17배이다. '
        '이 역시 다른 작업량을 고정하고 FFT 비용을 0으로 놓은 가정이지 실측 성과가 아니다. '
        '1.7배에는 전체 시간의 41.18% 제거가 필요하다. 반복 횟수/정수 갱신/다른 단계를 바꾸는 것은 '
        '현재 커널 최적화와 별도 범위·정확성 검토가 필요하다.','',
        '## 세부 검증 및 근거','',
        '- [전체 측정 요약](validation/measurement_summary.md), [JSON](validation/summary.json).',
        '- [크기별 커널·변환·오차·입력별 시간](validation/kernel_summary.md). 변환 미포함 성능과 실제 경계 비용을 구분한다.',
        '- [실험별 변경 기록](research/experiment_log.md). A0–A16, B0–B18를 구분한다.',
        '- [A7 고정소수점 입력 변환](validation/fixed_input_results.md). 원본 Q32 비트 비교와 크기별 실제 호출 비용.',
        '- [B 경계 연산 검증](validation/boundary_results.md). 단독 개선과 전체 개선을 구분한다.',
        '- [B9 입력 자리 선택·변환](validation/selection_results.md). 원본 정수 비트와 FP32 결과를 별도 검사한다.',
        '- [B10 네 계수 나눗셈](validation/division_results.md), [설계·출처](research/division_design.md). 전체 키생성 배율과 단독 나눗셈 배율은 다르다.',
        '- [A8 Q32 배열 직접 나눗셈](validation/fixed_division_results.md). 표현 변환 없는 NTRU 역수 계산 및 전체 키생성 재측정.',
        '- [B11 점별 곱셈 통합](validation/point_fusion_results.md), [설계·출처](research/point_fusion_design.md). 변환 포함 커널과 전체 효과를 구분한다.',
        '- [B12 작은 FFT 입력 변환](validation/b12_fixed_input_results.md). 원본 비트 일치, 작은 크기 비용과 전체 효과를 분리한다.',
        '- [B13 큰 입력 변환 통합](validation/input_fusion_results.md). 같은 ELF의 이전 방식과 비교하며, 변환 및 함수 호출 비용을 포함한다.',
        '- [B14 인코더 합 연산 단축](validation/encoder_fastsum_results.md), [범위 분석·출처](research/encoder_fastsum_design.md). 유한 비트 비교와 전체 성능을 별도로 기록한다.',
        '- [B15 큰 입력 선택 마스크 단축](validation/b15_predicate_input_results.md). B의 원본 비트·표현 경계·전체 검증을 독립 수행한다.',
        '- [B16 디코더의 오차 보존 덧셈 단축](validation/b16_decoder_fastsum_results.md), [적용 조건·출처](research/decoder_fastsum_design.md). 중간 zero 부호와 최종 raw 비트 일치를 구분한다.',
        '- [B17 디코더의 정수·상수 명령 단축](validation/b17_decoder_words_results.md), [동일 비트 규칙](research/decoder_words_design.md). FP 계산 순서는 유지한다.',
        '- [B18 변하지 않는 역수 디코딩 캐시](validation/b18_inverse_cache_results.md), [메모리 수명·동일 계산 규칙](research/inverse_cache_design.md). 준비 비용을 포함하며 Babai 반복은 바꾸지 않는다.',
        '- [A9 회전상수 전용 곱셈과 정확한 MVE FFT](validation/twiddle_results.md), [설계·범위](research/twiddle_multiply_design.md). 단독 곱셈과 변환 전체 이득을 구분한다.',
        '- [A10 butterfly 통합·임시 저장 감소](validation/fusion_results.md), [설계·레지스터 수명](research/fused_butterfly_design.md). 새 경로의 정확성·커널·전체 효과를 별도 검증한다.',
        '- [A11 작은 입력의 두 자리 동시 처리](validation/paired_input_results.md), [원본 계산 규칙 대응](research/paired_input_design.md). 단독 실험과 본체 검증을 구분한다.',
        '- [A12 네 계수 입력의 마스크 단축](validation/predicate_input_results.md), [접근·산술 규칙](research/predicate_input_design.md). 새 소스의 비교와 전체 효과를 분리한다.',
        '- [A13 짧은 레이어의 butterfly 묶음 처리](validation/packed_tail_results.md), [레인 배치·연산 규칙](research/packed_tail_design.md). 큰 커널과 전체 키생성 배율을 구분한다.',
        '- [A14 상수 성분 곱셈·임시 저장 단축](validation/packed_root_lifetime_results.md), [범위·정확한 곱셈·레지스터 수명](research/packed_root_lifetime_design.md). 곱셈만 바꾼 실험과 결합 실험을 구분한다.',
        '- [A15 짧은 레이어의 결과 직접 사용·크기 16 경로](validation/packed_finish_results.md), [레지스터 수명·공개 크기 조건](research/packed_finish_design.md). 결과 저장 제거와 크기 하한 변경을 별도로 측정한다.',
        '- [A16 짧은 레이어의 재배열 메모리 접근](validation/packed_layout_results.md), [배치·레지스터·접근 범위](research/packed_layout_design.md). 회전상수만 바꾼 실험과 계수 입출력까지 바꾼 실험을 구분한다.',
        '- [상수시간 관련 발견·수정·유한 검사](validation/ct_results.md). A4/A5 기록은 최종 안전성 통과로 취급하지 않는다.',
        '- [현재 소스 해시와 일치하는 검증](validation/current_validation.json). 다른 버전의 통과를 이어받지 않는다.',
        '- [기록·ELF 해시 및 외부 원본 불변 재확인](validation/evidence_check.json). 재현: `python validation/verify_evidence.py`.',
        '- [검증 범위·한계](validation/validation_limits.md). 유한 KAT/오차/시간 검사는 보편적 동등성·상수시간 증명이 아니다.',
        '- [A17 정리 후 요청 범위의 다섯 검사](validation/cleanup/README.md). 현재 소스의 재검증과 정리 전 기록을 구분한다. 수치 차이와 유한 검사 한계는 명시하며, 배포 준비·물리 부채널 검사는 이번 요청 범위 밖이다.',
        '- [원래 유지한 소스 검사](validation/scope_check.json). A17의 후보 invnorm 변경과 이후 미사용 코드 정리를 구분해 검사한다.',
        '- [모든 로컬 논문 독해 기록](research/reading_log.md), [추가 일차 문헌](research/additional_sources.md).',
        '- [1.7배 목표의 현재 범위 재검토](validation/scope_feasibility.md), [새 문헌과 실제 solver 대조](research/babai_scope_review.md). 동일 호출 횟수·조건부 시간 계산이며 새 보드 실측이 아니다.',
        '- [요구사항별 완료 감사](validation/requirements_audit.md), [같은 seed별 전체 성능 비교](validation/paired_keygen_audit.md). 평균뿐 아니라 입력별 목표 미달도 확인했으며 전체 목표는 미완료다.',
        '- [미달 목표·남은 연구·미증명 범위](research/remaining_work.md). 모든 가능한 기법을 소진했다는 주장은 하지 않는다.',
        '- 소스 스냅샷은 `validation/source_snapshots/`, 실행 ELF·원시 로그·해시는 `validation/results/`.',
        '- 재현: `bash validation/build.sh <candidate> <mode>` 후 공통 venv Python으로 `validation/run_board.py <candidate> <mode>`. '
        '보드 실행은 항상 한 개씩. SLOTHY 실행·생성 및 다른 후보의 암호 코드 링크 없음.','',
        '## 검증 로그 목록','',
        '| 후보 | 검사 | run |','| --- | --- | --- |']
for v in data:
    if v['mode'] in ('kat','extra','sigkat','arithmetic','kernel','encoding','rounding','decoding','fixed_input','input_pair','input_predicate','division','fixed_division','twiddle','twiddle_fft','fixed_fft','rootmul','fft_alignment','fft_placement','fft_context','fft_replay','profile_probe','fft_fusion','invnorm'):
        review=p/Path(v['manifest']).parent/'review.json'
        note=' (timing rejected; numerical only)' if review.exists() else ''
        lines.append(f'| {v["candidate"]} | {v["mode"]}{note} | [{v["run"]}](validation/{v["manifest"]}) |')
(r/'result.md').write_text('\n'.join(lines)+'\n')
print(r/'result.md')
