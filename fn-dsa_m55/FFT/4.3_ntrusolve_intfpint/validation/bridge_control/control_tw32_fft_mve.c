#include "control_tw32_api.h"
#include "control_tw32_gm_ds32.h"

#include <arm_mve.h>
#include <string.h>

/* Four independent triple-float values, one value per MVE lane. */
typedef struct {
	float c[3][4];
} tw4;

typedef struct {
	float c[2][4];
} ds4;

static inline void
load4(tw4 *d, const float p[3][TW32_NMAX / 2], size_t i)
{
	for (unsigned k = 0; k < 3; k ++) {
		memcpy(d->c[k], p[k] + i, sizeof d->c[k]);
	}
}

static inline void
store4(float p[3][TW32_NMAX / 2], size_t i, const tw4 *s)
{
	for (unsigned k = 0; k < 3; k ++) {
		memcpy(p[k] + i, s->c[k], sizeof s->c[k]);
	}
}

/*
 * The final forward layers (and first inverse layers) contain only one or
 * two butterflies.  Keep their arithmetic on MVE as well: inactive lanes
 * are zero-filled and never stored.  The lane count depends only on logn and
 * the public loop indices.
 */
static inline void
load4_tail(tw4 *d, const float p[3][TW32_NMAX / 2], size_t i,
	unsigned lanes)
{
	mve_pred16_t pred = vctp32q(lanes);
	for (unsigned k = 0; k < 3; k ++) {
		vst1q_f32(d->c[k], vld1q_z_f32(p[k] + i, pred));
	}
}

static inline void
store4_tail(float p[3][TW32_NMAX / 2], size_t i, const tw4 *s,
	unsigned lanes)
{
	mve_pred16_t pred = vctp32q(lanes);
	for (unsigned k = 0; k < 3; k ++) {
		vst1q_p_f32(p[k] + i, vld1q_f32(s->c[k]), pred);
	}
}

static inline void
splat4(tw4 *d, tw_fpr x)
{
	for (unsigned k = 0; k < 3; k ++) {
		for (unsigned u = 0; u < 4; u ++) d->c[k][u] = x.x[k];
	}
}

static inline tw_fpr
q32_tw(uint64_t x)
{
	double d = (double)(int64_t)x * 0x1p-32;
	float h = (float)d;
	float m = (float)(d - (double)h);
	return (tw_fpr){{ h, m, (float)(d - (double)h - (double)m) }};
}

void
control_tw32_init_twiddles(void)
{
	/* DS roots are checked-in constants; no lazy initialization or conversion. */
}

static void
add4(tw4 *d, const tw4 *a, const tw4 *b)
{
	control_tw32_add4_full(&d->c[0][0], &a->c[0][0], &b->c[0][0]);
}

static void
sub4(tw4 *d, const tw4 *a, const tw4 *b)
{
	control_tw32_sub4_full(&d->c[0][0], &a->c[0][0], &b->c[0][0]);
}

static void
addsub4(tw4 *sum, tw4 *diff, const tw4 *a, const tw4 *b)
{
	control_tw32_addsub4_full(&sum->c[0][0], &diff->c[0][0],
		&a->c[0][0], &b->c[0][0]);
}

/* TWFalcon fast product: three exact leading products plus second-order terms. */
static void
mul4(tw4 *d, const tw4 *a, const tw4 *b)
{
	control_tw32_mul4_full(&d->c[0][0], &a->c[0][0], &b->c[0][0]);
}

void
control_tw32_debug_add4(float d[3][4], const float a[3][4], const float b[3][4])
{
	add4((tw4 *)d, (const tw4 *)a, (const tw4 *)b);
}

void
control_tw32_debug_mul4(float d[3][4], const float a[3][4], const float b[3][4])
{
	mul4((tw4 *)d, (const tw4 *)a, (const tw4 *)b);
}

static void
cmul4(tw4 *rr, tw4 *ri, const tw4 *ar, const tw4 *ai,
	const tw4 *br, const tw4 *bi)
{
	control_tw32_cmul4_full(&rr->c[0][0], &ri->c[0][0],
		&ar->c[0][0], &ai->c[0][0], &br->c[0][0], &bi->c[0][0]);
}

