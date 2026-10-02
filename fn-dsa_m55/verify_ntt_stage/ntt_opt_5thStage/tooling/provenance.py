#!/usr/bin/env python3
"""Record pinned optimizer, Python dependency, generator and output identities."""
import hashlib
import importlib.metadata
import json
from pathlib import Path
import platform
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    vendor = ROOT / "tooling/slothy"
    commit = subprocess.check_output(["git", "-C", str(vendor), "rev-parse", "HEAD"], text=True).strip()
    assert commit == "55983e6760e98aece5359055085a7def96c688b7"
    subprocess.run(["git", "-C", str(vendor), "diff", "--exit-code", "HEAD"], check=True, capture_output=True)
    files = [ROOT / "tooling" / name for name in
             ("fndsa_slothy_adapter.py", "generate.py", "check_schedule.py", "requirements.lock")]
    files += [ROOT / name / "mq_cm55.s" for name in ("ref", "slothyA", "slothyB")]
    files += [ROOT / "tooling/logs/manifest.json", ROOT / "tooling/logs/instruction_model.json"]
    report = dict(slothy_upstream="https://github.com/slothy-optimizer/slothy.git", slothy_commit=commit,
                  slothy_tracked_files_unmodified=True, python=platform.python_version(),
                  packages={p: importlib.metadata.version(p) for p in
                            ("slothy", "ortools", "sympy", "numpy", "pandas", "unicorn", "protobuf")},
                  files={str(p.relative_to(ROOT)): sha(p) for p in files},
                  generation_command="tooling/venv/bin/python tooling/generate.py --timeout 8",
                  B_strategy="paper halving heuristic via genuine SlothyBase linear solves of b;a",
                  modulo_solver_enabled=False,
                  warning="Re-solving can choose different schedules; retained manifest is authoritative for this measured image.")
    (ROOT / "tooling/logs/provenance.json").write_text(json.dumps(report, indent=2) + "\n")
    print("Optimizer/dependency/source provenance recorded")


if __name__ == "__main__": main()
