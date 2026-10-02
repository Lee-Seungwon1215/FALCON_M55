#!/usr/bin/env python3
"""Read-only audits and build snapshots for the ref_preslothy stage profile.

No board access. Only prepare/record write the candidate's new build manifest.
Historical before/after builds and logs are never rewritten.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import shlex
import sys

sys.dont_write_bytecode = True
import instrument

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parent
SOURCE = WORK / "ntt_ntrusolve/ref_preslothy"
BASE_RECORDED_SOURCE = WORK / "ref"
# A renamed folder is accepted only after its full source-tree hash matches
# the historical, validated run. No symlink or source copy is created.
BASE_SOURCE = BASE_RECORDED_SOURCE if BASE_RECORDED_SOURCE.is_dir() else WORK / "M55_ref"
BUILD = ROOT / "build/preslothy"
BASE_BUILD = ROOT / "build/before"
MANIFEST = BUILD / "profile_provenance.json"
ASM = "codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 kgen_mp31_cm55".split()
ARTIFACTS = ("zephyr/zephyr.elf", "zephyr/zephyr.map", "zephyr/.config",
             "compile_commands.json", "CMakeCache.txt", "fndsa_dtcm_linker.ld")


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sources(source):
    paths = sorted(p for p in source.iterdir() if p.suffix in (".c", ".h", ".s"))
    require(all(p.is_file() and not p.is_symlink() for p in paths), "nonlocal cryptographic source")
    return {p.name: sha(p) for p in paths}


def tree_sha(source):
    h = hashlib.sha256()
    for name in sources(source):
        h.update(name.encode() + b"\0" + (source / name).read_bytes() + b"\0")
    return h.hexdigest()


def baseline():
    record = json.loads((ROOT / "results/before/validated.json").read_text())
    require(record.get("valid"), "historical baseline is not validated")
    require(record["source_tree_sha256"] == tree_sha(BASE_SOURCE), "historical ref source changed")
    require(record["elf_sha256"] == sha(BASE_BUILD / "zephyr/zephyr.elf"), "historical ELF changed")
    require(record["raw_log_sha256"] == sha(Path(record["run_directory"]) / "raw.log"),
            "historical raw log changed")
    require((BASE_BUILD / "benchmark.c").read_bytes() ==
            (WORK / "ntt_profile_compare/benchmark.c").read_bytes(), "workload changed")
    return record


def generated(source, build, recorded_source=None):
    """Verify every generated C byte against the unchanged stage marker recipe."""
    for name in instrument.SOURCES:
        path = source / (name + ".c")
        original = path.read_text()
        content = instrument.INSTRUMENT.get(name, lambda x: x)(original)
        recorded_path = (recorded_source or source) / path.name
        expected = f'#include "profile.h"\n#line 1 "{recorded_path.as_posix()}"\n' + content
        require((build / "generated" / path.name).read_text() == expected,
                "generated instrumentation changed: " + str(path))


def snapshot():
    base = baseline()
    generated(BASE_SOURCE, BASE_BUILD, BASE_RECORDED_SOURCE)
    generated(SOURCE, BUILD)
    return {
        "source_dir": str(SOURCE), "source_tree_sha256": tree_sha(SOURCE),
        "source_files": sources(SOURCE), "baseline": base,
        "baseline_current_source_dir": str(BASE_SOURCE),
        "profiler": {name: sha(ROOT / name) for name in
                     ("profile.c", "profile.h", "instrument.py", "CMakeLists.txt", "build.sh")},
        "benchmark_sha256": sha(WORK / "ntt_profile_compare/benchmark.c"),
        "generated": {name + ".c": sha(BUILD / "generated" / (name + ".c"))
                      for name in instrument.SOURCES},
    }


def normalized_options(row, source, build):
    args = row.get("arguments") or shlex.split(row["command"])
    ignored = {"-DFNDSA_MVE_MP31=1"}
    return [arg.replace(str(build), "<BUILD>").replace(str(source), "<SOURCE>")
            for arg in args if arg not in ignored and not arg.startswith("-DPROFILE_CANDIDATE=")]


def inspect_build():
    commands = json.loads((BUILD / "compile_commands.json").read_text())
    base_commands = json.loads((BASE_BUILD / "compile_commands.json").read_text())
    expected = {BUILD / "generated" / (name + ".c") for name in instrument.SOURCES}
    expected |= {SOURCE / (name + ".s") for name in ASM}
    selected = {}
    for row in commands:
        path = Path(row["file"])
        if path.parent in (SOURCE, BUILD / "generated"):
            require(path in expected and path not in selected, "unexpected/duplicate crypto input: " + str(path))
            args = row.get("arguments") or shlex.split(row["command"])
            require("-DFNDSA_MVE_MP31=1" in args, "RNS MVE backend missing")
            selected[path] = row
        else:
            require(not any(x in str(path) for x in ("/ntt_opt/", "/ntt_opt_slothy/", "/ref/")),
                    "another implementation is compiled: " + str(path))
    require(set(selected) == expected, "missing crypto translation unit")
    for name in instrument.SOURCES:
        matches = [row for row in base_commands if Path(row["file"]) ==
                   BASE_BUILD / "generated" / (name + ".c")]
        require(len(matches) == 1, "baseline C input is missing/duplicate")
        actual = normalized_options(selected[BUILD / "generated" / (name + ".c")], SOURCE, BUILD)
        original = normalized_options(matches[0], BASE_RECORDED_SOURCE, BASE_BUILD)
        require(actual == original, "C options differ from historical baseline: " + name)
    require((BUILD / "zephyr/.config").read_bytes() == (BASE_BUILD / "zephyr/.config").read_bytes(),
            "Kconfig differs from historical baseline")
    require((BUILD / "fndsa_dtcm_linker.ld").read_bytes() ==
            (BASE_BUILD / "fndsa_dtcm_linker.ld").read_bytes(), "linker placement policy differs")
    require((BUILD / "benchmark.c").read_bytes() == (BASE_BUILD / "benchmark.c").read_bytes(),
            "workload differs from historical baseline")
    return {"artifacts": {name: sha(BUILD / name) for name in ARTIFACTS},
            "compiled_crypto": sorted(str(p) for p in selected),
            "same_kconfig": True, "same_c_options_except_backend_and_label": True,
            "same_linker_policy": True, "same_workload": True,
            "instrumentation_recipe_matches_historical_generated_sources": True}


def write(data):
    MANIFEST.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")


def check():
    saved = json.loads(MANIFEST.read_text())
    require(saved.get("ready"), "build is not recorded")
    require(saved["inputs"] == snapshot(), "inputs changed after build")
    require(saved["build"] == inspect_build(), "build changed after recording")
    return saved


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("prepare", "record", "check"))
    args = parser.parse_args()
    if args.action == "prepare":
        write({"ready": False, "inputs": snapshot()})
    elif args.action == "record":
        saved = json.loads(MANIFEST.read_text())
        require(saved["inputs"] == snapshot(), "inputs changed during build")
        saved.update(ready=True, build=inspect_build())
        write(saved)
    else:
        check()
    print("PROVENANCE " + args.action + " PASS")


if __name__ == "__main__":
    main()
