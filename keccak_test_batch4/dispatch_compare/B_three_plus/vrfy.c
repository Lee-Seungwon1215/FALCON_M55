/*
 * Signature verification.
 */

#include "inner.h"
#include "fndsa_batch4.h"
#include "shake_independent4.h"

/*
 * Inner verification function; it enforces a specific degree range.
 */
static int
inner_verify_prepared(unsigned logn_min, unsigned logn_max,
	const void *sig, size_t sig_len,
	const void *vrfy_key, size_t vrfy_key_len,
	const void *ctx, size_t ctx_len,
	const char *id, const void *hv, size_t hv_len,
	void *tmp, size_t tmp_len, const uint16_t *prepared_c)
{
	/* Get header bytes for key and signature, check that they relate
	   to the same degree, and that it is acceptable. */
	if (sig_len == 0 || vrfy_key_len == 0) {
		return 0;
	}
	const uint8_t *sigbuf = (const uint8_t *)sig;
	const uint8_t *vkbuf = (const uint8_t *)vrfy_key;
	unsigned logn = vkbuf[0];
	if (logn < logn_min || logn > logn_max || sigbuf[0] != 0x30 + logn) {
		return 0;
	}

	/* Keys and signatures have known fixed sizes. */
	if (sig_len != FNDSA_SIGNATURE_SIZE(logn)
		|| vrfy_key_len != FNDSA_VRFY_KEY_SIZE(logn))
	{
		return 0;
	}

	/* Check that temporary area is large enough. */
	size_t n = (size_t)1 << logn;
	if (tmp_len < (n * 4 + 31)) {
		return 0;
	}
	tmp = (void *)(((uintptr_t)tmp + 31) & ~(uintptr_t)31);

	/* Get message representative mu. */
	uint8_t mu[64];
	if (id != NULL && *(const uint8_t *)id == 0xFE) {
		if (hv_len != sizeof mu) {
			return 0;
		}
		memcpy(mu, hv, sizeof mu);
	} else {
		fndsa_hashed_vrfykey_from_vrfykey(mu, vrfy_key, vrfy_key_len);
		if (!fndsa_compute_mu(mu, mu, ctx, ctx_len, id, hv, hv_len)) {
			return 0;
		}
	}

	/* Get two buffers of n 16-bit values from the temporary area. */
	uint16_t *t1 = (uint16_t *)tmp;
	uint16_t *t2 = t1 + n;

	/* t1 <- h (verifying key, decoded); h is in ntt representation. */
	if (mqpoly_decode(logn, vkbuf + 1, t1) != vrfy_key_len - 1) {
		return 0;
	}
	mqpoly_ext_to_int(logn, t1);

	/* t2 <- s2 (signature, decoded, converted to ntt)
	   Also get the squared norm of s2. */
	if (!comp_decode(logn, sigbuf + 41, sig_len - 41, (int16_t *)t2)) {
		/* Note: comp_decode() checks the L-infinity norm of s2. */
		return 0;
	}
	uint32_t norm2 = mqpoly_sqnorm_signed(logn, t2);
	mqpoly_signed_to_int(logn, t2);
	mqpoly_int_to_ntt(logn, t2);

	/* t2 <- s2*h (converted to int) */
	mqpoly_mul_ntt(logn, t2, t1);
	mqpoly_ntt_to_int(logn, t2);

	/* Hash message into polynomial c (into t1, converted to int) */
	if (prepared_c != NULL) {
		memcpy(t1, prepared_c, n * sizeof *t1);
	} else {
		hash_to_point(logn, sigbuf + 1, mu, t1);
	}
	mqpoly_ext_to_int(logn, t1);

	/* t1 <- s1 = c - s2*h (converted to ext), and compute its norm;
	   this also verifies the L-infinity norm of s1. */
	mqpoly_sub(logn, t1, t2);
	mqpoly_int_to_ext(logn, t1);
	uint32_t norm1 = mqpoly_sqnorm_binf_ext(logn, t1);

	/* Signature is valid if the total squared norm of (s1,s2) is
	   small enough. Beware overflows. */
	if (norm2 != 0 && norm1 >= -norm2) {
		return 0;
	}
	return mqpoly_sqnorm_is_acceptable(logn, norm1 + norm2);
}

