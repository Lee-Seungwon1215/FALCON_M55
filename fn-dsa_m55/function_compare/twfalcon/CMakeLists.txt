cmake_minimum_required(VERSION 3.20.0)
find_package(Python3 REQUIRED COMPONENTS Interpreter)

set(COMMON_MEAS "${CMAKE_CURRENT_SOURCE_DIR}/../../measurement_mlkem_native")
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/twfalcon_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE}
  "${COMMON_MEAS}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fndsa_twfalcon_compare C ASM)

set(UPSTREAM "${CMAKE_CURRENT_SOURCE_DIR}/reference/upstream/c-fn-dsa-multiple")
set(SOURCES
  reference/gm_q32.c reference/fixed_fft.c
  ${UPSTREAM}/triple_float.c
  tw32_scalar/fft_tw32_scalar.c
  tw32_mve/fft_tw32_mve.c tw32_mve/tw32_primitives_cm55.s
  tests/ds32_stage7_oracle.s tests/ds32_span_check.c
  tests/ds32_stage8_oracle.s
  tests/ds32_stage7_transform.c
  tests/ds32_layer_profile.c tests/ds32_layer_measure.c
  tests/ds32_tail_check.c
  bench/board_main.c
  ${COMMON_MEAS}/app/dtcm_startup.s
  $ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c)

target_sources(app PRIVATE ${SOURCES})
target_include_directories(app PRIVATE bench ${UPSTREAM})
target_compile_definitions(app PRIVATE fmaf=__builtin_fmaf
  isnanf=__builtin_isnan isinff=__builtin_isinf
  printf=__wrap_printf fprintf=__wrap_fprintf puts=__wrap_puts
  putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS
  VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar
  -Wl,--wrap=fflush -Wl,--wrap=exit)
set_property(SOURCE ${SOURCES} APPEND PROPERTY COMPILE_OPTIONS
  -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math
  -fno-strict-aliasing -fno-reorder-functions)
