/*
 * Top-level key pair generator functions.
 */

#include "kgen_inner.h"
#include "fndsa_batch4.h"
#include "shake_independent4.h"

static void
keygen_inner_stream(unsigned logn, shake_context *stream,
    fndsa_shake_prefix *prefix, void *sign_key, void *vrfy_key, void *tmp)
{
	/* Ensure that tmp is 32-byte aligned. */
	tmp = (void *)(((uintptr_t)tmp + 31) & ~(uintptr_t)31);

	/* We allocate f and g at the end of the temporary area. */
	size_t n = (size_t)1 << logn;
	int8_t *f = (int8_t *)tmp + ((size_t)20 << logn);
	int8_t *g = f + n;

	shake_context pc = *stream;
	for (;;) {
		/* Sample f, with odd parity. */
		if (prefix != NULL && prefix->next != prefix->end) {
			fndsa_sample_f_prefetched(logn, &pc, prefix, f);
		} else {
			sample_f(logn, &pc, f);
		}

		/* If f is not invertible mod q, try again. */
		if (!mqpoly_is_invertible(logn, f, tmp)) {
			continue;
		}
		/* Note: invertibility check on f entailed converting f
		   to NTT. In order to save RAM, we do not keep NTT(f);
		   instead, we will recompute it at the end. The CPU
		   overhead is negligible, but the RAM saving is not (on
		   small microcontroller). */

		/* Sample g, also with odd parity. */
		if (prefix != NULL && prefix->next != prefix->end) {
			fndsa_sample_f_prefetched(logn, &pc, prefix, g);
		} else {
			sample_f(logn, &pc, g);
		}

		/* Ensure that ||(g, -f)|| < 1.17*sqrt(q),
		   i.e. that ||(g, -f)||^2 < (1.17^2)*q = 16822.4121  */
		int32_t sn = 0;
		for (size_t i = 0; i < n; i ++) {
			int32_t xf = f[i];
			int32_t xg = g[i];
			sn += xf * xf + xg * xg;
		}
		if (sn >= 16823) {
			continue;
		}

		/* (f,g) must have an acceptable orthogonalized norm. */
		if (!check_ortho_norm(logn, f, g, tmp)) {
			continue;
		}

		/* Try to solve the NTRU equation. */
		if (!solve_NTRU(logn, f, g, tmp)) {
			continue;
		}

		/* solve_NTRU() ensured that f*G - g*F = q, and that all
		   coefficients of F and G are in [-127,+127]. sample_f()
		   already ensured that coefficients of f and g fit in
		   the expected number of bits. We do not have to check
		   these properties again. */

		/* We have F and G at the start of tmp. We encode the
		   private and public keys. */
		size_t j = 1;
		if (sign_key != NULL) {
			/* Encode header byte, f, g and F. */
			int8_t *F = tmp;
			uint8_t *buf = sign_key;
			buf[0] = 0x50 + logn;
			unsigned nbits;
			switch (logn) {
			case 2: case 3: case 4: case 5:
				nbits = 8;
				break;
			case 6: case 7:
				nbits = 7;
				break;
			case 8: case 9:
				nbits = 6;
				break;
			default:
				nbits = 5;
			}
			j += trim_i8_encode(logn, f, nbits, buf + j);
			j += trim_i8_encode(logn, g, nbits, buf + j);
			j += trim_i8_encode(logn, F, 8, buf + j);
			/* We still need the hash of the public key. */
		}

		/* If sign_key != NULL, then j is the offset in sign_key at
		which the public key hash (64 bytes) should be written. */

		if (sign_key != NULL || vrfy_key != NULL) {
			/* The signing key includes the hash of the
			   verifying key, so we need to compute that one
			   if either key must be returned.
			   We have already encoded f, g and F so we can
			   overwrite these values. */
			uint16_t *h = tmp;
			uint16_t *ft = h + n;
			mqpoly_small_to_int(logn, f, ft);
			mqpoly_small_to_int(logn, g, h);
			mqpoly_int_to_ntt(logn, ft);
			mqpoly_int_to_ntt(logn, h);
			mqpoly_div_ntt(logn, h, ft, ft + n);
			mqpoly_int_to_ext(logn, h);

			/* We encode the public key in the temporary area. */
			uint8_t *buf = (uint8_t *)ft;
			buf[0] = 0x00 + logn;
			size_t vklen = 1 + mqpoly_encode(logn, h, buf + 1);

			if (sign_key != NULL) {
				/* Since we obtained a key pair, we can reuse
				   the SHAKE context. */
				shake_init(&pc, 256);
				shake_inject(&pc, buf, vklen);
				shake_flip(&pc);
				shake_extract(&pc, (uint8_t *)sign_key + j, 64);
			}
			if (vrfy_key != NULL) {
				memcpy(vrfy_key, buf, vklen);
			}
		}
		break;
	}
}

