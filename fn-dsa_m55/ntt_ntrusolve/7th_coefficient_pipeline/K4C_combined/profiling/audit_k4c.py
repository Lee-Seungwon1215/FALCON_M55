#!/usr/bin/env python3
"""K2 -> K4-C disassembly-level constant-time regression audit."""
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
BASE_RUN = (WORK / "ntt_ntrusolve/ref_preslothy/profiling/results/"
            "d1-k2_root_pipeline_audit-audit/runs/pilot-20260916T082122Z")
K4A_RUN = (WORK / "ntt_ntrusolve/7th_coefficient_pipeline/K4A_forward/"
           "profiling/results/d1-k4a_forward_audit_v1-audit/runs/"
           "pilot-20260916T115027Z")
K4B_RUN = (WORK / "ntt_ntrusolve/7th_coefficient_pipeline/K4B_inverse/"
           "profiling/results/d1-k4b_inverse_audit_v1-audit/runs/"
           "pilot-20260916T121445Z")
CANDIDATE_RUN = (PROFILE / "results/d1-k4c_combined_audit_v1-audit/runs/"
                 "pilot-20260916T124600Z")


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


def function_report(base, candidate, isolated, name):
    old_start, old_size, old = instructions(base, name)
    new_start, new_size, new = instructions(candidate, name)
    iso_start, iso_size, iso = instructions(isolated, name)
    assert old_start == new_start == iso_start
    assert old_size == new_size == iso_size
    assert old != new
    assert new == iso
    assert collections.Counter(row[1] for row in old) == collections.Counter(
        row[1] for row in new)
    assert [(row[0], row[1], row[2]) for row in old if branch(row)] == [
        (row[0], row[1], row[2]) for row in new if branch(row)]
    assert memory_counter(old) == memory_counter(new)
    forbidden = re.compile(r"(?:bl|blx|[us]div(?:\.[a-z0-9]+)?|vdiv.*|vcvt.*)")
    assert not [row for row in new
                if forbidden.fullmatch(row[1])
                or ".f32" in row[1] or ".f64" in row[1]]
    return {
        "address": hex(new_start),
        "size_bytes": new_size,
        "instructions": len(new),
        "branches": sum(map(branch, new)),
        "memory_instructions": sum("[" in row[2] for row in new),
        "instruction_rows_identical_to_isolated_candidate": True,
        "mnemonic_multiset_equal_to_k2": True,
        "branch_offset_mnemonic_operand_sequence_equal_to_k2": True,
        "memory_address_multiset_equal_to_k2": True,
        "forbidden_call_divide_or_fp_instructions": 0,
    }


def main():
    base = BASE_RUN / "zephyr.elf"
    k4a = K4A_RUN / "zephyr.elf"
    k4b = K4B_RUN / "zephyr.elf"
    candidate = CANDIDATE_RUN / "zephyr.elf"
    for path in (base, k4a, k4b, candidate):
        assert path.is_file()

    base_manifest = json.loads((BASE_RUN / "h1_build.json").read_text())
    candidate_manifest = json.loads((CANDIDATE_RUN / "h1_build.json").read_text())
    source_differences = sorted(
        name for name in set(base_manifest["sources"]) | set(candidate_manifest["sources"])
        if base_manifest["sources"].get(name) != candidate_manifest["sources"].get(name))
    assert source_differences == ["kgen_mp31_cm55.s"]

    symbol_maps = [symbols(path) for path in (base, k4a, k4b, candidate)]
    assert symbol_maps[0] == symbol_maps[1] == symbol_maps[2] == symbol_maps[3]
    report = {
        "status": "PASS",
        "scope": "K2 to K4-C combined forward and inverse coefficient scheduling",
        "baseline": {"run": str(BASE_RUN), "elf_sha256": sha(base)},
        "candidate": {"run": str(CANDIDATE_RUN), "elf_sha256": sha(candidate)},
        "isolated_forward": {"run": str(K4A_RUN), "elf_sha256": sha(k4a)},
        "isolated_inverse": {"run": str(K4B_RUN), "elf_sha256": sha(k4b)},
        "source_files_with_different_hash": source_differences,
        "whole_audit_elf_layout": {
            "named_symbols": len(symbol_maps[0]),
            "address_or_size_changes": 0,
        },
        "functions": {
            "fndsa_mp_NTT": function_report(
                base, candidate, k4a, "fndsa_mp_NTT"),
            "fndsa_mp_NTT_small": function_report(
                base, candidate, k4a, "fndsa_mp_NTT_small"),
            "fndsa_mp_iNTT": function_report(
                base, candidate, k4b, "fndsa_mp_iNTT"),
        },
        "reasoning": [
            "K4-C is the direct source-level composition of K4-A forward and K4-B inverse scheduling.",
            "Its forward instruction streams exactly match K4-A; its inverse stream exactly matches K4-B.",
            "No instruction, branch, call, divide, floating-point operation, memory access, or address form was added or removed relative to K2.",
            "All loop bounds and branch predicates remain functions of public logn and public counters.",
            "No coefficient value is introduced into an address calculation.",
        ],
        "limitation": "This is a disassembly-level structural regression check, not a formal constant-time proof or a dynamic leakage test such as dudect or TVLA.",
    }
    output = PROFILE / "results/k4c_static_ct.json"
    output.write_text(json.dumps(report, indent=2) + "\n")
    print("PASS", output)


if __name__ == "__main__":
    main()
