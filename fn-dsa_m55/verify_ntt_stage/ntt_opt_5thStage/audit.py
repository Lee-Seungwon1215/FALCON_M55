#!/usr/bin/env python3
"""Stage-5 scope, build, schedule-replay, and board result auditing."""
import argparse
from collections import Counter
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shlex
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT.parent / "ntt_opt_4thStage"))
import audit_combinations as shared
sys.path.insert(0, str(ROOT / "tooling"))
import generate
import run as stage5_run

shared.RESULTS = ROOT / "results"
shared.runs.runner = stage5_run.runner


def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()


def replay_check(manifest):
    ref = (ROOT / "ref/mq_cm55.s").read_text()
    assert sha(ROOT / "ref/mq_cm55.s") == manifest["reference_sha256"]
    aa, bb = ref, ref
    report = {r["label"]: r for r in manifest["reports"]}
    coverage = []
    for name, label, counter, step in generate.REGIONS:
        m = re.search(r"^" + label + r":\n(.*?)(\tsubs\s+" + counter + r", #" + str(step)
                      + r"\n\tbne(?:\.w)?\s+" + label + r"\n)", ref, re.S | re.M)
        a, b = report[name + "_A"], report[name + "_B_seam"]
        aa = aa.replace(m[0], label + ":\n\t@ SLOTHY A: iteration-local schedule; indivisible predicates/structure loads.\n"
                        + generate.asm(a["assembly_out"]) + m[2], 1)
        loop = label + "_slothyB_kernel"
        bb = bb.replace(m[0], label + ":\n\t@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.\n"
                        + f"\tsub.w\t{counter}, {counter}, #{step}\n"
                        + generate.asm(b["preamble"]) + loop + ":\n"
                        + generate.asm(b["assembly_out"]) + f"\tsubs\t{counter}, #{step}\n\tbne\t{loop}\n"
                        + generate.asm(b["postamble"]), 1)
        # Count actual moves across b_i | a_(i+1), not merely a loop rotation.
        tail_units = len(a["output"]) - b["cut"]
        tail_keys = {s.split()[0] for s in b["input"][:tail_units]}
        ahead = 0
        inversions = 0
        for s in b["output"]:
            if s.split()[0] in tail_keys: inversions += ahead
            else: ahead += 1
        coverage.append(dict(region=name, A_changed=a["assembly_in"] != a["assembly_out"],
                             B_cross_iteration_pairs_reordered=inversions,
                             B_halving_pipeline=True, public_counter=counter, step=step))
    for name, label, bound in [
        ("ntt1024_ct2", "fndsa_mqpoly_int_to_ntt__F2_butterflies", 16),
        ("intt1024_gs2", "fndsa_mqpoly_ntt_to_int__I2_butterflies", 4),
    ]:
        m = re.search(r"^" + label + r":\n(.*?)(\tcmp\s+r2, #" + str(bound) + r"\n)", ref, re.S | re.M)
        a = report[name + "_A"]
        replacement = label + ":\n\t@ SLOTHY iteration-local arithmetic schedule (A and B).\n" + generate.asm(a["assembly_out"]) + m[2]
        aa, bb = aa.replace(m[0], replacement, 1), bb.replace(m[0], replacement, 1)
        coverage.append(dict(region=name, A_changed=a["assembly_in"] != a["assembly_out"],
                             B_halving_pipeline=False, B_policy="A schedule; preserve full/half-vector control"))
    assert aa == (ROOT / "slothyA/mq_cm55.s").read_text()
    assert generate.fix_b_literal(bb) == (ROOT / "slothyB/mq_cm55.s").read_text()
    return coverage


