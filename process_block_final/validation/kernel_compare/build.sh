#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
COMMON="$(cd "$HERE/../../../fn-dsa_m55/measurement_mlkem_native" && pwd)"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
variant="${1:?ref|mve with -plain|-aligned|-iota|-tail|-core}"
case "$variant" in ref-plain|mve-plain|ref-aligned|mve-aligned|ref-iota|mve-iota|ref-tail|mve-tail|ref-core|mve-core) ;; *) exit 2;; esac
cmake --fresh -S "$HERE" -B "$HERE/build/$variant" -G Ninja \
  -DBOARD=nucleo_n657x0_q -DVARIANT="$variant" \
  -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
  -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf;$HERE/../elf_only.conf" \
  -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/$variant" -j4
