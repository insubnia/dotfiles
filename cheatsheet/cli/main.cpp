#include <iostream>
#include <cstdio>
#include <cstdint>
#include <cstdbool>
#include <cstring>
#include <unistd.h>

#include <thread>
#include <queue>

using namespace std;

volatile bool loop = true;
queue<string> input_queue;

int input_handler(string input);

inline void msleep(int mseconds) { usleep(mseconds * 1000); }

void user_input(void)
{
    while (loop) {
        string buf_in;
        getline(cin, buf_in);
        input_queue.push(buf_in);
        usleep(50);
    }
    pthread_exit(NULL);
}

int main(void)
{
    std::thread user_input_thread(user_input);

    while (loop) {
        cout << "sis > ";
        fflush(stdout);

        while (input_queue.empty())
            usleep(50);

        string input = input_queue.front();
        input_queue.pop();

        input_handler(input);
        msleep(10);
    }
    user_input_thread.join();

    return 0;
}

int input_handler(string input)
{
    if (input.length() == 0) {
        /* do nothing */
    } else if (input.length() == 1) {
        char ch = input.c_str()[0];
        switch (ch) {
        default:
            cout << "ch: " << ch << endl;
            break;
        }
    } else if (input == "exit") {
        loop = false;
    } else {
        cout << " " << input << endl;
        return 1;
    }
    return 0;
}
