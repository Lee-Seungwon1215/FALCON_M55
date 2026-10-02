/*
 * Gaussian generation of (f,g)
 */

#include "kgen_inner.h"
#include "shake_independent4.h"

/* q = 12289, n = 512 */
static const uint16_t KGDist_512[] = {
	29543, 23286, 17574, 12669,  8706,  5692,  3535,  2083,  1164,
	  615,   308,   146,    65,    28,    11,     4,     1
};

/* q = 12289, n = 1024 */
static const uint16_t KGDist_1024[] = {
	28207, 19623, 12472,  7198,  3753,  1761,
	  742,   280,    94,    28,     8,     2
};

/* Interleave independent candidate generation, not their random bytes.
 * This gives rolling x4 refills useful work in all unfinished lanes while
 * retaining the original table, sign bit and last-coefficient parity rule. */
void
fndsa_sample_f_x4(const unsigned logn[4], fndsa_shake4_stream *s,
    int8_t *out[4], unsigned mask)
{
    size_t pos[4] = {0};
    unsigned parity[4] = {0};
    while (mask) {
        for (unsigned lane = 0; lane < 4; lane++) {
            if (!(mask & (1u << lane))) continue;
            const uint16_t *tab = logn[lane] == 10 ? KGDist_1024 : KGDist_512;
            size_t tlen = logn[lane] == 10 ? 12 : 17;
            size_t n = (size_t)1 << logn[lane];
            /* Process at most one rate block's worth before switching lanes.
             * Keep table and polynomial metadata outside the sample loop. */
            for (unsigned chunk = 0; chunk < 68 && pos[lane] < n; chunk++) {
                uint32_t u = fndsa_shake4_stream_u16(s, lane), v = u >> 1;
                uint32_t a = 0;
                for (size_t j = 0; j < tlen; j++)
                    a -= (v - (uint32_t)tab[j]) & ~(uint32_t)0xffff;
                a -= (a << 1) & -(u & 1);
                int32_t ai = (int32_t)a >> 16;
                if (ai < -127 || ai > 127) continue;
                if (pos[lane] == n-1 && ((parity[lane] ^ (uint32_t)ai) & 1) != 1)
                    continue;
                out[lane][pos[lane]++] = (int8_t)ai;
                parity[lane] ^= (uint32_t)ai;
            }
            if (pos[lane] == n) mask &= ~(1u << lane);
        }
    }
}

/* Batch reader below shares these exact tables and the original parity rule.
 * The original single reader is kept intact to avoid per-sample dispatch. */
void
fndsa_sample_f_prefetched(unsigned logn, shake_context *pc,
    fndsa_shake_prefix *prefix, int8_t *f)
{
	size_t n = (size_t)1 << logn;

	/*
	 * Sampling uses a lookup table, defined for degrees 512 and 1024.
	 * For degree n lower than 512, we use the degree-512 table but
	 * add 512/n sampled values together.
	 */
	const uint16_t *tab;
	size_t tab_len;
	unsigned zz;
	if (logn == 10) {
		tab = KGDist_1024;
		tab_len = (sizeof KGDist_1024) / sizeof(uint16_t);
		zz = 1;
	} else {
		tab = KGDist_512;
		tab_len = (sizeof KGDist_512) / sizeof(uint16_t);
		zz = 1u << (9 - logn);
	}

	/* We sample each value once, except the last one, which is
	   sampled repeatedly until it has the right parity (so that
	   the complete polynomial has odd parity). */
	unsigned parity = 0;
	for (size_t i = 0; i < n; i ++) {
		/* Sample the value as an unsigned 32-bit word. */
		uint32_t aa = 0;
		for (unsigned t = 0; t < zz; t ++) {
			uint32_t u;
            if (prefix->next != prefix->end) {
                /* Prefix and reads are both multiples of two: no tail discard. */
                u = prefix->next[0] | ((uint32_t)prefix->next[1] << 8);
                prefix->next += 2;
            } else {
                u = shake_next_u16(pc);
            }
			uint32_t v = u >> 1;
			/* We add 2^16 to a for each table element which
			   is greater than v. */
			uint32_t a = 0;
			for (size_t j = 0; j < tab_len; j ++) {
				a -= (v - (uint32_t)tab[j])
					& ~(uint32_t)0xFFFF;
			}
			/* We apply the sign bit (lsb of u). */
			a -= (a << 1) & -(u & 1);
			aa += a;
		}

		/* Sampled value was obtained in the top 16 bits of aa;
		   we shift that back to the low 16 bits, with sign
		   extension. */
		int32_t ai = *(int32_t *)&aa >> 16;

		/* At low (test) degrees, it may happen that the value
		   is not in [-127,+127], which we do not tolerate since
		   that does not fit in the APIs and storage format. */
		if (ai < -127 || ai > +127) {
			i --;
			continue;
		}
		f[i] = (int8_t)ai;

		/* For the last element, we insist on an odd parity for the
		   complete polynomial, and resample the value if needed. */
		if (i == (n - 1)) {
			if (((parity ^ (uint32_t)ai) & 1) != 1) {
				i --;
				continue;
			}
		} else {
			parity ^= (uint32_t)ai;
		}
	}
}

/* see kgen_inner.h */
void
sample_f(unsigned logn, shake_context *pc, int8_t *f)
{
	size_t n = (size_t)1 << logn;

	/*
	 * Sampling uses a lookup table, defined for degrees 512 and 1024.
	 * For degree n lower than 512, we use the degree-512 table but
	 * add 512/n sampled values together.
	 */
	const uint16_t *tab;
	size_t tab_len;
	unsigned zz;
	if (logn == 10) {
		tab = KGDist_1024;
		tab_len = (sizeof KGDist_1024) / sizeof(uint16_t);
		zz = 1;
	} else {
		tab = KGDist_512;
		tab_len = (sizeof KGDist_512) / sizeof(uint16_t);
		zz = 1u << (9 - logn);
	}

	/* We sample each value once, except the last one, which is
	   sampled repeatedly until it has the right parity (so that
	   the complete polynomial has odd parity). */
	unsigned parity = 0;
	for (size_t i = 0; i < n; i ++) {
		/* Sample the value as an unsigned 32-bit word. */
		uint32_t aa = 0;
		for (unsigned t = 0; t < zz; t ++) {
			uint32_t u = shake_next_u16(pc);
			uint32_t v = u >> 1;
			/* We add 2^16 to a for each table element which
			   is greater than v. */
			uint32_t a = 0;
			for (size_t j = 0; j < tab_len; j ++) {
				a -= (v - (uint32_t)tab[j])
					& ~(uint32_t)0xFFFF;
			}
			/* We apply the sign bit (lsb of u). */
			a -= (a << 1) & -(u & 1);
			aa += a;
		}

		/* Sampled value was obtained in the top 16 bits of aa;
		   we shift that back to the low 16 bits, with sign
		   extension. */
		int32_t ai = *(int32_t *)&aa >> 16;

		/* At low (test) degrees, it may happen that the value
		   is not in [-127,+127], which we do not tolerate since
		   that does not fit in the APIs and storage format. */
		if (ai < -127 || ai > +127) {
			i --;
			continue;
		}
		f[i] = (int8_t)ai;

		/* For the last element, we insist on an odd parity for the
		   complete polynomial, and resample the value if needed. */
		if (i == (n - 1)) {
			if (((parity ^ (uint32_t)ai) & 1) != 1) {
				i --;
				continue;
			}
		} else {
			parity ^= (uint32_t)ai;
		}
	}
}
