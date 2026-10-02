/*
 * Copyright 2025 NXP
 * SPDX-License-Identifier: MIT
 */

#include "print_to_file_combined.h"
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TYPE_SIZE 4
#define VALUE_SIZE 6
#define FILE_ITEM_SIZE TYPE_SIZE + VALUE_SIZE + 3
#define ITEMS_SIZE 1000


struct file_item {
    enum type type;
    int16_t value;
};

static const char *get_type_name(enum type name) {
    switch (name) {
    case add:
        return "add";
    case mul:
        return "mul";
    case sqrtt:
        return "sqrt";
    case divv_up:
        return "div_high";
    case divv_low:
        return "div_low";
        break;
    }
}

// #ifndef fpr
// typedef uint64_t fpr;
// #endif

static void get_file_name(char time_str[30]) {
    time_t rawtime;
    struct tm *timeinfo;

    time(&rawtime);
    timeinfo = localtime(&rawtime);

    /* Format using locale's default date and time representation */
    strftime(time_str, 30, "%F:%T.csv", timeinfo);
    // sprintf(time_str, "custom.csv");
}
typedef union dunion {
    uint64_t i;
    double d;

} dunion_t;

static void print_exponent_fpr_combined(uint64_t x, enum type arithmetic_type){
    dunion_t xt;
    xt.i = x;
int16_t exponent_biased;
    if (xt.d == 0) {
        exponent_biased = -200;
    }
    else{
        exponent_biased = ((x >> 52) & 0x7FF) - 1023;

    }
    // if(exponent_biased == 0){
    //     return;
    //
    // }

    add_item_c(arithmetic_type, exponent_biased);
}

static pthread_mutex_t old_lock;

static void print_exponent_fpr(uint64_t x, enum type arithmetic_type) {


    dunion_t xt;
    xt.i = x;
    //
    // if (xt.d == 0) {
    //     return;
    // }

    print_exponent_fpr_combined(x, arithmetic_type);
    return;

    int16_t exponent_biased = ((x >> 52) & 0x7FF) - 1023;
    pthread_mutex_lock(&old_lock);
    static struct file_item items[ITEMS_SIZE];
    static int items_ptr = 0;
    static int file_created = 0;
    static char file_name[30];
    // return;
    int16_t exponent = ((x >> 52) & 0x7FF) - 1023;

    if (items_ptr < ITEMS_SIZE) {
        struct file_item item = {.type = arithmetic_type,
                                 .value = exponent_biased};
        items[items_ptr] = item;
        items_ptr++;
    }
    if (items_ptr == ITEMS_SIZE - 1) {
        FILE *fptr;
        if (!file_created) {
            get_file_name(file_name);
            fptr = fopen(file_name, "w");
            fprintf(fptr, "operation,exponent\n");
            file_created = 1;
        } else {
            fptr = fopen(file_name, "a");
        }
        for (int i = 0; i < ITEMS_SIZE; i++) {
            struct file_item curr_item = items[i];
            const char *type_name = get_type_name(curr_item.type);
            fprintf(fptr, "%s,%d\n", type_name, curr_item.value);
        }
        fclose(fptr);
        items_ptr = 0;
    }
    pthread_mutex_unlock(&old_lock);
}
