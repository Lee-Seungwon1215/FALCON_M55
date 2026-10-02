cmake_minimum_required(VERSION 3.20.0)
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON_MEAS}/app/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(sep27_ntru_fft C ASM)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf
  -Wl,--wrap=fprintf -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
set(C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss kgen_mp31
  kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
set(S_NAMES codec_cm4 sha3_cm4 sign_fpr_cm4 sign_sampler_cm4)
# Every optional file is in this source tree, never a different candidate.
foreach(name kgen_fft_mve kgen_fft_bridge)
  if(EXISTS "${CRYPTO_SOURCE}/${name}.c")
    list(APPEND C_NAMES ${name})
  endif()
endforeach()
foreach(name mq_cm4 mq_cm55 kgen_mp31_cm55 kgen_fft_cm55)
  if(EXISTS "${CRYPTO_SOURCE}/${name}.s")
    list(APPEND S_NAMES ${name})
  endif()
endforeach()
set(BENCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${BENCH_SOURCE}")
if(BENCH_SOURCE STREQUAL "integration_bench.c" OR BENCH_SOURCE STREQUAL "integration_probe.c")
  execute_process(COMMAND ${Python3_EXECUTABLE}
    "${CMAKE_CURRENT_SOURCE_DIR}/generate_integration_profile.py"
    "${CRYPTO_SOURCE}" "${CMAKE_CURRENT_BINARY_DIR}/generated" integer
    COMMAND_ERROR_IS_FATAL ANY)
  set(BENCH_FILE "${CMAKE_CURRENT_BINARY_DIR}/generated/integration_bench.c")
  if(BENCH_SOURCE STREQUAL "integration_probe.c")
    execute_process(COMMAND ${Python3_EXECUTABLE}
      "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/generate_probe.py"
      "${CMAKE_CURRENT_BINARY_DIR}/generated" COMMAND_ERROR_IS_FATAL ANY)
  endif()
endif()
set(CRYPTO_FILES)
if(BENCH_SOURCE STREQUAL "twiddle/replay_bench.c")
  execute_process(COMMAND ${Python3_EXECUTABLE}
    "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/generate_replay.py"
    "${CRYPTO_SOURCE}" "${CMAKE_CURRENT_BINARY_DIR}/generated"
    COMMAND_ERROR_IS_FATAL ANY)
  set(BENCH_FILE "${CMAKE_CURRENT_BINARY_DIR}/generated/replay_bench.c")
endif()
foreach(name IN LISTS C_NAMES)
  if((BENCH_SOURCE STREQUAL "integration_bench.c" OR BENCH_SOURCE STREQUAL "integration_probe.c") AND (name STREQUAL "kgen" OR name STREQUAL "kgen_ntru"))
    list(APPEND CRYPTO_FILES "${CMAKE_CURRENT_BINARY_DIR}/generated/${name}.c")
  elseif(BENCH_SOURCE STREQUAL "twiddle/replay_bench.c" AND name STREQUAL "kgen_ntru")
    list(APPEND CRYPTO_FILES "${CMAKE_CURRENT_BINARY_DIR}/generated/${name}.c")
  else()
    list(APPEND CRYPTO_FILES "${CRYPTO_SOURCE}/${name}.c")
  endif()
endforeach()
foreach(name IN LISTS S_NAMES)
  list(APPEND CRYPTO_FILES "${CRYPTO_SOURCE}/${name}.s")
endforeach()
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
set(TEST_FILES ${BENCH_FILE})
if(BENCH_SOURCE STREQUAL "integration_bench.c" OR BENCH_SOURCE STREQUAL "integration_probe.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/integration_profile.c")
endif()
if(BENCH_SOURCE STREQUAL "integration_probe.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_BINARY_DIR}/generated/profile_probe.c")
endif()
if(BENCH_SOURCE STREQUAL "arithmetic/board.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/arithmetic/initial.c")
endif()
if(BENCH_SOURCE STREQUAL "twiddle/board.c")
  # Isolated experimental helper, NOT a production backend selector.
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/trial.s")
endif()
if(BENCH_SOURCE STREQUAL "twiddle/fft_board.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/trial.s"
    "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/fft_trial.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/fft_vector_trial.c")
endif()
if(BENCH_SOURCE STREQUAL "twiddle/alignment_board.c" OR BENCH_SOURCE STREQUAL "twiddle/context_board.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/alignment.s")
endif()
if(BENCH_SOURCE STREQUAL "twiddle/placement_board.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/placement_helpers.s")
endif()
if(BENCH_SOURCE STREQUAL "twiddle/replay_bench.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/replay.c")
endif()
if(BENCH_SOURCE STREQUAL "twiddle/fusion_board.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/fused_trial.s"
    "${CMAKE_CURRENT_SOURCE_DIR}/twiddle/fused_fft.c")
endif()
if(BENCH_SOURCE STREQUAL "fixed_input/pair_board.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/fixed_input/pair_trial.s")
endif()
if(BENCH_SOURCE STREQUAL "fixed_input/predicate_board.c")
  list(APPEND TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/fixed_input/predicate_trial.s")
endif()
target_sources(app PRIVATE ${CRYPTO_FILES} ${TEST_FILES} ${SHIM}
  "${COMMON_MEAS}/app/dtcm_startup.s")
target_include_directories(app PRIVATE "${CRYPTO_SOURCE}" "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/generated")
target_compile_definitions(app PRIVATE FNDSA_ASM_CORTEXM4=1 FNDSA_ASM_CORTEXM55=1
  FNDSA_MVE_MP31=1 AUDIT_BOARD=1 printf=__wrap_printf fprintf=__wrap_fprintf
  puts=__wrap_puts putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${CRYPTO_FILES} ${TEST_FILES} ${SHIM} APPEND PROPERTY
  COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
