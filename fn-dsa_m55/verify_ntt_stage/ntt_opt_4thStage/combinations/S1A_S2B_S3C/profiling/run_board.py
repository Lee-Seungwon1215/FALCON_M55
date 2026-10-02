#!/usr/bin/env python3
"""Run the explicitly selected SRAM benchmark and export verified counters."""
import argparse
import datetime
import json
import os
from pathlib import Path
import subprocess

CATEGORIES = ["other", "shake", "codec", "hash_to_point", "message_hash",
              "fft_fixed", "fft_fpr", "ntt_q", "ntt_modp", "keygen_other",
              "key_preparation", "ntru_other", "crt", "ldl_ffsampling",
              "sampler_other", "gaussian_fg", "gaussian0", "berexp", "norm",
              "sign_other", "verify_other"]

def main():
    p = argparse.ArgumentParser()
    p.add_argument("target", choices=["m4", "m55"])
    p.add_argument("--instrument", type=int, choices=[0, 1], default=1)
    p.add_argument("--capture-only", action="store_true")
    args = p.parse_args()
    root = Path(__file__).resolve().parent
    os.chdir(root)
    gccroot = Path(os.environ.get("ARM_GCC_ROOT", "/private/tmp/arm-gnu-toolchain-15.3.rel1-expanded/Payload"))
    binary = root / f"build/{args.target}-{args.instrument}/fndsa512_profile.elf"
    command = [str(gccroot / "bin/arm-none-eabi-gdb"), "-q", "-batch", str(binary)]
    if args.capture_only:
        port = 3334 if args.target == "m4" else 3335
        command += ["-ex", f"target extended-remote localhost:{port}",
                    "-ex", "monitor halt", "-x", "capture.gdb", "-ex", "detach"]
    else:
        command += ["-x", f"run_{args.target}.gdb"]
    print("Running", args.target, "instrumented=" + str(args.instrument), flush=True)
    completed = subprocess.run(command, text=True, stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT, timeout=900)
    output = root / "results" / (args.target + ("_profile" if args.instrument else "_uninstrumented"))
    output.parent.mkdir(parents=True, exist_ok=True)
    output.with_suffix(".log").write_text(completed.stdout)
    print(completed.stdout, flush=True)
    if completed.returncode:
        raise SystemExit(completed.returncode)
    raw = completed.stdout.split("FNDSA_JSON_BEGIN\n", 1)[1].split("\nFNDSA_JSON_END", 1)[0]
    result = json.loads(raw)
    result.update({
        "recorded_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "source_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root.parent, text=True).strip(),
        "target": args.target, "instrumented": bool(args.instrument), "unit": "cycles",
        "compatibility_fix": "Re-enabled existing scalar mqpoly_sqnorm_int_to_signed body in generated mq.c only",
        "compiler": subprocess.check_output([str(gccroot / "bin/arm-none-eabi-gcc"), "--version"], text=True).splitlines()[0],
    })
    ops = {}
    for name, data in zip(["keygen", "sign", "verify"], result["operations"]):
        cycles, entries = data.pop("cycles"), data.pop("entries")
        assert sum(cycles) == data["total_cycles"], "Exclusive categories do not sum to total"
        data["categories"] = {cat: {"cycles": c, "entries": n}
                              for cat, c, n in zip(CATEGORIES, cycles, entries)}
        ops[name] = data
        print(name, "calls=", data["calls"], "cycles/call=", data["total_cycles"] / max(1, data["calls"]))
    result["operations"] = ops
    output.with_suffix(".json").write_text(json.dumps(result, indent=2) + "\n")
    assert result["state"] == 0x600D0000 and result["error"] == 0 and result["profile_error"] == 0, "Firmware reported failure"
    assert [ops[name]["calls"] for name in ["keygen", "sign", "verify"]] == [10, 100, 100]
    print("Saved and validated:", output.with_suffix(".json"))

if __name__ == "__main__":
    main()
