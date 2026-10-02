/* New gathered layers against old per-group assembly, including all bytes
 * outside the touched ranges. Public sizes/offsets only; test code only. */
#include "api.h"
#include "triple_float.h"
#include <stdio.h>
#include <string.h>

static tw_fpr
root(uint64_t q)
{
	double x = (double)(int64_t)q * 0x1p-32;
	float h = (float)x, l = (float)(x - (double)h);
	return (tw_fpr){{h, l, (float)(x - (double)h - (double)l)}};
}

unsigned
ds32_tail_check(tw32_fft *work, tw32_fft *ref)
{
	tw_fpr real[256], imag[256];
	unsigned count = 0, fail = 0;
	uint32_t rng = 0x274895af;
	for (unsigned logn = 4; logn <= 10; logn ++) {
		for (unsigned ht = 1; ht <= 2; ht ++) {
			unsigned m = (1u << (logn-1))/ht;
			for (unsigned i = 0; i < m/2; i ++) {
				real[i] = root(tw_gm_q32[m+i][0]);
				imag[i] = root(tw_gm_q32[m+i][1]);
			}
			for (unsigned inv = 0; inv < 2; inv ++) {
				for (unsigned offset = 0; offset <= 1; offset ++) {
					unsigned blocks = 1u << (logn-4);
					if (offset && blocks > 1) blocks --;
					for (unsigned cls = 0; cls < 4; cls ++) {
						memset(work, 0x5A, sizeof *work);
						for (unsigned part = 0; part < 2; part ++) {
							float (*v)[TW32_NMAX/2] = part ? work->im : work->re;
							for (unsigned i = 0; i < TW32_NMAX/2; i ++) {
								rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5;
								double x = cls == 0 ? 0.0 : cls == 1 ? ((i&1) ? -1.0 : 1.0)
									: cls == 2 ? (double)(int32_t)rng * 0x1p-20
									: ((i&1) ? -0x1p20 : 0x1p20) + (double)(int32_t)rng * 0x1p-32;
								v[0][i] = (float)x;
								v[1][i] = (float)(x - (double)v[0][i]);
							}
						}
						memcpy(ref, work, sizeof *work);
						if (inv) ds32_tail_inv4(work->re[0]+offset, work->im[0]+offset,
							real, imag, TW32_NMAX/2*sizeof(float), blocks, ht);
						else ds32_tail_fwd4(work->re[0]+offset, work->im[0]+offset,
							real, imag, TW32_NMAX/2*sizeof(float), blocks, ht);
						for (unsigned group = 0; group < blocks*4/ht; group ++) {
							float x[4][2][4] = {{{0}}};
							float sr[2][4], si[2][4];
							unsigned j = offset + group*2*ht;
							for (unsigned k = 0; k < 2; k ++) {
								for (unsigned lane = 0; lane < 4; lane ++) {
									sr[k][lane] = real[group].x[k];
									si[k][lane] = inv ? -imag[group].x[k] : imag[group].x[k];
									if (lane < ht) {
										x[0][k][lane] = ref->re[k][j+lane];
										x[1][k][lane] = ref->im[k][j+lane];
										x[2][k][lane] = ref->re[k][j+ht+lane];
										x[3][k][lane] = ref->im[k][j+ht+lane];
									}
								}
							}
							if (inv) ds32_bfly_inv4(x[0][0], x[1][0], x[2][0], x[3][0],
								sr[0], si[0], 4*sizeof(float));
							else ds32_bfly_fwd4(x[0][0], x[1][0], x[2][0], x[3][0],
								sr[0], si[0], 4*sizeof(float));
							for (unsigned k = 0; k < 2; k ++) {
								for (unsigned lane = 0; lane < ht; lane ++) {
									ref->re[k][j+lane] = x[0][k][lane];
									ref->im[k][j+lane] = x[1][k][lane];
									ref->re[k][j+ht+lane] = x[2][k][lane];
									ref->im[k][j+ht+lane] = x[3][k][lane];
								}
							}
						}
						count ++;
						unsigned bad = memcmp(work, ref, sizeof *work) != 0;
						if (bad && fail < 4) printf("DS_TAIL_BAD logn=%u ht=%u inv=%u offset=%u class=%u\n",
							logn, ht, inv, offset, cls);
						fail += bad;
					}
				}
			}
		}
	}
	printf("DS_TAIL_EQ cases=%u mismatches=%u comparison=ALL_BYTES\n", count, fail);
	return fail;
}
