#ifndef _BITVECTOR_C
#define _BITVECTOR_C

#include <stdlib.h>
#include <stdint.h>
#include <memory.h>

typedef struct _bitvector {
    size_t length; /* by byte */
    int32_t bits[1];
} bitvector_t;

#define LENGTH_BY_BYTE(n) ((n + 7) >> 3)
#define LENGTH_BY_INT32(n) ((n + 31) >> 5)
#define LENGTH_BY_INT64(n) ((n + 63) >> 6)

#define BIT1AT(n) ((int32_t)1 << ((n)&31))
#define BITVECTOR_REF(v, n) ((v)->bits[(n)>>5] & BIT1AT(n))
#define BITVECTOR_SET(v, n) (v)->bits[(n)>>5] |= BIT1AT(n)
#define BITVECTOR_RESET(v, n) (v)->bits[(n)>>5] &= ~BIT1AT(n)
#define BITVECTOR_FREE(v)      \
    do {                       \
        free(v);               \
        v = (bitvector_t*)0;   \
    } while(0)

int bitvector_ref(bitvector_t *v, int n) { return BITVECTOR_REF(v, n); }
void bitvector_set(bitvector_t *v, int n) { BITVECTOR_SET(v, n); }
void bitvector_reset(bitvector_t *v, int n) { BITVECTOR_RESET(v, n); }
void bitvector_free(bitvector_t *v) { BITVECTOR_FREE(v); }
void bitvector_fill(bitvector_t *v, int fill)
{
    if (fill == 1)
        memset(v->bits, 0xff, v->length);
    else if (fill == 0)
        memset(v->bits, 0, v->length);
}

bitvector_t *make_bitvector(int n, int fill)
{
    bitvector_t *v;
    int length = LENGTH_BY_INT32(n) << 2;
    v = malloc(sizeof (bitvector_t) + length);
    v->length = length; /* by byte */
    bitvector_fill(v, fill);
    return v;
}

#endif /* _BITVECTOR_C */
