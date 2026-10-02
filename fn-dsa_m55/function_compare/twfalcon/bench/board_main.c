#include "api.h"
#include "../tests/ds32_layer_profile.h"

#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdbool.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include "triple_float.h"

#define BATCHES 10
#define CALLS 100
#define CANARY_WORDS 8
#define CANARY_A UINT32_C(0xA55A39C7)
#define CANARY_B UINT32_C(0x5AA5C639)

unsigned ds32_span_check(tw32_fft *candidate, tw32_fft *baseline);
unsigned ds32_tail_check(tw32_fft *candidate, tw32_fft *baseline);
void ds32_stage7_init_twiddles(void);
void ds32_stage7_fft_mve(unsigned logn, tw32_fft *f);
void ds32_stage7_ifft_mve(unsigned logn, tw32_fft *f);
void ds32_stage8_fft_mve(unsigned logn, tw32_fft *f);
void ds32_stage8_ifft_mve(unsigned logn, tw32_fft *f);

static uint64_t src[TW32_NMAX] __attribute__((aligned(32)));
static uint64_t qbuf[TW32_NMAX] __attribute__((aligned(32)));
static uint64_t out[TW32_NMAX] __attribute__((aligned(32)));
static uint64_t scalar_out[TW32_NMAX] __attribute__((aligned(32)));
static double dbuf[TW32_NMAX] __attribute__((aligned(32)));
typedef struct {
	uint32_t pre[CANARY_WORDS];
	tw32_fft value;
	uint32_t post[CANARY_WORDS];
} guarded_tw32_fft;
static guarded_tw32_fft twbuf_mem __attribute__((aligned(32)));
static guarded_tw32_fft twref_mem __attribute__((aligned(32)));
#define twbuf (twbuf_mem.value)
#define twref (twref_mem.value)
static volatile uint64_t sink;
static uint64_t rng_state = UINT64_C(0x243f6a8885a308d3);

static uint32_t
prng(void)
{
	rng_state ^= rng_state << 13;
	rng_state ^= rng_state >> 7;
	rng_state ^= rng_state << 17;
	return (uint32_t)rng_state;
}

static uint32_t
now(void)
{
	__DSB();
	__ISB();
	return DWT->CYCCNT;
}

static uint64_t
absdiff(uint64_t a, uint64_t b)
{
	int64_t d = (int64_t)(a - b);
	return d < 0 ? -(uint64_t)d : (uint64_t)d;
}

static void
canary_init(guarded_tw32_fft *g)
{
	for (unsigned u = 0; u < CANARY_WORDS; u ++) {
		g->pre[u] = CANARY_A ^ u;
		g->post[u] = CANARY_B ^ u;
	}
}

static unsigned
canary_check(const guarded_tw32_fft *g)
{
	unsigned fail = 0;
	for (unsigned u = 0; u < CANARY_WORDS; u ++) {
		fail += g->pre[u] != (CANARY_A ^ u);
		fail += g->post[u] != (CANARY_B ^ u);
	}
	return fail;
}

static void
make_input(unsigned logn, unsigned salt)
{
	size_t n = (size_t)1 << logn;
	for (size_t i = 0; i < n; i ++) {
		int32_t x = (int32_t)(prng() % (2049 + salt)) - (1024 + (int32_t)salt/2);
		src[i] = (uint64_t)(int64_t)x << 32;
	}
}

