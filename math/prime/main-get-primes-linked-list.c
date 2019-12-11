#include <stdio.h>
#include <time.h>

#include "get-primes-linked-list.c"

void benchmark(char *name, list_t *get_primes(int maxn), int maxn)
{
    clock_t start, end;
    list_t *primes;

    start = clock();
    primes = get_primes(maxn);
    end = clock();

    printf("%s:\n", name);
    printf("\tFound %lld primes\n", list_length(primes));
    printf("\tCost time: %ldms\n", end - start);
    list_free(primes);
}

int main()
{
    benchmark("euler", euler, 100000000);
    benchmark("eratosthenes", eratosthenes, 100000000);

#if 0
    const char *fmts[2] = {"%d", " %d"};

    list_t *primes = euler(100);
    for (int i = 0; i < primes->length; ++i)
        printf(fmts[!!i], primes->data[i]);
    printf("\n");
    list_free(primes);
#endif

    return 0;
}
