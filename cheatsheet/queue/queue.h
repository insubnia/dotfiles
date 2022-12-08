#pragma once

#define QUEUE_TYPEDEF(TYPE) \
    typedef struct { \
        int (*push)(TYPE data); \
        int (*pop)(void); \
        TYPE (*front)(void); \
        uint16_t (*size)(void); \
        bool (*full)(void); \
        bool (*empty)(void); \
    } queue_##TYPE;


#define QUEUE_TYPE(TYPE) queue_##TYPE


#define QUEUE(NAME, TYPE, SIZE) \
    typedef struct { \
        TYPE buf[SIZE]; \
        const uint16_t capacity; \
        uint16_t size; \
        uint16_t wr_seq; \
        uint16_t rd_seq; \
    } NAME##_cbuf_t; \
    \
    NAME##_cbuf_t NAME##_cbuf = { \
        .capacity = SIZE, \
        .wr_seq = 0, \
        .rd_seq = 0, \
    }; \
    \
    static int NAME##_push(TYPE data) \
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
    static int NAME##_pop(void) \
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
    static TYPE NAME##_front(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->buf[p->rd_seq]; \
    } \
    static uint16_t NAME##_size(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->size; \
    } \
    static bool NAME##_full(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->size == p->capacity; \
    } \
    static bool NAME##_empty(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        return p->size == 0; \
    } \
    \
    QUEUE_TYPE(TYPE) NAME = { \
        .push = NAME##_push, \
        .pop = NAME##_pop, \
        .front = NAME##_front, \
        .size = NAME##_size, \
        .full = NAME##_full, \
        .empty = NAME##_empty, \
    };
