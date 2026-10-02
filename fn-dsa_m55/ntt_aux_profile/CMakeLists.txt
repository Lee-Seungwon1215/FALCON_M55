cmake_minimum_required(VERSION 3.20.0)
find_package(Python3 REQUIRED COMPONENTS Interpreter)
if(NOT DEFINED FNDSA_SOURCE_DIR OR NOT DEFINED FNDSA_GENERATED_DIR OR
   NOT DEFINED FNDSA_COMMON_MEAS OR NOT DEFINED FNDSA_MQ_ASM OR
   NOT DEFINED PROFILE_CANDIDATE)
  message(FATAL_ERROR "profiling paths/candidate are required")
endif()

set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE}
  "${FNDSA_COMMON_MEAS}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fndsa_m55_ntt_aux_profile C ASM)

zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook
  -Wl,--wrap=printf -Wl,--wrap=fprintf
  -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)

set(FNDSA_C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss
  kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly
  sign_fpr sign_sampler vrfy)
set(FNDSA_S_NAMES codec_cm4 ${FNDSA_MQ_ASM} sha3_cm4 sign_fpr_cm4 sign_sampler_cm4)
if(DEFINED FNDSA_KGEN_MP31_ASM AND NOT FNDSA_KGEN_MP31_ASM STREQUAL "")
  list(APPEND FNDSA_S_NAMES ${FNDSA_KGEN_MP31_ASM})
endif()
set(FNDSA_SOURCES)
foreach(name IN LISTS FNDSA_C_NAMES)
  list(APPEND FNDSA_SOURCES "${FNDSA_GENERATED_DIR}/${name}.c")
endforeach()
foreach(name IN LISTS FNDSA_S_NAMES)
  list(APPEND FNDSA_SOURCES "${FNDSA_SOURCE_DIR}/${name}.s")
endforeach()

# Reuse the already audited deterministic workload, but copy it into this
# build directory so that its quoted profile.h include resolves to this
# stage profiler rather than the function profiler next to the source file.
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/../ntt_profile_compare/benchmark.c"
  "${CMAKE_CURRENT_BINARY_DIR}/benchmark.c" COPYONLY)
set(BENCHMARK_C "${CMAKE_CURRENT_BINARY_DIR}/benchmark.c")

if(PROFILE_CANDIDATE STREQUAL "detailed")
  target_sources(app PRIVATE wrappers.c)
  zephyr_link_libraries(-Wl,--wrap=fndsa_mqpoly_mul_ntt)
endif()

set(MLK_ROOT "$ENV{MLKEM_NATIVE_PINNED_ROOT}")
set(SHIM "${MLK_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
target_sources(app PRIVATE ${FNDSA_SOURCES} ${BENCHMARK_C} profile.c
  "${FNDSA_COMMON_MEAS}/app/dtcm_startup.s" ${SHIM})
target_include_directories(app PRIVATE "${FNDSA_GENERATED_DIR}"
  "${FNDSA_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_definitions(app PRIVATE FNDSA_ASM_CORTEXM4=1 FNDSA_ASM_CORTEXM55=1
  PROFILE_CANDIDATE="${PROFILE_CANDIDATE}"
  printf=__wrap_printf fprintf=__wrap_fprintf puts=__wrap_puts
  putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
if(DEFINED FNDSA_KGEN_MP31_ASM AND NOT FNDSA_KGEN_MP31_ASM STREQUAL "")
  target_compile_definitions(app PRIVATE FNDSA_MVE_MP31=1)
endif()
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS
  VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${FNDSA_SOURCES} ${BENCHMARK_C} profile.c ${SHIM}
  APPEND PROPERTY COMPILE_OPTIONS ${CONFIG_COMPILER_OPT})
