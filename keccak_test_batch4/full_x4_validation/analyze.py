#!/usr/bin/env python3
"""Summarize the actual all-x4 experiment; keep prefix-only history separate."""
import hashlib
import json
from pathlib import Path
import re

HERE=Path(__file__).resolve().parent
data={}
for op in ('keygen','sign'):
    data[op]={}
    for mode in ('control','profile'):
        files=sorted((HERE/'results'/(op+'_'+mode)).glob('*/manifest.json'))
        assert files,(op,mode)
        path=files[-1];manifest=json.loads(path.read_text())
        assert manifest['valid'],manifest
        raw=re.sub(r'Info : [^\n]*\n','',(path.parent/'raw.log').read_text())
        rows={}
        for n,operation,v,batches,cycles in re.findall(
            r'^TOTAL n=(\d+) op=(\d+) variant=(\d+) batches=(\d+) cycles=(\d+)$',raw,re.M):
            rows[f'{n}_{v}']=dict(n=int(n),variant=int(v),batches=int(batches),cycles=int(cycles),functions={})
        for n,operation,v,name,cycles,calls,children,inclusive in re.findall(
            r'^CATEGORY n=(\d+) op=(\d+) variant=(\d+) name=(\w+) cycles=(\d+) calls=(\d+) children=(\d+) inclusive=(\d+)$',raw,re.M):
            rows[f'{n}_{v}']['functions'][name]=dict(cycles=int(cycles),calls=int(calls))
        for n,operation,v,one,two,three,four in re.findall(
            r'^LANES n=(\d+) op=(\d+) variant=(\d+) one=(\d+) two=(\d+) three=(\d+) four=(\d+)$',raw,re.M):
            rows[f'{n}_{v}']['lanes']=list(map(int,(one,two,three,four)))
        if mode=='profile':
            for n in (512,1024):
                f=rows[f'{n}_1']['functions']
                for name in ('single_keccak','shake_init','shake_inject','shake_flip','shake_extract','inject_chunk'):
                    assert f[name]['calls']==0,(op,n,name)
                assert sum(rows[f'{n}_1']['lanes'])==f['x4_permute']['calls']
        assert 'EDGE_STREAM checks=10112 ' in raw
        assert ('EDGE_KEY mixed_degrees=PASS' if op=='keygen' else 'EDGE_SIGN byte_exact=16 batch_verified=16') in raw
        verify={512:[],1024:[]}
        for n,batch,a,b in re.findall(
            r'^VERIFY_PAIR n=(\d+) batch=(\d+) original=(\d+) batch4=(\d+)$',raw,re.M):
            verify[int(n)].append((int(a),int(b)))
        generation=json.loads((path.parent/'generation.json').read_text())
        sources={p:h for p,h in generation['original'].items()
            if str(HERE.parent)+'/' in p and '/validation/' not in p}
        for p,h in sources.items():
            assert hashlib.sha256(Path(p).read_bytes()).hexdigest()==h,('source stale',p)
        data[op][mode]=dict(run=str(path.parent.relative_to(HERE)),manifest=manifest,
            rows=rows,verify=verify,production_sources=sources)
    assert data[op]['control']['manifest']['fingerprint']==data[op]['profile']['manifest']['fingerprint']
reference_sources=data['keygen']['control']['production_sources']
for op in data:
    for mode in data[op]:
        assert reference_sources==data[op][mode]['production_sources'],'different production revisions'

md='''# 전체 SHAKE x4 전환 결과 — 2026-10-01

## 결론

키생성·서명 batch4 경로에서 기존 단일 Keccak/SHAKE 호출을 제거했다.
검증 batch4도 단일 Keccak 없이 실행된다. **기존 단일 API는 단일 SHAKE를 유지한다.**

그러나 이것은 모든 순간에 네 요청을 유효하게 병렬 처리하는 구현이 아니다.
끝난 키생성 lane과 아직 난수가 충분한 서명 lane은 상태를 보존하며, 부분 마스크도
동일한 x4 permutation 비용을 지불한다. 서명 산술 본체는 공유 scratch에서 순차 실행한다.
현재 측정에서 키생성은 소폭 느려졌고, 서명1024는 뚜렷하게 느려졌다.
**전체 x4 연결은 구현·시험했지만 성능 개선판으로 채택하는 것은 권하지 않는다.**

## 전체 성능 — 계측 없는 control

비교는 같은 ELF, 같은 입력의 Before_slothy 네 건 순차 실행 대 현재 배치다.
이미 NTT·FFT 최적화가 포함된 기준이며 최초 M55_ref 대비 수치가 아니다.
1보다 작은 배율은 느려짐을 뜻한다. 시간 변화는 (후/전 - 1)이다.
순수 단일 요청 지연시간이 아니라 네 건 전체 시간/처리량 비교다.

| 연산 | 크기 | 원본 네 건 평균 cycles | 전체 x4 평균 cycles | 속도 배율 | 시간 변화 |
|---|---:|---:|---:|---:|---:|
'''
labels={'keygen':'키생성','sign':'서명'}
for op,label in labels.items():
    for n in (512,1024):
        a,b=(data[op]['control']['rows'][f'{n}_{v}'] for v in (0,1))
        av=a['cycles']/a['batches'];bv=b['cycles']/b['batches']
        md+=f'| {label} | {n} | {av:,.1f} | {bv:,.1f} | {av/bv:.5f}× | {100*(bv/av-1):+.3f}% |\n'
