#!/usr/bin/env python3
"""Compare call-site profiles on identical real keygen seeds, with no double counting."""
import hashlib
import json
import re
import sys
from pathlib import Path

refdir, curdir = [Path(x).resolve() for x in sys.argv[1:]]
root = Path(__file__).resolve().parents[1]
val = root/'integration_candidate/validation'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()

def read(path, kind, control_stamp):
    m = json.loads((path/'run.json').read_text())
    assert m['valid_measurement'] and m['kind'] == kind
    assert sha(path/'raw.log') == m['raw_sha256']
    text = re.sub(r'Info : [^\n]*\n', '', (path/'raw.log').read_text())
    keys = re.findall(r'^KEYGEN_PERF degree=(\d+) index=(\d+) cycles=(\d+) match=1 equation=PASS keyhash=([0-9a-f]+)$', text, re.M)
    assert len(keys) == 200
    keymap = {(int(d),int(i)): (int(c),h) for d,i,c,h in keys}
    assert set(keymap) == {(d,i) for d in (512,1024) for i in range(100)}
    rows = re.findall(r'^IPRO degree=(\d+) op=(\w+) logn=(\d+) calls=(\d+) cycles=(\d+) success=(\d+)$', text, re.M)
    counters = {(int(d),op,int(l)): dict(calls=int(n),cycles=int(c),success=int(s)) for d,op,l,n,c,s in rows}
    assert len(rows) == len(counters)
    for name, expected in m['source'].items():
        p = Path(name)
        assert sha(p) == expected, name
    build = val/'build'/kind
    assert sha(build/'zephyr/zephyr.elf') == m['elf_sha256']
    control_kind = 'keygen_ref' if kind.endswith('_ref') else 'keygen_current'
    control_dir = val/'results'/control_kind/control_stamp
    cm = json.loads((control_dir/'run.json').read_text())
    assert cm['valid_measurement'] and sha(control_dir/'raw.log') == cm['raw_sha256']
    # The actual crypto tree is identical to the uninstrumented comparison.
    for p,h in cm['source'].items():
        if Path(p).parent == Path(cm['source_root']): assert m['source'][p] == h
    ctext = re.sub(r'Info : [^\n]*\n', '', (control_dir/'raw.log').read_text())
    ckeys = re.findall(r'^KEYGEN_PERF degree=(\d+) index=(\d+) cycles=(\d+) match=1 equation=PASS keyhash=([0-9a-f]+)$', ctext, re.M)
    ckeymap = {(int(d),int(i)): (int(c),h) for d,i,c,h in ckeys}
    assert all(keymap[k][1] == ckeymap[k][1] for k in keymap)
    assert sha(build/'zephyr/.config') == sha(val/'build'/control_kind/'zephyr/.config')
    results = {}
    for d in (512,1024):
        total = sum(c for (kd,i),(c,h) in keymap.items() if kd == d)
        control = sum(c for (kd,i),(c,h) in ckeymap.items() if kd == d)
        ops = {}
        for (kd,op,l),row in counters.items():
            if kd == d:
                dst = ops.setdefault(op, dict(calls=0,cycles=0,success=0))
                for k in dst: dst[k] += row[k]
        leaves = {op: row['cycles'] for op,row in ops.items()
                  if op.startswith(('I_','D_','O_')) or op in ('sample','invert','finish')}
        leaves['ortho_other'] = ops['ortho']['cycles']-sum(c for op,c in leaves.items() if op.startswith('O_'))
        leaves['ntru_other'] = ops['ntru']['cycles']-sum(c for op,c in leaves.items() if op.startswith(('I_','D_')))
        for op in ('crt_deep','bezout_deep','crt_fg','crt_intermediate'):
            if op in ops:
                leaves[op] = ops[op]['cycles']
                leaves['ntru_other'] -= ops[op]['cycles']
        leaves['top_other'] = total-sum(ops[op]['cycles'] for op in ('sample','invert','ortho','ntru','finish'))
        assert min(leaves.values()) >= 0 and sum(leaves.values()) == total
        printed = re.search(r'^IPRO_TOTAL degree='+str(d)+r' cycles=(\d+) top=(\d+) ortho_leaves=(\d+) ntru_leaves=(\d+) errors=0$',text,re.M)
        assert printed and int(printed[1]) == total and int(printed[2]) == total-leaves['top_other']
        fft = {}
        for direction in ('fft','ifft'):
            for l in range(1,11):
                selected = [v for (kd,op,kl),v in counters.items() if kd==d and kl==l and op in ('I_'+direction,'D_'+direction,'O_'+direction)]
                if selected:
                    fft[direction+'_'+str(1<<l)] = dict(calls=sum(x['calls'] for x in selected),cycles=sum(x['cycles'] for x in selected))
        results[d] = dict(total=total,control_total=control,
            instrumentation_percent=100*(total/control-1),ops=ops,leaves=leaves,fft=fft)
    return m,keymap,results

