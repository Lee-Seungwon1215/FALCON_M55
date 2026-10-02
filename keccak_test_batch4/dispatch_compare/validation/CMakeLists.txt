cmake_minimum_required(VERSION 3.20.0)
get_filename_component(WORKSPACE "${CMAKE_CURRENT_SOURCE_DIR}/../../.." ABSOLUTE)
set(COMMON "${WORKSPACE}/fn-dsa_m55/measurement_mlkem_native")
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON}/app/generate_dtcm_linker.py"
 "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
 "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
execute_process(COMMAND ${Python3_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/pin_layout.py"
 "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(batch4_share_profile C ASM)
set(GEN "${CMAKE_CURRENT_BINARY_DIR}/generated")
execute_process(COMMAND ${Python3_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/generate.py"
 "${GEN}" "${MODE}" "${CANDIDATE}" COMMAND_ERROR_IS_FATAL ANY)
set(C_NAMES codec mq sha3 shake_batch4 shake_independent4 sysrng util kgen kgen_fxp
 kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 kgen_fft_mve kgen_fft_bridge
 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
set(S_NAMES codec_cm4 sha3_cm4 sha3x4_cm55 sign_fpr_cm4 sign_sampler_cm4 mq_cm55
 kgen_mp31_cm55 kgen_fft_cm55 sign_fft_cm55 sign_ldl_cm55 sign_split_merge_cm55)
foreach(n IN LISTS C_NAMES)
 if(n STREQUAL "shake_independent4")
  list(APPEND FILES "${GEN}/production/dispatch_candidate.c")
 else()
  list(APPEND FILES "${GEN}/production/${n}.c")
 endif()
endforeach()
foreach(n IN LISTS S_NAMES)
 list(APPEND FILES "${GEN}/production/${n}.s")
endforeach()
foreach(n kgen.c kgen_gauss.c sign.c sign_core.c sign_sampler.c sign_sampler_cm4.s shake_batch4.c shake_independent4.c vrfy.c)
 list(APPEND FILES "${GEN}/reference/${n}")
endforeach()
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
target_sources(app PRIVATE ${FILES} benchmark.c profile.c "${GEN}/probes.s"
 ${SHIM} "${COMMON}/app/dtcm_startup.s")
target_include_directories(app PRIVATE "${GEN}/production" "${CMAKE_CURRENT_SOURCE_DIR}")
target_include_directories(app PRIVATE "${WORKSPACE}/keccak_test_batch4/validation/build/fixtures")
if(BATCH4_PROFILE_OPERATION STREQUAL "keygen")
 target_compile_definitions(app PRIVATE PROFILE_KEYGEN=1)
else()
 target_compile_definitions(app PRIVATE PROFILE_KEYGEN=0)
endif()
target_compile_definitions(app PRIVATE PROFILE_MODE="${MODE}" CANDIDATE_NAME="${CANDIDATE}" DISPATCH_THRESHOLD=${THRESHOLD} printf=__wrap_printf
 fprintf=__wrap_fprintf puts=__wrap_puts putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf -Wl,--wrap=fprintf
 -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${FILES} benchmark.c profile.c "${GEN}/probes.s" ${SHIM}
 APPEND PROPERTY COMPILE_OPTIONS -O3 -mfpu=fpv5-d16 -ffp-contract=off
 -fno-fast-math -fno-strict-aliasing)
set_property(SOURCE profile.c APPEND PROPERTY COMPILE_OPTIONS -mgeneral-regs-only)
