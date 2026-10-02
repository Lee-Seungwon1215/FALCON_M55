#!/usr/bin/env python3
"""Verify stage-4 promotion against the exact validated standalone candidate.

The assembly is copied directly into ntt_opt. This script audits that copy,
its independently linked ELF and (after completion) its own board run.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess

import audit_combinations as prior
import run_integrated as current

NAME = "S1B_S2B_S3A"
CHOSEN, CHOSEN_BUILD = prior.runs.runner.CANDIDATES[NAME]
OUT = current.ROOT / "results/integrated"


def sources(root):
    return {p.name: prior.sha(p) for p in root.iterdir() if p.suffix in (".c", ".h", ".s")}


def allocated_contents(path):
    """ELF32 allocated section payloads, ignoring debug metadata and file paths."""
    data = path.read_bytes()
    assert data[:6] == b"\x7fELF\x01\x01"
    header = struct.unpack_from("<16sHHIIIIIHHHHHH", data)
    sections = [struct.unpack_from("<IIIIIIIIII", data, header[6] + i * header[11])
                for i in range(header[12])]
    strings = sections[header[13]]
    names = data[strings[4]:strings[4] + strings[5]]
    result = {}
    for s in sections:
        if not (s[2] & 2) or not s[5]:
            continue
        name = names[s[0]:names.index(0, s[0])].decode()
        payload = b"" if s[1] == 8 else data[s[4]:s[4] + s[5]]
        result[name] = (s[1], s[2], s[3], s[5], payload)
    return result


def compile_commands(build, source):
    commands = json.loads((build / "compile_commands.json").read_text())
    return {Path(x["file"]).name: prior.normalize_command(x["command"], source, build)
            for x in commands if Path(x["file"]).parent == source}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--require-full", action="store_true")
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    selected = sources(CHOSEN)
    integrated = sources(current.SOURCE)
    archived = sources(prior.BASE)
    assert integrated == selected, "promoted C/H/S differs from the selected candidate"
    changed = [name for name in archived if archived[name] != integrated[name]]
    assert changed == ["mq_cm55.s"], changed
    approved = json.loads((prior.RESULTS / NAME / "full_validated.json").read_text())
    tree_hash = current.runner.tree_sha(current.SOURCE)
    assert approved["source_tree_sha256"] == tree_hash
    selected_elf = CHOSEN_BUILD / "zephyr/zephyr.elf"
    elf = current.BUILD / "zephyr/zephyr.elf"
    assert approved["elf_sha256"] == prior.sha(selected_elf)
    left, right = allocated_contents(selected_elf), allocated_contents(elf)
    assert left == right, "allocated execution/data images differ"
    assert compile_commands(current.BUILD, current.SOURCE) == compile_commands(CHOSEN_BUILD, CHOSEN)
    assert (current.BUILD / "zephyr/.config").read_bytes() == (CHOSEN_BUILD / "zephyr/.config").read_bytes()
    cache = (current.BUILD / "CMakeCache.txt").read_text()
    assert "FNDSA_MQ_ASM:STRING=mq_cm55" in cache or "FNDSA_MQ_ASM:UNINITIALIZED=mq_cm55" in cache
    functions, symbols, sections = prior.elf32(elf)
    other_functions, _, _ = prior.elf32(selected_elf)
    assert functions == other_functions
    selected_audit = json.loads((prior.RESULTS / NAME / "static_audit.json").read_text())
    assert selected_audit["valid"] and selected_audit["source_sha256"] == selected["mq_cm55.s"]
    model = json.loads((prior.RESULTS / "revision_model.json").read_text())
    assert model["valid"] and model["source_sha256"][NAME] == integrated["mq_cm55.s"]
    toolchain = current.BUILD.parent / "env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin"
    dis = subprocess.check_output([str(toolchain / "arm-none-eabi-objdump"), "-d", str(elf)], text=True)
    (OUT / "firmware.dis").write_text(dis)
    section_report = [dict(name=n, address=f"0x{value[2]:08x}", bytes=value[3],
                           payload_sha256=hashlib.sha256(value[4]).hexdigest())
                      for n, value in right.items()]
    report = dict(valid=True, selected_candidate=NAME,
                  source_directory=str(current.SOURCE), build_directory=str(current.BUILD),
                  source_tree_sha256=tree_hash, assembly_sha256=integrated["mq_cm55.s"],
                  elf_sha256=prior.sha(elf), selected_elf_sha256=prior.sha(selected_elf),
                  all_crypto_sources_equal_candidate=True,
                  allocated_sections_byte_identical=True, function_bytes_identical=True,
                  compiler_commands_equal_candidate=True, zephyr_config_equal_candidate=True,
                  changed_crypto_files_vs_stage3=changed,
                  instruction_model_cases=model["model_cases"],
                  itcm_code_bytes=symbols["__rom_region_size"],
                  dtcm_reserved_bytes=symbols["_image_ram_size"], sections=section_report,
                  constant_time_scope="Identical source and instruction bytes to the statically audited candidate; no new secret-dependent branch/address. Not formal CT proof, timing-leakage test or power/EM TVLA.")
    (OUT / "static_audit.json").write_text(json.dumps(report, indent=2) + "\n")
    print("STATIC PASS: sources, compiler settings and allocated ELF bytes equal", NAME)
    if args.require_full:
        old_results = prior.RESULTS
        prior.RESULTS = current.ROOT / "results"
        prior.runs.runner.CANDIDATES["integrated"] = (current.SOURCE, current.BUILD)
        try:
            measured = prior.board_summary("integrated")
            assert measured is not None
        finally:
            prior.RESULTS = old_results
            del prior.runs.runner.CANDIDATES["integrated"]
        baseline = prior.board_summary("baseline")
        candidate = prior.board_summary(NAME)
        assert baseline is not None and candidate is not None
        compared = dict(integrated=measured, selected_candidate=candidate, stage3_baseline=baseline,
                        integrated_minus_candidate_cycles={
                            key: value - candidate["upper_median"][key]
                            for key, value in measured["upper_median"].items()})
        (OUT / "comparison.json").write_text(json.dumps(compared, indent=2) + "\n")
        print("FULL PASS:", measured["upper_median"])
        print("integrated - candidate:", compared["integrated_minus_candidate_cycles"])


if __name__ == "__main__":
    main()
