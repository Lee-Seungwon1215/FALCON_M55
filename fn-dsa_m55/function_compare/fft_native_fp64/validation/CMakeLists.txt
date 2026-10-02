cmake_minimum_required(VERSION 3.20.0)
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON_MEAS}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fndsa_isolated_fp64_audit C ASM)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
set(C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
set(S_NAMES codec_cm4 mq_cm55 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4 kgen_mp31_cm55)
set(CRYPTO_FILES)
foreach(name IN LISTS C_NAMES)
  if(BENCH_SOURCE STREQUAL "keyprofile.c" AND name STREQUAL "kgen_ntru")
    execute_process(COMMAND ${Python3_EXECUTABLE}
      "${CMAKE_CURRENT_SOURCE_DIR}/generate_approx_profile.py"
      "${CRYPTO_SOURCE}" "${CMAKE_CURRENT_BINARY_DIR}/generated"
      COMMAND_ERROR_IS_FATAL ANY)
    list(APPEND CRYPTO_FILES "${CMAKE_CURRENT_BINARY_DIR}/generated/kgen_ntru.c")
  else()
    list(APPEND CRYPTO_FILES "${CRYPTO_SOURCE}/${name}.c")
  endif()
endforeach()
foreach(name IN LISTS S_NAMES)
  list(APPEND CRYPTO_FILES "${CRYPTO_SOURCE}/${name}.s")
endforeach()
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
target_sources(app PRIVATE ${CRYPTO_FILES} ${BENCH_SOURCE}
  "${COMMON_MEAS}/app/dtcm_startup.s" "${SHIM}")
if(BENCH_SOURCE STREQUAL "keyprofile.c")
  target_sources(app PRIVATE approx_profile.c)
  set_property(SOURCE approx_profile.c APPEND PROPERTY
    COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
endif()
target_include_directories(app PRIVATE "${CRYPTO_SOURCE}" "${CMAKE_CURRENT_SOURCE_DIR}/generated" "${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_definitions(app PRIVATE FNDSA_ASM_CORTEXM4=1 FNDSA_ASM_CORTEXM55=1
  FNDSA_MVE_MP31=1 AUDIT_BOARD=1 printf=__wrap_printf fprintf=__wrap_fprintf
  puts=__wrap_puts putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${CRYPTO_FILES} ${BENCH_SOURCE} ${SHIM} APPEND PROPERTY
  COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
