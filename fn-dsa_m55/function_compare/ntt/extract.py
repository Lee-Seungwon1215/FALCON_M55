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
           # Immutable pre-K1 D1 source.  The extractor then applies the
           # documented K0 -> K1 full-iGM transformation mechanically.
           "optimized": WORK / "ntt_ntrusolve/4th_array_compare/D1_vld4_last"}

K1_FULL_IGM_FALLBACK = r'''opt_mp_iNTT_c(unsigned logn, uint32_t *restrict a, const uint32_t *restrict igm,
	uint32_t p, uint32_t p0i)
{
	if (logn == 0) {
		return;
	}

	/* This fallback consumes the same full inverse roots w*R as the K1
	 * assembly.  It is used only for logn < 4, so a compact unscaled GS
	 * implementation followed by one final 1/n pass is preferable to a
	 * second half-root contract. */
	size_t n = (size_t)1 << logn;
	size_t t = 1;
	for (size_t m = n; m > 1; m >>= 1, t <<= 1) {
		size_t hm = m >> 1;
		size_t dt = t << 1;
		size_t j0 = 0;
		for (size_t i = 0; i < hm; i ++) {
			uint32_t s = igm[i + hm];
			for (size_t j = 0; j < t; j ++) {
				size_t k0 = j0 + j;
				size_t k1 = k0 + t;
				uint32_t x0 = a[k0];
				uint32_t x1 = a[k1];
				a[k0] = mp_add(x0, x1, p);
				a[k1] = mp_mmul(mp_sub(x0, x1, p), s, p, p0i);
			}
			j0 += dt;
		}
	}
	uint32_t ni = (uint32_t)(((uint64_t)1 << (32 - logn)) % p);
	for (size_t u = 0; u < n; u ++) {
		a[u] = mp_mmul(a[u], ni, p, p0i);
	}
}'''

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
    evidence = {"inputs": {}, "outputs": {}, "adaptations": [
        "public symbol namespaces orig_/opt_ (no algorithm change)",
        "NTT-only extraction, local minimal headers, ELF placement sections",
        "M4 inline assembly enabled for original RNS and optimized small fallback",
        "K1 optimized iNTT consumes full w*R inverse roots and uses a matching small fallback",
        "K2 optimized RNS NTT/iNTT pipelines root preparation across independent butterfly work",
        "mq tables copied from respective source; RNS roots generated once outside timing"]}
    def read(which, name):
        p = SOURCES[which] / name
        data = p.read_bytes()
        evidence['inputs'][str(p.relative_to(WORK))] = sha(data)
        return data.decode()
    inner = read('original', 'inner.h')
    hdr = read('original', 'kgen_inner.h')
    helpers = '#pragma once\n#include <stdint.h>\n#include <stddef.h>\n#define FNDSA_ASM_CORTEXM4 1\n'
    for name in ('tbmask', 'mp_R', 'mp_hR', 'mp_add', 'mp_sub', 'mp_half', 'mp_mmul'):
        helpers += '\nstatic inline uint32_t\n' + function(inner if name == 'tbmask' else hdr, name) + '\n'
    generated['original/mp_helpers.h'] = helpers
    base = read('original', 'kgen_mp31.c')
    c = '#include "mp_helpers.h"\n#include "../bench/api.h"\n'
    for name in ('mp_NTT', 'mp_iNTT'):
        c += '\n__attribute__((section(".compare.orig_mp"), noinline))\nvoid\n'
        c += function(base, name).replace(name + '(', 'orig_' + name + '(', 1) + '\n'
    generated['original/kgen_mp31.c'] = c
    c = '#include "../original/mp_helpers.h"\n#include "../bench/api.h"\n'
    # The forward fallback remains the exact upstream body.  K1 gives the
    # inverse fallback the same full-root/final-scaling contract as its ASM.
    current = read('optimized', 'kgen_mp31.c')
    old_body = function(base, 'mp_NTT').split('{', 1)[1]
    current_body = function(current, 'mp_NTT').split('{', 1)[1]
    assert old_body == current_body, 'forward fallback arithmetic has changed'
    c += '\nvoid\n' + function(base, 'mp_NTT').replace('mp_NTT(', 'opt_mp_NTT_c(', 1) + '\n'
    c += '\nvoid\n' + K1_FULL_IGM_FALLBACK + '\n'
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
    replacements = [
        (' *   - unscaled inverse layers, with 1/n fused into the last GS layer;\n',
         ' *   - unscaled inverse layers, with 1/n fused into the last GS layer;\n'
         ' *   - full inverse roots w*R prepared outside the timed transform;\n'),
        ('or Slothy scheduling. Existing gm/igm arrays are never modified.',
         'or Slothy scheduling. Existing gm/full-igm arrays are never modified.'),
        (' * Existing gm/igm values, including inverse half-scaled roots, are intact.\n',
         ' * Forward gm values are unchanged. The inverse input table contains w*R\n'
         ' * instead of the traditional w*R/2; the original half-scaled table remains\n'
         ' * separate in the comparison harness.\n'),
        ('/* igm contains w*R/2. Restore w*R in a register, not in the shared table.\n'
         ' * Canonical modular doubling is required: p is almost 2^31, not a small q.\n'
         ' */\n\t.macro MP31_IROOT root\n\tMP31_ADD\t\\root, \\root, \\root\n\tMP31_ROOT\t\\root\n\t.endm',
         '/* The K1 inverse table already contains w*R. */\n'
         '\t.macro MP31_IROOT root\n\tMP31_ROOT\t\\root\n\t.endm'),
        (' * Mont(igm[1],r5) followed by modular doubling gives w*R/n.',
         ' * Mont(igm_full[1],r5) directly gives w*R/n.'),
        ('\tMP31_MONT\tq0, q4, q6\n\tMP31_ADD\tq0, q0, q0\n\tvmov\t\t\\dst, s0',
         '\tMP31_MONT\tq0, q4, q6\n\tvmov\t\t\\dst, s0')]
    for old, new in replacements:
        assert asm.count(old) == 1, 'K1 extraction anchor changed'
        asm = asm.replace(old, new)

    # K2 is a pure scheduling transformation.  It neither changes the
    # butterfly equations nor adds/removes coefficient/root memory accesses.
    # The next root load and low-word root*p0i preparation are moved into the
    # independent tail of the preceding butterfly.  Keep these as exact,
    # fail-closed replacements so the checked-in assembly remains mechanically
    # reproducible from the immutable D1 input above.
    replacements = [
        (' *   - full inverse roots w*R prepared outside the timed transform;\n',
         ' *   - full inverse roots w*R prepared outside the timed transform;\n'
         ' *   - K2 root preparation pipelined across independent butterfly work;\n'),
        ('/* Unchanged CT2 arithmetic. Only the load/store boundary varies below.\n',
         '/* CT2 arithmetic and memory order are unchanged. Root preparation for the\n'
         ' * next butterfly overlaps independent add/sub work from the previous one.\n'),
        ('/* Unchanged GS2 arithmetic; r8 = first root, r2 = igm, r0 scratch. */\n',
         '/* GS2 arithmetic and memory order are unchanged. Root preparation for the\n'
         ' * next butterfly overlaps the previous result move.\n'
         ' * r8 = first root, r2 = igm, r0 scratch.\n'
         ' */\n'),
        ('''\t.macro MP31_CT2_TILE
\tldr\t\tr0, [r8]
\tvdup.32\t\tq4, r0
\tMP31_ROOT\tq4
\tMP31_MONT\tq2, q4, q6
\tMP31_CT\tq0, q2, q7
\tMP31_MONT\tq3, q4, q6
\tMP31_CT\tq1, q3, q7
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr6, [r0]
\tvdup.32\t\tq4, r6
\tMP31_ROOT\tq4
\tMP31_MONT\tq1, q4, q6
\tMP31_CT\tq0, q1, q7
\tldr\t\tr6, [r0, #4]
\tvdup.32\t\tq4, r6
\tMP31_ROOT\tq4
\tMP31_MONT\tq3, q4, q6
\tMP31_CT\tq2, q3, q7
\t.endm''',
         '''\t.macro MP31_CT2_TILE
\tldr\t\tr0, [r8]
\tvdup.32\t\tq4, r0
\tMP31_ROOT\tq4
\tMP31_MONT\tq2, q4, q6
\tMP31_CT\tq0, q2, q7
\tMP31_MONT\tq3, q4, q6
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr6, [r0]
\tvdup.32\t\tq4, r6
\tMP31_ROOT\tq4
\tMP31_CT\tq1, q3, q7
\tMP31_MONT\tq1, q4, q6
\tldr\t\tr6, [r0, #4]
\tvdup.32\t\tq4, r6
\tMP31_ROOT\tq4
\tMP31_CT\tq0, q1, q7
\tMP31_MONT\tq3, q4, q6
\tMP31_CT\tq2, q3, q7
\t.endm'''),
        ('''\t.macro MP31_GS2_TILE
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr0, [r0]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tMP31_GS\tq0, q1, q4, q7, q6
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr0, [r0, #4]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tMP31_GS\tq2, q3, q4, q7, q6
\tldr\t\tr0, [r8]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tMP31_GS\tq0, q2, q4, q7, q6
\tMP31_GS\tq1, q3, q4, q7, q6
\t.endm''',
         '''\t.macro MP31_GS2_TILE
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr0, [r0]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tvsub.i32\tq7, q0, q1
\tMP31_ADD\tq0, q0, q1
\tMP31_MONT\tq7, q4, q6
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr0, [r0, #4]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tvmov\t\tq1, q7
\tvsub.i32\tq7, q2, q3
\tMP31_ADD\tq2, q2, q3
\tMP31_MONT\tq7, q4, q6
\tldr\t\tr0, [r8]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tvmov\t\tq3, q7
\tMP31_GS\tq0, q2, q4, q7, q6
\tMP31_GS\tq1, q3, q4, q7, q6
\t.endm'''),
        ('''\tldr\t\tr0, [r8]
\tvdup.32\t\tq4, r0\t\t\t/* s */
\tMP31_ROOT\tq4
\tMP31_MONT\tq2, q4, q6
\tMP31_CT\tq0, q2, q7
\tMP31_MONT\tq3, q4, q6
\tMP31_CT\tq1, q3, q7
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2\t\t/* &gm[2*(i+m)] */
\tldr\t\tr6, [r0]
\tvdup.32\t\tq4, r6\t\t\t/* s0 */
\tMP31_ROOT\tq4
\tMP31_MONT\tq1, q4, q6
\tMP31_CT\tq0, q1, q7
\tldr\t\tr6, [r0, #4]
\tvdup.32\t\tq4, r6\t\t\t/* s1 */
\tMP31_ROOT\tq4
\tMP31_MONT\tq3, q4, q6
\tMP31_CT\tq2, q3, q7
''', '''\tMP31_CT2_TILE
'''),
        ('''\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr0, [r0]
\tvdup.32\t\tq4, r0\t\t\t/* s0 */
\tMP31_IROOT\tq4
\tMP31_GS\tq0, q1, q4, q7, q6
\tadd\t\tr0, r8, r8
\tsub\t\tr0, r0, r2
\tldr\t\tr0, [r0, #4]
\tvdup.32\t\tq4, r0\t\t\t/* s1 */
\tMP31_IROOT\tq4
\tMP31_GS\tq2, q3, q4, q7, q6
\tldr\t\tr0, [r8]
\tvdup.32\t\tq4, r0\t\t\t/* s */
\tMP31_IROOT\tq4
\tMP31_GS\tq0, q2, q4, q7, q6
\tMP31_GS\tq1, q3, q4, q7, q6
''', '''\tMP31_GS2_TILE
'''),
        ('''\tMP31_MONT\tq2, q4, q6
\tMP31_CT\tq0, q2, q7
\tMP31_MONT\tq3, q4, q6
\tMP31_CT\tq1, q3, q7
\tadr\t\tr0, .Lmp31_stride8
\tvldrw.u32\tq7, [r0]
\tvldrw.u32\tq4, [r9, q7]\t\t/* s0 */
\tMP31_ROOT\tq4
\tMP31_MONT\tq1, q4, q6
\tMP31_CT\tq0, q1, q7
\tadr\t\tr0, .Lmp31_stride8
\tvldrw.u32\tq7, [r0]
\tadd\t\tr11, r9, #4
\tvldrw.u32\tq4, [r11, q7]\t\t/* s1 */
\tMP31_ROOT\tq4
\tMP31_MONT\tq3, q4, q6''',
         '''\tMP31_MONT\tq2, q4, q6
\tMP31_CT\tq0, q2, q7
\tMP31_MONT\tq3, q4, q6
\tadr\t\tr0, .Lmp31_stride8
\tvldrw.u32\tq7, [r0]
\tvldrw.u32\tq4, [r9, q7]\t\t/* s0 */
\tMP31_ROOT\tq4
\tMP31_CT\tq1, q3, q7
\tMP31_MONT\tq1, q4, q6
\tadr\t\tr0, .Lmp31_stride8
\tvldrw.u32\tq7, [r0]
\tadd\t\tr11, r9, #4
\tvldrw.u32\tq4, [r11, q7]\t\t/* s1 */
\tMP31_ROOT\tq4
\tMP31_CT\tq0, q1, q7
\tMP31_MONT\tq3, q4, q6'''),
        ('''\tMP31_MONT\tq2, q4, q6
\tMP31_CT\tq0, q2, q7
\tMP31_MONT\tq3, q4, q6
\tMP31_CT\tq1, q3, q7
\tadr.w\t\tr0, .Lsmall_stride8
\tvldrw.u32\tq7, [r0]
\tvldrw.u32\tq4, [r9, q7]\t\t/* s0 */
\tMP31_ROOT\tq4
\tMP31_MONT\tq1, q4, q6
\tMP31_CT\tq0, q1, q7
\tadr.w\t\tr0, .Lsmall_stride8
\tvldrw.u32\tq7, [r0]
\tadd\t\tr11, r9, #4
\tvldrw.u32\tq4, [r11, q7]\t\t/* s1 */
\tMP31_ROOT\tq4
\tMP31_MONT\tq3, q4, q6''',
         '''\tMP31_MONT\tq2, q4, q6
\tMP31_CT\tq0, q2, q7
\tMP31_MONT\tq3, q4, q6
\tadr.w\t\tr0, .Lsmall_stride8
\tvldrw.u32\tq7, [r0]
\tvldrw.u32\tq4, [r9, q7]\t\t/* s0 */
\tMP31_ROOT\tq4
\tMP31_CT\tq1, q3, q7
\tMP31_MONT\tq1, q4, q6
\tadr.w\t\tr0, .Lsmall_stride8
\tvldrw.u32\tq7, [r0]
\tadd\t\tr11, r9, #4
\tvldrw.u32\tq4, [r11, q7]\t\t/* s1 */
\tMP31_ROOT\tq4
\tMP31_CT\tq0, q1, q7
\tMP31_MONT\tq3, q4, q6'''),
        ('''\tvldrw.u32\tq4, [r9, q7]\t\t/* s0 */
\tMP31_IROOT\tq4
\tMP31_GS\tq0, q1, q4, q7, q6
\tadr\t\tr0, .Lmp31_stride8
\tvldrw.u32\tq7, [r0]
\tadd\t\tr11, r9, #4
\tvldrw.u32\tq4, [r11, q7]\t\t/* s1 */
\tMP31_IROOT\tq4
\tMP31_GS\tq2, q3, q4, q7, q6
\tvldrw.u32\tq4, [r8], #16\t\t/* s */
\tMP31_IROOT\tq4''',
         '''\tvldrw.u32\tq4, [r9, q7]\t\t/* s0 */
\tMP31_IROOT\tq4
\tvsub.i32\tq7, q0, q1
\tMP31_ADD\tq0, q0, q1
\tMP31_MONT\tq7, q4, q6
\tadr\t\tr0, .Lmp31_stride8
\tvldrw.u32\tq6, [r0]
\tadd\t\tr11, r9, #4
\tvldrw.u32\tq4, [r11, q6]\t\t/* s1 */
\tMP31_IROOT\tq4
\tvmov\t\tq1, q7
\tvsub.i32\tq7, q2, q3
\tMP31_ADD\tq2, q2, q3
\tMP31_MONT\tq7, q4, q6
\tvldrw.u32\tq4, [r8], #16\t\t/* s */
\tMP31_IROOT\tq4
\tvmov\t\tq3, q7'''),
        ('''\tldr\t\tr0, [r2, #8]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tMP31_GS\tq0, q1, q4, q7, q6
\tldr\t\tr0, [r2, #12]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tMP31_GS\tq2, q3, q4, q7, q6
\tvdup.32\t\tq4, r7
\tMP31_ROOT\tq4
\tMP31_GS\tq0, q2, q4, q7, q6
\tMP31_GS\tq1, q3, q4, q7, q6
\tvdup.32\t\tq4, r5
\tMP31_ROOT\tq4''',
         '''\tldr\t\tr0, [r2, #8]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tvsub.i32\tq7, q0, q1
\tMP31_ADD\tq0, q0, q1
\tMP31_MONT\tq7, q4, q6
\tldr\t\tr0, [r2, #12]
\tvdup.32\t\tq4, r0
\tMP31_IROOT\tq4
\tvmov\t\tq1, q7
\tvsub.i32\tq7, q2, q3
\tMP31_ADD\tq2, q2, q3
\tMP31_MONT\tq7, q4, q6
\tvdup.32\t\tq4, r7
\tMP31_ROOT\tq4
\tvmov\t\tq3, q7
\tMP31_GS\tq0, q2, q4, q7, q6
\tvsub.i32\tq7, q1, q3
\tMP31_ADD\tq1, q1, q3
\tMP31_MONT\tq7, q4, q6
\tvdup.32\t\tq4, r5
\tMP31_ROOT\tq4
\tvmov\t\tq3, q7'''),
        ('''\tvdup.32\t\tq4, r8
\tMP31_ROOT\tq4
\tMP31_GS\tq0, q1, q4, q7, q6
\tvdup.32\t\tq4, r5
\tMP31_ROOT\tq4''',
         '''\tvdup.32\t\tq4, r8
\tMP31_ROOT\tq4
\tvsub.i32\tq7, q0, q1
\tMP31_ADD\tq0, q0, q1
\tMP31_MONT\tq7, q4, q6
\tvdup.32\t\tq4, r5
\tMP31_ROOT\tq4
\tvmov\t\tq1, q7''')]
    expected_counts = [1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1]
    for index, ((old, new), count) in enumerate(zip(replacements, expected_counts)):
        actual = asm.count(old)
        assert actual == count, f'K2 extraction anchor {index} changed: {actual} != {count}'
        asm = asm.replace(old, new)
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
