#!/usr/bin/env python3
"""Offline audit only: never connects to a board or changes measured files."""
import datetime
import hashlib
import json
from pathlib import Path
import statistics
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent
REF, BUILD = ROOT.parent / "ref", ROOT / "build"
PREFIX = Path("/private/tmp/arm-gnu-toolchain-13.2.Rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-")
results = json.loads((ROOT / "results.json").read_text())
session = json.loads((ROOT / "session.json").read_text())
words = struct.unpack("<640I", (ROOT / "logs/mailbox.bin").read_bytes())
lines = []
def record(message):
    lines.append(message)
    print(message, flush=True)

assert results["header"]["state"] == 0x600D0000 and results["header"]["error"] == 0
assert results["header"]["counts"] == [[100, 100, 100], [100, 100, 100]]
for d, item in enumerate(results["measurements"]):
    for op, name in enumerate(["keygen", "sign", "verify"]):
        stats = item["operations"][name]
        values = list(words[40+(d*3+op)*100:40+(d*3+op+1)*100])
        assert values == stats["cycles"] and len(values) == 100
        assert stats["mean"] == statistics.mean(values)
        assert stats["median"] == statistics.median(values)
        assert stats["stdev"] == statistics.stdev(values)
        assert stats["min"] == min(values) and stats["max"] == max(values)
record("PASS: all 600 raw mailbox cycles match JSON; mean/median/sample-SD/min/max recomputed.")
for name, expected in session["source_hashes"].items():
    assert hashlib.sha256((REF / name).read_bytes()).hexdigest() == expected, name
for name, expected in [("fndsa_m55.elf", session["elf_sha256"]), ("fndsa_m55.bin", session["binary_sha256"])]:
    assert hashlib.sha256((BUILD / name).read_bytes()).hexdigest() == expected, name
record("PASS: current source, ELF and binary SHA-256 match the measured session.")
m4 = json.loads((ROOT.parent.parent / "fn-dsa_m4/measurement/results.json").read_text())
assert results["header"]["fingerprint"] == m4["header"]["fingerprint"] == session["host_oracle"]["fingerprint"]
assert results["header"]["warmup_fingerprint"] == session["host_oracle"]["warmup_fingerprint"]
record("PASS: both final fingerprints match the completed M4 measurement and scalar host oracle.")

cpu_m4 = ["-mcpu=cortex-m4", "-mfpu=fpv4-sp-d16"]
cpu_m55 = ["-mcpu=cortex-m55+nomve", "-mfpu=auto"]
common = ["-mthumb", "-mfloat-abi=hard"]
for label, cpu, defs, expected_ok in [
    ("Original M4 path", cpu_m4, ["-DFNDSA_ASM_CORTEXM4=1"], True),
    ("Explicit M55 assembly compatibility", cpu_m55, ["-DFNDSA_ASM_CORTEXM4=1", "-DFNDSA_ASM_CORTEXM55=1"], True),
    ("M55 without explicit compatibility", cpu_m55, ["-DFNDSA_ASM_CORTEXM4=1"], False),
    ("M55 compatibility with ASM disabled", cpu_m55, ["-DFNDSA_ASM_CORTEXM4=0", "-DFNDSA_ASM_CORTEXM55=1"], False),
]:
    command = [str(PREFIX)+"gcc"] + common + cpu + defs + ["-I", str(REF), "-include", "inner.h", "-fsyntax-only", "-x", "c", "/dev/null"]
    run = subprocess.run(command, capture_output=True, text=True)
    assert (run.returncode == 0) == expected_ok, run.stderr
    record("PASS: " + label + (" accepted" if expected_ok else " rejected as intended"))

# Unlinked .text bytes should be identical: .s retains its M4 .cpu directive.
# External calls still have relocation placeholders, so this does not claim
# that the two final linked executables have identical addresses or timing.
with tempfile.TemporaryDirectory(prefix="fndsa-m55-asm-audit-") as tmp:
    for name in ["codec_cm4", "mq_cm4", "sha3_cm4", "sign_fpr_cm4", "sign_sampler_cm4"]:
        chunks = []
        for label, cpu in [("m4", cpu_m4), ("m55", cpu_m55)]:
            obj, binary = Path(tmp)/(name+label+".o"), Path(tmp)/(name+label+".bin")
            subprocess.run([str(PREFIX)+"gcc"]+common+cpu+["-c", str(REF/(name+".s")), "-o", str(obj)], check=True)
            subprocess.run([str(PREFIX)+"objcopy", "-O", "binary", "-j", ".text", str(obj), str(binary)], check=True)
            chunks.append(binary.read_bytes())
        assert chunks[0] == chunks[1], name
        record(f"PASS: {name}.s assembled .text identical under M4/M55 flags ({len(chunks[0])} bytes).")

cycle_sum = sum(sum(op["cycles"]) for item in results["measurements"] for op in item["operations"].values())
events = (ROOT / "logs/events.log").read_text().splitlines()
go = next(line for line in events if "OpenOCD: write_memory 0x341ff088" in line)
done = next(line for line in events if "progress counts=[[100, 100, 100], [100, 100, 100]]" in line)
observed = (datetime.datetime.fromisoformat(done.split()[0])-datetime.datetime.fromisoformat(go.split()[0])).total_seconds()
nominal_seconds = cycle_sum/600000000
assert nominal_seconds < observed < (cycle_sum+(1<<32))/600000000
record(f"PASS: summed measured duration {nominal_seconds:.6f}s <= completion observation {observed:.6f}s.")
record("Under the nominal CPU clock, even one uncounted 2^32-cycle wrap would exceed the observed whole-run time; a consistency check, not external clock calibration.")
(ROOT / "logs/artifact_audit.log").write_text("\n".join(lines)+"\n")
