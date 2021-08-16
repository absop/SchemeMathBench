#ifndef _BITVECTOR_C
#define _BITVECTOR_C

#include <stdlib.h>
#include <stdint.h>
#include <memory.h>
#include <malloc.h>


/* default memory allocation functions with memory limitation */
static inline size_t bitvector_usable_size(void *ptr)
{
#if defined(__APPLE__)
    return malloc_size(ptr);
#elif defined(_WIN32)
    return _msize(ptr);
#elif defined(EMSCRIPTEN)
    return 0;
#elif defined(__linux__)
    return malloc_usable_size(ptr);
#else
    /* change this to `return 0;` if compilation fails */
    return malloc_usable_size(ptr);
#endif
}

typedef int32_t bitvector_t;


#define LENGTH_BY_BYTE(nbits)  ((nbits +  7) >> 3)
#define LENGTH_BY_INT32(nbits) ((nbits + 31) >> 5)
#define LENGTH_BY_INT64(nbits) ((nbits + 63) >> 6)

#define BIT1AT(i) ((int32_t)1 << ((i)&31))
#define BITVECTOR_REF(v, i)  ((v)[(i)>>5] & BIT1AT(i))
#define BITVECTOR_SET(v, i)   (v)[(i)>>5] |= BIT1AT(i)
#define BITVECTOR_RESET(v, i) (v)[(i)>>5] &= ~BIT1AT(i)

int bitvector_ref(bitvector_t *v, int n) { return BITVECTOR_REF(v, n); }
void bitvector_set(bitvector_t *v, int n) { BITVECTOR_SET(v, n); }
void bitvector_reset(bitvector_t *v, int n) { BITVECTOR_RESET(v, n); }
void bitvector_fill(bitvector_t *v, int fill)
{
    size_t size = bitvector_usable_size(v);
    memset(v, -(fill & 0x1), size);
}

bitvector_t *make_bitvector(int n, int fill)
{
    size_t nbytes = LENGTH_BY_INT32(n) * 4;
    bitvector_t *v = (bitvector_t*)malloc(nbytes);
    bitvector_fill(v, fill);
    return v;
}

void free_bitvector(bitvector_t *v) { free(v); }

#endif /* _BITVECTOR_C */
