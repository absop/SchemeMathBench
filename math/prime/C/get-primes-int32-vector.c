#include <math.h>
#include "../../../library/C/bitvector.c"
#include "../../../library/C/vector.c"


int32_vector_t *eratosthenes(int maxn)
{
    int sqrm = (int)floor(sqrt(maxn));
    bitvector_t *mask = make_bitvector(maxn + 1, 1);
    int32_vector_t *primes = int32_vector_new((maxn >> 1) + 5);
    int32_vector_append(primes, 2);

    for (int i = 3; i <= maxn; i += 2) {
        if (bitvector_ref(mask, i)) {
            int32_vector_append(primes, i);
            // primes->data[primes->length++] = i;
            if (i <= sqrm) {
                int j = i * i, d = i << 1;
                for (; j <= maxn; j += d)
                    bitvector_reset(mask, j);
            }
        }
    }
    bitvector_free(mask);
    int32_vector_resize(primes, primes->length);

    return primes;
}

int32_vector_t *euler(int maxn)
{
    int index, *p, *end;
    int sqrm = (int)floor(sqrt(maxn));
    bitvector_t *mask = make_bitvector(maxn + 1, 1);
    int32_vector_t *primes = int32_vector_new((maxn >> 1) + 5);
    int32_vector_append(primes, 2);

    for (int i = 3; i <= maxn; i += 2) {
        if (bitvector_ref(mask, i)) {
            int32_vector_append(primes, i);
            // primes->data[primes->length++] = i;
        }
        p = primes->data;
        end = p + primes->length;
        for (; p < end && (index = i * *p) <= maxn; ++p) {
            bitvector_reset(mask, index);
            if (i % *p == 0)
                break;
        }
    }
    bitvector_free(mask);
    int32_vector_resize(primes, primes->length);

    return primes;
}
