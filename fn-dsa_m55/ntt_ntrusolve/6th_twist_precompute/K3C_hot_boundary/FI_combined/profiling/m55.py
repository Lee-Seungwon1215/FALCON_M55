#!/usr/bin/env python3
"""K3-C FI-local provenance checks and adapter to the board runner.

Only `run` accesses hardware. No H0/L2 cryptographic sources are selected.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import shlex
import shutil
import sys

sys.dont_write_bytecode = True
PROFILE = Path(__file__).resolve().parent
SOURCE = PROFILE.parent
WORK = PROFILE.parents[4]
MEAS = WORK / "measurement_mlkem_native"
COMMON_RUNNER = WORK / "ntt_opt_3rdStage/run_stage3.py"
CANDIDATE_PREFIX = "d1"
PIN = MEAS / "env/mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f"
C_NAMES = ("codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 "
           "kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly "
           "sign_fpr sign_sampler vrfy").split()
S_NAMES = ("codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 "
           "kgen_mp31_cm55").split()
# Contract of the pinned benchmark.c: 308 primes, 7 vectorized sizes,
# 2 root tables of 1024 entries, 16 canonical + 14 signed patterns.
AUDIT_PRIMES = 308
AUDIT_LOGNS = range(4, 11)
AUDIT_TRANSFORMS = AUDIT_PRIMES * len(AUDIT_LOGNS)
AUDIT_ROUNDING_CASES = AUDIT_PRIMES * 2 * 1024 * (16 + 14)
AUDIT_BATCHES = 10
AUDIT_CALLS = 100


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_hashes():
    paths = sorted(p for p in SOURCE.iterdir() if p.suffix in (".c", ".h", ".s"))
    require(all(p.is_file() and not p.is_symlink() for p in paths),
            "cryptographic sources must be local regular files")
    return {p.name: sha(p) for p in paths}


def build_dir(kind):
    return PROFILE / "build" / ("k3c-fi-hot-boundary-m55-" + kind)


def write_json(path, data):
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")


def preflight():
    needed = [MEAS / "env/environment.sh", MEAS / "app/CMakeLists.txt",
              MEAS / "app/fndsa.conf", MEAS / "exec_with_tcm_init.py", COMMON_RUNNER]
    needed += [PIN / "test/zephyr/app" / name for name in
               ("prj.conf", "nucleo_n657x0_q.conf", "nucleo_n657x0_q.overlay")]
    needed += [SOURCE / (name + ".c") for name in C_NAMES]
    needed += [SOURCE / (name + ".s") for name in S_NAMES]
    require(all(p.is_file() for p in needed),
            "missing dependency: " + ", ".join(str(p) for p in needed if not p.is_file()))
    return {"source_dir": str(SOURCE), "harness_dir": str(MEAS),
            "crypto_source_count": len(source_hashes()),
            "cryptographic_inputs": "this candidate folder only", "hardware_access": False}


def prepare(kind):
    preflight()
    build = build_dir(kind)
    build.mkdir(parents=True, exist_ok=True)
    write_json(build / "h1_build.json", {
        "ready": False, "kind": kind, "source_dir": str(SOURCE),
        "sources": source_hashes(),
    })


def inspect_build(kind):
    build = build_dir(kind)
    commands = json.loads((build / "compile_commands.json").read_text())
    expected = {SOURCE / (name + ".c") for name in C_NAMES}
    expected |= {SOURCE / (name + ".s") for name in S_NAMES}
    seen = set()
    for row in commands:
        path = Path(row["file"])
        if not path.is_absolute():
            path = Path(row["directory"]) / path
        path = path.resolve()
        if path.parent == SOURCE:
            require(path in expected, "unexpected H1 translation unit: " + str(path))
            args = row.get("arguments") or shlex.split(row["command"])
            optimizations = [arg for arg in args if re.fullmatch(r"-O(?:[0-3sgz]|fast)", arg)]
            require(optimizations and optimizations[-1] == "-O3", "last optimization is not -O3")
            require("-DFNDSA_MVE_MP31=1" in args, "MVE mp31 backend not enabled")
            for define in ("FNDSA_MP31_SELFTEST", "FNDSA_MP31_SIGNED_SELFTEST"):
                require(("-D" + define + "=1" in args) == (kind == "audit"),
                        "unexpected self-test setting: " + define)
            seen.add(path)
        else:
            require(MEAS in path.parents or build in path.parents,
                    "source outside H1, generated build files or common harness: " + str(path))
    require(seen == expected, "missing H1 sources: " + str(expected - seen))
    baseline = MEAS / ("build-ntru-stage2-l2" + ("_audit" if kind == "audit" else ""))
    baseline_config = baseline / "zephyr/.config"
    same_config = None
    if baseline_config.is_file():
        same_config = (build / "zephyr/.config").read_bytes() == baseline_config.read_bytes()
        require(same_config, "Kconfig differs from the existing L2 measurement")
    artifacts = ("zephyr/zephyr.elf", "zephyr/zephyr.map", "zephyr/.config",
                 "compile_commands.json", "CMakeCache.txt")
    return {"compiled_crypto_files": sorted(p.name for p in seen),
            "last_crypto_optimization": "-O3", "mve_mp31": True,
            "l2_kconfig_identical": same_config,
            "artifacts": {name: sha(build / name) for name in artifacts}}


def record(kind):
    path = build_dir(kind) / "h1_build.json"
    manifest = json.loads(path.read_text())
    require(manifest["sources"] == source_hashes(), "sources changed while building; rebuild")
    manifest.update(inspect_build(kind))
    manifest["ready"] = True
    write_json(path, manifest)
    return manifest


def check_built(kind):
    manifest = json.loads((build_dir(kind) / "h1_build.json").read_text())
    require(manifest["ready"] and manifest["kind"] == kind
            and manifest["source_dir"] == str(SOURCE), "no completed H1 build for this path")
    require(manifest["sources"] == source_hashes(), "source changed since build; rebuild first")
    current = inspect_build(kind)
    require(manifest["artifacts"] == current["artifacts"], "build artifacts changed; rebuild first")
    return manifest


def parse_audit(raw):
    raw = re.sub(r"Info : [^\n]*\n", "", raw)
    def records(prefix):
        return [line for line in raw.splitlines()
                if line == prefix or line.startswith(prefix + " ")]

    def fields_for(prefix, expected_keys):
        lines = records(prefix)
        require(len(lines) == 1, "missing/duplicate " + prefix)
        items = []
        for token in lines[0][len(prefix):].split():
            match = re.fullmatch(r"([a-z_]+)=([0-9]+(?:\.\.[0-9]+)?)", token)
            require(match is not None, "malformed " + prefix + " field")
            items.append(match.groups())
        fields = dict(items)
        require(len(fields) == len(items) and set(fields) == set(expected_keys),
                "missing/duplicate/unexpected " + prefix + " fields")
        require(all(re.fullmatch(r"[0-9]+", value) for key, value in items if key != "logn"),
                "invalid numeric " + prefix + " field")
        return fields, lines[0][len(prefix) + 1:]

    fields, _ = fields_for("MP31_EXACT", (
        "primes", "logn", "transforms", "forward_mismatches", "inverse_mismatches",
        "roundtrip_mismatches", "max_mod_error", "first_prime", "first_logn", "first_index"))
    require(int(fields["primes"]) == AUDIT_PRIMES, "unexpected RNS prime count")
    require(fields["logn"] == "4..10", "unexpected RNS logn coverage")
    require(int(fields["transforms"]) == AUDIT_TRANSFORMS, "incomplete RNS transform coverage")
    for key in ("forward_mismatches", "inverse_mismatches", "roundtrip_mismatches", "max_mod_error"):
        require(int(fields[key]) == 0, "nonzero " + key)
    require(int(fields["first_prime"]) == 0xFFFFFFFF
            and int(fields["first_logn"]) == int(fields["first_index"]) == 0,
            "inconsistent RNS failure marker")
    rounding, rounding_text = fields_for("MP31_ROUNDING", (
        "cases", "mismatches", "range_errors", "first_prime", "first_root"))
    require(int(rounding["cases"]) == AUDIT_ROUNDING_CASES, "incomplete rounding coverage")
    require(int(rounding["mismatches"]) == int(rounding["range_errors"]) == 0,
            "rounding audit failed")
    require(int(rounding["first_prime"]) == 0xFFFFFFFF and int(rounding["first_root"]) == 0,
            "inconsistent rounding failure marker")
    cycles = []
    for line in records("MP31_CYCLES"):
        match = re.fullmatch(r"MP31_CYCLES logn=([0-9]+) direction=(forward|inverse) batch=([0-9]+) "
                             r"calls=([0-9]+) total=([0-9]+) per_call=([0-9]+) twiddle_prepare=included", line)
        require(match is not None, "malformed RNS cycle batch")
        row = match.groups()
        calls, total, per_call = map(int, row[3:])
        require(calls == AUDIT_CALLS, "unexpected RNS cycle call count")
        require(0 < total <= 0xFFFFFFFFFFFFFFFF and per_call > 0,
                "invalid RNS cycle count")
        require(per_call == total // calls, "inconsistent RNS per-call cycles")
        cycles.append(row)
    expected = {(str(k), d, str(b)) for k in AUDIT_LOGNS
                for d in ("forward", "inverse") for b in range(AUDIT_BATCHES)}
    require(len(cycles) == len(expected) and {c[:3] for c in cycles} == expected,
            "missing/duplicate/unexpected RNS cycle batches")
    return {"exact": fields, "rounding": rounding_text, "cycle_batches": cycles}


def run(kind, mode, label):
    require(re.fullmatch(r"[a-z0-9][a-z0-9_-]*", label or ""),
            "provide a non-empty LABEL using lowercase letters, digits, _ or -")
    require(not (kind == "audit" and mode == "full"), "audit is for pilot, not full performance")
    manifest = check_built(kind)
    candidate = CANDIDATE_PREFIX + "-" + label + "-" + kind
    out = PROFILE / "results" / candidate
    approved = out / (mode + "_validated.json")
    require(not approved.exists(), "this mode/label already has a result; use a new label")
    spec = importlib.util.spec_from_file_location("h1_common_runner", COMMON_RUNNER)
    runner = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    runner.ROOT = PROFILE
    runner.CANDIDATES = {candidate: (SOURCE, build_dir(kind))}
    sys.argv = [sys.argv[0], candidate, mode]
    rc = runner.main()
    if rc:
        return rc
    validation = json.loads(approved.read_text())
    run_dir = Path(validation["run_directory"])
    try:
        check_built(kind)
        if kind == "audit":
            write_json(run_dir / "rns_audit.json", parse_audit((run_dir / "raw.log").read_text()))
        source_archive = run_dir / "source"
        source_archive.mkdir()
        for name in manifest["sources"]:
            shutil.copy2(SOURCE / name, source_archive / name)
        for name in ("zephyr.elf", "zephyr.map", ".config"):
            shutil.copy2(build_dir(kind) / "zephyr" / name, run_dir / name)
        shutil.copy2(build_dir(kind) / "h1_build.json", run_dir / "h1_build.json")
    except Exception as exc:
        validation.update(valid=False, h1_validation_error=str(exc))
        write_json(approved, validation)
        run_meta = json.loads((run_dir / "run.json").read_text())
        run_meta.update(valid=False, h1_validation_error=str(exc))
        write_json(run_dir / "run.json", run_meta)
        raise
    print("H1_ARCHIVE=" + str(run_dir), flush=True)
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    check = commands.add_parser("check", help="read-only checks; no board access")
    check.add_argument("--built", choices=("perf", "audit"))
    for name in ("prepare", "record"):
        sub = commands.add_parser(name, help="internal build-manifest step; no board access")
        sub.add_argument("kind", choices=("perf", "audit"))
    board = commands.add_parser("run", help="RESET/LOAD/RUN the connected M55")
    board.add_argument("kind", choices=("perf", "audit"))
    board.add_argument("mode", choices=("pilot", "full"))
    board.add_argument("--label", required=True)
    args = parser.parse_args()
    if args.command == "run":
        return run(args.kind, args.mode, args.label)
    if args.command == "prepare":
        prepare(args.kind)
        return 0
    result = (record(args.kind) if args.command == "record" else
              check_built(args.built) if args.built else preflight())
    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, OSError, ValueError, KeyError) as exc:
        print("H1_ERROR: " + str(exc), file=sys.stderr)
        raise SystemExit(1)
