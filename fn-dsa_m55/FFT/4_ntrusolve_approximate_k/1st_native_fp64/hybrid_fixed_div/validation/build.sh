#!/bin/bash
set -euo pipefail
TASK_ROOT="$(cd "$(dirname "$0")" && pwd)"
M55_ROOT="$(cd "$TASK_ROOT/../../../../.." && pwd)"
COMMON="$M55_ROOT/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
label="${1:?ref-perf|hybrid-perf|ref-profile|hybrid-profile|kernels|kat}"
case "$label" in
  ref-perf|ref-profile) crypto="$(cd "$TASK_ROOT/../../../ref" && pwd)" ;;
  hybrid-perf|hybrid-profile|kernels|kat) crypto="$(cd "$TASK_ROOT/.." && pwd)" ;;
  *) exit 2 ;;
esac
mode="${label#*-}"
bench=benchmark.c
if [[ "$label" == kernels ]]; then mode=perf; bench=kernel_bench.c; fi
if [[ "$label" == kat ]]; then mode=perf; bench=board_kat.c; fi
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
