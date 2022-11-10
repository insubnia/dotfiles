#pragma once

#define BIT(pos) (1UL << (pos))

#define SET_BIT(x, pos) ((x) |= (1UL << (pos)))
#define CLR_BIT(x, pos) ((x) &= ~(1UL << (pos)))
#define TEST_BIT(x, pos) !!((x) & (1UL << (pos)))
#define CHANGE_BIT(x, pos) (x) ^= (1UL << (pos))

