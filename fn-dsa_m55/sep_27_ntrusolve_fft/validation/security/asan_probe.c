/* Control: no FN-DSA code. Distinguish sanitizer runtime startup from A17. */
#include <stdio.h>
int main(void) { puts("ASAN_RUNTIME_PROBE_REACHED_MAIN"); return 0; }
