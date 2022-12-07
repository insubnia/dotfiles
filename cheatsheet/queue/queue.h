#pragma once

#define QUEUE(NAME, TYPE, SIZE) \
    typedef struct { \
        TYPE buf[SIZE]; \
        const uint16_t capacity; \
        uint16_t size; \
        uint16_t wr_seq; \
        uint16_t rd_seq; \
    } NAME##_cbuf_t; \
    \
    typedef struct { \
        int (*push)(TYPE data); \
        int (*pop)(void); \
        TYPE (*front)(void); \
        uint16_t (*size)(void); \
        bool (*full)(void); \
        bool (*empty)(void); \
    } NAME##_queue_t; \
    \
    \
    NAME##_cbuf_t NAME##_cbuf = { \
        .capacity = SIZE, \
        .wr_seq = 0, \
        .rd_seq = 0, \
    }; \
    \
    int _NAME##_push(TYPE data) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        if (p->size == p->capacity) { \
            printf("buffer full\n"); \
            return -1; \
        } \
        p->size++; \
        p->buf[p->wr_seq] = data; \
        p->wr_seq = (p->wr_seq + 1) % p->capacity; \
        return 0; \
    } \
    int _NAME##_pop(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        if (p->size == 0) { \
            printf("buffer empty\n"); \
            return -1; \
        } \
        p->size--; \
        p->rd_seq = (p->rd_seq + 1) % p->capacity; \
        return 0; \
    } \
    TYPE _NAME##_front(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->buf[p->rd_seq]; \
    } \
    uint16_t _NAME##_size(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->size; \
    } \
    bool _NAME##_full(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->size == p->capacity; \
    } \
    bool _NAME##_empty(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->size == 0; \
    } \
    \
    NAME##_queue_t NAME = { \
        .push = _NAME##_push, \
        .pop = _NAME##_pop, \
        .front = _NAME##_front, \
        .size = _NAME##_size, \
        .full = _NAME##_full, \
        .empty = _NAME##_empty, \
    };
