#!/bin/bash
set -euo pipefail
MEASUREMENT_DIR="$(cd "$(dirname "$0")" && pwd)"
REF_DIR="$MEASUREMENT_DIR/../ref"
FNDSA_C_NAMES=(codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
FNDSA_C_SOURCES=()
for name in "${FNDSA_C_NAMES[@]}"; do
  FNDSA_C_SOURCES+=("$REF_DIR/$name.c")
done
mkdir -p "$MEASUREMENT_DIR/host"
# Independent native macOS/arm64 backend from the same unchanged source.
# Host numbers are not performance results. Only deterministic bytes matter.
clang --version
clang -O3 -ffp-contract=off -DBENCH_HOST -I"$REF_DIR" \
  "$MEASUREMENT_DIR/app/benchmark.c" "${FNDSA_C_SOURCES[@]}" \
  -lm -o "$MEASUREMENT_DIR/host/oracle"
"$MEASUREMENT_DIR/host/oracle" --pilot > "$MEASUREMENT_DIR/host/pilot.log"
"$MEASUREMENT_DIR/host/oracle" > "$MEASUREMENT_DIR/host/full.log"
