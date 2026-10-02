#!/usr/bin/env python3
"""Upstream runner with early fault capture and optional loader diagnostics.

The upstream checkout is not edited. All clock/Zephyr/timing/SWO behavior
remains upstream. The unsuccessful TCM initialization/CPU-copy experiment is
opt-in and is not adopted as the benchmark baseline.
"""
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
UPSTREAM = Path(os.environ["MLKEM_NATIVE_PINNED_ROOT"])
sys.path.insert(0, str(UPSTREAM / "test/zephyr/nucleo_n657x0_q"))
import exec_wrapper

original_build_run_script = exec_wrapper.build_run_script


def build_run_script(**kwargs):
    lines = original_build_run_script(**kwargs)
    if os.environ.get('FNDSA_LOADER_MODE', 'upstream') == 'cpu-copy':
        add_cpu_loader_diagnostic(lines)
    # Catch the first startup fault before uninitialized printk faults again.
    at = lines.index(f"jump {kwargs['reset_handler_jump']}")
    lines[at:at] = [f"hbreak {kwargs['hardfault_break']}",
                   "set $early_fault_bp = $bpnum"]
    at = lines.index(f"jump {kwargs['reset_handler_jump']}") + 1
    lines[at:at] = [
        f"if $pc != {kwargs['bootargs_break'].lstrip('*')}",
        "echo [[STARTUP-FAULT]]\\n", "info registers",
        "x/8wx $psp", "x/8wx $msp", "x/8i *(unsigned int*)($psp+24)",
        "x/6wx 0xE000ED28", "x/6wx 0xE001E000",
        "monitor reset_config none", "monitor reset run", "quit 1", "end",
        # Remove the temporary guard before upstream installs its fault BP.
        "delete $early_fault_bp",
        "echo TCM_MSCR_START=", "output/x *(unsigned int*)0xE001E000",
        "echo \\n",
    ]
    # Record ECC enable/check state after completion, before upstream resets.
    lines[-2:-2] = ["echo TCM_MSCR_END=",
                    "output/x *(unsigned int*)0xE001E000", "echo \\n"]
    return lines


def add_cpu_loader_diagnostic(lines):
    nm = os.environ["NM"]
    symbols = subprocess.check_output(
        [nm, "-n", str(ROOT / "loader/loader_tcm_init.elf")], text=True)
    table = {parts[2]: int(parts[0], 16) for line in symbols.splitlines()
             if len(parts := line.split()) == 3}
    at = lines.index("load")
    image = ROOT / "loader/application.bin"
    subprocess.run([str(Path(nm).with_name("arm-none-eabi-objcopy")),
                    "-O", "binary", str(ROOT / "build/zephyr/zephyr.elf"),
                    str(image)], check=True)
    length = image.stat().st_size
    if length % 8 or length > 0x2f000:
        raise RuntimeError("Load image must be aligned and fit reserved AXISRAM")
    init = [
        "echo [[TCM-PRELOAD-INIT]]\\n",
        "echo MEMSYSCTL_MSCR_ITCM_DTCM:\\n",
        "x/6wx 0xE001E000",
        f"restore {ROOT / 'loader/loader_tcm_init.bin'} binary 0x340af000",
        "set $preload_primask = $primask",
        f"tbreak *0x{table['loader_tcm_done']:x}",
        f"jump *0x{table['loader_tcm_init'] | 1:x}",
        "echo [[TCM-PRELOAD-INIT-DONE]]\\n",
        "x/4wx 0x100243d8",
        "x/6wx 0xE001E000",
        "set $primask = $preload_primask",
    ]
    lines[at:at] = init
    # Verify all loaded ELF sections before any application execution.
    at = lines.index("load")
    lines[at + 1:at + 1] = [
        f"restore {image} binary 0x34080000",
        "set $r0 = 0x34080000", "set $r1 = 0x10000000",
        f"set $r4 = 0x{0x10000000 + length:x}",
        f"tbreak *0x{table['loader_tcm_copy_done']:x}",
        f"jump *0x{table['loader_tcm_copy'] | 1:x}",
        "echo [[TCM-CPU-COPY-DONE]]\\n",
        "set $primask = $preload_primask",
        "compare-sections",
    ]


exec_wrapper.build_run_script = build_run_script
if __name__ == "__main__":
    raise SystemExit(exec_wrapper.main())
