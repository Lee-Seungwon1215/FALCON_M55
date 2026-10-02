#!/usr/bin/env python3
"""Offline, allow-listed ST evidence export. No USB, network or submission."""
import hashlib
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SERIAL = '003C00223335510735383531'
OUTPUT = HERE / 'STM32N657_ITCM_ECC_20260910.zip'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    if OUTPUT.exists():
        raise SystemExit(f'Refusing to overwrite existing attachment: {OUTPUT.name}')
    subprocess.run([sys.executable, str(ROOT / 'diagnostics/audit_tcm_root.py')], check=True)
    audit = json.loads((ROOT / 'diagnostics/tcm_root_audit.json').read_text())
    assert audit['valid'] and len(audit['cases']) == 69
    contents, records = {}, {}

    def add(name, original, source, expected=None, transform=None):
        assert name not in contents and not name.startswith('/') and '..' not in Path(name).parts
        source_hash = digest(original)
        if expected is not None:
            assert source_hash == expected, source
        exported = original
        changes = []
        if transform:
            exported, changes = transform(original)
        for private in (str(ROOT).encode(), b'/Users/', SERIAL.encode()):
            assert private not in exported, (name, 'unredacted private marker')
        contents[name] = exported
        records[name] = dict(source=source, source_sha256=source_hash,
                             exported_sha256=digest(exported), transformations=changes)

    def sanitize(raw):
        value = raw.decode('utf-8')
        edits = []
        for old, new, label in ((str(ROOT), '<LOCAL_WORKSPACE>', 'local workspace path redacted'),
                                (SERIAL, '<REDACTED_PROBE_SERIAL>', 'probe serial redacted')):
            if old in value:
                value = value.replace(old, new)
                edits.append(label)
        return value.encode(), edits

    for kind, info in audit['series'].items():
        directory = ROOT / 'runs' / info['run']
        # No application sources, keys, benchmark inputs or local environment.
        # The old runner depends on a private directory layout: export its exact
        # generated per-case scripts instead, not a misleading portable runner.
        for name in ('root.elf', 'results.json', 'tcm_probe.s', 'tcm_root_kernels.s', 'disassembly.txt'):
            path = directory / name
            add(f'captures/{kind}/{name}', path.read_bytes(), str(path.relative_to(ROOT)),
                info['file_sha256'][name], None if path.suffix == '.elf' else sanitize)
        for case in (c for c in audit['cases'] if c['series'] == kind):
            for path_name, expected in case['file_sha256'].items():
                path = ROOT / path_name
                transform = None if path.suffix == '.bin' else sanitize
                if path.suffix == '.gdb':
                    def transform(raw, directory=directory, kind=kind):
                        value = raw.decode()
                        assert value.count('dump binary memory ') == 3
                        assert value.count(str(directory)) == 3
                        value = value.replace(str(directory), f'replay-output/{kind}')
                        return value.encode(), ['three dump destinations changed to replay-output/'+kind]
                add(f'captures/{kind}/{path.name}', path.read_bytes(), path_name, expected, transform)

    for name in ('request_en.md', 'reproduction_en.md'):
        add(name, (HERE / name).read_bytes(), 'prepared support document', transform=sanitize)
    # Generate the same upstream Tcl sequence; do not run OpenOCD.
    upstream = Path(os.environ['MLKEM_NATIVE_PINNED_ROOT'])
    sys.path.insert(0, str(upstream / 'test/zephyr/nucleo_n657x0_q'))
    from nucleo_host.openocd_tools import (flexmem_script_lines, openocd_base_args,
                                          runtime_gdbserver_cmd)
    os.environ.update(OPENOCD_INTERFACE='interface/stlink.cfg', OPENOCD_TARGET='target/stm32n6x.cfg')
    base = openocd_base_args(openocd='openocd', speed='8000', serial='', transport='swd')
    runtime = runtime_gdbserver_cmd(openocd='openocd', port=3349, speed='8000', serial='', transport='swd')
    assert runtime[:len(base)] == base
    notice = ('# Generated from mlkem-native commit 637d076aa113d8faaec2277ed4a46b657acaf35f\n'
              '# Copyright (c) The mlkem-native project authors\n'
              '# Copyright (c) Arm Ltd.\n'
              '# SPDX-License-Identifier: Apache-2.0 OR ISC OR MIT\n')

    def tcl_options(args):
        assert len(args) % 2 == 0
        lines = []
        for flag, value in zip(args[::2], args[1::2]):
            assert flag in ('-f', '-c')
            lines.append(f'source [find {value}]' if flag == '-f' else value)
        return '\n'.join(lines) + '\n'

    generated = {
        'openocd-base.cfg': tcl_options(base[1:]),
        'runtime.cfg': tcl_options(runtime[len(base):]),
        'flexmem-setup.cfg': '\n'.join(flexmem_script_lines(timeout_ms=5000)) + '\n',
    }
    helper = upstream / 'test/zephyr/nucleo_n657x0_q/nucleo_host/openocd_tools.py'
    for name, value in generated.items():
        add(name, (notice + value).encode(), 'generated from pinned upstream helper; no hardware execution')
    add('UPSTREAM_LICENSE.txt', (upstream / 'LICENSE').read_bytes(), 'mlkem-native/LICENSE')
    summary = dict(valid=True, original_case_count=69,
                   series={k: {field: v[field] for field in ('run', 'count', 'passed', 'failed')}
                           for k, v in audit['series'].items()}, checks=audit['checks'],
                   kernel_sha256=audit['kernel_sha256'],
                   upstream_helper_sha256=digest(helper.read_bytes()))
    add('audit_summary.json', (json.dumps(summary, indent=2)+'\n').encode(),
        'summary of offline original-evidence audit')
    manifest = dict(status='prepared_not_submitted', files=records,
                    excluded=['application/cryptographic source and data', 'local environment files',
                              'account paths', 'originating probe serial', 'incomplete harness runs'],
                    replay_status='captured scripts with output-path edits; no new board run')
    contents['manifest.json'] = (json.dumps(manifest, indent=2)+'\n').encode()
    assert sum(n.endswith('.gdb') for n in contents) == 69
    assert sum(n.endswith('.elf') for n in contents) == 3
    for name, data in contents.items():
        assert b'/Users/' not in data and SERIAL.encode() not in data, name
    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, 'w', compression=zipfile.ZIP_DEFLATED) as archive:
        for name, data in sorted(contents.items()):
            archive.writestr(name, data)
    payload = buffer.getvalue()
    with zipfile.ZipFile(io.BytesIO(payload)) as archive:
        assert archive.testzip() is None
        assert set(archive.namelist()) == set(contents)
        for name, record in records.items():
            assert digest(archive.read(name)) == record['exported_sha256']
    with OUTPUT.open('xb') as f:
        f.write(payload)
    result = dict(status='prepared_not_submitted', archive=OUTPUT.name,
                  archive_sha256=digest(payload), size_bytes=len(payload), files=len(contents),
                  cases=69, original_evidence_audit_passed=True, privacy_marker_scan_passed=True,
                  zip_integrity_passed=True, hardware_run_this_step=False)
    with (HERE / 'package_check.json').open('x') as f:
        f.write(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
