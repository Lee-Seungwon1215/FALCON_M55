/* SPDX-License-Identifier: MIT
 * Four independent requests: keygen, signing and verification.
 * Ordinary single-request APIs remain available and do not use batching.
 */
#ifndef FNDSA_BATCH4_H
#define FNDSA_BATCH4_H
#include "fndsa.h"
#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    const void *sign_key;
    size_t sign_key_len;
    const void *ctx;
    size_t ctx_len;
    const char *id;
    const void *hv;
    size_t hv_len;
    const void *seed;          /* Required: caller-provided entropy, as in seeded API. */
    size_t seed_len;
    void *sig;
    size_t max_sig_len;
    size_t sig_len;            /* Output: zero on failure. */
} fndsa_sign_batch4_job;

/* blocks is a public queue-capacity policy, 0..160; zero means one block.
 * Batch SHAKE refills/retries select scalar or MVE x4 according to the
 * source-level occupancy policy. State conversion costs are not omitted.
 * One common signing scratch space is reused sequentially, so late sampler
 * refills are NOT guaranteed four useful lanes. Inputs/outputs/work must not
 * overlap. Keys, messages, contexts, seeds and degrees may all differ.
 */
size_t fndsa_sign_batch4_temp_size(unsigned blocks);
/* Returns 1 iff all four signatures succeeded; inspect sig_len individually.
 * Validation/preparation failure produces no signatures. A rare failure in
 * a signing core may leave other jobs successful. No global mutable state.
 * Work contains secrets on return, just like fndsa_sign_seeded_temp().
 */
int fndsa_sign_seeded_batch4_temp(fndsa_sign_batch4_job jobs[4],
    unsigned blocks, void *work, size_t work_len);
/* Call when results no longer need the workspace; time separately if comparing
 * with original APIs that also leave caller-owned scratch unwiped. */
void fndsa_sign_batch4_clear(void *work, size_t work_len);
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

/* blocks: public queue-capacity policy, 0..128; zero means one block.
 * Candidate generation interleaves unfinished jobs and replenishes queues
 * through the scalar/x4 dispatcher. Completed lanes stop consuming blocks. NTRU solving
 * and encoding remain sequential; public-key hashes are processed together.
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
