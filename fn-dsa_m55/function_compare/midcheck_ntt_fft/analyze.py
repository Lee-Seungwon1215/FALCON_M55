#!/usr/bin/env python3
"""Validate logs and publish this small-sample experiment without old timings."""
import hashlib,json,re,statistics
from pathlib import Path
from run import verify_sources
HERE=Path(__file__).resolve().parent
verify_sources()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
runs=[];fingerprints={}
for p in sorted((HERE/'results').glob('*/*/manifest.json')):
    m=json.loads(p.read_text());assert m['valid_measurement'],p
    assert sha(p.parent/'raw.log')==m['raw_sha256']
    assert sha(p.parent/'benchmark.elf')==m['elf_sha256']
    raw=re.sub(r'Info : [^\n]*\n','',(p.parent/'raw.log').read_text())
    rows={}
    for op,n,i,c in re.findall(r'^MC_SAMPLE op=(\w+) degree=(\d+) index=(\d+) cycles=(\d+)',raw,re.M):
        rows.setdefault((op,int(n)),{})[int(i)]=int(c)
    assert len(rows)==6 and all(set(d)==set(range(10)) for d in rows.values())
    for op,n,total in re.findall(r'^MC_SUMMARY op=(\w+) degree=(\d+) calls=10 total=(\d+)',raw,re.M):
        assert sum(rows[(op,int(n))].values())==int(total)
    for op,n,h in re.findall(r'^MC_DIGEST op=(\w+) degree=(\d+) sha3=([0-9a-f]{64})',raw,re.M):
        key=op+'_'+n;fingerprints.setdefault(key,h);assert fingerprints[key]==h,(p,key)
    prof={}
    if m['mode']=='profile':
        for op,n,total,classified,rem in re.findall(r'^MC_PROFILE_TOTAL op=(\w+) degree=(\d+) calls=10 cycles=(\d+) classified=(\d+) remainder=(\d+)',raw,re.M):
            key=(op,int(n));assert sum(rows[key].values())==int(total)
            prof[key]={'total':int(total),'classified':int(classified),'remainder':int(rem),'categories':{}}
        for op,n,cat,calls,excl,incl in re.findall(r'^MC_PROFILE op=(\w+) degree=(\d+) category=(\w+) calls=(\d+) exclusive=(\d+) inclusive=(\d+)',raw,re.M):
            r=prof[(op,int(n))];r['categories'][cat]={'calls':int(calls),'exclusive':int(excl),'inclusive':int(incl),'percent':100*int(excl)/r['total']}
        for r in prof.values():
            assert sum(c['exclusive'] for c in r['categories'].values())==r['classified']
            assert r['classified']+r['remainder']==r['total']
    runs.append({'variant':m['variant'],'mode':m['mode'],'log':str((p.parent/'raw.log').relative_to(HERE)),'rows':rows,'profile':prof})
perf={}
for v in ('ref','ntt','full'):
    selected=[r for r in runs if (r['variant'],r['mode'])==(v,'perf')];assert len(selected)==2
    for op in ('keygen','sign','verify'):
        for n in (512,1024):
            batches=[list(r['rows'][(op,n)].values()) for r in selected]
            values=sum(batches,[])
            perf[(v,op,n)]={'mean':statistics.mean(values),'median':statistics.median(values),
                'min':min(values),'max':max(values),'run_means':[statistics.mean(b) for b in batches],
                'run_delta_cycles':abs(statistics.mean(batches[0])-statistics.mean(batches[1]))}
profile_runs=[r for r in runs if r['mode']=='profile'];assert len(profile_runs)==1
profile=profile_runs[0]['profile']
out={'sample_policy':'10 unique deterministic seeds per degree, two repetitions; not 20 independent seeds',
    'fingerprints':fingerprints,'perf':{'_'.join(map(str,k)):v for k,v in perf.items()},
    'profile':{'_'.join(map(str,k)):v for k,v in profile.items()},
    'logs':[{'variant':r['variant'],'mode':r['mode'],'log':r['log']} for r in runs],
    'profile_limitation':'Instrumented, unpadded image: percentages use its own API totals; not a speed comparator or a measured overhead vs fixed-layout perf.'}
