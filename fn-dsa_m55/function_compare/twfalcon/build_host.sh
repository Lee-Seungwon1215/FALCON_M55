#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$ROOT/build/host"
cc -std=c11 -O3 -ffp-contract=off -fno-fast-math \
  -Disnanf=isnan -Disinff=isinf \
  -I"$ROOT/bench" \
  -I"$ROOT/reference/upstream/c-fn-dsa-multiple" \
  "$ROOT/reference/gm_q32.c" "$ROOT/reference/fixed_fft.c" \
  "$ROOT/reference/upstream/c-fn-dsa-multiple/triple_float.c" \
  "$ROOT/tw32_scalar/fft_tw32_scalar.c" "$ROOT/tests/host_accuracy.c" \
  -lm -o "$ROOT/build/host/host_accuracy"
"$ROOT/build/host/host_accuracy"
