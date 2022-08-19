#include <stdio.h>
#include <stdarg.h>

void print_number(int argc, ...)
{
    va_list ap;

    va_start(ap, argc);

    for (int i = 0; i < argc; i++) {
        int num = va_arg(ap, int);
        printf("%d ", num);
    }
    va_end(ap);

    printf("\n");
}

int main(void)
{
    print_number(2,2,3);
    print_number(3,2,3,5);
    print_number(4,2,3,7,9);
    print_number(4,2,3,7,9);

    return 0;
}
