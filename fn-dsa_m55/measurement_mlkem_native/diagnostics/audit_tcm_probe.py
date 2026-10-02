#!/usr/bin/env python3
"""Offline verification of completed diagnostic logs; no board operations."""
import hashlib
import json
from pathlib import Path
import re
from elftools.elf.elffile import ELFFile

ROOT = Path(__file__).resolve().parents[1]
RUNS = {
    'single_load_uniform': '20260910T012837Z',
    'single_load_unique_branch': '20260910T013038Z',
    'mve_itcm_input_first': '20260910T013405Z',
    'ldm_itcm_input': '20260910T013623Z',
    'mve_dtcm_input': '20260910T013742Z',
    'mve_itcm_input_repeat': '20260910T013948Z',
}
elf = ROOT / 'build/zephyr/zephyr.elf'
assert hashlib.sha256(elf.read_bytes()).hexdigest() == \
    '44e351780ce356112a9d53d577a5a5b5c2831de1b43d4cec39b0b267763aabdb'
with elf.open('rb') as f:
    e = ELFFile(f)
    expected = b''.join(e.get_section_by_name(n).data() for n in
                        ('datas', 'device_states', 'k_mutex_area'))
assert len(expected) == 140
output = {}
for label, stamp in RUNS.items():
    path = ROOT / 'runs' / f'tcm-scalar-matrix-{stamp}'
    result = json.loads((path / 'results.json').read_text())
    raw = (path / 'raw.log').read_text()
    copy = not label.startswith('single_load')
    count = 5 if copy else 35
    assert result['returncode'] == 0 and len(result['cases']) == count
    lines = [line for line in raw.splitlines() if line.startswith('CASE ')]
    assert len(lines) == count
    records = []
    for case, line in zip(result['cases'], lines):
        fields = {k: int(v, 0) for k, v in re.findall(r'(\w+)=(0x[\da-f]+|\d+)', line)}
        assert all(case[k] == v for k, v in fields.items())
        clean = fields['cfsr'] == fields['hfsr'] == fields['afsr'] == 0
        completed = fields['pc'] == result['symbols']['probe_done']
        equal = ((path / f"copied-{fields['id']}.bin").read_bytes() == expected
                 if copy else fields['r0'] == (0x13579bdf if label.endswith('uniform')
                                              else fields['data']))
        passed = clean and completed and equal
        expected_pass = (not copy or label == 'mve_dtcm_input' or fields['id'] in (0, 1, 3))
        assert passed == expected_pass
        if not passed:
            assert fields['cfsr'] == 0x8200 and fields['afsr'] == 0x20000
        if not copy:
            assert fields['left'] == 0
        records.append(dict(**fields, completed=completed, correct_bytes=equal, passed=passed))
    if label == 'mve_itcm_input_repeat':
        ccrs = re.findall(r'0xe000ed14:\s+0x([0-9a-f]+)', raw)
        assert len(ccrs) == 5 and all(int(v, 16) == 0x201 for v in ccrs)
    output[label] = dict(run=str(path.relative_to(ROOT)), calls_per_case=1 if copy else 10000,
                         pass_count=sum(c['passed'] for c in records), cases=records,
                         raw_sha256=hashlib.sha256(raw.encode()).hexdigest())
dest = ROOT / 'diagnostics/tcm_audit.json'
dest.write_text(json.dumps(output, indent=2) + '\n')
print('PASS: 70 single-load cases and 20 copy cases verified from raw logs and bytes.')
print('PASS: MVE result repeated; scalar LDM also fails at the same code/data window combinations.')
print('PASS: DTCM-input control has five exact copies; source/measurement ELF unchanged.')
print(dest)