refkind = json.loads((refdir/'run.json').read_text())['kind']
curkind = json.loads((curdir/'run.json').read_text())['kind']
mr, kr, rr = read(refdir,refkind,'20260926T085044Z')
mc, kc, rc = read(curdir,curkind,'20260926T085313Z')
assert all(kr[k][1] == kc[k][1] for k in kr)
assert sha(val/'build'/refkind/'zephyr/.config') == sha(val/'build'/curkind/'zephyr/.config')
assert sha(val/'build'/refkind/'fndsa_dtcm_linker.ld') == sha(val/'build'/curkind/'fndsa_dtcm_linker.ld')
comparison = {}
for d in (512,1024):
    a,b = rr[d],rc[d]
    assert a['leaves'].keys() == b['leaves'].keys()
    deltas = {op:(b['leaves'][op]-v)/100 for op,v in a['leaves'].items()}
    comparison[d] = dict(reference=a,current=b,delta_cycles_per_key=deltas,
        delta_sum=sum(deltas.values()),
        calls_equal={op:a['ops'][op]['calls']==b['ops'][op]['calls'] for op in a['ops']},
        success_equal={op:a['ops'][op]['success']==b['ops'][op]['success'] for op in a['ops']})
data = dict(reference_run=str(refdir),current_run=str(curdir),comparison=comparison,
    matching_encoded_keys=200,source_unchanged=True,
    note='Inclusive parents are not added to leaves. Every timing includes probe cost; no ad hoc overhead subtraction. Separate firmware, same memory policy, not identical code addresses.')
(curdir/'integration_comparison.json').write_text(json.dumps(data,indent=2)+'\n')
lines = ['# 통합 키 생성 손익 분리 계측','',
    '같은 KAT 입력 test0..test99, 각 크기 100개. 단위는 키 한 개당 평균 cycles.',
    '두 구현의 연산은 수정하지 않고 원본에서 복원 가능한 계측 복사본만 빌드했다.',
    '양수 Δ는 현재 구현의 추가 비용, 음수 Δ는 절감이다. 전체 분모는 실패 후보 재시도를 포함한다.','',
    '## 계측 영향','',
    '| n | 구현 | 무계측 평균 | 계측 평균 | 계측으로 인한 변화 |',
    '| ---: | --- | ---: | ---: | ---: |']
if refkind.startswith('zlayout'):
    lines[0:0] = ['> 진단용 정수 코드 동일 주소 배치 실험. 아래 무계측 대비 변화에는 계측뿐 아니라 배치 변경도 포함되므로 순수 계측 오버헤드로 해석하면 안 된다.','']
for d in (512,1024):
    for label,row in (('M55_ref',rr[d]),('현재',rc[d])):
        lines.append(f"| {d} | {label} | {row['control_total']/100:,.2f} | {row['total']/100:,.2f} | {row['instrumentation_percent']:+.3f}% |")
