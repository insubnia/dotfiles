#pragma once
#include <queue>
#include <string>
#include <chrono>
#include <thread>

using namespace std;

class Application {
private:
    volatile bool loop = true;
    queue<string> qin;
    string name;

    void SetName(string name_) { name = name_; }

    void InputThread(void);
    void InputHandler(string input);

public:
    void Init(void);
    void Process(void);

    void ClearScreen(void)
    {
#ifdef __WIN32
        system("cls");
#else
        system("clear");
#endif
    }
};

__attribute__((weak)) int usleep(unsigned int usec)
{
    this_thread::sleep_for(chrono::microseconds(usec));
    return 0;
}

__attribute__((weak)) void msleep(unsigned int msec)
{
    this_thread::sleep_for(chrono::milliseconds(msec));
}

