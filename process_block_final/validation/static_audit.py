"""Integration contracts and bounded constant-time evidence, not a proof."""
import hashlib,json,re
from pathlib import Path
from scope_check import check_scope
HERE=Path(__file__).resolve().parent; ROOT=HERE.parent; WORKSPACE=ROOT.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def norm(t):
    t=re.sub(r'@.*','',t)
    t=re.sub(r'^\s*\.(?:cpu|file)\b.*\n','',t,flags=re.M)
    return re.sub(r'\s+','',t)
def part(t,a,b):
    start=t.index(a);return t[start:t.index(b,start)]
def khi(t):
    start=t.index('.macro\tKHI_STEP ');return t[start:t.index('.endm',start)+5]
s=(ROOT/'sha3_cm55.s').read_text()
one=(WORKSPACE/'process_block/sha3_cm55.s').read_text()
two=(WORKSPACE/'process_block2/sha3_cm55.s').read_text()
three=(WORKSPACE/'process_block3/sha3_cm55.s').read_text()
four=(WORKSPACE/'process_block4/sha3_cm55.s').read_text()
five=(WORKSPACE/'process_block5/sha3_cm55.s').read_text()
scope=check_scope()
assert scope['checkpoint']=='N12345_all'
def frame(t,old):
    return t.replace('\tsub\tsp, #'+str(old)+'\n','\tsub\tsp, #100\n').replace('\tadd\tsp, #'+str(old)+'\n','\tadd\tsp, #100\n').replace(
        '{ r4, r5, r6, r7, r8, r10, r11,','{ r4, r5, r6, r7, r8, r9, r10, r11,')
prefix='fndsa_sha3_process_block:\n'
preamble='\t@ Here begins the preamble'
iteration='\t@ We will perform 24 rounds.'
theta='\t@ Apply D[x] to A[x+5*y] and absorb the original delayed rotations.'
special='\t@ For words 0, 6, 12, 18 and 24,'
iota='\t@ XOR next round constant into A[0]'
pi='\t@ Permute the state words for next round.'
final='fndsa_sha3_process_block__final:\n'
rc='process_block_RC:\n'
assert norm(s[:s.index(prefix)])==norm(one[:one.index(prefix)]),'IO macros or helpers changed'
assert norm(part(s,prefix,preamble))==norm(frame(part(one,prefix,preamble),88)),'input pipeline changed'
assert norm(part(s,preamble,iteration))==norm(part(two,preamble,iteration)),'initial C changed'
assert norm(part(s,theta,special))==norm(part(two,theta,special)),'theta differs from T8'
assert norm(part(s,pi,final))==norm(part(three,pi,final)),'pi differs from R9'
assert norm(khi(s))==norm(khi(four)),'chi differs from C4'
assert norm(part(s,iota,pi))==norm(part(five,iota,pi)),'iota differs from I4'
assert norm(part(s,final,rc))==norm(frame(part(one,final,rc),88)),'output pipeline changed'
# Full composition, beyond the component tests.
expected=one
def replace_region(t,a,b,new):
    i=t.index(a);j=t.index(b,i);return t[:i]+new+t[j:]
expected=replace_region(expected,preamble,iteration,part(two,preamble,iteration))
expected=replace_region(expected,'\t@ XOR each t_i into A[5*j+i] (for j = 0 to 4).',special,part(two,theta,special))
expected=replace_region(expected,pi,final,part(three,pi,final))
expected=expected.replace(khi(expected),khi(four))
expected=frame(expected,88)
expected=expected.replace('\tmvn\tr14, #0xBF\n','\tadr.w\tr9, process_block_RC\n\tmvn\tr14, #0xBF\n')
expected=expected.replace('\tadr.w\tr5, process_block_RC__end\n\tadd.w\tr5, r14\n\tldrd\tr2, r3, [r5]\n','\tldrd\tr2, r3, [r9], #8\n')
assert norm(s)==norm(expected),'unexpected code beyond selected stage composition'
profile=json.loads((HERE/'kernel_compare/summary.json').read_text())
assert profile['candidate_sha256']==sha(ROOT/'sha3_cm55.s')
run=HERE/'kernel_compare'/profile['runs']['mve-plain']['path']
symbols=(run/'symbols.txt').read_text()
def loc(n):return int(next(l.split()[0] for l in symbols.splitlines() if l.split() and l.split()[-1]==n),16)
assert loc('process_block_RC__end')-loc('process_block_RC')==192
ins=[]
for line in (run/'disassembly.txt').read_text().splitlines():
    m=re.match(r'^([0-9a-f]+):\s+(?:[0-9a-f]{4}\s+)+\s*([a-z][a-z0-9.]*)\s*(.*)',line)
    if m and loc('fndsa_sha3_process_block')<=int(m[1],16)<loc('process_block_RC'):
        ins.append(dict(address=int(m[1],16),mnemonic=m[2],operands=m[3].split('@')[0].strip()))
