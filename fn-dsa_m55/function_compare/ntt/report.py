#!/usr/bin/env python3
"""Generate reproducible paired reports from two fully validated raw sessions."""
import csv
import json
from pathlib import Path
import statistics as st
from audit import ROOT, check, layouts, sha, KERNELS
from run import parse

def stats(values):
    cycles=[v/100 for v in values]
    return {'min':min(cycles),'median':st.median(cycles),'max':max(cycles)}

def main():
    output=[]; sessions={}; indexed={}
    layout_audit=layouts()
    for layout in ('ab','ba'):
        pointer=json.loads((ROOT/'results'/layout/'validated.json').read_text())
        d=Path(pointer['run_dir']); meta=json.loads((d/'run.json').read_text())
        assert meta['status']=='PASS' and meta['returncode']==0
        assert sha(d/'raw.log')==meta['raw_sha256']==pointer['raw_sha256']
        manifest=check(layout)
        assert meta['build_manifest']==manifest
        sessions[layout]={'directory':str(d.relative_to(ROOT)),'raw_sha256':meta['raw_sha256'],
                          'elf_sha256':manifest['artifacts']['zephyr/zephyr.elf'],
                          'started_utc':meta['started_utc'],'ended_utc':meta['ended_utc']}
        for row in parse((d/'raw.log').read_text()):
            original=stats(row['original_totals']); optimized=stats(row['optimized_totals'])
            entry={'layout':layout,**row,'original':original,'optimized':optimized,
                   'reduction_pct':100*(1-optimized['median']/original['median']),
                   'speedup':original['median']/optimized['median'],
                   'paired_batch_reductions_pct':[100*(1-b/a) for a,b in zip(row['original_totals'],row['optimized_totals'])]}
            output.append(entry)
            indexed[(layout,row['family'],row['logn'],row['pi'],row['direction'])]=entry
    comparison=[]
    for e in output:
        if e['layout']!='ab':continue
        other=indexed[('ba',e['family'],e['logn'],e['pi'],e['direction'])]
        comparison.append({'family':e['family'],'logn':e['logn'],'pi':e['pi'],'direction':e['direction'],
                           'original_cycle_delta':other['original']['median']-e['original']['median'],
                           'optimized_cycle_delta':other['optimized']['median']-e['optimized']['median'],
                           'reduction_pp_delta':other['reduction_pct']-e['reduction_pct']})
    summary={'sessions':sessions,'layout_audit':layout_audit,'measurements':output,'layout_comparison':comparison}
    (ROOT/'results/summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    fields=['layout','family','logn','n','prime_index','direction','original_min','original_median','original_max',
            'optimized_min','optimized_median','optimized_max','reduction_pct','speedup']
    with (ROOT/'results/all_primes.csv').open('w',newline='') as f:
        w=csv.writer(f);w.writerow(fields)
        for e in output:
            w.writerow([e['layout'],e['family'],e['logn'],1<<e['logn'],e['pi'],'inverse' if e['direction'] else 'forward',
              *[e['original'][k] for k in ('min','median','max')],*[e['optimized'][k] for k in ('min','median','max')],
              e['reduction_pct'],e['speedup']])
    md=['# NTT/iNTT 4개 함수: 원본 대비 최적화 단독 실측','',
        '> 이 문서는 2026-09-16의 **RNS K2 결과를 보존한 과거 기록**이다. 현재 `ntt_opt`의 K4C 결과로 인용하면 안 된다. 원본과 현재 K4C를 같은 측정 프로그램에서 직접 재측정한 최신 표는 [ntt_k4c/result.md](../ntt_k4c/result.md)에 있다.','',
        '동일 M55에서 `M55_ref` 원본과 당시 `ref_preslothy`의 K2(Slothy 미적용)를 비교했다. **전체 키생성·서명·검증 시간이 아니다.**','',
        '공통 q-NTT는 기존 M4 ASM ↔ MVE ASM, RNS는 기존 C + M4 인라인 ASM ↔ MVE ASM이다.',
        '모든 암호 소스는 이 프로젝트에 직접 추출한 파일이다. 새로운 인트린식 C 구현을 비교군으로 만들지 않았다.','',
        '## 대표 결과 — AB 배치','',
        '단위 cycles/call. 10개 배치(각 100회)의 중앙값(5·6번째 평균). 사이클 감소율=(전−후)/전, 속도 배수=전/후.',
        'RNS의 아래 512/1024는 **변환 길이**이며 해당 FN-DSA 키생성 전체를 뜻하지 않는다. RNS 대표값은 `PRIMES[0]`.','',
        '| 함수 | n | 원본 | 최적화 | 사이클 감소 | 속도 배수 |',
        '|---|---:|---:|---:|---:|---:|']
    names={('mq',0):'mqpoly_int_to_ntt',('mq',1):'mqpoly_ntt_to_int',('mp',0):'mp_NTT',('mp',1):'mp_iNTT'}
    for family in ('mq','mp'):
        for direction in (0,1):
            for logn in (9,10):
                e=indexed[('ab',family,logn,0,direction)]
                md.append(f"| `{names[(family,direction)]}()` | {1<<logn} | {e['original']['median']:,.2f} | {e['optimized']['median']:,.2f} | {e['reduction_pct']:.4f}% | {e['speedup']:.4f}배 |")
    md+=['','## RNS 전체 변환 크기 — 308개 소수 동일가중 요약','',
         '각 소수의 10배치 중앙값을 먼저 구한 뒤 308개를 산술평균했다. 실제 NTRU 호출빈도로 가중한 결과가 아니다.',
         '범위는 소수별 사이클 감소율의 최소~최대다. 양수는 개선, 음수는 악화.','',
         '| 방향 | logn / n | 원본 평균 | 최적화 평균 | 평균 사이클 감소 | 소수별 감소율 범위 |','|---|---|---:|---:|---:|---|']
    for direction in (0,1):
        for logn in range(4,11):
            rows=[indexed[('ab','mp',logn,p,direction)] for p in range(308)]
            a=st.mean(e['original']['median'] for e in rows);b=st.mean(e['optimized']['median'] for e in rows)
            rates=[e['reduction_pct'] for e in rows]
            md.append(f"| {'iNTT' if direction else 'NTT'} | {logn} / {1<<logn} | {a:,.2f} | {b:,.2f} | {100*(1-b/a):.4f}% | {min(rates):.4f}~{max(rates):.4f}% |")
    md+=['','## 배치 교환 대조 — AB와 BA','',
         '동일 크기의 원본/최적화 슬롯을 교환했으며, 다른 코드·데이터의 주소는 동일하다. 모든 커널은 기본 64 KiB ITCM 안이다.',
         '**개별 함수 진입 주소를 서로 완전히 일치시킨 실험은 아니다.** 함수 내부 정렬은 구현의 일부이며 그대로 유지했다.','',
         '| 함수 | n | AB 원본 → 최적화 | BA 원본 → 최적화 | BA 감소율 |','|---|---:|---:|---:|---:|']
    for family in ('mq','mp'):
        for direction in (0,1):
            for logn in (9,10):
                a=indexed[('ab',family,logn,0,direction)];b=indexed[('ba',family,logn,0,direction)]
                md.append(f"| `{names[(family,direction)]}()` | {1<<logn} | {a['original']['median']:,.2f} → {a['optimized']['median']:,.2f} | {b['original']['median']:,.2f} → {b['optimized']['median']:,.2f} | {b['reduction_pct']:.4f}% |")
    md+=['',f"각 조건의 중앙값 기준, 전체 4,316조건의 AB→BA 최대 절대 차이: 원본 {max(abs(e['original_cycle_delta']) for e in comparison):.4f} cycles/call, 최적화 {max(abs(e['optimized_cycle_delta']) for e in comparison):.4f} cycles/call. 개별 배치 원시값까지 모두 같다는 뜻은 아니다.",
         '', '## 정확성·검증 범위','',
         '- 두 레이아웃 모두 q 72세트, RNS 27,104세트의 forward/inverse/roundtrip/range/canary PASS.',
         '- 독립 직접 다항식 평가 1,548세트 PASS. q는 0과 q의 허용 동치, RNS는 [0,p) bit-exact 확인.',
         '- q logn2..10, RNS 308소수 logn0..10 검사. RNS logn<4는 원래 C fallback으로 정확성만 확인.',
         '- 각 레이아웃 4,316개 속도 조건 × 10배치마다 100회 누적 변환 후 출력도 비교, 모두 PASS.',
         '- 모든 외부 배열 경계/여유 영역 canary 유지. canary는 잘못된 쓰기 탐지이며 모든 읽기 접근의 형식적 증명이 아니다.',
         '- 타이머 자체 점검, 실제 클럭·캐시·TCM/ECC·fault 상태 검증 PASS.',
         '- 전체 FN-DSA KAT/서명검증, 모든 입력 전수검사, CT 형식 증명·dudect/TVLA는 이번 독립 프로젝트의 범위가 아니다.','',
         '## 조건과 한계','',
         '- NUCLEO-N657X0-Q, CPU/SYSCLK/HCLK=800/400/200 MHz. ITCM 코드, DTCM 상수·데이터·스택, 각 256 KiB.',
         '- I/D cache OFF, ECC ON. 기존 로컬 rodata→DTCM/ECC 초기화 유지. Flash 쓰기·삭제 없음.',
         '- GCC 15.2.1, -O3, -fno-reorder-functions. 원본 M4 인라인 ASM ON, 자동 벡터화를 별도로 끄지 않음.',
         '- 같은 ELF·같은 호출 하네스·같은 데이터 주소. 각 배치에서 원본/최적화 측정 순서를 번갈아 실행.',
         '- DWT CYCCNT, 시간 구간 IRQ OFF. 입력 복사·gm/igm 생성·검사·출력 제외, 함수 내부 준비/scaling/진입·복귀 포함.',
         '- 100회 안에서는 이전 출력을 다시 변환한다. 배치 시작 입력은 동일하며 배치 사이에 재설정한다.',
         '- 공통 함수포인터 호출·루프·타이머 비용 포함. 임의 오버헤드 차감 없음. min/max와 모든 배치 total을 보존.',
         '- 성능은 각 레이아웃 한 세션의 반복 측정이다. 독립 장시간 통계 캠페인/모든 칩 일반화가 아니다.',
         '- 이 값은 **함수 자체 개선율**이다. 기존 API의 키생성 약 6%, 검증 약 14%와 같은 지표가 아니다.','',
         '## 산출물','',
         '- [모든 소수·크기·방향·레이아웃 CSV](results/all_primes.csv)',
         '- [배치 원자료·min/median/max·배치 교환 비교 JSON](results/summary.json)',
         '- [배치/주소 정적 감사](results/layout_audit.json)',
         '- [커널별 ISA 및 공통 호출 하네스 검사](results/kernel_inspection.json)',
         '- [출처·추출 SHA-256](extraction.json)',
         '- [구조·재현 명령](README.md)','']
    for layout,s in sessions.items():
        md += [f"### {layout.upper()} 세션",'',f"- UTC: {s['started_utc']} → {s['ended_utc']}",
               f"- [raw.log]({s['directory']}/raw.log)",f"- [run.json]({s['directory']}/run.json)",
               f"- ELF SHA-256: `{s['elf_sha256']}`",f"- raw SHA-256: `{s['raw_sha256']}`",'']
    failed=[]
    for path in sorted((ROOT/'results').glob('*/*/run.json')):
        entry=json.loads(path.read_text())
        if entry.get('status')=='FAIL': failed.append((path,entry))
    if failed:
        md += ['## 통계에서 제외한 개발 실행','',
               '최초 개발 실행은 모든 계산 후 Zephyr 일반 exit 경로로 정지해 정상 종료를 확인하지 못했다.',
               '완료 breakpoint로 돌아가는 반환 경로를 고친 뒤 두 레이아웃을 새로 실행했다.',
               '이전 로더가 종료되기 전 시작된 BA 시도도 접근 단계에서 실패했으며 사용하지 않았다.',
               '현재 runner에는 프로젝트 실행 잠금과 GDB 포트 점유 확인을 추가했다. 실패 로그는 삭제하지 않았다.','']
        for path,entry in failed:
            md.append(f"- [{path.parent.name} ({entry['layout']})]({path.relative_to(ROOT)}): {entry.get('error','failed')}")
    (ROOT/'result.md').write_text('\n'.join(md)+'\n')
    print('PASS report:',ROOT/'result.md')
if __name__=='__main__':main()
