#!/usr/bin/env python3
"""Reproducible source/object scope audit and strict board-log summary.

This is a regression/static-structure check, not a constant-time proof.
It does not rebuild firmware, combine source fragments or access the board.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import shlex
import struct
import subprocess
import tarfile

import check_combination_revision as model
import run_combinations as runs

ROOT = runs.ROOT / "combinations"
RESULTS = ROOT / "results"
MEAS = runs.MEAS
BASE, BASE_BUILD = runs.runner.CANDIDATES["baseline"]
# Compile database paths describe where the archived baseline was built.
BASE_ORIGINAL = ROOT.parents[1] / "ntt_opt"
BASE_BUILD_ORIGINAL = MEAS / "build-ntt-opt"
TARGETS = {"fndsa_mqpoly_int_to_ntt", "fndsa_mqpoly_ntt_to_int"}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def elf32(path):
    data = path.read_bytes()
    assert data[:6] == b"\x7fELF\x01\x01"
    header = struct.unpack_from("<16sHHIIIIIHHHHHH", data)
    offset, entrysize, count, strings = header[6], header[11], header[12], header[13]
    sections = [struct.unpack_from("<IIIIIIIIII", data, offset + i * entrysize)
                for i in range(count)]
    def content(section):
        return data[section[4]:section[4] + section[5]]
    def cstring(pool, index):
        return pool[index:pool.index(0, index)].decode()
    names = content(sections[strings])
    funcs, symbols = {}, {}
    for section in sections:
        if section[1] != 2:  # SHT_SYMTAB
            continue
        pool = content(sections[section[6]])
        for start in range(section[4], section[4] + section[5], section[9]):
            name, value, size, info, _, idx = struct.unpack_from("<IIIBBH", data, start)
            name = cstring(pool, name)
            symbols[name] = value
            if info & 15 == 2 and size and idx < len(sections):
                target = sections[idx]
                begin = target[4] + (value & ~1) - target[3]
                funcs[name] = data[begin:begin + size]
    return funcs, symbols, [dict(name=cstring(names, s[0]), flags=s[2],
                                address=s[3], size=s[5]) for s in sections]


def source_instructions(source):
    defs = model.macros(source)
    plain = re.sub(r"\t\.macro\t.*?\t\.endm", "", source, flags=re.S)
    result = []
    for line in plain.splitlines():
        line = line.split("@", 1)[0].strip()
        if not line or line.startswith(".") or line.endswith(":"):
            continue
        parts = line.split(None, 1)
        if parts[0] in defs:
            result += model.expand(defs, parts[0], [a.strip() for a in parts[1].split(",")])
        else:
            result.append(line)
    return [re.sub(r"\s+", " ", x).strip() for x in result]


def control(code):
    pattern = r"^(?:b(?:l|lx|x|eq|ne|cs|cc|hs|lo|mi|pl|vs|vc|hi|ls|ge|lt|gt|le)?(?:\.[nw])?|cbz|cbnz|tbb|tbh|wls|dls|le) "
    return [line for line in code if re.match(pattern, line)]


def stack(code):
    return [line for line in code if re.search(r"\bsp\b", line)
            or re.match(r"v?(push|pop)\b", line)]


def normalize_command(command, source, build):
    return command.replace(str(source), "SOURCE").replace(str(build), "BUILD")


def static_audit(name, archive):
    source, build = runs.runner.CANDIDATES[name]
    out = RESULTS / name / "static"
    out.mkdir(parents=True, exist_ok=True)
    before = archive.extractfile(name + "/mq_cm55.s").read().decode()
    current = (source / "mq_cm55.s").read_text()
    old_code, new_code = source_instructions(before), source_instructions(current)
    assert control(old_code) == control(new_code), (name, "control flow changed")
    assert stack(old_code) == stack(new_code), (name, "stack use changed")
    assert not re.search(r"^\s*(?:\.include|#include)", current, re.M)
    baseline_files = {p.name: sha(p) for p in BASE.iterdir() if p.suffix in (".c", ".h", ".s")}
    candidate_files = {p.name: sha(p) for p in source.iterdir() if p.suffix in (".c", ".h", ".s")}
    assert baseline_files.keys() == candidate_files.keys()
    changed = [key for key in baseline_files if baseline_files[key] != candidate_files[key]]
    assert changed == ["mq_cm55.s"], (name, changed)

    commands = json.loads((build / "compile_commands.json").read_text())
    entry = next(x for x in commands if x["file"] == str(source / "mq_cm55.s"))
    command = shlex.split(entry["command"])
    compiler = Path(command[0])
    objdump = compiler.with_name("arm-none-eabi-objdump")
    current_obj = build / entry["output"]
    old_obj = out / "before.o"
    command[command.index("-o") + 1] = str(old_obj)
    command[command.index("-c") + 1] = "-"
    command[1:1] = ["-x", "assembler"]
    subprocess.run(command, input=before, text=True, cwd=build, check=True, capture_output=True)
    oldfunc, _, _ = elf32(old_obj)
    newfunc, _, _ = elf32(current_obj)
    assert oldfunc.keys() == newfunc.keys()
    diff = [f for f in oldfunc if oldfunc[f] != newfunc[f]]
    assert set(diff) <= TARGETS, (name, diff)
    baseline_commands = json.loads((BASE_BUILD / "compile_commands.json").read_text())
    baseline_entry = next(e for e in baseline_commands if e["file"] == str(BASE_ORIGINAL / "mq_cm55.s"))
    baseline_functions, _, _ = elf32(BASE_BUILD / baseline_entry["output"])
    assert baseline_functions.keys() == newfunc.keys()
    baseline_diff = [f for f in newfunc if newfunc[f] != baseline_functions[f]]
    assert set(baseline_diff) <= TARGETS, (name, baseline_diff)
    for label, obj in (("before", old_obj), ("current", current_obj),
                       ("firmware", build / "zephyr/zephyr.elf")):
        disassembly = subprocess.check_output([str(objdump), "-d", str(obj)], text=True)
        (out / (label + ".dis")).write_text(disassembly)
    _, symbols, sections = elf32(build / "zephyr/zephyr.elf")
    allocated = [s for s in sections if s["flags"] & 2 and s["size"]]
    assert all((0x10000000 <= s["address"] and s["address"] + s["size"] <= 0x10020000)
               or (0x30000000 <= s["address"] and s["address"] + s["size"] <= 0x30040000)
               for s in allocated)
    normalized = {Path(e["file"]).name: normalize_command(e["command"], source, build)
                  for e in commands if Path(e["file"]).parent == source}
    baseline_normalized = {Path(e["file"]).name: normalize_command(e["command"], BASE_ORIGINAL, BASE_BUILD_ORIGINAL)
                           for e in baseline_commands if Path(e["file"]).parent == BASE_ORIGINAL}
    assert normalized == baseline_normalized, (name, "compiler options differ")
    config = build / "zephyr/.config"
    assert config.read_bytes() == (BASE_BUILD / "zephyr/.config").read_bytes()
    (out / "compile_commands.json").write_text(json.dumps(normalized, indent=2) + "\n")
    result = dict(valid=True, candidate=name, source_sha256=candidate_files["mq_cm55.s"],
                  elf_sha256=sha(build / "zephyr/zephyr.elf"),
                  changed_source_files_vs_baseline=changed,
                  changed_object_functions_vs_v1=diff,
                  changed_object_functions_vs_baseline=baseline_diff,
                  control_sequence_equal_v1=True, stack_sequence_equal_v1=True,
                  direct_source_no_includes=True, compiler_options_equal_baseline=True,
                  zephyr_config_equal_baseline=True, zephyr_config_sha256=sha(config),
                  static_instructions_before=len(old_code), static_instructions_after=len(new_code),
                  static_control_count=len(control(new_code)),
                  source_instruction_histogram=dict(Counter(x.split()[0] for x in new_code)),
                  itcm_code_bytes=symbols["__rom_region_size"],
                  itcm_active_code_limit_bytes=131072,
                  dtcm_reserved_bytes=symbols["_image_ram_size"], dtcm_capacity_bytes=262144,
                  sections=allocated,
                  limitations="Scope and unchanged branch/stack checks plus separate instruction-model regression; not formal CT proof, dynamic leakage test or power/EM TVLA.")
    (RESULTS / name / "static_audit.json").write_text(json.dumps(result, indent=2) + "\n")
    return result


def board_summary(name):
    record = RESULTS / name / "full_validated.json"
    if not record.exists():
        return None
    record = json.loads(record.read_text())
    source, build = runs.runner.CANDIDATES[name]
    assert record["source_tree_sha256"] == runs.runner.tree_sha(source)
    assert record["elf_sha256"] == sha(build / "zephyr/zephyr.elf")
    run = Path(record["run_directory"])
    meta = json.loads((run / "run.json").read_text())
    assert meta["valid"] and record["valid"]
    assert meta["raw_log_sha256"] == sha(run / "raw.log")
    raw = re.sub(r"Info : [^\n]*\n", "", (run / "raw.log").read_text())
    samples, errors = runs.runner.validate_measurements(raw, False)
    assert not errors
    ntt = [dict(re.findall(r"(\w+)=(\d+)", line))
           for line in re.findall(r"^NTT_EXACT (.+)$", raw, re.M)]
    assert [x["degree"] for x in ntt] == ["512", "1024"]
    for x in ntt:
        assert all(x[k] == "0" for k in ("forward_mismatches", "roundtrip_mismatches",
                                         "oracle_roundtrip_mismatches", "max_mod_error"))
    mul = re.findall(r"^NTT_MUL_TABLE kind=barrett3 pairs=2048 mismatches=(\d+) .+$", raw, re.M)
    assert mul == ["0", "0"]
    digests = re.findall(r"^(?:DIGEST|AUDIT) degree=.+$", raw, re.M)
    host = (MEAS / "host/full.log").read_text()
    assert len(digests) == 22 and digests == re.findall(r"^(?:DIGEST|AUDIT) degree=.+$", host, re.M)
    assert "FNDSA_DONE correctness=PASS tamper_rejection=PASS" in raw
    assert "FNDSA_FAILURE" not in raw
    assert all(re.findall(rf"^{reg}=(0x[0-9a-f]+)$", raw, re.M) == ["0x0"]
               for reg in ("CFSR", "HFSR", "AFSR"))
    ecc = re.findall(r"^TCM_MSCR_(?:START|END)=(0x[0-9a-f]+)$", raw, re.M)
    assert len(ecc) == 2 and all(int(x, 16) & 0x12 == 2 for x in ecc)
    ccr = int(re.search(r"^CORE .*?ccr=([0-9a-f]+)", raw, re.M)[1], 16)
    assert ccr & 0x30000 == 0
    assert "CLOCK_DECODE cpu=800000000 sysclk=400000000 hclk=200000000" in raw
    summaries = {}
    for line in re.findall(r"^SUMMARY (.+)$", raw, re.M):
        x = dict(re.findall(r"(\w+)=(\d+)", line))
        key = x["degree"] + "_" + ("keygen", "sign", "verify")[int(x["op"])]
        summaries[key] = int(x["upper_median"])
    stack_used = int(re.search(r"^STACK untouched_prefix=\d+ used_upper_bound=(\d+)$", raw, re.M)[1])
    return dict(valid=True, candidate=name, upper_median=summaries, samples=samples,
                kat_digest_count=22, modular_error=0, sign_verify="PASS", tamper_rejection="PASS",
                faults_zero=True, tcm_ecc=ecc, cache_off=True,
                stack_used_upper_bound=stack_used, run_directory=str(run),
                source_tree_sha256=record["source_tree_sha256"], elf_sha256=record["elf_sha256"],
                host_expected_log_sha256=sha(MEAS / "host/full.log"),
                raw_log_sha256=meta["raw_log_sha256"])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--skip-static", action="store_true")
    parser.add_argument("--require-full", action="store_true")
    args = parser.parse_args()
    names = [n for n in runs.runner.CANDIDATES if n.startswith("S1")]
    if not args.skip_static:
        with tarfile.open(ROOT / "revision_before/sources-v1.tar.gz") as archive:
            for name in names:
                result = static_audit(name, archive)
                print(name, "static PASS", result["changed_object_functions_vs_v1"], flush=True)
    summaries = {name: board_summary(name) for name in runs.runner.CANDIDATES}
    missing = [name for name, value in summaries.items() if value is None]
    if args.require_full:
        assert not missing, missing
    paired = {}
    baseline = summaries.get("baseline")
    if baseline:
        for name, value in summaries.items():
            if value is None or name == "baseline":
                continue
            references = {"baseline": baseline}
            if summaries.get("before_" + name):
                references["before_" + name] = summaries["before_" + name]
            paired[name] = {}
            for reference_name, reference in references.items():
                index = {(s["degree"], s["operation"], s["batch"]): s["total"]
                         for s in reference["samples"]}
                groups = {}
                for sample in value["samples"]:
                    key = (sample["degree"], sample["operation"], sample["batch"])
                    label = str(sample["degree"]) + "_" + ("keygen", "sign", "verify")[sample["operation"]]
                    groups.setdefault(label, []).append((index[key] - sample["total"]) / 10)
                paired[name][reference_name] = {
                    label: dict(reference_minus_candidate_cycles=deltas,
                                faster=sum(d > 0 for d in deltas), equal=sum(d == 0 for d in deltas),
                                slower=sum(d < 0 for d in deltas),
                                upper_median_delta=sorted(deltas)[5])
                    for label, deltas in groups.items()}
    result = dict(complete=not missing, missing=missing, measurements=summaries, paired=paired)
    (RESULTS / "comparison.json").write_text(json.dumps(result, indent=2) + "\n")
    print("FULL", len(summaries) - len(missing), "/", len(summaries), "missing:", missing)
    for name, value in summaries.items():
        if value:
            print(name, value["upper_median"])


if __name__ == "__main__":
    main()
