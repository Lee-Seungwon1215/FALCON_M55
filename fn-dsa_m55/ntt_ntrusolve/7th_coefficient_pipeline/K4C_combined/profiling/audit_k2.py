#!/usr/bin/env python3
"""Reproduce the K1 -> K2 disassembly-level constant-time regression audit."""
import collections
import hashlib
import json
from pathlib import Path
import re
import subprocess

PROFILE = Path(__file__).resolve().parent
WORK = PROFILE.parents[2]
BIN = (WORK / "measurement_mlkem_native/env/"
       "arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin")
NM = BIN / "arm-none-eabi-nm"
OBJDUMP = BIN / "arm-none-eabi-objdump"
RUNS = PROFILE / "results"
K1_AUDIT = RUNS / "d1-k1_full_igm_audit_v2-audit/runs/pilot-20260916T074406Z"
K2_AUDIT = RUNS / "d1-k2_root_pipeline_audit-audit/runs/pilot-20260916T082122Z"
K1_PERF = RUNS / "d1-k1_full_igm_perf-perf/runs/full-20260916T074512Z"
K2_PERF = RUNS / "d1-k2_root_pipeline_perf-perf/runs/full-20260916T082212Z"


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
        r"^\s*([0-9a-f]+):\s+(?:[0-9a-f]{2,8}\s+)+"
        r"([^\s]+)(?:\s+(.*?))?\s*$")
    for line in out.splitlines():
        match = pattern.match(line)
        if match:
            rows.append((int(match[1], 16) - start,
                         match[2], match[3] or ""))
    return start, size, rows


def branch(row):
    mnemonic = row[1]
    return mnemonic.startswith("b") and mnemonic not in ("bic", "bfi", "bkpt")


def memory_counter(rows):
    return collections.Counter(
        (mnemonic, re.sub(r"\s+", "", address))
        for _, mnemonic, operands in rows
        for address in re.findall(r"\[[^\]]+\]", operands))


def function_report(k1, k2, name):
    old_start, old_size, old = instructions(k1, name)
    new_start, new_size, new = instructions(k2, name)
    assert old_start == new_start and old_size == new_size
    assert collections.Counter(x[1] for x in old) == collections.Counter(x[1] for x in new)
    assert [(x[0], x[1]) for x in old if branch(x)] == [
        (x[0], x[1]) for x in new if branch(x)]
    forbidden = re.compile(r"(?:bl|blx|[us]div(?:\.[a-z0-9]+)?|vdiv.*|vcvt.*)")
    assert not [x for x in new if forbidden.fullmatch(x[1]) or ".f32" in x[1] or ".f64" in x[1]]
    old_mem, new_mem = memory_counter(old), memory_counter(new)
    result = {
        "address_k1": hex(old_start), "address_k2": hex(new_start),
        "size_bytes_k1": old_size, "size_bytes_k2": new_size,
        "instructions_k1": len(old), "instructions_k2": len(new),
        "branches_k1": sum(map(branch, old)), "branches_k2": sum(map(branch, new)),
        "memory_instructions_k1": sum("[" in x[2] for x in old),
        "memory_instructions_k2": sum("[" in x[2] for x in new),
        "mnemonic_multiset_equal": True,
        "branch_offset_and_mnemonic_sequence_equal": True,
        "memory_address_multiset_equal": old_mem == new_mem,
    }
    if name == "fndsa_mp_NTT":
        assert old_mem == new_mem
    else:
        assert old_mem - new_mem == collections.Counter({("vldrw.u32", "[fp,q7]"): 1})
        assert new_mem - old_mem == collections.Counter({("vldrw.u32", "[fp,q6]"): 1})
        result["memory_address_difference"] = {
            "k1": "vldrw.u32 q4, [r11, q7]",
            "k2": "vldrw.u32 q4, [r11, q6]",
            "reason": "q6 receives the same public constant stride vector before the load; "
                      "this is a scheduling register rename, not a coefficient-derived address",
        }
    return result


def main():
    k1a, k2a = K1_AUDIT / "zephyr.elf", K2_AUDIT / "zephyr.elf"
    k1p, k2p = K1_PERF / "zephyr.elf", K2_PERF / "zephyr.elf"
    for path in (k1a, k2a, k1p, k2p):
        assert path.is_file()
    old_symbols, new_symbols = symbols(k1p), symbols(k2p)
    common = set(old_symbols) & set(new_symbols)
    assert old_symbols == new_symbols and len(common) == 499
    report = {
        "status": "PASS",
        "scope": "static constant-time regression from K1 full-iGM to K2 root-preparation scheduling",
        "baseline": {"run": str(K1_AUDIT.relative_to(RUNS)), "elf_sha256": sha(k1a)},
        "candidate": {"run": str(K2_AUDIT.relative_to(RUNS)), "elf_sha256": sha(k2a)},
        "whole_perf_elf_layout": {
            "common_named_symbols": len(common), "address_or_size_changes": 0,
            "symbols_only_in_k1": 0, "symbols_only_in_k2": 0,
        },
        "functions": {
            name: function_report(k1a, k2a, name)
            for name in ("fndsa_mp_NTT", "fndsa_mp_iNTT")
        },
        "reasoning": [
            "K2 changes only instruction order and one temporary stride register.",
            "No compare, predicate, conditional branch, indirect branch, call, coefficient load, root load, or store was added or removed.",
            "All loop bounds and branch predicates remain functions of public logn and public counters.",
            "No coefficient value is introduced into an address calculation.",
        ],
        "limitation": "This is a disassembly-level structural regression check, not a formal constant-time proof and not a dynamic leakage test such as dudect or TVLA.",
    }
    output = RUNS / "k2_static_ct.json"
    output.write_text(json.dumps(report, indent=2) + "\n")
    print("PASS", output)


if __name__ == "__main__":
    main()
