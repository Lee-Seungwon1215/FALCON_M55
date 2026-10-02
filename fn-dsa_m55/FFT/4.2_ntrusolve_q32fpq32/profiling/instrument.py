#!/usr/bin/env python3
"""Generate disposable, instrumented C copies; never edit upstream sources.

Hooks use GCC/Clang scope cleanup so early returns cannot unbalance the
exclusive-category stack. Only selected coarse functions are instrumented;
in particular individual fpr primitives are not instrumented.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re

SOURCES = "codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy".split()
HOOKS = {
    "codec": {"CODEC": "trim_i8_encode trim_i8_decode mqpoly_encode mqpoly_decode comp_encode comp_decode"},
    "sha3": {"SHAKE": "process_block"},
    "util": {"HASH_TO_POINT": "hash_to_point", "MESSAGE_HASH": "fndsa_compute_mu fndsa_hashed_vrfykey_from_vrfykey"},
    "kgen": {"KEYGEN": "keygen_inner"},
    "kgen_fxp": {"FFT_FIXED": "vect_FFT vect_iFFT"},
    "kgen_gauss": {"GAUSSIAN_FG": "sample_f"},
    "kgen_mp31": {"NTT_MODP": "mp_NTT mp_iNTT mp_mkgmigm mp_mkgm mp_mkigm"},
    "kgen_ntru": {"NTRU": "solve_NTRU", "NORM": "check_ortho_norm"},
    "kgen_zint31": {"CRT": "zint_rebuild_CRT"},
    "mq": {"NTT_Q": "mqpoly_int_to_ntt mqpoly_ntt_to_int", "NORM": "mqpoly_sqnorm_binf_int mqpoly_sqnorm_binf_signed mqpoly_sqnorm_int_to_signed mqpoly_sqnorm_signed mqpoly_sqnorm_is_acceptable"},
    "sign": {"KEY_PREP": "sign_step1"},
    "sign_core": {"SIGN": "sign_core"},
    "sign_fpoly": {"FFT_FPR": "fpoly_FFT fpoly_iFFT", "TREE": "fpoly_LDL_fft"},
    "sign_sampler": {"TREE": "ffsamp_fft", "SAMPLER": "sampler_next", "GAUSSIAN0": "fndsa_gaussian0_helper", "BEREXP": "ber_exp"},
    "vrfy": {"VERIFY": "inner_verify"},
}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    source = Path(__file__).resolve().parent.parent
    args.output.mkdir(parents=True, exist_ok=True)
    manifest = {}
    for base in SOURCES:
        path = source / (base + ".c")
        original = path.read_text()
        content = original
        compatibility = None
        if base == "mq":
            # a5f1589 still calls this helper in sign_core.c, but its C
            # implementation was accidentally disabled as "obsolete".
            # Reactivate the existing upstream body, without changing math.
            marker = "#if 0 /* obsolete */\n#if !FNDSA_ASM_CORTEXM4\n/* see inner.h */\nuint32_t\nmqpoly_sqnorm_int_to_signed("
            if content.count(marker) != 1:
                raise RuntimeError("Review scalar mq compatibility fix for this upstream version")
            content = content.replace(marker, marker.replace("#if 0 /* obsolete */", "#if 1 /* profiling: restore still-required scalar helper */"))
            compatibility = "Re-enable existing mqpoly_sqnorm_int_to_signed C implementation"
        applied = {}
        for category, names in HOOKS.get(base, {}).items():
            for name in names.split():
                pattern = re.compile(r"(^" + re.escape(name) + r"\([^;{}]*?\)\s*\n\{)", re.M)
                content, count = pattern.subn(lambda m: m[1] + "\n\tFNDSA_SCOPE(CAT_" + category + ");", content)
                if not count:
                    raise RuntimeError(f"Missing instrumentation target: {base}.c:{name}")
                applied[name] = {"category": category, "definitions": count}
        content = '#include "profile.h"\n#line 1 "' + path.as_posix() + '"\n' + content
        (args.output / path.name).write_text(content)
        manifest[path.name] = {"sha256": hashlib.sha256(original.encode()).hexdigest(), "hooks": applied, "compatibility_fix": compatibility}
    (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    (args.output / ".stamp").touch()

if __name__ == "__main__":
    main()