void
control_tw32_debug_cmul4(float dr[3][4], float di[3][4],
	const float ar[3][4], const float ai[3][4],
	const float br[3][4], const float bi[3][4])
{
	cmul4((tw4 *)dr, (tw4 *)di, (const tw4 *)ar, (const tw4 *)ai,
		(const tw4 *)br, (const tw4 *)bi);
}

static void
half4(tw4 *d)
{
	for (unsigned k = 0; k < 3; k ++) {
		for (unsigned u = 0; u < 4; u ++) d->c[k][u] *= 0.5f;
	}
}

static inline tw_fpr
load1(const float p[3][TW32_NMAX / 2], size_t i)
{
	return (tw_fpr){{ p[0][i], p[1][i], p[2][i] }};
}

static inline void
store1(float p[3][TW32_NMAX / 2], size_t i, tw_fpr x)
{
	p[0][i]=x.x[0]; p[1][i]=x.x[1]; p[2][i]=x.x[2];
}

static inline tw_fpr
neg1(tw_fpr x)
{
	return (tw_fpr){{-x.x[0],-x.x[1],-x.x[2]}};
}

static inline tw_fpr
half1(tw_fpr x)
{
	return (tw_fpr){{x.x[0]*0.5f,x.x[1]*0.5f,x.x[2]*0.5f}};
}

static void
cmul1(tw_fpr ar, tw_fpr ai, tw_fpr br, tw_fpr bi, tw_fpr *rr, tw_fpr *ri)
{
	tw_fpr p0=tw_prod_fast_ct(ar,br), p1=tw_prod_fast_ct(ai,bi);
	tw_fpr p2=tw_prod_fast_ct(ar,bi), p3=tw_prod_fast_ct(ai,br);
	*rr=tw_sum_ct(p0,neg1(p1)); *ri=tw_sum_ct(p2,p3);
}

void
control_tw32_fft_mve(unsigned logn, control_tw32_fft *f)
{
	size_t hn=(size_t)1<<(logn-1), t=hn;
	for (unsigned lm=1;lm<logn;lm++) {
		size_t m=(size_t)1<<lm, ht=t>>1, j0=0;
		for (size_t i=0;i<(m>>1);i++) {
			tw_fpr sr1=q32_tw(control_tw_gm_q32[m+i][0]);
			tw_fpr si1=q32_tw(control_tw_gm_q32[m+i][1]);
			tw4 sr,si; splat4(&sr,sr1); splat4(&si,si1);
			size_t j=j0;
			for (;j+4<=j0+ht;j+=4) {
				control_tw32_bfly_fwd4(f->re[0]+j, f->im[0]+j,
					f->re[0]+j+ht, f->im[0]+j+ht,
					&sr.c[0][0], &si.c[0][0]);
			}
			if (j < j0 + ht) {
				unsigned lanes = (unsigned)(j0 + ht - j);
				tw4 xr,xi,yr,yi,zr,zi,ap,am;
				load4_tail(&xr,f->re,j,lanes); load4_tail(&xi,f->im,j,lanes);
				load4_tail(&yr,f->re,j+ht,lanes); load4_tail(&yi,f->im,j+ht,lanes);
				cmul4(&zr,&zi,&yr,&yi,&sr,&si);
				addsub4(&ap,&am,&xr,&zr);
				store4_tail(f->re,j,&ap,lanes);
				store4_tail(f->re,j+ht,&am,lanes);
				addsub4(&ap,&am,&xi,&zi);
				store4_tail(f->im,j,&ap,lanes);
				store4_tail(f->im,j+ht,&am,lanes);
			}
			j0+=t;
		}
		t=ht;
	}
}

