#!/usr/bin/env python3
"""RAM-load the isolated comparison image and preserve its complete log."""
from datetime import datetime, timezone
from pathlib import Path
import fcntl
import hashlib
import json
import os
import re
import subprocess
from tools.audit_layers import audit as audit_layers
from tools.audit_tail import audit as audit_tail

ROOT = Path(__file__).resolve().parent
ENV = ROOT.parents[1] / "measurement_mlkem_native" / "env"
BIN = ENV / "arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi" / "bin"
LOADER = ROOT.parents[1] / "ntt_opt_slothy" / "measurement" / "exec_board.py"
ELF = ROOT / "build" / "board" / "zephyr" / "zephyr.elf"
layer_audit = audit_layers()
tail_audit = audit_tail()

# Serialize physical-board access with the other FN-DSA experiments.
locks = []
for path in (ROOT.parents[1] / "measurement_mlkem_native" / "n657-board.lock",
             ROOT.parents[1] / "function_compare/fft_native_fp64/build/board.lock"):
    lock = path.open("a")
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    locks.append(lock)

stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
out = ROOT / "results" / stamp
out.mkdir(parents=True)
sources = [p for d in ("tw32_mve", "bench", "tests", "reference", "tw32_scalar")
           for p in (ROOT / d).glob("*") if p.suffix in (".c", ".h", ".s")]
assert all(p.stat().st_mtime <= ELF.stat().st_mtime for p in sources), "Rebuild stale ELF"
hashes = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
          for p in sources}
hashes["zephyr.elf"] = hashlib.sha256(ELF.read_bytes()).hexdigest()
(out / "manifest.json").write_text(json.dumps(hashes, indent=2) + "\n")
(out / "layer_source_audit.json").write_text(json.dumps(layer_audit, indent=2) + "\n")
(out / "tail_audit.json").write_text(json.dumps(tail_audit, indent=2) + "\n")
print(f"BOARD_START {out}", flush=True)
env = os.environ.copy()
env.update({
    "FNDSA_LOADER_MODE": "upstream",
    "MLKEM_NATIVE_PINNED_ROOT": str(ENV / "mlkem-native-637d076aa113d8faaec2277ed4a46b657acaf35f"),
    "OPENOCD": str(ENV / "openocd-4e9b167" / "bin" / "openocd"),
    "OPENOCD_SERIAL": "003C00223335510735383531",
    "OPENOCD_SPEED": "8000",
    "OPENOCD_TRANSPORT": "swd",
    "OPENOCD_SCRIPTS": str(ENV / "openocd-4e9b167" / "share" / "openocd" / "scripts"),
    "OPENOCD_INTERFACE": "interface/stlink.cfg",
    "OPENOCD_TARGET": "target/stm32n6x.cfg",
    "GDB_PORT": "3351",
    "GDB_RUN_TIMEOUT": "2400",
    "SWO_TRACECLK": "100000000",
    "SWO_PIN_FREQ": "1000000",
    "SWO_FORMATTER": "0",
    "GDB": str(BIN / "arm-none-eabi-gdb"),
    "NM": str(BIN / "arm-none-eabi-nm"),
    "READELF": str(BIN / "arm-none-eabi-readelf"),
    "PYTHONDONTWRITEBYTECODE": "1",
})
cmd = [str(ENV / "build-venv" / "bin" / "python"), str(LOADER), "--verbose", str(ELF)]
proc = subprocess.run(cmd, text=True, stdout=subprocess.PIPE,
                      stderr=subprocess.STDOUT, env=env, timeout=2500)
raw = proc.stdout
(out / "raw.log").write_text(raw)
print(raw, end="")
required = ("TW_COMPARE_BEGIN", "PRIMITIVE_CHECK cases=8000 mismatches=0",
            "DS_SPAN_EQ cases=1408 mismatches=0 comparison=ALL_BYTES",
            "DS_TAIL_EQ cases=224 mismatches=0 comparison=ALL_BYTES",
            "DS_TRANSFORM_EQ cases=180 mismatches=0 comparison=ALL_BYTES",
            "DS_LAYER_DONE cases=880 mismatches=0 accounting_errors=0",
            "MEMORY_CANARY mismatches=0", "NUCLEO_EXIT_CODE=0",
            "TRANSFORM_ERROR", "TW_COMPARE_DONE primitive_status=PASS")
missing = [x for x in required if x not in raw]
if len(re.findall(r"^DS_LAYER_TOTAL ", raw, re.M)) != 4:
    missing.append("4 DS_LAYER_TOTAL records")
if len(re.findall(r"^DS_LAYER ", raw, re.M)) != 34:
    missing.append("34 DS_LAYER records")
for reg in ("CFSR", "HFSR", "AFSR"):
    if re.findall(r"^" + reg + r"=(0x[0-9a-f]+)$", raw, re.M) != ["0x0"]:
        missing.append(reg + "=0x0")
for phase in ("START", "END"):
    if f"TCM_CONTROL_{phase}=0x99" not in raw:
        missing.append("TCM_CONTROL_" + phase)
    mscr = re.search(r"^TCM_MSCR_" + phase + r"=(0x[0-9a-f]+)$", raw, re.M)
    if not mscr or int(mscr[1], 16) & 0x12 != 2:
        missing.append("TCM_MSCR_" + phase)
if proc.returncode or missing:
    raise SystemExit(f"board run failed: rc={proc.returncode}, missing={missing}, log={out}")
print(f"VALIDATED_LOG {out / 'raw.log'}")
