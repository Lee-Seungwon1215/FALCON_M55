#!/usr/bin/env python3
"""Independent 32-bit instruction emulator for generated scheduling regions.

No Slothy imports and no adapter dependency model. Exact word memory traces,
register values, predicates and write-back are checked. Not a formal ISA proof.
"""
import copy
import hashlib
import json
from pathlib import Path
import random
import re

ROOT = Path(__file__).resolve().parents[1]
MASK = (1 << 32) - 1

def signed(x):
    return (x & MASK) - (1 << 32) if x & (1 << 31) else x & MASK

def execute(lines, state):
    state = copy.deepcopy(state)
    regs, mem = state["regs"], state["mem"]
    trace, pred = [], None
    def scalar(s):
        if s == "zr": return 0
        if s.startswith("#"): return int(s[1:], 0)
        return regs[s]
    def vector(s):
        val = scalar(s)
        return val[:] if isinstance(val, list) else [val & MASK]*4
    def read(addr):
        addr &= MASK
        trace.append(("r", addr))
        return mem.get(addr, ((addr*2654435761) ^ state["seed"]) % regs["r3"])
    def write(addr, value):
        addr &= MASK
        trace.append(("w", addr))
        mem[addr] = value & MASK
    def addresses(s):
        m = re.fullmatch(r"\[(r\d+)(?:,\s*(#[0-9]+|q[0-7]))?\](?:,\s*#([0-9]+))?", s)
        assert m, s
        base = regs[m[1]]
        offset = m[2]
        loc = [base+x for x in regs[offset]] if offset and offset.startswith("q") else [base+int((offset or "#0")[1:], 0)+4*k for k in range(4)]
        if m[3]: regs[m[1]] = (base + int(m[3])) & MASK
        return loc
    i = 0
    while i < len(lines):
        line = lines[i]
        op, _, arg = line.partition(" ")
        args = [x.strip() for x in arg.split(",")]
        i += 1
        if op.startswith(("vld40", "vst40")):
            m = re.fullmatch(r"\{\s*([^}]+)\},\s*\[(r\d+)\]", arg)
            assert m, line
            qs = [x.strip() for x in m[1].split(",")]
            base = regs[m[2]]
            assert all(lines[i-1+j].startswith(op[:4]+str(j)+".") for j in range(4))
            if op.startswith("vld"):
                data = [read(base+4*j) for j in range(16)]
                for j, q in enumerate(qs): regs[q] = data[j::4]
            else:
                for j in range(16): write(base+4*j, regs[qs[j % 4]][j//4])
            i += 3
            continue
        if op.startswith(("vldrw", "vstrw", "ldr")):
            dst, loc = arg.split(",", 1)
            aa = addresses(loc.strip())
            if op.startswith("vld"): regs[dst] = [read(a) for a in aa]
            elif op == "ldr": regs[dst] = read(aa[0])
            else:
                for a, v in zip(aa, regs[dst]): write(a, v)
            continue
        if op in ("add.w", "sub.w"):
            a, b = scalar(args[1]), scalar(args[2])
            if len(args) == 4:
                assert args[3].startswith("lsl #")
                b <<= int(args[3][5:])
            regs[args[0]] = (a+b if op == "add.w" else a-b) & MASK
            continue
        if op.startswith("adr"):
            addr = 0x800000 + int(hashlib.sha256(args[1].encode()).hexdigest()[:5], 16)*16
            regs[args[0]] = addr
            for k in range(4): mem[addr+4*k] = k*8
            continue
        if op == "vpt.s32":
            assert args[0] == "LT"
            pred = [signed(a) < signed(b) for a,b in zip(vector(args[1]),vector(args[2]))]
            continue
        if op in ("vmov", "vdup.32"):
            regs[args[0]] = vector(args[1])
            continue
        a,b = vector(args[1]),vector(args[2])
        if op in ("vadd.i32", "vaddt.i32"): out = [x+y for x,y in zip(a,b)]
        elif op == "vsub.i32": out = [x-y for x,y in zip(a,b)]
        elif op == "vmul.u32": out = [x*y for x,y in zip(a,b)]
        elif op == "vqrdmulh.s32": out = [max(-(1<<31),min((1<<31)-1,(signed(x)*signed(y)+(1<<30))>>31)) for x,y in zip(a,b)]
        elif op == "vhadd.s32": out = [(signed(x)+signed(y))>>1 for x,y in zip(a,b)]
        else: raise ValueError(line)
        if op == "vaddt.i32":
            assert pred is not None
            out = [x if yes else y for x,y,yes in zip(out,regs[args[0]],pred)]
            pred = None
        regs[args[0]] = [x & MASK for x in out]
    return state, trace

def main():
    manifest = json.loads((ROOT/"tooling/logs/manifest.json").read_text())
    assert manifest["scope_only"] is None
    def decode(rows):
        out = []
        for row in rows:
            key,args = row.split(" ",1)
            spec = manifest["specs"][key]
            mapping = dict(zip(spec["order"], [x.strip() for x in args.split(",")]))
            for line in spec["lines"]:
                out.append(re.sub(r"\b(?:q[0-7]|r(?:1[0-4]|[0-9]))\b",lambda m:mapping[m[0]],line))
        return out
    rng = random.Random(0x524e53534c4f5448)
    checks = []
    for rec in manifest["reports"]:
        old, a = decode(rec["A_input"]), decode(rec["A_output"])
        count = 0
        for trial in range(32):
            regs = {f"r{k}":0x100000+k*0x1000 for k in range(15)}
            regs.update({"r2":0x400000,"r8":0x400100,"r3":2147473409,"r4":2042615807})
            regs.update({f"q{k}":[rng.randrange(1<<32) for _ in range(4)] for k in range(8)})
            initial = {"regs":regs,"mem":{},"seed":rng.randrange(1<<32)}
            for n in (1,2,3,7):
                ref = execute(old*n,initial)
                assert execute(a*n,initial) == ref, (rec["region"],"A",trial,n)
                count += 1
                if "B_kernel" in rec:
                    code = decode(rec["B_pre"])+decode(rec["B_kernel"])*(n-1)+decode(rec["B_post"])
                    assert execute(code,initial) == ref, (rec["region"],"B",trial,n)
                    count += 1
        checks.append({"region":rec["region"],"exact_state_and_ordered_memory_checks":count})
    result = {"status":"PASS","checks":checks,"total":sum(x["exact_state_and_ordered_memory_checks"] for x in checks),
              "limitation":"Independent executable regression model, not a formal ISA or constant-time proof."}
    (ROOT/"tooling/logs/independent_check.json").write_text(json.dumps(result,indent=2)+"\n")
    print(json.dumps(result,indent=2))

if __name__ == "__main__": main()
