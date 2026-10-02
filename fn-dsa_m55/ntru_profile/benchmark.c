#include "fndsa.h"
#include "profile.h"

#include <cmsis_core.h>
#include <stm32n6xx.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define KEYGEN_RUNS 10u
#ifndef PROFILE_CANDIDATE
#define PROFILE_CANDIDATE "unknown"
#endif

static uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)] __attribute__((aligned(32)));
static uint8_t sig[FNDSA_SIGNATURE_SIZE(10)] __attribute__((aligned(32)));
static uint8_t tmp[59 * 1024 + 31] __attribute__((aligned(32)));
static const uint8_t message[] = "FN-DSA M55 NTRU internal profiling";

static void
seed_for(uint8_t *dst, size_t len, unsigned logn, unsigned phase, unsigned index)
{
	for (size_t j = 0; j < len; j ++) {
		dst[j] = (uint8_t)(0xA5u + 29u * j + 13u * phase + 7u * logn);
	}
	for (unsigned j = 0; j < 4; j ++) {
		dst[j] ^= (uint8_t)(index >> (8 * j));
	}
}

static uint32_t
fingerprint_update(uint32_t h, const void *src, size_t len)
{
	const uint8_t *p = src;
	for (size_t i = 0; i < len; i ++) {
		h = (h ^ p[i]) * 16777619u;
	}
	return h;
}

static int
keygen(unsigned logn, const uint8_t seed[32])
{
	return fndsa_keygen_seeded_temp(logn, seed, 32, sk, pk, tmp,
		((size_t)59 << logn) + 31);
}

static int
sign_message(unsigned logn, const uint8_t seed[40])
{
	size_t siglen = FNDSA_SIGNATURE_SIZE(logn);
	return fndsa_sign_seeded_temp(sk, FNDSA_SIGN_KEY_SIZE(logn), NULL, 0,
		FNDSA_HASH_ID_RAW, message, sizeof message - 1, seed, 40,
		sig, siglen, tmp, ((size_t)59 << logn) + 31) == siglen;
}

static int
verify_message(unsigned logn)
{
	return fndsa_verify_temp(sig, FNDSA_SIGNATURE_SIZE(logn), pk,
		FNDSA_VRFY_KEY_SIZE(logn), NULL, 0, FNDSA_HASH_ID_RAW,
		message, sizeof message - 1, tmp, ((size_t)59 << logn) + 31);
}

static int
hardware_audit(void)
{
	uint32_t ccr = SCB->CCR;
	uint32_t itcmcr = MEMSYSCTL->ITCMCR;
	uint32_t dtcmcr = MEMSYSCTL->DTCMCR;
	uint32_t control = *(volatile uint32_t *)0x56008008;
	printf("PROFILE_HW cpu=%u ccr=%08x itcmcr=%08x dtcmcr=%08x control=%08x\n",
		(unsigned)SystemCoreClock, ccr, itcmcr, dtcmcr, control);
	return SystemCoreClock == 800000000u && !(ccr & 0x30000u)
		&& (itcmcr & 0x79u) == 0x49u && (dtcmcr & 0x79u) == 0x49u
		&& control == 0x99u;
}

static int
profile_one(unsigned logn)
{
	uint8_t key_seed[32], sign_seed[40];
	uint32_t fingerprint = 2166136261u;
	size_t sklen = FNDSA_SIGN_KEY_SIZE(logn);
	size_t pklen = FNDSA_VRFY_KEY_SIZE(logn);

	for (unsigned i = 0; i < KEYGEN_RUNS; i ++) {
		seed_for(key_seed, sizeof key_seed, logn, 1, i);
		__disable_irq();
		int ok = keygen(logn, key_seed);
		__enable_irq();
		if (!ok) {
			return 1;
		}
		fingerprint = fingerprint_update(fingerprint, sk, sklen);
		fingerprint = fingerprint_update(fingerprint, pk, pklen);
	}

	/* Check that the final measured key can sign and reject tampering. */
	seed_for(sign_seed, sizeof sign_seed, logn, 2, 0);
	if (!sign_message(logn, sign_seed) || !verify_message(logn)) {
		return 2;
	}
	sig[50] ^= 1;
	int accepted = verify_message(logn);
	sig[50] ^= 1;
	if (accepted) {
		return 3;
	}
	printf("PROFILE_KEYGEN degree=%u calls=%u\n", 1u << logn, KEYGEN_RUNS);
	printf("PROFILE_FINGERPRINT degree=%u fnv1a=%08x\n", 1u << logn,
		fingerprint);
	return 0;
}

int
mlk_test_main(int argc, char **argv)
{
	(void)argc;
	(void)argv;
	printf("PROFILE_BEGIN candidate=%s keygen_runs=%u\n",
		PROFILE_CANDIDATE, KEYGEN_RUNS);
	if (!hardware_audit()) {
		return 10;
	}
	profile_clock_init();
	profile_reset();
	int r = profile_one(9);
	if (!r) {
		r = profile_one(10);
	}
	profile_report();
	printf("PROFILE_STATUS error=%u result=%d\n", (unsigned)profile_error, r);
	if (r || profile_error) {
		return 11;
	}
	printf("PROFILE_DONE correctness=PASS tamper_rejection=PASS\n");
	return 0;
}
