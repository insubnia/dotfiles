#include <stdio.h>
#include <stdint.h>
#include <string.h>

typedef struct {
    float *imgp;
    int height;
    int width;
} img_t;

void print_image(img_t img)
{
    char buf[65536] = "\n     ";

    for (int c = 0; c < img.width; c++) {
        char s[32] = {};
        sprintf(s, "[%2d]  ", c);
        strcat(buf, s);
    }
    strcat(buf, "\n");

    for (int r = 0; r < img.height; r++) {
        char s1[32] = {};
        sprintf(s1, "[%2d] ", r);
        strcat(buf, s1);

        for (int c = 0; c < img.width; c++) {
            float val = (*(float(*)[img.height][img.width])img.imgp)[r][c];
            char s[32] = {};
            sprintf(s, "%.2f, ", val);
            strcat(buf, s);
        }
        strcat(buf, "\n");
    }
    puts(buf);
}

int main(void)
{
    return 0;
}
