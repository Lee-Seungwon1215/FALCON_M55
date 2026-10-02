#ifndef BRIDGE_WORKSPACE_H
#define BRIDGE_WORKSPACE_H

#include "kgen_ds.h"
#include "bridge_control/control_tw32_api.h"

/* Measurement control: same DTCM base address, sequential use only. The
 * native layouts remain unchanged (TW has 3 planes, C has 2 planes). */
struct bridge_workspace {
    uint64_t before[4];
    union {
        fndsa_ds_poly c;
        control_tw32_fft tw;
    } poly;
    uint64_t after[4];
};
extern struct bridge_workspace bridge_shared_workspace;

#endif