static int
inner_verify(unsigned logn_min, unsigned logn_max,
    const void *sig, size_t sig_len, const void *vrfy_key, size_t vrfy_key_len,
    const void *ctx, size_t ctx_len, const char *id, const void *hv, size_t hv_len,
    void *tmp, size_t tmp_len)
{
    return inner_verify_prepared(logn_min, logn_max, sig, sig_len,
        vrfy_key, vrfy_key_len, ctx, ctx_len, id, hv, hv_len,
        tmp, tmp_len, NULL);
}

typedef struct {
    fndsa_shake4_state state;
    uint8_t block[4][136];
    uint8_t hpk[4][64], mu[4][64];
    uint16_t c[4][1024];
    uint8_t tmp[4*1024 + 31];
} verify_batch_work;

size_t
fndsa_verify_batch4_temp_size(void)
{
    return sizeof(verify_batch_work) + 31;
}

int
fndsa_verify_batch4_temp(fndsa_verify_batch4_job jobs[4],
    void *work, size_t work_len)
{
    if (jobs == NULL || work == NULL || work_len < fndsa_verify_batch4_temp_size()) return 0;
    verify_batch_work *w = (void *)(((uintptr_t)work + 31) & ~(uintptr_t)31);
    fndsa_shake_iov vectors[4][5];
    const fndsa_shake_iov *vp[4];
    size_t counts[4] = {0}, n[4] = {0}, pos[4] = {0}, id_len[4] = {0};
    uint8_t header[4][2] = {{0}};
    unsigned good = 0, external = 0;
    for (unsigned lane = 0; lane < 4; lane++) {
        fndsa_verify_batch4_job *j = &jobs[lane];
        j->valid = 0;
        vp[lane] = vectors[lane];
        if (j->sig == NULL || j->vrfy_key == NULL || j->sig_len == 0 || j->vrfy_key_len == 0
            || (j->hv == NULL && j->hv_len != 0)) continue;
        const uint8_t *vk = j->vrfy_key, *sig = j->sig;
        unsigned logn = vk[0];
        if (logn < 9 || logn > 10 || sig[0] != 0x30 + logn
            || j->sig_len != FNDSA_SIGNATURE_SIZE(logn)
            || j->vrfy_key_len != FNDSA_VRFY_KEY_SIZE(logn)) continue;
        const uint8_t *id = (const uint8_t *)(j->id == NULL ? FNDSA_HASH_ID_RAW : j->id);
        if (id[0] == 0xfe) {
            if (j->hv_len != 64) continue;
            external |= 1u << lane;
        } else {
            if (j->ctx_len > 255 || (j->ctx == NULL && j->ctx_len != 0)) continue;
            if (id[0] == 6 && id[1] <= 127) {
                header[lane][0] = 1;
                id_len[lane] = (size_t)id[1] + 2;
            } else if (id[0] != 0) continue;
            header[lane][1] = (uint8_t)j->ctx_len;
            vectors[lane][0] = (fndsa_shake_iov){j->vrfy_key, j->vrfy_key_len};
            counts[lane] = 1;
        }
        n[lane] = (size_t)1 << logn;
        good |= 1u << lane;
    }
    if (good == 0) return 1;

    /* SHAKE256(public key), then original domain/context/message encoding.
     * External-mu requests skip both operations exactly as the single API. */
    if ((good & ~external) != 0) {
        fndsa_shake4_absorb(&w->state, vp, counts);
        fndsa_shake4_block(&w->state, w->block);
        for (unsigned lane = 0; lane < 4; lane++) {
            counts[lane] = 0;
            if ((good & ~external & (1u << lane)) == 0) continue;
            const fndsa_verify_batch4_job *j = &jobs[lane];
            memcpy(w->hpk[lane], w->block[lane], 64);
            vectors[lane][0] = (fndsa_shake_iov){w->hpk[lane], 64};
            vectors[lane][1] = (fndsa_shake_iov){header[lane], 2};
            vectors[lane][2] = (fndsa_shake_iov){j->ctx, j->ctx_len};
            vectors[lane][3] = (fndsa_shake_iov){j->id, id_len[lane]};
            vectors[lane][4] = (fndsa_shake_iov){j->hv, j->hv_len};
            counts[lane] = 5;
        }
        fndsa_shake4_absorb(&w->state, vp, counts);
        fndsa_shake4_block(&w->state, w->block);
    }
    for (unsigned lane = 0; lane < 4; lane++) {
        counts[lane] = 0;
        if ((good & (1u << lane)) == 0) continue;
        memcpy(w->mu[lane], (external & (1u << lane))
            ? jobs[lane].hv : w->block[lane], 64);
        vectors[lane][0] = (fndsa_shake_iov){(const uint8_t *)jobs[lane].sig + 1, 40};
        vectors[lane][1] = (fndsa_shake_iov){w->mu[lane], 64};
        counts[lane] = 2;
    }

    /* Original Hash-to-Point rejection sampling. A completed lane is ignored;
     * every other lane continues its own stream, with no shared byte cursor. */
    fndsa_shake4_absorb(&w->state, vp, counts);
    unsigned remaining = good;
    while (remaining != 0) {
        fndsa_shake4_block(&w->state, w->block);
        for (unsigned lane = 0; lane < 4; lane++) {
            if ((remaining & (1u << lane)) == 0) continue;
            for (unsigned j = 0; j < 136 && pos[lane] < n[lane]; j += 2) {
                unsigned x = w->block[lane][j] | ((unsigned)w->block[lane][j+1] << 8);
                if (x < 61445) {
                    while (x >= 12289) x -= 12289;
                    w->c[lane][pos[lane]++] = (uint16_t)x;
                }
            }
            if (pos[lane] == n[lane]) remaining &= ~(1u << lane);
        }
    }
    for (unsigned lane = 0; lane < 4; lane++) {
        if ((good & (1u << lane)) == 0) continue;
        fndsa_verify_batch4_job *j = &jobs[lane];
        j->valid = inner_verify_prepared(9, 10, j->sig, j->sig_len,
            j->vrfy_key, j->vrfy_key_len, NULL, 0, FNDSA_HASH_ID_EXTMU,
            w->mu[lane], 64, w->tmp, sizeof w->tmp, w->c[lane]);
    }
    return 1;
}

