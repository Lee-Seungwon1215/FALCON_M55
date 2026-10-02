#!/usr/bin/env python3
"""Generate standalone A/B assembly using the pinned real SLOTHY solver.

B uses the paper's halving heuristic: [a;b]^N = a;[b;a]^(N-1);b.
The seam is rescheduled by SLOTHY; no unchecked speculative loads are added.
"""
import argparse
import hashlib
import importlib.util
import json
import logging
from pathlib import Path
import re
import sys
import time

import fndsa_slothy_adapter as arch
from slothy.core.core import SlothyBase
from slothy.core.config import Config
from slothy.helper import SourceLine

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("stage4_model", ROOT.parent / "ntt_opt_4thStage/check_combination_revision.py")
stage4 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(stage4)

# Labels identify original source regions. No line-number dependency.
REGIONS = [
    ("ntt512_ct2_wide", "fndsa_mqpoly_int_to_ntt__L512_CT2_chunk", "r3", 1),
    ("ntt512_ct3", "fndsa_mqpoly_int_to_ntt__L3x512_lanes", "r2", 1),
    ("ntt512_ct2_packed", "fndsa_mqpoly_int_to_ntt__L512_CT2_packed_loop", "r2", 1),
    ("ntt_shared_final2", "fndsa_mqpoly_int_to_ntt__L5_mve_stage3", "r3", 8),
    ("intt_shared_first2", "fndsa_mqpoly_ntt_to_int__L0_mve_stage3", "r3", 8),
    ("intt512_gs2_packed", "fndsa_mqpoly_ntt_to_int__L512_GS2_packed_loop", "r2", 1),
    ("intt512_gs3", "fndsa_mqpoly_ntt_to_int__L3x512_lanes", "r2", 1),
    ("intt512_gs2_wide", "fndsa_mqpoly_ntt_to_int__L512_GS2_wide_loop", "r3", 1),
]


def expand_body(text, defs):
    result = []
    for line in text.splitlines():
        line = line.split("@", 1)[0].strip()
        if not line: continue
        parts = line.split(None, 1)
        if parts[0] in defs:
            result.extend(stage4.expand(defs, parts[0], [s.strip() for s in parts[1].split(",")]))
        else:
            assert not line.endswith(":") and not line.startswith("."), line
            result.append(line)
    return result


def all_regs(source):
    regs = set()
    for sl in SourceLine.reduce_source(source):
        inst = arch.Instruction.parser(sl)[0]
        regs.update(inst.args_out + inst.args_in_out + inst.args_in)
    return regs


def optimize_one(source, label, timeout):
    logger = logging.getLogger(label)
    conf = Config(arch, arch.Target, logger)
    # Every physical register is live through a window unless its final value
    # is explicitly replaced. Merely listing touched registers lets a solver
    # clobber a register consumed by a later window (independent check catches it).
    conf.outputs = all_regs(source) | {f"q{i}" for i in range(8)} | {f"r{i}" for i in range(15)}
    conf.inputs_are_outputs = True
    conf.allow_useless_instructions = True
    conf.variable_size = True
    conf.constraints.stalls_allowed = len(source) * 10
    conf.constraints.allow_spills = False
    conf.constraints.allow_renaming = True
    conf.sw_pipelining.enabled = False
    # r0-r14 carry public pointers/counters/constants; q0 may alias saved s0-s3.
    # A partial D/S write must not rename its unmodified half behind our back.
    partial = set()
    for sl in source:
        partial.update(arch.Instruction.parser(sl)[0].spec["partial"])
    conf.locked_registers = {f"r{i}" for i in range(15)} | {"q0"} | partial
    conf.reserved_regs = {f"r{i}" for i in range(15)} | {"q0"} | partial
    conf.timeout = timeout
    conf.hints.order_hint_orig_order = True
    conf.hints.rename_hint_orig_rename = True
    core = SlothyBase(arch, arch.Target, logger=logger, config=conf)
    start = time.monotonic()
    if not core.optimize(source):
        raise RuntimeError(f"No verified SLOTHY solution for {label}")
    result = SourceLine.reduce_source(core.result.code)
    return result, dict(label=label, units=len(source), seconds=time.monotonic()-start,
                        solver_cycles_estimate=core.result.cycles,
                        input=[s.text for s in source], output=[s.text for s in result],
                        assembly_in=arch.decode(source), assembly_out=arch.decode(result))


def optimize(source, label, timeout):
    """Paper-style split/windows: keep each boundary's full state unchanged."""
    if len(source) <= 80:
        return optimize_one(source, label, timeout)
    result, chunks = list(source), []
    start_time = time.monotonic()
    # A 48-unit seam window also crosses the b|a boundary in the B candidate.
    for start in range(0, len(result), 48):
        end = min(start + 48, len(result))
        code, report = optimize_one(result[start:end], f"{label}_window{start}", timeout)
        result[start:end] = code
        chunks.append(report)
    return result, dict(label=label, units=len(source), seconds=time.monotonic()-start_time,
                        solver_cycles_estimate=sum(r["solver_cycles_estimate"] for r in chunks),
                        estimate_scope="sum of separately scheduled window estimates",
                        input=[s.text for s in source], output=[s.text for s in result],
                        assembly_in=arch.decode(source), assembly_out=arch.decode(result),
                        windows=chunks)


def asm(lines):
    return "".join("\t" + line.replace(" ", "\t", 1) + "\n" for line in lines)