static unsigned
test_primitives(void)
{
	unsigned fail = 0;
	uint64_t add_max = 0, mul_max = 0, cmul_max = 0;
	for (unsigned k = 0; k < 1000; k ++) {
		float a[4] __attribute__((aligned(16)));
		float b[4] __attribute__((aligned(16)));
		float s[4] __attribute__((aligned(16)));
		float e[4] __attribute__((aligned(16)));
		float p[4] __attribute__((aligned(16)));
		float pe[4] __attribute__((aligned(16)));
		for (unsigned i = 0; i < 4; i ++) {
			a[i] = (float)(int32_t)prng() * 0x1p-16f;
			b[i] = (float)(int32_t)prng() * 0x1p-16f;
		}
		tw32_two_sum4(a, b, s, e);
		tw32_two_prod4(a, b, p, pe);
		for (unsigned i = 0; i < 4; i ++) {
			double sd = (double)s[i] + (double)e[i];
			double pd = (double)p[i] + (double)pe[i];
			fail += sd != (double)a[i] + (double)b[i];
			fail += pd != (double)a[i] * (double)b[i];
		}
	}
	for (unsigned k = 0; k < 100; k ++) {
		float a[3][4] __attribute__((aligned(16)));
		float b[3][4] __attribute__((aligned(16)));
		float sa[3][4] __attribute__((aligned(16)));
		float sm[3][4] __attribute__((aligned(16)));
		for (unsigned i = 0; i < 4; i ++) {
			double da = (double)((int32_t)prng() >> 8) * 0x1p-8;
			double db = (double)((int32_t)prng() >> 8) * 0x1p-8;
			a[0][i]=(float)da; a[1][i]=(float)(da-a[0][i]);
			a[2][i]=(float)(da-a[0][i]-a[1][i]);
			b[0][i]=(float)db; b[1][i]=(float)(db-b[0][i]);
			b[2][i]=(float)(db-b[0][i]-b[1][i]);
		}
		tw32_debug_add4(sa, a, b);
		tw32_debug_mul4(sm, a, b);
		for (unsigned i = 0; i < 4; i ++) {
			tw_fpr aa={{a[0][i],a[1][i],a[2][i]}};
			tw_fpr bb={{b[0][i],b[1][i],b[2][i]}};
			tw_fpr ra=tw_sum_ct(aa,bb), rm=tw_prod_fast_ct(aa,bb);
			double va=(double)ra.x[0]+ra.x[1]+ra.x[2];
			double vm=(double)rm.x[0]+rm.x[1]+rm.x[2];
			double xa=(double)sa[0][i]+sa[1][i]+sa[2][i];
			double xm=(double)sm[0][i]+sm[1][i]+sm[2][i];
			uint64_t da=(uint64_t)(va>xa?(va-xa)*0x1p32:(xa-va)*0x1p32);
			uint64_t dm=(uint64_t)(vm>xm?(vm-xm)*0x1p32:(xm-vm)*0x1p32);
			if (da > add_max) add_max = da;
			if (dm > mul_max) mul_max = dm;
		}
	}
	{
		float a[3][4] __attribute__((aligned(16))) = {{0}};
		float ai[3][4] __attribute__((aligned(16))) = {{0}};
		float b[3][4] __attribute__((aligned(16))) = {{0}};
		float bi[3][4] __attribute__((aligned(16))) = {{0}};
		float sm[3][4] __attribute__((aligned(16)));
		float cr[3][4] __attribute__((aligned(16)));
		float ci[3][4] __attribute__((aligned(16)));
		double root = (double)(int64_t)tw_gm_q32[2][0] * 0x1p-32;
		double iroot = (double)(int64_t)tw_gm_q32[2][1] * 0x1p-32;
		for (unsigned i = 0; i < 4; i ++) {
			double da = (double)(17 + (int)i * 31);
			a[0][i]=(float)da;
			ai[0][i]=(float)(-23 + (int)i * 29);
			b[0][i]=(float)root;
			b[1][i]=(float)(root-(double)b[0][i]);
			b[2][i]=(float)(root-(double)b[0][i]-(double)b[1][i]);
			bi[0][i]=(float)iroot;
			bi[1][i]=(float)(iroot-(double)bi[0][i]);
			bi[2][i]=(float)(iroot-(double)bi[0][i]-(double)bi[1][i]);
		}
		tw32_debug_mul4(sm,a,b);
		tw32_debug_cmul4(cr,ci,a,ai,b,bi);
		for (unsigned i=0;i<4;i++) {
			tw_fpr aa={{a[0][i],a[1][i],a[2][i]}};
			tw_fpr bb={{b[0][i],b[1][i],b[2][i]}};
			tw_fpr rr=tw_prod_fast_ct(aa,bb);
			double vr=(double)rr.x[0]+(double)rr.x[1]+(double)rr.x[2];
			double vm=(double)sm[0][i]+(double)sm[1][i]+(double)sm[2][i];
			uint64_t md = absdiff((uint64_t)(int64_t)(vr * 0x1p32),
				(uint64_t)(int64_t)(vm * 0x1p32));
			if (md > mul_max) mul_max = md;
			tw_fpr iai={{ai[0][i],ai[1][i],ai[2][i]}};
			tw_fpr ibi={{bi[0][i],bi[1][i],bi[2][i]}};
			tw_fpr p0=tw_prod_fast_ct(aa,bb),p1=tw_prod_fast_ct(iai,ibi);
			tw_fpr p2=tw_prod_fast_ct(aa,ibi),p3=tw_prod_fast_ct(iai,bb);
			tw_fpr sr=tw_sum_ct(p0,(tw_fpr){{-p1.x[0],-p1.x[1],-p1.x[2]}});
			tw_fpr si=tw_sum_ct(p2,p3);
			double srq=((double)sr.x[0]+sr.x[1]+sr.x[2])*0x1p32;
			double siq=((double)si.x[0]+si.x[1]+si.x[2])*0x1p32;
			double crq=((double)cr[0][i]+cr[1][i]+cr[2][i])*0x1p32;
			double ciq=((double)ci[0][i]+ci[1][i]+ci[2][i])*0x1p32;
			uint64_t dr = absdiff((uint64_t)(int64_t)srq,
				(uint64_t)(int64_t)crq);
			uint64_t di = absdiff((uint64_t)(int64_t)siq,
				(uint64_t)(int64_t)ciq);
			if (dr > cmul_max) cmul_max = dr;
			if (di > cmul_max) cmul_max = di;
		}
	}
	printf("PRIMITIVE_CHECK cases=8000 mismatches=%u add4_max_q32_lsb=%" PRIu64
		" mul4_max_q32_lsb=%" PRIu64 " cmul4_max_q32_lsb=%" PRIu64 "\n",
		fail, add_max, mul_max, cmul_max);
	return fail;
}

