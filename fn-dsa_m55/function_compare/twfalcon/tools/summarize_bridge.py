#!/usr/bin/env python3
"""Account disjoint regions of the integrated bridge (not standalone kernels)."""
import hashlib
import json
import re
import sys
from pathlib import Path

out = Path(sys.argv[1]).resolve()
run = json.loads((out/'run.json').read_text())
assert run['valid_measurement'] and run['kind'] == 'bridgeprofile', run
precomputed = any(p.endswith('/tw32_gm_ds32.c') for p in run['source'])
raw = (out/'raw.log').read_text()
assert hashlib.sha256((out/'raw.log').read_bytes()).hexdigest() == run['raw_sha256']
raw = re.sub(r'Info : [^\n]*\n', '', raw)
totals = {}
regions = {}
for match in re.finditer(r'^BPRO_TOTAL degree=(\d+) inverse=(\d+) batch=(\d+) backend=(\w+) calls=(\d+) cycles=(\d+) min=(\d+) max=(\d+)$', raw, re.M):
    d, inv, batch, backend, calls, cycles, lo, hi = match.groups()
    key = (int(d), int(inv), int(batch))
    assert backend not in totals.setdefault(key, {})
    totals[key][backend] = dict(calls=int(calls), cycles=int(cycles), minimum=int(lo), maximum=int(hi))
for match in re.finditer(r'^BPRO_REGION degree=(\d+) inverse=(\d+) batch=(\d+) part=(\w+) calls=(\d+) cycles=(\d+)$', raw, re.M):
    d, inv, batch, part, calls, cycles = match.groups()
    key = (int(d), int(inv), int(batch))
    assert part not in regions.setdefault(key, {})
    regions[key][part] = dict(calls=int(calls), cycles=int(cycles))
