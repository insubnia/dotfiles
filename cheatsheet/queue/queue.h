#pragma once
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

typedef volatile struct {
    uint8_t* pbuf;
    size_t capacity;
    size_t wr_seq;
    size_t rd_seq;
    size_t size;
} circ_buf_t;

void circ_buf_init(circ_buf_t* p, size_t capacity);


typedef struct {
    circ_buf_t* cbuf;
    int (*const push)(uint8_t data);
    int (*const pop)(void);
    uint8_t (*const front)(void);
    uint8_t (*const back)(void);
    size_t (*const size)(void);
    bool (*const full)(void);
    bool (*const empty)(void);
} qtype;

int qpush(circ_buf_t* p, uint8_t data);
int qpop(circ_buf_t* p);
uint8_t qfront(circ_buf_t* p);
uint8_t qback(circ_buf_t* p);
size_t qsize(circ_buf_t* p);
bool qfull(circ_buf_t* p);
bool qempty(circ_buf_t* p);

#define QDEF(NAME) qtype q##NAME;
#define QINIT(NAME, SIZE) \
    circ_buf_t NAME_cbuf;



#define QUEUE_TYPE(TYPE) queue_##TYPE
#define QUEUE_TYPEDEF(TYPE) \
    typedef struct { \
        int (*const push)(TYPE data); \
        int (*const pop)(void); \
        TYPE (*const front)(void); \
        TYPE (*const back)(void); \
        size_t (*const size)(void); \
        bool (*const full)(void); \
        bool (*const empty)(void); \
    } QUEUE_TYPE(TYPE);

QUEUE_TYPEDEF(int32_t);
QUEUE_TYPEDEF(uint32_t);
QUEUE_TYPEDEF(int16_t);
QUEUE_TYPEDEF(uint16_t);
QUEUE_TYPEDEF(int8_t);
QUEUE_TYPEDEF(uint8_t);


#define QUEUE_INIT(NAME, TYPE, SIZE) \
    typedef struct { \
        TYPE buf[SIZE]; \
        const size_t capacity; \
        size_t wr_seq; \
        size_t rd_seq; \
        size_t size; \
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
    TYPE _##NAME##_front(void) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        return p->buf[p->rd_seq]; \
    } \
    TYPE _##NAME##_back(void) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        uint16_t idx = (p->capacity + p->wr_seq - 1) % p->capacity;\
        return p->buf[idx]; \
    } \
    size_t _##NAME##_size(void) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        return p->size; \
    } \
    bool _##NAME##_full(void) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        return p->size == p->capacity; \
    } \
    bool _##NAME##_empty(void) \
    { \
        _##NAME##_cbuf_t* p = &_##NAME##_cbuf; \
        return p->size == 0; \
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
