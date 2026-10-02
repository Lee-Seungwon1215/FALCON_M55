#!/usr/bin/env python3
"""Offline RNS Slothy generation. Output is self-contained GNU assembly.

Conservative memory ordering, indivisible predicates/structured loads, and
full window liveness. B uses guarded halving; no speculative buffer reads.
"""
import argparse
import collections
import hashlib
import json
import logging
from pathlib import Path
import re
import time

import rns_adapter as arch
from slothy.core.core import SlothyBase
from slothy.core.config import Config
from slothy.helper import SourceLine

ROOT = Path(__file__).resolve().parents[1]
REGIONS = [
    ("ntt_two_inner", "pointer", "r9", 16),
    ("intt_two_inner", "pointer", "r9", 16),
    ("small_two_inner", "pointer", "r9", 16),
    ("ntt_odd_loop", "counter", "r11", 4),
    ("ntt_penultimate", "counter", "r7", 1),
    ("ntt_last_loop", "counter", "r7", 4),
    ("intt_first_loop", "counter", "r6", 4),
    ("intt_second", "counter", "r7", 1),
    ("intt_odd_loop", "counter", "r7", 4),
    ("small_penultimate", "counter", "r7", 1),
    ("small_last_loop", "counter", "r7", 4),
    ("intt_final_two_body", "local", "r9", 16),
]

def clean(s):
    s = re.sub(r"/\*.*?\*/", "", s, flags=re.S)
    return [re.sub(r"\s+", " ", x.split("@", 1)[0].strip())
            for x in s.splitlines() if x.split("@", 1)[0].strip()]

def macros(s):
    defs = {}
    for m in re.finditer(r"\.macro\s+(\w+)([^\n]*)\n(.*?)\.endm", s, re.S):
        defs[m[1]] = ([x.strip() for x in m[2].split(",") if x.strip()], m[3])
    return defs

def expand(s, defs):
    out = []
    for line in clean(s):
        op, _, args = line.partition(" ")
        if op in defs:
            params, body = defs[op]
            vals = [x.strip() for x in args.split(",") if x.strip()]
            assert len(vals) == len(params)
            for p, v in zip(params, vals):
                body = body.replace("\\" + p, v)
            out.extend(expand(body, defs))
        else:
            assert not line.startswith(".") and not line.endswith(":"), line
            # Explicit non-flag-setting encodings make APSR liveness trivial.
            if op in ("add", "sub"):
                line = op + ".w " + args
            out.append(re.sub(r"\blr\b", "r14", line))
    return out

def semantic_trace(source):
    """Register-version graph + ordered memory events, independent of solver CFG.

    Opaque atoms preserve exact opcodes/immediates and input versions. This
    checks permutation/renaming, not mathematical semantics of the base code.
    """
    state = {f"r{i}": "input:r" + str(i) for i in range(15)}
    state.update({f"q{i}": "input:q" + str(i) for i in range(8)})
    state["hint_memory"] = "input:memory"
    events = []
    for sl in SourceLine.reduce_source(source):
        inst = arch.Instruction.parser(sl)[0]
        sp = inst.spec
        ins = inst.args_in_out + inst.args_in
        values = [state.get(r, "input:" + r) for r in ins]
        signature = hashlib.sha256(json.dumps([sp["lines"], values]).encode()).hexdigest()
        if sp["memory"]:
            events.append(signature)
        for k, r in enumerate(inst.args_out + inst.args_in_out):
            state[r] = signature + ":" + str(k)
    return state, events

