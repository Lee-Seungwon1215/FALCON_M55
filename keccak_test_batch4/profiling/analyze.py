#!/usr/bin/env python3
"""Report raw and empty-probe-corrected exclusive profiles, not inferred shares."""
import json
from pathlib import Path
import re
import statistics

HERE=Path(__file__).resolve().parent
data={}
for operation in ('keygen','sign'):
    data[operation]={}
    for mode in ('control','profile'):
        manifests=sorted((HERE/'results'/(operation+'_'+mode)).glob('*/manifest.json'))
        assert manifests,('missing run',operation,mode)
        path=manifests[-1];manifest=json.loads(path.read_text())
        assert manifest['valid'],manifest
        raw=(path.parent/'raw.log').read_text()
        raw=re.sub(r'Info : [^\n]*\n','',raw)
        runs,wrapped,self_total,unwrapped=map(int,re.search(
            r'CALIBRATION runs=(\d+) wrapped=(\d+) self=(\d+) raw=(\d+)',raw).groups())
        self_cost=self_total/runs;whole=(wrapped-unwrapped)/runs;outer=whole-self_cost
        assert whole>0 and outer>0
        rows={}
        for n,op,v,batches,total in re.findall(
            r'^TOTAL n=(\d+) op=(\d+) variant=(\d+) batches=(\d+) cycles=(\d+)$',raw,re.M):
            if int(batches)==0:continue
            key=f'{n}_{v}'
            rows[key]={'n':int(n),'variant':int(v),'batches':int(batches),
                'raw_total':int(total),'functions':{}}
        for n,op,v,name,cycles,calls,children,inclusive in re.findall(
            r'^CATEGORY n=(\d+) op=(\d+) variant=(\d+) name=(\w+) cycles=(\d+) calls=(\d+) children=(\d+) inclusive=(\d+)$',raw,re.M):
            if int(op)!=(0 if operation=='keygen' else 1):continue
            key=f'{n}_{v}'
            f=dict(raw=int(cycles),calls=int(calls),children=int(children),inclusive=int(inclusive))
            f['unclamped_corrected']=f['raw']-f['calls']*self_cost-f['children']*outer
            f['corrected']=max(0,f['unclamped_corrected'])
            rows[key]['functions'][name]=f
        pairs={512:[],1024:[]}
        for n,op,batch,original,candidate in re.findall(
            r'^PAIR n=(\d+) op=(\d+) batch=(\d+) original=(\d+) batch4=(\d+)$',raw,re.M):
            pairs[int(n)].append({'batch':int(batch),'original':int(original),'batch4':int(candidate)})
        groups={'x4':['x4_permute'],'x4_output':['x4_squeeze'],
            'single':['single_keccak','shake_init','shake_inject','shake_flip','shake_extract','inject_chunk'],
            'batch_management':['batch_prepare','batch_absorb','batch_export','batch_block','sampler_extract','batch_clear'],
            'other':['other']}
        for key,row in rows.items():
            fs=row['functions']
            assert sum(f['raw'] for f in fs.values())==row['raw_total']
            row['corrected_total']=sum(f['corrected'] for f in fs.values())
            row['groups']={g:sum(fs[name]['corrected'] for name in members) for g,members in groups.items()}
            row['percent']={g:100*c/row['corrected_total'] for g,c in row['groups'].items()}
            row['shake_percent']=100-row['percent']['other']
            row['shake_cycles']=row['corrected_total']-row['groups']['other']
            row['average4_cycles']=row['corrected_total']/row['batches']
            row['clamped']=[name for name,f in fs.items() if f['unclamped_corrected']<0]
        data[operation][mode]=dict(run=str(path.parent.relative_to(HERE)),manifest=manifest,
            self_cost=self_cost,outer_cost=outer,whole_cost=whole,rows=rows,pairs=pairs)
    control=data[operation]['control'];profile=data[operation]['profile']
    assert control['manifest']['fingerprint']==profile['manifest']['fingerprint'],'different outputs'
    for key,row in profile['rows'].items():
        row['corrected_vs_control_percent']=100*(row['corrected_total']/control['rows'][key]['raw_total']-1)
        row['raw_vs_control_percent']=100*(row['raw_total']/control['rows'][key]['raw_total']-1)

