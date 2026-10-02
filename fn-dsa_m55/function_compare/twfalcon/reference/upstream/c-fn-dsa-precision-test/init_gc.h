#include "gc.h"
#include <mpfr.h>

static void *mpfr_malloc(size_t size) { return GC_MALLOC(size); }

static void *mpfr_realloc(void *ptr, size_t old_size, size_t new_size) {
    return GC_REALLOC(ptr, new_size);
}

static void mpfr_free(void *ptr, size_t size) {
    // having mpfr library use the garbage collector to free memory goes wrong
    // at random places, if we do not free anything through mpfr the garbage
    // collector will fix this by itself GC_FREE(ptr);
}

static void init_gc() {
    GC_INIT();
    GC_expand_hp(20000000);
    mp_set_memory_functions(mpfr_malloc, mpfr_realloc, mpfr_free);
}
