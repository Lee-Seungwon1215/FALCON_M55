#!/usr/bin/env python3
"""Clone current bridge/FFT for measurement; never replace production sources.

Only symbol names and marked timer hooks differ. Removing the hooks and
undoing the namespace must recover the entire original source byte for byte.
Both copies use the very same, unchanged MVE assembly functions and roots.
"""
import hashlib
import json
import re
import sys
from pathlib import Path

source, output = map(Path, sys.argv[1:])
originals = {name: (source/name).read_text()
             for name in ('tw32_bridge.c', 'tw32_fft_mve.c')}
names = sorted({n for s in originals.values()
                for n in re.findall(r'^void\s+(\w+)\(', s, re.M)})
sha = lambda s: hashlib.sha256(s.encode()).hexdigest()
output.mkdir(parents=True, exist_ok=True)
manifest = dict(originals={n: sha(s) for n, s in originals.items()},
                generated={}, symbols=names, recover_original=True,
                interpretation='core minus roots includes butterfly arithmetic, memory accesses, loop control, inverse scaling and inner timer overhead')

def mark(s):
    return '/* BPRO_BEGIN */'+s+'/* BPRO_END */'

for prefix in ('bc_', 'bp_'):
    for filename, original in originals.items():
        code = original
        regions = []
        def wrap(fragment, op):
            global code
            assert code.count(fragment) == 1, (filename, op, fragment)
            timer = 'bp_time_'+str(len(regions))
            regions.append(op)
            code = code.replace(fragment,
                mark('uint32_t '+timer+' = bp_tick();\n')+fragment+
                mark('\nbp_end('+op+', '+timer+');\n'))
        if prefix == 'bp_':
            if filename == 'tw32_bridge.c':
                for direction in ('fft', 'ifft'):
                    # Each public bridge has its own input/core/output timers.
                    start = code.index('tw32_bridge_'+direction+'(')
                    end = code.index('\n}', start)
                    head, body, tail = code[:start], code[start:end], code[end:]
                    for fragment, op in (
                        ('from_double(logn, f);', 'BP_INPUT'),
                        ('ds32_'+direction+'_mve(logn, &workspace);', 'BP_CORE'),
                        ('to_double(logn, f);', 'BP_OUTPUT'),
                    ):
                        assert body.count(fragment) == 1
                        timer = 'bp_time_'+str(len(regions))
                        regions.append(op)
                        body = body.replace(fragment, mark('uint32_t '+timer+' = bp_tick();\n')+
                            fragment+mark('\nbp_end('+op+', '+timer+');\n'))
                    code = head+body+tail
            else:
                if 'tw_gm_ds32_re' in code:
                    wrap('''\tconst tw_fpr *real = tw_gm_ds32_re + m;
\tconst tw_fpr *imag = tw_gm_ds32_im + m;''', 'BP_ROOTS')
                    wrap('''\t\t\t\tds_splat4(&sr, tw_gm_ds32_re[m + i]);
\t\t\t\tds_splat4(&si, tw_gm_ds32_im[m + i]);''', 'BP_ROOTS')
                    wrap('''\t\t\t\ttw_fpr sri = tw_gm_ds32_re[m + i];
\t\t\t\ttw_fpr sii = neg1(tw_gm_ds32_im[m + i]);
\t\t\t\tds4 sr, si;
\t\t\t\tds_splat4(&sr, sri);
\t\t\t\tds_splat4(&si, sii);''', 'BP_ROOTS')
                else:
                    wrap('''\tfor (unsigned i = 0; i < m/2; i ++) {
\t\treal[i] = q32_tw(tw_gm_q32[m+i][0]);
\t\timag[i] = q32_tw(tw_gm_q32[m+i][1]);
\t}''', 'BP_ROOTS')
                    wrap('''\t\t\t\tds_splat4(&sr, q32_tw(tw_gm_q32[m + i][0]));
\t\t\t\tds_splat4(&si, q32_tw(tw_gm_q32[m + i][1]));''', 'BP_ROOTS')
                    wrap('''\t\t\t\ttw_fpr sri = q32_tw(tw_gm_q32[m + i][0]);
\t\t\t\ttw_fpr sii = neg1(q32_tw(tw_gm_q32[m + i][1]));
\t\t\t\tds4 sr, si;
\t\t\t\tds_splat4(&sr, sri);
\t\t\t\tds_splat4(&si, sii);''', 'BP_ROOTS')
        code = mark('#include "bridge_profile.h"\n')+code
        for name in names:
            code = re.sub(r'\b'+name+r'\b', prefix+name, code)
        recovered = re.sub(r'/\* BPRO_BEGIN \*/.*?/\* BPRO_END \*/', '', code, flags=re.S)
        for name in names:
            recovered = re.sub(r'\b'+prefix+name+r'\b', name, recovered)
        assert recovered == original, filename
        target = prefix+filename
        (output/target).write_text(code)
        manifest['generated'][target] = dict(sha256=sha(code), regions=regions)
(output/'bridge_profile_manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')
