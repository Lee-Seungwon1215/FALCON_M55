/* Frozen original poly_big_to_fixed; test-only, never a crypto backend. */
static __attribute__((noipa)) void
oracle_fixed_input(unsigned logn, fxr *restrict d, const uint32_t *restrict f,
	size_t len, uint32_t sc)
{
	size_t n = (size_t)1 << logn;
	if (len == 0) {
		memset(d, 0, n * sizeof *d);
		return;
	}

	/*
	 * We split the bit length into sch and scl such that:
	 *   sc = 31*sch + scl
	 * We also want scl in the 1..31 range, not 0..30. It may happen
	 * that sch becomes -1, which will "wrap around" (harmlessly).
	 *
	 * For each coefficient, we need three words, each with a given
	 * left shift (negative for a right shift):
	 *    sch-1   1 - scl
	 *    sch     32 - scl
	 *    sch+1   63 - scl
	 */
	uint32_t sch, scl;
	DIVREM31(sch, scl, sc);
	uint32_t z = (scl - 1) >> 31;
	sch -= z;
	scl |= 31 & -z;

	uint32_t t0 = (uint32_t)(sch - 1) & 0xFFFFFF;
	uint32_t t1 = sch & 0xFFFFFF;
	uint32_t t2 = (uint32_t)(sch + 1) & 0xFFFFFF;

	for (size_t i = 0; i < n; i ++, f ++) {
		uint32_t w0, w1, w2, ws, xl, xh;

		w0 = 0;
		w1 = 0;
		w2 = 0;
		for (size_t j = 0; j < len; j ++) {
			uint32_t t, w;

			w = f[j << logn];
			t = (uint32_t)j & 0xFFFFFF;
			w0 |= w & -((uint32_t)((t ^ t0) - 1) >> 31);
			w1 |= w & -((uint32_t)((t ^ t1) - 1) >> 31);
			w2 |= w & -((uint32_t)((t ^ t2) - 1) >> 31);
		}

		/*
		 * If there were not enough words for the requested
		 * scaling, then we must supply copies with the proper
		 * sign.
		 */
		ws = -(f[(len - 1) << logn] >> 30) >> 1;
		w0 |= ws & -((uint32_t)((uint32_t)len - sch) >> 31);
		w1 |= ws & -((uint32_t)((uint32_t)len - sch - 1) >> 31);
		w2 |= ws & -((uint32_t)((uint32_t)len - sch - 2) >> 31);

		/*
		 * Assemble the 64-bit value with the shifts. We assume
		 * that shifts on 32-bit values are constant-time with
		 * regard to the shift count (this should be true on all
		 * modern architectures; the last notable arch on which
		 * shift timing depended on the count was the Pentium IV).
		 *
		 * Since the shift count (scl) is guaranteed to be in 1..31,
		 * we do not have special cases to handle.
		 *
		 * We must sign-extend w2 to ensure the sign bit is properly
		 * set in the fnr value.
		 */
		w2 |= (uint32_t)(w2 & 0x40000000) << 1;
		xl = (w0 >> (scl - 1)) | (w1 << (32 - scl));
		xh = (w1 >> scl) | (w2 << (31 - scl));
		d[i] = fxr_of_scaled32((uint64_t)xl | ((uint64_t)xh << 32));
	}
}
