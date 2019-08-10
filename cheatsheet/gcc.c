#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

int main(void)
{
    /* byte swap */
    uint32_t var = 0x12345678;
    printf("0x%08x\n", __builtin_bswap32(var));

    return 0;
}
