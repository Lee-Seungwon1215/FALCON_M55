#!/usr/bin/env python3
"""Differential instruction-model checks for the revised combination macros.

Models only the integer MVE/GPR instructions in the checked straight-line
macros. This is a deterministic regression check, not a formal ISA proof or
a substitute for the hardware oracle/KAT. Unsupported instructions fail closed.
"""
import copy
import hashlib
import json
from pathlib import Path
import random
import re
import tarfile

ROOT = Path(__file__).resolve().parent / "combinations"
Q = 12289


def macros(source):
    result = {}
    for name, arguments, body in re.findall(
            r"\t\.macro\t(\w+)\s*([^\n]*)\n(.*?)\t\.endm", source, re.S):
        result[name] = ([x.strip() for x in arguments.split(",")], body)
    return result


def expand(defs, name, arguments):
    parameters, body = defs[name]
    assert len(parameters) == len(arguments), (name, parameters, arguments)
    for key, value in zip(parameters, arguments):
        body = re.sub(r"\\" + key + r"\b", lambda _: value, body)
    out = []
    for line in body.splitlines():
        line = line.split("@", 1)[0].strip()
        if not line:
            continue
        op, _, rest = line.partition("\t")
        if op in defs:
            out += expand(defs, op, [x.strip() for x in rest.split(",")])
        else:
            out.append(line)
    return out


def signed(x, bits=16):
    x &= (1 << bits) - 1
    return x - (1 << bits) if x >> (bits - 1) else x


def execute(code, state):
    state = copy.deepcopy(state)
    regs, mem = state["regs"], state["mem"]
    mask = [True] * 8
    pred = False
    reads, writes = [], []

    def scalar(x):
        return int(x[1:], 0) if x.startswith("#") else regs[x]

    def vec(x):
        if x == "zr":
            return [0] * 8
        v = scalar(x)
        return v if isinstance(v, list) else [v & 65535] * 8

    for line in code:
        op, arg = line.split(None, 1) if "\t" in line else (line, "")
        args = [x.strip() for x in arg.split(",")]
        if op.startswith(("vldrh", "vstrh")):
            m = re.fullmatch(r"(q\d), \[(r\d+)(?:, #(\d+))?\]", arg)
            assert m, line
            qreg, base, offset = m.groups()
            addr = regs[base] + int(offset or 0)
            addresses = [addr + 2 * k for k in range(8)]
            if op.startswith("vldrh"):
                regs[qreg] = [mem[a] for a in addresses]
                reads += addresses
            else:
                for a, v in zip(addresses, regs[qreg]):
                    mem[a] = v
                writes += addresses
            continue
        if op == "add.w":
            regs[args[0]] = (scalar(args[1]) + scalar(args[2])) & 0xffffffff
            continue
        if op == "asr.w":
            regs[args[0]] = (signed(scalar(args[1]), 32) >> scalar(args[2])) & 0xffffffff
            continue
        if op.startswith("vcmp"):
            cond, a, b = args
            if op == "vcmp.s16":
                mask = [signed(x) < signed(y) for x, y in zip(vec(a), vec(b))]
                assert cond == "lt"
            else:
                assert cond == "ne"
                mask = [x != y for x, y in zip(vec(a), vec(b))]
            continue
        if op == "vpst":
            assert not pred
            pred = True
            continue
        dst = args[0]
        if op in ("vmov", "vmov.i16", "vdup.16"):
            values = list(vec(args[1]))
        elif op in ("vadd.i16", "vaddt.i16", "vsub.i16", "vmul.i16", "vmla.i16", "vand", "vshr.u16", "vqrdmulh.s16"):
            a, b = vec(args[1]), vec(args[2])
            if op.startswith("vadd"):
                values = [x + y for x, y in zip(a, b)]
            elif op == "vsub.i16":
                values = [x - y for x, y in zip(a, b)]
            elif op == "vmul.i16":
                values = [x * y for x, y in zip(a, b)]
            elif op == "vmla.i16":
                values = [z + x * y for z, x, y in zip(vec(dst), a, b)]
            elif op == "vand":
                values = [x & y for x, y in zip(a, b)]
            elif op == "vshr.u16":
                values = [x >> y for x, y in zip(a, b)]
            else:
                values = [max(-32768, min(32767, (signed(x) * signed(y) + 16384) >> 15))
                          for x, y in zip(a, b)]
        else:
            raise AssertionError(("unsupported instruction", line))
        values = [v & 65535 for v in values]
        if op == "vaddt.i16":
            assert pred
            values = [v if enabled else old for v, enabled, old in zip(values, mask, vec(dst))]
            pred = False
        else:
            assert not pred, ("instruction inside unmodeled predicate block", line)
        regs[dst] = values
    assert not pred
    state.update(reads=reads, writes=writes)
    return state


def tables():
    source = (ROOT / "S1A_S2A_S3A" / "mq.c").read_text()
    out = []
    for stem in ("GM", "iGM"):
        arrays = []
        for suffix in ("", "_twist"):
            contents = re.search(r"fndsa_mq_barrett3_" + stem + suffix + r"\[1024\] = \{(.*?)\};", source, re.S)[1]
            arrays.append([int(x) for x in re.findall(r"-?\d+", contents)])
        out.extend(zip(*arrays))
    assert len(out) == 2048
    return out


