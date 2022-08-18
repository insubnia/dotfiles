#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

#define ARRAY_SIZE(x) (sizeof((x))/sizeof((x)[0])) 

#define DTYPE uint16_t

DTYPE data[] = { 17, 3, 5, 11, 9, 1 };

void print_arr(DTYPE *arr, size_t n)
{
    printf("arr: ");
    for (size_t i = 0; i < n; i++) {
        printf("%d, ", arr[i]);
    }
    printf("\n");
}

void insertion_sort(DTYPE *in, DTYPE *out, size_t n)
{
    memcpy(out, in, sizeof(DTYPE) * n);

    for (size_t j, i = 1; i < n; i++) {
        DTYPE val = out[(j=i)];
        while (--j >= 0 && val < out[j])
            out[j + 1] = out[j];
        out[j + 1] = val;
    }
}

int main(void)
{
    DTYPE out[ARRAY_SIZE(data)] = {};

    printf("Before ");
    print_arr(data, ARRAY_SIZE(data));

    insertion_sort(data, out, ARRAY_SIZE(data));

    printf("After ");
    print_arr(out, ARRAY_SIZE(out));
}