for n in (512,1024):
    pairs=data['sign']['control']['verify'][n]
    assert len(pairs)==25
    a=sum(p[0] for p in pairs)/len(pairs);b=sum(p[1] for p in pairs)/len(pairs)
    md+=f'| 검증 | {n} | {a:,.1f} | {b:,.1f} | {a/b:.5f}× | {100*(b/a-1):+.3f}% |\n'

md+='''
이전 prefix-only 측정과는 서명 fixture 수 및 코드 배치가 다르므로 과거 수치와
직접 빼서 개선률을 만들지 않는다. 위 표의 각 행은 동일 펌웨어 내 paired 비교다.

## 단일 Keccak 제거 확인

profile 펌웨어의 암호 연산 내부에서 센 호출 횟수. 준비·흡수·추출·주변 해시까지 포함하며,
원본 대조 및 측정 밖의 검증/테스트용 SHAKE 호출은 배치 집계에 섞지 않았다.

| 연산 | 크기 | 측정 배치 수 | 원본 단일 Keccak | 전체 x4의 단일 Keccak | x4 호출 |
|---|---:|---:|---:|---:|---:|
'''
for op,label in labels.items():
    for n in (512,1024):
        a,b=(data[op]['profile']['rows'][f'{n}_{v}'] for v in (0,1))
        md+=f"| {label} | {n} | {a['batches']} | {a['functions']['single_keccak']['calls']} | **0** | {b['functions']['x4_permute']['calls']} |\n"
md+='''
배치의 shake_init/inject/flip/extract 및 scalar inject_chunk도 모두 0회다.
검증 배치는 512/1024 각각 25회 측정 + warmup 및 혼합 입력 경계 검사에서
단일 Keccak 호출을 watch해 0회인지 검사했다.

## 왜 전체 x4가 반드시 빠르지는 않은가

| 연산 | 크기 | 활성1 lane 호출 | 활성2 | 활성3 | 활성4 | 평균 활성 lane 비율 |
|---|---:|---:|---:|---:|---:|---:|
'''
for op,label in labels.items():
    for n in (512,1024):
        counts=data[op]['profile']['rows'][f'{n}_1']['lanes']
        useful=sum((i+1)*c for i,c in enumerate(counts))/(4*sum(counts))
        md+=f'| {label} | {n} | '+' | '.join(str(c) for c in counts)+f' | {100*useful:.2f}% |\n'
