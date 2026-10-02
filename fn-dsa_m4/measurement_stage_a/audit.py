#!/usr/bin/env python3
"""Offline independent audit; never connects to a debugger or changes a board."""
import hashlib
import json
from pathlib import Path
import statistics
import subprocess

ROOT = Path(__file__).resolve().parent
REF = ROOT.parent / "ref"

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

session = json.loads((ROOT / "session.json").read_text())
status = json.loads((ROOT / "status.json").read_text())
results = json.loads((ROOT / "results.json").read_text())
oracle = json.loads((ROOT / "build/host_oracle.json").read_text())
old = json.loads((ROOT.parent / "measurement/results.json").read_text())
assert status["phase"] == "측정·검증·Flash 복원 완료"
assert "전체 Flash가 백업과 일치" in session["restoration"]
assert session["backup_verified"] and session["warmup_verified"]
assert sha(Path(session["backup_file"])) == session["backup_sha256"]
assert Path(session["backup_file"]).read_bytes()[0x1C0000:] == b"\xff" * 0x40000
assert sha(ROOT / "build/fndsa_m4.elf") == session["elf_sha256"]
assert sha(ROOT / "build/fndsa_m4.bin") == session["binary_sha256"]
for name, expected in session["source_hashes"].items():
    assert sha(REF / name) == expected, "Changed source: " + name
for name, expected in session["harness_hashes"].items():
    assert sha(ROOT / name) == expected, "Changed harness: " + name
assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REF, text=True).strip() == session["source_commit"]
assert not subprocess.check_output(["git", "status", "--porcelain", "--untracked-files=no"], cwd=REF, text=True).strip()
header = results["header"]
assert header == status["header"]
assert header["state"] == 0x600D0000 and header["error"] == 0
assert header["counts"] == [[100, 100, 100], [100, 100, 100]]
assert header["warmup_fingerprint"] == oracle["warmup_fingerprint"]
assert header["fingerprint"] == oracle["fingerprint"]
assert header["core_clock_hz"] == 24000000 and header["flash_acr"] == 1
assert header["rcc_cfgr"] == 0x400 and header["vtor"] == 0x081C0000
assert header["primask"] == 1 and header["assembly"] == 1 and header["gcc_version"] == 130201
comparisons = []
for degree, previous in zip(results["measurements"], old["measurements"]):
    assert degree["degree"] == previous["degree"]
    for operation, data in degree["operations"].items():
        values = data["cycles"]
        assert len(values) == data["count"] == 100 and all(0 < x < 2**32 for x in values)
        assert data["mean"] == statistics.mean(values)
        assert data["median"] == statistics.median(values)
        assert data["stdev"] == statistics.stdev(values)
        assert data["min"] == min(values) and data["max"] == max(values)
        before = previous["operations"][operation]["mean"]
        comparisons.append({"degree": degree["degree"], "operation": operation,
                            "mean_cycles": data["mean"], "previous_mean_cycles": before,
                            "difference_percent": (data["mean"] / before - 1) * 100})
binary = (ROOT / "build/fndsa_m4.bin").read_bytes()
previous_binary = (ROOT.parent / "measurement/build/fndsa_m4.bin").read_bytes()
assert len(binary) == len(previous_binary)
diff = [i for i, (a, b) in enumerate(zip(previous_binary, binary)) if a != b]
assert diff == [51998] and previous_binary[51998] == 0x30 and binary[51998] == 0
audit = {"passed": True, "kind": "offline post-measurement audit; board restoration relies on recorded verify_image result",
         "source_commit": session["source_commit"], "stlink_serial": session["stlink_serial"],
         "fresh_backup_sha256": session["backup_sha256"], "total_timed_calls": 600,
         "host_fingerprints_match": True, "binary_difference_from_previous": "WFI to NOP at offset 51998 only; outside measured calls",
         "comparison_with_previous_flash_run": comparisons}
(ROOT / "audit.json").write_text(json.dumps(audit, indent=2, ensure_ascii=False) + "\n")
print(json.dumps(audit, indent=2, ensure_ascii=False))
