#!/usr/bin/env python3
"""Host arithmetic model only: does NOT execute the Arm inline assembly."""
from pathlib import Path
import hashlib
import json

ROOT=Path(__file__).resolve().parent
MASK=(1<<64)-1
state=0x853c49e6748fea9b
peak=0.0

def next64():
    global state
    state^=(state<<13)&MASK
    state^=state>>7
    state^=(state<<17)&MASK
    return state

def split(x):
    lo=float(x&0xffffffff);hi=float(x>>32)
    low_top=float(int(lo*2.0**-24))
    high_top=float(int(hi*2.0**-16))
    return (lo-low_top*2.0**24,
            (hi-high_top*2.0**16)*256+low_top,
            high_top,lo,float(x>>63))

def model(x,y):
    global peak
    a,b=split(x),split(y)
    # Same eight non-fused coefficient products as the assembly.
    c0=a[0]*b[0]
    c1=a[0]*b[1]+a[1]*b[0]
    c2=(a[0]*b[2]+a[1]*b[1])+a[2]*b[0]
    c3=a[1]*b[2]+a[2]*b[1]
    c1+=float(int(c0*2.0**-24))
    carry=float(int(c1*2.0**-24));d1=c1-carry*2.0**24
    c2+=carry
    carry=float(int(c2*2.0**-24));d2=c2-carry*2.0**24
    c3+=carry
    d3=c3-float(int(c3*2.0**-24))*2.0**24
    peak=max(peak,c0,c1,c2,c3)
    top=float(int(d2*2.0**-16))
    lo=float(int(d1/256))+(d2-top*65536)*65536
    hi=(top+d3*256+2.0**33)-a[4]*b[3]-b[4]*a[3]
    hi-=float(int(hi*2.0**-32))*2.0**32
    assert 0<=hi<2**32 and 0<=lo<2**32
    return (int(hi)<<32)|int(lo)

def check(x,y):
    sx=x-(1<<64) if x>>63 else x
    sy=y-(1<<64) if y>>63 else y
    z=model(x,y)
    assert z==((sx*sy)>>32)&MASK,(x,y,z)
    return z

checksum=0xcbf29ce484222325
for _ in range(1000000):
    checksum=((checksum^check(next64(),next64()))*0x100000001b3)&MASK
edges=[0,1,MASK]
for bit in range(1,64):edges.extend(((1<<bit)-1,1<<bit,(1<<bit)+1))
for x in edges:
    for y in edges:check(x,y)
assert checksum==0xc665dcb55f68554d and peak<2**50
data=dict(result='PASS',random_pairs=1000000,edge_pairs=len(edges)**2,
          checksum=f'{checksum:016x}',maximum_observed_column=int(peak),
          caveat='Arithmetic model, not host execution/sanitization of Arm assembly.',
          model_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
out=ROOT/'results/model.json';out.parent.mkdir(parents=True,exist_ok=True)
out.write_text(json.dumps(data,indent=2)+'\n')
print(json.dumps(data,indent=2))
