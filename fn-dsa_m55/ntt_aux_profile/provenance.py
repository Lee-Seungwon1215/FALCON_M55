#!/usr/bin/env python3
"""Bind generated sources and ELF to local ref_preslothy; no board access."""
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
PREVIOUS = WORK / "stage_profile_compare"
EXPECTED_TREE = "1bee63df84452c426acc1b045a25d771a456d76ead95b3ee9cc2c39fe354daae"
ASM = "codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 kgen_mp31_cm55".split()
ARTIFACTS = ("zephyr/zephyr.elf", "zephyr/zephyr.map", "zephyr/.config",
             "compile_commands.json", "CMakeCache.txt", "fndsa_dtcm_linker.ld")

def require(ok, reason):
    if not ok:
        raise RuntimeError(reason)

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def snapshot(mode):
    build = ROOT / "build" / mode
    paths = sorted(p for p in SOURCE.iterdir() if p.suffix in (".c", ".h", ".s"))
    require(len(paths) == 31 and all(p.is_file() and not p.is_symlink() for p in paths),
            "expected 31 local crypto sources")
    h = hashlib.sha256()
    for p in paths:
        h.update(p.name.encode() + b"\0" + p.read_bytes() + b"\0")
    require(h.hexdigest() == EXPECTED_TREE, "crypto tree differs from adopted ref_preslothy")
    generated = {}
    for name in instrument.SOURCES:
        content, metadata = instrument.expected(SOURCE, name, mode)
        p = build / "generated" / (name + ".c")
        require(p.read_text() == content, "generated source drift: " + name)
        generated[p.name] = metadata
    saved = json.loads((build / "generated/manifest.json").read_text())
    require(saved == dict(source=str(SOURCE), mode=mode, files=generated), "instrumentation manifest drift")
    return dict(mode=mode, source_dir=str(SOURCE), source_tree_sha256=h.hexdigest(),
                source_files={p.name: sha(p) for p in paths}, generated=generated,
                measurement_files={n: sha(ROOT / n) for n in (
                    "profile.c", "profile.h", "wrappers.c", "instrument.py", "provenance.py",
                    "CMakeLists.txt", "build.sh")},
                workload_sha256=sha(WORK / "ntt_profile_compare/benchmark.c"))

def normalized(row, build, profile_root):
    args = row.get("arguments") or shlex.split(row["command"])
    return [s.replace(str(build), "<BUILD>").replace(str(profile_root), "<PROFILE>")
            for s in args if not s.startswith("-DPROFILE_CANDIDATE=")]

def inspect_build(mode):
    build = ROOT / "build" / mode
    oldbuild = PREVIOUS / "build/preslothy"
    commands = json.loads((build / "compile_commands.json").read_text())
    prior = json.loads((oldbuild / "compile_commands.json").read_text())
    expected = {build / "generated" / (n + ".c") for n in instrument.SOURCES}
    expected |= {SOURCE / (n + ".s") for n in ASM}
    selected = {}
    for row in commands:
        p = Path(row["file"])
        if p.parent in (SOURCE, build / "generated"):
            require(p in expected and p not in selected, "wrong crypto input: " + str(p))
            args = shlex.split(row["command"])
            require(all(flag in args for flag in ("-O3", "-DFNDSA_MVE_MP31=1",
                "-DFNDSA_ASM_CORTEXM4=1", "-DFNDSA_ASM_CORTEXM55=1")), "wrong compiler flags")
            selected[p] = row
        else:
            require(not any(s in str(p) for s in ("/ntt_opt/", "/ntt_opt_slothy/", "/M55_ref/")),
                    "other crypto implementation compiled")
    require(set(selected) == expected, "missing crypto compilation unit")
    for name in instrument.SOURCES:
        row = selected[build / "generated" / (name + ".c")]
        old = [r for r in prior if Path(r["file"]) == oldbuild / "generated" / (name + ".c")]
        require(len(old) == 1, "missing old compile entry")
        require(normalized(row, build, ROOT) == normalized(old[0], oldbuild, PREVIOUS),
                "C options differ from prior profile: " + name)
    for name in ("zephyr/.config", "fndsa_dtcm_linker.ld", "benchmark.c"):
        require((build / name).read_bytes() == (oldbuild / name).read_bytes(), "prior build policy differs: " + name)
    return dict(artifacts={n: sha(build / n) for n in ARTIFACTS},
                compiled_crypto=sorted(str(p) for p in selected),
                same_c_options=True, same_kconfig=True, same_linker_policy=True, same_workload=True)

def check(mode):
    saved = json.loads((ROOT / "build" / mode / "profile_provenance.json").read_text())
    require(saved.get("ready"), "unrecorded build")
    require(saved["inputs"] == snapshot(mode), "inputs changed since build")
    require(saved["build"] == inspect_build(mode), "artifacts changed since build")
    return saved

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("prepare", "record", "check"))
    parser.add_argument("mode", choices=("control", "detailed"))
    args = parser.parse_args()
    path = ROOT / "build" / args.mode / "profile_provenance.json"
    if args.action == "prepare":
        path.write_text(json.dumps(dict(ready=False, inputs=snapshot(args.mode)), indent=2) + "\n")
    elif args.action == "record":
        saved = json.loads(path.read_text())
        require(saved["inputs"] == snapshot(args.mode), "inputs changed during build")
        saved.update(ready=True, build=inspect_build(args.mode))
        path.write_text(json.dumps(saved, indent=2) + "\n")
    else:
        check(args.mode)
    print("PROVENANCE", args.action, args.mode, "PASS")

if __name__ == "__main__":
    main()
