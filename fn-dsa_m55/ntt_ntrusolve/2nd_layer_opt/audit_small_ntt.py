#!/usr/bin/env python3
"""Audit small-size control specialization against a layout-matched control."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
from audit_ntt_tuning import sections, BIN, MEAS

ROOT = Path(__file__).resolve().parent

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def normalized(s):
    s = re.sub(r"/\*.*?\*/", "", s, flags=re.S)
    s = re.sub(r"^\s*\.p2align\s+2\s*$", "", s, flags=re.M)
    s = s.replace("adr.w", "adr")
    return [re.sub(r"\s+", " ", x.strip()) for x in s.splitlines() if x.strip()]

def main():
    p = argparse.ArgumentParser()
    p.add_argument("candidate", choices=("l2", "l3", "l2_audit", "l3_audit"))
    p.add_argument("--label", default="small_final")
    p.add_argument("--baseline", default="small_hot_control")
    a = p.parse_args()
    assert re.fullmatch(r"[a-z0-9_-]+", a.label)
    assert re.fullmatch(r"[a-z0-9_-]+", a.baseline)
    base = a.candidate[:2]
    audit = a.candidate.endswith("_audit")
    mode = "pilot" if audit else "full"
    record = ROOT / "experiments" / a.baseline / "results" / a.candidate / (mode+"_validated.json")
    control = Path(json.loads(record.read_text())["run_directory"])
    old = control / "zephyr.elf"
    built = MEAS / ("build-ntru-stage2-"+a.candidate) / "zephyr"
    new = built / "zephyr.elf"
    old_sections, new_sections = sections(old), sections(new)
    assert old_sections.keys() == new_sections.keys()
    def symbol(elf, name):
        nm = subprocess.check_output([str(BIN/"arm-none-eabi-nm"),"--defined-only",str(elf)],text=True)
        return int(re.search(rf"^([0-9a-f]+)\s+\w\s+{name}$",nm,re.M)[1],16)
    small = symbol(new,"fndsa_mp_NTT_small")
    assert small == symbol(old,"fndsa_mp_NTT_small")
    changes = []
    for name, sec in old_sections.items():
        cur = new_sections[name]
        assert sec[:2] == cur[:2], (name, "layout changed")
        changed = [i for i, (x,y) in enumerate(zip(sec[2], cur[2])) if x != y]
        if changed:
            assert name == "text" and sec[0] == 0x10000330
            assert all(i < 6 or small <= sec[0]+i < small+0x2d8 for i in changed), (name, changed[:20])
            changes += [hex(sec[0]+i) for i in changed]
    assert changes, "small route was not activated"
    assert (control/".config").read_bytes() == (built/".config").read_bytes()
    folder = ROOT / ("L2_two_layer" if base == "l2" else "L3_three_layer")
    source = folder / "kgen_mp31_cm55.s"
    s = source.read_text()
    old_s = (control/source.name).read_text()
    # The original regular NTT and all inverse/probe code remain unchanged.
    body = lambda t: t.split(".Lntt_regular:\n",1)[1].split("/*\n * Small even NTT",1)[0]
    assert body(s) == body(old_s)
    original_record = (ROOT / "results/l2/full_validated.json" if base == "l2" else
                       ROOT / "experiments/ntt_final/results/l3/full_validated.json")
    original_dir = Path(json.loads(original_record.read_text())["run_directory"])
    orig = (original_dir/source.name).read_text()
    before_inverse = orig.split("fndsa_mp_iNTT:\n",1)[1].split('.section .note.GNU-stack',1)[0]
    after_inverse = s.split("fndsa_mp_iNTT:\n",1)[1].split("/*\n * Small even NTT",1)[0]
    assert normalized(before_inverse) == normalized(after_inverse), "inverse or arithmetic probes changed"
    for macro in ("MP31_ROOT", "MP31_MONT", "MP31_ADD", "MP31_SUB", "MP31_HALF", "MP31_CT", "MP31_GS"):
        pattern = rf"^\s*\.macro {macro}\b.*?^\s*\.endm"
        assert re.search(pattern,s,re.M|re.S)[0] == re.search(pattern,orig,re.M|re.S)[0], macro
    regular_group = s.split(".Lntt_two_group:\n",1)[1].split("\n\tlsr\t\tr5, r5, #2",1)[0]
    small_group = s.split(".Lsmall_two_group:\n",1)[1].split("/* After the first CT2",1)[0]
    assert normalized(regular_group) == normalized(small_group.replace(".Lsmall_two_", ".Lntt_two_")), "CT2 scheduling changed"
    small_final = s.split(".Lsmall_last_loop:\n",1)[1].split(".size fndsa_mp_NTT_small",1)[0]
    reg_final = s.split(".Lntt_last_loop:\n",1)[1].split(".size fndsa_mp_NTT,",1)[0]
    reg_final = re.sub(r"^\s*add\s+sp, sp, #(?:8|16)\s*$", "", reg_final, flags=re.M)
    small_final = small_final.replace(".Lsmall_last_", ".Lntt_last_").replace(".Lsmall_stride8", ".Lmp31_stride8").replace("[sp, #96]", "[sp, #0]")
    assert normalized(reg_final) == normalized(small_final), "final CT2 scheduling changed"
    dis = subprocess.check_output([str(BIN/"arm-none-eabi-objdump"),"-d","--disassemble=fndsa_mp_NTT_small",str(new)],text=True)
    assert "<fndsa_mp_NTT_small>:" in dis
    assert not re.search(r"\s(?:bl|blx|sdiv|udiv|vdiv\S*|vcvt\S*)\s", dis)
    assert not re.search(r"\sv(?:ldr|str)\S*\s+[^\n]*\[sp",dis)
    out = ROOT / "experiments" / a.label
    out.mkdir(parents=True,exist_ok=True)
    (out/(a.candidate+"_small_disassembly.txt")).write_text(dis)
    result = {
        "candidate":a.candidate, "control":str(control.relative_to(ROOT)),
        "source_sha256":sha(source), "old_elf_sha256":sha(old), "new_elf_sha256":sha(new),
        "changed_byte_addresses":changes,
        "changes_confined_to_entry_guard_and_small_helper":True,
        "small_helper_address":hex(small),
        "all_other_allocated_bytes_addresses_sizes_identical":True,
        "config_identical":True, "inverse_and_arithmetic_unchanged":True,
        "ct2_group_and_final_arithmetic_instruction_order_unchanged":True,
        "small_frame_bytes":104, "small_p0i_slot":104,
        "new_function_calls_divisions_fp_conversions_or_coefficient_stack_spills":False,
        "formal_constant_time_proof":False, "dynamic_leakage_test":False,
    }
    (out/(a.candidate+"_static_audit.json")).write_text(json.dumps(result,indent=2)+"\n")
    brief = {k:v for k,v in result.items() if k != "changed_byte_addresses"}
    brief["changed_byte_count"] = len(changes)
    print(json.dumps(brief,indent=2))

if __name__ == "__main__":
    main()
