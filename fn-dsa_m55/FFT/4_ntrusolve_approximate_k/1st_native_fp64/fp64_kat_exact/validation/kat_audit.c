/* Host-only audit: keep checking all upstream keygen vectors after a mismatch.
 * The original test file and its published-in-repository vectors are unchanged.
 */
#define main upstream_main
#include "../test_fndsa.c"
#undef main

int
main(void)
{
	unsigned mismatches = 0, count = 0;
	test_keygen_self();
	for (unsigned logn = 8; logn <= 10; logn ++) {
		const char *const *kat = logn == 8 ? KAT_KG256
			: (logn == 9 ? KAT_KG512 : KAT_KG1024);
		size_t n = (size_t)1 << logn;
		uint8_t sk[FNDSA_SIGN_KEY_SIZE(10)];
		uint8_t pk[FNDSA_VRFY_KEY_SIZE(10)];
		uint8_t tmp[22 * 1024 + 31];
		int8_t fgFG[4 * 1024];
		for (unsigned i = 0; kat[i] != NULL; i ++) {
			char seed[30];
			sprintf(seed, "test%u", i);
			if (!fndsa_keygen_seeded_temp(logn, seed, strlen(seed),
				sk, pk, tmp, 22 * n + 31)) return 3;
			check_keypair(logn, sk, pk, fgFG, fgFG + n,
				fgFG + 2 * n, fgFG + 3 * n);
			uint8_t actual[32], expected[32], part[32];
			sha256_context ctx;
			sha256_init(&ctx);
			sha256_update(&ctx, fgFG, 4 * n);
			sha256_close(&ctx, actual);
			hextobin(expected, 32, kat[i]);
			int match = memcmp(actual, expected, 32) == 0;
			mismatches += !match;
			count ++;
			printf("KEY_KAT degree=%u seed=%s match=%d actual=",
				1u << logn, seed, match);
			for (unsigned j = 0; j < 32; j ++) printf("%02x", actual[j]);
			for (unsigned k = 0; k < 4; k ++) {
				sha256_init(&ctx);
				sha256_update(&ctx, fgFG + k * n, n);
				sha256_close(&ctx, part);
				printf(" %c=", "fgFG"[k]);
				for (unsigned j = 0; j < 32; j ++) printf("%02x", part[j]);
			}
			printf("\n");
		}
	}
	test_verify();
	test_self();
	printf("KEY_KAT_SUMMARY count=%u mismatches=%u equation_and_range=PASS\n",
		count, mismatches);
	fflush(stdout);
	test_kat();
	return mismatches ? 2 : 0;
}