static void
keygen_inner(unsigned logn, const void *seed, size_t seed_len,
    void *sign_key, void *vrfy_key, void *tmp)
{
    shake_context pc;
    shake_init(&pc, 256);
    shake_inject(&pc, seed, seed_len);
    shake_flip(&pc);
    keygen_inner_stream(logn, &pc, NULL, sign_key, vrfy_key, tmp);
}

size_t
fndsa_keygen_batch4_temp_size(unsigned blocks)
{
    return blocks > 128 ? 0 : 31 + 22*1024 + (size_t)4*136*blocks;
}

int
fndsa_keygen_seeded_batch4_temp(const fndsa_keygen_batch4_job jobs[4],
    unsigned blocks, void *work, size_t work_len)
{
    size_t need = fndsa_keygen_batch4_temp_size(blocks);
    if (jobs == NULL || work == NULL || need == 0 || work_len < need) return 0;
    for (unsigned lane = 0; lane < 4; lane++) {
        const fndsa_keygen_batch4_job *j = &jobs[lane];
        if (j->logn < 9 || j->logn > 10 || j->seed == NULL
            || (j->sign_key != NULL && j->sign_key_len < FNDSA_SIGN_KEY_SIZE(j->logn))
            || (j->vrfy_key != NULL && j->vrfy_key_len < FNDSA_VRFY_KEY_SIZE(j->logn))) return 0;
    }
    uint8_t *tmp = (void *)(((uintptr_t)work + 31) & ~(uintptr_t)31);
    uint8_t *buffer = tmp + 22*1024;
    fndsa_shake4_state state;
    fndsa_shake_iov v[4];
    const fndsa_shake_iov *vp[4];
    const size_t count[4] = {1,1,1,1};
    for (unsigned lane = 0; lane < 4; lane++) {
        v[lane] = (fndsa_shake_iov){jobs[lane].seed, jobs[lane].seed_len};
        vp[lane] = &v[lane];
    }
    fndsa_shake4_absorb(&state, vp, count);
    for (unsigned b = 0; b < blocks; b++) {
        fndsa_keccakx4_permute(state.a);
        fndsa_keccakx4_squeeze_separate(buffer + (size_t)b*136,
            state.a, blocks*136);
    }
    for (unsigned lane = 0; lane < 4; lane++) {
        shake_context pc;
        fndsa_shake4_export_lane(&state, lane, &pc);
        fndsa_shake_prefix prefix = {buffer + (size_t)lane*blocks*136,
            buffer + (size_t)(lane+1)*blocks*136};
        keygen_inner_stream(jobs[lane].logn, &pc, &prefix,
            jobs[lane].sign_key, jobs[lane].vrfy_key, tmp);
    }
    fndsa_batch4_clear(&state, sizeof state);
    return 1;
}

