#!/usr/bin/env python3
"""Derive stage-2 tables from validated records, preserving sample units."""
import hashlib
import json
from pathlib import Path
import statistics

ROOT = Path(__file__).resolve().parent

def read_run(base, candidate, mode):
    record = json.loads((base / "results" / candidate / (mode + "_validated.json")).read_text())
    assert record["valid"]
    run = Path(record["run_directory"])
    meta = json.loads((run / "run.json").read_text())
    assert meta["valid"] and meta["host_digests_match"]
    assert hashlib.sha256((run / "raw.log").read_bytes()).hexdigest() == meta["raw_log_sha256"]
    return run, meta

def direct(base, candidate):
    run, meta = read_run(base, candidate, "pilot")
    audit = json.loads((run / "rns_audit.json").read_text())
    values = {}
    for n in range(4, 11):
        for direction in ("forward", "inverse"):
            v = [int(row[4]) / int(row[3]) for row in audit["cycle_batches"]
                 if int(row[0]) == n and row[1] == direction]
            assert len(v) == 10
            values[f"{n}_{direction}"] = {
                "median": statistics.median(v), "min": min(v), "max": max(v)}
    return {"run": str(run.relative_to(ROOT)), "cycles": values}

def gain(old, new):
    return 100 * (old - new) / old

def main():
    result = {"gain_convention": "100 * (L2 - L3) / L2; positive is faster",
              "full": {}, "direct": {}, "placement_sweep": {}}
    indexed = {}
    for candidate in ("l2", "l3"):
        run, meta = read_run(ROOT, candidate, "full")
        data = {}
        index = {}
        for row in meta["samples"]:
            key = (row["degree"], row["operation"], row["batch"])
            assert key not in index
            index[key] = row["total"] / 10
        indexed[candidate] = index
        for degree in (512, 1024):
            for op, name in enumerate(("keygen", "sign", "verify")):
                v = sorted(index[(degree, op, b)] for b in range(10))
                data[f"{degree}_{name}"] = {
                    "upper_median": v[5], "standard_median": statistics.median(v),
                    "min": v[0], "max": v[-1]}
        result["full"][candidate] = {"run": str(run.relative_to(ROOT)), "cycles": data}
        result["direct"][candidate] = direct(ROOT, candidate + "_audit")
    result["paired"] = {}
    for degree in (512, 1024):
        for op, name in enumerate(("keygen", "sign", "verify")):
            a = [indexed["l2"][(degree, op, b)] for b in range(10)]
            b = [indexed["l3"][(degree, op, b)] for b in range(10)]
            result["paired"][f"{degree}_{name}"] = {
                "l3_wins": sum(y < x for x, y in zip(a, b)),
                "per_batch_gain_percent": [gain(x, y) for x, y in zip(a, b)],
                "cycles_saved_per_call": [x-y for x, y in zip(a, b)]}
    for label in ("early", "middle", "late"):
        result["placement_sweep"][label] = direct(ROOT / "experiments" / label, "l3_audit")
    (ROOT / "results/comparison.json").write_text(json.dumps(result, indent=2) + "\n")
    print("FULL: upper median of 10 batch averages; positive gain = faster")
    print("degree/op | L2 | L3 | gain% | paired L3 wins")
    for key, a in result["full"]["l2"]["cycles"].items():
        b = result["full"]["l3"]["cycles"][key]
        print(f"{key} | {a['upper_median']:,.1f} | {b['upper_median']:,.1f} | "
              f"{gain(a['upper_median'], b['upper_median']):+.4f}% | "
              f"{result['paired'][key]['l3_wins']}/10")
    print("DIRECT: median of 10 batches x 100 calls, cycles/call")
    for n in range(4, 11):
        fields = [str(n)]
        for d in ("forward", "inverse"):
            a = result["direct"]["l2"]["cycles"][f"{n}_{d}"]["median"]
            b = result["direct"]["l3"]["cycles"][f"{n}_{d}"]["median"]
            fields += [f"{a:.2f}", f"{b:.2f}", f"{gain(a,b):+.4f}%"]
        print(" | ".join(fields))

if __name__ == "__main__":
    main()