def fix_b_literal(source):
    # Halving adds a prologue/epilogue and moves the old pool beyond ADR's
    # immediate reach. Duplicate the *address word*, not the twiddle table,
    # in the preceding unreachable gap. Keep ADR+LDR execution unchanged.
    label = "fndsa_mqpoly_ntt_to_int__L512_GS2_packed"
    near = label + "_slothyB_igmaddr"
    old = label + ":\n\tadr\tr8, fndsa_mqpoly_ntt_to_int__igmaddr\n"
    new = ("\t.align\t2\n" + near + ":\n\t.word\tfndsa_mq_barrett3_iGM\n"
           + label + ":\n\tadr\tr8, " + near + "\n")
    if near + ":" in source: return source
    assert old in source
    return source.replace(old, new, 1)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--only", help="region name for a diagnostic solver run")
    p.add_argument("--timeout", type=float, default=30)
    p.add_argument("--variant", choices=["A", "B", "both"], default="both")
    p.add_argument("--fix-literals-only", action="store_true")
    args = p.parse_args()
    if args.fix_literals_only:
        path = ROOT / "slothyB/mq_cm55.s"
        path.write_text(fix_b_literal(path.read_text()))
        return
    logdir = ROOT / "tooling/logs"
    logdir.mkdir(exist_ok=True)
    logging.basicConfig(filename=logdir / "solver.log", level=logging.INFO,
                        format="%(asctime)s %(name)s %(levelname)s %(message)s")
    original = (ROOT / "ref/mq_cm55.s").read_text()
    defs = stage4.macros(original)
    out_a, out_b = original, original
    reports = []
    for name, label, counter, step in REGIONS:
        if args.only and args.only != name: continue
        match = re.search(r"^" + re.escape(label) + r":\n(.*?)(\tsubs\s+" + counter + r", #" + str(step) + r"\n\tbne(?:\.w)?\s+" + re.escape(label) + r"\n)", original, re.S | re.M)
        if not match: raise ValueError(f"Region not found: {name} {label}")
        source = arch.encode(expand_body(match[1], defs))
        print(f"SOLVE {name}: {len(source)} units", flush=True)
        a, ra = optimize(source, name + "_A", args.timeout)
        reports.append(ra)
        out_a = out_a.replace(match[0], label + ":\n\t@ SLOTHY A: iteration-local schedule; indivisible predicates/structure loads.\n" + asm(arch.decode(a)) + match[2], 1)
        if args.variant != "A":
            cut = len(a) // 2
            pre, post = a[:cut], a[cut:]
            b, rb = optimize(post + pre, name + "_B_seam", args.timeout)
            rb["cut"] = cut
            rb["preamble"] = arch.decode(pre)
            rb["postamble"] = arch.decode(post)
            reports.append(rb)
            newlabel = label + "_slothyB_kernel"
            # Loop trip counts are public. Each selected path has N >= 2.
            replacement = (label + ":\n\t@ SLOTHY B: halving pipeline a; (b;a)^(N-1); b.\n"
                           + f"\tsub.w\t{counter}, {counter}, #{step}\n"
                           + asm(arch.decode(pre)) + newlabel + ":\n"
                           + asm(arch.decode(b)) + f"\tsubs\t{counter}, #{step}\n\tbne\t{newlabel}\n"
                           + asm(arch.decode(post)))
            out_b = out_b.replace(match[0], replacement, 1)
        print(f"DONE {name}", flush=True)
        # Diagnostic artefacts are saved incrementally; no partial source-tree writes.
        (logdir / (name + ".json")).write_text(json.dumps(dict(reports=reports[-(2 if args.variant != 'A' else 1):], specs=arch.SPECS), indent=2) + "\n")
    # The 1024 middle passes have public full/half-vector branches. Keep that
    # control flow and exact access width, and reschedule their shared arithmetic.
    # B uses A here; the shared first/final-two-layer loops provide its pipeline.
    for name, label, bound in [
        ("ntt1024_ct2", "fndsa_mqpoly_int_to_ntt__F2_butterflies", 16),
        ("intt1024_gs2", "fndsa_mqpoly_ntt_to_int__I2_butterflies", 4),
    ]:
        if args.only and args.only != name: continue
        match = re.search(r"^" + label + r":\n(.*?)(\tcmp\s+r2, #" + str(bound) + r"\n)", original, re.M | re.S)
        assert match, name
        source = arch.encode(expand_body(match[1], defs))
        print(f"SOLVE {name}: {len(source)} units", flush=True)
        a, report = optimize(source, name + "_A", args.timeout)
        report["B_policy"] = "same local schedule; preserve public full/half-vector branch"
        reports.append(report)
        replacement = label + ":\n\t@ SLOTHY iteration-local arithmetic schedule (A and B).\n" + asm(arch.decode(a)) + match[2]
        out_a, out_b = out_a.replace(match[0], replacement, 1), out_b.replace(match[0], replacement, 1)
        (logdir / (name + ".json")).write_text(json.dumps(dict(reports=[report], specs=arch.SPECS), indent=2) + "\n")
        print(f"DONE {name}", flush=True)
    if not args.only:
        if args.variant in {"A", "both"}: (ROOT / "slothyA/mq_cm55.s").write_text(out_a)
        if args.variant in {"B", "both"}: (ROOT / "slothyB/mq_cm55.s").write_text(fix_b_literal(out_b))
    (logdir / "manifest.json").write_text(json.dumps(dict(
        reference_sha256=hashlib.sha256(original.encode()).hexdigest(),
        slothy_commit="55983e6760e98aece5359055085a7def96c688b7", diagnostic_only=bool(args.only),
        reports=reports, specs=arch.SPECS), indent=2) + "\n")


if __name__ == "__main__": main()
