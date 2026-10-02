#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
COMMON="$(cd "$HERE/../../fn-dsa_m55/measurement_mlkem_native" && pwd)"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
mode="${1:?ntt|kat|extra|sigkat|api|keygen|sign_profile|sign_control|sign_detail}"
case "$mode" in ntt|kat|extra|sigkat|api|keygen|sign_profile|sign_control|sign_detail) ;; *) exit 2;; esac
cmake --fresh -S "$HERE" -B "$HERE/build/$mode" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DMODE="$mode" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/$mode" -j4