static unsigned
accuracy(void)
{
	unsigned fail = 0;
	uint64_t max_fft = 0, max_roundtrip = 0;
	uint64_t q32_nonidentical = 0, scalar_nonidentical = 0;
	for (unsigned logn = 2; logn <= 10; logn ++) {
		size_t n = (size_t)1 << logn;
		uint64_t max_mve_scalar = 0, max_mve_q32 = 0;
		for (unsigned round = 0; round < 10; round ++) {
			make_input(logn, round);
			memcpy(qbuf, src, n * sizeof *qbuf);
			ref_fft_q32(logn, qbuf);
			tw32_from_q32(logn, &twbuf, src);
			tw32_from_q32(logn, &twref, src);
			tw32_fft_mve(logn, &twbuf);
			tw32_fft_scalar(logn, &twref);
			tw32_to_q32(logn, out, &twbuf);
			tw32_to_q32(logn, scalar_out, &twref);
			for (size_t i = 0; i < n; i ++) {
				uint64_t d = absdiff(qbuf[i], out[i]);
				q32_nonidentical += d != 0;
				if (d > max_fft) max_fft = d;
				if (d > max_mve_q32) max_mve_q32 = d;
				d = absdiff(scalar_out[i], out[i]);
				scalar_nonidentical += d != 0;
				if (d > max_mve_scalar) max_mve_scalar = d;
			}
			tw32_ifft_mve(logn, &twbuf);
			tw32_to_q32(logn, out, &twbuf);
			for (size_t i = 0; i < n; i ++) {
				uint64_t d = absdiff(src[i], out[i]);
				if (d > max_roundtrip) max_roundtrip = d;
			}
		}
		printf("TRANSFORM_LOGN logn=%u mve_vs_q32_lsb=%" PRIu64
			" mve_vs_tw_scalar_lsb=%" PRIu64 "\n",
			logn, max_mve_q32, max_mve_scalar);
	}
	/* Non-bit-exact is reported, not hidden as a false KAT pass. */
	printf("TRANSFORM_ERROR max_fft_q32_lsb=%" PRIu64
		" max_roundtrip_q32_lsb=%" PRIu64
		" q32_nonidentical=%" PRIu64 " scalar_nonidentical=%" PRIu64 "\n",
		max_fft, max_roundtrip, q32_nonidentical, scalar_nonidentical);
	return fail;
}

