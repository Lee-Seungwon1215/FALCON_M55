#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
COMMON="$ROOT/fn-dsa_m55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
op="${1:?keygen|sign}"
mode="${2:?control|profile}"
case "$op" in keygen|sign) ;; *) exit 2;; esac
case "$mode" in control|profile) ;; *) exit 2;; esac
cmake -S "$HERE" -B "$HERE/build/${op}_${mode}" -G Ninja \
 -DBOARD=nucleo_n657x0_q -DMODE="$mode" -DBATCH4_PROFILE_OPERATION="$op" \
 -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
 -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf;$HERE/test.conf" \
 -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/${op}_${mode}" -j4
# Only this reproducible flat BIN is unused; preserve ELF/map and all results.
rm -f "$HERE/build/${op}_${mode}/zephyr/zephyr.bin"
