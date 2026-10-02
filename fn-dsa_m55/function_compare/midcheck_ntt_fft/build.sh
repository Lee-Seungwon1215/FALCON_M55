#!/bin/bash
set -euo pipefail
MID_ROOT="$(cd "$(dirname "$0")" && pwd)"
COMMON="$(cd "$MID_ROOT/../../measurement_mlkem_native" && pwd)"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
variant="${1:?ref|ntt|full}"
mode="${2:-perf}"
cmake --fresh -S "$MID_ROOT" -B "$MID_ROOT/build/${variant}_${mode}" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DVARIANT="$variant" -DMODE="$mode" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$MID_ROOT/build/${variant}_${mode}" -j4
