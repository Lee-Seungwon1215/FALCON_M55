#!/usr/bin/env python3
"""Common tight object slots, or unpadded observation-only profile layout."""
from pathlib import Path
import subprocess,sys
source,dest=map(Path,sys.argv[1:3])
mode=sys.argv[3]
root=Path(__file__).resolve().parents[3]
subprocess.run([sys.executable,str(root/'fn-dsa_m55/measurement_mlkem_native/app/generate_dtcm_linker.py'),str(source),str(dest)],check=True)
text=dest.read_text()
if mode=='profile':sys.exit(0)
kg=('kgen_fxp.c','kgen_ntru.c','kgen_poly.c','kgen_fft_mve.c','kgen_fft_bridge.c','kgen_fft_cm55.s')
nt=('mq.c','mq_cm4.s','mq_cm55.s','kgen_mp31.c','kgen_mp31_cm55.s')
def obj(names,section):return '\n'.join('    *'+n+'.obj(.'+section+' .'+section+'.*)' for n in names)
slots='''
    . = ALIGN(256);
    __mid_ntt_start = .;
'''+obj(nt,'text')+'''
    __mid_ntt_end = .;
    . = __mid_ntt_start + 0x4600;
    __mid_kg_start = .;
'''+obj(kg,'text')+'''
    __mid_kg_end = .;
    . = __mid_kg_start + 0xaa00;
    __mid_sg_start = .;
    *sign_fpoly.c.obj(.text.fndsa_fpoly_FFT .text.fndsa_fpoly_iFFT .text.fndsa_fpoly_LDL_fft .text.fndsa_fpoly_split_fft .text.fndsa_fpoly_merge_fft)
    *sign_fft_cm55.s.obj(.text .text.*)
    *sign_ldl_cm55.s.obj(.text .text.*)
    *sign_split_merge_cm55.s.obj(.text .text.*)
    __mid_sg_end = .;
    . = __mid_sg_start + 0xb00;
    __mid_common_text = .;
    *(.text)
    *(".text.*")'''
old='\t*(.text)\n\t*(".text.*")'
assert text.count(old)==1;text=text.replace(old,slots)
ro='''
    . = ALIGN(256);
    __mid_nr_start = .;
'''+obj(nt,'rodata')+'''
    __mid_nr_end = .;
    . = __mid_nr_start + 0x5600;
    __mid_kr_start = .;
'''+obj(kg,'rodata')+'''
    __mid_kr_end = .;
    . = __mid_kr_start + 0xa400;
    __mid_gm_start = .;
    *sign_fpoly.c.obj(.rodata.GM .rodata.fndsa_sign_gm)
    __mid_gm_end = .;
    . = __mid_gm_start + 0x4000;
    __mid_common_rodata = .;
    *(.rodata)
    *(".rodata.*")'''
old='\t*(.rodata)\n\t*(".rodata.*")'
assert text.count(old)==1;text=text.replace(old,ro)
for name,size in (('ntt',0x4600),('kg',0xaa00),('sg',0xb00),('nr',0x5600),('kr',0xa400),('gm',0x4000)):
    text+=f'\nASSERT(__mid_{name}_end <= __mid_{name}_start + {size}, "{name} slot overflow")\n'
dest.write_text(text)
