"""TEST ONLY: prefix public names in unchanged Before_slothy kgen/vrfy.
Remaining arithmetic and original sample_f/SHAKE are shared in one ELF.
No production code is linked from another implementation directory.
"""
from pathlib import Path
import re
HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
dst = HERE/'build/reference'
dst.mkdir(parents=True, exist_ok=True)
for name in ('kgen', 'vrfy'):
    text = (ROOT/'Final_code/Before_slothy'/f'{name}.c').read_text()
    text = re.sub(r'\bfndsa_(keygen\w*|verify\w*)\b', r'baseline_\1', text)
    (dst/f'{name}.c').write_text(text)