md+='''
마스크가 실제 전진시키는 상태 수다. 미리 생성해 놓고 나중에 쓰지 않은 바이트까지
제외한 유효 소비량 비율은 아니며 네 lane 활성만으로 4배 속도를 뜻하지 않는다.

- 키생성: 후보 생성은 번갈아 진행하지만 성공 시점이 서로 다르다. 끝난 키의
  lane을 다른 키의 스트림에 섞을 수 없어 후반에 부분 배치가 생긴다.
- 서명: 초기 난수/주변 해시는 함께 계산하지만 서명 본체는 한 건씩 완료한다.
  후속 샘플러 출력은 한 lane만 요구하는 경우가 많다. 특히 1024에서 이 비용이 크다.
- 검증: 기존 넓은 x4 적용 범위 유지. 서명처럼 장시간의 샘플러 연속 소비가 없다.
- 한 lane만 필요한 경우에도 scalar로 되돌아가지 않는다. 이것이 전체 x4 요구를
  충족시키는 동시에 현재 성능 손해를 일으키는 명확한 한계다.

## 정확성·범위 검사

각 control/profile 모드에서:

- 키생성: 512/1024 각각40개 고유 입력 + warmup, **총88개 키 원본 전체 바이트 일치**.
  추가로 혼합 크기·빈 seed·큐0/1/2·선택적 sk/pk 출력·잘못된 work 검사.
- 서명: 총208개 원본 전체 바이트 일치,208개 정상 검증,208개 변조 거부.
  혼합 크기/raw/prehash/external-mu/255-byte context/빈 seed를 포함한16개 추가 서명도 일치.
- 독립 스트림: 모드별 **10,112개 대조**, 0/1/2/7 블록 큐, 136-byte 경계,
  비대칭 소비, 한 lane만 많이 소비, counter1..26 재초기화 및 다른 lane 상태 보존.
- 검증: mixed batch16개 정상 통과, 각 lane의 변조가 다른 lane의 결과를 오염시키지 않음.
- guards, profile stack/합계, CFSR/HFSR/AFSR=0, TCM/ECC 검사 통과.
- 정수/FFT/NTT/샘플러 산술과 기존 scalar/x4 permutation ASM은 유지했다.
  audit.py에서 산술 구간 및 Before_slothy 소스 hash를 검사한다.

이는 시험 입력의 KAT 호환/회귀 검사다. 공식 전체 KAT suite, 모든 입력 동등성,
전체 상수시간 또는 전력/EM 보안 검증 완료를 의미하지 않는다.
활성 lane과 난수 소비/재시도에 따른 새 제어 흐름의 보안 검토는 별도로 필요하다.

## 측정 환경과 메모리

N657 serial 003C00223335510735383531만 RAM 로딩. 800MHz, cache OFF, ECC ON,
코드 ITCM / 상수·데이터·스택 DTCM 각256KiB. GCC15.2.1 -O3, Cortex-M55,
hard FP64 ABI, -ffp-contract=off -fno-fast-math -fno-strict-aliasing.
IRQ ON,64-bit SoC timer. main stack32KiB. Flash/M4/Before_slothy 미변경.

키생성10배치/크기, 서명·검증25배치/크기. 원본/후보 순서 교대.
서명은 크기별 두 키를 네 요청에 교차 배치하고 각 메시지/seed를 독립적으로 설정했다.
출력 대조·회귀 검사·로그·caller의 work 삭제는 시간 밖이다.
성능 표는 probe 없는 control이고 profile은 호출 범위/활성 lane 확인에만 사용한다.
새 큐 관리·인라인 reader 비용을 완전히 분해하지 않았으므로 기존 연산 비중표를 재사용하지 않는다.

| 항목 | 크기 |
|---|---:|
| 키생성 caller work, blocks64 | 73,599 B |
| 서명 caller work, blocks112 | 136,031 B |
| 검증 caller work | 14,207 B |
| 키생성 control/profile DTCM, fixture/OS 포함 | 241,352 B |
| 서명 control/profile DTCM, fixture/OS 포함 | 258,184 B |

새 blocks 정책은 반복 큐 용량이다. blocks=0은 최소1블록이며 모든 경로가 x4다.
세 연산을 동시에 메모리에 상주시킨 제품 펌웨어의 적합성을 증명한 수치는 아니다.

## 코드와 재현

- shake_independent4.c/.h: rolling queue, 미소비 tail 압축, masked x4, retry reset, Hash-to-Point.
- kgen.c, kgen_gauss.c: 독립 후보 생성 교차 진행, 실패 재시도, 최종 pk hash x4.
- sign.c: mu/개인키 hash/seed/초기 nonce 및 Hash-to-Point x4.
- sign_core.c, sign_inner.h, shake_batch4.c/.h: 추가 난수·retry도 x4, 기존 단일 API 보존.
- fndsa_batch4.h: 새 큐 용량 및 workspace 계약.
- 배포 Makefile에 후보 선택 옵션이나 외부 링크는 추가하지 않았다. 독립 라이브러리 빌드 통과.
- 이전 코드 보존: baseline/prefix_only_20261001.tar.gz.
- 실행 방법: README.md.

## 실행 원자료

'''
for op in labels:
    for mode in ('control','profile'):
        run=data[op][mode]['run']
        md+=f'- {op}/{mode}: [raw.log]({run}/raw.log), [manifest]({run}/manifest.json), [sources]({run}/sources.json), [ELF]({run}/benchmark.elf).\n'
(HERE/'data.json').write_text(json.dumps(data,indent=2)+'\n')
(HERE/'result.md').write_text(md)
print(md)
