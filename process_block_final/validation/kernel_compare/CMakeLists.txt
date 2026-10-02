cmake_minimum_required(VERSION 3.20.0)
get_filename_component(WORKSPACE "${CMAKE_CURRENT_SOURCE_DIR}/../../.." ABSOLUTE)
set(COMMON "${WORKSPACE}/fn-dsa_m55/measurement_mlkem_native")
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
# This affects only incidental BIN/HEX byproducts; measurements load full ELF.
set_property(TARGET bintools APPEND PROPERTY elfconvert_flag
  --only-section=rom_start --only-section=text)
project(keccak_integrated_compare C ASM)
set(GENERATED "${CMAKE_CURRENT_BINARY_DIR}/generated")
execute_process(COMMAND ${Python3_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/generate.py"
  "${GENERATED}" "${VARIANT}" COMMAND_ERROR_IS_FATAL ANY)
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
set(BENCH "${GENERATED}/sha3_benchmark.s" "${GENERATED}/benchmark.c")
target_sources(app PRIVATE ${BENCH} ${SHIM} "${COMMON}/app/dtcm_startup.s")
target_include_directories(app PRIVATE "${GENERATED}")
target_compile_definitions(app PRIVATE printf=__wrap_printf fprintf=__wrap_fprintf
  puts=__wrap_puts putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${BENCH} ${SHIM} APPEND PROPERTY COMPILE_OPTIONS
  -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
