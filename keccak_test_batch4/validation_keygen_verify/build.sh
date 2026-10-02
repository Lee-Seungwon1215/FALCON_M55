#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
COMMON="$ROOT/fn-dsa_m55/measurement_mlkem_native"
source "$COMMON/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
mkdir -p "$HERE/build/fixtures"
python "$HERE/prepare_reference.py"
if [[ ! -f "$HERE/build/fixtures/expected.h" || "$HERE/host_vectors.c" -nt "$HERE/build/fixtures/expected.h" || "$HERE/inputs.h" -nt "$HERE/build/fixtures/expected.h" ]]; then
 crypto_names=(codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
 crypto_files=()
 for n in "${crypto_names[@]}"; do crypto_files+=("$ROOT/fn-dsa_ref/$n.c"); done
 clang -O2 -ffp-contract=off -I"$ROOT/fn-dsa_ref" "$HERE/host_vectors.c" "${crypto_files[@]}" -o "$HERE/build/fixtures/host_vectors"
 "$HERE/build/fixtures/host_vectors" "$HERE/build/fixtures/expected.h"
fi
cmake -S "$HERE" -B "$HERE/build/board" -G Ninja \
 -DBOARD=nucleo_n657x0_q \
 -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
 -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMMON/app/fndsa.conf;$HERE/test.conf" \
 -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$HERE/build/board" -j4
# Upstream STM32N6 Kconfig forces flat BIN generation (512-MiB address gap).
# The loader uses ELF; discard only this reproducible, unused build artifact.
rm -f "$HERE/build/board/zephyr/zephyr.bin"
