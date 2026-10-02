"""Recapture exact raw words and locate fixed-point truncation/wrap operations.
Only generated diagnostics are built. Production candidates are never edited.
"""
from pathlib import Path
import ctypes as C
import hashlib
import json
import math
import re
import subprocess
import sys

ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT.parent))
import host
OUT=ROOT/'build'
OUT.mkdir(exist_ok=True)
MASK=(1<<64)-1
B=1<<32
signed=lambda x: x-(1<<64) if x>>63 else x
raw=lambda x: int(x,16)

def capture():
    text=(host.BASE/'kgen_ntru.c').read_text()
    start=text.index('solve_NTRU_intermediate(');end=text.index('\n#if FNDSA_AVX2',start)
    part=text[start:end]
    for old,new in [
        ('\tvect_FFT(logn, rt3);','\tshadow_f(logn,rt3,scale_t);\n\tvect_FFT(logn, rt3);'),
        ('\t\tvect_FFT(logn, rt1);','\t\tshadow_F(logn,rt1);\n\t\tvect_FFT(logn, rt1);'),
        ('\t\t/* k <- round(rt1)','\t\tshadow_round(logn,depth,rt1);\n\t\t/* k <- round(rt1)')]:
        assert part.count(old)==1
        part=part.replace(old,new)
    text='#include "kgen_inner.h"\nextern void shadow_f(unsigned,const fxr*,unsigned);\nextern void shadow_F(unsigned,const fxr*);\nextern void shadow_round(unsigned,unsigned,const fxr*);\n'+text[:start]+part+text[end:]
    (OUT/'shadow_ntru.c').write_text(text)
    shadow=(ROOT.parent/'revision/shadow.c').read_text()
    shadow=shadow.replace('static unsigned exponent,rounds,found;','static unsigned exponent,rounds,found;\nstatic fxr raw_f[1024],raw_F[1024];')
    shadow=shadow.replace('exponent=e;size_t n=(size_t)1<<l;', 'exponent=e;size_t n=(size_t)1<<l;memcpy(raw_f,f,n*8);')
    shadow=shadow.replace('void shadow_F(unsigned l,const fxr *f)\n{','void shadow_F(unsigned l,const fxr *f)\n{\n    memcpy(raw_F,f,((size_t)1<<l)*8);')
    helper=r'''
static void raw_array(const char *name,const fxr *a,size_t n) {
    printf(",\"%s\":[",name);
    for(size_t i=0;i<n;i++)printf("%s\"%016llx\"",i?",":"",(unsigned long long)a[i].v);
    printf("]");
}
'''
    shadow=shadow.replace('void shadow_round(',helper+'\nvoid shadow_round(',1)
    shadow=shadow.replace('array("fixed_x",qout,n);','raw_array("raw_f",raw_f,n);raw_array("raw_F",raw_F,n);raw_array("raw_inverse",inverse_q,n);raw_array("raw_fixed_x",reference,n);array("fixed_x",qout,n);')
    (OUT/'shadow.c').write_text(shadow)
    sources=[str(host.SOURCE/(n+'.c')) for n in host.NAMES if n!='kgen_ntru']
    subprocess.run(['clang',*host.FLAGS,'-DSHADOW_FIXED_INVERSE=1','-I'+str(host.SOURCE),*sources,
                    str(OUT/'shadow_ntru.c'),str(OUT/'shadow.c'),'-lm','-o',str(OUT/'shadow')],check=True)
    for degree,seed in ((512,'test58'),(1024,'test65')):
        record=json.loads(subprocess.check_output([str(OUT/'shadow'),str(degree.bit_length()-1),seed],text=True))
        record.update(degree=degree,seed=seed)
        (OUT/f'{degree}-{seed}.json').write_text(json.dumps(record,indent=2)+'\n')

