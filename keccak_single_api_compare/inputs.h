#ifndef SINGLE_API_INPUTS_H
#define SINGLE_API_INPUTS_H
#include <stdint.h>
enum { INPUTS=8, REPEATS=3, VERIFY_BATCH=32 };
static void make_input(unsigned logn,unsigned index,
    uint8_t key_seed[32],uint8_t sign_seed[40],uint8_t msg[32])
{
    for(unsigned j=0;j<32;j++) {
        key_seed[j]=(uint8_t)(0xa5+29*j+7*logn+13);
        msg[j]=(uint8_t)(j*7+index+logn);
    }
    for(unsigned j=0;j<40;j++)sign_seed[j]=(uint8_t)(0xa5+29*j+7*logn+26);
    for(unsigned j=0;j<4;j++) {
        key_seed[j]^=(uint8_t)(index>>(8*j));
        sign_seed[j]^=(uint8_t)(index>>(8*j));
    }
}
#endif
