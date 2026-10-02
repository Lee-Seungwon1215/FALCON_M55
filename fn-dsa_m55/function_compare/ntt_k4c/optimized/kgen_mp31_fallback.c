#include "../original/mp_helpers.h"
#include "../bench/api.h"
#define FNDSA_MVE_MP31 1

void
opt_mp_NTT_c(unsigned logn, uint32_t *restrict a, const uint32_t *restrict gm,
	uint32_t p, uint32_t p0i)
{
	/*
	 * On small, non-superscalar platforms where memory accesses do
	 * not occur in parallel with computations, it is beneficial to
	 * perform two NTT layers at the same time, to reduce the number
	 * of memory accesses.
	 */

	if (logn == 0) {
		return;
	}
	if (logn == 1) {
		uint32_t s = gm[1];
		uint32_t x0 = a[0];
		uint32_t x1 = mp_mmul(a[1], s, p, p0i);
		a[0] = mp_add(x0, x1, p);
		a[1] = mp_sub(x0, x1, p);
		return;
	}
	size_t t;
	unsigned lm;

	if ((logn & 1) != 0) {
		t = (size_t)1 << (logn - 1);
		uint32_t s = gm[1];
		for (size_t i = 0; i < t; i ++) {
			uint32_t x0 = a[i];
			uint32_t x1 = mp_mmul(a[i + t], s, p, p0i);
			a[i] = mp_add(x0, x1, p);
			a[i + t] = mp_sub(x0, x1, p);
		}
		lm = 1;
	} else {
		t = (size_t)1 << logn;
		lm = 0;
	}

	for (; (lm + 3) < logn; lm += 2) {
		size_t m = (size_t)1 << lm;
		size_t ht = t >> 1;
		size_t qt = ht >> 1;
		size_t j0 = 0;
		for (size_t i = 0; i < m; i ++) {
			uint32_t s = gm[i + m];
			uint32_t s0 = gm[((i + m) << 1) + 0];
			uint32_t s1 = gm[((i + m) << 1) + 1];
			for (size_t j = 0; j < qt; j ++) {
				size_t k0 = j0 + j;
				size_t k1 = k0 + qt;
				size_t k2 = k0 + ht;
				size_t k3 = k0 + ht + qt;
				uint32_t x0 = a[k0];
				uint32_t x1 = a[k1];
				uint32_t x2 = a[k2];
				uint32_t x3 = a[k3];
				uint32_t tt;

				tt = mp_mmul(x2, s, p, p0i);
				x2 = mp_sub(x0, tt, p);
				x0 = mp_add(x0, tt, p);

				tt = mp_mmul(x3, s, p, p0i);
				x3 = mp_sub(x1, tt, p);
				x1 = mp_add(x1, tt, p);

				tt = mp_mmul(x1, s0, p, p0i);
				x1 = mp_sub(x0, tt, p);
				x0 = mp_add(x0, tt, p);

				tt = mp_mmul(x3, s1, p, p0i);
				x3 = mp_sub(x2, tt, p);
				x2 = mp_add(x2, tt, p);

				a[k0] = x0;
				a[k1] = x1;
				a[k2] = x2;
				a[k3] = x3;
			}
			j0 += t;
		}
		t = qt;
	}

	size_t m = (size_t)1 << (logn - 2);
	for (size_t i = 0; i < m; i ++) {
		uint32_t s = gm[i + m];
		uint32_t s0 = gm[((i + m) << 1) + 0];
		uint32_t s1 = gm[((i + m) << 1) + 1];
		uint32_t x0 = a[(i << 2) + 0];
		uint32_t x1 = a[(i << 2) + 1];
		uint32_t x2 = a[(i << 2) + 2];
		uint32_t x3 = a[(i << 2) + 3];
		uint32_t tt;

		tt = mp_mmul(x2, s, p, p0i);
		x2 = mp_sub(x0, tt, p);
		x0 = mp_add(x0, tt, p);

		tt = mp_mmul(x3, s, p, p0i);
		x3 = mp_sub(x1, tt, p);
		x1 = mp_add(x1, tt, p);

		tt = mp_mmul(x1, s0, p, p0i);
		x1 = mp_sub(x0, tt, p);
		x0 = mp_add(x0, tt, p);

		tt = mp_mmul(x3, s1, p, p0i);
		x3 = mp_sub(x2, tt, p);
		x2 = mp_add(x2, tt, p);

		a[(i << 2) + 0] = x0;
		a[(i << 2) + 1] = x1;
		a[(i << 2) + 2] = x2;
		a[(i << 2) + 3] = x3;
	}
}