class Model:
    def __init__(self, wrap=True, graph=3):
        self.wrap,self.graph=wrap,graph
        self.events=[];self.context='';self.ordinal=0
    def op(self,op,a,b=None):
        self.ordinal+=1
        if op=='mul':
            full=a*b; wide=full>>32
        elif op=='add': wide=a+b
        elif op=='sub': wide=a-b
        elif op=='half': wide=(a+1)>>1
        else: raise ValueError(op)
        wrapped=not -(1<<63)<=wide<(1<<63)
        result=signed(wide&MASK) if self.wrap else wide
        fractional=op=='mul' and (a*b)%B != 0
        if wrapped or fractional:
            self.events.append(dict(ordinal=self.ordinal,context=self.context,operation=op,
                a_raw=str(a),b_raw=None if b is None else str(b),unwrapped_raw=str(wide),
                result_raw=str(result),wrap=wrapped,low_bits_discarded=(a*b)%B if op=='mul' else 0))
        return result
    def cmul(self,x,y):
        ctx=self.context
        self.context=ctx+' / z0=ac';a=self.op('mul',x[0],y[0])
        self.context=ctx+' / z1=bd';b=self.op('mul',x[1],y[1])
        if self.graph==3:
            self.context=ctx+' / z2=(a+b)(c+d)'
            c=self.op('mul',self.op('add',x[0],x[1]),self.op('add',y[0],y[1]))
            self.context=ctx+' / re=z0-z1, im=z2-(z0+z1)'
            result=self.op('sub',a,b),self.op('sub',c,self.op('add',a,b))
        else:
            self.context=ctx+' / ad,bc'
            c=self.op('mul',x[0],y[1]);d=self.op('mul',x[1],y[0])
            self.context=ctx+' / re=ac-bd, im=ad+bc'
            result=self.op('sub',a,b),self.op('add',c,d)
        self.context=ctx
        return result
    def fft(self,a,gm,inverse=False):
        n=len(a);hn=n//2;l=n.bit_length()-1
        if not inverse:
            t=hn
            for lm in range(1,l):
                m=1<<lm;ht=t//2
                for i in range(m//2):
                    for j in range(i*t,i*t+ht):
                        self.context=f'FFT layer={lm} butterfly={j} twiddle={m+i}'
                        x=(a[j],a[j+hn]);y=self.cmul(gm[m+i],(a[j+ht],a[j+ht+hn]))
                        a[j]=self.op('add',x[0],y[0]);a[j+hn]=self.op('add',x[1],y[1])
                        a[j+ht]=self.op('sub',x[0],y[0]);a[j+ht+hn]=self.op('sub',x[1],y[1])
                t=ht
        else:
            ht=1
            for lm in range(l-1,0,-1):
                m=1<<lm;t=2*ht
                for i in range(m//2):
                    s=gm[m+i][0],-gm[m+i][1]
                    for j in range(i*t,i*t+ht):
                        self.context=f'iFFT layer={lm} butterfly={j} twiddle={m+i}'
                        x=(a[j],a[j+hn]);y=(a[j+ht],a[j+ht+hn])
                        a[j]=self.op('half',self.op('add',x[0],y[0]))
                        a[j+hn]=self.op('half',self.op('add',x[1],y[1]))
                        z=(self.op('half',self.op('sub',x[0],y[0])),self.op('half',self.op('sub',x[1],y[1])))
                        a[j+ht],a[j+ht+hn]=self.cmul(s,z)
                ht=t
    def pipeline(self,a,b,gm):
        a=list(a);self.fft(a,gm);stages={'FFT':list(a)};hn=len(a)//2
        for i in range(hn):
            self.context=f'pointwise index={i}'
            a[i],a[i+hn]=self.cmul((a[i],a[i+hn]),(b[i],b[i+hn]))
        stages['pointwise']=list(a);self.fft(a,gm,True);stages['iFFT']=list(a)
        return stages

class FloatModel(Model):
    def op(self,op,a,b=None):
        if op=='mul':return a*b/B
        if op=='add':return a+b
        if op=='sub':return a-b
        if op=='half':return a*0.5
        raise ValueError(op)

def analyze():
    table=re.findall(r'FXC\(\s*(\d+)ull,\s*(\d+)ull\)',(host.BASE/'kgen_fxp.c').read_text())
    gm=[(signed(int(a)),signed(int(b))) for a,b in table]
    assert len(gm)==1024
    subprocess.run(['clang',*host.FLAGS,'-dynamiclib',str(host.BASE/'kgen_fxp.c'),'-o',str(OUT/'fixed.dylib')],check=True)
    lib=C.CDLL(str(OUT/'fixed.dylib'))
    for name in ('FFT','iFFT'):getattr(lib,'fndsa_vect_'+name).argtypes=[C.c_uint,C.POINTER(C.c_uint64)]
    lib.fndsa_vect_mul_fft.argtypes=[C.c_uint,C.POINTER(C.c_uint64),C.POINTER(C.c_uint64)]
    summary=[]
    for degree,seed in ((512,'test58'),(1024,'test65')):
        r=json.loads((OUT/f'{degree}-{seed}.json').read_text());n=1<<r['logn']
        a=[signed(raw(x)) for x in r['raw_F']];b=[signed(raw(x)) for x in r['raw_inverse']]
        model=Model();stages=model.pipeline(a,b,gm)
        ca=(C.c_uint64*n)(*[x&MASK for x in a]);cb=(C.c_uint64*n)(*[x&MASK for x in b])
        for stage,func in [('FFT',lambda:lib.fndsa_vect_FFT(r['logn'],ca)),
                           ('pointwise',lambda:lib.fndsa_vect_mul_fft(r['logn'],ca,cb)),
                           ('iFFT',lambda:lib.fndsa_vect_iFFT(r['logn'],ca))]:
            func();assert [signed(x) for x in ca]==stages[stage],stage
        assert [x&MASK for x in stages['iFFT']]==[raw(x) for x in r['raw_fixed_x']]
        k=lambda values:[signed(((v+0x80000000)&MASK))>>32 for v in values]
        wanted=k(stages['iFFT']);variants={}
        for name,m in [('no_wrap',Model(wrap=False)),('four_product_fixed',Model(graph=4))]:
            out=m.pipeline(a,b,gm)['iFFT'];got=k(out)
            variants[name]=dict(k_differences=sum(x!=y for x,y in zip(wanted,got)),
                                first_bad=[i for i,(x,y) in enumerate(zip(wanted,got)) if x!=y][:8])
        for graph in (3,4):
            out=FloatModel(graph=graph).pipeline(list(map(float,a)),list(map(float,b)),gm)['iFFT']
            got=[math.floor(v/B+0.5) for v in out]
            variants[f'native_{graph}product']=dict(k_differences=sum(x!=y for x,y in zip(wanted,got)))
            if graph==4:
                assert [v/B for v in out]==[float.fromhex(v) for v in r['fp64_x']], 'native C/float model mismatch'
        differing=[]
        for i,(q,fs) in enumerate(zip(stages['iFFT'],r['fp64_x'])):
            f=float.fromhex(fs);native=math.floor(f+0.5)
            if wanted[i]!=native:differing.append(dict(index=i,fixed_raw=str(q),fixed_value=q/B,native_value=f,fixed_k=wanted[i],native_k=native))
        conversion=[dict(index=i,raw=str(v),rounded_raw=str(int(float(v/B)*B))) for i,v in enumerate(b) if int(float(v/B)*B)!=v]
        wraps=[e for e in model.events if e['wrap']]
        row=dict(degree=degree,seed=seed,round=r['round'],logn=r['logn'],depth=r['depth'],
                 first_quantization=next((e for e in model.events if e['low_bits_discarded']),None),
                 first_wrap=wraps[0] if wraps else None,wrap_count=len(wraps),
                 inverse_double_conversion_losses=conversion,differing_k=differing,variants=variants,
                 exact_C_stage_comparison='PASS')
        (OUT/f'{degree}-{seed}-analysis.json').write_text(json.dumps(row,indent=2)+'\n')
        (OUT/f'{degree}-{seed}-events.json').write_text(json.dumps(model.events,indent=2)+'\n')
        summary.append(row);print(json.dumps(row,indent=2),flush=True)
    (ROOT/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    (ROOT/'manifest.json').write_text(json.dumps(dict(
        baseline={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in host.BASE.glob('*.[chs]')},
        native={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in host.SOURCE.glob('*.[chs]')},
        method='Baseline NTRU state; exact 64-bit raw capture; independent Python integer model checked against C at every transform boundary'),indent=2)+'\n')

if __name__=='__main__':
    capture();analyze()