def solve(source, name, timeout):
    logger = logging.getLogger(name)
    conf = Config(arch, arch.Target, logger)
    conf.outputs = {f"r{i}" for i in range(15)} | {f"q{i}" for i in range(8)} | {"hint_memory"}
    conf.inputs_are_outputs = True
    conf.allow_useless_instructions = True
    conf.variable_size = True
    conf.constraints.stalls_allowed = len(source) * 10
    conf.constraints.allow_spills = False
    conf.constraints.allow_renaming = True
    conf.sw_pipelining.enabled = False
    partial = {r for s in source for r in arch.Instruction.parser(s)[0].spec["partial"]}
    conf.locked_registers = {f"r{i}" for i in range(15)} | {"q0", "hint_memory"} | partial
    conf.reserved_regs = conf.locked_registers
    conf.timeout = timeout
    conf.hints.order_hint_orig_order = True
    conf.hints.rename_hint_orig_rename = True
    solver = SlothyBase(arch, arch.Target, logger=logger, config=conf)
    start = time.monotonic()
    if not solver.optimize(source):
        raise RuntimeError("No solution: " + name)
    result = SourceLine.reduce_source(solver.result.code)
    assert semantic_trace(source) == semantic_trace(result), name + " dependency mismatch"
    assert collections.Counter(x.text.split()[0] for x in source) == collections.Counter(x.text.split()[0] for x in result)
    return result, {"name": name, "units": len(source), "elapsed": time.monotonic()-start,
                    "model_cycles_NOT_measured": solver.result.cycles,
                    "input": [x.text for x in source], "output": [x.text for x in result],
                    "assembly_input": arch.decode(source), "assembly_output": arch.decode(result),
                    "register_version_and_memory_trace_equal": True}

def optimize(source, name, timeout):
    # Bounded overlapping windows; every boundary preserves all live registers.
    code, reports = list(source), []
    width = 48
    for start in range(0, len(code), width):
        stop = min(start + width, len(code))
        chunk, report = solve(code[start:stop], name + "_" + str(start), timeout)
        code[start:stop] = chunk
        reports.append(report)
    assert semantic_trace(source) == semantic_trace(code)
    return code, reports

def asm(source):
    return "".join("\t" + s + "\n" for s in arch.decode(source))

