#pragma once
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#define QUEUE_TYPEDEF(TYPE) \
    typedef struct { \
        int (*const push)(TYPE data); \
        int (*const pop)(void); \
        TYPE (*const front)(void); \
        TYPE (*const back)(void); \
        size_t (*const size)(void); \
        bool (*const full)(void); \
        bool (*const empty)(void); \
    } queue_##TYPE;

QUEUE_TYPEDEF(int32_t);
QUEUE_TYPEDEF(uint32_t);
QUEUE_TYPEDEF(int16_t);
QUEUE_TYPEDEF(uint16_t);
QUEUE_TYPEDEF(int8_t);
QUEUE_TYPEDEF(uint8_t);


#define QUEUE_TYPE(TYPE) queue_##TYPE


#define QUEUE_INIT(NAME, TYPE, SIZE) \
    typedef struct { \
        TYPE buf[SIZE]; \
        const size_t capacity; \
        size_t size; \
        size_t wr_seq; \
        size_t rd_seq; \
    } _##NAME##_cbuf_t; \
    \
    static _##NAME##_cbuf_t _##NAME##_cbuf = { \
        .capacity = SIZE, \
    }; \
    \
    static int _##NAME##_push(TYPE data) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        if (p->size == p->capacity) { \
            return -1; \
        } \
        p->size++; \
        p->buf[p->wr_seq] = data; \
        p->wr_seq = (p->wr_seq + 1) % p->capacity; \
        return 0; \
    } \
    static int _##NAME##_pop(void) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        if (p->size == 0) { \
            return -1; \
        } \
        p->size--; \
        p->rd_seq = (p->rd_seq + 1) % p->capacity; \
        return 0; \
    } \
    static TYPE _##NAME##_front(void) \
    { \
        return _##NAME##_cbuf.buf[_##NAME##_cbuf.rd_seq]; \
    } \
    static TYPE _##NAME##_back(void) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        uint16_t idx = (p->capacity + p->wr_seq - 1) % p->capacity;\
        return p->buf[idx]; \
    } \
    static size_t _##NAME##_size(void) \
    { \
        return _##NAME##_cbuf.size; \
    } \
    static bool _##NAME##_full(void) \
    { \
        return _##NAME##_cbuf.size == _##NAME##_cbuf.capacity; \
    } \
    static bool _##NAME##_empty(void) \
    { \
        return _##NAME##_cbuf.size == 0; \
    } \
    \
    QUEUE_TYPE(TYPE) NAME = { \
        .push = _##NAME##_push, \
        .pop = _##NAME##_pop, \
        .front = _##NAME##_front, \
        .back = _##NAME##_back, \
        .size = _##NAME##_size, \
        .full = _##NAME##_full, \
        .empty = _##NAME##_empty, \
    };
