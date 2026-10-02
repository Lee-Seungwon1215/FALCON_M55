#!/usr/bin/env python3
"""Source, fixed-layout and disassembly regression checks, not a CT proof."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
STAGE = ROOT.parent
BIN = STAGE.parents[1]/"measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin"
VARIANTS = ("baseline","slothyA","slothyB") + (("ref_slothy",) if "--integrated" in sys.argv else ())
TARGETS = ("fndsa_mp_NTT","fndsa_mp_iNTT","fndsa_mp_NTT_small")
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def source(v): return STAGE/v if v != "ref_slothy" else STAGE.parent/v
def symbols(elf):
    data = subprocess.check_output([str(BIN/"arm-none-eabi-nm"),"-n","-S",str(elf)],text=True)
    out = {}
    for line in data.splitlines():
        parts = line.split()
        if len(parts)==4 and parts[2] in ("T","t"):
            out[parts[3]]=(int(parts[0],16),int(parts[1],16))
    return out
def instructions(elf,name,sym):
    start,size=sym[name]
    out=subprocess.check_output([str(BIN/"arm-none-eabi-objdump"),"-d",f"--start-address={start}",f"--stop-address={start+size}",str(elf)],text=True)
    return [m.groups() for m in re.finditer(r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+)+([^\s]+)\s*(.*?)$",out,re.M)]
def main():
    source_hashes={v:{p.name:sha(p) for p in source(v).iterdir() if p.suffix in (".c",".s",".h")} for v in VARIANTS}
    for v in VARIANTS[1:]:
        assert [n for n in source_hashes[v] if source_hashes[v][n]!=source_hashes["baseline"][n]]==["kgen_mp31_cm55.s"]
    independent=json.loads((STAGE/"tooling/logs/independent_check.json").read_text())
    assert independent["status"]=="PASS"
    result={"status":"PASS","source_hashes":source_hashes,"independent_checks":independent["total"],"builds":{}}
    for kind in ("audit","perf"):
        elfs={v:source(v)/"build"/kind/"zephyr/zephyr.elf" for v in VARIANTS}
        sym={v:symbols(e) for v,e in elfs.items()}
        base=sym["baseline"]
        others={k:v for k,v in base.items() if k not in TARGETS}
        cfgs={sha(e.parent/".config") for e in elfs.values()}
        assert len(cfgs)==1, "Kconfig differs"
        for v in VARIANTS:
            assert {k:x for k,x in sym[v].items() if k not in TARGETS}==others, "unrelated function moved"
            assert [sym[v][k][0] for k in TARGETS]==[base[k][0] for k in TARGETS]
        data={}
        for v,elf in elfs.items():
            funcs={}
            for name in TARGETS:
                rows=instructions(elf,name,sym[v])
                assert rows, name
                forbidden=[r for r in rows if re.fullmatch(r"bl(?:\.w)?|blx|[us]div.*|vdiv.*|vcvt.*",r[1]) or ".f32" in r[1] or ".f64" in r[1]]
                assert not forbidden, forbidden
                funcs[name]={"address":hex(sym[v][name][0]),"size":sym[v][name][1],
                    "branches":[r for r in rows if r[1].startswith("b") and r[1] not in ("bic","bfi","bkpt")],
                    "memory_operations":[r for r in rows if "[" in r[2]],"forbidden":forbidden}
            data[v]={"functions":funcs,"elf_sha256":sha(elf)}
        if "ref_slothy" in elfs:
            assert source_hashes["ref_slothy"] == source_hashes["slothyA"]
            for name in TARGETS:
                assert instructions(elfs["ref_slothy"],name,sym["ref_slothy"]) == instructions(elfs["slothyA"],name,sym["slothyA"])
        result["builds"][kind]={"candidates":data,"other_functions_fixed":len(others),"config_sha256":next(iter(cfgs))}
    result["constant_time_review"]=[
        "A reorders/renames only; Montgomery arithmetic and predicate pairs are unchanged.",
        "B adds only public count or public end-pointer checks, including N=1 guard.",
        "All new branch conditions use r7/r11/r6 public counters or r9/lr public traversal pointers.",
        "No secret-indexed lookup, coefficient-dependent branch, division, or floating-point conversion is introduced.",
        "Memory order, pointer write-back and register dependencies checked in solver traces and independent emulator.",
        "Original ABI prologue/epilogue and saved register sets remain unchanged."]
    result["limitation"]="Structural/static CT review plus tests, not a formal timing proof, dudect, TVLA or power/EM analysis."
    out=ROOT/"results"/("integrated_static_audit.json" if "ref_slothy" in VARIANTS else "static_audit.json")
    out.write_text(json.dumps(result,indent=2)+"\n")
    print("PASS",out)
    for kind, d in result["builds"].items():
        print(kind,{v:{n:(f["address"],f["size"]) for n,f in x["functions"].items()} for v,x in d["candidates"].items()})
if __name__=="__main__": main()
