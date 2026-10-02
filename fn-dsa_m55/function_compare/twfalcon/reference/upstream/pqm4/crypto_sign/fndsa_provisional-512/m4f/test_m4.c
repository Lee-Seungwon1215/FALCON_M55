/*
 * Copyright 2025 NXP
 * SPDX-License-Identifier: MIT
 */

#include "test_m4.h"
#include "hal.h"
#include "ieeefp.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

const int TEST_AMOUNT = 1000000;

tw_fpr create_tw_fpr(uint32_t x0, uint32_t x1, uint32_t x2) {

    tw_fpr x;
    funion_t xf;

    xf.i = x0;
    x.x[0] = xf.x;

    xf.i = x1;
    x.x[1] = xf.x;

    xf.i = x2;
    x.x[2] = xf.x;

    return x;
}
extern tw_fpr tw_sum_ct_asm(tw_fpr x, tw_fpr y);
extern tw_fpr tw_sum_asm(tw_fpr x, tw_fpr y);
// #pragma GCC push_options
// #pragma GCC optimize("O0")
int test_add_twfpr(tw_fpr x, tw_fpr y, tw_fpr z) {
    tw_fpr z1, z1_ct;
    z1 = tw_sum_asm(x, y);
    z1_ct = tw_sum_ct_asm(x, y);

    int check = 1;
    for (int i = 0; i < 3; i++) {
        if (z1.x[i] != z.x[i] && z1_ct.x[i] != z.x[i]) {
            check = 0;
        }
    }
    if (check != 1) {

        char text[100];
        sprintf(text, "(%.10e, %.10e, %.10e) != (%.10e, %.10e, %.10e)", z1.x[0],
                z1.x[1], z1.x[2], z.x[0], z.x[1], z.x[2]);
        hal_send_str(text);
    }
    return check;
}

int test_add_sub_asm(tw_fpr x, tw_fpr y, tw_fpr z1, tw_fpr z2) {
    tw_fpr z11, z22;
    //
    tw_fpr t_add_sub_x = (x);
    tw_fpr t_add_sub_y = (y);
    register float t_add_sub_s0 __asm__("s0") = t_add_sub_x.x[0];
    register float t_add_sub_s1 __asm__("s1") = t_add_sub_x.x[1];
    register float t_add_sub_s2 __asm__("s2") = t_add_sub_x.x[2];
    register float t_add_sub_s3 __asm__("s3") = t_add_sub_y.x[0];
    register float t_add_sub_s4 __asm__("s4") = t_add_sub_y.x[1];
    register float t_add_sub_s5 __asm__("s5") = t_add_sub_y.x[2];

    __asm__ volatile("bl tw_add_sub_ct_asm\n"
                     : "+t"(t_add_sub_s0), "+t"(t_add_sub_s1),
                       "+t"(t_add_sub_s2), "+t"(t_add_sub_s3),
                       "+t"(t_add_sub_s4), "+t"(t_add_sub_s5)
                     :
                     : "lr", "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
                       "r8", "r9", "r10", "r11", "s6", "s7", "s8", "s9", "s10",
                       "s11", "s12", "s13", "s14", "s15", "cc");
    z11 = (tw_fpr){{t_add_sub_s0, t_add_sub_s1, t_add_sub_s2}};
    z22 = (tw_fpr){{t_add_sub_s3, t_add_sub_s4, t_add_sub_s5}};

    int check = 1;

    for (int i = 0; i < 3; i++) {
        if (z1.x[i] != z11.x[i] || z2.x[i] != z22.x[i]) {

            check = 0;
        }
    }
    return check;
}
extern int32_t tw_floor_fast_asm(const tw_fpr x);
int test_floor_fast_asm(tw_fpr x, int64_t a) {

    int32_t a1 = tw_floor_fast_asm(x);

    int check = 1;
    if ((int32_t)a != a1) {
        char buffer[100];
        sprintf(buffer, "%lld != %ld\n", a, a1);
        hal_send_str(buffer);

        check = 0;
    }
    return check;
}
extern int32_t tw_trunc_full_ct_asm(const tw_fpr x);
int test_trunc_full_ct_asm(tw_fpr x, int64_t a) {

    int32_t a1 = tw_trunc_full_ct_asm(x);

    int check = 1;
    if ((int32_t)a != a1) {
        char buffer[100];
        sprintf(buffer, "%lld != %ld\n", a, a1);
        hal_send_str(buffer);

        check = 0;
    }
    return check;
}
extern int32_t tw_rint_fast_ct_asm(const tw_fpr x);
int test_rint_fast_ct_asm(tw_fpr x, int32_t a) {

    int32_t a1 = tw_rint_fast_ct_asm(x);

    int check = 1;
    if (a != a1) {
        char buffer[100];
        sprintf(buffer, "%ld != %ld\n", a, a1);
        hal_send_str(buffer);

        check = 0;
    }
    return check;
}

