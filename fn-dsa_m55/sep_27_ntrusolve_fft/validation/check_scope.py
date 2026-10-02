#!/usr/bin/env python3
"""Check the promised unmodified areas against the frozen ntt_opt copy."""
import json,hashlib,runpy
from pathlib import Path
root=Path(__file__).resolve().parent.parent
base=root/'baseline_ntt'
def body(text,name):
    a=text.index('\n'+name+'(')
    b=text.index('\n#if FNDSA_AVX2',a)
    return text[a:b]
def function(text,name):
    start=text.index('\n'+name+'(')
    end=text.index('\n}\n',start)+3
    return text[start:end]
out={}
for name in ('A_tw_bridge','B_continuous_ds'):
    d=root/name
    unchanged=[];changed=[]
    for p in sorted(base.glob('*')):
        if p.suffix not in ('.c','.h','.s'):continue
        if p.read_bytes()==(d/p.name).read_bytes():unchanged.append(p.name)
        else:changed.append(p.name)
    must=[p.name for p in base.glob('*') if p.suffix in ('.c','.s') and
          (p.name.startswith(('mq','sign','vrfy','sha3','codec')) or
           p.name in ('kgen.c','kgen_mp31.c','kgen_mp31_cm55.s','kgen_zint31.c','kgen_gauss.c'))]
    if name == 'A_tw_bridge':
        # User-authorized cleanup removes only the unused mq diagnostic tail.
        # The independent archive comparison checks retained executable tokens,
        # exact tables, the sole assembly deletion and all other file hashes.
        cleanup = runpy.run_path(str(root/'validation/cleanup/check.py'))['check']()
        must.remove('mq_cm55.s')
    assert set(must)<=set(unchanged),(name,set(must)-set(unchanged))
    a=(base/'kgen_ntru.c').read_text();b=(d/'kgen_ntru.c').read_text()
    ortho=body(a,'check_ortho_norm')==body(b,'check_ortho_norm')
    intermediate=body(a,'solve_NTRU_intermediate')==body(b,'solve_NTRU_intermediate')
    assert ortho
    intermediate_calls_only = intermediate
    if name=='A_tw_bridge':
        part=body(b,'solve_NTRU_intermediate')
        assert part.count('vect_FFT_ntru(')==2 and part.count('vect_iFFT_ntru(')==1
        part=part.replace('vect_FFT_ntru(', 'vect_FFT(').replace('vect_iFFT_ntru(', 'vect_iFFT(')
        intermediate_calls_only=part==body(a,'solve_NTRU_intermediate')
        assert intermediate_calls_only
    original_fxp=(base/'kgen_fxp.c').read_text()
    candidate_fxp=(d/'kgen_fxp.c').read_text()
    scalar_div=function(original_fxp,'inner_fxr_div')==function(candidate_fxp,'inner_fxr_div')
    assert scalar_div
    if name=='A_tw_bridge':
        invnorm=function(candidate_fxp,'vect_invnorm_fft_fixed').replace(
            'vect_invnorm_fft_fixed(', 'vect_invnorm_fft(', 1)
        assert invnorm==function(original_fxp,'vect_invnorm_fft')
        # 2026-09-28: the user explicitly requested the former FP64 invnorm.
        # Its caller and the surrounding transforms must still be unchanged.
        invnorm_port=function(candidate_fxp,'vect_invnorm_fft')
        assert 'if (e != 0)' in invnorm_port
        assert 'vect_invnorm_fft_fixed(logn, d, a, b, e);' in invnorm_port
        assert 'fp64c_from_fxc' in invnorm_port
        assert 'fp64q_to_fixed(fp64q_recip_positive_normal(z))' in invnorm_port
        assert cleanup['removed_test_symbol'] == 'fndsa_stage3_mul_probe'
        for kernel in ('vect_FFT','vect_iFFT'):
            fixed=function(candidate_fxp,kernel+'_fixed').replace(kernel+'_fixed(',kernel+'(',1)
            assert fixed==function(original_fxp,kernel)
            assert '\n\t'+kernel+'_fixed(logn, f);\n}' in function(candidate_fxp,kernel)
    out[name]=dict(unchanged=unchanged,changed=changed,
        candidate_invnorm_user_requested_fp64=(name=='A_tw_bridge'),
        orthonorm_exact_source_equal=ortho,intermediate_exact_source_equal=intermediate,
        intermediate_only_ntru_fft_calls_changed=intermediate_calls_only,
        scalar_division_exact_source_equal=scalar_div,
        ntru_sha256=hashlib.sha256((d/'kgen_ntru.c').read_bytes()).hexdigest())
(root/'validation/scope_check.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
