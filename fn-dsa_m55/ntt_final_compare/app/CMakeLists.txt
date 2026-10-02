cmake_minimum_required(VERSION 3.20.0)
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/fndsa_dtcm_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE}
  "${CMAKE_CURRENT_SOURCE_DIR}/generate_dtcm_linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" COMMAND_ERROR_IS_FATAL ANY)
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
  "${CMAKE_CURRENT_SOURCE_DIR}/generate_dtcm_linker.py")
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fndsa_m55_stage_b C ASM)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook)

set(FNDSA_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../ref" CACHE PATH
  "FN-DSA source directory")
get_filename_component(FNDSA_REF "${FNDSA_SOURCE_DIR}" ABSOLUTE)
set(FNDSA_MQ_ASM "mq_cm4" CACHE STRING
  "Assembly source basename that implements the mq routines")
set(FNDSA_KGEN_MP31_ASM "" CACHE STRING
  "Optional assembly source basename that implements the mp_NTT routines")
option(FNDSA_MP31_SELFTEST
  "Run coefficient-exact mp_NTT/mp_iNTT tests before the benchmark" OFF)
option(FNDSA_MP31_SIGNED_SELFTEST
  "Include signed-difference inputs in the mp31 multiplication audit" OFF)
set(MLK_ROOT "$ENV{MLKEM_NATIVE_PINNED_ROOT}")
if(NOT EXISTS "${MLK_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
  message(FATAL_ERROR "Source env/environment.sh first")
endif()
set(FNDSA_C_NAMES codec mq sha3 sysrng util kgen kgen_fxp kgen_gauss
  kgen_mp31 kgen_ntru kgen_poly kgen_zint31 sign sign_core sign_fpoly
  sign_fpr sign_sampler vrfy)
set(FNDSA_S_NAMES codec_cm4 ${FNDSA_MQ_ASM} sha3_cm4 sign_fpr_cm4 sign_sampler_cm4)
if(FNDSA_KGEN_MP31_ASM)
  list(APPEND FNDSA_S_NAMES ${FNDSA_KGEN_MP31_ASM})
endif()
set(FNDSA_SOURCES)
foreach(name IN LISTS FNDSA_C_NAMES)
  list(APPEND FNDSA_SOURCES "${FNDSA_REF}/${name}.c")
endforeach()
foreach(name IN LISTS FNDSA_S_NAMES)
  list(APPEND FNDSA_SOURCES "${FNDSA_REF}/${name}.s")
endforeach()
set(SHIM "${MLK_ROOT}/test/zephyr/app/shim_nucleo_n657x0_q.c")
target_sources(app PRIVATE ${FNDSA_SOURCES} benchmark.c dtcm_startup.s ${SHIM})
target_include_directories(app PRIVATE "${FNDSA_REF}")
target_compile_definitions(app PRIVATE FNDSA_ASM_CORTEXM4=1 FNDSA_ASM_CORTEXM55=1
  printf=__wrap_printf fprintf=__wrap_fprintf puts=__wrap_puts
  putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
if(FNDSA_KGEN_MP31_ASM)
  target_compile_definitions(app PRIVATE FNDSA_MVE_MP31=1)
endif()
if(FNDSA_MP31_SELFTEST)
  target_compile_definitions(app PRIVATE FNDSA_MP31_SELFTEST=1)
endif()
if(FNDSA_MP31_SIGNED_SELFTEST)
  target_compile_definitions(app PRIVATE FNDSA_MP31_SIGNED_SELFTEST=1)
endif()
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS
  VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
target_link_options(app PRIVATE -Wl,--wrap=printf -Wl,--wrap=fprintf
  -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
# Match upstream's last-option-wins application optimization handling.
set_property(SOURCE ${FNDSA_SOURCES} benchmark.c ${SHIM}
  APPEND PROPERTY COMPILE_OPTIONS ${CONFIG_COMPILER_OPT})

