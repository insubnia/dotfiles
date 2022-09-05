#include <iostream>
#include <cstdio>
#include <cstdint>
#include <cstdbool>
#include <cstring>
#include <unistd.h>

#include <thread>
#include <queue>

using namespace std;

inline void msleep(int mseconds) { usleep(mseconds * 1000); }

volatile bool loop = true;

queue<string> input_queue;

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
        
        if (input.length() == 0) {
        } else if (!input.compare("exit")) {
            loop = false;
        } else {
            cout << input << endl;
        }

        msleep(10);
    }

    user_input_thread.join();

    return 0;
}
