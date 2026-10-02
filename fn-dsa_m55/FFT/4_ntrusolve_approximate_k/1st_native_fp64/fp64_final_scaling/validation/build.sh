#!/bin/bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "$0")" && pwd)"
M55_ROOT="$(cd "$TASK_ROOT/../../../../.." && pwd)"
COMMON="$M55_ROOT/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
label="${1:?fixed-perf|old-perf|new-perf|old-profile|new-profile|kernels|old-kat|new-kat}"
case "$label" in
  fixed-perf) crypto="$(cd "$TASK_ROOT/../../../ref" && pwd)" ;;
  old-perf|old-profile|old-kat) crypto="$(cd "$TASK_ROOT/../.." && pwd)" ;;
  new-perf|new-profile|kernels|new-kat) crypto="$(cd "$TASK_ROOT/.." && pwd)" ;;
  *) exit 2 ;;
esac
mode="${label#*-}"
bench=benchmark.c
if [[ "$label" == kernels ]]; then mode=perf; bench=kernel_bench.c; fi
if [[ "$label" == *-kat ]]; then mode=perf; bench=board_kat.c; fi
build="$TASK_ROOT/build/$label"
mkdir -p "$build/generated"
python3 "$TASK_ROOT/generate.py" "$crypto" "$build/generated" "$mode"
cmake --fresh -S "$TASK_ROOT" -B "$build" -G Ninja -DBOARD=nucleo_n657x0_q \
  -DCRYPTO_SOURCE="$crypto" -DCOMMON_MEAS="$COMMON" -DBENCH_LABEL="$label" \
  -DBENCH_SOURCE="$bench" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$build" -j 4
python3 -B "$TASK_ROOT/provenance.py" "$build" "$crypto"