def source_sections(s):
    # Function sections permit fixed-address measurement with normal linking.
    # They do not import code or change instructions in the implementation.
    s = s.replace("\t.global fndsa_mp_NTT\n", '\t.section .text.rns_ntt,"ax",%progbits\n\t.global fndsa_mp_NTT\n')
    s = s.replace("\t.global fndsa_mp_iNTT\n", '\t.section .text.rns_intt,"ax",%progbits\n\t.global fndsa_mp_iNTT\n')
    s = s.replace("\t.type fndsa_mp_NTT_small, %function", '\t.section .text.rns_small,"ax",%progbits\n\t.type fndsa_mp_NTT_small, %function')
    # ADR cannot cross sections. A local copy of the same public stride vector.
    forward, rest = s.split('\t.section .text.rns_intt,', 1)
    forward = forward.replace(".Lmp31_stride8", ".Lslothy_ntt_stride8")
    forward += "\n\t.p2align 2\n.Lslothy_ntt_stride8:\n\t.word 0, 8, 16, 24\n"
    return forward + '\t.section .text.rns_intt,' + rest

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--timeout", type=float, default=10)
    parser.add_argument("--only")
    args = parser.parse_args()
    logs = ROOT / "tooling/logs"
    logs.mkdir(exist_ok=True)
    logging.basicConfig(filename=logs / "solver.log", level=logging.INFO)
    original = (ROOT / "baseline/kgen_mp31_cm55.s").read_text()
    # Store pristine baseline once; subsequent runs always derive from it.
    pristine = logs / "baseline_original.s"
    if pristine.exists():
        original = pristine.read_text()
    else:
        pristine.write_text(original)
    defs = macros(original)
    outa, outb = original, original
    reports = []
    for name, kind, reg, step in REGIONS:
        if args.only and name != args.only:
            continue
        label = ".L" + name
        endlabel = ".Lintt_final_two_loop" if kind == "local" else label
        end = (r"\tcmp\s+r9, lr\n\tbne\s+" + re.escape(endlabel) + r"\n"
               if kind in ("pointer", "local") else
               r"\tsubs\s+" + reg + ", " + reg + ", #" + str(step) + r"\n\tbne\s+" + re.escape(label) + r"\n")
        m = re.search(r"^" + re.escape(label) + r":\n(.*?)(" + end + ")", original, re.M | re.S)
        assert m, name
        inp = arch.encode(expand(m[1], defs))
        print("SOLVE", name, len(inp), flush=True)
        a, ar = optimize(inp, name + "_A", args.timeout)
        outa = outa.replace(m[0], label + ":\n\t/* Slothy A: fixed arithmetic, local schedule. */\n" + asm(a) + m[2], 1)
        rec = {"region": name, "kind": kind, "A": ar, "A_input": [x.text for x in inp], "A_output": [x.text for x in a]}
        if kind == "local":
            replacement = label + ":\n" + asm(a) + m[2]
            rec["B_policy"] = "A only: shared logn=4 entry into final scaling body"
        else:
            cut = len(a) // 2
            pre, post = a[:cut], a[cut:]
            b, br = optimize(post + pre, name + "_B", args.timeout)
            # Check halving for N=1,2,3 including loop-carried values and memory.
            for n in (1, 2, 3):
                assert semantic_trace(a*n) == semantic_trace(pre + b*(n-1) + post)
            entry, kernel, tail = label, label + "_slothy_kernel", label + "_slothy_tail"
            prefix, suffix = "", ""
            if kind == "pointer":
                # Compare after the early half. r9 advances exactly once/tile.
                early_advances = sum("r9" in arch.Instruction.parser(x)[0].args_in_out for x in pre)
                assert early_advances in (0, 1)
                if not early_advances:
                    prefix, suffix = "\tsub.w lr, lr, #16\n", "\tadd.w lr, lr, #16\n"
                compare = "\tcmp r9, lr\n"
                loopend = compare + "\tbne " + kernel + "\n"
            else:
                prefix = f"\tsub.w {reg}, {reg}, #{step}\n"
                compare = f"\tcmp {reg}, #0\n"
                loopend = f"\tsubs {reg}, {reg}, #{step}\n\tbne {kernel}\n"
                # Counter is not part of the arithmetic body.
                assert all(reg not in arch.Instruction.parser(x)[0].spec["touched"] for x in inp)
            replacement = (entry + ":\n\t/* Slothy B: guarded a;(b;a)^(N-1);b, N >= 1. */\n"
                           + prefix + asm(pre) + compare + "\tbeq.w " + tail + "\n"
                           + kernel + ":\n" + asm(b) + loopend + tail + ":\n" + asm(post) + suffix)
            rec.update(B=br, B_pre=[x.text for x in pre], B_post=[x.text for x in post],
                       B_kernel=[x.text for x in b], halving_N_1_2_3_trace_equal=True)
        outb = outb.replace(m[0], replacement, 1)
        reports.append(rec)
        (logs / (name + ".json")).write_text(json.dumps(rec, indent=2) + "\n")
        print("DONE", name, flush=True)
    for variant, s in [("baseline", original), ("slothyA", outa), ("slothyB", outb)]:
        if variant != "baseline":
            s = s.replace("or Slothy scheduling.", "or arithmetic changes from Slothy. This file includes Slothy " + variant[-1] + " scheduling.")
        s = source_sections(s)
        (ROOT / variant / "kgen_mp31_cm55.s").write_text(s)
    (logs / "manifest.json").write_text(json.dumps({"baseline_sha256":hashlib.sha256(original.encode()).hexdigest(),
        "slothy_commit":"55983e6760e98aece5359055085a7def96c688b7", "reports":reports, "specs":arch.SPECS,
        "scope_only":args.only, "memory_policy":"serialized; no address fixups or speculative reads"}, indent=2)+"\n")

if __name__ == "__main__":
    main()