begin=next(x['address'] for x in ins if x['mnemonic'].split('.')[0]=='mvn' and x['operands']=='lr, #191')
core=[x for x in ins if begin<=x['address']<loc('fndsa_sha3_process_block__final')]
conditionals={f'b{x}' for x in ('eq','ne','cs','cc','mi','pl','vs','vc','hi','ls','ge','lt','gt','le','hs','lo')}
branches=[x for x in core if x['mnemonic'].split('.')[0] in conditionals|{'b'}]
assert len(branches)==2 and branches[0]['mnemonic'].split('.')[0]=='beq' and branches[1]['mnemonic'].split('.')[0]=='b'
assert core[core.index(branches[0])-1]['mnemonic'].split('.')[0]=='adds'
assert not any(x['mnemonic'].split('.')[0] in ('bl','blx','cbz','cbnz','bx','tbb','tbh') for x in core)
memory=[]
for x in core:
    for addr in re.findall(r'\[([^\]]+)\]',x['operands']):
        assert re.fullmatch(r'(?:sp|ip|r9)(?:, #\d+)?',addr),(x,addr)
        memory.append(dict(instruction=x,address=addr))
loads=[x for x in core if '[r9]' in x['operands']]
assert len(loads)==1 and loads[0]['mnemonic']=='ldrd' and re.search(r'\[r9\],\s*#8$',loads[0]['operands'])
assert s.count('str r9,[sp,#84]')==2 and s.count('ldr r9,[sp,#84]')==2
assert s.count('str r14,[sp,#80]')==s.count('ldr r14,[sp,#80]')==1
assert s.count('str r9,[sp,#92]')==s.count('ldr r9,[sp,#92]')==1
assert s.count('str r14,[sp,#88]')==s.count('ldr r14,[sp,#88]')==1
assert '\tsub\tsp, #100\n' in s and '\tadd\tsp, #100\n' in s
assert 36+64+100==200 and 200%8==0
functional={}
for mode in ('kat','sigkat','api'):
    p=sorted((HERE/'results'/('mve_'+mode)).glob('*'))[-1]
    assert json.loads((p/'manifest.json').read_text())['valid_measurement']
    assert json.loads((p/'sources.json').read_text())['original_sha256'][str(ROOT/'sha3_cm55.s')]==sha(ROOT/'sha3_cm55.s')
    functional[mode]=str(p.relative_to(HERE))
report=dict(candidate_sha256=sha(ROOT/'sha3_cm55.s'),reference_sha256=sha(ROOT/'sha3_cm4.s'),
    selected_components={str(p.relative_to(WORKSPACE)):sha(p) for p in (
        WORKSPACE/'process_block/sha3_cm55.s',WORKSPACE/'process_block2/sha3_cm55.s',
        WORKSPACE/'process_block3/sha3_cm55.s',WORKSPACE/'process_block4/sha3_cm55.s',
        WORKSPACE/'process_block5/sha3_cm55.s')},scope=scope,
    composition='direct local stages IO3 + T8 + R9 + C4 + I4; no production includes/selectors',
    frame_bytes=200,original_frame_bytes=184,new_external_scratch_bytes=0,
    stack_layout={'0..71':'state A16..A24','72..75':'state pointer','76..79':'rate',
                  '80..87':'theta R14/R9; later pi old A6','88..95':'pi R14/R9',
                  '96..99':'alignment padding'},
    branch_control=branches,memory=memory,helpers_bytes=1284,
    production_text_bytes=profile['runs']['mve-plain']['audit']['production_text_bytes'],
    timing_classes=profile['runs']['mve-plain']['timing_classes'],functional_runs=functional,
    limitations=['not a formal CT proof','zero/random 1000 samples each are bounded evidence',
                 'finite correctness tests are not universal equivalence or power/EM/fault security validation'])
(HERE/'static_audit.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items() if k not in ('memory','scope')},indent=2))
