#pragma once
#include <queue>
#include <string>

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

    int ClearScreen(void)
    {
#ifdef __WIN32
        return system("cls");
#else
        return system("clear");
#endif
    }
};

