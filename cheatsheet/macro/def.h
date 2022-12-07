#pragma once

#define BIT(pos) (1UL << (pos))

#define SET_BIT(x, pos) ((x) |= (1UL << (pos)))
#define CLR_BIT(x, pos) ((x) &= ~(1UL << (pos)))
#define TEST_BIT(x, pos) !!((x) & (1UL << (pos)))
#define CHANGE_BIT(x, pos) (x) ^= (1UL << (pos))

#define ARRAY_SIZE(x) (sizeof((x))/sizeof((x)[0]))

#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
#define OFFSETOF(s,m) (size_t)&(((s *)0)->m)


#ifndef MIN
#define MIN(a, b) (((a)<(b))?(a):(b))
#endif /* MIN */

#ifndef MAX
#define MAX(a, b) (((a)>(b))?(a):(b))
#endif /* MAX */

#ifdef ABS
#define ABS(x) (((x)<0)?-(x):(x))
#endif /* ABS */
