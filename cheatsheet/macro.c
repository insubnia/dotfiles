#include <stdio.h>

// #define DEBUG 0

#ifdef DEBUG
#define DEBUG_PRINT(...) printf(__VA_ARGS__)
#else
#define DEBUG_PRINT(...) do {} while (0)
#endif

#define _BV(bit) (1UL << (bit))
#define BIT(nr) (1UL << (nr))

/*
 * x = !!x // booleanize
 *
 * < refer to bitops >
 * set_bit(nr, p)
 * clear_bit(nr, p)
 * change_bit(nr, p)
 * test_bit(nr, p)
 */

/* Macros for min/max. */
#ifndef MIN
#define MIN(a, b) (((a)<(b))?(a):(b))
#endif /* MIN */
#ifndef MAX
#define MAX(a, b) (((a)>(b))?(a):(b))
#endif /* MAX */

#define ABS(x) (((x)<0)?-(x):(x))

#define ARRAY_SIZE(x) (sizeof((x))/sizeof((x)[0])) 

#define offsetof(s,m) (size_t)&(((s *)0)->m)

#define PP_NARG(...) \
    PP_NARG_(__VA_ARGS__,PP_RSEQ_N())
#define PP_NARG_(...) \
    PP_ARG_N(__VA_ARGS__)
#define PP_ARG_N( \
     _1, _2, _3, _4, _5, _6, _7, _8, _9,_10, \
    _11,_12,_13,_14,_15,_16,_17,_18,_19,_20, \
    _21,_22,_23,_24,_25,_26,_27,_28,_29,_30, \
    _31,_32,_33,_34,_35,_36,_37,_38,_39,_40, \
    _41,_42,_43,_44,_45,_46,_47,_48,_49,_50, \
    _51,_52,_53,_54,_55,_56,_57,_58,_59,_60, \
    _61,_62,_63,  N, ...) N
#define PP_RSEQ_N() \
    63,62,61,60,                   \
    59,58,57,56,55,54,53,52,51,50, \
    49,48,47,46,45,44,43,42,41,40, \
    39,38,37,36,35,34,33,32,31,30, \
    29,28,27,26,25,24,23,22,21,20, \
    19,18,17,16,15,14,13,12,11,10, \
     9, 8, 7, 6, 5, 4, 3, 2, 1, 0


void say_ha_sis(void) { printf("ha sis\n"); }
void say_ha_sjs(void) { printf("ha sjs\n"); }
void say_ha_shs(void) { printf("ha shs\n"); }
void say_ha_sws(void) { printf("ha sws\n"); }


#define SAY(M, ...)         SAY_(M, PP_NARG(__VA_ARGS__), __VA_ARGS__)
#define SAY_(...)           SAY__(__VA_ARGS__)
#define SAY__(M, N, ...)    SAY ##N(M, __VA_ARGS__)

#define SAY1(M, P1)      say_ ##M ##_ ##P1();
#define SAY2(M, P1, P2)  SAY1(M, P1); SAY1(M, P2);
#define SAY3(M, P1, ...) SAY1(M, P1); SAY2(M, __VA_ARGS__);
#define SAY4(M, P1, ...) SAY1(M, P1); SAY3(M, __VA_ARGS__);
#define SAY5(M, P1, ...) SAY1(M, P1); SAY4(M, __VA_ARGS__);
#define SAY6(M, P1, ...) SAY1(M, P1); SAY5(M, __VA_ARGS__);


int main(void)
{
    printf("test start\n");

    SAY(ha, sis, sjs, shs, sws);
    SAY(ha, sis, shs);

    return 0;
}
