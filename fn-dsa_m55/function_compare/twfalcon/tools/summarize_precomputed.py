#!/usr/bin/env python3
"""Same-ELF stage10/stage11/fixed benchmark and exact-root/source audits."""
import hashlib
import json
import re
import struct
import subprocess
import sys
from pathlib import Path
from elftools.elf.elffile import ELFFile
from precompute_ds_roots import content, roots

ROOT = Path(__file__).resolve().parents[1]
LOCAL = ROOT/'integration_candidate'
out = Path(sys.argv[1]).resolve()
manifest = json.loads((out/'run.json').read_text())
assert manifest['valid_measurement'] and manifest['kind'] == 'twiddlebench'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(out/'raw.log') == manifest['raw_sha256']
assert (LOCAL/'tw32_gm_ds32.c').read_text() == content()
raw = re.sub(r'Info : [^\n]*\n', '', (out/'raw.log').read_text())
perf = re.findall(r'^TWROOT_PERF degree=(\d+) inverse=(\d+) batch=(\d+) backend=(\w+) calls=(\d+) cycles=(\d+) min=(\d+) max=(\d+)$', raw, re.M)
rows = []
for degree in (512, 1024):
    for inverse in (0, 1):
        times = {}
        for backend in ('stage10_ondemand', 'stage11_precomputed', 'stage11_alias', 'M55_ref_fixed'):
            selected = [r for r in perf if (int(r[0]), int(r[1]), r[3]) == (degree, inverse, backend)]
            assert len(selected) == 5 and {int(r[2]) for r in selected} == set(range(5))
            times[backend] = sum(int(r[5]) for r in selected)/sum(int(r[4]) for r in selected)
        before, after, ref = (times[n] for n in ('stage10_ondemand', 'stage11_precomputed', 'M55_ref_fixed'))
        rows.append(dict(degree=degree, op='iFFT' if inverse else 'FFT', mean_cycles=times,
            time_reduction_vs_stage10_percent=100*(1-after/before),
            time_reduction_vs_fixed_percent=100*(1-after/ref),
            speedup_vs_stage10=before/after, speedup_vs_fixed=ref/after))
timing = re.findall(r'^TWROOT_TIMING degree=(\d+) inverse=(\d+) class=(\d+) calls=100 cycles=(\d+) min=(\d+) max=(\d+)$', raw, re.M)
ct = []
for degree in (512, 1024):
    for inverse in (0, 1):
        selected = [r for r in timing if (int(r[0]), int(r[1])) == (degree, inverse)]
        assert len(selected) == 8 and {int(r[2]) for r in selected} == set(range(8))
        ct.append(dict(degree=degree, op='iFFT' if inverse else 'FFT',
            class_mean_spread_cycles=(max(int(r[3]) for r in selected)-min(int(r[3]) for r in selected))/100,
            all_samples_span_cycles=max(int(r[5]) for r in selected)-min(int(r[4]) for r in selected)))

baseline_audit = {}
for filename in ('tw32_fft_mve.c', 'tw32_bridge.c'):
    frozen = (ROOT/'tests/stage10_snapshot'/filename).read_text()
    live = (LOCAL/'validation'/('old10_'+filename)).read_text()
    live = live.removeprefix('#include "twiddle_baseline.h"\n')
    live = re.sub(r'\bold10_(\w+)\b', r'\1', live)
    assert live == frozen
    baseline_audit[filename] = sha(ROOT/'tests/stage10_snapshot'/filename)
prior = json.loads((LOCAL/'validation/results/kat/20260924T150433Z/run.json').read_text())
unchanged = {}
for name in ('tw32_bridge.c', 'tw32_primitives_cm55.s', 'kgen_fxp.c', 'kgen_inner.h'):
    p = LOCAL/name
    assert sha(p) == prior['source'][str(p)]
    unchanged[name] = sha(p)
