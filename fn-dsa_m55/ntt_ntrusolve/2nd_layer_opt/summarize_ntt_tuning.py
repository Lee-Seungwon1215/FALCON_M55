#!/usr/bin/env python3
"""Independent report for forward-only tuning; old stage-2 records stay intact."""
import json
from pathlib import Path
import statistics
from summarize_layer import direct, read_run, gain

ROOT = Path(__file__).resolve().parent

def full(base, candidate):
    run, meta = read_run(base, candidate, "full")
    samples = {(r["degree"], r["operation"], r["batch"]): r["total"]/10
               for r in meta["samples"]}
    out = {}
    for n in (512, 1024):
        for op, name in enumerate(("keygen", "sign", "verify")):
            values = [samples[(n,op,b)] for b in range(10)]
            out[f"{n}_{name}"] = {
                "upper_median": sorted(values)[5],
                "standard_median": statistics.median(values), "batches": values}
    return {"run": str(run.relative_to(ROOT)), "cycles": out}

def main():
    labels = ("ntt_before", "ntt_nomove", "ntt_address", "ntt_dispatch", "ntt_final")
    result = {"positive_gain_means": "fewer cycles", "phases": {}, "full": {}}
    result["l2_direct"] = direct(ROOT, "l2_audit")
    for label in labels:
        result["phases"][label] = direct(ROOT / "experiments" / label, "l3_audit")
    base = result["phases"]["ntt_before"]["cycles"]
    for label in labels:
        for n in range(4,11):
            assert result["phases"][label]["cycles"][f"{n}_inverse"]["median"] == base[f"{n}_inverse"]["median"]
    result["all_inverse_medians_unchanged"] = True
    result["full"]["l2"] = full(ROOT, "l2")
    for label in ("ntt_before", "ntt_final"):
        result["full"][label] = full(ROOT / "experiments" / label, "l3")
    result["comparison"] = {}
    for key, new in result["full"]["ntt_final"]["cycles"].items():
        comparisons = {}
        for label in ("ntt_before", "l2"):
            old = result["full"][label]["cycles"][key]
            comparisons[label] = {
                "upper_median_gain_percent": gain(old["upper_median"],new["upper_median"]),
                "wins": sum(b<a for a,b in zip(old["batches"],new["batches"])),
                "paired_cycles_saved": [a-b for a,b in zip(old["batches"],new["batches"])],
            }
        result["comparison"][key] = comparisons
    path = ROOT / "experiments/ntt_final/comparison.json"
    path.write_text(json.dumps(result, indent=2)+"\n")
    print("NTT cycles/call: L2 / original L3 / no copies / address reuse / dispatch / final")
    for n in range(4,11):
        key=f"{n}_forward"
        vals=[result["l2_direct"]["cycles"][key]["median"]]
        vals += [result["phases"][label]["cycles"][key]["median"] for label in labels]
        print(n,*(f"{v:.2f}" for v in vals),"gain vs L2",f"{gain(vals[0],vals[-1]):+.4f}%")
    print("FULL: upper median cycles/call, positive percentage = faster")
    for key, new in result["full"]["ntt_final"]["cycles"].items():
        old = result["full"]["ntt_before"]["cycles"][key]
        l2 = result["full"]["l2"]["cycles"][key]
        cmp = result["comparison"][key]
        print(key, "L2", f"{l2['upper_median']:,.1f}", "L3 before",f"{old['upper_median']:,.1f}",
              "L3 after",f"{new['upper_median']:,.1f}",
              "gain vs before",f"{cmp['ntt_before']['upper_median_gain_percent']:+.4f}%",
              "gain vs L2",f"{cmp['l2']['upper_median_gain_percent']:+.4f}%")

if __name__ == "__main__":
    main()
