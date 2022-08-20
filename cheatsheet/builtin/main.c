#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

bool flag = true;

int main(void)
{
    /* byte swap */
    uint32_t var = 0x12345678;
    printf("before: 0x%08x\nafter: 0x%08x\n\n", var, __builtin_bswap32(var));

    if (__builtin_expect(flag, true)) {
        printf("expected to be true\n");
    }

    return 0;
}
