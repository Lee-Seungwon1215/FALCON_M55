cmake_minimum_required(VERSION 3.20.0)
get_filename_component(WORKSPACE "${CMAKE_CURRENT_SOURCE_DIR}/../.." ABSOLUTE)
set(COMMON "${WORKSPACE}/fn-dsa_m55/measurement_mlkem_native")
set(FIXTURES "${WORKSPACE}/fn-dsa_m55/sep_27_ntrusolve_fft/validation")
set(CRYPTO "${CMAKE_CURRENT_SOURCE_DIR}/../Before_slothy")
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(final_before_slothy_validation C ASM)

# Fixed local cryptographic implementation. External files below are only
# benchmark fixtures and the established board startup/measurement support.
set(C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_ntru kgen_poly kgen_zint31 kgen_fft_mve kgen_fft_bridge
  sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
set(S_NAMES codec_cm4 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4
  mq_cm55 kgen_mp31_cm55 kgen_fft_cm55 sign_fft_cm55)
if(MODE STREQUAL "sign_profile" OR MODE STREQUAL "sign_control" OR MODE STREQUAL "sign_detail")
  set(SIGN_PROFILE_DIR "${CMAKE_CURRENT_BINARY_DIR}/sign_generated")
  execute_process(COMMAND ${Python3_EXECUTABLE}
    "${CMAKE_CURRENT_SOURCE_DIR}/sign_profile/generate.py" "${SIGN_PROFILE_DIR}" "${MODE}"
    COMMAND_ERROR_IS_FATAL ANY)
endif()
foreach(name IN LISTS C_NAMES)
  if(DEFINED SIGN_PROFILE_DIR AND name MATCHES "^(sign|sign_core|sign_sampler|sign_fpoly)$")
    list(APPEND CRYPTO_FILES "${SIGN_PROFILE_DIR}/${name}.c")
  else()
    list(APPEND CRYPTO_FILES "${CRYPTO}/${name}.c")
  endif()
endforeach()
foreach(name IN LISTS S_NAMES)
  list(APPEND CRYPTO_FILES "${CRYPTO}/${name}.s")
endforeach()
if(MODE STREQUAL "ntt")
  set(BENCH "${CMAKE_CURRENT_SOURCE_DIR}/ntt_audit.c")
elseif(MODE STREQUAL "kat")
  set(BENCH "${FIXTURES}/board_kat.c")
elseif(MODE STREQUAL "extra")
  set(BENCH "${FIXTURES}/board_extra_kat.c")
elseif(MODE STREQUAL "sigkat")
  set(BENCH "${FIXTURES}/board_signkat.c")
elseif(MODE STREQUAL "api")
  set(BENCH "${FIXTURES}/security/api_audit.c")
elseif(MODE STREQUAL "keygen")
  set(BENCH "${FIXTURES}/board_keygen_perf.c")
elseif(DEFINED SIGN_PROFILE_DIR)
  set(BENCH "${SIGN_PROFILE_DIR}/benchmark.c" "${SIGN_PROFILE_DIR}/profile.c")
  if(MODE STREQUAL "sign_profile" OR MODE STREQUAL "sign_detail")
    list(APPEND BENCH "${SIGN_PROFILE_DIR}/fft_probes.c")
  endif()
  target_include_directories(app PRIVATE "${SIGN_PROFILE_DIR}")
else()
  message(FATAL_ERROR "Unknown validation MODE: ${MODE}")
endif()
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
target_sources(app PRIVATE ${CRYPTO_FILES} ${BENCH} ${SHIM} "${COMMON}/app/dtcm_startup.s")
target_include_directories(app PRIVATE "${CRYPTO}" "${FIXTURES}" "${FIXTURES}/generated")
target_compile_definitions(app PRIVATE AUDIT_BOARD=1 printf=__wrap_printf
  fprintf=__wrap_fprintf puts=__wrap_puts putchar=__wrap_putchar
  fflush=__wrap_fflush exit=__wrap_exit)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${CRYPTO_FILES} ${BENCH} ${SHIM} APPEND PROPERTY
  COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