#if FNDSA_AVX2
TARGET_AVX2
static void
avx2_keygen_inner(unsigned logn, const void *seed, size_t seed_len,
	void *sign_key, void *vrfy_key, void *tmp)
{
	/* Ensure that tmp is 32-byte aligned. */
	tmp = (void *)(((uintptr_t)tmp + 31) & ~(uintptr_t)31);

	/* We allocate f and g at the end of the temporary area. */
	size_t n = (size_t)1 << logn;
	int8_t *f = (int8_t *)tmp + ((size_t)20 << logn);
	int8_t *g = f + n;

	/* Make a PRNG with the provided seed. */
	shake_context pc;
	shake_init(&pc, 256);
	shake_inject(&pc, seed, seed_len);
	shake_flip(&pc);
	for (;;) {
		/* Sample f, with odd parity. */
		sample_f(logn, &pc, f);

		/* If f is not invertible mod q, try again. */
		if (!avx2_mqpoly_is_invertible(logn, f, tmp)) {
			continue;
		}
		/* Note: invertibility check on f entailed converting f
		   to NTT. In order to save RAM, we do not keep NTT(f);
		   instead, we will recompute it at the end. The CPU
		   overhead is negligible, but the RAM saving is not (on
		   small microcontroller). */

		/* Sample g, also with odd parity. */
		sample_f(logn, &pc, g);

		/* Ensure that ||(g, -f)|| < 1.17*sqrt(q),
		   i.e. that ||(g, -f)||^2 < (1.17^2)*q = 16822.4121  */
		int32_t sn = 0;
		for (size_t i = 0; i < n; i ++) {
			int32_t xf = f[i];
			int32_t xg = g[i];
			sn += xf * xf + xg * xg;
		}
		if (sn >= 16823) {
			continue;
		}

		/* (f,g) must have an acceptable orthogonalized norm. */
		if (!avx2_check_ortho_norm(logn, f, g, tmp)) {
			continue;
		}

		/* Try to solve the NTRU equation. */
		if (!avx2_solve_NTRU(logn, f, g, tmp)) {
			continue;
		}

		/* solve_NTRU() ensured that f*G - g*F = q, and that all
		   coefficients of F and G are in [-127,+127]. sample_f()
		   already ensured that coefficients of f and g fit in
		   the expected number of bits. We do not have to check
		   these properties again. */

		/* We have F and G at the start of tmp. We encode the
		   private and public keys. */
		size_t j = 1;
		if (sign_key != NULL) {
			/* Encode header byte, f, g and F. */
			int8_t *F = tmp;
			uint8_t *buf = sign_key;
			buf[0] = 0x50 + logn;
			unsigned nbits;
			switch (logn) {
			case 2: case 3: case 4: case 5:
				nbits = 8;
				break;
			case 6: case 7:
				nbits = 7;
				break;
			case 8: case 9:
				nbits = 6;
				break;
			default:
				nbits = 5;
			}
			j += trim_i8_encode(logn, f, nbits, buf + j);
			j += trim_i8_encode(logn, g, nbits, buf + j);
			j += trim_i8_encode(logn, F, 8, buf + j);
			/* We still need the hash of the public key. */
		}

		/* If sign_key != NULL, then j is the offset in sign_key at
		which the public key hash (64 bytes) should be written. */

		if (sign_key != NULL || vrfy_key != NULL) {
			/* The signing key includes the hash of the
			   verifying key, so we need to compute that one
			   if either key must be returned.
			   We have already encoded f, g and F so we can
			   overwrite these values. */
			uint16_t *h = tmp;
			uint16_t *ft = h + n;
			avx2_mqpoly_small_to_int(logn, f, ft);
			avx2_mqpoly_small_to_int(logn, g, h);
			avx2_mqpoly_int_to_ntt(logn, ft);
			avx2_mqpoly_int_to_ntt(logn, h);
			avx2_mqpoly_div_ntt(logn, h, ft, ft + n);
			avx2_mqpoly_int_to_ext(logn, h);

			/* We encode the public key in the temporary area. */
			uint8_t *buf = (uint8_t *)ft;
			buf[0] = 0x00 + logn;
			size_t vklen = 1 + mqpoly_encode(logn, h, buf + 1);

			if (sign_key != NULL) {
				/* Since we obtained a key pair, we can reuse
				   the SHAKE context. */
				shake_init(&pc, 256);
				shake_inject(&pc, buf, vklen);
				shake_flip(&pc);
				shake_extract(&pc, (uint8_t *)sign_key + j, 64);
			}
			if (vrfy_key != NULL) {
				memcpy(vrfy_key, buf, vklen);
			}
		}
		break;
	}
}
#endif

/* Custom wrappers to allocate the temporary buffers on the stack. Several
   wrappers are defined so that stack allocation is not always worst-case. */