#if FNDSA_AVX2
TARGET_AVX2
static int
avx2_inner_verify(unsigned logn_min, unsigned logn_max,
	const void *sig, size_t sig_len,
        const void *vrfy_key, size_t vrfy_key_len,
        const void *ctx, size_t ctx_len,
        const char *id, const void *hv, size_t hv_len,
	void *tmp, size_t tmp_len)
{
	/* Get header bytes for key and signature, check that they relate
	   to the same degree, and that it is acceptable. */
	if (sig_len == 0 || vrfy_key_len == 0) {
		return 0;
	}
	const uint8_t *sigbuf = (const uint8_t *)sig;
	const uint8_t *vkbuf = (const uint8_t *)vrfy_key;
	unsigned logn = vkbuf[0];
	if (logn < logn_min || logn > logn_max || sigbuf[0] != 0x30 + logn) {
		return 0;
	}

	/* Keys and signatures have known fixed sizes. */
	if (sig_len != FNDSA_SIGNATURE_SIZE(logn)
		|| vrfy_key_len != FNDSA_VRFY_KEY_SIZE(logn))
	{
		return 0;
	}

	/* Check that temporary area is large enough. */
	size_t n = (size_t)1 << logn;
	if (tmp_len < (n * 4 + 31)) {
		return 0;
	}
	tmp = (void *)(((uintptr_t)tmp + 31) & ~(uintptr_t)31);

	/* Get message representative mu. */
	uint8_t mu[64];
	if (id != NULL && *(const uint8_t *)id == 0xFE) {
		if (hv_len != sizeof mu) {
			return 0;
		}
		memcpy(mu, hv, sizeof mu);
	} else {
		fndsa_hashed_vrfykey_from_vrfykey(mu, vrfy_key, vrfy_key_len);
		if (!fndsa_compute_mu(mu, mu, ctx, ctx_len, id, hv, hv_len)) {
			return 0;
		}
	}

	/* Get two buffers of n 16-bit values from the temporary area. */
	uint16_t *t1 = (uint16_t *)tmp;
	uint16_t *t2 = t1 + n;

	/* t1 <- h (verifying key, decoded); h is in ntt representation. */
	if (mqpoly_decode(logn, vkbuf + 1, t1) != vrfy_key_len - 1) {
		return 0;
	}
	avx2_mqpoly_ext_to_int(logn, t1);

	/* t2 <- s2 (signature, decoded, converted to ntt)
	   Also get the squared norm of s2. */
	if (!comp_decode(logn, sigbuf + 41, sig_len - 41, (int16_t *)t2)) {
		/* Note: comp_decode() checks the L-infinity norm of s2. */
		return 0;
	}
	uint32_t norm2 = avx2_mqpoly_sqnorm_signed(logn, t2);
	avx2_mqpoly_signed_to_int(logn, t2);
	avx2_mqpoly_int_to_ntt(logn, t2);

	/* t2 <- s2*h (converted to int) */
	avx2_mqpoly_mul_ntt(logn, t2, t1);
	avx2_mqpoly_ntt_to_int(logn, t2);

	/* Hash message into polynomial c (into t1, converted to int) */
	hash_to_point(logn, sigbuf + 1, mu, t1);
	avx2_mqpoly_ext_to_int(logn, t1);

	/* t1 <- s1 = c - s2*h (converted to ext), and compute its norm. */
	avx2_mqpoly_sub(logn, t1, t2);
	avx2_mqpoly_int_to_ext(logn, t1);
	uint32_t norm1 = avx2_mqpoly_sqnorm_binf_ext(logn, t1);

	/* Signature is valid if the total squared norm of (s1,s2) is
	   small enough. Beware overflows. */
	if (norm2 != 0 && norm1 >= -norm2) {
		return 0;
	}
	return mqpoly_sqnorm_is_acceptable(logn, norm1 + norm2);
}
#endif

