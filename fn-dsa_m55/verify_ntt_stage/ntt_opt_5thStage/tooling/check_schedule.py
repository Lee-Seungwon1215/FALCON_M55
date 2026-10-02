#!/usr/bin/env python3
"""Independent integer instruction interpreter for schedule regression checks.

This does not import the SLOTHY adapter or its dependency model. It checks the
expanded assembly, including D/Q aliasing, exact memory access sequence, and
halving prologue/epilogue at several trip counts. Not a formal ISA proof.
"""
import copy
import hashlib
import json
from pathlib import Path
import random
import re

ROOT = Path(__file__).resolve().parents[1]
Q = 12289


def signed(x, bits=16):
    x &= (1 << bits) - 1
    return x - (1 << bits) if x & (1 << (bits - 1)) else x


def execute(code, initial):
    st = copy.deepcopy(initial)
    regs, mem = st["regs"], st["mem"]
    trace, predicate = [], None

    def scalar(s):
        return int(s[1:], 0) if s.startswith("#") else regs[s]

    def vec(s):
        if s == "zr": return [0] * 8
        v = scalar(s)
        return list(v) if isinstance(v, list) else [v & 65535] * 8

    def address(s):
        m = re.fullmatch(r"\[(r\d+)(?:, #(-?\d+))?\]", s)
        assert m, s
        return (regs[m[1]] + int(m[2] or 0)) & 0xffffffff

    def read(addr):
        # Reproducible, address-dependent canonical coefficient/constant stream.
        trace.append(("r", addr))
        return mem.get(addr, ((addr * 2654435761 + st["seed"]) ^ (addr >> 7)) % Q)

    def write(addr, val):
        trace.append(("w", addr))
        mem[addr] = val & 65535

    def set_half(d, values):
        n = int(d[1:])
        reg, at = f"q{n // 2}", (n % 2) * 4
        regs[reg][at:at+4] = values

    i = 0
    while i < len(code):
        line = code[i]
        op, _, arg = line.partition(" ")
        args = [x.strip() for x in arg.split(",")]
        i += 1
        if op.startswith(("vld40.", "vst40.", "vld20.")):
            width = 2 if op.startswith("vld20.") else 4
            m = re.fullmatch(r"\{ (.*?) \}, (\[.*\])", arg)
            assert m, line
            qq = [x.strip() for x in m[1].split(",")]
            assert len(qq) == width
            addr = address(m[2])
            assert all(code[i-1+k].startswith(op[:4] + str(k) + ".") for k in range(width))
            if op.startswith("vld"):
                data = [read(addr + 2*k) for k in range(8*width)]
                for k, r in enumerate(qq): regs[r] = data[k::width]
            else:
                for k in range(8*width): write(addr + 2*k, regs[qq[k % width]][k // width])
            i += width - 1
            continue
        if op.startswith(("vldrh", "vstrh", "vldr", "vstr", "ldrh")):
            dst, _, loc = arg.partition(", ")
            addr = address(loc)
            n = 8 if op.startswith(("vldrh", "vstrh")) else 4
            if op == "ldrh":
                regs[dst] = read(addr)
            elif op.startswith("vld"):
                values = [read(addr + 2*k) for k in range(n)]
                if dst.startswith("d"): set_half(dst, values)
                else: regs[dst] = values
            else:
                if dst.startswith("d"):
                    d = int(dst[1:]); values = regs[f"q{d // 2}"][(d % 2)*4:(d % 2)*4+4]
                else: values = regs[dst]
                for k, v in enumerate(values): write(addr + 2*k, v)
            continue
        if op in {"add.w", "sub.w", "asr.w", "orr", "orr.w", "uxth", "mov", "mov.w"}:
            dst = args[0]
            if op == "uxth": value = scalar(args[1]) & 65535
            elif op.startswith("mov"): value = scalar(args[1])
            elif op == "asr.w": value = signed(scalar(args[1]), 32) >> scalar(args[2])
            else:
                a, b = scalar(args[1]), scalar(args[2])
                if len(args) == 4:
                    shift, amt = args[3].split()
                    assert shift == "lsl"
                    b <<= scalar(amt)
                if op.startswith("add"): value = a + b
                elif op.startswith("sub"): value = a - b
                else: value = a | b
            regs[dst] = value & 0xffffffff
            continue
        if op.startswith("vcmp"):
            cond, a, b = args
            if cond == "lt": predicate = [signed(x) < signed(y) for x, y in zip(vec(a), vec(b))]
            elif cond == "ne": predicate = [x != y for x, y in zip(vec(a), vec(b))]
            else: raise AssertionError(line)
            assert code[i] == "vpst" and code[i+1].startswith("vaddt.")
            continue
        if op == "vpst":
            assert predicate is not None
            continue
        dst = args[0]
        if op == "vmov" and dst.startswith("d"):
            a, b = scalar(args[1]), scalar(args[2])
            set_half(dst, [a & 65535, a >> 16, b & 65535, b >> 16])
            continue
        if op in {"vmov", "vmov.i16", "vdup.16"}: values = vec(args[1])
        else:
            a, b = vec(args[1]), vec(args[2])
            if op in {"vadd.i16", "vaddt.i16"}: values = [x+y for x,y in zip(a,b)]
            elif op == "vsub.i16": values = [x-y for x,y in zip(a,b)]
            elif op == "vmul.i16": values = [x*y for x,y in zip(a,b)]
            elif op == "vmla.i16": values = [z+x*y for x,y,z in zip(a,b,regs[dst])]
            elif op == "vand": values = [x&y for x,y in zip(a,b)]
            elif op == "vshr.u16": values = [x >> y for x,y in zip(a,b)]
            elif op == "vqrdmulh.s16":
                values = [max(-32768, min(32767, (signed(x)*signed(y)+(1<<14)) >> 15)) for x,y in zip(a,b)]
            else: raise AssertionError(f"Unsupported instruction: {line}")
        if op == "vaddt.i16":
            values = [v if yes else old for v,yes,old in zip(values,predicate,regs[dst])]
            predicate = None
        regs[dst] = [v & 65535 for v in values]
    return st, trace


def main():
    manifest = json.loads((ROOT / "tooling/logs/manifest.json").read_text())
    assert not manifest["diagnostic_only"], "Full generation required"
    rng = random.Random(0x5A10_512_1024)
    reports = manifest["reports"]
    total = 0
    result = []
    for ra in reports:
        if not ra["label"].endswith("_A"): continue
        name = ra["label"][:-2]
        rb = next((r for r in reports if r["label"] == name + "_B_seam"), None)
        tests = 0
        for trial in range(24):
            regs = {f"r{k}": 0x20000000 + k * 0x10000 + 2*rng.randrange(1024) for k in range(15)}
            regs["r10"] = Q
            regs.update({f"q{k}": [rng.randrange(65536) for _ in range(8)] for k in range(8)})
            state = dict(regs=regs, mem={}, seed=rng.randrange(1 << 32))
            for n in ([2, 3, 16, 32] if rb else [1]):
                expected = execute(ra["assembly_in"] * n, state)
                actual = execute(ra["assembly_out"] * n, state)
                if expected != actual:
                    differences = {k: (expected[0]["regs"][k], actual[0]["regs"][k]) for k in regs
                                   if expected[0]["regs"][k] != actual[0]["regs"][k]}
                    first_access = next(((k, a, b) for k,(a,b) in enumerate(zip(expected[1],actual[1])) if a != b), None)
                    raise AssertionError((name, "A", trial, n, differences, "trace", first_access,
                                          "memory_equal", expected[0]["mem"] == actual[0]["mem"]))
                if rb:
                    actual = execute(rb["preamble"] + rb["assembly_out"]*(n-1) + rb["postamble"], state)
                    assert expected == actual, (name, "B", trial, n)
                tests += 1
        total += tests
        result.append(dict(region=name, cases=tests, A="PASS", B="PASS" if rb else "same A"))
        print(f"PASS {name}: {tests} exact state + memory-trace cases", flush=True)
    report = dict(status="PASS", cases=total, regions=result,
                  manifest_sha256=hashlib.sha256((ROOT / "tooling/logs/manifest.json").read_bytes()).hexdigest(),
                  scope="independent interpreter regression; not formal ISA/constant-time proof")
    (ROOT / "tooling/logs/instruction_model.json").write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__": main()