#if FNDSA_AVX2
#define KEYGEN_WRAP(sz)   \
	NOINLINE static void keygen_ ## sz(unsigned logn, \
		const void *seed, size_t seed_len, \
		void *sign_key, void *vrfy_key) \
	{ \
		uint8_t tmp[(sz) * 22 + 31]; \
		if (has_avx2()) { \
			avx2_keygen_inner(logn, \
				seed, seed_len, sign_key, vrfy_key, tmp); \
		} else { \
			keygen_inner(logn, \
				seed, seed_len, sign_key, vrfy_key, tmp); \
		} \
	}
#else
#define KEYGEN_WRAP(sz)   \
	NOINLINE static void keygen_ ## sz(unsigned logn, \
		const void *seed, size_t seed_len, \
		void *sign_key, void *vrfy_key) \
	{ \
		uint8_t tmp[(sz) * 22 + 31]; \
		keygen_inner(logn, seed, seed_len, sign_key, vrfy_key, tmp); \
	}
#endif

KEYGEN_WRAP(32)
KEYGEN_WRAP(64)
KEYGEN_WRAP(128)
KEYGEN_WRAP(256)
KEYGEN_WRAP(512)
KEYGEN_WRAP(1024)

static int
keygen(unsigned logn, const void *seed, size_t seed_len,
	void *sign_key, void *vrfy_key, void *tmp, size_t tmp_len)
{
	/* If no seed is provided, uses the system RNG to get a
	   32-byte seed. */
	uint8_t seedbuf[32];
	if (seed == NULL) {
		if (!sysrng(seedbuf, sizeof seedbuf)) {
			goto fail;
		}
		seed = seedbuf;
		seed_len = sizeof seedbuf;
	}

	if (tmp == NULL) {
		/* If no temporary area is provided, call the relevant
		   wrapper to allocate it on the stack. */
		switch (logn) {
		case 6:
			keygen_64(logn, seed, seed_len, sign_key, vrfy_key);
			break;
		case 7:
			keygen_128(logn, seed, seed_len, sign_key, vrfy_key);
			break;
		case 8:
			keygen_256(logn, seed, seed_len, sign_key, vrfy_key);
			break;
		case 9:
			keygen_512(logn, seed, seed_len, sign_key, vrfy_key);
			break;
		case 10:
			keygen_1024(logn, seed, seed_len, sign_key, vrfy_key);
			break;
		default:
			keygen_32(logn, seed, seed_len, sign_key, vrfy_key);
			break;
		}
	} else {
		/* Check that the provided temporary area is large enough.
		   We want 22*n bytes + enough room to ensure 32-byte
		   alignment. */
		if (tmp_len < (31 + ((size_t)22 << logn))) {
			goto fail;
		}
#if FNDSA_AVX2
		if (has_avx2()) {
			avx2_keygen_inner(logn, seed, seed_len,
				sign_key, vrfy_key, tmp);
		} else {
			keygen_inner(logn, seed, seed_len,
				sign_key, vrfy_key, tmp);
		}
#else
		keygen_inner(logn, seed, seed_len, sign_key, vrfy_key, tmp);
#endif
	}
	return 1;

fail:
	if (sign_key != NULL) {
		memset(sign_key, 0, FNDSA_SIGN_KEY_SIZE(logn));
	}
	if (vrfy_key != NULL) {
		memset(vrfy_key, 0, FNDSA_VRFY_KEY_SIZE(logn));
	}
	return 0;
}

/* see fndsa.h */
int
fndsa_keygen(unsigned logn, void *sign_key, void *vrfk_key)
{
	return keygen(logn, NULL, 0, sign_key, vrfk_key, NULL, 0);
}

/* see fndsa.h */
int
fndsa_keygen_temp(unsigned logn, void *sign_key, void *vrfk_key,
	void *tmp, size_t tmp_len)
{
	return keygen(logn, NULL, 0, sign_key, vrfk_key, tmp, tmp_len);
}

/* see fndsa.h */
void
fndsa_keygen_seeded(unsigned logn, const void *seed, size_t seed_len,
	void *sign_key, void *vrfk_key)
{
	(void)keygen(logn, seed, seed_len, sign_key, vrfk_key, NULL, 0);
}

/* see fndsa.h */
int
fndsa_keygen_seeded_temp(unsigned logn, const void *seed, size_t seed_len,
	void *sign_key, void *vrfk_key, void *tmp, size_t tmp_len)
{
	return keygen(logn, seed, seed_len, sign_key, vrfk_key, tmp, tmp_len);
}