extern tw_fpr tw_sum_f_ct_asm(const tw_fpr a, const float b);
int test_sum_f_ct_asm(tw_fpr x, float a, tw_fpr z) {

    tw_fpr z1 = tw_sum_f_ct_asm(x, a);

    int check = 1;
    for (int i = 0; i < 3; i++) {
        if (z1.x[i] != z.x[i]) {
            check = 0;
        }
    }
    return check;
}
extern tw_fpr tw_prod_fast_f_ct_asm(const float a0, const tw_fpr b);
int test_prod_f_ct_asm(float a, tw_fpr x, tw_fpr z) {

    tw_fpr z1 = tw_prod_fast_f_ct_asm(a, x);

    int check = 1;
    for (int i = 0; i < 3; i++) {
        if (z1.x[i] != z.x[i]) {
            check = 0;
        }
    }
    return check;
}

extern tw_fpr tw_prod_fast_ct_asm(tw_fpr x, tw_fpr y);
extern tw_fpr tw_prod_fast_asm(tw_fpr x, tw_fpr y);
int test_prod_twfpr(tw_fpr x, tw_fpr y, tw_fpr z) {
    tw_fpr z1, z1_ct;

    z1_ct = tw_prod_fast_ct_asm(x, y);
    z1 = tw_prod_fast_asm(x, y);

    int check = 1;

    for (int i = 0; i < 3; i++) {
        if (z1_ct.x[i] != z.x[i] && z1.x[i] != z.x[i]) {
            check = 0;
        }
    }
    return check;
}

tw_fpr tw_sqrt_fast_ct_asm(tw_fpr x);
tw_fpr tw_sqrt_fast_asm(tw_fpr x);

int test_sqrt_twfpr(tw_fpr x, tw_fpr z) {
    tw_fpr z1, z1_ct;

    z1 = tw_sqrt_fast_asm(x);
    z1_ct = tw_sqrt_fast_ct_asm(x);

    int check = 1;

    for (int i = 0; i < 3; i++) {
        if (z1.x[i] != z.x[i] || z1_ct.x[i] != z.x[i]) {
            check = 0;
        }
    }
    return check;
}

tw_fpr tw_div_fast_ct_asm(tw_fpr x, tw_fpr y);
tw_fpr tw_div_fast_asm(tw_fpr x, tw_fpr y);

int test_div_twfpr(tw_fpr x, tw_fpr y, tw_fpr z) {
    tw_fpr z1, z1_ct;

    z1 = tw_div_fast_asm(x, y);
    z1_ct = tw_div_fast_ct_asm(x, y);

    int check = 1;
    for (int i = 0; i < 3; i++) {
        if (z1.x[i] != z.x[i] || z1_ct.x[i] != z.x[i]) {
            check = 0;
        }
    }
    return check;
}
tw_fpr tw_reci_fast_ct_asm(tw_fpr x);
tw_fpr tw_reci_fast_asm(tw_fpr x);
int test_reci_twfpr(tw_fpr x, tw_fpr z) {
    tw_fpr z1, z1_ct;

    z1 = tw_reci_fast_asm(x);
    z1_ct = tw_reci_fast_ct_asm(x);

    int check = 1;
    for (int i = 0; i < 3; i++) {
        if (z1.x[i] != z.x[i] || z1_ct.x[i] != z.x[i]) {
            char item[100];
            sprintf(item, "%e != %e\n", z1.x[i], z.x[i]);
            hal_send_str(item);
            check = 0;
        }
    }
    return check;
}

float frand() {
    __ieee_float_shape_type x;
    x.number.sign = rand() & 0b1;
    x.number.exponent = (rand() % 250) + 1;
    x.number.fraction0 = rand() & 0b1111111;
    x.number.fraction1 = rand() & 0xFFFF;

    return x.value;
}

float frand_prod() {
    __ieee_float_shape_type x;
    x.number.sign = rand() & 0b1;
    x.number.exponent = (rand() % 120) + 1;
    x.number.fraction0 = rand() & 0b1111111;
    x.number.fraction1 = rand() & 0xFFFF;

    return x.value;
}
float frand_sqrt() {
    __ieee_float_shape_type x;
    x.number.sign = 0;
    x.number.exponent = (rand() % 2) + 13 + 127;
    x.number.fraction0 = rand() & 0b1111111;
    x.number.fraction1 = rand() & 0xFFFF;

    return x.value;
}
float frand_floor_fast() {
    __ieee_float_shape_type x;
    x.number.sign = rand() & 0b1;
    x.number.exponent = (rand() % 60) + 80;
    x.number.fraction0 = rand() & 0b1111111;
    x.number.fraction1 = rand() & 0xFFFF;

    return x.value;
}

tw_fpr random_tw_fpr() {

    float x1 = frand();
    float x2 = frand();
    float x3 = frand();

    tw_fpr x = to_tw(x1, x2, x3);
    return x;
}

tw_fpr random_tw_fpr_prod() {

    float x1 = frand_prod();
    float x2 = frand_prod();
    float x3 = frand_prod();

    tw_fpr x = to_tw(x1, x2, x3);
    return x;
}

