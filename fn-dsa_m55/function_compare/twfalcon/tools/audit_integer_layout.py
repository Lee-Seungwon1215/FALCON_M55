#!/usr/bin/env python3
"""Record exact code/data addresses for the diagnostic layout control."""
import hashlib
import json
import sys
from pathlib import Path
from elftools.elf.elffile import ELFFile

root = Path(__file__).resolve().parents[1]
build = root/'integration_candidate/validation/build'
output = Path(sys.argv[1])
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
records = {}
for kind in ('keygen_ref','keygen_current','keylayout_ref','keylayout_current',
             'zpro_ref','zpro_current','zlayout_ref','zlayout_current'):
    p = build/kind/'zephyr/zephyr.elf'
    with p.open('rb') as f:
        e = ELFFile(f)
        symbols = list(e.get_section_by_name('.symtab').iter_symbols())
        ints = {s.name: dict(address=s['st_value']&~1, size=s['st_size'])
                for s in symbols if s['st_size'] and s.name.startswith(('fndsa_zint','zint_'))}
        data = {s.name:dict(address=s['st_value'],size=s['st_size']) for s in symbols
                if s['st_size'] and 0x30000000 <= s['st_value'] < 0x30040000}
        instructions = {}
        for name,row in ints.items():
            sym = next(s for s in symbols if s.name == name)
            sec = e.get_section(sym['st_shndx'])
            off = row['address']-sec['sh_addr']
            instructions[name] = sec.data()[off:off+row['size']].hex()
    records[kind] = dict(elf_sha256=sha(p), integer_functions=ints,
        dtcm_symbols=data,instruction_bytes=instructions)
assert records['keylayout_ref']['integer_functions'] == records['keylayout_current']['integer_functions']
assert records['zlayout_ref']['integer_functions'] == records['zlayout_current']['integer_functions']
data_equal = {}
for old,new in (('keygen_ref','keylayout_ref'),('keygen_current','keylayout_current'),
                ('zpro_ref','zlayout_ref'),('zpro_current','zlayout_current')):
    data_equal[old+'->'+new] = records[old]['dtcm_symbols'] == records[new]['dtcm_symbols']
    assert data_equal[old+'->'+new], 'Unexpected DTCM layout change '+old
    for name,row in records[old]['integer_functions'].items():
        assert row['size'] == records[new]['integer_functions'][name]['size']
reference = root.parents[1]/'M55_ref'
current = root/'integration_candidate'
assert sha(reference/'kgen_zint31.c') == sha(current/'kgen_zint31.c')
data = dict(records=records,all_dtcm_symbol_addresses_preserved=data_equal,
    integer_c_source_identical=True,integer_c_source_sha256=sha(current/'kgen_zint31.c'),
    caveat='The layout control reorders integer text before other text; other code addresses shift too. DTCM symbols and crypto computations are unchanged. This does not establish a specific silicon fetch-latency mechanism.')
output.write_text(json.dumps(data,indent=2)+'\n')
print('Integer routine addresses identical across controlled pair; all DTCM symbol addresses unchanged by layout control.')
for kind in ('keygen_ref','keygen_current','keylayout_ref','keylayout_current'):
    print(kind,{k:hex(records[kind]['integer_functions'][k]['address']) for k in ('fndsa_zint_rebuild_CRT','fndsa_zint_bezout')})
