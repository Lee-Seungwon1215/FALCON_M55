#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
COMMON="$ROOT/fn-dsa_m55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
candidate="${1:?ref|serial|mlkem|vecfalcon|hybrid}"
case "$candidate" in ref|serial|mlkem|vecfalcon|hybrid) ;; *) exit 2;; esac
mkdir -p "$HERE/build/fixtures"
clang -O2 -I"$ROOT/fn-dsa_ref" "$HERE/make_keys.c" \
 "$ROOT/fn-dsa_ref/codec.c" "$ROOT/fn-dsa_ref/mq.c" "$ROOT/fn-dsa_ref/sha3.c" \
 "$ROOT/fn-dsa_ref/sysrng.c" "$ROOT/fn-dsa_ref/util.c" \
 "$ROOT/fn-dsa_ref/kgen.c" "$ROOT/fn-dsa_ref/kgen_fxp.c" "$ROOT/fn-dsa_ref/kgen_gauss.c" \
 "$ROOT/fn-dsa_ref/kgen_mp31.c" "$ROOT/fn-dsa_ref/kgen_ntru.c" "$ROOT/fn-dsa_ref/kgen_poly.c" \
 "$ROOT/fn-dsa_ref/kgen_zint31.c" -o "$HERE/build/fixtures/make_keys"
"$HERE/build/fixtures/make_keys" "$HERE/build/fixtures/keys.h"
cmake -S "$HERE" -B "$HERE/build/$candidate" -G Ninja \
 -DBOARD=nucleo_n657x0_q -DCANDIDATE="$candidate" \
 -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
 -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
 -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/$candidate" -j4
# STM32N6 Kconfig forces BIN output. It spans the 512-MiB ITCM/DTCM gap;
# the board runner uses ELF only. Remove only this regenerated build artifact.
rm -f "$HERE/build/$candidate/zephyr/zephyr.bin"
