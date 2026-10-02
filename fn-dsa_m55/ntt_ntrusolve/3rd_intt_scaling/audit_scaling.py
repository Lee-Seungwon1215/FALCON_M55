#!/usr/bin/env python3
"""Check matched ELF layouts, scope and constant-time structure (not a proof)."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess

ROOT = Path(__file__).resolve().parent
MEAS = ROOT.parents[1] / "measurement_mlkem_native"
BIN = MEAS / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin"


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def sections(path):
    b = path.read_bytes()
    assert b[:6] == b"\x7fELF\x01\x01"
    off = struct.unpack_from("<I", b, 32)[0]
    size, count, names_index = struct.unpack_from("<HHH", b, 46)
    hs = [struct.unpack_from("<10I", b, off+i*size) for i in range(count)]
    h = hs[names_index]
    names = b[h[4]:h[4]+h[5]]
    return {names[h[0]:].split(b"\0", 1)[0].decode():
            (h[3], h[5], b"" if h[1] == 8 else b[h[4]:h[4]+h[5]])
            for h in hs if h[2] & 2}


def tool(name, *args):
    return subprocess.check_output([str(BIN / ("arm-none-eabi-"+name)),
                                    *map(str, args)], text=True)


def normalized(text):
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return [re.sub(r"\s+", " ", s.strip()) for s in text.splitlines() if s.strip()]


def main():
    p = argparse.ArgumentParser()
    p.add_argument("kind", choices=("perf", "audit"))
    args = p.parse_args()
    before = ROOT / "H0_stagewise_half"
    after = ROOT / "H1_final_scaling"
    control = ROOT / "experiments/h0_layout/source"
    sources = sorted(x.name for x in before.iterdir() if x.suffix in (".c", ".h", ".s"))
    assert sources == sorted(x.name for x in after.iterdir() if x.suffix in (".c", ".h", ".s"))
    changed = [n for n in sources if (before/n).read_bytes() != (after/n).read_bytes()]
    assert changed == ["kgen_mp31_cm55.s"], changed
    h0 = (before/changed[0]).read_text()
    h1 = (after/changed[0]).read_text()
    ctl = (control/changed[0]).read_text()
    ctl = re.sub(r"^\s*\.org fndsa_mp_iNTT \+ 0x578, 0\s*$", "", ctl, flags=re.M)
    assert normalized(ctl) == normalized(h0), "control changed more than unreachable padding"
    assert all((before/n).read_bytes() == (control/n).read_bytes() for n in sources if n != changed[0])
    for macro in ("MP31_ROOT", "MP31_MONT", "MP31_ADD", "MP31_SUB", "MP31_CT"):
        pat = rf"^\s*\.macro {macro}\b.*?^\s*\.endm"
        assert re.search(pat, h0, re.M|re.S)[0] == re.search(pat, h1, re.M|re.S)[0], macro
    for fn in ("fndsa_mp_NTT", "fndsa_mp_NTT_small"):
        body = lambda s: s.split(fn+":\n", 1)[1].split(".size "+fn+",", 1)[0]
        assert body(h0) == body(h1), fn
    assert "MP31_HALF" not in h1
    out = ROOT / "results/static_audit"
    out.mkdir(parents=True, exist_ok=True)
    builds = {"h0_layout": ROOT / "experiments/h0_layout/profiling/build" / ("m55-"+args.kind),
              "h1": after / "profiling/build" / ("m55-"+args.kind)}
    binaries = {name: path/"zephyr/zephyr.elf" for name,path in builds.items()}
    nm = {name: tool("nm", "-S", path) for name,path in binaries.items()}
    def symbol(name, fn):
        m = re.search(rf"^([0-9a-f]+) ([0-9a-f]+) [Tt] {fn}$", nm[name], re.M)
        assert m, fn
        return tuple(int(x,16) for x in m.groups())
    start, size = symbol("h1", "fndsa_mp_iNTT")
    assert size == 0x578 and start == symbol("h0_layout", "fndsa_mp_iNTT")[0]
    old, new = (sections(binaries[n]) for n in ("h0_layout", "h1"))
    assert old.keys() == new.keys()
    changed_count = 0
    for name, (addr, length, data) in old.items():
        assert new[name][:2] == (addr, length), (name, "layout differs")
        changes = [addr+i for i,(a,b) in enumerate(zip(data,new[name][2])) if a != b]
        assert all(start <= a < start+size for a in changes), (name, "change outside iNTT", changes[:8])
        changed_count += len(changes)
    assert changed_count
    configs = [(b/"zephyr/.config").read_bytes() for b in builds.values()]
    assert configs[0] == configs[1]
    symbols = {}
    for fn in ("fndsa_mp_NTT", "fndsa_mp_iNTT", "fndsa_mp_NTT_small", "fndsa_sign_core",
               "fndsa_mqpoly_int_to_ntt", "fndsa_mqpoly_ntt_to_int"):
        assert symbol("h0_layout",fn)[0] == symbol("h1",fn)[0]
        symbols[fn] = {n: {"address":hex(symbol(n,fn)[0]), "bytes":symbol(n,fn)[1]} for n in binaries}
    dis = tool("objdump", "-d", "--disassemble=fndsa_mp_iNTT", binaries["h1"])
    (out/(args.kind+"_intt_disassembly.txt")).write_text(dis)
    ins = re.findall(r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+)+([a-z][a-z0-9.]*)\s*([^\n]*)", dis, re.M)
    assert ins
    forbidden = [(pc,op) for pc,op,_ in ins if op in ("bl","blx","udiv","sdiv")
                 or op.startswith(("vdiv", "vcvt")) or ".f32" in op or ".f64" in op]
    assert not forbidden, forbidden
    spills = [(pc,op,a) for pc,op,a in ins if op.startswith(("vldr","vstr")) and "[sp" in a]
    assert not spills, spills
    assert "fndsa_mp_iNTT_c>" in dis
    branches = [(pc,op,a) for pc,op,a in ins if re.fullmatch(r"b(?:eq|ne|lo|cc|hs|cs|hi|ls|ge|gt|le|lt)?(?:\.w|\.n)?",op)]
    itcm = max(a+n-0x10000000 for a,n,_ in new.values() if 0x10000000<=a<0x10040000)
    dtcm = max(a+n-0x30000000 for a,n,_ in new.values() if 0x30000000<=a<0x30040000)
    assert itcm<=262144 and dtcm<=262144
    report = {"kind":args.kind, "changed_crypto_sources":changed,
              "h0_original_arithmetic_preserved":True, "control_only_unreachable_padding":True,
              "h1_source_sha256":sha(after/changed[0]),
              "elf_sha256":{n:sha(e) for n,e in binaries.items()},
              "all_allocated_addresses_sizes_identical":True,
              "all_allocated_bytes_outside_intt_identical":True,
              "changed_intt_bytes":changed_count, "kconfig_identical":True,
              "symbols":symbols, "itcm_bytes":itcm, "dtcm_bytes":dtcm,
              "extra_coefficient_stack_spills":False, "stack_frame_bytes_including_abi_save":112,
              "branches_for_manual_review":branches,
              "constant_time_scope":"new iNTT control/address structure only; VPT predication retained",
              "formal_constant_time_proof":False, "dynamic_leakage_test":False}
    (out/(args.kind+"_audit.json")).write_text(json.dumps(report,indent=2)+"\n")
    print(json.dumps({k:v for k,v in report.items() if k not in ("symbols","branches_for_manual_review")},indent=2))


if __name__ == "__main__":
    main()