static unsigned
accuracy_ds(void)
{
	uint64_t max_fft = 0, max_roundtrip = 0, q32_nonidentical = 0;
	unsigned bit_mismatches = 0;
	for (unsigned logn = 2; logn <= 10; logn ++) {
		size_t n = (size_t)1 << logn;
		uint64_t max_logn = 0;
		for (unsigned round = 0; round < 10; round ++) {
			make_input(logn, 0x40 + round);
			memcpy(qbuf, src, n * sizeof *qbuf);
			ref_fft_q32(logn, qbuf);
			ds32_from_q32(logn, &twbuf, src);
			memcpy(&twref, &twbuf, sizeof twref);
			ds32_fft_mve(logn, &twbuf);
			ds32_stage7_fft_mve(logn, &twref);
			bit_mismatches += memcmp(&twbuf, &twref, sizeof twref) != 0;
			tw32_to_q32(logn, out, &twbuf);
			for (size_t i = 0; i < n; i ++) {
				uint64_t d = absdiff(qbuf[i], out[i]);
				q32_nonidentical += d != 0;
				if (d > max_logn) max_logn = d;
				if (d > max_fft) max_fft = d;
			}
			ds32_ifft_mve(logn, &twbuf);
			ds32_stage7_ifft_mve(logn, &twref);
			bit_mismatches += memcmp(&twbuf, &twref, sizeof twref) != 0;
			tw32_to_q32(logn, out, &twbuf);
			for (size_t i = 0; i < n; i ++) {
				uint64_t d = absdiff(src[i], out[i]);
				if (d > max_roundtrip) max_roundtrip = d;
			}
		}
		printf("DS_TRANSFORM_LOGN logn=%u ds_vs_q32_lsb=%" PRIu64 "\n",
			logn, max_logn);
	}
	printf("DS_TRANSFORM_ERROR max_fft_q32_lsb=%" PRIu64
		" max_roundtrip_q32_lsb=%" PRIu64
		" q32_nonidentical=%" PRIu64 "\n",
		max_fft, max_roundtrip, q32_nonidentical);
	printf("DS_TRANSFORM_EQ cases=180 mismatches=%u comparison=ALL_BYTES\n", bit_mismatches);
	return bit_mismatches;
}

enum impl {
	IMPL_Q32, IMPL_FP64, IMPL_TW_SCALAR, IMPL_TW_MVE,
	IMPL_DS_STAGE7, IMPL_DS_STAGE8, IMPL_DS_STAGE9, IMPL_DS_MVE,
	IMPL_COUNT
};
enum dir { DIR_FFT, DIR_IFFT };

