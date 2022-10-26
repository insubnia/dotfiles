#include <iostream>
#include <cstdbool>
#include <cstring>
#include <thread>
#include <queue>
#include <unistd.h>

#include "app.hpp"

using namespace std;

volatile bool loop = true;
queue<string> input_queue;

void user_input(void);
int user_input_handler(string input);

inline void msleep(int mseconds) { usleep(mseconds * 1000); }

int main(void)
{
#if 1
    Application app;
    app.Init();
    app.Process();
    return 0;
#else
    std::thread user_input_thread(user_input);
    while (loop) {
        cout << "sis > ";
        fflush(stdout);

        while (input_queue.empty())
            usleep(50);

        string input = input_queue.front();
        input_queue.pop();

        user_input_handler(input);
        msleep(10);
    }
    user_input_thread.join();
    return 0;
#endif
}

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

int user_input_handler(string input)
{
    if (input.length() == 0) {
        /* do nothing */
    } else if (input.length() == 1) {
        char ch = input.c_str()[0];
        switch (ch) {
        case 'q':
            loop = false;
            break;
        default:
            cout << " ch: " << ch << endl;
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

