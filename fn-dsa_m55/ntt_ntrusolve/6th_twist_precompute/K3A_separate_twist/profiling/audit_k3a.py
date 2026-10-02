#!/usr/bin/env python3
"""Static K2 -> K3-A constant-time and footprint regression audit."""
import collections
import hashlib
import json
from pathlib import Path
import re
import subprocess

PROFILE = Path(__file__).resolve().parent
WORK = PROFILE.parents[3]
BIN = (WORK / "measurement_mlkem_native/env/"
       "arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin")
NM = BIN / "arm-none-eabi-nm"
OBJDUMP = BIN / "arm-none-eabi-objdump"
SIZE = BIN / "arm-none-eabi-size"
K2 = (WORK / "ntt_ntrusolve/ref_preslothy/profiling/results/"
      "d1-k2_root_pipeline_audit-audit/runs/pilot-20260916T082122Z/zephyr.elf")
K3 = (PROFILE / "results/d1-k3a_separate_twist_audit_v2-audit/runs/"
      "pilot-20260916T084725Z/zephyr.elf")
OUTPUT = PROFILE / "results/k3a_static_ct.json"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def symbols(path):
    out = subprocess.check_output([NM, "-n", "-S", path], text=True)
    result = {}
    for line in out.splitlines():
        row = line.split()
        if len(row) == 4:
            result[row[3]] = (int(row[0], 16), int(row[1], 16), row[2])
    return result


def instructions(path, name):
    start, size, _ = symbols(path)[name]
    out = subprocess.check_output([
        OBJDUMP, "-d", f"--start-address={start}",
        f"--stop-address={start + size}", path], text=True)
    rows = []
    pattern = re.compile(
        r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+){1,2}"
        r"([^\s]+)(?:\s+(.*?))?\s*$")
    for line in out.splitlines():
        match = pattern.match(line)
        if match:
            rows.append((int(match[1], 16) - start,
                         match[2], match[3] or ""))
    return start, size, rows


def is_branch(row):
    op = row[1]
    return op.startswith("b") and op not in ("bic", "bfi", "bkpt")


def image_size(path):
    lines = subprocess.check_output([SIZE, path], text=True).splitlines()
    text, data, bss, total = map(int, lines[-1].split()[:4])
    return {"text": text, "data": data, "bss": bss, "total": total}


def function_report(name):
    _, old_size, old = instructions(K2, name)
    _, new_size, new = instructions(K3, name)
    old_branches = [x[1] for x in old if is_branch(x)]
    new_branches = [x[1] for x in new if is_branch(x)]
    assert old_branches == new_branches
    forbidden = re.compile(r"(?:bl|blx|bx|[us]div(?:\.[a-z0-9]+)?|vdiv.*|vcvt.*)")
    assert not [x for x in new
                if forbidden.fullmatch(x[1]) or ".f32" in x[1] or ".f64" in x[1]]
    return {
        "size_bytes_k2": old_size,
        "size_bytes_k3a": new_size,
        "instructions_k2": len(old),
        "instructions_k3a": len(new),
        "branches_k2": len(old_branches),
        "branches_k3a": len(new_branches),
        "branch_mnemonic_sequence_equal": True,
        "memory_instructions_k2": sum("[" in x[2] for x in old),
        "memory_instructions_k3a": sum("[" in x[2] for x in new),
        "forbidden_call_divide_or_fp": 0,
        "mnemonic_delta": {
            "added": dict(collections.Counter(x[1] for x in new)
                          - collections.Counter(x[1] for x in old)),
            "removed": dict(collections.Counter(x[1] for x in old)
                            - collections.Counter(x[1] for x in new)),
        },
    }


def main():
    assert K2.is_file() and K3.is_file()
    syms = symbols(K3)
    for name in ("fndsa_mp_gm_twist", "fndsa_mp_igm_twist"):
        addr, size, kind = syms[name]
        assert size == 4096 and addr % 32 == 0 and kind.lower() == "b"
    old_image, new_image = image_size(K2), image_size(K3)
    report = {
        "status": "PASS",
        "scope": "static constant-time regression from K2 to experimental K3-A",
        "baseline_elf_sha256": sha(K2),
        "candidate_elf_sha256": sha(K3),
        "image": {
            "k2": old_image,
            "k3a": new_image,
            "delta": {key: new_image[key] - old_image[key] for key in old_image},
        },
        "twist_tables": {
            "count": 2,
            "bytes_each": 4096,
            "total_bytes": 8192,
            "alignment": 32,
            "index_source": "public root-table offset / public logn and loop counters",
        },
        "functions": {name: function_report(name) for name in
                      ("fndsa_mp_NTT", "fndsa_mp_iNTT")},
        "reasoning": [
            "K3-A adds no branch and preserves the K2 branch-mnemonic sequence.",
            "The new table addresses use only the public root-table offset, public logn, and public loop counters.",
            "Root and twist values depend only on public modulus/root parameters; no coefficient value enters an address or branch.",
            "The added generator stores are fixed-count loops over public n and bit-reversed public indices.",
        ],
        "semantic_warning": "The two process-global mutable twist tables make K3-A non-reentrant even though its instruction flow is data independent.",
        "limitation": "Static structural regression only; not a formal proof and not dudect/TVLA or physical leakage testing.",
    }
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(report, indent=2) + "\n")
    print("PASS", OUTPUT)


if __name__ == "__main__":
    main()