elfpath = LOCAL/'validation/build/twiddlebench/zephyr/zephyr.elf'
assert sha(elfpath) == manifest['elf_sha256']
with elfpath.open('rb') as f:
    elf = ELFFile(f)
    sym = elf.get_section_by_name('.symtab')
    components = roots()
    for part, name in enumerate(('tw_gm_ds32_re', 'tw_gm_ds32_im')):
        symbol, = sym.get_symbol_by_name(name)
        section = elf.get_section(symbol['st_shndx'])
        offset = symbol['st_value']-section['sh_addr']
        binary = section.data()[offset:offset+symbol['st_size']]
        expected = b''.join(struct.pack('<fff', *v) for v in components[part::2])
        assert binary == expected and len(binary) == 12288

tool = ROOT.parents[1]/'measurement_mlkem_native/env/arm-gnu-toolchain-15.2.rel1-darwin-arm64-arm-none-eabi/bin/arm-none-eabi-objdump'
disassembly = subprocess.check_output([str(tool), '-d', str(elfpath)], text=True)
(out/'disassembly.txt').write_text(disassembly)
kernel_audit = {}
for name in ('ds32_fft_mve', 'ds32_ifft_mve'):
    body = re.search(r'^[0-9a-f]+ <'+name+r'>:\n(.*?)(?=^[0-9a-f]+ <|\Z)', disassembly, re.M|re.S)[1]
    assert '__aeabi_l2d' not in body
    kernel_audit[name] = dict(runtime_int64_to_double_conversion_calls=0,
                             source_loops_and_addresses='public logn/layer/group, no coefficient-driven table indices')
audit = dict(status='PASS', frozen_baseline=baseline_audit, unchanged_source_hashes=unchanged,
    linked_root_components_exact=6144, board_root_components_exact=6144,
    kernel_audit=kernel_audit, note='Local control/address review and timing evidence, not a complete side-channel proof')
(out/'audit.json').write_text(json.dumps(audit, indent=2)+'\n')
before_memory = json.loads((ROOT/'stages/11_precomputed_roots/before_memory.json').read_text())
memory = {}
for kind in ('kat', 'sigkat'):
    p = LOCAL/'validation/build'/kind/'zephyr/zephyr.elf'
    with p.open('rb') as f:
        elf = ELFFile(f)
        sections = [s for s in elf.iter_sections() if s['sh_flags'] & 2 and s['sh_size']]
        syms = elf.get_section_by_name('.symtab')
        assert syms.get_symbol_by_name('tw_gm_ds32_re')
        assert syms.get_symbol_by_name('tw_gm_ds32_im')
        assert not syms.get_symbol_by_name('tw_gm_q32')
        row = dict(elf_sha256=sha(p), unused_original_Q32_table_garbage_collected=True)
        for name, base in (('ITCM', 0x10000000), ('DTCM', 0x30000000)):
            used = max(s['sh_addr']+s['sh_size'] for s in sections
                if base <= s['sh_addr'] < base+262144)-base
            row[name+'_used'] = used
            row[name+'_increase'] = used-before_memory[kind][name+'_used']
            row[name+'_free'] = 262144-used
            assert 0 < used < 262144
        memory[kind] = row
(out/'memory.json').write_text(json.dumps(memory, indent=2)+'\n')
summary = dict(rows=rows, timing_classes=ct, memory=memory, checks=manifest['checks'],
    conditions='Same image; 800MHz M55, ITCM code/DTCM data and stack 256KiB each, caches off; GCC15.2.1 O3 fpv5-d16 no-fast-math ffp-contract=off; 5x100 measured calls +10 warmups per batch',
    scope='Whole public FFT/iFFT including double/DS conversion; not whole keygen speed',
    raw_sha256=manifest['raw_sha256'], elf_sha256=manifest['elf_sha256'])
(out/'summary.json').write_text(json.dumps(summary, indent=2)+'\n')
print(json.dumps(summary, indent=2))
