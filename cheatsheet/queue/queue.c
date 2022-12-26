#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include "queue.h"

void circ_buf_init(circ_buf_t* p, size_t capacity)
{
    p->pbuf = (void*)malloc(capacity);
    p->capacity = capacity;
    p->wr_seq = p->rd_seq = p->size = 0;
}


int qpush(circ_buf_t* p, uint8_t data)
{
    if (p->size == p->capacity) {
        return -1;
    }
    p->size++;
    p->pbuf[p->wr_seq] = data;
    p->wr_seq = (p->wr_seq + 1) % p->capacity;
    return 0;
}

int qpop(circ_buf_t* p)
{
    if (p->size == 0) {
        return -1;
    }
    p->size--;
    p->rd_seq = (p->rd_seq + 1) % p->capacity;
    return 0;
}

uint8_t qfront(circ_buf_t* p)
{
    return p->pbuf[p->rd_seq];
}

uint8_t qback(circ_buf_t* p)
{
    size_t idx = (p->capacity + p->wr_seq - 1) % p->capacity;
    return p->pbuf[idx];
}

size_t qsize(circ_buf_t* p)
{
    return p->size;
}

bool qfull(circ_buf_t* p)
{
    return p->size == p->capacity;
}

bool qempty(circ_buf_t* p)
{
    return p->size == 0;
}
