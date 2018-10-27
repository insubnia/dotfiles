#include <stdio.h>

void say_ha_sis(void) { printf("ha sis\n"); }
void say_ha_sjs(void) { printf("ha sjs\n"); }
void say_ha_shs(void) { printf("ha shs\n"); }
void say_ha_sws(void) { printf("ha sws\n"); }

#define ARG_N(_1,_2,_3,_4,_5,_6,_7,_8,N,...)  N
#define RSEQ_N() 8,7,6,5,4,3,2,1

#define NUM_OF_(...)    ARG_N(__VA_ARGS__)
#define NUM_OF(...)     NUM_OF_(__VA_ARGS__, RSEQ_N())

#define SAY1(M, P1)      say_ ##M ##_ ##P1();
#define SAY2(M, P1, P2)  SAY1(M, P1); SAY1(M, P2);
#define SAY3(M, P1, ...) SAY1(M, P1); SAY2(M, __VA_ARGS__);
#define SAY4(M, P1, ...) SAY1(M, P1); SAY3(M, __VA_ARGS__);
#define SAY5(M, P1, ...) SAY1(M, P1); SAY4(M, __VA_ARGS__);
#define SAY6(M, P1, ...) SAY1(M, P1); SAY5(M, __VA_ARGS__);

#define SAY__(M, N, ...)    SAY ##N(M, __VA_ARGS__)
#define SAY_(...)           SAY__(__VA_ARGS__)
#define SAY(M, ...)         SAY_(M, NUM_OF(__VA_ARGS__), __VA_ARGS__)

int main(void)
{
    printf("test start\n");

    SAY(ha, sis, sjs, shs, sws);
    SAY(ha, sis, shs);

    return 0;
}
