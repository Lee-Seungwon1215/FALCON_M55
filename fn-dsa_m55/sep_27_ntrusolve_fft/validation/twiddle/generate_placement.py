#!/usr/bin/env python3
"""Print an apply_patch patch for same-instruction, test-only address variants.

The eight copies differ ONLY in address modulo 32. This is a diagnostic,
not a production backend selector. No build-time crypto source rewriting.
"""
import hashlib
from pathlib import Path

here = Path(__file__).resolve().parent
source = here.parent.parent / 'A_tw_bridge/kgen_fft_cm55.s'
text = source.read_text()
macro_start = text.index('\t.macro NTRU_TWIDDLE_LOOP ')
body_start = text.index('\t.section .text.fndsa_ntru_mve_q32_twiddle,', macro_start)
body_end = text.index('\n', text.index('\t.size fndsa_ntru_mve_q32_twiddle,', body_start))
macro = text[macro_start:body_start]
body = text[body_start:body_end]
output = ['/* Test-only mechanical copies of the production A9 multiplier.',
          ' * Source SHA256: ' + hashlib.sha256(source.read_bytes()).hexdigest(),
          ' * Rebuild with this generator if the production instructions change. */',
          '\t.syntax unified\n\t.thumb', macro]
for offset in range(0, 32, 4):
    copy = body.replace('fndsa_ntru_mve_q32_twiddle', f'trial_twiddle_at_{offset}')
    copy = copy.replace('.L', f'.Lpos{offset}_')
    copy = copy.replace('\t.balign 4', f'\t.balign 32\n\t.space {offset}, 0')
    output.append(copy)
target = here / 'placement_helpers.s'
assert not target.exists(), 'Preserve an existing diagnostic source; review before regeneration.'
print('*** Begin Patch\n*** Add File: ' + str(target))
for line in '\n'.join(output).splitlines():
    print('+' + line)
print('*** End Patch')
