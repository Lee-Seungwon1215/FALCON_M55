#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
COMMON="$ROOT/fn-dsa_m55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
candidate="${1:?ref|batch4|single_mve}"
case "$candidate" in ref|batch4|single_mve) ;; *) exit 2;; esac
mkdir -p "$HERE/build/fixtures"
if [[ ! -f "$HERE/build/fixtures/expected.h" ]]; then
 crypto_names=(codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
 crypto_files=()
 for n in "${crypto_names[@]}"; do crypto_files+=("$ROOT/fn-dsa_ref/$n.c"); done
 clang -O2 -ffp-contract=off -I"$ROOT/fn-dsa_ref" "$HERE/host_vectors.c" "${crypto_files[@]}" -o "$HERE/build/fixtures/host_vectors"
 "$HERE/build/fixtures/host_vectors" "$HERE/build/fixtures/expected.h"
fi
cmake -S "$HERE" -B "$HERE/build/$candidate" -G Ninja \
 -DBOARD=nucleo_n657x0_q -DCANDIDATE="$candidate" \
 -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
 -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf" \
 -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/$candidate" -j4
# Only remove this reproducible flat binary (512 MiB address gap); use ELF.
rm -f "$HERE/build/$candidate/zephyr/zephyr.bin"
