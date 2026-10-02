#include "api.h"
#include "triple_float.h"

#include <arm_mve.h>
#include <string.h>

/* Four independent triple-float values, one value per MVE lane. */
typedef struct {
	float c[3][4];
} tw4;

/* Conversion from the exact Q32 roots is invariant across all transforms. */
static tw_fpr gm_re[TW32_NMAX];
static tw_fpr gm_im[TW32_NMAX];

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
tw32_init_twiddles(void)
{
	for (size_t u = 0; u < TW32_NMAX; u ++) {
		gm_re[u] = q32_tw(tw_gm_q32[u][0]);
		gm_im[u] = q32_tw(tw_gm_q32[u][1]);
	}
}

static void
add4(tw4 *d, const tw4 *a, const tw4 *b)
{
	tw32_add4_full(&d->c[0][0], &a->c[0][0], &b->c[0][0]);
}

static void
sub4(tw4 *d, const tw4 *a, const tw4 *b)
{
	tw32_sub4_full(&d->c[0][0], &a->c[0][0], &b->c[0][0]);
}

static void
addsub4(tw4 *sum, tw4 *diff, const tw4 *a, const tw4 *b)
{
	tw32_addsub4_full(&sum->c[0][0], &diff->c[0][0],
		&a->c[0][0], &b->c[0][0]);
}

/* TWFalcon fast product: three exact leading products plus second-order terms. */
static void
mul4(tw4 *d, const tw4 *a, const tw4 *b)
{
	tw32_mul4_full(&d->c[0][0], &a->c[0][0], &b->c[0][0]);
}

void
tw32_debug_add4(float d[3][4], const float a[3][4], const float b[3][4])
{
	add4((tw4 *)d, (const tw4 *)a, (const tw4 *)b);
}

void
tw32_debug_mul4(float d[3][4], const float a[3][4], const float b[3][4])
{
	mul4((tw4 *)d, (const tw4 *)a, (const tw4 *)b);
}

static void
cmul4(tw4 *rr, tw4 *ri, const tw4 *ar, const tw4 *ai,
	const tw4 *br, const tw4 *bi)
{
	tw32_cmul4_full(&rr->c[0][0], &ri->c[0][0],
		&ar->c[0][0], &ai->c[0][0], &br->c[0][0], &bi->c[0][0]);
}

void
tw32_debug_cmul4(float dr[3][4], float di[3][4],
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
tw32_fft_mve(unsigned logn, tw32_fft *f)
{
	size_t hn=(size_t)1<<(logn-1), t=hn;
	for (unsigned lm=1;lm<logn;lm++) {
		size_t m=(size_t)1<<lm, ht=t>>1, j0=0;
		for (size_t i=0;i<(m>>1);i++) {
			tw_fpr sr1=gm_re[m+i];
			tw_fpr si1=gm_im[m+i];
			tw4 sr,si; splat4(&sr,sr1); splat4(&si,si1);
			size_t j=j0;
			for (;j+4<=j0+ht;j+=4) {
				tw4 xr,xi,yr,yi,zr,zi,ap,am;
				load4(&xr,f->re,j); load4(&xi,f->im,j);
				load4(&yr,f->re,j+ht); load4(&yi,f->im,j+ht);
				cmul4(&zr,&zi,&yr,&yi,&sr,&si);
				addsub4(&ap,&am,&xr,&zr);
				store4(f->re,j,&ap); store4(f->re,j+ht,&am);
				addsub4(&ap,&am,&xi,&zi);
				store4(f->im,j,&ap); store4(f->im,j+ht,&am);
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
tw32_ifft_mve(unsigned logn, tw32_fft *f)
{
	size_t ht=1;
	for (unsigned lm=logn-1;lm>0;lm--) {
		size_t m=(size_t)1<<lm,t=ht<<1,j0=0;
		for (size_t i=0;i<(m>>1);i++) {
			tw_fpr sr1=gm_re[m+i];
			tw_fpr si1=neg1(gm_im[m+i]);
			tw4 sr,si; splat4(&sr,sr1); splat4(&si,si1);
			size_t j=j0;
			for (;j+4<=j0+ht;j+=4) {
				tw4 xr,xi,yr,yi,sumr,diffr,sumi,diffi,zr,zi;
				load4(&xr,f->re,j); load4(&xi,f->im,j);
				load4(&yr,f->re,j+ht); load4(&yi,f->im,j+ht);
				addsub4(&sumr,&diffr,&xr,&yr);
				addsub4(&sumi,&diffi,&xi,&yi);
				half4(&sumr); half4(&diffr); half4(&sumi); half4(&diffi);
				store4(f->re,j,&sumr); store4(f->im,j,&sumi);
				cmul4(&zr,&zi,&diffr,&diffi,&sr,&si);
				store4(f->re,j+ht,&zr); store4(f->im,j+ht,&zi);
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
