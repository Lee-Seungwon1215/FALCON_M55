/*
 * Copyright 2025 NXP
 * SPDX-License-Identifier: MIT
 */

#include <stdint.h>

enum type { add, mul, sqrtt, divv_up, divv_low };

#ifdef __cplusplus
extern "C" {
#endif

void add_item_c(const enum type key, const int16_t value);
void write_to_file(char file_name[30]);
void init(int id);
void combine();

#ifdef __cplusplus
}
#endif