(HERE/'summary.json').write_text(json.dumps(out,indent=2)+'\n')
names={'keygen':'키생성','sign':'서명','verify':'검증'}
lines=['# NTT + 키생성/서명 FFT 소표본 중간점검','',
'측정일: 2026-09-29. 연결된 NUCLEO-N657X0-Q에서 새로 측정했다. 과거 기록의 평균값을 섞지 않았다. 원본 작업 폴더의 암호 코드는 수정하지 않았다.','',
'## 비교 대상','',
'| 후보 | NTT | 키생성 FFT | 서명 FFT |',
'| --- | --- | --- | --- |',
'| `ref` | M55_ref 원본 | 원본 | 원본 |',
'| `ntt` | 공통 q-NTT + K4C RNS, pre-SLOTHY | 원본 | 원본 |',
'| `full` | 동일 NTT | A17 통합 | FFT/iFFT·LDL·split/merge 다섯 함수 |','',
'`full`은 현재 `Final_code/Before_slothy`의 C/H/S 파일을 그대로 동결한 복사본이다. `FFT/6_sign_fft`와도 이 파일들의 해시가 일치한다. 성능용 펌웨어에는 내부 프로파일링 코드를 넣지 않았다. 서명용 ASM 세 파일도 실제로 빌드했다. 원본 ASM은 끈 상태가 아니라 M4 ASM ON + M55 호환 상태다.','',
'`ref`/`ntt`는 앞선 [fourway 비교](../sign_fft_fourway/result.md)의 동결 소스다. 원본·선택된 NTT 소스의 출처/헤더 설정 차이는 그 manifest와 이번 [source_manifest.json](source_manifest.json)에 추적했다. `ntt` 대비 `full`은 FFT 통합 패키지의 추가 효과이며, 커널 하나만의 효과는 아니다. FFT 단독 구현을 원본 위에 얹은 네 번째 후보는 이번에 측정하지 않았다.','',
'## 1. 전체 API 성능','',
'각 연산·크기·후보별 **서로 다른 결정적 입력 10개 × 두 번 = 20개 측정값**의 산술평균. 두 번은 같은 입력 집합을 반복한 것이며 독립 입력 20개가 아니다. 배율 = 원본 평균 / 해당 평균, 클수록 빠르다.','',
'| 연산 | 크기 | 원본 cycles | NTT만 cycles | NTT+FFT cycles | NTT 배율 | 최종 배율 | 최종 cycles 감소 |',
'| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |']
for op in names:
    for n in (512,1024):
        r,t,f=[perf[(v,op,n)]['mean'] for v in ('ref','ntt','full')]
        lines.append(f'| {names[op]} | {n} | {r:,.2f} | {t:,.2f} | {f:,.2f} | {r/t:.4f}× | **{r/f:.4f}×** | {100*(1-f/r):.2f}% |')
lines+=['','### NTT까지 끝난 상태에서 FFT가 추가한 효과','',
'분모를 바꾸어 **NTT만 → 현재 통합본**을 비교한다. 위의 원본 대비 배율과 더하거나 단순 평균 내면 안 된다.','',
'| 연산 | 512 추가 배율 / cycles 감소 | 1024 추가 배율 / cycles 감소 |','| --- | ---: | ---: |']
for op in names:
    values=[]
    for n in (512,1024):
        t,f=[perf[(v,op,n)]['mean'] for v in ('ntt','full')]
        values.append(f'{t/f:.4f}× / {100*(1-f/t):.2f}%')
    lines.append('| '+names[op]+' | '+' | '.join(values)+' |')
lines+=['','검증에서는 FFT를 쓰지 않으므로 NTT만과 통합본은 동등하다. 512 평균 0.05 cycle 차이는 최적화 효과로 해석하지 않는다.',
'','## 2. 현재 통합본에 남은 비중 — 별도 진단용 계측','',
'분모는 **계측 펌웨어의 해당 API 전체 시간**이다. 재시도를 포함한다. 중첩 호출을 차감한 exclusive 합계로 집계했으며 `fpoly_apply_basis`/`ffsamp_fft_deepest`에서 이미 분리한 하위 호출을 다시 더하지 않았다.','',
'**주의:** 계측본은 코드 크기 제약 때문에 성능용 고정 슬롯 배치가 아니라 비패딩 배치를 사용했다. 계측 호출/코드 배치의 영향이 있다. 따라서 아래 비중은 다음 대상 선정용이며, 성능표의 cycles에 곧바로 곱하거나 정밀한 개선 상한으로 주장하지 않는다. 계측본 시간이 더 짧게 나온 항목도 있으므로 두 펌웨어 시간의 차이를 단순한 계측 overhead로 해석할 수 없다.','',
'### 키생성','',
'| 분류 | 512 전체 키생성 비중 | 1024 전체 키생성 비중 |','| --- | ---: | ---: |']
kg=[('NTRU solve 내 FFT/iFFT 변환',['kg_fft_ntru','kg_ifft_ntru','kg_fft_fp64','kg_ifft_fp64']),
    ('후보 검사 FFT/iFFT 변환 — 현재 고정소수점',['kg_fft_fixed','kg_ifft_fixed']),
    ('후보 검사 invnorm — 현재 native FP64',['kg_invnorm']),
    ('FFT 영역 점별 곱셈·역수·나눗셈·켤레 등',['kg_mul','kg_recip','kg_div','kg_fft_misc']),
    ('입력 변환',['kg_input']),('NTRU solve 나머지: 미분리 연산·제어 등',['kg_ntru_rest']),
    ('후보 검사 나머지',['kg_ortho_rest'])]
