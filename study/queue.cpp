#include <cstdio>
#include <cstring>
#include <iostream>

using namespace std;

enum {
    None = -1,
    VDISP,
    IDC,
    IDS1,
    IDS2,
    IVC,
    NUM,
};

static int8_t queue[NUM] = {[VDISP ... NUM - 1] = None};

const char* get_name(int nr)
{
    switch (nr) {
    case None: return "None";
    case VDISP: return "VDISP";
    case IDC: return "IDC";
    case IDS1: return "IDS1";
    case IDS2: return "IDS2";
    case IVC: return "IVC";
    default: return "Unkown";
    }
}

void print_queue(void)
{
    for (uint32_t i = 0; i < sizeof(queue); i++)
        printf("%s, ", get_name(queue[i]));
    printf("\n");
}

int8_t get_qlen(void)
{
    for (uint32_t i = 0; i < sizeof(queue); i++) {
        if (queue[i] == None)
            return i;
    }
    return sizeof(queue);
}

void enq(uint8_t data_in)
{
    printf("enqueue %s\n", get_name(data_in));
    uint8_t qlen = get_qlen();

    for (int i = 0; i < qlen; i++) {
        if (queue[i] == data_in) {
            memcpy(&queue[i], &queue[i + 1], qlen - i);
            queue[qlen - 1] = data_in;
            return;
        }
    }
    queue[qlen] = data_in;
}

int8_t deq(void)
{
    printf("dequeue\n");
    int8_t data_out = queue[0];
    uint8_t qlen = get_qlen();

    if (qlen > 1)
        memcpy(queue, &queue[1], qlen - 1);
    queue[qlen - 1] = None;

    return data_out;
}

int main(void)
{
    enq(VDISP);
    print_queue();
    enq(IVC);
    print_queue();
    enq(IDC);
    print_queue();
    enq(VDISP);
    print_queue();
    enq(IDS1);
    print_queue();

    deq();

    enq(IDC);
    print_queue();
    enq(IDS1);
    print_queue();
    enq(IDS2);
    print_queue();
    enq(IDS2);
    print_queue();
    enq(IDC);
    print_queue();
    enq(IVC);
    print_queue();

    deq();
    deq();
    deq();
    print_queue();
    deq();
    deq();
    print_queue();
    deq();
    deq();
    print_queue();

    return 0;
}
