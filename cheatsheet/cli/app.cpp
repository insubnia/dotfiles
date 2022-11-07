#include <iostream>
#include <thread>
#include <unistd.h>

#include "app.hpp"

void Application::Init(void)
{
    SetName("sis");
}

void Application::Process(void)
{
    ClearScreen();

    // thread _t(&Application::InputThread, this);
    thread _t([this]{ InputThread(); });
    while (loop) {
        cout << name + "@MBP$ " << flush;
        while (qin.empty())
            usleep(100);

        string input = qin.front();
        qin.pop();
        InputHandler(input);
    }
    _t.join();
}

void Application::InputThread(void)
{
    while (loop) {
        string buf;
        getline(cin, buf);
        qin.push(buf);
        usleep(100);
    }
}

void Application::InputHandler(string input)
{
    if (input.length() == 0) {
        /* NOP */
    } else if (input.length() == 1) {
        char ch = input.c_str()[0];
        switch (ch) {
        /**************************************/
        case 'q':
            loop = false;
            break;
        /**************************************/
        default:
            cout << " (ch)" << ch << endl;
            break;
        }
    // } else if (input == "") {
    } else if (input == "exit") {
        loop = false;
    } else if (input == "clear" || input == "cls") {
        ClearScreen();
    } else {
        cout << " " << input << endl;
    }

    if (!loop)
        cout << "\nTerminate program" << endl;
}

