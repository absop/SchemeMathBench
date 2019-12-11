#include <stdio.h>
#include <time.h>

#include "get-primes-int32-vector.c"

void benchmark(char *name, int32_vector_t *get_primes(int maxn), int maxn)
{
    clock_t start, end;
    int32_vector_t *primes;

    start = clock();
    primes = get_primes(maxn);
    end = clock();

    printf("%s:\n", name);
    printf("\tFound %d primes\n", primes->length);
    printf("\tCost time: %ldms\n", end - start);
    int32_vector_free(primes);
}

int main()
{
    benchmark("euler", euler, 100000000);
    benchmark("eratosthenes", eratosthenes, 100000000);

#if 0
    const char *fmts[2] = {"%d", " %d"};

    int32_vector_t *primes = euler(100);
    for (int i = 0; i < primes->length; ++i)
        printf(fmts[!!i], primes->data[i]);
    printf("\n");
    int32_vector_free(primes);
#endif

    return 0;
}
