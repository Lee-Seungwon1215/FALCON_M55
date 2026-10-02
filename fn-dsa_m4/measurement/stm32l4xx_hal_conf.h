#ifndef FNDSA_MEASUREMENT_HAL_CONF_H
#define FNDSA_MEASUREMENT_HAL_CONF_H
/* Reuse the existing HAL module selection, without changing that file. */
#include "../../fn-dsa_ref/profiling/stm32l4xx_hal_conf.h"
#undef INSTRUCTION_CACHE_ENABLE
#undef DATA_CACHE_ENABLE
#define INSTRUCTION_CACHE_ENABLE 0U
#define DATA_CACHE_ENABLE 0U
#endif
