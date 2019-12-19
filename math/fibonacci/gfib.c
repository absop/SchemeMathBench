#include<stdio.h>

__declspec(dllexport)
int gfib(int n) { return n < 2 ? n : gfib(n - 1) + gfib(n - 2); }

int main()
{
    printf("%d\n", gfib(30));
    return 0;
}