labels={'keygen':'키생성','sign':'서명'}
md='''# batch4 전/후 Keccak·SHAKE 연산 비중 — 실물 M55

생산 코드와 `Final_code/Before_slothy`는 수정하지 않았다. 다음 비중은 각 구현의
**키생성 네 건 전체 / 서명 네 건 전체**를 각각 100%로 한 독립 실측이다.
분자와 분모는 빈 probe 오버헤드를 보정한 추정치다. 부모 SHAKE에서 하위 Keccak 시간을
빼는 exclusive 집계이므로 중복 합산하지 않는다.

## 측정 조건

- NUCLEO-N657X0-Q, ST-Link `003C00223335510735383531`, 800 MHz, cache OFF, ECC ON.
- 기존 코드 ITCM / 상수·데이터·stack DTCM 정책. 메모리 용량 때문에 키생성과 서명은
  별도 펌웨어지만, 각 펌웨어 안에서 원본 4회 호출과 batch4를 같은 입력으로 교대 실행.
- GCC 15.2.1, `-O3`, `-mcpu=cortex-m55`, `-mfpu=fpv5-d16`, hard ABI,
  `-ffp-contract=off -fno-fast-math -fno-strict-aliasing`. 계측 bookkeeping만 general-regs-only.
- 두 연산 모두 IRQ ON / 64-bit SoC cycle counter. 이전 IRQ OFF 서명 측정값과 직접 혼합하지 않는다.
- 각 크기: 키생성 10배치 = 40개의 서로 다른 seed, 서명 25배치 = 100개의 입력(4개 키).
  각 구현·크기별 별도 warm-up 1배치. 키 prefix64블록/요청, 서명112블록/요청.
- reference는 NTT·FFT 최적화가 이미 포함된 Before_slothy. 최초 M55_ref 대비 수치가 아니다.
- 오류 대조·서명 검증·변조 검사·로그·호출자 workspace 삭제는 시간 밖.

## 전/후 SHAKE 관련 합계

아래 ‘합계’는 계측한 SHAKE/Keccak 및 배치 준비/출력 함수들의 시간이다.
짧은 인라인 난수 읽기와 API 제어는 강제로 함수화하지 않아 나머지에 포함된다.
앞선 sha3_profile도 인라인 `shake_next_*` 자체 비용을 제외했다.

| 연산 | 크기 | 원본 SHAKE 합계 | batch4 SHAKE·관리 합계 | 원본 나머지 | batch4 나머지 |
|---|---:|---:|---:|---:|---:|
'''
for op in labels:
    for n in (512,1024):
        a,b=(data[op]['profile']['rows'][f'{n}_{v}'] for v in (0,1))
        md+=f"| {labels[op]} | {n} | {a['shake_percent']:.3f}% | {b['shake_percent']:.3f}% | {a['percent']['other']:.3f}% | {b['percent']['other']:.3f}% |\n"
md+='''
## batch4 후 100% 분해

| 구간 | 키생성512 | 키생성1024 | 서명512 | 서명1024 |
|---|---:|---:|---:|---:|
'''
columns=[data[op]['profile']['rows'][f'{n}_1'] for op in labels for n in (512,1024)]
for name,title in [('x4','MVE x4 Keccak'),('x4_output','x4 출력 버퍼 저장'),
    ('single','남아 있는 단일 Keccak/SHAKE'),('batch_management','계측한 배치 준비·관리'),
    ('other','나머지 FN-DSA·인라인 읽기·제어')]:
    md+='| '+title+' | '+' | '.join(f"{r['percent'][name]:.3f}%" for r in columns)+' |\n'
