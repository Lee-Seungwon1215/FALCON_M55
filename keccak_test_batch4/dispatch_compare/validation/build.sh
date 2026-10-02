#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
COMMON="$ROOT/fn-dsa_m55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
candidate="${1:?A_four_only|B_three_plus|C_two_plus}"
op="${2:?keygen|sign}"
mode="${3:?control|profile}"
case "$candidate" in A_four_only) threshold=4;; B_three_plus) threshold=3;; C_two_plus) threshold=2;; *) exit 2;; esac
case "$op" in keygen|sign) ;; *) exit 2;; esac
case "$mode" in control|profile) ;; *) exit 2;; esac
cmake -S "$HERE" -B "$HERE/build/${candidate}_${op}_${mode}_pinned" -G Ninja \
 -DBOARD=nucleo_n657x0_q -DMODE="$mode" -DBATCH4_PROFILE_OPERATION="$op" -DCANDIDATE="$candidate" -DTHRESHOLD="$threshold" \
 -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
 -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf;$HERE/test.conf" \
 -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/${candidate}_${op}_${mode}_pinned" -j4
# Only this reproducible flat BIN is unused; preserve ELF/map and all results.
rm -f "$HERE/build/${candidate}_${op}_${mode}_pinned/zephyr/zephyr.bin"
