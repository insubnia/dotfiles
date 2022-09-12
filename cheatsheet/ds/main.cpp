#include <iostream>
// #include <format>
#include <cstdio>
#include <cstdint>
#include <cstdbool>
#include <cstring>

#ifndef MIN
#define MIN(a, b) (((a)<(b))?(a):(b))
#endif /* MIN */
#ifndef MAX
#define MAX(a, b) (((a)>(b))?(a):(b))
#endif /* MAX */

using namespace std;

typedef struct {
    uint8_t * const pbuf;
    const uint16_t capacity;
    uint16_t wr_seq;
    uint16_t rd_seq;
} circ_buf_t;

#define CIRC_BUF_DEF(name, size) \
    uint8_t _##name[size]; \
    circ_buf_t name = { \
        .pbuf = _##name, \
        .capacity = size, \
        .wr_seq = 0, \
        .rd_seq = 0, \
    }

CIRC_BUF_DEF(cbuf, 512);

int circ_buf_push(circ_buf_t *c, uint8_t *src, uint16_t len);
int circ_buf_pop(circ_buf_t *c, uint8_t *dst, uint16_t len);


int main(void)
{
    cout << "hello world" << endl;
    return 0;
}


int circ_buf_push(circ_buf_t *c, uint8_t *src, uint16_t len)
{
    if (false) { /* TODO: notify buffer full */
        printf("Buffer full\n");
        return -1;
    }

    if (len == 0) {
        return 0;
    } else if (c->wr_seq + len < c->capacity) {
        memcpy(&c->pbuf[c->wr_seq], src, len);
    } else {
        uint16_t len1 = c->capacity - c->wr_seq;
        memcpy(&c->pbuf[c->wr_seq], src, len1);
        memcpy(&c->pbuf[0], &src[len1], len - len1);
    }
    c->wr_seq = (c->wr_seq + len) % c->capacity;
    return len;
}

int circ_buf_pop(circ_buf_t *c, uint8_t *dst, uint16_t len)
{
    len = MIN((c->capacity + c->wr_seq - c->rd_seq) % c->capacity, len);
    if (len == 0) {
        // printf("Buffer empty\n");
        return 0;
    } else if (c->rd_seq + len < c->capacity) {
        memcpy(dst, &c->pbuf[c->rd_seq], len);
    } else {
        uint16_t len1 = c->capacity - c->rd_seq;
        memcpy(dst, &c->pbuf[c->rd_seq], len1);
        memcpy(&dst[len1], &c->pbuf[0], len - len1);
    }
    c->rd_seq = (c->rd_seq + len) % c->capacity;
    return len;
}
