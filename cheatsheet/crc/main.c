#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

uint8_t crc8_table[256];
uint16_t crc16_table[256];
uint32_t crc32_table[256];


void make_crc8_table(uint8_t polynomial)
{
    for (int byte = 0; byte <= 0xFF; byte++) {
        uint8_t crc = byte;
        for (int i = 8; i--;)
            crc = (crc << 1) ^ (crc & 0x80 ? polynomial : 0);
        crc8_table[byte] = crc;
    }
}

void make_crc16_table(uint16_t polynomial)
{
    for (int byte = 0; byte <= 0xFF; byte++) {
        uint16_t crc = byte << 8;
        for (int i = 8; i--;)
            crc = (crc << 1) ^ (crc & 0x8000 ? polynomial : 0);
        crc16_table[byte] = crc;
    }
}

void make_crc32_table(uint32_t polynomial)
{
    for (int byte = 0; byte <= 0xFF; byte++) {
        uint32_t crc = byte << 24;
        for (int i = 8; i--;)
            crc = (crc << 1) ^ (crc & 0x80000000 ? polynomial : 0);
        crc32_table[byte] = crc;
    }
}


uint8_t get_crc8(uint8_t *ptr, uint32_t len, uint8_t crc, uint8_t final_xor)
{
    while (len--)
        crc = crc8_table[crc ^ *ptr++];
    return crc ^ final_xor;
}

uint16_t get_crc16(uint8_t *ptr, uint32_t len, uint16_t crc, uint16_t final_xor)
{
    while (len--)
        crc = (crc << 8) ^ crc16_table[(crc >> 8) ^ *ptr++];
    return crc ^ final_xor;
}

uint32_t get_crc32(uint8_t *ptr, uint32_t len, uint32_t crc, uint32_t final_xor)
{
    while (len--)
        crc = (crc << 8) ^ crc32_table[(crc >> 24) ^ *ptr++];
    return crc ^ final_xor;
}

int main(void)
{
    make_crc8_table(0x07);
    make_crc16_table(0x1021);
    make_crc32_table(0x4C11DB7);

    uint8_t input[] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39};

    uint8_t res1 = get_crc8(input, sizeof(input), 0, 0);
    printf("crc8 result = 0x%02X\n", res1);

    uint16_t res2 = get_crc16(input, sizeof(input), 0, 0);
    printf("crc16 result = 0x%04X\n", res2);

    uint32_t res3 = get_crc32(input, sizeof(input), 0xFFFFFFFF, 0xFFFFFFFF);
    printf("crc32 result = 0x%08X\n", res3);

    return 0;
}
