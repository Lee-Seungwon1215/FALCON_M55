#!/usr/bin/env python3
"""One-time, mechanical extraction. Normal builds use ONLY checked-in local files.

Run --check to verify extracted sources without writing. --write refuses to
overwrite an existing different file. Function bodies/arithmetic are unmodified;
only public symbol names, includes and placement annotations are adapted.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
WORK = ROOT.parents[1]
SOURCES = {"original": WORK / "M55_ref",
           "optimized": WORK / "ntt_opt"}

def sha(data):
    return hashlib.sha256(data).hexdigest()

def block(text, start):
    """Balanced C block, ignoring comments/string literals (including inline asm)."""
    tokens = re.finditer(r'/\*[\s\S]*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|[{}]', text[start:])
    depth = 0
    opened = False
    for m in tokens:
        if m[0] == '{':
            depth += 1
            opened = True
        elif m[0] == '}':
            depth -= 1
            if opened and depth == 0:
                return start + m.end()
    raise ValueError('unclosed block')

def function(text, name):
    matches = list(re.finditer(r'^' + re.escape(name) + r'\(', text, re.M))
    if len(matches) != 1:
        raise ValueError(f'{name}: expected unique function, got {len(matches)}')
    start = matches[0].start()
    return text[start:block(text, start)]

def array(text, name):
    m = re.search(r'^(?:static )?const [^\n]+\b' + name + r'\[[^\]]*\] = \{', text, re.M)
    if not m:
        raise ValueError(name)
    end = block(text, m.start())
    assert text[end] == ';'
    return text[m.start():end + 1]

def outputs():
    generated = {}
    evidence = {"comparison": "M55_ref vs ntt_opt (K4C, pre-SLOTHY)",
                "inputs": {}, "outputs": {}, "adaptations": [
        "public symbol namespaces orig_/opt_ (no algorithm change)",
        "NTT-only extraction, local minimal headers, ELF placement sections",
        "M4 inline assembly enabled for original RNS and optimized small fallback",
        "current ntt_opt K4C assembly copied without arithmetic or instruction-order edits",
        "optimized C fallback extracted from current ntt_opt, full inverse roots w*R",
        "mq tables copied from respective source; RNS roots generated once outside timing"]}
    def read(which, name):
        p = SOURCES[which] / name
        data = p.read_bytes()
        evidence['inputs'][str(p.relative_to(WORK))] = sha(data)
        return data.decode()
    inner = read('original', 'inner.h')
    hdr = read('original', 'kgen_inner.h')
    opt_inner = read('optimized', 'inner.h')
    opt_hdr = read('optimized', 'kgen_inner.h')
    helpers = '#pragma once\n#include <stdint.h>\n#include <stddef.h>\n#define FNDSA_ASM_CORTEXM4 1\n'
    for name in ('tbmask', 'mp_R', 'mp_hR', 'mp_add', 'mp_sub', 'mp_half', 'mp_mmul'):
        assert function(inner if name == 'tbmask' else hdr, name) == function(
            opt_inner if name == 'tbmask' else opt_hdr, name), 'helper changed: ' + name
        helpers += '\nstatic inline uint32_t\n' + function(inner if name == 'tbmask' else hdr, name) + '\n'
    generated['original/mp_helpers.h'] = helpers
    base = read('original', 'kgen_mp31.c')
    c = '#include "mp_helpers.h"\n#include "../bench/api.h"\n'
    for name in ('mp_NTT', 'mp_iNTT'):
        c += '\n__attribute__((section(".compare.orig_mp"), noinline))\nvoid\n'
        c += function(base, name).replace(name + '(', 'orig_' + name + '(', 1) + '\n'
    generated['original/kgen_mp31.c'] = c
    current = read('optimized', 'kgen_mp31.c')
    c = '#include "../original/mp_helpers.h"\n#include "../bench/api.h"\n#define FNDSA_MVE_MP31 1\n'
    for name in ('mp_NTT', 'mp_iNTT'):
        body = function(current, name)
        # Remove only the conditional public-symbol prototype terminator.
        # Keep the actual current MVE small fallback body, including its guards.
        assert body.count('\n#endif\n{') == 1
        body = body.replace('\n#endif\n{', '\n{', 1)
        c += '\nvoid\n' + body.replace(name + '(', 'opt_' + name + '_c(', 1) + '\n'
    generated['optimized/kgen_mp31_fallback.c'] = c
    roots = '#include "../original/mp_helpers.h"\n#include "../bench/api.h"\n'
    roots += array(base, 'REV10') + '\n\n'
    roots += 'void\n' + function(base, 'mp_mkgmigm') + '\n\n'
    roots += '''/* Convert the traditional inverse roots w*R/2 into the unscaled roots w*R
 * consumed by the H1 MVE iNTT.  Generation is deliberately outside every
 * timed region; the original half-scaled table remains available to the
 * unmodified comparison implementation. */
void
mp_mkigm_full(unsigned logn, uint32_t *restrict igm_full,
\tconst uint32_t *restrict igm_half, uint32_t p)
{
\tsize_t n = (size_t)1 << logn;
\tfor (size_t u = 0; u < n; u ++) {
\t\tigm_full[u] = mp_add(igm_half[u], igm_half[u], p);
\t}
}

'''
    roots += array(base, 'PRIMES') + '\n'
    generated['bench/roots.c'] = roots
    for which, prefix, fname in (('original', 'orig_', 'mq_cm4.s'), ('optimized', 'opt_', 'mq_cm55.s')):
        asm = read(which, fname)
        head = asm[:asm.index('@ =======================================================================')]
        if which == 'original':
            start = asm.index('@ =======================================================================', asm.index('.size\tfndsa_mqpoly_sqnorm_int_to_signed'))
        else:
            start = asm.index('\t.align\t2\nfndsa_mqpoly_int_to_ntt__gmaddr_plus1_near:')
        end = re.search(r'^\s*\.size\s+fndsa_mqpoly_ntt_to_int,[^\n]+', asm, re.M).end()
        asm = head + f'\n\t.section .compare.{prefix}mq,"ax",%progbits\n' + asm[start:end] + '\n'
        generated[which + '/' + fname] = asm.replace('fndsa_', prefix)
        mq = read(which, 'mq.c')
        tables = '#include <stdint.h>\n'
        for name in ('mq_GM', 'mq_iGM'):
            tables += '\n__attribute__((aligned(32)))\n' + array(mq, name).replace(name, prefix + name) + '\n'
        if which == 'optimized':
            for name in ('GM', 'GM_twist', 'iGM', 'iGM_twist'):
                tables += '\n__attribute__((aligned(32)))\n' + array(mq, 'fndsa_mq_barrett3_' + name).replace('fndsa_', prefix) + '\n'
        generated[which + '/mq_tables.c'] = tables
    asm = read('optimized', 'kgen_mp31_cm55.s')
    assert sha(asm.encode()) == 'bad74cbe6f569a948b70f887b47cc0c5fc9f7e6130605df27adb70f3d88ece88', 'not the adopted K4C source'
    asm = asm.replace('fndsa_', 'opt_')
    asm = re.sub(r'^\s*\.text\s*$', '\n\t.section .compare.opt_mp,"ax",%progbits', asm, flags=re.M)
    generated['optimized/kgen_mp31_cm55.s'] = asm
    for name, text in generated.items():
        evidence['outputs'][name] = sha(text.encode())
    return generated, evidence

def main():
    p = argparse.ArgumentParser()
    p.add_argument('--write', action='store_true')
    p.add_argument('--check', action='store_true')
    args = p.parse_args()
    generated, manifest = outputs()
    generated['extraction.json'] = json.dumps(manifest, indent=2) + '\n'
    for name, text in generated.items():
        path = ROOT / name
        if args.write and not path.exists():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        if not path.is_file() or path.read_text() != text:
            raise SystemExit('missing/changed local extraction (not overwritten): ' + name)
    print(f'PASS extraction: {len(generated)-1} files; original function bodies preserved')

if __name__ == '__main__':
    main()
