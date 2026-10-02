#!/bin/bash
# Builds the upstream-pinned debugger into a separate prefix. No board access.
set -euo pipefail
source /Users/seungwon/FALCON/fn-dsa_m55/measurement_mlkem_native/env/environment.sh
export PATH="/private/tmp/falcon-tools/bin:$PATH"
export PKG_CONFIG_PATH=/private/tmp/falcon-tools/lib/pkgconfig
export CPPFLAGS=-I/private/tmp/falcon-tools/include
export LDFLAGS=-L/private/tmp/falcon-tools/lib
cd "$FNDSA_M55_ENV/openocd-4e9b167-src"
./bootstrap nosubmodule
mkdir -p "$FNDSA_M55_ENV/openocd-4e9b167-build"
cd "$FNDSA_M55_ENV/openocd-4e9b167-build"
"$FNDSA_M55_ENV/openocd-4e9b167-src/configure" \
  --prefix="$FNDSA_M55_ENV/openocd-4e9b167" \
  --enable-stlink --enable-internal-jimtcl --enable-internal-libjaylink \
  --disable-werror --disable-doxygen-html --disable-doxygen-pdf \
  --disable-shared --enable-static
make -j4
make install
"$FNDSA_M55_ENV/openocd-4e9b167/bin/openocd" --version
