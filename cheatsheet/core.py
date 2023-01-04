#!usr/bin/python3
import os
import sys
import signal
from colorama import Fore

def resource_path(relpath):
    if hasattr(sys, '_MEIPASS'):
        cwd = getattr(sys, '_MEIPASS')
    else:
        cwd = os.getcwd()
    return os.path.abspath(os.path.join(cwd, relpath))

def signal_handler(signum, frame):
    print(f"{Fore.RED}Terminate program!{Fore.RESET}\n")
    sys.exit()
signal.signal(signal.SIGINT, signal_handler)


# https://gist.github.com/michelbl/efda48b19d3e587685e3441a74457024
if os.name == 'nt':
    import msvcrt
else:  # UNIX
    import sys
    import termios
    import atexit
    from select import select

class KBHIT:
    def __init__(self):
        if os.name != 'nt':
            # backup terminal settings
            self.fd = sys.stdin.fileno()
            self.new_term = termios.tcgetattr(self.fd)
            self.old_term = termios.tcgetattr(self.fd)

            # New terminal setting unbuffered
            self.new_term[3] = (self.new_term[3] & ~termios.ICANON & ~termios.ECHO)
            termios.tcsetattr(self.fd, termios.TCSAFLUSH, self.new_term)

            # Support normal-terminal reset at exit
            atexit.register(self.set_normal_term)

    def set_normal_term(self):
        if os.name != 'nt':
            termios.tcsetattr(self.fd, termios.TCSAFLUSH, self.old_term)

    def getch(self):
        if os.name == 'nt':
            ch = msvcrt.getch()
            try:
                ch = ch.decode('utf-8')
            except UnicodeDecodeError:
                ch = None
        else:
            ch = sys.stdin.read(1)
        return ch

    def getarrow(self):
        if os.name == 'nt':
            msvcrt.getch()  # skip 0xE0
            c = msvcrt.getch()
            vals = [72, 77, 80, 75]
        else:
            c = sys.stdin.read(3)[2]
            vals = [65, 67, 66, 68]
        return vals.index(ord(c.decode('utf-8')))

    def kbhit(self):
        if os.name == 'nt':
            return msvcrt.kbhit()
        else:
            dr, dw, de = select([sys.stdin], [], [], 0)
            return dr != []


if __name__ == "__main__":
    print(resource_path('./core.py'))

    print(f"{Fore.BLUE}\nHit any key or ESC to exit{Fore.RESET}")
    kb = KBHIT()
    while True:
        if kb.kbhit():
            ch = kb.getch()
            if ord(ch) == 27:  # ESC
                print("ESC pressed\n")
                break
            else:
                print(ch)
    kb.set_normal_term()