void
control_tw32_ifft_mve(unsigned logn, control_tw32_fft *f)
{
	size_t ht=1;
	for (unsigned lm=logn-1;lm>0;lm--) {
		size_t m=(size_t)1<<lm,t=ht<<1,j0=0;
		for (size_t i=0;i<(m>>1);i++) {
			tw_fpr sr1=q32_tw(control_tw_gm_q32[m+i][0]);
			tw_fpr si1=neg1(q32_tw(control_tw_gm_q32[m+i][1]));
			tw4 sr,si; splat4(&sr,sr1); splat4(&si,si1);
			size_t j=j0;
			for (;j+4<=j0+ht;j+=4) {
				control_tw32_bfly_inv4(f->re[0]+j, f->im[0]+j,
					f->re[0]+j+ht, f->im[0]+j+ht,
					&sr.c[0][0], &si.c[0][0]);
			}
			if (j < j0 + ht) {
				unsigned lanes = (unsigned)(j0 + ht - j);
				tw4 xr,xi,yr,yi,sumr,diffr,sumi,diffi,zr,zi;
				load4_tail(&xr,f->re,j,lanes); load4_tail(&xi,f->im,j,lanes);
				load4_tail(&yr,f->re,j+ht,lanes); load4_tail(&yi,f->im,j+ht,lanes);
				addsub4(&sumr,&diffr,&xr,&yr);
				addsub4(&sumi,&diffi,&xi,&yi);
				half4(&sumr); half4(&diffr); half4(&sumi); half4(&diffi);
				store4_tail(f->re,j,&sumr,lanes);
				store4_tail(f->im,j,&sumi,lanes);
				cmul4(&zr,&zi,&diffr,&diffi,&sr,&si);
				store4_tail(f->re,j+ht,&zr,lanes);
				store4_tail(f->im,j+ht,&zi,lanes);
			}
			j0+=t;
		}
		ht=t;
	}
}

static inline void
ds_splat4(ds4 *d, tw_fpr x)
{
	for (unsigned k = 0; k < 2; k ++) {
		for (unsigned u = 0; u < 4; u ++) d->c[k][u] = x.x[k];
	}
}

static inline void
ds_load_tail(ds4 *d, const float p[3][TW32_NMAX / 2], size_t i,
	unsigned lanes)
{
	mve_pred16_t pred = vctp32q(lanes);
	for (unsigned k = 0; k < 2; k ++) {
		vst1q_f32(d->c[k], vld1q_z_f32(p[k] + i, pred));
	}
}

static inline void
ds_store_tail(float p[3][TW32_NMAX / 2], size_t i, const ds4 *s,
	unsigned lanes)
{
	mve_pred16_t pred = vctp32q(lanes);
	for (unsigned k = 0; k < 2; k ++) {
		vst1q_p_f32(p[k] + i, vld1q_f32(s->c[k]), pred);
	}
}

/*
 * Apply the packed inverse-FFT normalization once, after all inverse
 * butterflies.  The scale is 2/n and therefore an exact binary power of
 * two; for the value range used by FN-DSA, moving this operation out of the
 * individual layers does not introduce an additional rounding step.
 */
static void
ds_final_scale(unsigned logn, control_tw32_fft *f)
{
	size_t hn = (size_t)1 << (logn - 1);
	union {
		uint32_t u;
		float f;
	} sc = { (uint32_t)(128u - logn) << 23 };
	float32x4_t vs = vdupq_n_f32(sc.f);
	for (unsigned k = 0; k < 2; k ++) {
		for (unsigned part = 0; part < 2; part ++) {
			float *p = part == 0 ? f->re[k] : f->im[k];
			size_t i = 0;
			for (; i + 4 <= hn; i += 4) {
				vst1q_f32(p + i, vmulq_f32(vld1q_f32(p + i), vs));
			}
			if (i < hn) {
				mve_pred16_t pred = vctp32q((unsigned)(hn - i));
				float32x4_t x = vld1q_z_f32(p + i, pred);
				vst1q_p_f32(p + i, vmulq_f32(x, vs), pred);
			}
		}
	}
}

/* The two small layers read preconverted roots directly. Keep the existing
 * triple-stride assembly ABI (the third float is zero padding), and remove
 * the old 6 KiB temporary stack table and per-call conversion loop.
 */
static void __attribute__((noinline))
ds_packed_tail(unsigned logn, control_tw32_fft *f, unsigned m, unsigned ht,
	unsigned inverse)
{
	const tw_fpr *real = control_tw_gm_ds32_re + m;
	const tw_fpr *imag = control_tw_gm_ds32_im + m;
	if (inverse) control_ds32_tail_inv4(f->re[0], f->im[0], real, imag,
		TW32_NMAX/2*sizeof(float), 1u << (logn-4), ht);
	else control_ds32_tail_fwd4(f->re[0], f->im[0], real, imag,
		TW32_NMAX/2*sizeof(float), 1u << (logn-4), ht);
}

