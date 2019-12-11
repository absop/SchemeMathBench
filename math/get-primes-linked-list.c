// gcc -O3 -fPIC -shared -o get-primes-linked-list.so get-primes-linked-list.c
#include <math.h>
#include "bitvector.c"
#include "linked-list.c"


list_t *eratosthenes(int maxn)
{
    int sqrm = (int)floor(sqrt(maxn));
    bitvector_t *mask = make_bitvector(maxn + 1, 1);
    list_t *primes = list_new(2, NULL);
    list_t *tail = primes;

    for (int i = 3; i <= maxn; i += 2) {
        if (bitvector_ref(mask, i)) {
            append(tail, i);
            tail = tail->next;
            if (i <= sqrm) {
                int j = i * i, d = i << 1;
                for (; j <= maxn; j += d)
                    bitvector_reset(mask, j);
            }
        }
    }
    bitvector_free(mask);

    return primes;
}

list_t *euler(int maxn)
{
    int p, index;
    bitvector_t *mask = make_bitvector(maxn + 1, 1);
    list_t *primes = list_new(2, NULL);
    list_t *head, *tail = primes;

    for (int i = 3; i <= maxn; i += 2) {
        if (bitvector_ref(mask, i)) {
            append(tail, i);
            tail = tail->next;
        }
        for (head = primes; head; head = head->next) {
            p = head->this;
            index = i * p;
            if (index > maxn) break;
            bitvector_reset(mask, index);
            if (i % p == 0)
                break;
        }
    }
    bitvector_free(mask);

    return primes;
}
