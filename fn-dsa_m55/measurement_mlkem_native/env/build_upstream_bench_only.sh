#!/bin/bash
# This target only builds the unchanged upstream benchmark. It never starts
# the hardware runner, OpenOCD, or GDB.
set -euo pipefail
source /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/env/environment.sh
cd "$MLKEM_NATIVE_PINNED_ROOT"
make bench_512 CYCLES=NO AUTO=0 OPT=0 \
  EXTRA_MAKEFILE=test/zephyr/platform.mk \
  ZEPHYR_TARGET=nucleo-n657x0-q \
  BUILD_DIR="$FNDSA_M55_ENV/upstream-build-opt0"
