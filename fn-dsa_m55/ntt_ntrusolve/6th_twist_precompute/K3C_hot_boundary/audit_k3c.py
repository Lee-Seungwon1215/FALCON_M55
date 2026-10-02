#!/usr/bin/env python3
"""Static constant-time and footprint regression audit for K3-C candidates."""
import collections
import hashlib
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parent
FNDSA_M55 = ROOT.parents[2]
BIN = (FNDSA_M55 / "measurement_mlkem_native/env/"
       "arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin")
NM = BIN / "arm-none-eabi-nm"
OBJDUMP = BIN / "arm-none-eabi-objdump"
SIZE = BIN / "arm-none-eabi-size"
BASE = (ROOT.parents[1] / "ref_preslothy/profiling/results/"
        "d1-k2_root_pipeline_audit-audit/runs/"
        "pilot-20260916T082122Z/zephyr.elf")
CANDIDATES = {
    "F_forward": ROOT / "F_forward/profiling/results/"
        "d1-k3c_f_audit-audit/runs/pilot-20260916T094112Z/zephyr.elf",
    "I_inverse": ROOT / "I_inverse/profiling/results/"
        "d1-k3c_i_audit-audit/runs/pilot-20260916T094128Z/zephyr.elf",
    "FI_combined": ROOT / "FI_combined/profiling/results/"
        "d1-k3c_fi_audit_v2-audit/runs/pilot-20260916T093618Z/zephyr.elf",
}
OUTPUT = ROOT / "static_ct.json"


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
    return size, rows


def is_branch(row):
    op = row[1]
    return op.startswith("b") and op not in ("bic", "bfi", "bkpt")


def image_size(path):
    line = subprocess.check_output([SIZE, path], text=True).splitlines()[-1]
    text, data, bss, total = map(int, line.split()[:4])
    return {"text": text, "data": data, "bss": bss, "total": total}


def function_report(candidate, name):
    old_size, old = instructions(BASE, name)
    new_size, new = instructions(candidate, name)
    old_branches = [x[1] for x in old if is_branch(x)]
    new_branches = [x[1] for x in new if is_branch(x)]
    assert old_branches == new_branches
    forbidden = re.compile(r"(?:bl|blx|bx|[us]div(?:\.[a-z0-9]+)?|vdiv.*|vcvt.*)")
    bad = [x for x in new if forbidden.fullmatch(x[1])
           or ".f32" in x[1] or ".f64" in x[1]]
    assert not bad
    return {
        "size_bytes_k2": old_size,
        "size_bytes_k3c": new_size,
        "instructions_k2": len(old),
        "instructions_k3c": len(new),
        "branches_k2": len(old_branches),
        "branches_k3c": len(new_branches),
        "branch_mnemonic_sequence_equal": True,
        "memory_instructions_k2": sum("[" in x[2] for x in old),
        "memory_instructions_k3c": sum("[" in x[2] for x in new),
        "forbidden_call_divide_or_fp": 0,
        "mnemonic_delta": {
            "added": dict(collections.Counter(x[1] for x in new)
                          - collections.Counter(x[1] for x in old)),
            "removed": dict(collections.Counter(x[1] for x in old)
                            - collections.Counter(x[1] for x in new)),
        },
    }


def main():
    assert BASE.is_file()
    base_image = image_size(BASE)
    reports = {}
    for label, elf in CANDIDATES.items():
        assert elf.is_file()
        syms = symbols(elf)
        expected = []
        if label in ("F_forward", "FI_combined"):
            expected.append("fndsa_mp_gm_boundary")
        if label in ("I_inverse", "FI_combined"):
            expected.append("fndsa_mp_igm_boundary")
        for name in expected:
            addr, size, kind = syms[name]
            assert size == 12192 and addr % 32 == 0 and kind.lower() == "b"
        image = image_size(elf)
        reports[label] = {
            "elf_sha256": sha(elf),
            "image": image,
            "image_delta_from_k2": {
                key: image[key] - base_image[key] for key in base_image
            },
            "packed_tables": {
                "count": len(expected),
                "bytes_each": 12192,
                "total_bytes": 12192 * len(expected),
                "alignment": 32,
            },
            "functions": {name: function_report(elf, name) for name in
                          ("fndsa_mp_NTT", "fndsa_mp_iNTT",
                           "fndsa_mp_NTT_small")},
        }
    report = {
        "status": "PASS",
        "scope": "static constant-time regression from K2 to K3-C",
        "baseline_elf_sha256": sha(BASE),
        "baseline_image": base_image,
        "candidates": reports,
        "reasoning": [
            "K3-C preserves each K2 transform's branch-mnemonic sequence.",
            "Added table addresses depend only on public logn and public loop counters.",
            "Packed roots/twists depend only on public modulus/root parameters.",
            "Packing loops have fixed public bounds and public bit-reversed indices.",
        ],
        "semantic_warning": (
            "Mutable process-global packed tables make K3-C non-reentrant."
        ),
        "limitation": (
            "Static structural regression only; not a formal proof, dudect/TVLA, "
            "or physical leakage test."
        ),
    }
    OUTPUT.write_text(json.dumps(report, indent=2) + "\n")
    print("PASS", OUTPUT)


if __name__ == "__main__":
    main()
