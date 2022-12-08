#pragma once

#define QUEUE_TYPEDEF(TYPE) \
    typedef struct { \
        int (*const push)(TYPE data); \
        int (*const pop)(void); \
        TYPE (*const front)(void); \
        TYPE (*const back)(void); \
        uint16_t (*const size)(void); \
        bool (*const full)(void); \
        bool (*const empty)(void); \
    } queue_##TYPE;


#define QUEUE_TYPE(TYPE) queue_##TYPE


#define QUEUE_INIT(NAME, TYPE, SIZE) \
    typedef struct { \
        TYPE buf[SIZE]; \
        const uint16_t capacity; \
        uint16_t size; \
        uint16_t wr_seq; \
        uint16_t rd_seq; \
    } NAME##_cbuf_t; \
    \
    static NAME##_cbuf_t NAME##_cbuf = { \
        .capacity = SIZE, \
    }; \
    \
    static int NAME##_push(TYPE data) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        if (p->size == p->capacity) { \
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
            return -1; \
        } \
        p->size--; \
        p->rd_seq = (p->rd_seq + 1) % p->capacity; \
        return 0; \
    } \
    static TYPE NAME##_front(void) \
    { \
        return NAME##_cbuf.buf[NAME##_cbuf.rd_seq]; \
    } \
    static TYPE NAME##_back(void) \
    { \
        NAME##_cbuf_t* p = &NAME##_cbuf; \
        uint16_t idx = (p->capacity + p->wr_seq - 1) % p->capacity;\
        return NAME##_cbuf.buf[idx]; \
    } \
    static uint16_t NAME##_size(void) \
    { \
        return NAME##_cbuf.size; \
    } \
    static bool NAME##_full(void) \
    { \
        return NAME##_cbuf.size == NAME##_cbuf.capacity; \
    } \
    static bool NAME##_empty(void) \
    { \
        return NAME##_cbuf.size == 0; \
    } \
    \
    QUEUE_TYPE(TYPE) NAME = { \
        .push = NAME##_push, \
        .pop = NAME##_pop, \
        .front = NAME##_front, \
        .back = NAME##_back, \
        .size = NAME##_size, \
        .full = NAME##_full, \
        .empty = NAME##_empty, \
    };
