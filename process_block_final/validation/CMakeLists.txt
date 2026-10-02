cmake_minimum_required(VERSION 3.20.0)
get_filename_component(WORKSPACE "${CMAKE_CURRENT_SOURCE_DIR}/../.." ABSOLUTE)
set(COMMON "${WORKSPACE}/fn-dsa_m55/measurement_mlkem_native")
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
# STM32N6 forces flat BIN generation. Keep that unused byproduct ITCM-only
# so the 0x10000000 -> 0x30000000 address gap does not consume 512 MiB.
# The debugger uses the complete ELF, including every DTCM section.
set_property(TARGET bintools APPEND PROPERTY elfconvert_flag
  --only-section=rom_start --only-section=text)
project(keccak_kernel_baseline C ASM)
set(GENERATED "${CMAKE_CURRENT_BINARY_DIR}/generated")
execute_process(COMMAND ${Python3_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/generate.py"
  "${GENERATED}" "${VARIANT}" "${DIAGNOSTIC_ROUNDS}" COMMAND_ERROR_IS_FATAL ANY)
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
set(BENCH "${GENERATED}/sha3_benchmark.s" "${GENERATED}/benchmark.c")
if(MODE AND NOT MODE STREQUAL "kernel")
  set(CRYPTO "${CMAKE_CURRENT_SOURCE_DIR}/..")
  set(FIXTURES "${WORKSPACE}/fn-dsa_m55/sep_27_ntrusolve_fft/validation")
  set(C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
    kgen_ntru kgen_poly kgen_zint31 kgen_fft_mve kgen_fft_bridge
    sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
  set(S_NAMES codec_cm4 sign_fpr_cm4 sign_sampler_cm4 mq_cm55 kgen_mp31_cm55
    kgen_fft_cm55 sign_fft_cm55 sign_ldl_cm55 sign_split_merge_cm55)
  if(VARIANT STREQUAL "mve")
    list(APPEND S_NAMES sha3_cm55)
  else()
    list(APPEND S_NAMES sha3_cm4)
  endif()
  foreach(name IN LISTS C_NAMES)
    list(APPEND CRYPTO_FILES "${CRYPTO}/${name}.c")
  endforeach()
  foreach(name IN LISTS S_NAMES)
    list(APPEND CRYPTO_FILES "${CRYPTO}/${name}.s")
  endforeach()
  if(MODE STREQUAL "kat")
    set(BENCH ${CRYPTO_FILES} "${FIXTURES}/board_kat.c")
  elseif(MODE STREQUAL "sigkat")
    set(BENCH ${CRYPTO_FILES} "${FIXTURES}/board_signkat.c")
  elseif(MODE STREQUAL "api")
    set(BENCH ${CRYPTO_FILES} "${FIXTURES}/security/api_audit.c")
  else()
    message(FATAL_ERROR "Unknown validation mode")
  endif()
  target_include_directories(app PRIVATE "${CRYPTO}" "${FIXTURES}/generated")
  target_compile_definitions(app PRIVATE AUDIT_BOARD=1)
endif()
target_sources(app PRIVATE ${BENCH} ${SHIM} "${COMMON}/app/dtcm_startup.s")
target_include_directories(app PRIVATE "${GENERATED}")
target_compile_definitions(app PRIVATE printf=__wrap_printf fprintf=__wrap_fprintf
  puts=__wrap_puts putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${BENCH} ${SHIM} APPEND PROPERTY COMPILE_OPTIONS
  -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
