"""Offline fixed-register scalar-FP64 adapter for pinned Slothy.

All physical 32-bit register lanes remain live at window boundaries. D/S aliases
are explicit. Memory order is serialized. Unknown instructions, calls, control
flow and directives are hard boundaries. No renaming, speculation or arithmetic
rewrite. Cost estimates are not board measurements. FPSCR access is a boundary;
normal non-trapping FP exception sticky bits accumulate the same instruction set.
"""
from pathlib import Path
import collections,hashlib,json,logging,re,sys
ROOT=Path(__file__).resolve().parent
M55=ROOT.parents[4]
sys.path.insert(0,str(M55/'verify_ntt_stage/ntt_opt_5thStage/tooling/slothy'))
from slothy.targets.arm_v81m import arch_v81m as base
from slothy.targets.arm_v81m import cortex_m55r1 as m55
from slothy.core.core import SlothyBase
from slothy.core.config import Config
from slothy.helper import SourceLine
RegisterType=base.RegisterType
arch_name='FP64_locked_lanes'
llvm_mca_arch='arm'
llvm_mc_arch=llvm_mc_attr=unicorn_arch=unicorn_mode=None
SPECS={}
REG=re.compile(r'\b(?:r(?:1[0-5]|[0-9])|sp|lr|pc|ip|fp|sl|sb|d(?:1[0-5]|[0-9])|s(?:[12][0-9]|3[01]|[0-9]))\b')
ALL={f'hint_s{i}' for i in range(32)}|{f'hint_r{i}' for i in range(16)}|{'hint_memory'}
def lanes(reg):
    reg={'sp':'r13','lr':'r14','pc':'r15','ip':'r12','fp':'r11','sl':'r10','sb':'r9'}.get(reg,reg)
    if reg.startswith('d'):return {f'hint_s{2*int(reg[1:])+i}' for i in (0,1)}
    return {'hint_'+reg}
def registers(text):return set().union(*(lanes(r) for r in REG.findall(text))) if REG.search(text) else set()
def spec(line):
    line=line.split('@')[0].strip()
    if not line or line.startswith(('.', '#')) or line.endswith(':'):return None
    op,_,args=line.partition(' ');args=args.strip()
    operands=[a.strip() for a in args.split(',')]
    if not operands or not operands[0]:return None
    rd,wr=set(),set();memory=False
    if re.fullmatch(r'v(add|sub|mul|div|mla|mls|fma|fms|nmla|nmls|fnma|fnms|neg|abs|mov)\.f64',op) or re.fullmatch(r'vcvt\.(f64\.u32|u32\.f64|f64\.s32|s32\.f64)',op):
        wr=registers(operands[0]);rd=registers(','.join(operands[1:]))
        if op.startswith(('vmla','vmls','vfma','vfms','vnmla','vnmls','vfnma','vfnms')):rd|=wr
    elif op=='vmov':
        regs=[{'ip':'r12','fp':'r11','sl':'r10','sb':'r9','lr':'r14','sp':'r13','pc':'r15'}.get(r,r) for r in REG.findall(args)]
        if len(regs)==3 and regs[0].startswith('r') and regs[1].startswith('r'):
            wr=lanes(regs[0])|lanes(regs[1]);rd=lanes(regs[2])
        elif len(regs)==3 and regs[0].startswith('d'):
            wr=lanes(regs[0]);rd=lanes(regs[1])|lanes(regs[2])
        elif len(regs)==2:wr=lanes(regs[0]);rd=lanes(regs[1])
        else:return None
    elif op in ('vldr.64','vstr.64','vldr.32','vstr.32','ldr','ldr.w','str','str.w'):
        if '!' in args or re.search(r'\],',args):return None
        memory=True
        if 'str' in op:rd=registers(args)
        else:wr=registers(operands[0]);rd=registers(','.join(operands[1:]))
        rd.add('hint_memory');wr.add('hint_memory')
    elif op in ('add','add.w','sub','sub.w','mov','mov.w','movw','movt','lsr','lsr.w','lsl','lsl.w','asr','asr.w','and','and.w','orr','orr.w','eor','eor.w','ubfx'):
        wr=registers(operands[0]);rd=registers(','.join(operands[1:]))
        if len(operands)==2 and op not in ('mov','mov.w','movw'):rd|=wr
        if op=='movt':rd|=wr
    else:return None
    if not wr:return None
    if 'hint_r13' in wr or 'hint_r15' in wr:return None
    return dict(line=line,op=op,rd=sorted(rd),wr=sorted(wr),memory=memory)
def encode(lines):
    result=[]
    for line in lines:
        s=spec(line);assert s is not None,line
        key=f'fp64unit{len(SPECS):06d}';SPECS[key]=s
        rd,wr=set(s['rd']),set(s['wr'])
        s['out']=sorted(wr-rd);s['io']=sorted(wr&rd);s['inp']=sorted(rd-wr)
        s['order']=s['out']+s['io']+s['inp']
        result.append(SourceLine(key+' '+', '.join(s['order'])))
    return result
