#!/usr/bin/env python3
"""Recompute the stage-4 comparison from validated archived board logs."""
import hashlib
import importlib.util
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("d1_audit", ROOT / "D1_vld4_last/profiling/m55.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)
PROFILES = {"d0": ROOT / "experiments/d0_layout/profiling",
            "d1": ROOT / "D1_vld4_last/profiling"}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_run(candidate, kind):
    prefix = "d0_layout" if candidate == "d0" else "d1"
    mode = "full" if kind == "perf" else "pilot"
    version = "v2" if kind == "perf" else "v1"
    path = PROFILES[candidate] / "results" / f"{prefix}-boundary_{version}-{kind}" / f"{mode}_validated.json"
    approved = json.loads(path.read_text())
    assert approved["valid"]
    run = Path(approved["run_directory"])
    meta = json.loads((run/"run.json").read_text())
    assert meta["valid"] and not meta["validation_errors"] and meta["host_digests_match"]
    assert sha(run/"zephyr.elf") == approved["elf_sha256"] == meta["elf_sha256"]
    if "raw_log_sha256" in meta:
        assert sha(run/"raw.log") == meta["raw_log_sha256"]
    manifest = json.loads((run/"h1_build.json").read_text())
    assert all(sha(run/"source"/name) == digest for name,digest in manifest["sources"].items())
    assert manifest["artifacts"]["zephyr/zephyr.elf"] == approved["elf_sha256"]
    raw = (run/"raw.log").read_text()
    return raw, {"run_directory":str(run.relative_to(ROOT)), "elf_sha256":sha(run/"zephyr.elf"),
                 "raw_log_sha256":sha(run/"raw.log")}


def statistics(values):
    assert len(values) == 10
    return {"upper_median":sorted(values)[5], "mean":sum(values)/len(values),
            "min":min(values), "max":max(values), "batches":values}


def compare(before, after):
    x,y = statistics(before),statistics(after)
    return {"d0":x, "d1":y,
            "improvement_pct":100*(x["upper_median"]-y["upper_median"])/x["upper_median"],
            "paired_improvement_pct":[100*(a-b)/a for a,b in zip(before,after)]}


def main():
    evidence, api, micro, raw_perf = {}, {}, {}, {}
    for candidate in PROFILES:
        evidence[candidate] = {}
        raw,evidence[candidate]["perf"] = load_run(candidate,"perf")
        raw_perf[candidate] = raw
        assert "FNDSA_BEGIN mode=full batches=10 warmups=10 iterations=10" in raw
        api[candidate] = {(int(n),int(op),int(b)):int(t)/10 for n,b,op,t in re.findall(
            r"^BATCH degree=(\d+) batch=(\d+) op=(\d+) total=(\d+)",raw,re.M)}
        assert set(api[candidate]) == {(n,op,b) for n in (512,1024) for op in range(3) for b in range(10)}
        raw,evidence[candidate]["audit"] = load_run(candidate,"audit")
        checked = audit.parse_audit(raw)
        micro[candidate] = {(int(n),d,int(b)):int(t)/int(c)
                            for n,d,b,c,t,_ in checked["cycle_batches"]}
    digest = lambda raw: re.findall(r"^DIGEST degree=(\d+) batch=(\d+) shake256=([0-9a-f]+)$",raw,re.M)
    assert len(digest(raw_perf["d0"])) == 20
    assert digest(raw_perf["d0"]) == digest(raw_perf["d1"])
    report = {"metric":"100*(D0-D1)/D0; positive = faster",
              "api_statistic":"upper median of 10 batch means, 10 calls each",
              "micro_statistic":"upper median of 10 batch means, 100 calls each, PRIMES[0]",
              "api_digests_identical":True, "evidence":evidence, "api":{}, "micro":{}}
    for n in (512,1024):
        for op,name in enumerate(("keygen","sign","verify")):
            row = compare(*[[api[c][n,op,b] for b in range(10)] for c in ("d0","d1")])
            report["api"][f"{n}_{name}"] = row
            print(f"API {n} {name}: {row['d0']['upper_median']:.2f} -> {row['d1']['upper_median']:.2f}; {row['improvement_pct']:+.6f}%")
    for n in range(4,11):
        for d in ("forward","inverse"):
            row = compare(*[[micro[c][n,d,b] for b in range(10)] for c in ("d0","d1")])
            report["micro"][f"{n}_{d}"] = row
            print(f"MICRO {n} {d}: {row['d0']['upper_median']:.2f} -> {row['d1']['upper_median']:.2f}; {row['improvement_pct']:+.6f}%")
    report["static_audits"] = {k:json.loads((ROOT/f"results/static_audit/{k}.json").read_text()) for k in ("perf","audit")}
    for c in ("d0","d1"):
        for k in ("perf","audit"):
            assert evidence[c][k]["elf_sha256"] == report["static_audits"][k]["elf_sha256"]["d0_layout" if c=="d0" else c]
    path = ROOT / "results/comparison.json"
    path.write_text(json.dumps(report,indent=2)+"\n")
    print(path)


if __name__ == "__main__":
    main()
