#!/usr/bin/env python3
"""Create disposable C sources with exclusive coarse-grained profiling hooks."""
import argparse
import hashlib
import json
from pathlib import Path
import re

SOURCES = "codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy".split()

# Functions implemented by the selected assembly backend are wrapped at link
# time in wrappers.c.  The entries below cover the remaining C functions,
# including static functions that a linker wrapper cannot intercept.
HOOKS = {
    "codec": {"CODEC": "trim_i8_encode trim_i8_decode mqpoly_encode comp_encode"},
    "util": {"HASH_TO_POINT": "hash_to_point", "MESSAGE_HASH": "fndsa_compute_mu fndsa_hashed_vrfykey_from_vrfykey"},
    "kgen": {"KEYGEN": "keygen_inner"},
    "kgen_fxp": {"FFT_FIXED": "vect_FFT vect_iFFT"},
    "kgen_gauss": {"GAUSSIAN_FG": "sample_f"},
    "kgen_mp31": {"NTT_MODP": "mp_NTT mp_iNTT mp_mkgmigm mp_mkgm mp_mkigm"},
    "kgen_ntru": {"NTRU": "solve_NTRU", "NORM": "check_ortho_norm"},
    "kgen_zint31": {"CRT": "zint_rebuild_CRT"},
    "mq": {"NORM": "mqpoly_sqnorm_binf_signed mqpoly_sqnorm_is_acceptable"},
    "sign": {"KEY_PREP": "sign_step1"},
    "sign_core": {"SIGN": "sign_core"},
    "sign_fpoly": {"FFT_FPR": "fpoly_FFT fpoly_iFFT", "TREE": "fpoly_LDL_fft"},
    "sign_sampler": {"TREE": "ffsamp_fft", "SAMPLER": "sampler_next", "BEREXP": "ber_exp"},
    "vrfy": {"VERIFY": "inner_verify"},
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    manifest = {"source": str(args.source.resolve()), "files": {}}
    for base in SOURCES:
        path = args.source / (base + ".c")
        original = path.read_text()
        content = original
        applied = {}
        for category, names in HOOKS.get(base, {}).items():
            for name in names.split():
                pattern = re.compile(r"(^" + re.escape(name) + r"\([^;{}]*?\)\s*\n\{)", re.M)
                content, count = pattern.subn(
                    lambda m: m[1] + "\n\tFNDSA_SCOPE(CAT_" + category + ");", content)
                if not count:
                    raise RuntimeError(f"missing instrumentation target: {path.name}:{name}")
                applied[name] = {"category": category, "definitions": count}
        content = '#include "profile.h"\n#line 1 "' + path.as_posix() + '"\n' + content
        (args.output / path.name).write_text(content)
        manifest["files"][path.name] = {
            "sha256": hashlib.sha256(original.encode()).hexdigest(),
            "hooks": applied,
        }
    (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


if __name__ == "__main__":
    main()
