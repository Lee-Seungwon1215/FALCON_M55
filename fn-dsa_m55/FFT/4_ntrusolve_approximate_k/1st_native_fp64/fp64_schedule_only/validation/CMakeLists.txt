cmake_minimum_required(VERSION 3.20.0)
find_package(Python3 REQUIRED COMPONENTS Interpreter)
if(NOT DEFINED CRYPTO_SOURCE OR NOT DEFINED COMMON_MEAS OR NOT DEFINED BENCH_LABEL)
  message(FATAL_ERROR "Explicit source, common platform and label required")
endif()
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON_MEAS}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fndsa_stage4_fp64 C ASM)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
set(C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
if(BENCH_SOURCE STREQUAL "kernel_bench.c")
  # The diagnostic includes this candidate's source to access its private
  # divider. This does not select or import another candidate's arithmetic.
  list(REMOVE_ITEM C_NAMES kgen_fxp)
endif()
set(S_NAMES codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 kgen_mp31_cm55)
if(EXISTS "${CRYPTO_SOURCE}/kgen_fp64_cm55.s")
  list(APPEND S_NAMES kgen_fp64_cm55)
endif()
set(CRYPTO_FILES)
foreach(name IN LISTS C_NAMES)
  list(APPEND CRYPTO_FILES "${CRYPTO_SOURCE}/${name}.c")
endforeach()
foreach(name IN LISTS S_NAMES)
  list(APPEND CRYPTO_FILES "${CRYPTO_SOURCE}/${name}.s")
endforeach()
list(APPEND CRYPTO_FILES "${CMAKE_CURRENT_BINARY_DIR}/generated/kgen_ntru.c")
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
if(NOT DEFINED BENCH_SOURCE)
  set(BENCH_SOURCE benchmark.c)
endif()
target_sources(app PRIVATE ${CRYPTO_FILES} ${BENCH_SOURCE} measure.c
  "${COMMON_MEAS}/app/dtcm_startup.s" "${SHIM}")
target_include_directories(app PRIVATE "${CRYPTO_SOURCE}" "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/generated")
target_compile_definitions(app PRIVATE FNDSA_ASM_CORTEXM4=1 FNDSA_ASM_CORTEXM55=1
  FNDSA_MVE_MP31=1 BENCH_LABEL="${BENCH_LABEL}" printf=__wrap_printf
  fprintf=__wrap_fprintf puts=__wrap_puts putchar=__wrap_putchar
  fflush=__wrap_fflush exit=__wrap_exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
# Both candidates use the SAME hardware-enabling flags. No algorithm selection.
set_property(SOURCE ${CRYPTO_FILES} ${BENCH_SOURCE} measure.c ${SHIM} APPEND PROPERTY
  COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing -fstack-usage)
