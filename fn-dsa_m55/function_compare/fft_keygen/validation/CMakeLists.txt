cmake_minimum_required(VERSION 3.20.0)

find_package(Python3 REQUIRED COMPONENTS Interpreter)

set(KEYGEN_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.." CACHE PATH
  "FN-DSA source tree under test")
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE}
  "${COMMON_MEAS}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fndsa_fft_keygen_fp64_validation C ASM)

zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar
  -Wl,--wrap=fflush -Wl,--wrap=exit)

set(C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr
  sign_sampler vrfy)
set(FNDSA_MQ_ASM "mq_cm55" CACHE STRING
  "Assembly source basename that implements the mod-q routines")
set(FNDSA_KGEN_MP31_ASM "kgen_mp31_cm55" CACHE STRING
  "Optional assembly source basename that implements mp_NTT/mp_iNTT")
set(BENCH_SOURCE "board_kernels.c" CACHE STRING
  "Validation or benchmark source in this directory")
get_filename_component(BENCH_SOURCE_DIR "${BENCH_SOURCE}" DIRECTORY)
set(S_NAMES codec_cm4 ${FNDSA_MQ_ASM} sha3_cm4 sign_fpr_cm4 sign_sampler_cm4)
if(FNDSA_KGEN_MP31_ASM)
  list(APPEND S_NAMES ${FNDSA_KGEN_MP31_ASM})
endif()

set(CRYPTO_FILES)
foreach(name IN LISTS C_NAMES)
  list(APPEND CRYPTO_FILES "${KEYGEN_ROOT}/${name}.c")
endforeach()
foreach(name IN LISTS S_NAMES)
  list(APPEND CRYPTO_FILES "${KEYGEN_ROOT}/${name}.s")
endforeach()

set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
target_sources(app PRIVATE ${CRYPTO_FILES} ${BENCH_SOURCE}
  "${COMMON_MEAS}/app/dtcm_startup.s" "${SHIM}")
target_include_directories(app PRIVATE "${KEYGEN_ROOT}"
  "${BENCH_SOURCE_DIR}" "${BENCH_SOURCE_DIR}/generated")
target_compile_definitions(app PRIVATE FNDSA_ASM_CORTEXM4=1
  FNDSA_ASM_CORTEXM55=1 printf=__wrap_printf
  fprintf=__wrap_fprintf puts=__wrap_puts putchar=__wrap_putchar
  fflush=__wrap_fflush exit=__wrap_exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS
  VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
if(FNDSA_KGEN_MP31_ASM)
  target_compile_definitions(app PRIVATE FNDSA_MVE_MP31=1)
endif()
set_property(SOURCE ${CRYPTO_FILES} ${BENCH_SOURCE} ${SHIM} APPEND PROPERTY
  COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math
  -fno-strict-aliasing)
