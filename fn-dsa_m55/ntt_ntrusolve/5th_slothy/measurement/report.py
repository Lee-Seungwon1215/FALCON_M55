#!/usr/bin/env python3
"""Report only validated new measurements, never copied historical results."""
import argparse
import json
from pathlib import Path
import statistics

ROOT=Path(__file__).resolve().parent
STAGE=ROOT.parent
VARIANTS=("baseline","slothyA","slothyB")

def run(variant,kind,label,mode):
    path=ROOT/"results"/(variant+"-"+kind+"-"+label)/(mode+"_validated.json")
    if not path.exists(): return None
    record=json.loads(path.read_text())
    assert record["valid"]
    directory=Path(record["run_directory"])
    return directory,json.loads((directory/"run.json").read_text())

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--labels",nargs="+",default=["v1"])
    args=p.parse_args()
    kernels={}
    links=[]
    for v in VARIANTS:
        directory,_=run(v,"audit","v1","pilot")
        audit=json.loads((directory/"rns_audit.json").read_text())
        kernels[v]={(int(k),di):statistics.mean(int(t)/int(c) for kk,dd,b,c,t,pc in audit["cycle_batches"] if kk==k and dd==di)
                    for k,di,b,c,t,pc in audit["cycle_batches"]}
        links.append(f"- [{v} audit 원시 로그]({(directory/'raw.log').relative_to(STAGE)})")
    full={}
    for label in args.labels:
        full[label]={}
        for v in VARIANTS:
            found=run(v,"perf",label,"full")
            if not found: continue
            directory,meta=found
            samples=meta["samples"]
            full[label][v]={(n,op):statistics.mean(x["total"]/10 for x in samples if x["degree"]==n and x["operation"]==op)
                           for n in (512,1024) for op in range(3)}
            links.append(f"- [{v} {label} 100회 원시 로그]({(directory/'raw.log').relative_to(STAGE)})")
    static=json.loads((ROOT/"results/static_audit.json").read_text())
    lines=["# K4-C 대비 RNS Slothy A/B 측정", "",
        "기준: 현재 ref_slothy 복사본. q-NTT Slothy A는 세 후보에서 동일하며 RNS의 kgen_mp31_cm55.s만 다르다.","",
        "## 조건", "",
        "- NUCLEO-N657X0-Q / Cortex-M55 r1p1, ST-LINK 003C00223335510735383531.",
        "- CPU 800 MHz, SYSCLK 400 MHz, HCLK 200 MHz; GCC 15.2.1, 암호 소스 마지막 옵션 -O3.",
        "- 기존 mlkem-native 기반 TCM 설정 유지: 코드 ITCM, 상수·데이터·스택 DTCM; 각 256 KiB 구성.",
        "- 기존 ECC 우회 방침 그대로 유지: 코드 사용량은 하위 128 KiB 이내, 상수는 DTCM. ECC 검사 ON.",
        "- 런타임 CCR=0x611: I/D cache OFF. Kconfig의 icache/dcache=1은 지원 구성이지 실제 활성 상태가 아니다.",
        "- 측정 전용 고정 배치: mp_NTT=0x10000400, mp_iNTT=0x10001000, small=0x10002000. 다른 함수들의 주소·크기도 동일.",
        "- 커널: prime[0], logn=4..10, 방향별 10 batches × 100 calls. root preparation 포함, 상수표 생성 제외.",
        "- 전체 API: 라운드별 10 deterministic seeds × 10 timed calls = 100회, batch마다 warmup 10회. 아래 수치는 산술평균 cycles/call.",
        "- 개선율=(baseline-candidate)/baseline×100. 양수는 빠름, 음수는 느림.","",
        "## 커널 사이클", "",
        "| logn | 방향 | baseline | A | A 개선 | B | B 개선 |",
        "|---:|---|---:|---:|---:|---:|---:|"]
    for key,base in kernels["baseline"].items():
        a,b=kernels["slothyA"][key],kernels["slothyB"][key]
        lines.append(f"| {key[0]} | {key[1]} | {base:,.2f} | {a:,.2f} | {100*(1-a/base):+.4f}% | {b:,.2f} | {100*(1-b/base):+.4f}% |")
    for label,data in full.items():
        lines += ["",f"## 전체 API — {label}","",
                  "| 크기 | 연산 | baseline | A | A 개선 | B | B 개선 |",
                  "|---:|---|---:|---:|---:|---:|---:|"]
        if len(data)!=3:
            lines.append("측정 진행 중 — 완료된 세 후보가 모이기 전 전체 비교를 확정하지 않음.")
            continue
        for key,base in data["baseline"].items():
            a,b=data["slothyA"][key],data["slothyB"][key]
            lines.append(f"| {key[0]} | {('키생성','서명','검증')[key[1]]} | {base:,.2f} | {a:,.2f} | {100*(1-a/base):+.4f}% | {b:,.2f} | {100*(1-b/base):+.4f}% |")
    lines += ["", "## 역순 커널 재측정", "", "| 후보 | v1 대비 v2 최대 상대 차이 |", "|---|---:|"]
    for v in VARIANTS:
        found=run(v,"audit","v2","pilot")
        if not found: continue
        directory,_=found
        d=json.loads((directory/"rns_audit.json").read_text())
        values={(int(k),di):statistics.mean(int(t)/int(c) for kk,dd,b,c,t,pc in d["cycle_batches"] if kk==k and dd==di)
                for k,di,b,c,t,pc in d["cycle_batches"]}
        delta=max(abs(values[k]/kernels[v][k]-1)*100 for k in values)
        lines.append(f"| {v} | {delta:.8f}% |")
        links.append(f"- [{v} 역순 v2 커널 로그]({(directory/'raw.log').relative_to(STAGE)})")
    integrated={}
    found=run("ref_slothy","perf","adopted_a","full")
    if found:
        directory,meta=found
        integrated={(n,op):statistics.mean(x["total"]/10 for x in meta["samples"] if x["degree"]==n and x["operation"]==op)
                    for n in (512,1024) for op in range(3)}
        lines += ["", "## 최종 ref_slothy 경로 재측정", "", "동일한 고정 배치에서 이 경로 자체의 소스를 새로 빌드했다.", "",
                  "| 크기 | 연산 | ref_slothy cycles | baseline 대비 개선 |", "|---:|---|---:|---:|"]
        for k,value in integrated.items():
            base=full["v1"]["baseline"][k]
            lines.append(f"| {k[0]} | {('키생성','서명','검증')[k[1]]} | {value:,.2f} | {100*(1-value/base):+.4f}% |")
        links.append(f"- [최종 ref_slothy 100회 로그]({(directory/'raw.log').relative_to(STAGE)})")
    lines += ["","## 코드 크기 (세 RNS 함수 본문 합계)","","| 후보 | bytes | 기준 대비 |","|---|---:|---:|"]
    sizes={v:sum(f["size"] for f in static["builds"]["perf"]["candidates"][v]["functions"].values()) for v in VARIANTS}
    for v,sz in sizes.items(): lines.append(f"| {v} | {sz} | {sz-sizes['baseline']:+d} |")
    lines += ["", "고정 배치를 위한 미사용 패딩은 후보 알고리즘의 코드 크기에 포함하지 않는다. 함수별 section 및 로컬 stride literal 복사는 측정 배치를 위한 동일한 조정이다.", "",
        "## 검증", "",
        "- 세 후보: 308개 소수 × logn 4..10 = 2,156개 변환 설정에서 forward/iNTT/왕복 오류 0.",
        "- rounding Montgomery: 18,923,520 cases, 불일치·범위 오류 0.",
        "- 독립 inverse 입력 포함 17,248개 경계/랜덤 패턴 검사: 불일치·비정규 출력·버퍼 guard 손상 0.",
        "- q-NTT 512/1024도 기존 C oracle과 일치. 프로젝트의 deterministic host KAT/digest와 서명·변조 거부 검사 통과.",
        "- 2,944개의 별도 호스트 명령 에뮬레이션 검사: 최종 레지스터·메모리와 순서 있는 메모리 접근 trace 일치.",
        "- 정적 점검: 새 secret-dependent branch/address 없음, 공개 크기/포인터 기반 루프만 사용. ABI 저장/복원 유지, FP·나눗셈·새 함수 호출 없음.",
        "- 한계: 위 검사는 형식적 상수시간 증명, dudect 또는 전력/EM 부채널 검사가 아니다. Slothy 모델 cycle 추정치를 보드 측정값으로 사용하지 않음.","",
        "## 채택 상태", "", "최종 채택 및 ref_slothy 반영은 `adoption.md` 참고. 해당 파일이 없으면 아직 미반영.", "", "## 원시 로그", ""]+links
    lines += ["", "- [정적 감사](measurement/results/static_audit.json)",
              "- [Slothy 생성 기록](tooling/logs/manifest.json)",
              "- [독립 스케줄 검사](tooling/logs/independent_check.json)", ""]
    (STAGE/"result.md").write_text("\n".join(lines))
    payload={"kernels":{v:{f"{k[0]}_{k[1]}":x for k,x in d.items()} for v,d in kernels.items()},
             "full":{l:{v:{f"{k[0]}_{k[1]}":x for k,x in d.items()} for v,d in vs.items()} for l,vs in full.items()},
             "integrated":{f"{k[0]}_{k[1]}":x for k,x in integrated.items()},"sizes":sizes}
    (ROOT/"results/comparison.json").write_text(json.dumps(payload,indent=2)+"\n")
    print(STAGE/"result.md")
    print(json.dumps(payload["full"],indent=2))
if __name__=="__main__": main()
