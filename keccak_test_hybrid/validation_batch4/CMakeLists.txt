cmake_minimum_required(VERSION 3.20.0)
get_filename_component(WORKSPACE "${CMAKE_CURRENT_SOURCE_DIR}/../.." ABSOLUTE)
set(COMMON "${WORKSPACE}/fn-dsa_m55/measurement_mlkem_native")
set(CRYPTO "${WORKSPACE}/keccak_test_hybrid")
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${COMMON}/app/generate_dtcm_linker.py"
 "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
 "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(hybrid_keygen_verify_batch4 C ASM)
set(C_NAMES codec mq sha3 sha3x4 shake_independent4 sysrng util kgen kgen_fxp
 kgen_gauss kgen_mp31 kgen_ntru kgen_poly kgen_zint31 kgen_fft_mve kgen_fft_bridge
 sign sign_core sign_fpoly sign_fpr sign_sampler vrfy)
set(S_NAMES codec_cm4 sha3_cm4 sha3x4_cm55 sign_fpr_cm4 sign_sampler_cm4 mq_cm55
 kgen_mp31_cm55 kgen_fft_cm55 sign_fft_cm55 sign_ldl_cm55 sign_split_merge_cm55)
foreach(n IN LISTS C_NAMES)
 list(APPEND FILES "${CRYPTO}/${n}.c")
endforeach()
foreach(n IN LISTS S_NAMES)
 list(APPEND FILES "${CRYPTO}/${n}.s")
endforeach()
list(APPEND FILES "${CMAKE_CURRENT_SOURCE_DIR}/build/reference/kgen.c"
 "${CMAKE_CURRENT_SOURCE_DIR}/build/reference/vrfy.c")
set(SHIM "$ENV{MLKEM_NATIVE_PINNED_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
target_sources(app PRIVATE ${FILES} benchmark.c ${SHIM} "${COMMON}/app/dtcm_startup.s")
target_include_directories(app PRIVATE "${CRYPTO}" "${CMAKE_CURRENT_SOURCE_DIR}/build/fixtures")
target_compile_definitions(app PRIVATE printf=__wrap_printf fprintf=__wrap_fprintf
 puts=__wrap_puts putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf -Wl,--wrap=fprintf
 -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
set_property(SOURCE ${FILES} benchmark.c ${SHIM} APPEND PROPERTY COMPILE_OPTIONS
 -O3 -mfpu=fpv5-d16 -ffp-contract=off -fno-fast-math -fno-strict-aliasing)