def percentage(op,n,cats):return sum(profile[(op,n)]['categories'][c]['percent'] for c in cats)
for name,cats in kg:lines.append('| '+name+' | '+' | '.join(f'{percentage("keygen",n,cats):.3f}%' for n in (512,1024))+' |')
lines.append('| API 나머지: 후보 생성·인코딩·제어·계측 등 | '+' | '.join(f'{100*profile[("keygen",n)]["remainder"]/profile[("keygen",n)]["total"]:.3f}%' for n in (512,1024))+' |')
lines+=['| 합계 | 100% | 100% |','',
'`kg_ntru_rest`는 별도 계측하지 않은 정수 갱신/NTT/CRT/Bezout, 인라인 산술 및 제어·계측 시간을 포함하는 잔여 분류다. 이번에는 그 내부를 다시 세분하지 않았다. 이 잔여 전체가 순수 정수 연산이라고 증명한 것은 아니다. 함수명 `_fp64`는 이식 당시 이름이며, A17의 depth0 변환 구현은 2×FP32 MVE 브리지를 호출한다. 키생성 FFT가 모두 native FP64로 바뀌었다는 뜻이 아니다.','',
'### 서명','',
'| 함수/분류 | 512 전체 서명 비중 | 1024 전체 서명 비중 |','| --- | ---: | ---: |']
sg=[('FFT + iFFT (최적화됨)',['sg_fft','sg_ifft']),('LDL (최적화됨)',['sg_ldl']),
    ('split + merge (최적화됨)',['sg_split','sg_merge']),
    ('`fpoly_mul_fft()`',['sg_mul']),('`fpoly_add()` + `fpoly_sub()`',['sg_add','sg_sub']),
    ('`fpoly_split_selfadj_fft()`',['sg_split_selfadj']),
    ('`fpoly_gram_fft()`',['sg_gram']),('basis, 하위 호출 제외',['sg_basis']),
    ('deepest, sampler 제외',['sg_deepest']),('sampler',['sg_sampler'])]