void
control_ds32_fft_mve(unsigned logn, control_tw32_fft *f)
{
	size_t hn = (size_t)1 << (logn - 1), t = hn;
	for (unsigned lm = 1; lm < logn; lm ++) {
		size_t m = (size_t)1 << lm, ht = t >> 1, j0 = 0;
		/* Pack across groups when fewer than four lanes are available. */
		if (ht <= 2 && logn >= 4) {
			ds_packed_tail(logn, f, (unsigned)m, (unsigned)ht, 0);
		} else {
			for (size_t i = 0; i < (m >> 1); i ++) {
				ds4 sr, si;
				ds_splat4(&sr, control_tw_gm_ds32_re[m + i]);
				ds_splat4(&si, control_tw_gm_ds32_im[m + i]);
				size_t j = j0;
				unsigned blocks = (unsigned)((j0 + ht - j) >> 2);
				if (blocks != 0) {
					control_ds32_bfly_fwd4_span(f->re[0] + j, f->im[0] + j,
						f->re[0] + j + ht, f->im[0] + j + ht,
						&sr.c[0][0], &si.c[0][0],
						TW32_NMAX / 2 * sizeof(float), blocks);
					j += (size_t)blocks << 2;
				}
				if (j < j0 + ht) {
					unsigned lanes = (unsigned)(j0 + ht - j);
					ds4 xr, xi, yr, yi;
					ds_load_tail(&xr, f->re, j, lanes);
					ds_load_tail(&xi, f->im, j, lanes);
					ds_load_tail(&yr, f->re, j + ht, lanes);
					ds_load_tail(&yi, f->im, j + ht, lanes);
					control_ds32_bfly_fwd4(&xr.c[0][0], &xi.c[0][0],
						&yr.c[0][0], &yi.c[0][0],
						&sr.c[0][0], &si.c[0][0], 4 * sizeof(float));
					ds_store_tail(f->re, j, &xr, lanes);
					ds_store_tail(f->im, j, &xi, lanes);
					ds_store_tail(f->re, j + ht, &yr, lanes);
					ds_store_tail(f->im, j + ht, &yi, lanes);
				}
				j0 += t;
			}
		}
		t = ht;
	}
}

void
control_ds32_ifft_mve(unsigned logn, control_tw32_fft *f)
{
	size_t ht = 1;
	for (unsigned lm = logn - 1; lm > 0; lm --) {
		size_t m = (size_t)1 << lm, t = ht << 1, j0 = 0;
		/* Pack across groups when fewer than four lanes are available. */
		if (ht <= 2 && logn >= 4) {
			ds_packed_tail(logn, f, (unsigned)m, (unsigned)ht, 1);
		} else {
			for (size_t i = 0; i < (m >> 1); i ++) {
				tw_fpr sri = control_tw_gm_ds32_re[m + i];
				tw_fpr sii = neg1(control_tw_gm_ds32_im[m + i]);
				ds4 sr, si;
				ds_splat4(&sr, sri);
				ds_splat4(&si, sii);
				size_t j = j0;
				unsigned blocks = (unsigned)((j0 + ht - j) >> 2);
				if (blocks != 0) {
					control_ds32_bfly_inv4_span(f->re[0] + j, f->im[0] + j,
						f->re[0] + j + ht, f->im[0] + j + ht,
						&sr.c[0][0], &si.c[0][0],
						TW32_NMAX / 2 * sizeof(float), blocks);
					j += (size_t)blocks << 2;
				}
				if (j < j0 + ht) {
					unsigned lanes = (unsigned)(j0 + ht - j);
					ds4 xr, xi, yr, yi;
					ds_load_tail(&xr, f->re, j, lanes);
					ds_load_tail(&xi, f->im, j, lanes);
					ds_load_tail(&yr, f->re, j + ht, lanes);
					ds_load_tail(&yi, f->im, j + ht, lanes);
					control_ds32_bfly_inv4(&xr.c[0][0], &xi.c[0][0],
						&yr.c[0][0], &yi.c[0][0],
						&sr.c[0][0], &si.c[0][0], 4 * sizeof(float));
					ds_store_tail(f->re, j, &xr, lanes);
					ds_store_tail(f->im, j, &xi, lanes);
					ds_store_tail(f->re, j + ht, &yr, lanes);
					ds_store_tail(f->im, j + ht, &yi, lanes);
				}
				j0 += t;
			}
		}
		ht = t;
	}
	ds_final_scale(logn, f);
}
