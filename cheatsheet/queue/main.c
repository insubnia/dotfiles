#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "queue.h"

#define TYPE int8_t
#define SIZE 8

extern void external_test(void);

#if 0
typedef struct {
    TYPE buf[SIZE];
    const uint16_t capacity;
    uint16_t size;
    uint16_t wr_seq;
    uint16_t rd_seq;
} circ_buf_t;

circ_buf_t q_cbuf = {
    .capacity = SIZE,
};

void print_buf(circ_buf_t* c)
{
    printf("[BUF] :");
    for (int i = 0; i < SIZE; i++) {
        printf("%6d, ", c->buf[i]);
    }
    printf("\n");

#if 0
    printf("      ");
    for (int i = 0; i < SIZE; i++) {
        printf("     ");
        printf("%s", (i == c->rd_seq ? "<" : " "));
        printf("%s", (i == c->wr_seq ? ">" : " "));
        printf("|");
    }
    printf("\n");
#endif
}
#endif

QUEUE_INIT(my, uint16_t, 32);
QUEUE_INIT(dup, uint16_t, 16);

int main(void)
{
#if 1
    my.push(10);
    external_test();
    my.push(100);

    while (!my.empty()) {
        printf("front: %3d / back: %3d\n", my.front(), my.back());
        my.pop();
    }
#else
    circ_buf_t quart;
    circ_buf_init(&quart, 32);

    qpush(&quart, 10);
    qpush(&quart, 20);
    qpush(&quart, 30);
    qpush(&quart, 40);
    qpush(&quart, 50);

    while (!qempty(&quart)) {
        printf("front: %3d / back: %3d\n", qfront(&quart), qback(&quart));
        qpop(&quart);
    }

    for (int i = 0; i < 35; i++) {
        if (!qfull(&quart))
            qpush(&quart, i + 10);
        else
            printf("Full @ %d\n", i);
    }


#endif
    printf("\nComplete!\n\n");
    return 0;
}
