#!/usr/bin/env python3
"""Archive focused disassembly for human CT review, not an automated proof."""
import json,subprocess,hashlib
from pathlib import Path
root=Path(__file__).resolve().parent.parent
tool=root.parent/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
out=root/'validation/audit';out.mkdir(exist_ok=True)
for candidate,symbols in {
 'A_tw_bridge':['fndsa_vect_mul_fft_fp64','fndsa_vect_inv_mul2e_fft_fp64',
                'fndsa_vect_div_selfadj_fft_fp64','fndsa_fft_bridge_forward',
                'fndsa_poly_big_to_fixed','fndsa_fixed_input_mve',
                'fndsa_vect_inv_mul2e_fft','fndsa_fxr_div4',
                'fndsa_vect_FFT_ntru','fndsa_vect_iFFT_ntru','ntru_fft_large',
                'ntru_ifft_large','fndsa_ntru_q32_butterfly','fndsa_ntru_q32_tail'],
 'B_continuous_ds':['qd_raw_floor','fndsa_ds_mul','fndsa_ds_mul_span','fndsa_ds_inverse',
                    'fndsa_ds_prepare_mul','fndsa_ds_prepare_mul_span',
                    'fndsa_ds_mul_cached','fndsa_ds_mul_cached_span',
                    'fndsa_ds_div_real','fndsa_ds_to_k','fndsa_ds_encode4',
                    'fndsa_ds_round4','fndsa_ds_decode4','fndsa_ds_select4','fndsa_ds_div4',
                    'fndsa_ds_from_big','fndsa_ds_from_big_span',
                    'fndsa_poly_big_to_fixed','fndsa_fixed_input_mve',
                    'ds_fft_run','ds_ifft_run']
}.items():
    elf=root/'validation/build'/candidate/'keygen/zephyr/zephyr.elf'
    text=''.join(subprocess.check_output([str(tool),'-d','--disassemble='+s,str(elf)],text=True) for s in symbols)
    (out/(candidate+'.txt')).write_text(text)
    (out/(candidate+'.json')).write_text(json.dumps(dict(
        elf=str(elf),elf_sha256=hashlib.sha256(elf.read_bytes()).hexdigest(),
        symbols=symbols,claim='Focused human inspection only; not a constant-time proof'),indent=2)+'\n')
