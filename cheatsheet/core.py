#!usr/bin/python3
import os
import sys
import time
import signal
import asyncio
import logging
import requests
import platform
import numpy as np
import pandas as pd
from datetime import datetime, timedelta
from functools import partial, wraps
from threading import Thread
from colorama import Fore
from typing import Union

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
    __bool__ = lambda self: self.loop
    __str__ = lambda self: "True" if getattr(self, 'loop') else "False"

    def signal_handler(self, *_):
        self.loop = False
        print(f"\n{Fore.RED} 🛑 Terminate program!{Fore.RESET}\n")
        Thread(target=lambda: (time.sleep(3), os._exit(0)), daemon=True).start()


loop = Loop()


class timeout():
    """ https://stackoverflow.com/questions/2281850/timeout-function-if-it-takes-too-long-to-finish
        with timeout(3):
            time.sleep(4)
    """
    def __init__(self, seconds=10):
        signal.signal(signal.SIGALRM, self.timeout_handler)
        signal.alarm(seconds)
    __enter__ = lambda self: None
    __exit__ = lambda self, *_: signal.alarm(0)

    def timeout_handler(self, *_):
        raise TimeoutError("User-Defined Timeout")


def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')


# https://dev.to/0xbf/turn-sync-function-to-async-python-tips-58nn
def async_wrap(func):
    @wraps(func)
    async def run(*args, loop=None, executor=None, **kwargs):
        loop = loop or asyncio.get_event_loop()
        pfunc = partial(func, *args, **kwargs)
        return await loop.run_in_executor(executor, pfunc)
    return run


def alarm(string="가즈아"):
    freq, duration = 2000, 1000
    if platform.system() == 'Darwin':
        os.system(f"say -v Yuna {string}")
        sys.stdout.write("\a")
    elif platform.system() == 'Linux':
        # os.system(f"beep -f {freq} -l {duration}")
        os.system("printf '\007'")
    elif getattr(os, 'name') == 'nt':
        import winsound as ws
        ws.Beep(freq, duration)

def lapse(func):
    def wrapper(*args, **kwargs):
        start_time = time.perf_counter()
        result = func(*args, **kwargs)
        end_time = time.perf_counter()
        print(f"{Fore.WHITE} ⏱️  {func.__name__} took {end_time - start_time:.4f} secs{Fore.RESET}")
        return result
    return wrapper

def get_public_ip():
    # return requests.get("https://api.ipify.org").text
    return requests.get('https://ipapi.co/ip/').text


def xdatetime(_datetime=None) -> str:
    _datetime = _datetime or datetime.now().astimezone()
    assert isinstance(_datetime, datetime)
    return _datetime.strftime("%Y-%m-%d %H:%M:%S")

def to_datetime(t) -> datetime:
    return pd.to_datetime(t).to_pydatetime().astimezone()

def trim_usec(input: Union[datetime, timedelta]) -> Union[datetime, timedelta]:
    if isinstance(input, datetime):
        return input - timedelta(microseconds=input.microsecond)
    elif isinstance(input, timedelta):
        return input - timedelta(microseconds=input.microseconds)

def now() -> datetime:
    return trim_usec(datetime.now().astimezone())

def epoch() -> datetime:
    return datetime.utcfromtimestamp(0).astimezone()

def get_interval(input: Union[pd.Index, pd.DataFrame, pd.Series]) -> int:
    if type(input) in (pd.DataFrame, pd.Series):
        input = input.index
    """
    itvs = []
    for i in range(len(input) - 1)[::10]:  # 1/10 sampling and then return median value
        itv = int((to_datetime(input[i + 1]) - to_datetime(input[i])).total_seconds()) // 60
        itvs.append(itv)
    return sorted(itvs)[len(itvs) // 2]
    """
    itvs = pd.Series(np.NaN, input)
    for i in range(1, len(input)):
        itvs[i] = (to_datetime(input[i]) - to_datetime(input[i - 1])).total_seconds() // 60
    return int(itvs.value_counts().idxmax())


def get_elapsed_minutes(since=None) -> int:
    since = since or epoch()
    return int((now() - to_datetime(since)).total_seconds()) // 60


def _print(color, /, *args, **kwargs):
    print(color, end="")
    print(*args, **kwargs)
    print(Fore.RESET, end="")
printk = partial(_print, Fore.BLACK)
printr = partial(_print, Fore.RED)
printg = partial(_print, Fore.GREEN)
printy = partial(_print, Fore.YELLOW)
printb = partial(_print, Fore.BLUE)
printm = partial(_print, Fore.MAGENTA)
printc = partial(_print, Fore.CYAN)
printw = partial(_print, Fore.WHITE)
printlk = partial(_print, Fore.LIGHTBLACK_EX)
printlr = partial(_print, Fore.LIGHTRED_EX)
printlg = partial(_print, Fore.LIGHTGREEN_EX)
printly = partial(_print, Fore.LIGHTYELLOW_EX)
printlb = partial(_print, Fore.LIGHTBLUE_EX)
printlm = partial(_print, Fore.LIGHTMAGENTA_EX)
printlc = partial(_print, Fore.LIGHTCYAN_EX)
printlw = partial(_print, Fore.LIGHTWHITE_EX)


# https://gist.github.com/michelbl/efda48b19d3e587685e3441a74457024
if getattr(os, 'name') == 'nt':
    import msvcrt
else:  # UNIX
    import termios
    import atexit
    from select import select

class Conio:
    def __init__(self):
        if getattr(os, 'name') != 'nt':
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

    def kbhit(self) -> bool:
        if getattr(os, 'name') == 'nt':
            return msvcrt.kbhit()
        else:
            dr, _, _ = select([sys.stdin], [], [], 0)
            return dr != []

    def getch(self) -> Union[str, None]:
        if getattr(os, 'name') == 'nt':
            ch = msvcrt.getch()
            try:
                ch = ch.decode('utf-8')
            except UnicodeDecodeError:
                ch = None
        else:
            ch = sys.stdin.read(1)
        return ch

    def getarrow(self):
        if getattr(os, 'name') == 'nt':
            msvcrt.getch()  # skip 0xE0
            c = msvcrt.getch()
            vals = [72, 77, 80, 75]
        else:
            c = sys.stdin.read(3)[2]
            vals = [65, 67, 66, 68]
        return vals.index(ord(c.decode('utf-8')))


if __name__ == "__main__":
    printy(resource_path('./core.py'))
    printg(xdatetime())

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
