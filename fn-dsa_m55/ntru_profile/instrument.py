#!/usr/bin/env python3
"""Generate disposable c-fn-dsa sources with NTRU-only profiling hooks."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re


SOURCES = "codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy".split()


def inject_function(content: str, name: str, statement: str) -> tuple[str, int]:
	pattern = re.compile(r"(^" + re.escape(name) + r"\([^;{}]*?\)\s*\n\{)", re.M)
	return pattern.subn(lambda m: m[1] + "\n\t" + statement, content)


def apply(content: str, name: str, statement: str, applied: dict, category: str) -> str:
	content, count = inject_function(content, name, statement)
	if count != 1:
		raise RuntimeError(f"{name}: expected one definition, found {count}")
	applied[name] = category
	return content


def main() -> None:
	parser = argparse.ArgumentParser()
	parser.add_argument("source", type=Path)
	parser.add_argument("output", type=Path)
	parser.add_argument("mode", choices=("control", "detailed", "logn", "fft"))
	args = parser.parse_args()
	args.output.mkdir(parents=True, exist_ok=True)
	manifest = {"source": str(args.source.resolve()), "mode": args.mode, "files": {}}

	for base in SOURCES:
		path = args.source / f"{base}.c"
		original = path.read_text()
		content = original
		applied: dict[str, str] = {}

		if base == "kgen_ntru":
			content = apply(content, "solve_NTRU", "NTRU_PROFILE_SCOPE(logn);",
				applied, "total")
			if args.mode == "detailed":
				content = apply(content, "solve_NTRU_deepest",
					"NTRU_PHASE_SCOPE(PHASE_DEEPEST);", applied, "phase_deepest")
				content = apply(content, "solve_NTRU_intermediate",
					"NTRU_PHASE_SCOPE(PHASE_INTERMEDIATE_D1 + depth - 1);",
					applied, "phase_intermediate")
				content = apply(content, "solve_NTRU_depth0",
					"NTRU_PHASE_SCOPE(PHASE_DEPTH0);", applied, "phase_depth0")

		if args.mode == "logn" and base == "kgen_mp31":
			content = apply(content, "mp_NTT",
				"NTRU_NTT_LOGN_SCOPE(NTT_FORWARD, logn);",
				applied, "ntt_logn_forward")
			content = apply(content, "mp_iNTT",
				"NTRU_NTT_LOGN_SCOPE(NTT_INVERSE, logn);",
				applied, "ntt_logn_inverse")

		if args.mode == "detailed" and base == "kgen_mp31":
			for name, kernel in (
				("mp_NTT", "KERNEL_MP_NTT"),
				("mp_iNTT", "KERNEL_MP_INTT"),
				("mp_mkgmigm", "KERNEL_TWIDDLE"),
				("mp_mkgm", "KERNEL_TWIDDLE"),
				("mp_mkigm", "KERNEL_TWIDDLE"),
			):
				content = apply(content, name, f"NTRU_KERNEL_SCOPE({kernel});",
					applied, kernel.lower())

		if args.mode == "detailed" and base == "kgen_zint31":
			content = apply(content, "zint_rebuild_CRT",
				"NTRU_KERNEL_SCOPE(KERNEL_CRT);", applied, "kernel_crt")
			content = apply(content, "zint_bezout",
				"NTRU_KERNEL_SCOPE(KERNEL_BEZOUT);", applied, "kernel_bezout")

		if args.mode in ("detailed", "fft") and base == "kgen_fxp":
			content = apply(content, "vect_FFT", "NTRU_KERNEL_SCOPE(KERNEL_FFT);",
				applied, "kernel_fft")
			content = apply(content, "vect_iFFT", "NTRU_KERNEL_SCOPE(KERNEL_IFFT);",
				applied, "kernel_ifft")
			for name in ("vect_mul_fft", "vect_div_selfadj_fft", "vect_inv_mul2e_fft"):
				content = apply(content, name,
					"NTRU_KERNEL_SCOPE(KERNEL_FXP_SPECTRAL);",
					applied, "kernel_fxp_spectral")

		if args.mode in ("detailed", "fft") and base == "kgen_poly":
			content = apply(content, "poly_big_to_fixed",
				"NTRU_KERNEL_SCOPE(KERNEL_FIXED_CONVERT);", applied,
				"kernel_fixed_convert")
		if args.mode == "detailed" and base == "kgen_poly":
			content = apply(content, "poly_sub_scaled_ntt",
				"NTRU_KERNEL_SCOPE(KERNEL_SUB_NTT);", applied, "kernel_sub_ntt")
			content = apply(content, "poly_sub_kf_scaled_depth1",
				"NTRU_KERNEL_SCOPE(KERNEL_SUB_DEPTH1);", applied,
				"kernel_sub_depth1")
			content = apply(content, "poly_sub_scaled",
				"NTRU_KERNEL_SCOPE(KERNEL_SUB_PLAIN);", applied, "kernel_sub_plain")

		content = f'#include "profile.h"\n#line 1 "{path.as_posix()}"\n' + content
		(args.output / path.name).write_text(content)
		manifest["files"][path.name] = {
			"sha256": hashlib.sha256(original.encode()).hexdigest(),
			"hooks": applied,
		}

	(args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


if __name__ == "__main__":
	main()
