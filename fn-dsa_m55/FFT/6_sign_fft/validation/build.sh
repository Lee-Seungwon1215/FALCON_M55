#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
COMMON="$(cd "$HERE/../../../measurement_mlkem_native" && pwd)"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
mode="${1:?sign_detail|sign_control|ldl|kernel|sign|sign_native|sigkat|kat|extra|api}"
variant="${2:-candidate}"
case "$mode" in poly|sign_detail|sign_control|ldl|kernel|sign|sign_native|sigkat|kat|extra|api) ;; *) exit 2;; esac
original=OFF
case "$variant" in candidate) baseline=OFF;; baseline) baseline=ON;; original) baseline=OFF; original=ON;; *) exit 2;; esac
cmake --fresh -S "$HERE" -B "$HERE/build/${variant}_${mode}" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DMODE="$mode" -DBASELINE="$baseline" -DORIGINAL="$original" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/${variant}_${mode}" -j4
