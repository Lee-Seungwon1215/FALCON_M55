"""Record/verify the exact source and ELF used by a completed local build."""
from pathlib import Path
import hashlib
import json
import sys

def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def snapshot(build, source):
    root = Path(__file__).resolve().parent
    files = list(source.glob('*.[chs]'))
    files += [p for p in root.iterdir() if p.suffix in ('.c', '.h')]
    files += [root/'CMakeLists.txt', root/'build.sh', root/'generate.py']
    files += list((build/'generated').glob('*'))
    files += [build/'compile_commands.json', build/'zephyr/zephyr.elf',
              build/'zephyr/.config', build/'fndsa_dtcm_linker.ld']
    return {str(p.resolve()): digest(p) for p in sorted(files) if p.is_file()}

if __name__ == '__main__':
    build, source = (Path(p).resolve() for p in sys.argv[1:3])
    (build/'build_manifest.json').write_text(json.dumps(snapshot(build, source), indent=2)+'\n')
