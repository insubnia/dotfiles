#!usr/bin/python3
import os
import sys
import time
import signal
import logging
import requests
from threading import Thread
from datetime import datetime
from colorama import Fore

logging.basicConfig(format=f"{Fore.CYAN}(%(levelname)s)(%(asctime)s) %(message)s{Fore.RESET}",
                    datefmt="%Y-%m-%d %H:%M:%S",
                    level=logging.WARNING)


def resource_path(relpath):
    if hasattr(sys, '_MEIPASS'):
        cwd = getattr(sys, '_MEIPASS')
    else:
        cwd = os.getcwd()
    return os.path.abspath(os.path.join(cwd, relpath))


class Loop():
    def __init__(self):
        self.loop = True
        signal.signal(signal.SIGINT, self.signal_handler)
    def __bool__(self):
        return self.loop
    def __str__(self):
        return "True" if self.loop else "False"

    def signal_handler(self, signum, frame):
        self.loop = False
        print(f"\n{Fore.RED} 🛑 Terminate program!{Fore.RESET}\n")
        Thread(target=lambda:(time.sleep(3), os._exit(0)), daemon=True).start()

loop = Loop()


def lapse(func):
    def wrapper(*args, **kwargs):
        start_time = time.perf_counter()
        result = func(*args, **kwargs)
        end_time = time.perf_counter()
        print(f"{Fore.WHITE} ⏱️  {func.__name__} took {end_time - start_time:.4f} secs{Fore.RESET}")
        return result
    return wrapper

def get_public_ip():
    return requests.get("https://api.ipify.org").text

def xdatetime(_datetime=None):
    if _datetime is None:
        _datetime = datetime.now().astimezone()
    elif not isinstance(_datetime, datetime):
        return ""
    return _datetime.strftime("%Y-%m-%d %H:%M:%S")


# https://gist.github.com/michelbl/efda48b19d3e587685e3441a74457024
if os.name == 'nt':
    import msvcrt
else:  # UNIX
    import termios
    import atexit
    from select import select

class Conio:
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

    def kbhit(self):
        if os.name == 'nt':
            return msvcrt.kbhit()
        else:
            dr, dw, de = select([sys.stdin], [], [], 0)
            return dr != []

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


if __name__ == "__main__":
    print(resource_path('./core.py'))
    print(xdatetime())

    print(f"{Fore.BLUE}\nHit any key or ESC to exit{Fore.RESET}")
    conio = Conio()
    while loop:
        if conio.kbhit():
            ch = conio.getch()
            if ord(ch) == 27:  # ESC
                print("ESC pressed\n")
                break
            else:
                print(f" {ch}")
    # conio.set_normal_term()
