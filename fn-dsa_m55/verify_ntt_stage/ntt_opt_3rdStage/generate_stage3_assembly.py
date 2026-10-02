#!/usr/bin/env python3
"""Generate readable stage-3 MVE reduction candidates from the frozen ref."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
REF = ROOT / "ref" / "mq_cm55.s"


def replace_once(source: str, old: str, new: str, what: str) -> str:
    count = source.count(old)
    if count != 1:
        raise ValueError(f"{what}: expected one occurrence, got {count}")
    return source.replace(old, new, 1)


def replace_in(source: str, start: str, end: str, old: str, new: str,
               expected: int, what: str) -> str:
    a = source.index(start)
    b = source.index(end, a)
    part = source[a:b]
    count = part.count(old)
    if count != expected:
        raise ValueError(f"{what}: expected {expected}, got {count}")
    return source[:a] + part.replace(old, new) + source[b:]


def replace_macro(source: str, name: str, body: str) -> str:
    pattern = re.compile(rf"\t\.macro\t{name}\b.*?\n\t\.endm", re.S)
    source, count = pattern.subn(lambda _: body.rstrip(), source, count=1)
    if count != 1:
        raise ValueError(f"macro {name}: expected one occurrence, got {count}")
    return source


LOAD_HELPERS = r"""
@ Load root[index] and twist[index], packing root in the low half and twist
@ in the high half of one GPR. r9 is twist_base-root_base.
	.macro	MQ_LOAD_PAIR dst, ptr
	ldrh	\dst, [\ptr]
	add.w	r14, \ptr, r9
	ldrh	r14, [r14]
	orr	\dst, \dst, r14, lsl #16
	add.w	\ptr, \ptr, #2
	.endm

	.macro	MQ_LOAD_PAIR_OFF dst, ptr, off
	ldrh	\dst, [\ptr, #\off]
	add.w	r14, \ptr, r9
	ldrh	r14, [r14, #\off]
	orr	\dst, \dst, r14, lsl #16
	.endm

@ Duplicate the two signed halfwords of a packed root/twist GPR.
	.macro	MQ_DUP_PAIR rootv, twistv, pair
	vdup.16	\rootv, \pair
	asr.w	r14, \pair, #16
	vdup.16	\twistv, r14
	.endm
"""


def candidate_macros(kind: str) -> tuple[str, str, str, str]:
    if kind == "mont3":
        mmul = r"""
	.macro	MQ_MVE_MMUL data, root, tmp, twist
	vmul.i16	\tmp, \data, \twist
	vqrdmulh.s16	\data, \data, \root
	vqrdmlah.s16	\data, \tmp, r10
	@ Algorithm 6 returns a signed representative in [-16836,16836]
	@ for q=12289. Normalize exactly to the existing [0,q) contract.
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	vsub.i16	\tmp, \data, r10
	vcmp.s16	ge, \tmp, zr
	vpst
	vmovt	\data, \tmp
	.endm

	.macro	MQ_MVE_MMUL_DEADTW data, root, twist
	vmul.i16	\twist, \data, \twist
	vqrdmulh.s16	\data, \data, \root
	vqrdmlah.s16	\data, \twist, r10
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	vsub.i16	\root, \data, r10
	vcmp.s16	ge, \root, zr
	vpst
	vmovt	\data, \root
	.endm
"""
        mmul3 = r"""
	.macro	MQ3_MVE_MMUL d, t0, t1, tw
	MQ_DUP_PAIR	\t1, \t0, \tw
	vmul.i16	\t0, \d, \t0
	vqrdmulh.s16	\d, \d, \t1
	vqrdmlah.s16	\d, \t0, r10
	vcmp.s16	lt, \d, zr
	vpst
	vaddt.i16	\d, \d, r10
	vcmp.s16	lt, \d, zr
	vpst
	vaddt.i16	\d, \d, r10
	vsub.i16	\t0, \d, r10
	vcmp.s16	ge, \t0, zr
	vpst
	vmovt	\d, \t0
	.endm
"""
    elif kind == "barrett3":
        mmul = r"""
	.macro	MQ_MVE_MMUL data, root, tmp, twist
	vqrdmulh.s16	\tmp, \data, \twist
	vmul.i16	\data, \data, \root
	vmla.i16	\data, \tmp, r10
	@ Exhaustive q=12289 analysis gives [-8447,8447]; one masked add
	@ restores the existing [0,q) contract.
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	.endm

	.macro	MQ_MVE_MMUL_DEADTW data, root, twist
	vqrdmulh.s16	\twist, \data, \twist
	vmul.i16	\data, \data, \root
	vmla.i16	\data, \twist, r10
	vcmp.s16	lt, \data, zr
	vpst
	vaddt.i16	\data, \data, r10
	.endm
"""
        mmul3 = r"""
	.macro	MQ3_MVE_MMUL d, t0, t1, tw
	MQ_DUP_PAIR	\t1, \t0, \tw
	vqrdmulh.s16	\t0, \d, \t0
	vmul.i16	\d, \d, \t1
	vmla.i16	\d, \t0, r10
	vcmp.s16	lt, \d, zr
	vpst
	vaddt.i16	\d, \d, r10
	.endm
"""
    else:
        raise ValueError(kind)

    mmul_x8 = mmul.split("\n\n\t.macro\tMQ_MVE_MMUL_DEADTW", 1)[0]
    mmul_x8 = mmul_x8.replace("MQ_MVE_MMUL", "MQ_MUL_X8", 1)
    return LOAD_HELPERS + mmul, mmul3, mmul_x8, kind


def mve_l5_candidate(block: str) -> str:
    block = block.replace(
        "fndsa_mqpoly_int_to_ntt__L5_mve:",
        "fndsa_mqpoly_int_to_ntt__L5_mve_stage3:", 1)
    block = block.replace(
        "\tvldrh.u16\tq7, [r8]          @ one first-layer twiddle per group\n"
        "\tadd.w\tr8, r8, #16\n",
        "\tvldrh.u16\tq7, [r8]          @ roots\n"
        "\tadd.w\tr12, r8, r9\n"
        "\tvldrh.u16\tq6, [r12]         @ twists\n"
        "\tadd.w\tr8, r8, #16\n", 1)
    a = block.index("\t@ q3 <- mmul(q3,q7)")
    b = block.index("\t@ q4 <- mmul(q4,q7).", a)
    block = block[:a] + "\tMQ_MVE_MMUL\tq3, q7, q5, q6\n\n" + block[b:]
    a = block.index("\t@ q4 <- mmul(q4,q7).")
    b = block.index("\t@ First of the fused layers.", a)
    block = block[:a] + "\tMQ_MVE_MMUL\tq4, q7, q5, q6\n\n" + block[b:]
    block = block.replace(
        "\tvld20.16\t{ q5, q6 }, [r7]\n"
        "\tvld21.16\t{ q5, q6 }, [r7]\n"
        "\tadd.w\tr7, r7, #32\n",
        "\tvld20.16\t{ q5, q6 }, [r7]      @ roots\n"
        "\tvld21.16\t{ q5, q6 }, [r7]\n"
        "\tadd.w\tr12, r7, r9\n"
        "\t@ VLD2 requires consecutive Q registers.  Reuse q6 for the\n"
        "\t@ even twist, keep the odd twist in q7, then reload roots.\n"
        "\tvld20.16\t{ q6, q7 }, [r12]     @ twists\n"
        "\tvld21.16\t{ q6, q7 }, [r12]\n", 1)
    a = block.index("\t@ q2 <- mmul(q2,q5)")
    b = block.index("\t@ q4 <- mmul(q4,q6)", a)
    block = block[:a] + "\tMQ_MVE_MMUL_DEADTW\tq2, q5, q6\n\n" + block[b:]
    a = block.index("\t@ q4 <- mmul(q4,q6)")
    b = block.index("\t@ Second fused layer.", a)
    block = block[:a] + (
        "\t@ Recover the two roots overwritten/consumed above.\n"
        "\tvld20.16\t{ q5, q6 }, [r7]\n"
        "\tvld21.16\t{ q5, q6 }, [r7]\n"
        "\tadd.w\tr7, r7, #32\n"
        "\tMQ_MVE_MMUL_DEADTW\tq4, q6, q7\n\n") + block[b:]
    block = block.replace(
        "bne\tfndsa_mqpoly_int_to_ntt__L5_mve",
        "bne\tfndsa_mqpoly_int_to_ntt__L5_mve_stage3")
    return block


def mve_l0_candidate(block: str) -> str:
    block = block.replace(
        "fndsa_mqpoly_ntt_to_int__L0_mve:",
        "fndsa_mqpoly_ntt_to_int__L0_mve_stage3:", 1)
    block = block.replace(
        "\tvld20.16\t{ q5, q6 }, [r7]\n"
        "\tvld21.16\t{ q5, q6 }, [r7]\n"
        "\tadd.w\tr7, r7, #32\n",
        "\tvld20.16\t{ q5, q6 }, [r7]      @ roots\n"
        "\tvld21.16\t{ q5, q6 }, [r7]\n"
        "\tadd.w\tr12, r7, r9\n"
        "\t@ VLD2 requires consecutive Q registers.  Reuse q6 for the\n"
        "\t@ even twist, keep the odd twist in q7, then reload roots.\n"
        "\tvld20.16\t{ q6, q7 }, [r12]     @ twists\n"
        "\tvld21.16\t{ q6, q7 }, [r12]\n", 1)
    a = block.index("\t@ q2 <- mmul(q2,q5)")
    b = block.index("\t@ Second inverse butterfly:", a)
    block = block[:a] + "\tMQ_MVE_MMUL_DEADTW\tq2, q5, q6\n\n" + block[b:]
    a = block.index("\t@ q4 <- mmul(q4,q6)")
    b = block.index("\t@ Second fused layer.", a)
    block = block[:a] + (
        "\t@ q7 was used as the first butterfly accumulator, so reload\n"
        "\t@ the twist pair before recovering the two roots.\n"
        "\tadd.w\tr12, r7, r9\n"
        "\tvld20.16\t{ q6, q7 }, [r12]\n"
        "\tvld21.16\t{ q6, q7 }, [r12]\n"
        "\tvld20.16\t{ q5, q6 }, [r7]\n"
        "\tvld21.16\t{ q5, q6 }, [r7]\n"
        "\tadd.w\tr7, r7, #32\n"
        "\tMQ_MVE_MMUL_DEADTW\tq4, q6, q7\n\n") + block[b:]
    block = block.replace(
        "\tvldrh.u16\tq7, [r8]\n\tadd.w\tr8, r8, #16\n",
        "\tvldrh.u16\tq7, [r8]          @ roots\n"
        "\tadd.w\tr12, r8, r9\n"
        "\tvldrh.u16\tq6, [r12]         @ twists\n"
        "\tadd.w\tr8, r8, #16\n", 1)
    # q6 holds the second-layer twist vector.  The reference kernel used q6
    # as a disposable parity mask because its legacy multiplier needed only
    # q7.  After each difference is formed, the corresponding old output
    # vector is dead, so reuse q1 and then q2 as masks.  q0 cannot be used:
    # its s0..s3 aliases hold public logn, the base pointer, and loop state.
    second_layer = block.index("\t@ Second fused layer.")
    output_layout = block.index("\t@ Output layout", second_layer)
    middle = block[second_layer:output_layout]
    middle = middle.replace(
        "\tvmov.i16\tq6, #1\n"
        "\tvand\tq6, q5, q6\n"
        "\tvcmp.i16\tne, q6, zr\n",
        "\tvmov.i16\tq1, #1\n"
        "\tvand\tq1, q5, q1\n"
        "\tvcmp.i16\tne, q1, zr\n", 1)
    middle = middle.replace(
        "\tvmov.i16\tq6, #1\n"
        "\tvand\tq6, q5, q6\n"
        "\tvcmp.i16\tne, q6, zr\n",
        "\tvmov.i16\tq2, #1\n"
        "\tvand\tq2, q5, q2\n"
        "\tvcmp.i16\tne, q2, zr\n", 1)
    block = block[:second_layer] + middle + block[output_layout:]
    a = block.index("\t@ q3 <- mmul(q3,q7)")
    b = block.index("\t@ q4 <- mmul(q4,q7).", a)
    block = block[:a] + "\tMQ_MVE_MMUL\tq3, q7, q5, q6\n\n" + block[b:]
    a = block.index("\t@ q4 <- mmul(q4,q7).")
    b = block.index("\t@ Output layout", a)
    block = block[:a] + "\tMQ_MVE_MMUL\tq4, q7, q5, q6\n\n" + block[b:]
    block = block.replace(
        "bne\tfndsa_mqpoly_ntt_to_int__L0_mve",
        "bne\tfndsa_mqpoly_ntt_to_int__L0_mve_stage3")
    block = block.replace(
        "\tb\tfndsa_mqpoly_ntt_to_int__L0_done",
        "\t@ Restore public logn kept in s0 for the shared epilogue.\n"
        "\tldr\tr12, [sp, #64]\n"
        "\tvmov\ts0, r12\n"
        "\tb\tfndsa_mqpoly_ntt_to_int__L0_done", 1)
    return block


def pack_loads(source: str) -> str:
    ranges = [
        ("fndsa_mqpoly_int_to_ntt__L512_CT2_group:",
         "fndsa_mqpoly_int_to_ntt__L512_not:"),
        ("fndsa_mqpoly_int_to_ntt__L3x512_block:",
         "fndsa_mqpoly_int_to_ntt__L512_CT2_packed:"),
        ("fndsa_mqpoly_int_to_ntt__L512_CT2_packed_loop:",
         "fndsa_mqpoly_int_to_ntt__F2_setup:"),
        ("fndsa_mqpoly_int_to_ntt__F2_middle:",
         "fndsa_mqpoly_int_to_ntt__L4:"),
        ("fndsa_mqpoly_ntt_to_int__I2_middle:",
         "fndsa_mqpoly_ntt_to_int__L1:"),
        ("fndsa_mqpoly_ntt_to_int__L512_GS2_packed_loop:",
         "fndsa_mqpoly_ntt_to_int__L3x512:"),
        ("fndsa_mqpoly_ntt_to_int__L3x512_block:",
         "fndsa_mqpoly_ntt_to_int__L512_GS2_wide:"),
    ]
    for start, end in ranges:
        a = source.index(start)
        b = source.index(end, a)
        part = source[a:b]
        part, n = re.subn(
            r"\tldrh\t(r(?:0|[3-8]|11)), \[(r(?:0|[4-8]|12))\], #2",
            r"\tMQ_LOAD_PAIR\t\1, \2",
            part,
        )
        if n == 0:
            raise ValueError(f"no root loads changed in {start}")
        source = source[:a] + part + source[b:]

    # The two adjacent child loads in the 1024 forward/inverse pair paths.
    source = replace_in(
        source,
        "fndsa_mqpoly_int_to_ntt__F2_middle:",
        "fndsa_mqpoly_int_to_ntt__L4:",
        "\tldr.w\tr12, [r7], #4\n\tuxth\tr11, r12\n\tlsr.w\tr6, r12, #16\n",
        "\tMQ_LOAD_PAIR\tr11, r7\n\tMQ_LOAD_PAIR\tr6, r7\n",
        1, "forward 1024 child roots")
    source = replace_in(
        source,
        "fndsa_mqpoly_ntt_to_int__I2_middle:",
        "fndsa_mqpoly_ntt_to_int__L1:",
        "\tldr.w\tr12, [r7], #4\n\tuxth\tr5, r12\n\tlsr.w\tr6, r12, #16\n",
        "\tMQ_LOAD_PAIR\tr5, r7\n\tMQ_LOAD_PAIR\tr6, r7\n",
        1, "inverse 1024 child roots")

    # Fixed iGM[1..3] loads in the final 512 inverse pass.
    source = replace_in(
        source,
        "fndsa_mqpoly_ntt_to_int__L512_GS2_wide:",
        "fndsa_mqpoly_ntt_to_int__L512_GS2_wide_loop:",
        "\tldrh\tr5, [r8, #2]\n\tldrh\tr6, [r8, #4]\n\tldrh\tr7, [r8, #6]\n",
        "\tMQ_LOAD_PAIR_OFF\tr5, r8, 2\n"
        "\tMQ_LOAD_PAIR_OFF\tr6, r8, 4\n"
        "\tMQ_LOAD_PAIR_OFF\tr7, r8, 6\n",
        1, "inverse 512 fixed roots")
    return source


def duplicate_packed_vectors(source: str) -> str:
    # Ordinary scalar root -> root/twist vector expansion in dedicated paths.
    ranges = [
        ("fndsa_mqpoly_int_to_ntt__L512_CT2_group:",
         "fndsa_mqpoly_int_to_ntt__L512_not:"),
        ("fndsa_mqpoly_int_to_ntt__F2_butterflies:",
         "fndsa_mqpoly_int_to_ntt__F2_half_store:"),
        ("fndsa_mqpoly_ntt_to_int__L512_GS2_wide_loop:",
         "fndsa_mqpoly_ntt_to_int__Lend:"),
    ]
    for start, end in ranges:
        a = source.index(start)
        b = source.index(end, a)
        part = source[a:b]
        part, n = re.subn(
            r"\tvdup\.16\tq7, (r(?:[3-8]|11))\n(?=\tMQ_(?:MVE_MMUL|MUL_X8))",
            r"\tMQ_DUP_PAIR\tq7, q6, \1\n",
            part,
        )
        if n == 0:
            raise ValueError(f"no pair duplication changed in {start}")
        source = source[:a] + part + source[b:]

    # MQ_GS_X8 receives packed root/twist in its scalar twreg.
    source = replace_once(
        source,
        "\tvdup.16\t\\tmp2, \\twreg\n"
        "\tMQ_MUL_X8\t\\right, \\tmp2, \\tmp0, \\tmp1",
        "\tMQ_DUP_PAIR\t\\tmp2, \\tmp1, \\twreg\n"
        "\tMQ_MUL_X8\t\\right, \\tmp2, \\tmp0, \\tmp1",
        "MQ_GS_X8 packed twiddle")
    return source


def packed_512_vectors(source: str, function: str, start: str, end: str) -> str:
    a = source.index(start)
    b = source.index(end, a)
    part = source[a:b]
    pattern = re.compile(
        r"\tvdup\.16\tq7, (r\d+)\n"
        r"\torr\tr12, (r\d+), \2, lsl #16\n"
        r"\tvmov\td15, r12, r12\n"
        r"(?=\tMQ_MVE_MMUL)")

    def repl(m: re.Match[str]) -> str:
        lo, hi = m.group(1), m.group(2)
        return (
            f"\tMQ_DUP_PAIR\tq7, q6, {lo}\n"
            f"\tuxth\tr12, {hi}\n"
            "\torr\tr12, r12, r12, lsl #16\n"
            "\tvmov\td15, r12, r12\n"
            f"\tasr.w\tr12, {hi}, #16\n"
            "\tuxth\tr12, r12\n"
            "\torr\tr12, r12, r12, lsl #16\n"
            "\tvmov\td13, r12, r12\n"
        )

    part, count = pattern.subn(repl, part)
    if count == 0:
        raise ValueError(f"{function}: no mixed packed vectors changed")
    return source[:a] + part + source[b:]


def generate(kind: str, directory: str, prefix: str) -> None:
    source = REF.read_text()
    mmul, mmul3, mmul_x8, _ = candidate_macros(kind)
    source = replace_macro(source, "MQ_MVE_MMUL", mmul)
    source = replace_macro(source, "MQ3_MVE_MMUL", mmul3)
    source = replace_macro(source, "MQ_MUL_X8", mmul_x8)

    source = source.replace(
        "\tpush.w\t{ r4, r5, r6, r7, r8, r10, r11, lr }",
        "\tpush.w\t{ r0, r4, r5, r6, r7, r8, r9, r10, r11, lr }")
    source = source.replace(
        "\tpop\t{ r4, r5, r6, r7, r8, r10, r11, pc }",
        "\tpop.w\t{ r0, r4, r5, r6, r7, r8, r9, r10, r11, pc }")

    fwd_label = (
        "fndsa_mqpoly_int_to_ntt__stage3_gmaddrs:\n"
        f"\t.word\t{prefix}_GM\n"
        f"\t.word\t{prefix}_GM_twist\n")
    source = replace_once(
        source,
        "fndsa_mqpoly_int_to_ntt__gmaddr_plus1_near:\n"
        "\t.word\tfndsa_mq_GM + 2\n",
        "fndsa_mqpoly_int_to_ntt__gmaddr_plus1_near:\n"
        "\t.word\tfndsa_mq_GM + 2\n" + fwd_label,
        "forward candidate addresses")
    source = replace_once(
        source,
        "\t@ r8 <- &mq_GM[1]\n"
        "\tadr\tr8, fndsa_mqpoly_int_to_ntt__gmaddr_plus1_near\n"
        "\tldr\tr8, [r8]\n",
        "\t@ q=12289 stage-3 tables are used only by FN-DSA-512/1024.\n"
        "\t@ r0 has already been cleared above; recover the public logn saved\n"
        "\t@ in s0 before selecting the table pair.\n"
        "\tvmov\tr12, s0\n"
        "\tcmp\tr12, #9\n"
        "\tblo\tfndsa_mqpoly_int_to_ntt__legacy_gm\n"
        "\tadr\tr12, fndsa_mqpoly_int_to_ntt__stage3_gmaddrs\n"
        "\tldmia.w\tr12, { r8, r9 }\n"
        "\tsub.w\tr9, r9, r8\n"
        "\tadd.w\tr8, r8, #2\n"
        "\tb\tfndsa_mqpoly_int_to_ntt__gm_ready\n"
        "fndsa_mqpoly_int_to_ntt__legacy_gm:\n"
        "\tadr\tr8, fndsa_mqpoly_int_to_ntt__gmaddr_plus1_near\n"
        "\tldr\tr8, [r8]\n"
        "\tmovs\tr9, #0\n"
        "fndsa_mqpoly_int_to_ntt__gm_ready:\n",
        "forward table selection")

    inv_label = (
        "fndsa_mqpoly_ntt_to_int__stage3_igmaddrs:\n"
        f"\t.word\t{prefix}_iGM\n"
        f"\t.word\t{prefix}_iGM_twist\n")
    source = replace_once(
        source,
        "fndsa_mqpoly_ntt_to_int__igmaddr_near:\n"
        "\t.word\tfndsa_mq_iGM\n",
        "fndsa_mqpoly_ntt_to_int__igmaddr_near:\n"
        "\t.word\tfndsa_mq_iGM\n" + inv_label,
        "inverse candidate addresses")
    source = replace_once(
        source,
        "\tadr\tr8, fndsa_mqpoly_ntt_to_int__igmaddr_near\n"
        "\tldr\tr8, [r8]\n"
        "\tmovs\tr3, #1\n",
        "\tcmp\tr0, #9\n"
        "\tblo\tfndsa_mqpoly_ntt_to_int__legacy_igm\n"
        "\tadr\tr12, fndsa_mqpoly_ntt_to_int__stage3_igmaddrs\n"
        "\tldmia.w\tr12, { r8, r9 }\n"
        "\tsub.w\tr9, r9, r8\n"
        "\tb\tfndsa_mqpoly_ntt_to_int__igm_ready\n"
        "fndsa_mqpoly_ntt_to_int__legacy_igm:\n"
        "\tadr\tr8, fndsa_mqpoly_ntt_to_int__igmaddr_near\n"
        "\tldr\tr8, [r8]\n"
        "\tmovs\tr9, #0\n"
        "fndsa_mqpoly_ntt_to_int__igm_ready:\n"
        "\tmovs\tr3, #1\n",
        "inverse table selection")
    # The dedicated logn=10 inverse pair loop reloads the iGM base on every
    # outer iteration.  Keep that reload on the stage-3 root table; otherwise
    # MQ_LOAD_PAIR combines a legacy Montgomery root with an unrelated word
    # at the stage-3 twist offset.
    source = replace_in(
        source,
        "fndsa_mqpoly_ntt_to_int__I2_outer:",
        "fndsa_mqpoly_ntt_to_int__Lend:",
        "\tadr\tr8, fndsa_mqpoly_ntt_to_int__igmaddr_near\n"
        "\tldr\tr8, [r8]\n",
        "\tadr\tr8, fndsa_mqpoly_ntt_to_int__stage3_igmaddrs\n"
        "\tldr\tr8, [r8]\n",
        1, "inverse 1024 stage-3 table reload")
    # The far address is used only by the dedicated FN-DSA-512 inverse code.
    source = source.replace(
        "fndsa_mqpoly_ntt_to_int__igmaddr:\n\t.word\tfndsa_mq_iGM",
        f"fndsa_mqpoly_ntt_to_int__igmaddr:\n\t.word\t{prefix}_iGM")

    source = pack_loads(source)
    source = duplicate_packed_vectors(source)
    source = packed_512_vectors(
        source, "forward packed 512",
        "fndsa_mqpoly_int_to_ntt__L512_CT2_packed_loop:",
        "fndsa_mqpoly_int_to_ntt__F2_setup:")
    source = packed_512_vectors(
        source, "inverse packed 512",
        "fndsa_mqpoly_ntt_to_int__L512_GS2_packed_loop:",
        "fndsa_mqpoly_ntt_to_int__L3x512:")

    # Candidate version of the shared last-two-forward-layer vector block.
    a = source.index("fndsa_mqpoly_int_to_ntt__L5_mve:")
    b = source.index("fndsa_mqpoly_int_to_ntt__L5:", a)
    original = source[a:b]
    candidate = mve_l5_candidate(original)
    source = source[:a] + candidate + "\n" + original + source[b:]
    source = replace_once(
        source,
        "\tcmp\tr3, #8\n\tblo\tfndsa_mqpoly_int_to_ntt__L5\n\n"
        "fndsa_mqpoly_int_to_ntt__L5_mve_stage3:",
        "\tcmp\tr3, #8\n\tblo\tfndsa_mqpoly_int_to_ntt__L5\n"
        "\tcmp\tr9, #0\n"
        "\tbeq\tfndsa_mqpoly_int_to_ntt__L5_mve\n\n"
        "fndsa_mqpoly_int_to_ntt__L5_mve_stage3:",
        "forward candidate dispatch")

    # Candidate version of the shared first-two-inverse-layer vector block.
    a = source.index("fndsa_mqpoly_ntt_to_int__L0_mve:")
    b = source.index("fndsa_mqpoly_ntt_to_int__L0:", a)
    original = source[a:b]
    candidate = mve_l0_candidate(original)
    source = source[:a] + candidate + "\n" + original + source[b:]
    source = replace_once(
        source,
        "\tcmp\tr3, #8\n\tblo\tfndsa_mqpoly_ntt_to_int__L0\n\n"
        "fndsa_mqpoly_ntt_to_int__L0_mve_stage3:",
        "\tcmp\tr3, #8\n\tblo\tfndsa_mqpoly_ntt_to_int__L0\n"
        "\tcmp\tr9, #0\n"
        "\tbeq\tfndsa_mqpoly_ntt_to_int__L0_mve\n\n"
        "fndsa_mqpoly_ntt_to_int__L0_mve_stage3:",
        "inverse candidate dispatch")

    # All dedicated packed-root calls now need root and twist expansion.
    # Any remaining vdup immediately before a candidate macro indicates a miss.
    for match in re.finditer(r"vdup\.16\s+q7, r\d+\n\s+MQ_(?:MVE_MMUL|MUL_X8)", source):
        line = source.count("\n", 0, match.start()) + 1
        raise ValueError(f"unconverted packed twiddle at line {line}")

    header = (
        f"@ GENERATED stage-3 {kind} candidate.\n"
        "@ Source layout is frozen from ntt_opt stage 2; only q=12289\n"
        "@ constant-twiddle multiplication and its tables are changed.\n")
    probe = r"""

@ Diagnostic entry used by the stage-3 exactness harness.  q0-q3 and r0-r3
@ are caller-saved; r10 is preserved explicitly.
	.align	2
	.global	fndsa_stage3_mul_probe
	.thumb
	.thumb_func
	.type	fndsa_stage3_mul_probe, %function
fndsa_stage3_mul_probe:
	push	{ r10, lr }
	movw	r10, #Q
	vdup.16	q0, r0
	uxth	r1, r1
	orr	r1, r1, r2, lsl #16
	MQ_DUP_PAIR	q1, q3, r1
	MQ_MVE_MMUL	q0, q1, q2, q3
	vmov	r0, s0
	uxth	r0, r0
	pop	{ r10, pc }
	.size	fndsa_stage3_mul_probe,.-fndsa_stage3_mul_probe
"""
    (ROOT / directory / "mq_cm55.s").write_text(header + source + probe)


def main() -> None:
    generate("mont3", "m1_3instruction_montgomery", "fndsa_mq_mont3")
    generate("barrett3", "b1_3instruction_Barrett", "fndsa_mq_barrett3")


if __name__ == "__main__":
    main()
