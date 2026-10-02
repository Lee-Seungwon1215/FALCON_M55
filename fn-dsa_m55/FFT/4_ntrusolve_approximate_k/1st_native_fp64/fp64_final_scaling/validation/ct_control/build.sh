#!/bin/bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "$0")" && pwd)"
M55_ROOT="$(cd "$TASK_ROOT/../../../../../.." && pwd)"
COMMON="$M55_ROOT/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
crypto="$(cd "$TASK_ROOT/../.." && pwd)"
build="$TASK_ROOT/build"
mkdir -p "$build/generated"
python3 -B "$TASK_ROOT/../generate.py" "$crypto" "$build/generated" perf
cmake --fresh -S "$TASK_ROOT" -B "$build" -G Ninja -DBOARD=nucleo_n657x0_q \
 -DCRYPTO_SOURCE="$crypto" -DCOMMON_MEAS="$COMMON" -DBENCH_LABEL=ct-control -DBENCH_SOURCE=kernel_bench.c \
 -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
 -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
 -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$build" -j 4
