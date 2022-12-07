#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#define BUF_SIZE 8


typedef struct {
    uint8_t* const pbuf;
    const uint16_t capacity;
    uint16_t wr_seq;
    uint16_t rd_seq;
} circ_buf_t;

struct queue {
    int (*push)(uint8_t data);
    int (*pop)(void);
    uint8_t (*front)(void);
    // uint8_t (*back)(void);
    uint16_t (*size)(void);
    bool (*empty)(void);
};

uint16_t size(circ_buf_t* c)
{
    // printf("\nwr: %d / rd: %d\n", c->wr_seq, c->rd_seq);
    return (c->capacity + c->wr_seq - c->rd_seq) % c->capacity;
}

int push(circ_buf_t* c, uint8_t data)
{
    if ((c->wr_seq + 1) % c->capacity == c->rd_seq) {
        printf("buffer full\n");
        return -1;
    }
    c->pbuf[c->wr_seq] = data;
    c->wr_seq = (c->wr_seq + 1) % c->capacity;
    return 0;
}

int pop(circ_buf_t* c)
{
    if (size(c) == 0) {
        printf("buffer empty\n");
        return -1;
    }
    c->rd_seq = (c->rd_seq + 1) % c->capacity;
    return 0;
}

uint8_t front(circ_buf_t* c)
{
    return c->pbuf[c->rd_seq];
}


uint8_t _buf[BUF_SIZE] = {};
circ_buf_t buf = {
    .pbuf = _buf,
    .capacity = BUF_SIZE,
    .rd_seq = 0,
    .wr_seq = 0,
};

void print_buf(circ_buf_t* c)
{
    printf("[BUF] :");
    for (int i = 0; i < BUF_SIZE; i++) {
        printf("%6d, ", c->pbuf[i]);
    }
    printf("\n");

#if 1
    printf("      :");
    for (int i = 0; i < BUF_SIZE; i++) {
        printf("     ");

        if (i == c->rd_seq)
            printf("<");
        else
            printf(" ");

        if (i == c->wr_seq)
            printf(">");
        else
            printf(" ");

        printf("|");
    }
    printf("\n");
#endif
}


int main(void)
{
    for (int i = 0; i < 10; i++) {
        push(&buf, i + 1);
        print_buf(&buf);
        // pop(&buf);
        // printf("front: %d\n", front(&buf));
    }

    for (int i = 0; i < 5; i++) {
        pop(&buf);
        print_buf(&buf);
        printf("front: %d\n", front(&buf));
    }

    printf("\nComplete!\n\n");
    return 0;
}
