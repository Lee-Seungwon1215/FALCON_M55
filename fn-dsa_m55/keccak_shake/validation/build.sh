#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
COMMON="$(cd "$HERE/../../../fn-dsa_m55/measurement_mlkem_native" && pwd)"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
variant="${1:?ref|mve}"
case "$variant" in ref|mve) ;; *) exit 2;; esac
mode="${3:-kernel}"
suffix="$variant"
if [[ "$mode" != kernel ]]; then suffix="${variant}_${mode}"; fi
cmake --fresh -S "$HERE" -B "$HERE/build/$suffix" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DVARIANT="$variant" -DMODE="$mode" -DDIAGNOSTIC_ROUNDS="${2:-24}" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/$suffix" -j4
python "$HERE/audit.py" "$variant" "$mode"
