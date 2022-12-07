#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#define NAME my

#define TYPE int8_t
#define SIZE 8

typedef struct {
    TYPE buf[SIZE];
    const uint16_t capacity;
    uint16_t size;
    uint16_t wr_seq;
    uint16_t rd_seq;
} circ_buf_t;

struct queue {
    int (*push)(TYPE data);
    int (*pop)(void);
    TYPE (*front)(void);
    // TYPE (*back)(void);
    uint16_t (*size)(void);
    bool (*full)(void);
    bool (*empty)(void);
};


int push(circ_buf_t* c, TYPE data)
{
    if (c->size == c->capacity) {
        printf("buffer full\n");
        return -1;
    }
    c->size++;
    c->buf[c->wr_seq] = data;
    c->wr_seq = (c->wr_seq + 1) % c->capacity;
    return 0;
}

int pop(circ_buf_t* c)
{
    if (c->size == 0) {
        printf("buffer empty\n");
        return -1;
    }
    c->size--;
    c->rd_seq = (c->rd_seq + 1) % c->capacity;
    return 0;
}

TYPE front(circ_buf_t* c)
{
    return c->buf[c->rd_seq];
}

uint16_t size(circ_buf_t* c)
{
    return c->size;
}


circ_buf_t buf = {
    .buf = { 0, },
    .capacity = SIZE,
    .rd_seq = 0,
    .wr_seq = 0,
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


int main(void)
{
#if 1
    for (int i = 0; i < 9; i++) {
        printf("push\n");
        push(&buf, i + 1);
        print_buf(&buf);
        // printf("front: %d\n", front(&buf));
    }
    for (int i = 0; i < 8; i++) {
        printf("pop\n");
        // printf("front: %d\n", front(&buf));
        pop(&buf);
        print_buf(&buf);
    }
#endif

    printf("\nComplete!\n\n");
    return 0;
}
