#!/usr/bin/env python3
"""Compare preserved originals, matched controls and small-size candidates."""
import json
from pathlib import Path
import statistics
from summarize_layer import direct, read_run, gain

ROOT = Path(__file__).resolve().parent

def full(base, candidate):
    run, meta = read_run(base, candidate, "full")
    samples = {(s["degree"],s["operation"],s["batch"]):s["total"]/10 for s in meta["samples"]}
    data = {}
    for n in (512,1024):
        for op,name in enumerate(("keygen","sign","verify")):
            values = [samples[n,op,b] for b in range(10)]
            data[f"{n}_{name}"] = {"upper_median":sorted(values)[5],
                                    "median":statistics.median(values),"batches":values}
    return {"run":str(run.relative_to(ROOT)),"cycles":data}

def main():
    result = {"positive_gain_means":"fewer cycles", "direct":{}, "full":{}, "paired":{}}
    for c in ("l2","l3"):
        original = ROOT if c == "l2" else ROOT/"experiments/ntt_final"
        for label,base in (("original",original),("control",ROOT/"experiments/small_hot_control"),
                           ("final",ROOT/"experiments/small_final")):
            key = c+"_"+label
            result["direct"][key] = direct(base,c+"_audit")
            result["full"][key] = full(base,c)
        print(c,"NTT cycles: original / matched control / final / gain vs control")
        for n in range(4,11):
            k=f"{n}_forward"
            v=[result["direct"][c+"_"+label]["cycles"][k]["median"] for label in ("original","control","final")]
            print(n,*(f"{x:.2f}" for x in v),f"{gain(v[1],v[2]):+.4f}%")
        for direction in ("forward","inverse"):
            for n in range(4,11):
                k=f"{n}_{direction}"
                before=result["direct"][c+"_control"]["cycles"][k]["median"]
                after=result["direct"][c+"_final"]["cycles"][k]["median"]
                if direction == "inverse":
                    assert before == after, (c,k,"inverse median changed")
        for key,v in result["full"][c+"_final"]["cycles"].items():
            result["paired"][c+"_"+key] = {}
            for label in ("original","control"):
                b=result["full"][c+"_"+label]["cycles"][key]
                diffs=[x-y for x,y in zip(b["batches"],v["batches"])]
                result["paired"][c+"_"+key][label] = {
                    "upper_median_gain_percent":gain(b["upper_median"],v["upper_median"]),
                    "wins":sum(x>0 for x in diffs), "paired_cycles_saved":diffs}
            ctrl=result["full"][c+"_control"]["cycles"][key]["upper_median"]
            print(key,"control",f"{ctrl:,.1f}","final",f"{v['upper_median']:,.1f}",
                  f"{gain(ctrl,v['upper_median']):+.4f}%")
    result["all_inverse_medians_unchanged_vs_matched_control"] = True
    out=ROOT/"experiments/small_final/comparison.json"
    out.write_text(json.dumps(result,indent=2)+"\n")

if __name__ == "__main__":
    main()
