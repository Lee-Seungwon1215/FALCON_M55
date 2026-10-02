#!/usr/bin/env python3
"""Recompute H0/H1 results from validated, archived board logs (no board I/O)."""
import hashlib
import importlib.util
import json
from pathlib import Path
import re

from audit_scaling import sections

ROOT = Path(__file__).resolve().parent
_spec = importlib.util.spec_from_file_location("scaling_audit_parser", ROOT / "H1_final_scaling/profiling/m55.py")
_audit_parser = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_audit_parser)
PATHS = {
    "h0": {
        "perf": "experiments/h0_layout/profiling/results/h0_layout-final_v1-perf/full_validated.json",
        "audit": "experiments/h0_layout/profiling/results/h0_layout-final_v1-audit/pilot_validated.json",
        "ntru": "experiments/ntru_total/h0_layout/results/control/validated.json",
    },
    "h1": {
        "perf": "H1_final_scaling/profiling/results/h1-final_v1-perf/full_validated.json",
        "audit": "H1_final_scaling/profiling/results/h1-h1_final_v1-audit/pilot_validated.json",
        "ntru": "experiments/ntru_total/h1/results/control/validated.json",
    },
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_run(relative):
    record = json.loads((ROOT / relative).read_text())
    assert record["valid"]
    run = Path(record["run_directory"])
    metadata = json.loads((run / "run.json").read_text())
    assert metadata["valid"] and not metadata["validation_errors"]
    assert sha(run / "zephyr.elf") == record["elf_sha256"] == metadata["elf_sha256"]
    if "raw_log_sha256" in metadata:
        assert sha(run / "raw.log") == metadata["raw_log_sha256"]
    raw = (run / "raw.log").read_text()
    evidence = {"run_directory": str(run.relative_to(ROOT)),
                "elf_sha256": record["elf_sha256"],
                "raw_sha256": sha(run / "raw.log")}
    return run, metadata, raw, evidence


def stats(values):
    assert len(values) == 10
    return {"upper_median": sorted(values)[5], "mean": sum(values) / 10,
            "min": min(values), "max": max(values), "batches": values}


def compare(before, after):
    return {"h0": stats(before), "h1": stats(after),
            "improvement_pct": 100 * (sorted(before)[5] - sorted(after)[5]) / sorted(before)[5],
            "mean_improvement_pct": 100 * (sum(before) - sum(after)) / sum(before),
            "paired_improvement_pct": [100 * (a - b) / a for a, b in zip(before, after)]}


def main():
    runs = {candidate: {kind: load_run(path) for kind, path in paths.items()}
            for candidate, paths in PATHS.items()}
    report = {"metric": "100*(H0-H1)/H0; positive means fewer cycles",
              "api_statistic": "upper median of 10 batch means; 10 calls/batch",
              "micro_statistic": "upper median of 10 batch means; 100 calls/batch; PRIMES[0]",
              "ntru_statistic": "sum of solve_NTRU time across all retries / 10 keygens",
              "evidence": {c: {k: v[3] for k,v in d.items()} for c,d in runs.items()},
              "api": {}, "micro": {}, "ntru": {}}
    api = {}
    micro = {}
    for candidate, kinds in runs.items():
        _, meta, raw, _ = kinds["perf"]
        assert meta["host_digests_match"]
        assert "FNDSA_BEGIN mode=full batches=10 warmups=10 iterations=10" in raw
        api[candidate] = {(int(d),int(op),int(b)):int(t)/10
            for d,b,op,t in re.findall(
                r"^BATCH degree=(\d+) batch=(\d+) op=(\d+) total=(\d+)", raw, re.M)}
        assert set(api[candidate]) == {(d,op,b) for d in (512,1024) for op in range(3) for b in range(10)}
        run, meta, raw, _ = kinds["audit"]
        assert meta["host_digests_match"]
        # Revalidate raw coverage, including historical runs parsed by older tools.
        # Do not modify the archived rns_audit.json or its original validation.
        audit = _audit_parser.parse_audit(raw)
        assert int(audit["exact"]["primes"]) == 308
        for field in ("forward_mismatches", "inverse_mismatches", "roundtrip_mismatches", "max_mod_error"):
            assert int(audit["exact"][field]) == 0
        assert "mismatches=0 range_errors=0" in audit["rounding"]
        micro[candidate] = {(int(n),direction,int(b)):int(t)/int(calls)
            for n,direction,b,calls,t,_ in audit["cycle_batches"]}
        assert set(micro[candidate]) == {(n,d,b) for n in range(4,11)
                                       for d in ("forward","inverse") for b in range(10)}
    digest = lambda raw: re.findall(r"^DIGEST degree=(\d+) batch=(\d+) shake256=([0-9a-f]+)$",raw,re.M)
    assert len(digest(runs["h0"]["perf"][2])) == 20
    assert digest(runs["h0"]["perf"][2]) == digest(runs["h1"]["perf"][2])
    for degree in (512,1024):
        for op,name in enumerate(("keygen","sign","verify")):
            row = compare(*[[api[c][degree,op,b] for b in range(10)] for c in ("h0","h1")])
            report["api"][f"{degree}_{name}"] = row
            print(f"API {degree} {name}: {row['h0']['upper_median']:.2f} -> {row['h1']['upper_median']:.2f}; {row['improvement_pct']:+.6f}%")
    for logn in range(4,11):
        for direction in ("forward","inverse"):
            row = compare(*[[micro[c][logn,direction,b] for b in range(10)] for c in ("h0","h1")])
            report["micro"][f"{logn}_{direction}"] = row
            print(f"MICRO {logn} {direction}: {row['h0']['upper_median']:.2f} -> {row['h1']['upper_median']:.2f}; {row['improvement_pct']:+.6f}%")
    a, b = (runs[c]["ntru"][1] for c in ("h0","h1"))
    assert a["fingerprints"] == b["fingerprints"]
    for degree in (512,1024):
        x,y = (v["totals"][str(degree)] for v in (a,b))
        assert x["calls"] == y["calls"]
        row = {"h0":x,"h1":y,"keygens":10,"fingerprint":a["fingerprints"][str(degree)],
               "h0_per_keygen":x["total"]/10, "h1_per_keygen":y["total"]/10,
               "improvement_pct":100*(x["total"]-y["total"])/x["total"]}
        report["ntru"][str(degree)] = row
        print(f"NTRU {degree}: {row['h0_per_keygen']:.2f} -> {row['h1_per_keygen']:.2f}; {row['improvement_pct']:+.6f}%; {x['calls']} attempts/10 keys")
    # The independently instrumented diagnostic must have the same layout too.
    a,b = (sections(runs[c]["ntru"][0]/"zephyr.elf") for c in ("h0","h1"))
    assert a.keys() == b.keys()
    for name,(addr,size,data) in a.items():
        assert b[name][:2] == (addr,size)
        assert all(0x10000684 <= addr+i < 0x10000684+0x578
                   for i,(x,y) in enumerate(zip(data,b[name][2])) if x != y)
    for c in ("h0","h1"):
        manifest = json.loads((runs[c]["ntru"][0]/"instrumentation.json").read_text())
        hooks = {name:kind for entry in manifest["files"].values()
                 for name,kind in entry["hooks"].items()}
        assert hooks == {"solve_NTRU":"total"}
    report["ntru_outside_intt_bytes_and_addresses_identical"] = True
    report["api_digests_identical"] = True
    report["static_audits"] = {kind:json.loads((ROOT/f"results/static_audit/{kind}_audit.json").read_text())
                               for kind in ("perf","audit")}
    output = ROOT / "results/comparison.json"
    output.parent.mkdir(parents=True,exist_ok=True)
    output.write_text(json.dumps(report,indent=2)+"\n")
    print(output)


if __name__ == "__main__":
    main()
