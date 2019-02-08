#include <cstdio>
#include <iostream>

using namespace std;

#define TEMPLATE(INDEX) buf[INDEX] = INDEX;

#define REPEAT(EVAL, END_IDX) REPEAT_ ##END_IDX(EVAL)

#define REPEAT_0(EVAL) EVAL(0)
#define REPEAT_1(EVAL) REPEAT_0(EVAL) EVAL(1)
#define REPEAT_2(EVAL) REPEAT_1(EVAL) EVAL(2)
#define REPEAT_3(EVAL) REPEAT_2(EVAL) EVAL(3)
#define REPEAT_4(EVAL) REPEAT_3(EVAL) EVAL(4)
#define REPEAT_5(EVAL) REPEAT_4(EVAL) EVAL(5)
#define REPEAT_6(EVAL) REPEAT_5(EVAL) EVAL(6)
#define REPEAT_7(EVAL) REPEAT_6(EVAL) EVAL(7)
#define REPEAT_8(EVAL) REPEAT_7(EVAL) EVAL(8)
#define REPEAT_9(EVAL) REPEAT_8(EVAL) EVAL(9)
#define REPEAT_10(EVAL) REPEAT_9(EVAL) EVAL(10)
#define REPEAT_11(EVAL) REPEAT_10(EVAL) EVAL(11)
#define REPEAT_12(EVAL) REPEAT_11(EVAL) EVAL(12)
#define REPEAT_13(EVAL) REPEAT_12(EVAL) EVAL(13)
#define REPEAT_14(EVAL) REPEAT_13(EVAL) EVAL(14)
#define REPEAT_15(EVAL) REPEAT_14(EVAL) EVAL(15)
#define REPEAT_16(EVAL) REPEAT_15(EVAL) EVAL(16)


int main(void)
{
    uint8_t buf[16] = {
        [3 ... 5] = 128,
        [6 ... 8] = 255,
    };

    REPEAT(TEMPLATE, 15);

    for (uint32_t i = 0; i < sizeof(buf); i++)
        printf("buf[%d] = %d\n", i, buf[i]);

    return 0;
}
