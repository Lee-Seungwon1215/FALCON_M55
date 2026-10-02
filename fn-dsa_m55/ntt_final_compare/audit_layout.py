#!/usr/bin/env python3
"""Check equal policies AND unchanged common-code/buffer addresses in both ELFs."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
sys.dont_write_bytecode = True
import run

ROOT = Path(__file__).resolve().parent
BIN = ROOT.parent/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin'
VARIANTS = ('ref','ntt_opt_slothy')

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def symbols(elf):
    out = subprocess.check_output([str(BIN/'arm-none-eabi-nm'),'-n','-S',str(elf)],text=True)
    result, sized = {}, []
    for row in out.splitlines():
        t = row.split()
        if len(t) == 3:
            addr,kind,name = t
            result[name] = int(addr,16)
        elif len(t) == 4:
            addr,size,kind,name = t
            result[name] = int(addr,16)
            sized.append((name,kind,int(addr,16),int(size,16)))
    return result,sized

def main():
    builds = {v:ROOT/'build'/v for v in VARIANTS}
    elfs = {v:b/'zephyr/zephyr.elf' for v,b in builds.items()}
    manifests = {v:run.manifest(v) for v in VARIANTS}
    for v in VARIANTS:
        assert manifests[v] == json.loads((builds[v]/'provenance.json').read_text())
    for name in ('zephyr/.config','fndsa_dtcm_linker.ld'):
        assert len({sha(b/name) for b in builds.values()}) == 1, name
    assert manifests['ref']['harness'] == manifests['ntt_opt_slothy']['harness']
    syms = {v:symbols(e) for v,e in elfs.items()}
    fixed = ('__compare_q_start','__compare_mp_start','__compare_common_text',
             '__compare_ntt_rodata_start','__compare_common_rodata',
             '__text_region_end','__bss_start','_image_ram_end',
             'sk','pk','sig','tmp','ntt_actual','ntt_oracle',
             'fndsa_batch_cycles','fndsa_progress','z_main_stack')
    addresses = {}
    for name in fixed:
        values = [syms[v][0][name] for v in VARIANTS]
        assert len(set(values)) == 1, (name,values)
        addresses[name] = hex(values[0])
    common_text = syms['ref'][0]['__compare_common_text']
    common_rodata = syms['ref'][0]['__compare_common_rodata']
    text = {v:sorted(t for t in syms[v][1] if t[1] in ('T','t') and t[2]>=common_text) for v in VARIANTS}
    assert text['ref'] == text['ntt_opt_slothy'], 'Common function addresses or sizes changed'
    data = {v:sorted(t for t in syms[v][1] if t[1] in ('R','r','D','d','B','b') and common_rodata<=t[2]<0x30040000) for v in VARIANTS}
    assert data['ref'] == data['ntt_opt_slothy'], 'Common constant/data/buffer addresses or sizes changed'
    used = {}
    for v in VARIANTS:
        s = syms[v][0]
        assert s['__compare_q_start'] <= s['fndsa_mqpoly_int_to_ntt'] < s['__compare_mp_start']
        assert s['__compare_q_start'] <= s['fndsa_mqpoly_ntt_to_int'] < s['__compare_mp_start']
        assert s['__compare_mp_start'] <= s['fndsa_mp_NTT'] < common_text
        assert s['__compare_mp_start'] <= s['fndsa_mp_iNTT'] < common_text
        assert s['__fndsa_itcm_end'] <= 0x10020000 and s['_image_ram_end'] <= 0x30040000
        used[v] = {'q_text':s['__compare_q_end']-s['__compare_q_start'],
                   'rns_text':s['__compare_mp_end']-s['__compare_mp_start'],
                   'ntt_rodata':s['__compare_ntt_rodata_end']-s['__compare_ntt_rodata_start'],
                   'itcm_reserved':s['__fndsa_itcm_end']-0x10000000,
                   'dtcm_reserved':s['_image_ram_end']-0x30000000}
    result = {'valid':True,'elf_hashes':{v:sha(e) for v,e in elfs.items()},
              'fixed_addresses':addresses,'common_functions_fixed':len(text['ref']),
              'common_data_symbols_fixed':len(data['ref']),'used':used,
              'policy':'Identical reserved q-text, RNS-text and NTT-constant object slots; remaining code/data/buffers fixed.',
              'limitation':'Changed object internal function and table offsets differ by implementation; this is not instruction-by-instruction address identity or a formal constant-time proof.'}
    out=ROOT/'results/layout_audit.json'
    out.parent.mkdir(exist_ok=True)
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))

if __name__ == '__main__': main()