static uint32_t
time_one(unsigned logn, enum impl impl, enum dir dir, bool inclusive)
{
	size_t n = (size_t)1 << logn;
	if (!inclusive) {
		if (impl == IMPL_Q32) {
			memcpy(qbuf, src, n * sizeof *qbuf);
		} else if (impl == IMPL_FP64) {
			for (size_t i = 0; i < n; i ++) {
				dbuf[i] = (double)(int64_t)src[i] * 0x1p-32;
			}
		} else if (impl >= IMPL_DS_STAGE7) {
			ds32_from_q32(logn, &twbuf, src);
		} else {
			tw32_from_q32(logn, &twbuf, src);
		}
	}
	uint32_t primask = __get_PRIMASK();
	__disable_irq();
	uint32_t t = now();
	if (inclusive) {
		if (impl == IMPL_Q32) {
			memcpy(qbuf, src, n * sizeof *qbuf);
		} else if (impl == IMPL_FP64) {
			for (size_t i = 0; i < n; i ++) {
				dbuf[i] = (double)(int64_t)src[i] * 0x1p-32;
			}
		} else if (impl >= IMPL_DS_STAGE7) {
			ds32_from_q32(logn, &twbuf, src);
		} else {
			tw32_from_q32(logn, &twbuf, src);
		}
	}
	if (impl == IMPL_Q32) {
		if (dir == DIR_FFT) ref_fft_q32(logn, qbuf); else ref_ifft_q32(logn, qbuf);
	} else if (impl == IMPL_FP64) {
		if (dir == DIR_FFT) ref_fft_fp64(logn, dbuf); else ref_ifft_fp64(logn, dbuf);
	} else if (impl == IMPL_TW_SCALAR) {
		if (dir == DIR_FFT) tw32_fft_scalar(logn, &twbuf); else tw32_ifft_scalar(logn, &twbuf);
	} else if (impl == IMPL_TW_MVE) {
		if (dir == DIR_FFT) tw32_fft_mve(logn, &twbuf); else tw32_ifft_mve(logn, &twbuf);
	} else if (impl == IMPL_DS_STAGE7) {
		if (dir == DIR_FFT) ds32_stage7_fft_mve(logn, &twbuf); else ds32_stage7_ifft_mve(logn, &twbuf);
	} else if (impl == IMPL_DS_STAGE8) {
		if (dir == DIR_FFT) ds32_stage8_fft_mve(logn, &twbuf); else ds32_stage8_ifft_mve(logn, &twbuf);
	} else if (impl == IMPL_DS_STAGE9) {
		if (dir == DIR_FFT) ds32_layer_control_fft(logn, &twbuf); else ds32_layer_control_ifft(logn, &twbuf);
	} else {
		if (dir == DIR_FFT) ds32_fft_mve(logn, &twbuf); else ds32_ifft_mve(logn, &twbuf);
	}
	t = now() - t;
	if (!primask) __enable_irq();
	sink ^= impl == IMPL_Q32 ? qbuf[0] : impl == IMPL_FP64
		? (uint64_t)(int64_t)(dbuf[0] * 0x1p32) : (uint64_t)twbuf.re[0][0];
	return t;
}

static void
benchmark(unsigned logn, enum dir dir, bool inclusive)
{
	uint32_t values[IMPL_COUNT][BATCHES];
	make_input(logn, 17);
	for (unsigned impl = 0; impl < IMPL_COUNT; impl ++) {
		for (unsigned i = 0; i < 10; i ++) {
			(void)time_one(logn, impl, dir, inclusive);
		}
	}
	for (unsigned b = 0; b < BATCHES; b ++) {
		for (unsigned pos = 0; pos < IMPL_COUNT; pos ++) {
			unsigned impl = (b & 1) ? (IMPL_COUNT - 1) - pos : pos;
			uint64_t sum = 0;
			for (unsigned k = 0; k < CALLS; k ++) {
				sum += time_one(logn, impl, dir, inclusive);
			}
			values[impl][b] = (uint32_t)sum;
		}
	}
	printf("BENCH mode=%s logn=%u dir=%s calls=%u",
		inclusive ? "conversion_inclusive" : "core",
		logn, dir == DIR_FFT ? "fft" : "ifft", CALLS);
	for (unsigned impl = 0; impl < IMPL_COUNT; impl ++) {
		static const char *name[] = {
			"q32", "fp64", "tw_scalar", "tw_mve", "ds_stage7", "ds_stage8", "ds_stage9", "ds_mve"
		};
		printf(" %s=", name[impl]);
		for (unsigned b = 0; b < BATCHES; b ++) printf("%s%u", b ? "," : "", values[impl][b]);
	}
	printf("\n");
}