void
opt_mp_iNTT_c(unsigned logn, uint32_t *restrict a, const uint32_t *restrict igm,
	uint32_t p, uint32_t p0i)
{
	if (logn == 0) {
		return;
	}
#if FNDSA_MVE_MP31
	/*
	 * Coefficient-exact C oracle and small-logn fallback for the full-root
	 * MVE contract.  Unlike the upstream half-root implementation below,
	 * the layers are unscaled; the common 1/n factor is applied once after
	 * the last layer.  Loop bounds and all addresses depend only on the
	 * public logn.
	 */
	{
		size_t n = (size_t)1 << logn;
		size_t t = 1;
		for (unsigned lm = 0; lm < logn; lm ++) {
			size_t hm = (size_t)1 << (logn - 1 - lm);
			size_t dt = t << 1;
			size_t j0 = 0;
			for (size_t i = 0; i < hm; i ++) {
				uint32_t s = igm[i + hm];
				for (size_t j = 0; j < t; j ++) {
					size_t k0 = j0 + j;
					size_t k1 = k0 + t;
					uint32_t x0 = a[k0];
					uint32_t x1 = a[k1];
					a[k0] = mp_add(x0, x1, p);
					a[k1] = mp_mmul(
						mp_sub(x0, x1, p), s, p, p0i);
				}
				j0 += dt;
			}
			t = dt;
		}
		uint32_t ni = (uint32_t)1 << (32 - logn);
		for (size_t i = 0; i < n; i ++) {
			a[i] = mp_mmul(a[i], ni, p, p0i);
		}
		return;
	}
#endif
	if (logn == 1) {
		uint32_t s = igm[1];
		uint32_t x0 = a[0];
		uint32_t x1 = a[1];
		a[0] = mp_half(mp_add(x0, x1, p), p);
		a[1] = mp_mmul(mp_sub(x0, x1, p), s, p, p0i);
		return;
	}

	size_t qn = (size_t)1 << (logn - 2);
	for (size_t i = 0; i < qn; i ++) {
		uint32_t s0 = igm[((i + qn) << 1) + 0];
		uint32_t s1 = igm[((i + qn) << 1) + 1];
		uint32_t s = igm[i + qn];

		uint32_t x0 = a[(i << 2) + 0];
		uint32_t x1 = a[(i << 2) + 1];
		uint32_t x2 = a[(i << 2) + 2];
		uint32_t x3 = a[(i << 2) + 3];
		uint32_t tt;

		tt = mp_sub(x0, x1, p);
		x0 = mp_half(mp_add(x0, x1, p), p);
		x1 = mp_mmul(tt, s0, p, p0i);

		tt = mp_sub(x2, x3, p);
		x2 = mp_half(mp_add(x2, x3, p), p);
		x3 = mp_mmul(tt, s1, p, p0i);

		tt = mp_sub(x0, x2, p);
		x0 = mp_half(mp_add(x0, x2, p), p);
		x2 = mp_mmul(tt, s, p, p0i);

		tt = mp_sub(x1, x3, p);
		x1 = mp_half(mp_add(x1, x3, p), p);
		x3 = mp_mmul(tt, s, p, p0i);

		a[(i << 2) + 0] = x0;
		a[(i << 2) + 1] = x1;
		a[(i << 2) + 2] = x2;
		a[(i << 2) + 3] = x3;
	}

	size_t t = 4;
	for (unsigned lm = 2; (lm + 1) < logn; lm += 2) {
		size_t hm = (size_t)1 << (logn - 1 - lm);
		size_t qm = hm >> 1;
		size_t dt = t << 1;
		size_t ft = t << 2;
		size_t j0 = 0;
		for (size_t i = 0; i < qm; i ++) {
			uint32_t s0 = igm[((i + qm) << 1) + 0];
			uint32_t s1 = igm[((i + qm) << 1) + 1];
			uint32_t s = igm[i + qm];
			for (size_t j = 0; j < t; j ++) {
				size_t k0 = j0 + j;
				size_t k1 = k0 + t;
				size_t k2 = k0 + dt;
				size_t k3 = k0 + t + dt;
				uint32_t x0 = a[k0];
				uint32_t x1 = a[k1];
				uint32_t x2 = a[k2];
				uint32_t x3 = a[k3];
				uint32_t tt;

				tt = mp_sub(x0, x1, p);
				x0 = mp_half(mp_add(x0, x1, p), p);
				x1 = mp_mmul(tt, s0, p, p0i);

				tt = mp_sub(x2, x3, p);
				x2 = mp_half(mp_add(x2, x3, p), p);
				x3 = mp_mmul(tt, s1, p, p0i);

				tt = mp_sub(x0, x2, p);
				x0 = mp_half(mp_add(x0, x2, p), p);
				x2 = mp_mmul(tt, s, p, p0i);

				tt = mp_sub(x1, x3, p);
				x1 = mp_half(mp_add(x1, x3, p), p);
				x3 = mp_mmul(tt, s, p, p0i);

				a[k0] = x0;
				a[k1] = x1;
				a[k2] = x2;
				a[k3] = x3;
			}
			j0 += ft;
		}
		t = ft;
	}

	if ((logn & 1) != 0) {
		size_t hn = (size_t)1 << (logn - 1);
		uint32_t s = igm[1];
		for (size_t i = 0; i < hn; i ++) {
			uint32_t x0 = a[i];
			uint32_t x1 = a[i + hn];
			a[i] = mp_half(mp_add(x0, x1, p), p);
			a[i + hn] = mp_mmul(mp_sub(x0, x1, p), s, p, p0i);
		}
	}
}
