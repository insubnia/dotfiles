#include <iostream>
#include <cstdio>
#include <cstdint>
#include <cstdbool>
#include <cstring>
#include <unistd.h>
#include <thread>

using namespace std;

inline void msleep(int mseconds) { usleep(mseconds * 1000); }

volatile bool loop = true;

#define NEXT_INPUT_INTERVAL 1000 // useconds

volatile bool wait_for_input = true;
string input;

void user_input(void)
{
    while (loop) {
        wait_for_input = true;

        input.clear();
        getline(cin, input);

        wait_for_input = false;
        usleep(NEXT_INPUT_INTERVAL);
    }
    pthread_exit(NULL);
}

int main(void)
{
    std::thread user_input_thread(user_input);

    while (loop) {
        cout << "sis > ";
        fflush(stdout);
        while (wait_for_input)
            usleep(100);

        if (input.length() == 0) {
            usleep(NEXT_INPUT_INTERVAL + 10);
            continue;
        }

        if (!input.compare("exit")) {
            loop = false;
        } else if (!input.compare("test")) {
            cout << "this is test " << endl;
        } else {
            cout << input << endl;
        }

        msleep(100);
    }

    user_input_thread.join();

    return 0;
}
