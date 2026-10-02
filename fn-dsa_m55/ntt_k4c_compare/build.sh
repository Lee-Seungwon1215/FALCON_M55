#!/bin/bash
# Shared benchmark and layout; crypto sources are compiled in place.
set -euo pipefail
COMPARE_ROOT="$(cd "$(dirname "$0")" && pwd)"
M55_ROOT="$(cd "$COMPARE_ROOT/.." && pwd)"
case "${1:-}" in
  ref) SOURCE="$M55_ROOT/M55_ref"; MQ=mq_cm4; MP= ;;
  ntt_opt) SOURCE="$M55_ROOT/ntt_opt"; MQ=mq_cm55; MP=kgen_mp31_cm55 ;;
  *) echo 'usage: build.sh ref|ntt_opt' >&2; exit 2 ;;
esac
source "$M55_ROOT/measurement_mlkem_native/env/environment.sh"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
COMPARE_BUILD="$COMPARE_ROOT/build/$1"
mkdir -p "$COMPARE_BUILD"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
{
  cmake -S "$COMPARE_ROOT/app" -B "$COMPARE_BUILD" -G Ninja \
    -DBOARD=nucleo_n657x0_q -DFNDSA_SOURCE_DIR="$SOURCE" \
    -DFNDSA_MQ_ASM="$MQ" -DFNDSA_KGEN_MP31_ASM="$MP" \
    -DFNDSA_MP31_SELFTEST=OFF -DFNDSA_MP31_SIGNED_SELFTEST=OFF \
    -DCONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/prj.conf" \
    -DEXTRA_CONF_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.conf;$COMPARE_ROOT/app/fndsa.conf" \
    -DDTC_OVERLAY_FILE="$MLKEM_NATIVE_PINNED_ROOT/test/zephyr/app/nucleo_n657x0_q.overlay" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_C_FLAGS= -DCMAKE_CXX_FLAGS= -DCMAKE_ASM_FLAGS= -DCMAKE_EXE_LINKER_FLAGS=
  cmake --build "$COMPARE_BUILD" -j 4
  # Regenerable flat BIN spans a 512 MiB address gap; use the sparse ELF.
  cmake -E rm -f "$COMPARE_BUILD/zephyr/zephyr.bin"
} 2>&1 | tee "$COMPARE_BUILD/build-$STAMP.log"
python3 "$COMPARE_ROOT/run.py" "$1" record