def static_audit(name):
    refdir, src = ROOT / "ref", ROOT / name
    build, refbuild = ROOT / "build" / name, ROOT / "build/ref"
    original = (refdir / "mq_cm55.s").read_text()
    current = (src / "mq_cm55.s").read_text()
    before, after = shared.source_instructions(original), shared.source_instructions(current)
    files = sorted(p.name for p in refdir.iterdir() if p.suffix in {".c", ".h", ".s"})
    assert all(sha(refdir / f) == sha(ROOT.parent / "ntt_opt" / f) for f in files), "frozen ref differs from integrated baseline"
    changes = [f for f in files if sha(refdir / f) != sha(src / f)]
    assert changes == ["mq_cm55.s"]
    assert shared.stack(before) == shared.stack(after), "extra stack/spill"
    assert not re.search(r"^\s*(?:\.include|#include)", current, re.M)
    old_branches, branches = shared.control(before), shared.control(after)
    if name == "slothyB":
        branches = [b.replace("_slothyB_kernel", "") for b in branches]
    # Branch encoding width may differ; the branch conditions/targets may not.
    normalize = lambda bb: [re.sub(r"^(\w+)\.[nw] ", r"\1 ", b) for b in bb]
    assert normalize(old_branches) == normalize(branches)
    commands = json.loads((build / "compile_commands.json").read_text())
    rcommands = json.loads((refbuild / "compile_commands.json").read_text())
    def normalized(entries, source, bld):
        return {Path(e["file"]).name: e["command"].replace(str(source), "SOURCE").replace(str(bld), "BUILD")
                for e in entries if Path(e["file"]).parent == source}
    assert normalized(commands, src, build) == normalized(rcommands, refdir, refbuild)
    assert (build / "zephyr/.config").read_bytes() == (refbuild / "zephyr/.config").read_bytes()
    entry = next(e for e in commands if e["file"] == str(src / "mq_cm55.s"))
    rentry = next(e for e in rcommands if e["file"] == str(refdir / "mq_cm55.s"))
    ff, _, _ = shared.elf32(build / entry["output"])
    rf, _, _ = shared.elf32(refbuild / rentry["output"])
    assert ff.keys() == rf.keys()
    changed_functions = [f for f in ff if ff[f] != rf[f]]
    assert set(changed_functions) == shared.TARGETS
    _, symbols, sections = shared.elf32(build / "zephyr/zephyr.elf")
    allocated = [s for s in sections if s["flags"] & 2 and s["size"]]
    assert all((0x10000000 <= s["address"] and s["address"] + s["size"] <= 0x10020000)
               or (0x30000000 <= s["address"] and s["address"] + s["size"] <= 0x30040000)
               for s in allocated)
    out = ROOT / "results" / name
    out.mkdir(parents=True, exist_ok=True)
    objdump = Path(shlex.split(entry["command"])[0]).with_name("arm-none-eabi-objdump")
    (out / "mq_cm55.dis").write_text(subprocess.check_output([str(objdump), "-d", str(build / entry["output"])], text=True))
    result = dict(valid=True, changed_source_files=changes, changed_object_functions=changed_functions,
                  assembly_sha256=sha(src / "mq_cm55.s"), elf_sha256=sha(build / "zephyr/zephyr.elf"),
                  compiler_options_equal=True, zephyr_config_equal=True, stack_sequence_equal=True,
                  conditional_branch_sequence_equal_after_public_loop_retarget=True,
                  itcm_code_bytes=symbols["__rom_region_size"], dtcm_reserved_bytes=symbols["_image_ram_size"],
                  itcm_active_limit=131072, dtcm_capacity=262144,
                  limitations="static CT structure + separate interpreter/hardware tests; no formal CT proof/dudect/TVLA")
    (out / "static_audit.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--require-full", action="store_true")
    args = p.parse_args()
    manifest = json.loads((ROOT / "tooling/logs/manifest.json").read_text())
    model = json.loads((ROOT / "tooling/logs/instruction_model.json").read_text())
    assert model["manifest_sha256"] == sha(ROOT / "tooling/logs/manifest.json")
    coverage = replay_check(manifest)
    static = {name: static_audit(name) for name in ("slothyA", "slothyB")}
    measured = {name: shared.board_summary(name) for name in ("ref", "slothyA", "slothyB")}
    if args.require_full: assert all(measured.values()), "Missing validated full run"
    paired = {}
    if measured["ref"]:
        base = {(s["degree"], s["operation"], s["batch"]): s["total"] for s in measured["ref"]["samples"]}
        for name, value in measured.items():
            if name == "ref" or value is None: continue
            groups = {}
            for s in value["samples"]:
                key = (s["degree"], s["operation"], s["batch"])
                label = str(s["degree"]) + "_" + ("keygen", "sign", "verify")[s["operation"]]
                groups.setdefault(label, []).append((base[key] - s["total"]) / 10)
            paired[name] = {k: dict(ref_minus_candidate_cycles=v, upper_median_delta=sorted(v)[5],
                                    faster=sum(x > 0 for x in v), slower=sum(x < 0 for x in v)) for k,v in groups.items()}
    result = dict(complete=all(measured.values()), static=static, coverage=coverage,
                  instruction_model=model, measurements=measured, paired=paired)
    (ROOT / "results/comparison.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(dict(complete=result["complete"], static=static, coverage=coverage), indent=2))


if __name__ == "__main__": main()
