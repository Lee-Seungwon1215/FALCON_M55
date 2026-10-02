#!/usr/bin/env python3
"""Disposable, lossless loop/function instrumentation; never modify crypto originals.

The nine loop sites operate on RNS+NTT coefficients. Conversion, CRT, table
generation, butterflies, FFT, and surrounding copies are deliberately excluded.
The depth-zero sites include modular division (mp_div), not just multiplication.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import re

SOURCES = "codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy".split()
FUNCTIONS = {
    "kgen_ntru": [("solve_NTRU", "CAT_NTRU_REST")],
    "kgen_mp31": [("mp_mkgm", "CAT_TABLE_GM"), ("mp_mkigm", "CAT_TABLE_IGM"),
                  ("mp_mkgmigm", "CAT_TABLE_BOTH")],
    "mq": [("mqpoly_div_ntt", "CAT_MQ_DIV")],
}
# Each selector must appear in exactly one complete for-loop in that function.
LOOPS = {
    "kgen_ntru": [
        ("make_fg_step", "mp_mmul(xf[2 * j]", "CAT_RNS_DESCENT"),
        ("make_fg_step", "yf[j] = mp_mmul(\n\t\t\t\tmp_mmul(t2", "CAT_RNS_DESCENT"),
        ("make_fg_step", "yg[j] = mp_mmul(\n\t\t\t\tmp_mmul(t2", "CAT_RNS_DESCENT"),
        ("solve_NTRU_intermediate", "uint32_t ga = gx[", "CAT_RNS_LIFTING"),
        ("solve_NTRU_depth0", "uint32_t ga = t2[", "CAT_RNS_LIFTING"),
        ("solve_NTRU_depth0", "uint32_t tf0 = t3[i];", "CAT_RNS_DEPTH0_BABAI"),
        ("solve_NTRU_depth0", "uint32_t tF = t1[i];", "CAT_RNS_DEPTH0_RECOVER"),
    ],
    "kgen_poly": [
        ("poly_sub_scaled_ntt", "ff[j] = mp_mmul(", "CAT_RNS_SCALED_SUB"),
        ("poly_sub_kf_scaled_depth1", "uint32_t xe0 = t1[", "CAT_RNS_DEPTH1_SUB"),
    ],
}

def digest(text):
    return hashlib.sha256(text.encode()).hexdigest()

def masked(text):
    # Keep offsets/newlines, but braces/for in strings and comments are inert.
    pattern = r'/\*[\s\S]*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\''
    return re.sub(pattern, lambda m: re.sub(r'[^\n]', ' ', m[0]), text)

def closing(code, start, left="{", right="}"):
    if code[start] != left:
        raise ValueError("wrong opening delimiter")
    depth = 0
    for i in range(start, len(code)):
        depth += code[i] == left
        depth -= code[i] == right
        if depth == 0:
            return i + 1
    raise ValueError("unterminated block")

def function_bounds(text, name):
    code = masked(text)
    hits = list(re.finditer(r"^" + re.escape(name) + r"\([^;{}]*?\)\s*\n\{", code, re.M))
    if len(hits) != 1:
        raise ValueError(f"{name}: expected exactly one function, got {len(hits)}")
    start = hits[0].end() - 1
    return start, closing(code, start)

def find_loop(text, function, selector):
    code = masked(text)
    start, end = function_bounds(text, function)
    matches = []
    for hit in re.finditer(r"\bfor\s*\(", code[start:end]):
        loop_start = start + hit.start()
        paren = start + hit.end() - 1
        body = closing(code, paren, "(", ")")
        while code[body].isspace():
            body += 1
        if code[body] != "{":
            continue
        loop_end = closing(code, body)
        if selector in text[loop_start:loop_end]:
            matches.append((loop_start, loop_end))
    # Enclosing prime loops also contain the selector; choose innermost.
    if not matches:
        raise ValueError(f"missing loop: {function}: {selector}")
    matches.sort(key=lambda span: span[1] - span[0])
    selected = matches[0]
    if text[selected[0]:selected[1]].count(selector) != 1:
        raise ValueError("ambiguous loop selector")
    if any(not (a <= selected[0] and selected[1] <= b) for a, b in matches):
        raise ValueError("multiple disjoint selector matches")
    return selected

def generate(name, original, mode):
    edits, sites = [], []
    for function, category in FUNCTIONS.get(name, []):
        if mode == "control" and category != "CAT_NTRU_REST":
            continue
        start, end = function_bounds(original, function)
        edits.append((start + 1, f"\n\tFNDSA_SCOPE({category});"))
        sites.append(dict(kind="function", function=function, category=category,
                          line=original.count("\n", 0, start) + 1))
    if mode == "detailed":
        for function, selector, category in LOOPS.get(name, []):
            start, end = find_loop(original, function, selector)
            body = original[start:end]
            if re.search(r"\b(?:mp_NTT|mp_iNTT|mp_mkgm\w*|mp_mkigm|zint_\w*|vect_\w*|memcpy|memmove)\s*\(", masked(body)):
                raise ValueError("out-of-scope operation inside pointwise loop")
            edits += [(start, "{\n\t\tFNDSA_SCOPE(" + category + ");\n\t\t"),
                      (end, "\n\t\t}")]
            sites.append(dict(kind="loop", function=function, category=category,
                              line=original.count("\n", 0, start) + 1,
                              last_line=original.count("\n", 0, end) + 1,
                              body_sha256=digest(body)))
    # Insertion only: every original byte, expression and return is preserved.
    result = original
    for at, text in sorted(edits, reverse=True):
        result = result[:at] + text + result[at:]
    return result, sites

def expected(source, name, mode):
    original = (source / (name + ".c")).read_text()
    body, sites = generate(name, original, mode)
    content = f'#include "profile.h"\n#line 1 "{source / (name + ".c")}"\n' + body
    return content, dict(original_sha256=digest(original), generated_sha256=digest(content), sites=sites)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("mode", choices=("control", "detailed"))
    args = parser.parse_args()
    source = args.source.resolve()
    args.output.mkdir(parents=True, exist_ok=True)
    files = {}
    for name in SOURCES:
        content, files[name + ".c"] = expected(source, name, args.mode)
        (args.output / (name + ".c")).write_text(content)
    (args.output / "manifest.json").write_text(json.dumps(
        dict(source=str(source), mode=args.mode, files=files), indent=2) + "\n")
    print("INSTRUMENT", args.mode, "sites", sum(len(f["sites"]) for f in files.values()))

if __name__ == "__main__":
    main()
