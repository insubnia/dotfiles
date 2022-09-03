#include <iostream>
#include <cstdio>
#include <cstdint>
#include <cstdbool>
#include <cstring>
#include <unistd.h>

using namespace std;

inline void msleep(int mseconds) { usleep(mseconds * 1000); }

volatile bool loop = true;
string input;

void *user_input_thread(void *)
{
    while (loop) {
        getline(cin, input);

        if (!input.compare("exit")) {
            loop = false;
            cout << "Let's get out of here." << endl;
        } else {
            cout << input << endl;
        }
        fflush(stdout);
    }
    pthread_exit(NULL);
}

int main(void)
{
    pthread_t t_id;
    pthread_create(&t_id, 0, user_input_thread, 0);

    while (loop) {
        cout << "sis > ";
        fflush(stdout);

        input = "";
        while (!input.compare("")) ;

        /* user input handling  */
        if (!input.compare("hell")) {
            cout << "enter here" << endl;
        }

        // fflush(stdout);
        msleep(100);
    }
    return 0;
}
