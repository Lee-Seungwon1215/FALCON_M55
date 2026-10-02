#!/usr/bin/env python3
"""Summarize raw DWT layer measurements without subtracting timer overhead."""
import json
import re
from pathlib import Path
import statistics
import sys


def fields(line):
    return dict(token.split("=", 1) for token in line.split()[1:])


def summarize(raw):
    # OpenOCD diagnostics can interrupt a SWO line; retain raw.log unchanged.
    raw = re.sub(r"Info : [^\n]*\n", "", raw)
    packed = "status=stage10_packed_tail" in raw
    tail_names = {ht: f"small_ht{ht}" if packed else f"tail_{ht}lane" for ht in (1, 2)}
    totals, layers, scales, ranges, core = {}, {}, {}, {}, {}
    for line in raw.splitlines():
        if not line.startswith(("DS_LAYER", "BENCH mode=core")):
            continue
        row = fields(line)
        if "logn" not in row:
            continue
        key = (int(row["logn"]), row["dir"])
        if line.startswith("DS_LAYER_TOTAL "):
            assert key not in totals
            totals[key] = row
        elif line.startswith("DS_LAYER "):
            layers.setdefault(key, []).append(row)
        elif line.startswith("DS_LAYER_SCALE "):
            scales[key] = row
        elif line.startswith("DS_LAYER_RANGE "):
            ranges.setdefault(key, {})[int(row["variant"])] = {
                k: int(row[k]) for k in ("min", "max")}
        elif line.startswith("BENCH mode=core "):
            core[key] = {name: statistics.median_high(
                [int(v)/int(row["calls"]) for v in row[name].split(",")])
                for name in ("q32", "ds_stage9", "ds_mve") if name in row}
    assert "DS_LAYER_DONE cases=880 mismatches=0 accounting_errors=0" in raw
    assert len(totals) == 4 and sum(map(len, layers.values())) == 34
    result = []
    for key, row in sorted(totals.items()):
        logn, direction = key
        count, total = int(row["calls"]), int(row["profiled"])
        assert count == 100 and int(row["mismatches"]) == 0
        scale, other = int(scales[key]["cycles"]), int(row["other"])
        by_layer = []
        categories = {"full_4lane": 0, tail_names[2]: 0, tail_names[1]: 0,
                      "scaling": scale, "other_and_instrumentation": other}
        assert len(layers[key]) == logn-1
        for entry in layers[key]:
            lm, ht, groups = (int(entry[k]) for k in ("lm", "ht", "groups"))
            assert ht == 1 << (logn-lm-1) and groups == 1 << (lm-1)
            assert int(entry["calls"]) == count
            cycles = int(entry["cycles"])
            category = "full_4lane" if ht >= 4 else tail_names[ht]
            categories[category] += cycles
            by_layer.append({"lm": lm, "execution_order": int(entry["order"]),
                             "ht": ht, "groups": groups, "mean_cycles": cycles/count,
                             "share_pct": 100*cycles/total})
        assert sum(categories.values()) == total
        original, control = int(row["original"]), int(row["control"])
        result.append({"n": 1 << logn, "direction": direction, "samples": count,
                       "original_mean_cycles": original/count,
                       "control_mean_cycles": control/count,
                       "profiled_mean_cycles": total/count,
                       "clone_vs_original_pct": 100*(control/original-1),
                       "profile_vs_control_pct": 100*(total/control-1),
                       "profile_vs_original_pct": 100*(total/original-1),
                       "tail_combined_pct": 100*(categories[tail_names[1]]+categories[tail_names[2]])/total,
                       "categories": {k: {"mean_cycles": v/count, "share_pct": 100*v/total}
                                      for k, v in categories.items()},
                       "layers": by_layer, "ranges": ranges[key], "same_image_core": core[key]})
        if packed:
            # Control is deliberately old stage9 now, not an instrumentation control.
            result[-1].pop("clone_vs_original_pct")
            result[-1].pop("profile_vs_control_pct")
            result[-1]["new_vs_stage9_time_reduction_pct"] = 100*(1-original/control)
    return {"denominator": "Profiled 2xFP32 FFT/iFFT only; not total key generation",
            "variant_labels": {"original": "current stage10" if packed else "stage9",
                               "control": "frozen stage9", "profiled": "current profiled"},
            "small_layer_lane_occupancy": "4/4 across groups" if packed else "1/4 or 2/4",
            "overhead_subtracted": False, "output_comparisons": 880, "mismatches": 0,
            "runs": result}


if __name__ == "__main__":
    path = Path(sys.argv[1])
    print(json.dumps(summarize(path.read_text()), indent=2))
