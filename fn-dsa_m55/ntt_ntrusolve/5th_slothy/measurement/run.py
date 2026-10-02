#!/usr/bin/env python3
"""Build/source provenance and fail-closed validation of new RNS measurements."""
import argparse
import hashlib
import importlib.util
import json
import re
from pathlib import Path
import shlex
import shutil
import sys

ROOT = Path(__file__).resolve().parent
STAGE = ROOT.parent
WORK = STAGE.parents[1]
sys.path.insert(0, str(ROOT))
import runner

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def hashes(source):
    return {p.name:sha(p) for p in sorted(source.iterdir()) if p.suffix in (".c", ".h", ".s")}

def manifest(source, build):
    commands = json.loads((build / "compile_commands.json").read_text())
    seen = []
    for row in commands:
        p = Path(row["file"]).resolve()
        if p.parent == source:
            assert p.is_file() and not p.is_symlink()
            args = shlex.split(row["command"])
            assert [x for x in args if x.startswith("-O")][-1] == "-O3"
            assert "-DFNDSA_MVE_MP31=1" in args
            seen.append(p.name)
        else:
            assert ROOT in p.parents or WORK / "measurement_mlkem_native" in p.parents or build in p.parents, p
    assert "kgen_mp31_cm55.s" in seen and "mq_cm55.s" in seen
    return {"source":str(source), "source_hashes":hashes(source), "compiled_sources":sorted(seen),
            "artifacts":{s:sha(build/s) for s in ("zephyr/zephyr.elf", "zephyr/zephyr.map", "zephyr/.config", "compile_commands.json")}}

def main():
    p = argparse.ArgumentParser()
    p.add_argument("variant", choices=("baseline", "slothyA", "slothyB", "ref_slothy"))
    p.add_argument("kind", choices=("audit", "perf"))
    p.add_argument("action", choices=("record", "pilot", "full"))
    p.add_argument("--label", default="v1")
    a = p.parse_args()
    source = (STAGE / a.variant).resolve() if a.variant != "ref_slothy" else (STAGE.parent / "ref_slothy").resolve()
    build = source / "build" / a.kind
    current = manifest(source, build)
    record = build / "provenance.json"
    if a.action == "record":
        record.write_text(json.dumps(current, indent=2)+"\n")
        print("RECORDED", record)
        return 0
    assert json.loads(record.read_text()) == current, "source or ELF changed since build"
    assert a.kind != "audit" or a.action == "pilot"
    name = a.variant + "-" + a.kind + "-" + a.label
    prior = ROOT / "results" / name / (a.action+"_validated.json")
    if prior.exists() and json.loads(prior.read_text()).get("valid"):
        raise RuntimeError("This validated label already exists; use a fresh label")
    runner.ROOT = ROOT
    runner.CANDIDATES = {name:(source, build)}
    sys.argv = [sys.argv[0], name, a.action]
    rc = runner.main()
    if rc:
        return rc
    approved = ROOT / "results" / name / (a.action+"_validated.json")
    data = json.loads(approved.read_text())
    dest = Path(data["run_directory"])
    try:
        assert manifest(source, build) == current
        if a.kind == "audit":
            # Existing strict all-prime audit parser, not candidate code.
            path = WORK / "ntt_ntrusolve/7th_coefficient_pipeline/K4C_combined/profiling/m55.py"
            spec = importlib.util.spec_from_file_location("prior_audit", path)
            audit = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(audit)
            result = audit.parse_audit((dest / "raw.log").read_text())
            raw = re.sub(r"Info : [^\n]*\n", "", (dest / "raw.log").read_text())
            assert re.findall(r"^MP31_BOUNDARY .+$", raw, re.M) == [
                "MP31_BOUNDARY cases=17248 mismatches=0 guard_errors=0 independent_inverse=1"]
            result["boundary"] = {"cases":17248, "mismatches":0, "guard_errors":0, "independent_inverse":True}
            (dest/"rns_audit.json").write_text(json.dumps(result, indent=2)+"\n")
        (dest / "source").mkdir()
        for name in current["source_hashes"]:
            shutil.copy2(source/name, dest/"source"/name)
        for name in ("zephyr.elf", "zephyr.map", ".config"):
            shutil.copy2(build/"zephyr"/name, dest/name)
        shutil.copy2(record, dest/"provenance.json")
    except Exception as exc:
        data.update(valid=False, validation_error=str(exc))
        approved.write_text(json.dumps(data, indent=2)+"\n")
        raise
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
