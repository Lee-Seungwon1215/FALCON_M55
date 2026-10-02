#include "fndsa.h"
#include "inner.h"
#include "measure.h"
#include <stdio.h>
#include <string.h>
#ifndef BENCH_HOST
#include <cmsis_core.h>
#include <stm32n6xx.h>
#endif
#ifndef BENCH_LABEL
#define BENCH_LABEL "host"
#endif
#define RUNS 100
static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)] __attribute__((aligned(32)));
static uint8_t tmp[59*1024+31] __attribute__((aligned(32)));
static const char message[] = "FN-DSA stage4 native FP64 validation";

static uint32_t now(void)
{
#ifdef BENCH_HOST
	return 0;
#else
	return DWT->CYCCNT;
#endif
}

static int run_degree(unsigned logn)
{
	uint64_t total = 0;
	uint32_t samples[RUNS];
	char seed[32];
	size_t sklen = FNDSA_SIGN_KEY_SIZE(logn), pklen = FNDSA_VRFY_KEY_SIZE(logn);
	size_t siglen = FNDSA_SIGNATURE_SIZE(logn), tmplen = ((size_t)59 << logn)+31;
	/* One untimed warm-up; key seeds below are 100 distinct upstream seeds. */
	if (!fndsa_keygen_seeded_temp(logn,"warmup-fp64",11,sk,pk,tmp,tmplen)) return 1;
#ifndef BENCH_HOST
	approx_reset();
#endif
	for (unsigned i = 0; i < RUNS; i ++) {
		sprintf(seed,"test%u",i);
#ifndef BENCH_HOST
		__disable_irq();
#endif
		uint32_t before = now();
		int ok = fndsa_keygen_seeded_temp(logn,seed,strlen(seed),sk,pk,tmp,tmplen);
		uint32_t elapsed = now()-before;
#ifndef BENCH_HOST
		__enable_irq();
#endif
		if (!ok) return 2;
		samples[i] = elapsed;
		total += elapsed;
		shake_context digest;
		shake_init(&digest,256);
		shake_inject(&digest,sk,sklen);
		shake_inject(&digest,pk,pklen);
		size_t size = fndsa_sign_seeded_temp(sk,sklen,NULL,0,FNDSA_HASH_ID_RAW,
			message,sizeof message-1,seed,strlen(seed),sig,siglen,tmp,tmplen);
		if (size != siglen || !fndsa_verify_temp(sig,siglen,pk,pklen,NULL,0,
			FNDSA_HASH_ID_RAW,message,sizeof message-1,tmp,tmplen)) return 3;
		shake_inject(&digest,sig,siglen);
		sig[50] ^= 1;
		if (fndsa_verify_temp(sig,siglen,pk,pklen,NULL,0,FNDSA_HASH_ID_RAW,
			message,sizeof message-1,tmp,tmplen)) return 4;
		sig[50] ^= 1;
		uint8_t hash[32];
		shake_flip(&digest); shake_extract(&digest,hash,sizeof hash);
		printf("KEY degree=%u index=%u cycles=%u digest=",1u<<logn,i,elapsed);
		for (unsigned j=0;j<32;j++) printf("%02x",hash[j]);
		printf("\n");
	}
	for (unsigned i=1;i<RUNS;i++) {
		uint32_t v=samples[i]; unsigned j=i;
		while (j && samples[j-1]>v) { samples[j]=samples[j-1]; j--; }
		samples[j]=v;
	}
	printf("TOTAL degree=%u runs=%u cycles=%llu median=%u min=%u max=%u\n",
		1u<<logn,RUNS,(unsigned long long)total,samples[RUNS/2],samples[0],samples[RUNS-1]);
#ifndef BENCH_HOST
	approx_report(logn);
#endif
	return 0;
}

int mlk_test_main(int argc, char **argv)
{
	(void)argc; (void)argv;
	printf("FP64_BEGIN label=%s runs=%u\n",BENCH_LABEL,RUNS);
#ifndef BENCH_HOST
	printf("HW cpu=%u ccr=%08x itcmcr=%08x dtcmcr=%08x control=%08x fpscr=%08x mvfr0=%08x\n",
		(unsigned)SystemCoreClock,(unsigned)SCB->CCR,(unsigned)MEMSYSCTL->ITCMCR,
		(unsigned)MEMSYSCTL->DTCMCR,*(volatile unsigned *)0x56008008,
		(unsigned)__get_FPSCR(),(unsigned)FPU->MVFR0);
	if (SystemCoreClock!=800000000u || (SCB->CCR&0x30000u) ||
		(MEMSYSCTL->ITCMCR&0x79u)!=0x49u || (MEMSYSCTL->DTCMCR&0x79u)!=0x49u ||
		*(volatile unsigned *)0x56008008!=0x99u || (__get_FPSCR()&0x1C00000u)) return 10;
	CoreDebug->DEMCR |= 1u<<24;
	*(volatile unsigned *)0xE0001FB0 = 0xC5ACCE55;
	DWT->CYCCNT=0; DWT->CTRL|=1;
#endif
	int r=run_degree(9);
	if (!r) r=run_degree(10);
	printf("FP64_DONE result=%d signature_and_tamper=%s\n",r,r?"FAIL":"PASS");
	return r;
}
#ifdef BENCH_HOST
int main(int argc,char **argv) { return mlk_test_main(argc,argv); }
#endif
