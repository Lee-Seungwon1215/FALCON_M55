cmake_minimum_required(VERSION 3.20.0)
get_filename_component(WORKSPACE "${CMAKE_CURRENT_SOURCE_DIR}/../../.." ABSOLUTE)
set(COMMON "${WORKSPACE}/fn-dsa_m55/measurement_mlkem_native")
set(CRYPTO "${WORKSPACE}/Final_code/Before_slothy")
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(sha3_function_profile C ASM)
set(GENERATED "${CMAKE_CURRENT_BINARY_DIR}/generated")
execute_process(COMMAND ${Python3_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/generate.py"
  "${GENERATED}" "${MODE}" COMMAND_ERROR_IS_FATAL ANY)
set(C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_ntru kgen_poly kgen_zint31 kgen_fft_mve kgen_fft_bridge
  sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
set(S_NAMES codec_cm4 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 mq_cm55
  kgen_mp31_cm55 kgen_fft_cm55 sign_fft_cm55 sign_ldl_cm55 sign_split_merge_cm55)
foreach(name IN LISTS C_NAMES)
  if(NOT MODE STREQUAL "control" AND name STREQUAL "sha3")
    list(APPEND CRYPTO_FILES "${GENERATED}/${name}.c")
  else()
    list(APPEND CRYPTO_FILES "${CRYPTO}/${name}.c")
  endif()
endforeach()
foreach(name IN LISTS S_NAMES)
  if(NOT MODE STREQUAL "control" AND name STREQUAL "sha3_cm4")
    list(APPEND CRYPTO_FILES "${GENERATED}/${name}.s")
  else()
    list(APPEND CRYPTO_FILES "${CRYPTO}/${name}.s")
  endif()
endforeach()
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
set(BENCH "${GENERATED}/benchmark.c" "${GENERATED}/probes.s"
  "${CMAKE_CURRENT_SOURCE_DIR}/profile.c")
target_sources(app PRIVATE ${CRYPTO_FILES} ${BENCH} ${SHIM} "${COMMON}/app/dtcm_startup.s")
target_include_directories(app PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}" "${CRYPTO}")
target_compile_definitions(app PRIVATE printf=__wrap_printf fprintf=__wrap_fprintf
  puts=__wrap_puts putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${CRYPTO_FILES} ${BENCH} ${SHIM} APPEND PROPERTY
  COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
# The private ASM helpers use FP registers as storage, outside the C ABI.
# The probe saves every GPR/APSR; its C bookkeeping MUST NOT touch FP/MVE.
set_property(SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/profile.c" APPEND PROPERTY
  COMPILE_OPTIONS -mgeneral-regs-only)