def main():
    rng = random.Random(0x53434f4d)
    pairs = tables()
    def initial(index):
        boundary = (0, 1, Q - 1, Q, 2, Q - 2)
        def lane():
            return boundary[index % len(boundary)] if index < 6 else rng.randrange(Q + 1)
        regs = {f"r{i}": 0 for i in range(15)}
        regs.update({f"q{i}": [lane() for _ in range(8)] for i in range(8)})
        regs.update(r1=4096, r4=64, r10=Q)
        for r in ("r5", "r6", "r7"):
            root, twist = pairs[rng.randrange(len(pairs))]
            regs[r] = (root & 65535) | ((twist & 65535) << 16)
        mem = {4096 + stream * 64 + offset: lane()
               for stream in range(4) for offset in range(0, 32, 2)}
        return dict(regs=regs, mem=mem)

    results = []
    with tarfile.open(ROOT / "revision_before/sources-v1.tar.gz") as archive:
        for s1 in "AB":
            for s2 in "AB":
                name = f"S1{s1}_S2{s2}_S3C"
                old = archive.extractfile(name + "/mq_cm55.s").read().decode()
                current = (ROOT / name / "mq_cm55.s").read_text()
                before, after = macros(old), macros(current)
                for kind in ("CT2", "F2", "GS2", "GS2_WIDE"):
                    call = "MQ_S3C_" + kind + "_STEADY"
                    args = ["r5", "r6", "r7", "r4"]
                    old_code, new_code = expand(before, call, args), expand(after, call, args)
                    for i in range(128):
                        state = initial(i)
                        a, b = execute(old_code, state), execute(new_code, state)
                        assert a["mem"] == b["mem"], (name, call, i, "memory")
                        for reg in ("q0", "q1", "q2", "q3", "q4", "r1"):
                            assert a["regs"][reg] == b["regs"][reg], (name, call, i, reg)
                        assert sorted(a["reads"]) == sorted(b["reads"])
                        assert a["writes"] == b["writes"]
                    results.append(dict(candidate=name, macro=call, cases=128))
                    # Whole abstract stream group: independent BODY loop vs
                    # prologue + (n-1) STEADY calls + load-free BODY epilogue.
                    # The memory dictionary contains no padding, so any
                    # successor read beyond the last chunk fails immediately.
                    body = "MQ_S3C_" + kind + "_BODY"
                    original_body = expand(before, body, args[:3])
                    final_body = expand(after, body, args[:3])
                    for chunks in (1, 2, 3, 4, 8, 16, 32):
                        state = initial(20)
                        stride = 16 * chunks
                        state["regs"]["r4"] = stride
                        state["mem"] = {4096 + stream * stride + offset: rng.randrange(Q + 1)
                                        for stream in range(4) for offset in range(0, stride, 2)}
                        reference, pipeline = copy.deepcopy(state), copy.deepcopy(state)
                        def load_chunk(st, chunk):
                            for stream in range(4):
                                address = 4096 + stream * stride + 16 * chunk
                                st["regs"][f"q{stream + 1}"] = [st["mem"][address + 2 * j] for j in range(8)]
                        def store_chunk(st, chunk):
                            for stream in range(4):
                                address = 4096 + stream * stride + 16 * chunk
                                for j, value in enumerate(st["regs"][f"q{stream + 1}"]):
                                    st["mem"][address + 2 * j] = value
                        for chunk in range(chunks):
                            load_chunk(reference, chunk)
                            reference = execute(original_body, reference)
                            store_chunk(reference, chunk)
                        load_chunk(pipeline, 0)
                        for _ in range(chunks - 1):
                            pipeline = execute(new_code, pipeline)
                        assert pipeline["regs"]["r1"] == 4096 + 16 * (chunks - 1)
                        pipeline = execute(final_body, pipeline)
                        store_chunk(pipeline, chunks - 1)
                        assert pipeline["mem"] == reference["mem"], (name, kind, chunks, "full group")
                    results.append(dict(candidate=name, macro=call + ":full_group", cases=7))
        for s1 in "AB":
            name = f"S1{s1}_S2B_S3B"
            current = (ROOT / name / "mq_cm55.s").read_text()
            defs = macros(current)
            call = "MQ3_MVE_CT_MUL2_CROSS_LAYER"
            for s3 in "AC":
                other = macros((ROOT / f"S1{s1}_S2B_S3{s3}" / "mq_cm55.s").read_text())
                assert other[call] == defs[call], (name, s3, "shared revised macro")
            for i, (root0, twist0) in enumerate(pairs):
                state = initial(i)
                root1, twist1 = pairs[(i * 17 + 7) % len(pairs)]
                state["regs"]["r5"] = (root0 & 65535) | ((twist0 & 65535) << 16)
                state["regs"]["r6"] = (root1 & 65535) | ((twist1 & 65535) << 16)
                for left, right in (("q2", "q4"), ("q3", "q7")):
                    code = expand(defs, call, [left, right, "q5", "q6", "r5", "r6"])
                    out = execute(code, state)
                    expected_a, expected_b = [], []
                    for a, b in zip(state["regs"][left], state["regs"][right]):
                        expected_a.append(((a + b) % Q * root0) % Q)
                        expected_b.append(((a - b) % Q * root1) % Q)
                    assert out["regs"][left] == expected_a, (name, i, left)
                    assert out["regs"][right] == expected_b, (name, i, right)
                    for reg in (set(f"q{i}" for i in range(8)) - {left, right, "q5", "q6"}):
                        assert out["regs"][reg] == state["regs"][reg], (name, i, "clobber", reg)
            results.append(dict(candidate=name, macro=call, cases=4096))
    checked = sorted({r["candidate"] for r in results} |
                     {f"S1{s1}_S2B_S3{s3}" for s1 in "AB" for s3 in "AC"})
    hashes = {name: hashlib.sha256((ROOT / name / "mq_cm55.s").read_bytes()).hexdigest()
              for name in checked}
    report = dict(valid=True, checks=results, source_sha256=hashes,
                  model_cases=sum(r["cases"] for r in results),
                  limitations="Instruction-model regression, not formal proof or hardware timing verification.")
    out = ROOT / "results/revision_model.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