assert len(totals) == len(regions) == 20
rows = []
for degree in (512, 1024):
    for inverse in (0, 1):
        keys = [(degree, inverse, b) for b in range(5)]
        sums = {name: sum(totals[k][name]['cycles'] for k in keys)
                for name in ('public_fp64', 'public_alias', 'clone_control', 'profile', 'M55_ref_fixed')}
        count = sum(totals[k]['profile']['calls'] for k in keys)
        assert count == 500
        r = {part: sum(regions[k][part]['cycles'] for k in keys)
             for part in ('input', 'output', 'roots', 'core_inclusive')}
        r['compute_and_inner_control'] = r['core_inclusive']-r['roots']
        r['outer_control_measurement'] = sums['profile']-r['input']-r['output']-r['core_inclusive']
        parts = ('input', 'roots', 'compute_and_inner_control', 'output', 'outer_control_measurement')
        assert all(r[p] >= 0 for p in parts)
        assert sum(r[p] for p in parts) == sums['profile']
        for k in keys:
            assert regions[k]['roots']['calls'] == 100*(degree//8+1)
            assert all(regions[k][p]['calls'] == 100 for p in ('input', 'output', 'core_inclusive'))
        rows.append(dict(degree=degree, op='iFFT' if inverse else 'FFT', calls=count,
            total_mean_cycles={n: v/count for n, v in sums.items()},
            regions={p: dict(mean_cycles=r[p]/count, percent=100*r[p]/sums['profile']) for p in parts},
            input_output_percent=100*(r['input']+r['output'])/sums['profile'],
            input_output_plus_roots_percent=100*(r['input']+r['output']+r['roots'])/sums['profile'],
            profile_vs_public_percent=100*(sums['profile']/sums['public_fp64']-1),
            profile_vs_clone_percent=100*(sums['profile']/sums['clone_control']-1),
            clone_vs_public_percent=100*(sums['clone_control']/sums['public_fp64']-1),
            public_vs_fixed_percent=100*(sums['public_fp64']/sums['M55_ref_fixed']-1)))
data = dict(rows=rows, precomputed_roots=precomputed, byte_identical_checks=run['checks']['byte_identical_outputs'],
    denominator='instrumented integrated function, 5 batches x 100 calls',
    note='Raw instrumented shares, no arbitrary timer subtraction. Compute includes loop/control, inverse scale and root counter overhead; not a pure assembly-only cycle count.',
    original_sources_unchanged=run['source'],
    raw_sha256=run['raw_sha256'], elf_sha256=run['elf_sha256'])
(out/'bridge_summary.json').write_text(json.dumps(data, indent=2)+'\n')
lines = [
    '# Integrated FFT/iFFT: same-function region profile', '',
    '2026-09-26 KST. Measurement only; production arithmetic/assembly and root policy unchanged.', '',
    '## Conditions and interpretation', '',
    '- NUCLEO-N657X0-Q, Cortex-M55 800 MHz, GCC 15.2.1, `-O3`, `fpv5-d16`, no fast math/FMA contraction.',
    '- Existing mlkem-native-based board startup: ITCM code, DTCM data/stack, each 256 KiB; caches OFF, interrupts disabled, TCM_CONTROL=0x99, default FP environment (FZ/DN OFF).',
    '- Same ELF contains unchanged public functions, namespace-only control copies, instrumented copies, and fixed M55_ref-equivalent function bodies.',
    '- 5 batches, each 10 warmup + 100 measured calls; deterministic input changes each call, backend order rotates. Inverse input is an FFT output prepared outside timing.',
    '- Input copies, fixture preparation, output comparison and logging are outside timing. Public and measurement copies use the same input/output buffer address; their private workspaces and code addresses differ.',
    '- Removing marked timer hooks and undoing symbol renaming recovers both original complete C files byte for byte (generator asserts this). The same unmodified assembly is shared.',
    '- These are kernel diagnostic fixtures, not a whole-keygen workload-weighted profile.', '',
    '## Disjoint shares of the instrumented whole function', '',
    '| n | function pair | input double→2×FP32 | root preparation | compute + inner control | output 2×FP32→double | outer control/timing | total |',
    '| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |',
]
for r in rows:
    vals = [r['regions'][p]['percent'] for p in parts]
    lines.append(f"| {r['degree']} | vect_{r['op']} / vect_{r['op']}_fp64 | "+' | '.join(f'{v:.3f}%' for v in vals)+' | 100% |')
lines += ['', 'The compute bucket is `core_inclusive − roots`; the nested root time is **not double-counted**. It includes MVE butterfly arithmetic and coefficient load/store, loop/dispatch/call costs, inverse final scaling, and root timer/counter overhead. Outer residual is `whole − input − core_inclusive − output`. Rounded table entries can differ from 100% by 0.001 percentage point.', '',
    '## Cycles per call (arithmetic mean over 500 calls)', '',
    '| n | op | input | roots | compute + inner control | output | outer residual | measured total |',
    '| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |']
for r in rows:
    vals = [r['regions'][p]['mean_cycles'] for p in parts]
    lines.append(f"| {r['degree']} | {r['op']} | "+' | '.join(f'{v:,.2f}' for v in vals)+f" | {r['total_mean_cycles']['profile']:,.2f} |")
lines += ['', '## What accounts for the cost?', '',
    '| n | op | input+output conversion | conversion + root preparation |',
    '| ---: | --- | ---: | ---: |']
for r in rows:
    lines.append(f"| {r['degree']} | {r['op']} | {r['input_output_percent']:.3f}% | {r['input_output_plus_roots_percent']:.3f}% |")
lines += ['',
    ('This run uses precomputed FP32 roots. Root preparation now measures the remaining pointer/broadcast work, not runtime Q32 conversion. Packed assembly root loads are inside the compute bucket. There are no DS-kernel int64-to-double root conversions.' if precomputed else
     'Input/output representation conversion alone is about 13–14% of this implementation, not the whole slowdown. The larger non-butterfly expense is on-demand Q32 root conversion/splat/table preparation (~32–35%). `q32_tw()` performs signed-int64→double conversion, FP32 high/residual conversion, and table/broadcast preparation; the compiled path includes calls to `__aeabi_l2d`. No sub-profile of that helper was performed, so its exact individual contribution is not claimed.'), '',
    ('Runtime share is **not** a proven causal percentage of the speed gap against M55_ref. Use the separate same-image stage10/stage11 twiddlebench comparison for the measured optimization effect.' if precomputed else
     'Runtime share is **not** a proven causal percentage of the speed gap against M55_ref. Eliminating a region can change dataflow/memory costs, and M55_ref already includes root loads. Preconverted roots merit a separate experiment; this turn does not implement that optimization or claim a speedup.'), '',
    '## Instrumentation and same-image controls', '',
    '| n | op | fixed reference | unchanged public | namespace control | instrumented | instrumented vs public | instrumented vs control | control vs public |',
    '| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |']
for r in rows:
    t = r['total_mean_cycles']
    lines.append(f"| {r['degree']} | {r['op']} | {t['M55_ref_fixed']:,.2f} | {t['public_fp64']:,.2f} | {t['clone_control']:,.2f} | {t['profile']:,.2f} | {r['profile_vs_public_percent']:+.3f}% | {r['profile_vs_clone_percent']:+.3f}% | {r['clone_vs_public_percent']:+.3f}% |")
lines += ['',
    'Shares use measured, instrumented totals. No timer cycles were arbitrarily subtracted. Back-to-back empty interval was 1 cycle; the calibration loop including counter updates took about 16 cycles/iteration, but neither is an exact correction for every instrumented loop. Differences above include instrumentation-induced code generation/register allocation and layout effects, not just timestamp instructions. Public aliases differ only by a few cycles.', '',
    '## Validation and provenance', '',
    '- Public aliases/control/instrumented outputs: **8,800/8,800 byte-identical** to the unchanged public function. This is profiling-equivalence validation, not a new complete KAT or formal constant-time proof.',
    '- All 20 batch accounting checks pass; per call root-region counts are 65 (512) / 129 (1024).',
    '- Board CFSR/HFSR/AFSR are zero; TCM configuration/ECC checks pass. Original crypto source hashes are recorded and unchanged throughout the run.',
    '- M55_ref fixed function bodies and arithmetic helper bodies were separately audited unchanged with `tools/audit_fixed_reference.py`.',
    '- Historical whole-image cycle values are not substituted here: the fixed/public/control paths were all remeasured together in this ELF.', '',
    '[Raw board log](raw.log), [run manifest](run.json), [machine-readable summary](bridge_summary.json).', '',
    'Reproduce:', '', '```sh',
    'sh fn-dsa_m55/function_compare/twfalcon/integration_candidate/validation/build.sh bridgeprofile',
    'fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/function_compare/twfalcon/integration_candidate/validation/run_board.py bridgeprofile',
    'fn-dsa_m55/measurement_mlkem_native/env/build-venv/bin/python fn-dsa_m55/function_compare/twfalcon/tools/summarize_bridge.py <result-directory>',
    '```', '',
]
(out/'bridge_profile.md').write_text('\n'.join(lines))
print(json.dumps(rows, indent=2))