static void
make_ct_input(unsigned logn, unsigned input_class)
{
	size_t n = (size_t)1 << logn;
	for (size_t u = 0; u < n; u ++) {
		int32_t x;
		switch (input_class) {
		case 0: x = 0; break;
		case 1: x = (u & 1) ? -1 : 1; break;
		case 2: x = (int32_t)(prng() & 2047) - 1024; break;
		default: x = (u & 1) ? -1048575 : 1048575; break;
		}
		src[u] = (uint64_t)(int64_t)x << 32;
	}
}

static void
constant_time_probe(unsigned logn, enum dir dir, enum impl impl,
	const char *name)
{
	for (unsigned input_class = 0; input_class < 4; input_class ++) {
		uint32_t lo = UINT32_MAX, hi = 0;
		uint64_t sum = 0;
		make_ct_input(logn, input_class);
		for (unsigned u = 0; u < 10; u ++) {
			(void)time_one(logn, impl, dir, false);
		}
		for (unsigned u = 0; u < 32; u ++) {
			uint32_t t = time_one(logn, impl, dir, false);
			if (t < lo) lo = t;
			if (t > hi) hi = t;
			sum += t;
		}
		printf("CT_PROBE impl=%s logn=%u dir=%s class=%u samples=32 min=%u max=%u mean=%u\n",
			name, logn, dir == DIR_FFT ? "fft" : "ifft", input_class,
			lo, hi, (unsigned)(sum / 32));
	}
}

int
mlk_test_main(int argc, char **argv)
{
	(void)argc;
	(void)argv;
	SCB_DisableICache();
	SCB_DisableDCache();
	/* Fix the FP environment: round-to-nearest, flush subnormals, default NaN. */
	__set_FPSCR((__get_FPSCR() & ~UINT32_C(0x00C00000))
		| UINT32_C(0x03000000));
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	DWT->CYCCNT = 0;
	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
	canary_init(&twbuf_mem);
	canary_init(&twref_mem);
	tw32_init_twiddles();
	ds32_stage7_init_twiddles();
	ds32_layer_init();
	printf("TW_COMPARE_BEGIN batches=%u calls=%u status=stage10_packed_tail\n", BATCHES, CALLS);
	printf("HW cpu=%u sysclk=%u hclk=%u ccr=%08x itcmcr=%08x dtcmcr=%08x fpscr=%08x\n",
		(unsigned)SystemCoreClock, (unsigned)HAL_RCC_GetSysClockFreq(),
		(unsigned)HAL_RCC_GetHCLKFreq(), (unsigned)SCB->CCR,
		(unsigned)MEMSYSCTL->ITCMCR, (unsigned)MEMSYSCTL->DTCMCR,
		(unsigned)__get_FPSCR());
	unsigned fail = test_primitives();
	fail += ds32_span_check(&twbuf, &twref);
	fail += ds32_tail_check(&twbuf, &twref);
	fail += accuracy();
	fail += accuracy_ds();
	for (unsigned logn = 9; logn <= 10; logn ++) {
		benchmark(logn, DIR_FFT, false);
		benchmark(logn, DIR_IFFT, false);
		benchmark(logn, DIR_FFT, true);
		benchmark(logn, DIR_IFFT, true);
		constant_time_probe(logn, DIR_FFT, IMPL_DS_MVE, "ds_mve");
		constant_time_probe(logn, DIR_IFFT, IMPL_DS_MVE, "ds_mve");
	}
	fail += ds32_layer_measure(&twbuf, &twref, src);
	unsigned canary_fail = canary_check(&twbuf_mem) + canary_check(&twref_mem);
	fail += canary_fail;
	printf("MEMORY_CANARY mismatches=%u\n", canary_fail);
	printf("TW_COMPARE_DONE primitive_status=%s transform_status=NUMERIC_NOT_Q32_IDENTICAL sink=%08x\n",
		fail ? "FAIL" : "PASS", (unsigned)sink);
	return fail != 0;
}
