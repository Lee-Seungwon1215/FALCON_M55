#!/usr/bin/env python3
"""Offline audit of the three completed 2026-09-10 TCM cause-control series."""
import hashlib
import json
from pathlib import Path
import re

from elftools.elf.elffile import ELFFile

ROOT = Path(__file__).resolve().parents[1]
SERIES = {
    'placement': ('tcm-root-20260910T023126Z', 25),
    'wait_controls': ('tcm-root-20260910T023253Z', 20),
    'write_read_factorial': ('tcm-root-20260910T023429Z', 24),
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def words(raw, address):
    """All debugger word-dump rows at the exact address."""
    return [[int(x, 16) for x in m.split()] for m in re.findall(
        rf'^0x{address:08x}:\s*((?:0x[0-9a-f]+[ \t]*)+)$', raw, re.M)]


def main():
    report = {'valid': True, 'series': {}, 'cases': []}
    kernel_bytes = {}
    for kind, (name, count) in SERIES.items():
        directory = ROOT / 'runs' / name
        meta = json.loads((directory / 'results.json').read_text())
        assert meta['complete'] and len(meta['cases']) == count
        assert meta['probe'] == '003C00223335510735383531'
        with (directory / 'root.elf').open('rb') as f:
            elf = ELFFile(f)
            section = elf.get_section_by_name('.text')
            body, base = section.data(), section['sh_addr']
        symbols = meta['symbols']
        pass_count = 0
        for case in meta['cases']:
            i = case['id']
            raw = (directory / f'case-{i}.log').read_text()
            fields = {k: int(v, 0) for k, v in re.findall(
                r'(\w+)=(0x[\da-f]+|\d+)',
                re.search(r'^CASE (.+)$', raw, re.M)[1])}
            assert all(case[k] == v for k, v in fields.items())
            assert 'INIT_FAILED' not in raw and 'PREP_FAILED' not in raw
            assert '[Inferior 1 (Remote target) detached]' in raw
            assert words(raw, 0x56028020) == [[0, 0x00100000]]
            assert words(raw, 0x56028048) == [[0x8c800000]]
            assert words(raw, 0xe000ed14) == [[0x201]]
            assert words(raw, 0xe001e000)[0][0] == 0x1300a
            assert words(raw, 0xe001e010) == [[0x49, 0x49]]
            ecc = words(raw, 0xe001e120)
            # Rows are pre-clear, prepared/pre-run, post-run. DATA words can
            # retain old values while the corresponding VALID flag is clear.
            assert len(ecc) == 3 and ecc[1][0] == ecc[1][2] == 0
            write = case.get('wsdisable', 0)
            expected_tcmcr = [[0x99 | write]]
            if 'read_wsdisable' in case:
                expected_tcmcr.append([0x99 | case['read_wsdisable']])
            if 'wsdisable' in case:
                expected_tcmcr.append([0x99])
                assert 'RESTORED_TCMCR:' in raw
            assert words(raw, 0x56008008) == expected_tcmcr
            expected = b''.join(((case['data'] + j) ^ 0x5a5aa5a5)
                               .to_bytes(4, 'little') for j in range(0, 128, 4))
            assert (directory / f'input-{i}.bin').read_bytes() == expected
            kernel = case['kernel']
            code = (directory / f'code-{i}.bin').read_bytes()
            assert code == body[symbols[kernel]-base:symbols[kernel+'_end']-base]
            if kernel in kernel_bytes:
                assert code == kernel_bytes[kernel]
            kernel_bytes[kernel] = code
            output = (directory / f'output-{i}.bin').read_bytes()
            checksum = sum(int.from_bytes(expected[j:j+4], 'little')
                           for j in range(0, 128, 4)) & 0xffffffff
            correct = output == expected if kernel == 'root_ldm_copy' else case['r0'] == checksum
            passed = (case['pc'] == symbols['probe_done'] and correct
                      and all(case[k] == 0 for k in ('cfsr', 'hfsr', 'afsr')))
            assert passed == case['passed'] and correct == case['correct_output']
            if kind == 'placement':
                predicted = not (case['code'] == 0x1001302c and case['data'] == 0x10024000)
            else:
                predicted = bool(case.get('read_wsdisable', write) & 0x800000)
            assert passed == predicted
            if passed:
                assert ecc[2][0] & 1 == ecc[2][2] & 1 == 0
                pass_count += 1
            else:
                assert case['pc'] == symbols['probe_fault']
                assert case['hfsr'] == 0x40000000
                assert (case['cfsr'], case['afsr']) in (
                    (0x8200, 0x20000), (0x100, 0x10000000))
                active = [ecc[2][j] for j in (0, 2) if ecc[2][j] & 1]
                assert active and all((value >> 24) & 7 == 4 for value in active)
            files = [directory / f'{prefix}-{i}.{suffix}' for prefix, suffix in (
                ('case', 'gdb'), ('case', 'log'), ('openocd', 'log'),
                ('code', 'bin'), ('input', 'bin'), ('output', 'bin'))]
            report['cases'].append(dict(series=kind, **case,
                file_sha256={str(p.relative_to(ROOT)): sha(p) for p in files}))
        report['series'][kind] = dict(run=name, count=count, passed=pass_count,
            failed=count-pass_count, file_sha256={p.name: sha(p) for p in (
                directory / 'root.elf', directory / 'results.json',
                directory / 'run_tcm_root.py', directory / 'tcm_probe.s',
                directory / 'tcm_root_kernels.s', directory / 'disassembly.txt')})
    report['kernel_sha256'] = {k: hashlib.sha256(v).hexdigest()
                               for k, v in kernel_bytes.items()}
    report['checks'] = [
        '69 cases complete; exact raw-log results; all source input bytes correct',
        'Identical kernel bytes in CPU-written destinations and each linked ELF',
        'ECC ON, TEBR valid flags clear before calls, I/D caches OFF, boot HSI registers',
        'Wait-state control and read-phase register readbacks match case specification',
        'Every changed wait-state setting restored to 0x00000099 before reset',
        'Every expected failure reports ECC in ITCM bank; every pass has correct output',
    ]
    (ROOT / 'diagnostics/tcm_root_audit.json').write_text(
        json.dumps(report, indent=2) + '\n')
    for name, series in report['series'].items():
        print(f"PASS audit {name}: {series['passed']} passing / {series['failed']} failing test cases")
    print('PASS: all 69 cases satisfy the independent raw-log/byte/register audit.')


if __name__ == '__main__':
    main()
