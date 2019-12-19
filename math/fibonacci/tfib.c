#include<stdio.h>

__declspec(dllexport)
int tfib(int n) { return n < 2 ? n : tfib(n - 1) + tfib(n - 2); }

int main()
{
    printf("%d\n", tfib(30));
    return 0;
}
