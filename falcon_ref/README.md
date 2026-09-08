# Falcon reference baseline

This directory contains the portable `clean` Falcon implementations copied
from PQClean.

- Upstream: https://github.com/PQClean/PQClean
- Upstream commit: `0586a824fc0d49df0b6b6e9179d8d15d06d0974f`
- PQClean implementation version: `20211101 with PQClean patches`
- Imported parameter sets: Falcon-512 and Falcon-1024
- Imported implementation: `clean` only
- Import date: 2026-09-07

The original PQClean paths are preserved:

```text
common/
crypto_sign/falcon-512/clean/
crypto_sign/falcon-1024/clean/
```

The `aarch64` implementation was intentionally not imported: Cortex-M55 is a
32-bit Armv8.1-M target and cannot use AArch64/NEON code. M55-specific FPU and
MVE optimizations should be developed as new implementations while retaining
these `clean` directories as the unmodified comparison baseline.

For a bare-metal target, replace PQClean's host `randombytes` provider with the
board's cryptographically secure RNG integration. The Falcon code also depends
on `common/fips202.c` and `common/fips202.h`.
