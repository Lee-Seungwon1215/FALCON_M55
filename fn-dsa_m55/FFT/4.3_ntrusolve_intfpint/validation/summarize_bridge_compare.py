#!/usr/bin/env python3
"""Summarize validated, same-workspace runs; never mix historical timings."""
import argparse
import hashlib
import json
import re
from pathlib import Path

BACKENDS = ("fixed_q32", "tw_double", "c_double", "tw_core", "c_core")


def fields(line):
    return dict(re.findall(r"(\w+)=([^\s]+)", line))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("runs", nargs="+", type=Path)
    parser.add_argument("--out", required=True, type=Path)
    args = parser.parse_args()
    data, runs = {}, []
    for directory in args.runs:
        manifest = json.loads((directory / "manifest.json").read_text())
        raw = (directory / "raw.log").read_bytes()
        assert manifest["valid_measurement"] and not manifest["errors"]
        assert hashlib.sha256(raw).hexdigest() == manifest["raw_sha256"]
        clean = re.sub(r"Info : [^\n]*\n", "", raw.decode())
        assert "BRIDGE_LAYOUT shared_workspace=1" in clean
        rows = [fields(line) for line in clean.splitlines()
                if line.startswith("BRIDGE_PERF ")]
        acc = [fields(line) for line in clean.splitlines()
               if line.startswith("BRIDGE_ACCURACY ")]
        checks = [fields(line) for line in clean.splitlines()
                  if line.startswith("BRIDGE_BATCH ")]
        assert len(rows) == 100 and len(acc) == 14 and len(checks) == 20
        assert all(int(r["tw_c_mismatches"]) == 0 for r in acc)
        assert all(int(r["mismatches"]) == 0 for r in checks)
        seen = set()
        for row in rows:
            n, inv, batch = (int(row[k]) for k in ("degree", "inverse", "batch"))
            b = row["backend"]
            key = n, inv, b
            assert (n, inv, batch, b) not in seen
            seen.add((n, inv, batch, b))
            assert n in (512, 1024) and inv in (0, 1) and batch in range(5)
            assert b in BACKENDS and int(row["calls"]) == 100
            item = data.setdefault(key, dict(cycles=0, calls=0, batches=[],
                                             min=2**32, max=0))
            cycles, calls = int(row["cycles"]), int(row["calls"])
            item["cycles"] += cycles
            item["calls"] += calls
            item["batches"].append(cycles / calls)
            item["min"] = min(item["min"], int(row["min"]))
            item["max"] = max(item["max"], int(row["max"]))
        runs.append(dict(directory=str(directory.resolve()),
                         elf_sha256=manifest["elf_sha256"],
                         raw_sha256=manifest["raw_sha256"],
                         layout=re.search(r"^BRIDGE_LAYOUT .*", clean, re.M)[0],
                         accuracy=acc, performance_comparisons=sum(int(r["comparisons"]) for r in checks)))
    assert len({r["elf_sha256"] for r in runs}) == 1, "Different ELF builds"
    for item in data.values():
        item["mean"] = item["cycles"] / item["calls"]
    records, lines = [], ["# 변환 포함 FFT/iFFT 재측정", "",
        "동일 ELF·동일 double 입력 버퍼·동일 DTCM workspace 시작 주소에서 비교했다.",
        "TW/4.3 행은 double → 2×FP32 → FFT 또는 iFFT → double 전체를 포함한다.",
        "원본 행은 M55_ref와 본문·회전상수가 동일한 Q32 vect_FFT/vect_iFFT이며 Q32 입출력이다.", "",
        "| 함수 | n | 원본 Q32 cycles | TW 변환 포함 | 4.3 변환 포함 | 4.3 / 원본 속도 배율 | TW 대비 시간 감소 |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: |"]
    for n in (512, 1024):
        for inv in (0, 1):
            values = {b: data[n, inv, b] for b in BACKENDS}
            f, t, c = (values[b]["mean"] for b in BACKENDS[:3])
            record = dict(degree=n, inverse=inv, backends=values,
                          speedup_vs_fixed=f/c, time_reduction_vs_fixed_pct=100*(1-c/f),
                          speedup_vs_tw=t/c, time_reduction_vs_tw_pct=100*(1-c/t))
            records.append(record)
            lines.append(f"| {'iFFT' if inv else 'FFT'} | {n} | {f:,.3f} | {t:,.3f} | {c:,.3f} | {f/c:.4f}× | {100*(1-c/t):.3f}% |")
    lines += ["", "## 변환 제외 진단 (같은 ELF)", "",
        "| 함수 | n | TW 내부 | 4.3 내부 | TW 전체−내부 | 4.3 전체−내부 |",
        "| --- | ---: | ---: | ---: | ---: | ---: |"]
    for r in records:
        v=r["backends"]
        means={k:item["mean"] for k,item in v.items()}
        lines.append(f"| {'iFFT' if r['inverse'] else 'FFT'} | {r['degree']} | "
                     f"{means['tw_core']:,.3f} | {means['c_core']:,.3f} | "
                     f"{means['tw_double']-means['tw_core']:,.3f} | "
                     f"{means['c_double']-means['c_core']:,.3f} |")
    lines += ["", "전체−내부는 별도 측정값의 차이이다. 변환·wrapper·호출 문맥·배치 효과를 함께 포함하며, 순수 변환 명령의 직접 계측값은 아니다.", "",
        f"각 함수/크기/backend: 5배치 × 100회 × {len(runs)}회 실행. 배치마다 warm-up 10회 제외.",
        "동일 seed로 펌웨어를 다시 실행하므로 재실행을 추가 독립 정확성 입력이라고 세지 않는다.",
        "정확성: 실행마다 1,400개 변환 포함 TW/4.3 출력 비교와 성능 중 8,800개 출력 비교가 bit-exact 일치했다.",
        "원본 Q32와 FP 출력 자체는 일부 다르다. 이것은 전체 키생성 KAT를 새로 통과했다는 의미가 아니다.",
        "이번에는 암호 본체를 수정하지 않았고, 키생성/서명 KAT·전체 상수시간을 재검증하지 않았다.", "",
        "## 로그", ""]
    for r in runs:
        lines += [f"- {r['directory']}", f"  - ELF SHA-256: `{r['elf_sha256']}`",
                  f"  - {r['layout']}"]
    args.out.mkdir(parents=True, exist_ok=True)
    (args.out / "summary.json").write_text(json.dumps(dict(runs=runs, results=records), indent=2)+"\n")
    (args.out / "summary.md").write_text("\n".join(lines)+"\n")
    print("\n".join(lines[:12]))
    print("SUMMARY", args.out.resolve())


if __name__ == "__main__":
    main()
