#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "queue.h"

QUEUE_TYPEDEF(uint16_t);
extern QUEUE_TYPE(uint16_t) my;

void external_test(void)
{
    my.push(20);
    my.push(40);
    my.push(60);
    my.push(80);
}