/* see fndsa.h */
int
fndsa_verify(const void *sig, size_t sig_len,
        const void *vrfy_key, size_t vrfy_key_len,
        const void *ctx, size_t ctx_len,
        const char *id, const void *hv, size_t hv_len)
{
	uint8_t tmp[4 * 1024 + 31];
#if FNDSA_AVX2
	if (has_avx2()) {
		return avx2_inner_verify(9, 10,
			sig, sig_len, vrfy_key, vrfy_key_len,
			ctx, ctx_len, id, hv, hv_len, tmp, sizeof tmp);
	}
#endif
	return inner_verify(9, 10,
		sig, sig_len, vrfy_key, vrfy_key_len,
		ctx, ctx_len, id, hv, hv_len, tmp, sizeof tmp);
}

/* see fndsa.h */
int
fndsa_verify_weak(const void *sig, size_t sig_len,
        const void *vrfy_key, size_t vrfy_key_len,
        const void *ctx, size_t ctx_len,
        const char *id, const void *hv, size_t hv_len)
{
	uint8_t tmp[4 * 256 + 31];
#if FNDSA_AVX2
	if (has_avx2()) {
		return avx2_inner_verify(2, 8,
			sig, sig_len, vrfy_key, vrfy_key_len,
			ctx, ctx_len, id, hv, hv_len, tmp, sizeof tmp);
	}
#endif
	return inner_verify(2, 8,
		sig, sig_len, vrfy_key, vrfy_key_len,
		ctx, ctx_len, id, hv, hv_len, tmp, sizeof tmp);
}

/* see fndsa.h */
int
fndsa_verify_temp(const void *sig, size_t sig_len,
	const void *vrfy_key, size_t vrfy_key_len,
	const void *ctx, size_t ctx_len,
	const char *id, const void *hv, size_t hv_len,
	void *tmp, size_t tmp_len)
{
#if FNDSA_AVX2
	if (has_avx2()) {
		return inner_verify(9, 10,
			sig, sig_len, vrfy_key, vrfy_key_len,
			ctx, ctx_len, id, hv, hv_len, tmp, tmp_len);
	}
#endif
	return inner_verify(9, 10,
		sig, sig_len, vrfy_key, vrfy_key_len,
		ctx, ctx_len, id, hv, hv_len, tmp, tmp_len);
}

/* see fndsa.h */
int
fndsa_verify_weak_temp(const void *sig, size_t sig_len,
	const void *vrfy_key, size_t vrfy_key_len,
	const void *ctx, size_t ctx_len,
	const char *id, const void *hv, size_t hv_len,
	void *tmp, size_t tmp_len)
{
#if FNDSA_AVX2
	if (has_avx2()) {
		return inner_verify(2, 8,
			sig, sig_len, vrfy_key, vrfy_key_len,
			ctx, ctx_len, id, hv, hv_len, tmp, tmp_len);
	}
#endif
	return inner_verify(2, 8,
		sig, sig_len, vrfy_key, vrfy_key_len,
		ctx, ctx_len, id, hv, hv_len, tmp, tmp_len);
}
