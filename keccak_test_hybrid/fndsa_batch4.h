/* SPDX-License-Identifier: MIT */
#ifndef FNDSA_KEYGEN_VERIFY_BATCH4_H
#define FNDSA_KEYGEN_VERIFY_BATCH4_H
#include "fndsa.h"
#ifdef __cplusplus
extern "C" {
#endif

/* Four INDEPENDENT requests, not a new per-request PRNG. Degrees 512/1024
 * may be mixed. Each lane retains the original single-API byte stream.
 * Inputs, outputs, jobs and work must not overlap (inputs may share storage).
 * No allocation, global mutable state or implicit queuing is performed.
 * The caller supplies entropy in each non-NULL seed and clears keygen work
 * after use. A non-NULL seed with length zero is allowed for tests.
 */
typedef struct {
    unsigned logn;
    const void *seed;
    size_t seed_len;
    void *sign_key;
    size_t sign_key_len;
    void *vrfy_key;
    size_t vrfy_key_len;
} fndsa_keygen_batch4_job;

/* blocks: public number of 136-byte blocks prefetched per lane, 0..128.
 * Once a lane exhausts its prefix it continues its ORIGINAL single SHAKE.
 * NTRU solving and public-key encoding/hashing remain sequential.
 * Returns zero for invalid arguments, before writing any output keys.
 */
size_t fndsa_keygen_batch4_temp_size(unsigned blocks);
int fndsa_keygen_seeded_batch4_temp(const fndsa_keygen_batch4_job jobs[4],
    unsigned blocks, void *work, size_t work_len);

typedef struct {
    const void *sig;
    size_t sig_len;
    const void *vrfy_key;
    size_t vrfy_key_len;
    const void *ctx;
    size_t ctx_len;
    const char *id;
    const void *hv;
    size_t hv_len;
    int valid;
} fndsa_verify_batch4_job;

/* Return 1 when batch processing completed (NOT "all signatures valid").
 * Each jobs[i].valid is independently 0 or 1. Malformed lanes do not suppress
 * valid lanes. Return 0 for a missing jobs/work pointer or short work area.
 */
size_t fndsa_verify_batch4_temp_size(void);
int fndsa_verify_batch4_temp(fndsa_verify_batch4_job jobs[4],
    void *work, size_t work_len);
void fndsa_batch4_clear(void *work, size_t work_len);
#ifdef __cplusplus
}
#endif
#endif