for name,cats in sg:lines.append('| '+name+' | '+' | '.join(f'{percentage("sign",n,cats):.3f}%' for n in (512,1024))+' |')
lines.append('| API 나머지·제어·계측 등 | '+' | '.join(f'{100*profile[("sign",n)]["remainder"]/profile[("sign",n)]["total"]:.3f}%' for n in (512,1024))+' |')
lines+=['| 합계 | 100% | 100% |','',
'검증에는 이번 FFT 함수가 없으므로 프로파일러의 FFT 계측 합계는 0, 잔여는 100%다. 이것은 검증 연산 자체가 0이라는 의미가 아니다.','',
'## 3. 중간 판단','',
'- **현재 성과는 유지할 가치가 있다.** 동일 입력에서 키생성·서명·검증 모두 빨라졌고 출력도 일치했다. 단, 원래의 전체 키생성 1.7배 목표를 달성한 것은 아니다.',
'- **NTRU solve의 FFT/iFFT를 계속 미세 조정하는 우선순위는 낮춘다.** 진단용 계측에서는 전체 키생성의 약 5.27% / 2.70%만 남았다. 큰 추가 이득을 기대하려면 다른 병목을 봐야 한다. 키생성 후보 검사의 고정소수점 FFT/iFFT는 별도 약 6.02% / 10.03%이지만 NTRU solve와는 다른 대상이다.',
'- **서명 FFT 영역은 추가로 살펴볼 가치가 있다.** 이미 바꾼 FFT/iFFT만 다시 배치하기보다, 아직 정수 FP64 에뮬레이션인 점별 곱셈·합차·self-adjoint 분할을 우선 검토한다. 이 세 묶음은 진단 계측 기준 약 19.87% / 21.19%다. 이는 달성 가능한 개선율이 아니라 현재 차지하는 시간이다.',
'- sampler의 약 32–34%는 또 다른 큰 대상이지만 FFT 커널과 같은 최적화라고 묶지 않는다. 이번에는 sampler나 새 최적화를 구현하지 않았다.','',
'## 4. 측정 조건·배치와 해석 범위','',
'- NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`, CPU 800 MHz.',
'- GCC 15.2.1, `-O3`, Cortex-M55, hard-float, `-mfpu=fpv5-d16`, `-ffp-contract=off`, `-fno-fast-math`, `-fno-strict-aliasing`.',
'- 코드 ITCM, 상수·데이터·스택 DTCM, cache OFF. TCM `0x99`. 기존의 상수 DTCM 배치/ECC workaround 유지.',
'- 성능 세 후보에서 공통 함수 230개, 공통 데이터 심볼 132개의 주소/크기 및 SK/PK/서명/tmp/스택 배치를 일치시켰다. 변경된 객체 내부 오프셋까지 모두 같다는 뜻은 아니다. [배치 검증](layout_audit.json).',
'- 전체 통합본이 들어갈 슬롯을 사용했으므로 앞선 `sign_fft_fourway`의 펌웨어와 실행 배치는 다르다. 이전 100입력 결과와 이번 cycles/배율을 섞거나 표본 수만 달라졌다고 해석하지 않는다. 배치 차이의 세부 원인을 이번에 단독 실험으로 확정하지 않았다.',
'- 키생성: 워밍업 3회, 서로 다른 seed index 0–9, `k_cycle_get_64()`, IRQ/SysTick ON. 후보 실패/재시도 포함.',
'- 서명/검증: 같은 index 9의 키·같은 메시지·서명 seed index 0–9, 워밍업 3회, DWT CYCCNT, IRQ OFF. 서명 생성은 검증 타이머 밖, 출력 해시/정상 검증/변조 거부/printf는 해당 타이머 밖이다.',
'- 실행 순서: `ref → ntt → full → full → ntt → ref`, 이어서 진단용 `full profile` 1회.',
'- 성능 timed 360회(3후보 × 2크기 × 3연산 × 10입력 × 2회), 진단 timed 60회. 새 전체 KAT sweep/상수시간 증명을 진행한 작업은 아니다.','',
'### 두 회차 반복성','',
'| 연산 | 같은 후보·크기의 두 평균 차이 중 최댓값 |','| --- | ---: |']
for op in names:lines.append(f'| {names[op]} | {max(perf[(v,op,n)]["run_delta_cycles"] for v in ("ref","ntt","full") for n in (512,1024)):.2f} cycles |')
lines+=['','같은 입력에서 반복성이 좋다는 뜻이며, 작은 표본이 모든 입력의 성능을 대표하거나 통계적 유의성을 증명한다는 뜻은 아니다. 특히 키생성은 seed별 재시도 횟수로 분산이 크다. 최종 논문 수치는 같은 배치 정책·더 많은 독립 seed로 별도 확정해야 한다.','',
'## 5. 검증과 원시 증거','',
'모든 실행에서 키생성·서명·정상 검증·변조 거부, 타이머 교차검사, ELF 로드 대조, CFSR/HFSR/AFSR=0, TCM/ECC 상태 검사, 실행 전후 소스 불변 검사를 통과했다. 모든 후보와 계측본의 SK/PK 및 PK/서명 누적 SHA3-256이 크기별로 일치했다. 이는 시험한 입력의 원본 대비 일치이며 모든 입력의 수학적 동등성이나 전체 상수시간 증명은 아니다.','',
'| 누적 출력 | SHA3-256 |','| --- | --- |']
for k,v in fingerprints.items():lines.append(f'| {k} | `{v}` |')
lines+=['','| 후보/모드 | 원시 로그 |','| --- | --- |']
for r in runs:lines.append(f'| {r["variant"]}/{r["mode"]} | [{Path(r["log"]).parent.name}]({r["log"]}) |')
lines+=['','각 로그 폴더에 ELF/map/소스 archive/컴파일 명령/disassembly/SHA256 manifest를 보존했다. 상세 평균·최솟값·최댓값·중앙값과 모든 함수별 계측은 [summary.json](summary.json)에 있다.','',
'재실행: `bash build.sh ref perf` / `ntt perf` / `full perf`, 이어서 `python3 audit_layout.py`; 순서대로 `python3 run.py ref perf` 등 실행. 진단용은 `bash build.sh full profile`, `python3 run.py full profile`. `analyze.py`는 성능 후보별 정확히 두 로그와 진단 로그 하나를 검증하므로 추가 실험은 기존 로그를 보존한 별도 세션 폴더로 분리한다.','']
(HERE/'result.md').write_text('\n'.join(lines))
print('PASS: 6 performance runs + 1 diagnostic run, matching outputs, all sums checked.')
print(HERE/'result.md')
