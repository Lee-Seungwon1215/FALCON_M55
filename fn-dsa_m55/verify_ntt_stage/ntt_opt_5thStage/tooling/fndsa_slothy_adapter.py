"""Conservative, auditable adapter for the pinned SLOTHY Armv8.1-M backend.

Most scheduling units are single instructions. Predicate triples and complete
VLD2/VLD4/VST4 sequences are indivisible units. No arithmetic transformation,
memory-order relaxation, implicit padding, or address-offset fixup is allowed.
The output is expanded back into ordinary, standalone GNU assembly.
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent / "slothy"))
from slothy.targets.arm_v81m import arch_v81m as base
from slothy.targets.arm_v81m import cortex_m55r1 as m55
from slothy.helper import SourceLine

RegisterType = base.RegisterType
arch_name = "FNDSA_Arm_v81M_conservative"
llvm_mca_arch = "arm"
llvm_mc_arch = llvm_mc_attr = unicorn_arch = unicorn_mode = None
REG = re.compile(r"\b(?:r(?:1[0-4]|[0-9])|q[0-7]|d(?:[12][0-9]|3[01]|[0-9])|s(?:[12][0-9]|3[01]|[0-9]))\b")
SPECS = {}


def parent(reg):
    if reg.startswith("d"):
        return f"q{int(reg[1:]) // 2}"
    if reg.startswith("s"):
        return f"q{int(reg[1:]) // 4}"
    return reg


def unit(lines):
    """Encode a unit, preserving old values for every partial register write."""
    reads, writes, partial, touched = set(), set(), set(), set()
    memory = False
    for line in lines:
        op, arg = line.split(None, 1) if " " in line else (line, "")
        regs = REG.findall(arg)
        pp = [parent(r) for r in regs]
        touched.update(pp)
        rd, wr = set(), set()
        if op.startswith("vcmp"):
            rd.update(pp)
        elif op == "vpst":
            pass
        elif op.startswith(("vst", "str")):
            memory = True
            rd.update(pp)
        elif op.startswith(("vld", "ldr")):
            memory = True
            if op.startswith(("vld2", "vld4")):
                wr.update(pp[:-1])
                rd.add(pp[-1])
            else:
                wr.add(pp[0])
                rd.update(pp[1:])
                if regs[0].startswith(("d", "s")):
                    rd.add(pp[0])
                    partial.add(pp[0])
        elif op in {"add.w", "sub.w", "asr.w", "orr", "orr.w", "uxth", "mov", "mov.w",
                    "vmov", "vmov.i16", "vdup.16", "vadd.i16", "vsub.i16", "vmul.i16",
                    "vmla.i16", "vqrdmulh.s16", "vaddt.i16", "vand", "vshr.u16"}:
            wr.add(pp[0])
            rd.update(pp[1:])
            if op in {"vmla.i16", "vaddt.i16"} or regs[0].startswith(("d", "s")):
                rd.add(pp[0])
            if regs[0].startswith(("d", "s")):
                partial.add(pp[0])
        else:
            raise ValueError(f"Unsupported instruction (fail closed): {line}")
        reads.update(rd - writes)
        writes.update(wr)
    # All memory accesses are serialized, including across the halving seam.
    # This is intentionally conservative: NTRU scratch aliases need no guesses.
    if memory:
        reads.add("hint_memory")
        writes.add("hint_memory")
    inp = sorted(reads - writes)
    io = sorted(reads & writes)
    out = sorted(writes - reads)
    key = f"fndsa_op{len(SPECS):05d}"
    order = out + io + inp
    SPECS[key] = dict(lines=lines, inp=inp, io=io, out=out, order=order,
                      touched=sorted(touched), partial=sorted(partial), memory=memory)
    return SourceLine(key + " " + ", ".join(order))


def encode(lines):
    lines = [re.sub(r"\s+", " ", x.strip()) for x in lines if x.strip()]
    result, i = [], 0
    while i < len(lines):
        op = lines[i].split()[0]
        size = 1
        if op.startswith("vcmp"):
            assert lines[i + 1] == "vpst" and lines[i + 2].startswith("vaddt.i16 ")
            size = 3
        elif op.startswith(("vld40.", "vst40.")):
            size = 4
            assert all(lines[i + k].startswith(op[:4] + str(k) + ".") for k in range(4))
        elif op.startswith("vld20."):
            size = 2
            assert lines[i + 1].startswith("vld21.")
        elif op.startswith(("vpst", "vaddt", "vld2", "vld4", "vst4")):
            raise ValueError(f"Incomplete atomic group: {lines[i]}")
        result.append(unit(lines[i:i + size]))
        i += size
    return result


class Instruction(base.Instruction):
    @staticmethod
    def parser(src_line):
        key, arguments = src_line.text.strip().split(None, 1)
        spec = SPECS[key]
        ty = RegisterType.find_type
        inst = Instruction(mnemonic=key, arg_types_in=list(map(ty, spec["inp"])),
                           arg_types_in_out=list(map(ty, spec["io"])),
                           arg_types_out=list(map(ty, spec["out"])))
        regs = [x.strip() for x in arguments.split(",")]
        a, b = len(spec["out"]), len(spec["io"])
        assert len(regs) == len(spec["order"])
        inst.args_out, inst.args_in_out, inst.args_in = regs[:a], regs[a:a+b], regs[a+b:]
        inst.source_line, inst.spec = src_line, spec
        # Fixed/consecutive register lists are kept in their original registers.
        # Scalar state, partial views, and q0 aliases are also pinned by config.
        if any(x.startswith(("vld2", "vld4", "vst4")) for x in spec["lines"]):
            for kind in ("out", "in_out", "in"):
                args = getattr(inst, "args_" + kind)
                setattr(inst, "args_" + kind + "_restrictions",
                        [[r] if r.startswith("q") else None for r in args])
        return [inst]

    # Memory addresses are explicit operands plus the memory token. Prevent
    # upstream offset-fixup from making assumptions about encoded operations.
    def is_load_store_instruction(self): return False
    def is_vector_load(self): return any(x.startswith("vld") for x in self.spec["lines"])
    def is_vector_store(self): return any(x.startswith("vst") for x in self.spec["lines"])
    def is_scalar_load(self): return any(x.startswith("ldr") for x in self.spec["lines"])
    def is_load(self): return self.is_vector_load() or self.is_scalar_load()
    def is_store(self): return self.is_vector_store()
    def is_stack_load(self): return False
    def is_stack_store(self): return False


def decode(source):
    result = []
    for sl in SourceLine.reduce_source(source):
        inst = Instruction.parser(sl)[0]
        mapping = dict(zip(inst.spec["order"], inst.args_out + inst.args_in_out + inst.args_in))
        def replace(m):
            old = m.group()
            assert parent(old) in mapping, (inst.mnemonic, inst.spec, mapping, sl.text)
            new = mapping[parent(old)]
            if old.startswith("d"):
                return f"d{int(new[1:]) * 2 + int(old[1:]) % 2}"
            if old.startswith("s"):
                return f"s{int(new[1:]) * 4 + int(old[1:]) % 4}"
            return new
        for line in inst.spec["lines"]:
            op, sep, args = line.partition(" ")
            result.append(op + sep + REG.sub(replace, args))
    return result


class Target:
    """Pinned M55 units with conservative costs for unsupported atomic groups.

    These are search estimates, never reported as measured CPU cycles.
    The real-board measurements, not this approximate model, select winners.
    """
    ExecutionUnit = m55.ExecutionUnit
    issue_rate = 1
    llvm_mca_target = "cortex-m55"
    has_min_max_objective = staticmethod(m55.has_min_max_objective)
    get_min_max_objective = staticmethod(m55.get_min_max_objective)

    @staticmethod
    def get_units(inst):
        op = inst.spec["lines"][0].split()[0]
        if inst.is_load() or inst.is_store(): return [m55.ExecutionUnit.LOAD]
        if op.startswith(("vmul", "vmla", "vqrdmulh")): return [m55.ExecutionUnit.VEC_MUL]
        if op.startswith("v"): return [m55.ExecutionUnit.VEC_INT]
        return [m55.ExecutionUnit.SCALAR]

    @staticmethod
    def get_inverse_throughput(inst):
        return len(inst.spec["lines"]) * (2 if inst.spec["lines"][0].startswith("v") else 1)

    @staticmethod
    def get_latency(src, out_idx, dst):
        return Target.get_inverse_throughput(src)

    @staticmethod
    def add_further_constraints(slothy):
        m55.add_further_constraints(slothy)
        # A multi-instruction atom occupies multiple issue slots. No unrelated
        # unit may be issued inside it, even if it uses a different unit.
        nodes = list(slothy.get_inst_pairs())
        for a, b in nodes:
            width = len(a.inst.spec["lines"])
            for delta in range(1, width):
                slothy._Add(b.cycle_start_var != a.cycle_start_var + delta)