md+='| 합계 | 100% | 100% | 100% | 100% |\n'
md+='''
‘단일’에는 bit_split/merge, 원래 초기화/흡수/추출도 포함한다. ‘배치 준비·관리’는
prepare/absorb/export/block/sampler_extract/내부 clear의 exclusive 시간이며,
모든 인라인 prefix 읽기 비용까지 완전히 분리한 값이 아니다.

## Keccak 호출 횟수와 적용 범위

x4 1회는 4개의 상태를 계산한다. 아래는 배치당 평균이다. 감소율은
`(원본 단일 호출수 - batch4의 단일 호출수) / 원본 단일 호출수`이다.
미사용 선생성 출력이 있을 수 있으므로 **유효 소비 바이트 비율이라고 해석하지 않는다.**

| 연산 | 크기 | 원본 단일 호출 | batch4 잔여 단일 호출 | x4 호출 | 단일 호출 감소율 |
|---|---:|---:|---:|---:|---:|
'''
for op in labels:
    for n in (512,1024):
        a,b=(data[op]['profile']['rows'][f'{n}_{v}'] for v in (0,1))
        ca=a['functions']['single_keccak']['calls'];cb=b['functions']['single_keccak']['calls']
        x=b['functions']['x4_permute']['calls'];count=a['batches']
        md+=f'| {labels[op]} | {n} | {ca/count:.2f} | {cb/count:.2f} | {x/count:.2f} | {100*(ca-cb)/ca:.2f}% |\n'
md+='''
## 계측 없는 control의 전체 성능

샘플별 paired 측정의 전체 cycle 합계 비율을 사용한다(평균 비용에 해당).
이전 결과와는 입력 집합/IRQ 정책/코드 배치가 달라 이전 값을 덮어쓰지 않는다.

| 연산 | 크기 | 원본4 평균 cycles | batch4 평균 cycles | 배율 | cycles 감소 |
|---|---:|---:|---:|---:|---:|
'''
for op in labels:
    for n in (512,1024):
        a,b=(data[op]['control']['rows'][f'{n}_{v}'] for v in (0,1))
        av=a['raw_total']/a['batches'];bv=b['raw_total']/b['batches']
        md+=f'| {labels[op]} | {n} | {av:,.1f} | {bv:,.1f} | {av/bv:.5f}× | {100*(1-bv/av):.3f}% |\n'
md+='''
## 계측 영향 점검

빈 wrapper 4,000회로 추정한 보정값을 각 함수 호출/하위 호출 수에 적용했다.
짧은 함수의 보정 후 음수는 0으로 제한하며 data.json에 기록한다. 코드 배치와
함수 wrapping에 따른 최적화 차이는 빈 probe 보정만으로 제거되지 않는다.
따라서 보정 후 control 대비 차이도 함께 보고, 미세한 값은 과해석하지 않는다.

| 연산 | 크기 | 구현 | raw/control 차이 | 보정/control 차이 |
|---|---:|---|---:|---:|
'''
for op in labels:
    for n in (512,1024):
        for v in (0,1):
            r=data[op]['profile']['rows'][f'{n}_{v}']
            md+=f"| {labels[op]} | {n} | {'batch4' if v else '원본4'} | {r['raw_vs_control_percent']:+.3f}% | {r['corrected_vs_control_percent']:+.3f}% |\n"
md+='\n## 검증 및 원자료\n\n'
md+='각 모드: 키 88회 전체 바이트 일치, 서명208회 전체 바이트 일치·검증·변조 거부(별도 warm-up 포함). '
md+='control/profile의 출력 지문 일치, 계측 stack 및 합계 검사, workspace guards, TCM/ECC 및 fault 레지스터 확인. '
md+='이는 이번 입력에 대한 회귀 검사이며 전체 공식 KAT/상수시간 증명이 아니다.\n\n'
for op in labels:
    for mode in ('control','profile'):
        d=data[op][mode];run=d['run']
        md+=f"- {op}/{mode}: [raw.log]({run}/raw.log), [manifest]({run}/manifest.json), [source hashes]({run}/sources.json). "
        md+=f"probe 보정 self={d['self_cost']:.3f}, parent={d['outer_cost']:.3f} cycles.\n"
(HERE/'data.json').write_text(json.dumps(data,indent=2)+'\n')
(HERE/'result.md').write_text(md)
print(md)
