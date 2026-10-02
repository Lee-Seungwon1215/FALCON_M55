#!/usr/bin/env python3
"""Check cleanup against the frozen A17, without accepting arithmetic edits.

This is a source-scope regression check, not a C semantics/security proof.
"""
import hashlib
import json
import re
import tarfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'A_tw_bridge'
OUT = Path(__file__).resolve().parent
SNAPSHOTS = ROOT / 'validation/source_snapshots'
REMOVED = {
    'kgen_fxp.c': {
        'fp64q_add', 'fp64q_sub', 'fp64q_mul_scaled_rhs', 'fp64q_mul', 'fp64q_half',
        'fp64c_mul_twiddle_q32', 'fp64c_mul_q32',
        'vect_FFT_fp64_native', 'vect_iFFT_fp64_native', 'vect_invnorm_fft_fp64',
        'vect_mul_fft_fp64', 'vect_inv_mul2e_fft_fp64', 'vect_set_fp64',
        'vect_adj_fft_fp64', 'vect_mul_realconst_fp64', 'vect_mul_selfadj_fft_fp64',
        'vect_sqnorm_fp64', 'vect_fxr_to_fp64', 'vect_fp64_to_fxr',
        'vect_fxr_to_fp64_inplace', 'vect_fp64_to_fxr_inplace',
    },
    'kgen_fft_mve.c': {
        'dsum', 'dadd', 'dscale', 'getds', 'putds', 'pow2i',
        'fndsa_ds_from_big', 'fndsa_ds_from_i32', 'fndsa_ds_inverse',
        'fndsa_ds_mul', 'fndsa_ds_div_real', 'fndsa_ds_to_k',
    },
    'kgen_poly.c': {'poly_big_to_fp64'},
    'kgen_inner.h': {'fp64_from_fxr', 'fp64_k_update_ok'},
}
CHANGED = set(REMOVED) | {'kgen_ds.h', 'kgen_fft_bridge.c', 'mq_cm55.s'}
DELETED = {'kgen_ds_q32.h'}
ADDED = {'kgen_fft_cm55.h'}


def without_comments(text):
    pattern = r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\''
    return re.sub(pattern, lambda m: ' ' * len(m[0]) if m[0].startswith('/') else m[0],
                  text, flags=re.S)


def tokens(text):
    return re.findall(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|\w+|[^\s]',
                      without_comments(text))


def functions(text):
    clean = without_comments(text)
    scan = re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',
                  lambda m: ' ' * len(m[0]), clean)
    scan = re.sub(r'__attribute__\s*\(\([^)]*\)\)',
                  lambda m: ' ' * len(m[0]), scan)
    found = {}
    pattern = r'(?m)^(?:[A-Za-z_]\w*[ \t]+)*([A-Za-z_]\w*)\([^;{}]*\)\s*\{'
    for m in re.finditer(pattern, scan):
        name = m[1]
        end = m.end()
        depth = 1
        while depth:
            depth += (scan[end] == '{') - (scan[end] == '}')
            end += 1
        found[name] = clean[m.start(1):end]
    return found


def check():
    hashes = json.loads((SNAPSHOTS / 'A17_fp64_invnorm.json').read_text())['sha256']
    with tarfile.open(SNAPSHOTS / 'A17_fp64_invnorm.tar.gz') as archive:
        old = {Path(m.name).name: archive.extractfile(m).read()
               for m in archive.getmembers() if m.isfile() and Path(m.name).suffix in ('.c', '.h', '.s')}
    for name, data in old.items():
        assert hashlib.sha256(data).hexdigest() == hashes[name], ('archive hash', name)
    new = {p.name: p.read_bytes() for p in SOURCE.glob('*') if p.suffix in ('.c', '.h', '.s')}
    assert old.keys() - new.keys() == DELETED
    assert new.keys() - old.keys() == ADDED
    changed = {name for name in old.keys() & new.keys() if old[name] != new[name]}
    assert changed == CHANGED, changed
    checked = []
    for name in sorted(CHANGED - {'mq_cm55.s', 'kgen_ds.h'}):
        before, after = functions(old[name].decode()), functions(new[name].decode())
        assert before.keys() - after.keys() == REMOVED.get(name, set()), (
            name, 'removed functions', sorted(before.keys() - after.keys()))
        assert not after.keys() - before.keys(), (name, 'new function')
        for fn in after:
            a, b = tokens(before[fn]), tokens(after[fn])
            if fn == 'fft_bridge':
                # Only braces were added to the existing if/else arms.
                a = [x for x in a if x not in ('{', '}')]
                b = [x for x in b if x not in ('{', '}')]
            assert a == b, (name, fn, 'changed executable tokens')
            checked.append(name + ':' + fn)
    # Constant tables are byte-identical. No stride/table packing experiment.
    for name, marker, ending in (
        ('kgen_fxp.c', 'static const fxc GM_TAB', '\n};'),
        ('kgen_fft_mve.c', 'static const ds_root tw_gm_ds32_re', '\n};'),
        ('kgen_fft_mve.c', 'static const ds_root tw_gm_ds32_im', '\n};'),
    ):
        def table(data):
            s = data.decode(); a = s.index(marker); b = s.index(ending, a) + len(ending)
            return s[a:b]
        assert table(old[name]) == table(new[name]), (name, marker)
    marker = '@ Diagnostic entry used by the stage-3 exactness harness.'
    assert new['mq_cm55.s'].rstrip() == old['mq_cm55.s'].split(marker.encode())[0].rstrip()
    # Every other assembly/C file, including solver, sign/verify and RNS, is unchanged.
    result = {'claim': 'Retained function executable tokens and tables unchanged; not formal proof',
              'changed': sorted(changed), 'deleted': sorted(DELETED), 'added': sorted(ADDED),
              'retained_functions_checked': checked,
              'removed_functions': {k: sorted(v) for k, v in REMOVED.items()},
              'removed_test_symbol': 'fndsa_stage3_mul_probe',
              'sha256': {name: hashlib.sha256(data).hexdigest() for name, data in sorted(new.items())}}
    return result


if __name__ == '__main__':
    result = check()
    (OUT / 'scope.json').write_text(json.dumps(result, indent=2) + '\n')
    print('CLEANUP_SCOPE_OK retained_functions=' + str(len(result['retained_functions_checked'])))