tw_fpr random_tw_fpr_sqrt() {

    float x1 = frand_sqrt();
    float x2 = frand_sqrt();
    float x3 = frand_sqrt();

    tw_fpr x = to_tw(x1, x2, x3);
    return x;
}
tw_fpr random_tw_fpr_floor_fast() {
    float x1 = frand_floor_fast();
    float x2 = frand_floor_fast();
    float x3 = frand_floor_fast();

    tw_fpr x = to_tw(x1, x2, x3);
    return x;
}
int test_add_assembly_random() {

    tw_fpr a, b, z;
    a = random_tw_fpr();
    b = random_tw_fpr();

    z = tw_sum(a, b);

    return test_add_twfpr(a, b, z);
}

int test_add_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {
        if (!test_add_assembly_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_prod_random() {

    tw_fpr a, b, z;
    a = random_tw_fpr_prod();
    b = random_tw_fpr_prod();

    z = tw_prod_fast(a, b);

    return test_prod_twfpr(a, b, z);
}

int test_prod_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {
        if (!test_prod_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_add_sub_random() {

    tw_fpr a, b, z1, z2;
    a = random_tw_fpr();
    b = random_tw_fpr();

    tw_add_sub(a, b, &z1, &z2);

    return test_add_sub_asm(a, b, z1, z2);
}
int test_floor_fast_random() {

    tw_fpr a = random_tw_fpr();
    while (a.x[0] > 16777216 || a.x[0] < -16777216) {
        a = random_tw_fpr();
    }

    int64_t x = tw_floor_fast(a);

    return test_floor_fast_asm(a, x);
}
int test_trunc_full_random() {

    tw_fpr a = random_tw_fpr();

    int64_t x = tw_trunc_full(a);

    return test_trunc_full_ct_asm(a, x);
}
int test_rint_fast_random() {

    tw_fpr a = random_tw_fpr();

    int32_t x = tw_rint_fast_ct(a);

    return test_rint_fast_ct_asm(a, x);
}
int test_sum_f_ct_random() {

    tw_fpr a, b;
    a = random_tw_fpr();
    b = random_tw_fpr();
    b.x[1] = 0;
    b.x[2] = 0;

    tw_fpr z = tw_sum_f_ct(a, b.x[0]);

    return test_sum_f_ct_asm(a, b.x[0], z);
}
int test_prod_fast_f_ct_random() {

    tw_fpr a, b;
    a = random_tw_fpr_prod();
    b = random_tw_fpr_prod();
    b.x[1] = 0;
    b.x[2] = 0;
    float bb = b.x[0];

    tw_fpr z = tw_prod_fast_f_ct(bb, a);

    return test_prod_f_ct_asm(bb, a, z);
}
int test_sqrt_random() {

    tw_fpr a, z;
    a = random_tw_fpr_sqrt();

    z = tw_sqrt_fast(a);

    return test_sqrt_twfpr(a, z);
}
int test_div_random() {

    tw_fpr a, b, z;
    a = random_tw_fpr_sqrt();
    b = random_tw_fpr_sqrt();

    z = tw_div_fast(a, b);

    return test_div_twfpr(a, b, z);
}
int test_reci_random() {

    tw_fpr a, z;
    a = random_tw_fpr_sqrt();

    z = tw_reci_fast(a);

    return test_reci_twfpr(a, z);
}

int test_sqrt_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {
        if (!test_sqrt_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_div_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {
        if (!test_div_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_reci_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {
        if (!test_reci_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_add_sub_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {
        if (!test_add_sub_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_floor_fast_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {

        if (!test_floor_fast_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_trunc_full_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {

        if (!test_trunc_full_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_rint_fast_assembly() {
    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {

        if (!test_rint_fast_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_sum_f_ct_assembly() {

    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {

        if (!test_sum_f_ct_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
int test_prod_f_ct_assembly() {

    int success = 1;
    for (int i = 0; i < TEST_AMOUNT; i++) {

        if (!test_prod_fast_f_ct_random()) {
            success = 0;
            char buffer[100];
            sprintf(buffer, "failed at i = %d\n", i);
            hal_send_str(buffer);
        }
    }
    return success;
}
// #pragma GCC pop_options
// #pragma GCC push_options
// #pragma GCC optimize ("O0")
int test_add() { return test_add_assembly(); }

int test_prod() { return test_prod_assembly(); }

int test_sqrt() { return test_sqrt_assembly(); }

int test_div() { return test_div_assembly(); }
int test_reci() { return test_reci_assembly(); }
int test_add_sub() { return test_add_sub_assembly(); }
int test_floor_fast() { return test_floor_fast_assembly(); }
int test_sum_f_ct() { return test_sum_f_ct_assembly(); }
int test_prod_f_ct() { return test_prod_f_ct_assembly(); }
int test_trunc_full() { return test_trunc_full_assembly(); }
int test_rint_fast() { return test_rint_fast_assembly(); }

// #pragma GCC pop_options