for d in (512,1024):
    a,b = rr[d],rc[d]
    lines += ['',f'## n={d}: 상위 단계 (서로 중복 없음)','',
        '| 구간 | 기준 cycles/key | 현재 cycles/key | Δ cycles/key |',
        '| --- | ---: | ---: | ---: |']
    for op in ('sample','invert','ortho','ntru','finish','top_other'):
        av = a['leaves'][op] if op=='top_other' else a['ops'][op]['cycles']
        bv = b['leaves'][op] if op=='top_other' else b['ops'][op]['cycles']
        lines.append(f'| {op} | {av/100:,.2f} | {bv/100:,.2f} | {(bv-av)/100:+,.2f} |')
    lines += ['',f'### n={d}: 전체 100%로 분리한 세부 항목','',
        'I=중간 깊이 NTRU 축소, D=depth0 최종 축소, O=후보 직교노름 검사.',
        'ntru_other에는 별도 행으로 분리하지 않은 정수 연산과 제어/계측 집계가 들어간다. CRT/Bezout 행이 있으면 해당 시간은 나머지에서 제외했다.',
        'I_update는 정수 해 갱신 함수이며 그 안의 NTT도 포함한다.','',
        '| 구간 | 기준 cycles/key | 현재 cycles/key | Δ cycles/key | 기준 비중 | 현재 비중 |',
        '| --- | ---: | ---: | ---: | ---: | ---: |']
    for op,av in sorted(a['leaves'].items(),key=lambda t:b['leaves'][t[0]]-t[1],reverse=True):
        bv=b['leaves'][op]
        lines.append(f'| {op} | {av/100:,.2f} | {bv/100:,.2f} | {(bv-av)/100:+,.2f} | {100*av/a["total"]:.3f}% | {100*bv/b["total"]:.3f}% |')
    lines.append(f'| 합계 | {a["total"]/100:,.2f} | {b["total"]/100:,.2f} | {(b["total"]-a["total"])/100:+,.2f} | 100% | 100% |')
    lines += ['',f'### n={d}: 실제 키 생성에서 FFT 크기별 누적','',
        '| 함수·변환 크기 | 호출 수 기준/현재 (100키) | 기준 cycles/call | 현재 cycles/call | Δ cycles/key |',
        '| --- | ---: | ---: | ---: | ---: |']
    for op,av in a['fft'].items():
        bv=b['fft'][op]
        lines.append(f'| {op} | {av["calls"]}/{bv["calls"]} | {av["cycles"]/av["calls"]:,.2f} | {bv["cycles"]/bv["calls"]:,.2f} | {(bv["cycles"]-av["cycles"])/100:+,.2f} |')
    lines += ['',f'### n={d}: 재시도·진행 횟수','',
        '| 구간 | 기준 호출/성공 | 현재 호출/성공 |', '| --- | ---: | ---: |']
    for op in ('sample','invert','ortho','ntru','deepest','intermediate','depth0'):
        x,y=a['ops'][op],b['ops'][op]
        lines.append(f'| {op} | {x["calls"]}/{x["success"]} | {y["calls"]}/{y["success"]} |')
    lines += ['','sample은 성공 상태를 집계하지 않는 void 함수다. intermediate/deepest/depth0의 성공은 SOLVE_OK(0), 후보 검사·NTRU 전체는 1이다.']
lines += ['', '## 조건·검증·주의','',
    '- NUCLEO-N657X0-Q, 800 MHz, 코드 ITCM / 데이터·상수·스택 DTCM 각 256 KiB, 캐시 OFF.',
    '- GCC 15.2.1 -O3, 동일 FP/Zephyr 설정·링커 정책, 두 구현 모두 IRQ ON의 64-bit SysTick 계수.',
    '- 키별 계측은 같은 board_keygen_perf.c에서 출발. 생성기 타이밍 삽입을 제거하면 원본 두 C 파일 및 측정 소스가 byte 단위로 복원됨.',
    '- 각 구현 KAT·정확한 NTRU 방정식 200/200 PASS. 인코딩된 키 해시 200/200쌍 일치. 무계측 실행의 키와도 모두 일치.',
    '- 직접 측정한 함수 내부 시간과 부모의 나머지 시간을 분리해 합계가 100%임을 검사. 부모와 자식을 더하지 않음.',
    '- 각 구간은 타이머 비용을 포함하고 임의 차감하지 않음. 작은 함수의 호출당 배율은 특히 계측 영향을 받는다.',
    '- 전체 성능 판정은 무계측 결과, 이 표는 병목 위치 진단용. 다른 세부 코드 주소와 계측에 따른 컴파일 변화는 남는다.',
    '- 서명/검증 및 전체 상수시간 시험을 이번 계측에서 다시 수행한 것은 아님.','',
    f'- [기준 원시 로그]({refdir}/raw.log)',
    '- [현재 원시 로그](raw.log)',
    '- [기계 판독 수치](integration_comparison.json)',
    '- [현재 실행 manifest](run.json)','']
(curdir/'integration_comparison.md').write_text('\n'.join(lines))
for d in (512,1024):
    print('degree',d,'probe_pct',rr[d]['instrumentation_percent'],rc[d]['instrumentation_percent'])
    print('all calls equal',all(comparison[d]['calls_equal'].values()))
    print('all success equal',all(comparison[d]['success_equal'].values()))
    print('deltas/key',json.dumps(comparison[d]['delta_cycles_per_key'],indent=2))
    print('sum',comparison[d]['delta_sum'])
print('Saved',curdir/'integration_comparison.md')
