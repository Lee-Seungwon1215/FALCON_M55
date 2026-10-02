#!/usr/bin/env python3
"""Save reproducible source/configuration/ELF checks without touching a board."""
import difflib
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
from elftools.elf.elffile import ELFFile

ROOT = Path(__file__).resolve().parent
REF = ROOT.parent / "ref"
M4 = ROOT.parents[1] / "fn-dsa_m4/ref"
BUILD = ROOT / "build-dtcm"
BIN = Path(os.environ["GNUARMEMB_TOOLCHAIN_PATH"]) / "bin"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def output(*args):
    return subprocess.check_output(args, text=True)


def main():
    artifact = ROOT / "audit-dtcm"
    artifact.mkdir(exist_ok=True)
    names = output("git", "-C", str(REF), "ls-files").splitlines()
    sources = {}
    for name in names:
        if Path(name).suffix not in (".h", ".c", ".s"):
            continue
        p = REF / name
        other = M4 / name
        sources[name] = {"m55_sha256": sha(p), "m4_sha256": sha(other),
                         "identical": p.read_bytes() == other.read_bytes()}
    differences = [name for name, value in sources.items() if not value["identical"]]
    assert differences == ["inner.h"], differences
    patch = output("git", "-C", str(REF), "diff", "--", "inner.h")
    (artifact / "m55_compatibility.patch").write_text(patch)
    commands = json.loads((BUILD / "compile_commands.json").read_text())
    crypto_commands = [c for c in commands if Path(c["file"]).parent == REF]
    assert len(crypto_commands) == 23, len(crypto_commands)
    for c in crypto_commands:
        flags = shlex.split(c["command"])
        opts = [x for x in flags if re.fullmatch(r"-O(?:[0-3sgz]|fast)", x)]
        assert opts[-1] == "-O3", (c["file"], opts)
        assert "-DFNDSA_ASM_CORTEXM4=1" in flags
        assert "-DFNDSA_ASM_CORTEXM55=1" in flags
        assert "-mcpu=cortex-m55" in flags
        assert "-mfpu=fpv5-sp-d16" in flags
        assert "-mfloat-abi=hard" in flags
    (artifact / "crypto_compile_commands.json").write_text(
        json.dumps(crypto_commands, indent=2) + "\n")

    upstream = Path(os.environ["FNDSA_M55_ENV"]) / (
        "upstream-build-opt1/zephyr/nucleo-n657x0-q/bench_mlkem512/zephyr/.config")
    actual = (BUILD / "zephyr/.config").read_text().splitlines(keepends=True)
    reference = upstream.read_text().splitlines(keepends=True)
    delta = list(difflib.unified_diff(reference, actual,
                 fromfile="mlkem-native OPT=1", tofile="FN-DSA stage B"))
    substantive = [line for line in delta if line.startswith(("+", "-"))
                   and not line.startswith(("+++", "---"))]
    assert substantive == ["-CONFIG_FIPS202_MVE_BACKEND=y\n"], substantive
    (artifact / "upstream_config.diff").write_text("".join(delta))

    elf_path = BUILD / "zephyr/zephyr.elf"
    loads = []
    with elf_path.open("rb") as stream:
        elf = ELFFile(stream)
        for seg in elf.iter_segments():
            if seg["p_type"] != "PT_LOAD":
                continue
            v, n = seg["p_vaddr"], seg["p_memsz"]
            p, f = seg["p_paddr"], seg["p_filesz"]
            assert ((0x10000000 <= v <= v+n <= 0x10040000)
                    or (0x30000000 <= v <= v+n <= 0x30040000)), (v, n)
            if f:
                assert p == v, (p, v)
            loads.append({"vaddr": hex(v), "paddr": hex(p),
                          "memory_bytes": n, "file_bytes": f})
        sections = []
        for sec in elf.iter_sections():
            if not sec['sh_flags'] & 2 or not sec['sh_size']:
                continue
            a, n = sec['sh_addr'], sec['sh_size']
            code = bool(sec['sh_flags'] & 4) or sec.name == 'rom_start'
            lo, hi = (0x10000000, 0x10020000) if code else (0x30000000, 0x30040000)
            assert lo <= a < a+n <= hi, (sec.name, hex(a), n, code)
            sections.append(dict(name=sec.name, address=hex(a), bytes=n, code=code))
    assembly = output(str(BIN / "arm-none-eabi-objdump"), "-d", str(elf_path))
    (artifact / "disassembly.txt").write_text(assembly)
    assert re.search(r'\bbl\s+[0-9a-f]+ <__wrap_soc_early_reset_hook>', assembly)
    assert '<soc_early_reset_hook>:' not in assembly, 'upstream destructive scrub retained'
    attributes = output(str(BIN / "arm-none-eabi-readelf"), "-A", str(elf_path))
    (artifact / "elf_attributes.txt").write_text(attributes)
    mve_functions = {}
    function = ""
    for line in assembly.splitlines():
        match = re.match(r"[0-9a-f]+ <(.+)>:", line)
        if match:
            function = match.group(1)
        elif re.search(r"\bq[0-7]\b|\bvctp\.", line):
            mve_functions[function] = mve_functions.get(function, 0) + 1
    (artifact / "mve_static_sites.json").write_text(
        json.dumps(mve_functions, indent=2) + "\n")
    manifest = {
        "m55_source_head": output("git", "-C", str(REF), "rev-parse", "HEAD").strip(),
        "m4_source_head": output("git", "-C", str(M4), "rev-parse", "HEAD").strip(),
        "sources": sources, "source_differences": differences,
        "crypto_translation_units": len(crypto_commands),
        "crypto_final_optimization": "-O3",
        "all_5_m4_assembly_files_enabled": True,
        "upstream_opt1_config_differences": ["CONFIG_FIPS202_MVE_BACKEND absent"],
        "artifact_only_change": "build.sh discards the generated gap-filled flat BIN; sparse ELF/HEX retained",
        "memory_layout_deviation": "Local linker: vectors/text ITCM; global rodata, Zephyr tables, data LMA/VMA, BSS and stack DTCM. Inline text literal pools remain ITCM.",
        "linker_generator_sha256": sha(ROOT / "app/generate_dtcm_linker.py"),
        "startup_adapter_sha256": sha(ROOT / "app/dtcm_startup.s"),
        "startup_deviation": "Wrapped early DTCM scrub preserves direct-loaded constant/data prefix; aligned STRD still initializes BSS/noinit/stack/remainder. ECC remains enabled.",
        "generated_linker_sha256": sha(BUILD / "fndsa_dtcm_linker.ld"),
        "load_segments": loads, "sections": sections,
        "all_executable_in_itcm": True, "all_global_rodata_in_dtcm": True,
        "all_data_and_stacks_in_dtcm": True,
        "bootargs_handoff_outside_elf": "0x340b0000, 64 KiB AXISRAM; upstream runner",
        "mve_static_instruction_sites_present": bool(mve_functions),
        "mve_note": "Compiler-generated MVE is present; this baseline is not nomve. Static counts are NOT runtime operation proportions.",
        "elf_sha256": sha(elf_path), "config_sha256": sha(BUILD / "zephyr/.config"),
        "benchmark_sha256": sha(ROOT / "app/benchmark.c"),
        "cortex_m4_asm_sha256": {p.name: sha(p) for p in REF.glob("*_cm4.s")},
    }
    (artifact / "build_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps({k: v for k, v in manifest.items()
                      if k not in ("sources", "cortex_m4_asm_sha256")}, indent=2))


if __name__ == "__main__":
    main()
