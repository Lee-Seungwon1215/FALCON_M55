#!/usr/bin/env python3
"""Read-only NAR SHA-256 check for unpacked, fixed Nix source archives."""
import base64
import hashlib
import os
from pathlib import Path
import stat
import struct
import sys


def nar_hash(root, exclude=()):
    digest = hashlib.sha256()
    root = Path(root)
    exclude = set(exclude)

    def atom(value):
        value = value.encode() if isinstance(value, str) else value
        digest.update(struct.pack('<Q', len(value)))
        digest.update(value)
        digest.update(b'\x00' * (-len(value) % 8))

    def node(path):
        mode = path.lstat().st_mode
        atom('(')
        atom('type')
        if stat.S_ISDIR(mode):
            atom('directory')
            for child in sorted(path.iterdir(), key=lambda p: os.fsencode(p.name)):
                if child.relative_to(root).as_posix() in exclude:
                    continue
                atom('entry')
                atom('(')
                atom('name')
                atom(os.fsencode(child.name))
                atom('node')
                node(child)
                atom(')')
        elif stat.S_ISLNK(mode):
            atom('symlink')
            atom('target')
            atom(os.fsencode(os.readlink(path)))
        elif stat.S_ISREG(mode):
            atom('regular')
            if mode & stat.S_IXUSR:
                atom('executable')
                atom('')
            atom('contents')
            size = path.stat().st_size
            digest.update(struct.pack('<Q', size))
            with path.open('rb') as source:
                while block := source.read(1024 * 1024):
                    digest.update(block)
            digest.update(b'\x00' * (-size % 8))
        else:
            raise ValueError(f'Unsupported node: {path}')
        atom(')')

    atom('nix-archive-1')
    node(root)
    return 'sha256-' + base64.b64encode(digest.digest()).decode()


if __name__ == '__main__':
    # Optional paths after EXPECTED are explicit root-relative exclusions for
    # generated build caches, never silently ignored source directories.
    actual = nar_hash(sys.argv[1], sys.argv[3:])
    print(actual, sys.argv[1])
    if sys.argv[3:]:
        print('Explicit exclusions:', ', '.join(sys.argv[3:]))
    if len(sys.argv) > 2 and actual != sys.argv[2]:
        raise SystemExit(f'Hash mismatch: expected {sys.argv[2]}')
