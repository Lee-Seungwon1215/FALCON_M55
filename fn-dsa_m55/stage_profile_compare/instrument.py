#!/usr/bin/env python3
"""Generate disposable sources with algorithm-stage profiling markers."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


SOURCES = "codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy".split()


def replace_once(text: str, old: str, new: str, label: str) -> str:
	count = text.count(old)
	if count != 1:
		raise RuntimeError(f"{label}: expected one match, got {count}")
	return text.replace(old, new, 1)


def instrument_kgen(text: str) -> str:
	head, tail = text.split("#if FNDSA_AVX2", 1)
	head = replace_once(head,
		"\tfor (;;) {\n\t\t/* Sample f, with odd parity. */",
		"\tfor (;;) {\n\t\tprofile_switch(CAT_KG_GENERATE);\n\t\t/* Sample f, with odd parity. */", "kgen generate f")
	head = replace_once(head,
		"\t\tsample_f(logn, &pc, f);\n\n\t\t/* If f is not invertible mod q, try again. */",
		"\t\tsample_f(logn, &pc, f);\n\n\t\tprofile_switch(CAT_KG_CHECK);\n\t\t/* If f is not invertible mod q, try again. */", "kgen check f")
	head = replace_once(head,
		"\t\t/* Sample g, also with odd parity. */\n\t\tsample_f(logn, &pc, g);",
		"\t\t/* Sample g, also with odd parity. */\n\t\tprofile_switch(CAT_KG_GENERATE);\n\t\tsample_f(logn, &pc, g);\n\t\tprofile_switch(CAT_KG_CHECK);", "kgen generate/check g")
	head = replace_once(head,
		"\t\t/* Try to solve the NTRU equation. */",
		"\t\tprofile_switch(CAT_KG_NTRU);\n\t\t/* Try to solve the NTRU equation. */", "kgen ntru")
	head = replace_once(head,
		"\t\t/* solve_NTRU() ensured that f*G - g*F = q, and that all",
		"\t\tprofile_switch(CAT_KG_SK_COMPLETE);\n\t\t/* solve_NTRU() ensured that f*G - g*F = q, and that all", "kgen sk")
	head = replace_once(head,
		"\t\tif (sign_key != NULL || vrfy_key != NULL) {",
		"\t\tprofile_switch(CAT_KG_PK_COMPUTE);\n\t\tif (sign_key != NULL || vrfy_key != NULL) {", "kgen pk")
	head = replace_once(head,
		"\t\t}\n\t\tbreak;\n\t}\n}",
		"\t\t}\n\t\tprofile_switch(CAT_OTHER);\n\t\tbreak;\n\t}\n}", "kgen end")
	return head + "#if FNDSA_AVX2" + tail


def instrument_sign(text: str) -> str:
	text = replace_once(text,
		"sign_step1(unsigned logn, const uint8_t *sign_key, const uint8_t *mu,\n\tconst uint8_t *seed, size_t seed_len, uint8_t *sig, void *tmp)\n{",
		"sign_step1(unsigned logn, const uint8_t *sign_key, const uint8_t *mu,\n\tconst uint8_t *seed, size_t seed_len, uint8_t *sig, void *tmp)\n{\n\tprofile_switch(CAT_SG_KEY_PREP);", "sign key prep")
	text = replace_once(text,
		"\t   We compute the message representative mu. */\n\tuint8_t mu[64];",
		"\t   We compute the message representative mu. */\n\tprofile_switch(CAT_SG_MESSAGE_HASH);\n\tuint8_t mu[64];", "sign message hash")
	return text


def instrument_sign_core(text: str) -> str:
	text = replace_once(text,
		"\tfor (uint8_t counter = 0; counter < 27; counter ++) {\n\t\t/* Initialize a SHAKE context",
		"\tfor (uint8_t counter = 0; counter < 27; counter ++) {\n\t\tprofile_switch(CAT_SG_HASH_TO_POINT);\n\t\t/* Initialize a SHAKE context", "sign h2p")
	text = replace_once(text,
		"\t\t/* Compute the lattice basis B = [[g, -f], [G, -F]] in FFT",
		"\t\tprofile_switch(CAT_SG_FFT_BASIS);\n\t\t/* Compute the lattice basis B = [[g, -f], [G, -F]] in FFT", "sign fft basis")
	text = replace_once(text,
		"\t\tffsamp_fft(&ss, tmp);",
		"\t\tprofile_switch(CAT_SG_LDL_FFSAMPLING);\n\t\tffsamp_fft(&ss, tmp);\n\t\tprofile_switch(CAT_SG_RECON_NORM);", "sign ffsampling/recon")
	text = replace_once(text,
		"\t\t/* We have a candidate signature (s1, s2). The L-2 norm of",
		"\t\tprofile_switch(CAT_SG_ENCODE);\n\t\t/* We have a candidate signature (s1, s2). The L-2 norm of", "sign encode")
	return text


def instrument_sampler(text: str) -> str:
	needle = "sampler_next(sampler_state *ss, fpr mu, fpr isigma)\n{"
	pos = text.rfind(needle)
	if pos < 0:
		raise RuntimeError("plain sampler_next not found")
	insert = needle + "\n\tFNDSA_SCOPE(CAT_SG_GAUSSIAN_BEREXP);"
	return text[:pos] + text[pos:].replace(needle, insert, 1)


def instrument_verify(text: str) -> str:
	head, tail = text.split("#if FNDSA_AVX2", 1)
	head = replace_once(head,
		"\t/* Get message representative mu. */\n\tuint8_t mu[64];",
		"\t/* Get message representative mu. */\n\tprofile_switch(CAT_VR_MESSAGE_HASH);\n\tuint8_t mu[64];", "verify message hash")
	head = replace_once(head,
		"\t/* t1 <- h (verifying key, decoded); h is in ntt representation. */",
		"\tprofile_switch(CAT_VR_DECODE);\n\t/* t1 <- h (verifying key, decoded); h is in ntt representation. */", "verify decode")
	head = replace_once(head,
		"\tuint32_t norm2 = mqpoly_sqnorm_signed(logn, t2);",
		"\tprofile_switch(CAT_VR_NORM);\n\tuint32_t norm2 = mqpoly_sqnorm_signed(logn, t2);\n\tprofile_switch(CAT_VR_NTT);", "verify norm2/ntt")
	head = replace_once(head,
		"\t/* Hash message into polynomial c (into t1, converted to int) */",
		"\tprofile_switch(CAT_VR_HASH_TO_POINT);\n\t/* Hash message into polynomial c (into t1, converted to int) */", "verify h2p")
	head = replace_once(head,
		"\t/* t1 <- s1 = c - s2*h (converted to ext), and compute its norm;",
		"\tprofile_switch(CAT_VR_POLY);\n\t/* t1 <- s1 = c - s2*h (converted to ext), and compute its norm;", "verify polynomial")
	head = replace_once(head,
		"\tuint32_t norm1 = mqpoly_sqnorm_binf_ext(logn, t1);",
		"\tprofile_switch(CAT_VR_NORM);\n\tuint32_t norm1 = mqpoly_sqnorm_binf_ext(logn, t1);", "verify norm1")
	return head + "#if FNDSA_AVX2" + tail


INSTRUMENT = {
	"kgen": instrument_kgen,
	"sign": instrument_sign,
	"sign_core": instrument_sign_core,
	"sign_sampler": instrument_sampler,
	"vrfy": instrument_verify,
}


def main() -> None:
	parser = argparse.ArgumentParser()
	parser.add_argument("source", type=Path)
	parser.add_argument("output", type=Path)
	args = parser.parse_args()
	args.output.mkdir(parents=True, exist_ok=True)
	manifest = {"source": str(args.source.resolve()), "files": {}}
	for base in SOURCES:
		path = args.source / f"{base}.c"
		original = path.read_text()
		content = INSTRUMENT.get(base, lambda x: x)(original)
		content = f'#include "profile.h"\n#line 1 "{path.as_posix()}"\n' + content
		(args.output / path.name).write_text(content)
		manifest["files"][path.name] = {
			"sha256": hashlib.sha256(original.encode()).hexdigest(),
			"instrumented": base in INSTRUMENT,
		}
	(args.output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


if __name__ == "__main__":
	main()
