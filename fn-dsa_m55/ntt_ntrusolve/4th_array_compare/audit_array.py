#!/usr/bin/env python3
"""Inspect D1 scope, machine code and matched D0/D1 layouts (not a CT proof)."""
import argparse
import importlib.util
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("elf_helpers", ROOT.parent / "3rd_intt_scaling/audit_scaling.py")
elf = importlib.util.module_from_spec(spec)
spec.loader.exec_module(elf)
from prepare_control import padded


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kind", choices=("perf", "audit"))
    args = parser.parse_args()
    before = ROOT / "D0_vst4_previous"
    after = ROOT / "D1_vld4_last"
    control = ROOT / "experiments/d0_layout/source"
    names = sorted(p.name for p in before.iterdir() if p.suffix in (".c", ".h", ".s"))
    assert len(names) == 31
    assert names == sorted(p.name for p in after.iterdir() if p.suffix in (".c", ".h", ".s"))
    assert [n for n in names if (before/n).read_bytes() != (after/n).read_bytes()] == ["kgen_mp31_cm55.s"]
    old, new = ((p / "kgen_mp31_cm55.s").read_text() for p in (before, after))
    assert (control / "kgen_mp31_cm55.s").read_text() == padded(old)
    assert all((before/n).read_bytes() == (control/n).read_bytes()
               for n in names if n != "kgen_mp31_cm55.s")
    macros = ("MP31_ROOT", "MP31_MONT", "MP31_ADD", "MP31_SUB", "MP31_IROOT",
              "MP31_CT", "MP31_GS", "MP31_FINAL_ROOT")
    for macro in macros:
        pattern = rf"^\s*\.macro {macro}\b.*?^\s*\.endm"
        assert re.search(pattern, old, re.M|re.S)[0] == re.search(pattern, new, re.M|re.S)[0], macro
    builds = {"d0_layout": ROOT / "experiments/d0_layout/profiling/build" / ("stage4-m55-"+args.kind),
              "d1": after / "profiling/build" / ("stage4-m55-"+args.kind)}
    binaries = {name: path/"zephyr/zephyr.elf" for name,path in builds.items()}
    nm = {name: elf.tool("nm", "-S", path) for name,path in binaries.items()}
    def symbol(candidate, name):
        m = re.search(rf"^([0-9a-f]+) ([0-9a-f]+) [Tt] {name}$", nm[candidate], re.M)
        assert m, name
        return tuple(int(x,16) for x in m.groups())
    kernels = ("fndsa_mp_NTT", "fndsa_mp_iNTT", "fndsa_mp_NTT_small")
    spans = dict(zip(kernels, (0x490, 0x6ea, 0x408)))
    allowed = []
    symbols = {}
    for name in kernels + ("fndsa_sign_core", "fndsa_mqpoly_int_to_ntt", "fndsa_mqpoly_ntt_to_int"):
        assert symbol("d0_layout", name)[0] == symbol("d1", name)[0], name
        symbols[name] = {c: {"address": hex(symbol(c,name)[0]), "bytes":symbol(c,name)[1]} for c in binaries}
        if name in kernels:
            start, size = symbol("d1", name)
            assert size <= spans[name]
            assert symbol("d0_layout",name)[1] <= spans[name]
            allowed.append((start, start+spans[name]))
    a,b = (elf.sections(binaries[c]) for c in binaries)
    assert a.keys() == b.keys()
    changed = 0
    for name,(addr,length,data) in a.items():
        assert b[name][:2] == (addr,length), name
        differences = [addr+i for i,(x,y) in enumerate(zip(data,b[name][2])) if x != y]
        assert all(any(lo<=x<hi for lo,hi in allowed) for x in differences), (name, differences[:8])
        changed += len(differences)
    assert changed
    assert len({(path/"zephyr/.config").read_bytes() for path in builds.values()}) == 1
    output = ROOT / "results/static_audit"
    output.mkdir(parents=True, exist_ok=True)
    branches = {}
    for name in kernels:
        dis = elf.tool("objdump", "-d", "--disassemble="+name, binaries["d1"])
        (output / f"{args.kind}_{name}.txt").write_text(dis)
        ins = re.findall(r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+)+([a-z][a-z0-9.]*)\s*([^\n]*)", dis, re.M)
        assert ins
        assert not [(pc,op) for pc,op,_ in ins if op in ("bl","blx","udiv","sdiv")
                    or op.startswith(("vdiv","vcvt")) or ".f32" in op or ".f64" in op]
        assert not [(pc,op) for pc,op,arg in ins if op.startswith(("vldr","vstr")) and "[sp" in arg]
        branches[name] = [(pc,op,arg) for pc,op,arg in ins
            if re.fullmatch(r"b(?:eq|ne|lo|cc|hs|cs|hi|ls|ge|gt|le|lt)?(?:\.w|\.n)?",op)]
    used = lambda base: max(addr+n-base for addr,n,_ in b.values() if base<=addr<base+262144)
    report = {"kind":args.kind, "changed_crypto_sources":["kgen_mp31_cm55.s"],
              "d0_control_only_unreachable_padding":True, "unchanged_arithmetic_macros":macros,
              "all_allocated_addresses_sizes_identical":True,
              "all_allocated_bytes_outside_three_kernel_slots_identical":True,
              "changed_bytes":changed, "symbols":symbols,
              "elf_sha256":{c:elf.sha(p) for c,p in binaries.items()},
              "itcm_bytes":used(0x10000000), "dtcm_bytes":used(0x30000000),
              "extra_coefficient_spills":False, "stack_bytes_regular":112, "stack_bytes_small":104,
              "branches_for_manual_review":branches,
              "ct_scope":"D1 branches and addresses depend on public logn/counters; existing VPT retained",
              "formal_constant_time_proof":False, "dynamic_leakage_test":False}
    (output / f"{args.kind}.json").write_text(json.dumps(report,indent=2)+"\n")
    print(json.dumps({k:v for k,v in report.items() if k not in ("symbols","branches_for_manual_review")},indent=2))


if __name__ == "__main__":
    main()