class Instruction(base.Instruction):
    @staticmethod
    def parser(src_line):
        key,args=src_line.text.strip().split(None,1);s=SPECS[key]
        inst=Instruction(mnemonic=key,arg_types_in=[RegisterType.HINT]*len(s['inp']),arg_types_in_out=[RegisterType.HINT]*len(s['io']),arg_types_out=[RegisterType.HINT]*len(s['out']))
        regs=[r.strip() for r in args.split(',')]
        assert regs==s['order'],'Register renaming forbidden'
        inst.args_out=s['out'];inst.args_in_out=s['io'];inst.args_in=s['inp']
        inst.source_line=src_line;inst.spec=s
        return [inst]
    def is_load_store_instruction(self):return False
    def is_vector_load(self):return False
    def is_vector_store(self):return False
    def is_scalar_load(self):return False
    def is_load(self):return False
    def is_store(self):return False
    def is_stack_load(self):return False
    def is_stack_store(self):return False
class Target:
    ExecutionUnit=m55.ExecutionUnit
    issue_rate=1
    llvm_mca_target='cortex-m55'
    has_min_max_objective=staticmethod(m55.has_min_max_objective)
    get_min_max_objective=staticmethod(m55.get_min_max_objective)
    @staticmethod
    def get_units(inst):
        op=inst.spec['op']
        if inst.spec['memory']:return [m55.ExecutionUnit.LOAD]
        return [m55.ExecutionUnit.VEC_FPU if op.startswith('v') else m55.ExecutionUnit.SCALAR]
    @staticmethod
    def get_latency(src,out_idx,dst):
        op=src.spec['op']
        if op.startswith(('vfma','vfms','vfnma','vfnms')):return 24
        if op.startswith(('vmla','vmls')):return 36
        if op.startswith('vmul'):return 21
        if op.startswith(('vadd','vsub')):return 15
        if op.startswith('vdiv'):return 29
        return 2 if op.startswith('v') or src.spec['memory'] else 1
    @staticmethod
    def get_inverse_throughput(inst):return max(1,Target.get_latency(inst,0,inst)-1)
    @staticmethod
    def add_further_constraints(slothy):pass
def trace(lines):
    state={r:r for r in ALL};events=[]
    for line in lines:
        s=spec(line);assert s
        h=hashlib.sha256(json.dumps([s['line'],[(r,state[r]) for r in s['rd']]]).encode()).hexdigest()
        if s['memory']:events.append(h)
        for r in s['wr']:state[r]=h+':'+r
    return state,events
def optimize(lines,name):
    source=encode(lines)
    conf=Config(sys.modules[__name__],Target,logging.getLogger(name))
    conf.outputs=ALL;conf.inputs_are_outputs=True;conf.allow_useless_instructions=True
    conf.variable_size=True;conf.constraints.stalls_allowed=len(lines)*40
    conf.constraints.allow_spills=False;conf.constraints.allow_renaming=False
    conf.locked_registers=ALL;conf.reserved_regs=ALL
    conf.sw_pipelining.enabled=False;conf.timeout=0.5
    conf.hints.order_hint_orig_order=True;conf.hints.rename_hint_orig_rename=True
    solver=SlothyBase(sys.modules[__name__],Target,logger=logging.getLogger(name),config=conf)
    ok=solver.optimize(source)
    if not ok:return lines,dict(name=name,status='timeout_keep_original',instructions=len(lines))
    out=[Instruction.parser(s)[0].spec['line'] for s in SourceLine.reduce_source(solver.result.code)]
    assert collections.Counter(out)==collections.Counter(lines)
    assert trace(out)==trace(lines),(name,'register/memory trace mismatch')
    return out,dict(name=name,status='verified_permutation',instructions=len(lines),changed=out!=lines,model_cycles_NOT_measured=solver.result.cycles,input=list(lines),output=out)
def main():
    # Aliases are not optional: GCC emits ip/r12 and fp/r11 in these loops.
    assert lanes('ip')==lanes('r12') and lanes('fp')==lanes('r11')
    assert lanes('d0')==lanes('s0')|lanes('s1')
    assert 'hint_r12' in spec('ldr ip, [sp, #32]')['wr']
    assert 'hint_r12' in spec('add r0, ip, r1')['rd']
    assert 'hint_r11' in spec('add r0, fp, r1')['rd']
    assert 'hint_r12' in spec('vmov ip, s15')['wr']
    assert 'hint_s15' in spec('vmov ip, s15')['rd']
    assert spec('cmp r0, #2') is None and spec('moveq lr, r0') is None
    src=Path(sys.argv[1]);dst=Path(sys.argv[2]);lines=src.read_text().splitlines()
    out=[];chunk=[];reports=[]
    def flush():
        if not chunk:return
        if len(chunk)>=6:
            new,report=optimize(chunk,'window_'+str(len(reports)));reports.append(report)
            out.extend('\t'+s for s in new)
        else:out.extend('\t'+s for s in chunk)
        chunk.clear()
    for line in lines:
        s=spec(re.sub(r'\s+',' ',line.strip()))
        if s is None:flush();out.append(line)
        else:
            chunk.append(s['line'])
            if len(chunk)==24:flush()
    flush()
    dst.write_text('\n'.join(out)+'\n')
    report=dict(slothy_commit='55983e6760e98aece5359055085a7def96c688b7',input_sha256=hashlib.sha256(src.read_bytes()).hexdigest(),output_sha256=hashlib.sha256(dst.read_bytes()).hexdigest(),windows=reports,changed=sum(x.get('changed',False) for x in reports),
        scope='Local straight-line windows only. Fixed physical lanes, serialized memory, no cross-iteration pipelining or renaming. Approximate timing model.')
    dst.with_suffix('.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k!='windows'}))
if __name__=='__main__':
    logging.basicConfig(level=logging.ERROR)
    main()
