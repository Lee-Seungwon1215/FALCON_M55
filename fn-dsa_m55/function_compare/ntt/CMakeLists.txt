cmake_minimum_required(VERSION 3.20.0)
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(COMPARE_LAYOUT "ab" CACHE STRING "Kernel slot placement only: ab or ba")
set(BOARD_LINKER_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/compare_linker.ld")
execute_process(COMMAND ${Python3_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/board/linker.py"
  "$ENV{ZEPHYR_BASE}/include/zephyr/arch/arm/cortex_m/scripts/linker.ld"
  "${BOARD_LINKER_SCRIPT}" "${COMPARE_LAYOUT}" COMMAND_ERROR_IS_FATAL ANY)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(fndsa_ntt_function_compare C ASM)
set(LOCAL_SOURCES
  original/mq_cm4.s original/mq_tables.c original/kgen_mp31.c
  optimized/mq_cm55.s optimized/mq_tables.c optimized/kgen_mp31_cm55.s
  optimized/kgen_mp31_fallback.c bench/roots.c bench/main.c
  board/dtcm_startup.s board/shim.c)
target_sources(app PRIVATE ${LOCAL_SOURCES})
target_include_directories(app PRIVATE bench)
target_compile_definitions(app PRIVATE FNDSA_ASM_CORTEXM4=1
  printf=__wrap_printf fprintf=__wrap_fprintf puts=__wrap_puts
  putchar=__wrap_putchar fflush=__wrap_fflush exit=__wrap_exit)
zephyr_compile_definitions(USER_VECT_TAB_ADDRESS VECT_TAB_BASE_ADDRESS=0x10000000 VECT_TAB_OFFSET=0x0)
zephyr_link_libraries(-Wl,--wrap=soc_early_reset_hook -Wl,--wrap=printf -Wl,--wrap=fprintf
  -Wl,--wrap=puts -Wl,--wrap=putchar -Wl,--wrap=fflush -Wl,--wrap=exit)
set_property(SOURCE ${LOCAL_SOURCES} APPEND PROPERTY COMPILE_OPTIONS -O3 -fno-reorder-functions)
