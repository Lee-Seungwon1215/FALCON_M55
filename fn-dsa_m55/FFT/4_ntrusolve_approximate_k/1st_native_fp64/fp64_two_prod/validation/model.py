"""Independent binary64/FMA model versus unbounded signed integer arithmetic."""
import ctypes
import itertools
import json
from pathlib import Path
fma=ctypes.CDLL(None).fma
fma.argtypes=[ctypes.c_double]*3
fma.restype=ctypes.c_double
B=1<<32
MASK=(1<<64)-1
corrections=set()
def product(a,b):
    q=float(int(float(a)*(float(b)/B)))
    residual=fma(float(a),float(b),-q*B)
    u=residual+B
    c=int(u/B)
    corrections.add(c)
    h,l=int(q+c-1),int(u-c*B)
    assert (h<<32)|l == a*b and 0<=h<B and 0<=l<B
    return h,l
def mul(x,y):
    x0,x1=x&(B-1),x>>32
    y0,y1=y&(B-1),y>>32
    h00,_=product(x0,y0)
    h01,l01=product(x0,y1)
    h10,l10=product(x1,y0)
    _,l11=product(x1,y1)
    lo=h00+l01+l10
    hi=h01+h10+l11+(lo>>32)-(x>>63)*y0-(y>>63)*x0
    return ((hi<<32)|(lo&(B-1)))&MASK
def signed(x): return x-(1<<64) if x>>63 else x
state=0x853c49e6748fea9b
def next64():
    global state
    state^=(state<<13)&MASK;state^=state>>7;state^=(state<<17)&MASK
    return state
edges=[0,1,MASK]+[v for i in range(1,64) for v in ((1<<i)-1,1<<i,(1<<i)+1)]
count=0
for a,b in itertools.chain(((next64(),next64()) for _ in range(1000000)),itertools.product(edges,repeat=2)):
    assert mul(a,b)==((signed(a)*signed(b))>>32)&MASK,(a,b)
    count+=1
result=dict(pairs=count,exact=True,observed_normalization_values=sorted(corrections),
    note='Host binary64/FMA model, not board instruction timing or a formal proof')
out=Path(__file__).parent/'results/model_fma.json'
out.parent.mkdir(exist_ok=True)
out.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result))
