#!/bin/bash
# C regression only. The ARM assembly is tested separately on the M55 board.
set -euo pipefail
STAGE_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$STAGE_DIR/M1_rounding_montgomery"
OUT="$STAGE_DIR/results/m1/host"
mkdir -p "$OUT"
NAMES=(codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
SOURCES=()
for name in "${NAMES[@]}"; do SOURCES+=("$SOURCE_DIR/$name.c"); done
clang --version > "$OUT/compiler.log"
# Use upstream's detected macOS/arm64 backend, like the existing host oracle.
# Forcing NEON=0 selects an upstream scalar-signing path whose fused mq norm
# function has no active C definition. Do not alter that unrelated code here.
clang -O3 -ffp-contract=off -DFNDSA_ASM_CORTEXM4=0 \
  -I"$SOURCE_DIR" "${SOURCES[@]}" \
  "$SOURCE_DIR/test_fndsa.c" -lm -o "$OUT/test_fndsa"
"$OUT/test_fndsa" > "$OUT/test_fndsa.log"
tail -20 "$OUT/test_fndsa.log"
