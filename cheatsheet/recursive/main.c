#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

const uint32_t input[] = {1, 2, 3, 4};

#define N ((int)(sizeof(input) / sizeof(input[0])))

uint32_t cnt = 0;

void print_buf(int *ptr)
{
    for (int i = 0; i < N; i++) {
        int val = *(ptr + i);
        if (val == -1)
            return;
    }

    printf("data: ");
    for (int i = 0; i < N; i++) {
        int val = *(ptr + i);
        printf("%d, ", val);
    }
    printf("\n");
}

void next(int pos, bool _used[N], int _data[N])
{
    if (pos == N) {
        cnt++;
        print_buf(_data);
        return;
    }

    bool used[N];
    int data[N];

    for (int i = 0; i < N; i++) {
        if (_used[i])
            continue;

        memcpy(used, _used, sizeof(used));
        memcpy(data, _data, sizeof(data));

        used[i] = true;
        data[pos] = input[i];
        next(pos + 1, used, data);
    }
}

int main(void)
{
    bool used[N] = {
        [0 ... N - 1] = false
    };

    int data[N] = {
        [0 ... N - 1] = -1
    };

    next(0, used, data);

    printf("cnt = %d\n", cnt);

    return 0;
}
