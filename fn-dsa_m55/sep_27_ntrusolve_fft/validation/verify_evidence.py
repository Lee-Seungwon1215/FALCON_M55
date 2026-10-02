#!/usr/bin/env python3
"""Recheck current-source evidence and untouched baselines; not a CT proof."""
import hashlib
import json
from pathlib import Path

p = Path(__file__).resolve().parent
r = p.parent
digest = lambda f: hashlib.sha256(f.read_bytes()).hexdigest()
current = json.loads((p / 'current_validation.json').read_text())
checked = []
required = {
    'A_tw_bridge': {'fixed_input', 'input_pair', 'input_predicate', 'fixed_division', 'fixed_fft', 'rootmul', 'kat', 'extra', 'sigkat', 'keygen', 'profile', 'kernel', 'invnorm'},
    'B_continuous_ds': {'fixed_input', 'kat', 'extra', 'sigkat', 'keygen', 'profile', 'kernel',
                        'encoding', 'rounding', 'decoding', 'division'},
}
for candidate, modes in required.items():
    assert modes <= current[candidate].keys(), (candidate, 'missing current gate')
    # Supplementary diagnostics are integrity checked, but are NOT adopted
    # as production whole-performance measurements or new security proofs.
    modes = modes | (set(current[candidate]) & {
        'fft_alignment', 'fft_placement', 'fft_context', 'fft_replay', 'profile_probe'})
    sources = {str(f): digest(f) for f in (r / candidate).glob('*.[chs]')}
    for mode in sorted(modes):
        run = current[candidate][mode]
        directory = p / 'results' / candidate / mode / run
        m = json.loads((directory / 'manifest.json').read_text())
        assert m['valid_measurement'] and not m['errors'], directory
        assert digest(directory / 'raw.log') == m['raw_sha256'], directory
        assert digest(directory / 'benchmark.elf') == m['elf_sha256'], directory
        assert all(m['source_sha256'].get(f) == h for f, h in sources.items()), directory
        checked.append({'candidate': candidate, 'mode': mode, 'run': run})
baselines = []
for name in ('baseline_m55', 'baseline_ntt'):
    origin = json.loads((r / name / 'origin.json').read_text())
    for file, expected in origin['files'].items():
        assert digest(r / name / file) == expected, (name, file)
        assert digest(Path(origin['source']) / file) == expected, ('external changed', file)
    baselines.append({'snapshot': name, 'external': origin['source'],
                      'files_unchanged': len(origin['files'])})
out = {'claim': 'Integrity, current-source gates and unchanged refs only; not formal security',
       'checked_runs': checked, 'baselines': baselines}
(p / 'evidence_check.json').write_text(json.dumps(out, indent=2) + '\n')
print(f'EVIDENCE_OK runs={len(checked)} baseline_files={sum(x["files_unchanged"] for x in baselines)}')
