#!/usr/bin/python3
import os
import time
import signal
import asyncio
import numpy as np
from datetime import datetime, timedelta
from threading import Thread
from bleak import BleakScanner
from colorama import Fore
from typing import List

MAX_WINDOW_LEN = 10


class Loop():
    def __init__(self):
        self.loop = True
        signal.signal(signal.SIGINT, self.signal_handler)

    __bool__ = lambda self: self.loop

    def signal_handler(self, *_):
        self.loop = False
        print(f"\n{Fore.RED} • Terminate program!{Fore.RESET}\n")
        Thread(target=lambda: (time.sleep(3), os._exit(0)), daemon=True).start()


class Beacon():
    num = 0

    def __init__(self, addr, x=0.0, y=0.0, rssi_1m=-45, name=''):
        self.addr = addr
        self.x, self.y = x, y
        self.name = name
        self.rssi_1m = rssi_1m
        self.rssis = []

        self.nr = Beacon.num
        Beacon.num += 1

    def put_rssi(self, rssi_raw):
        if len(self.rssis) > MAX_WINDOW_LEN:
            self.rssis.pop(0)
        self.rssis.append(rssi_raw)

    @property
    def coord(self):
        return f"({self.x:3.1f}, {self.y:3.1f})"

    @property
    def rssi(self):
        if len(self.rssis):
            # INFO: put filter here
            arr = np.array(self.rssis)
            return arr.mean()
        return 0

    @property
    def r(self):
        n = 4
        d = 10 ** ((self.rssi_1m - self.rssi) / (10 * n))
        return d

    def print_info(self):
        s = f"[{self.nr}]{self.addr} {self.coord} {Fore.GREEN}{self.name:>6}{Fore.RESET} »"
        s += f" RSSIs: {self.rssis} →"
        s += f" {Fore.CYAN}{self.rssi:6.2f}dB{Fore.RESET}"
        s += f" → {Fore.RED}{self.r:.1f}m{Fore.RESET}"
        print(s)


class Localizer():
    def __init__(self, beacons: List[Beacon]):
        self.beacons = beacons

    def find_beacon(self, addr: str):
        for beacon in self.beacons:
            if beacon.addr == addr:
                return beacon
        return None

    @property
    def beacon_num(self):
        return len(self.beacons)


_beacons = [
    Beacon('D0:15:CE:BB:7A:98', x=4, y=2, rssi_1m=-50, name='sis'),
    Beacon('FB:D5:7C:CA:BD:CE', x=7, y=0, rssi_1m=-50, name='iron'),
    Beacon('F7:E7:CD:96:B5:6B', x=1, y=3, rssi_1m=-50, name='table'),
    Beacon('78:46:7D:00:C2:1F', x=3, y=4, rssi_1m=-46, name='iris'),
]
localizer = Localizer(_beacons)


def now():
    _now = datetime.now()
    return _now - timedelta(microseconds=_now.microsecond)


def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')


def detection_callback(dev, data):
    beacon = localizer.find_beacon(dev.address)
    if beacon is None:
        return
    beacon.put_rssi(data.rssi)
    # print(f"{Fore.GREEN}[{beacon.nr}] {dev.address} > RSSI: {data.rssi}dB{Fore.RESET}")
    # print(f"\t{Fore.BLUE}{data}{Fore.RESET}")


async def main():
    scanner = BleakScanner(detection_callback=detection_callback)
    await scanner.start()

    loop = Loop()
    while loop:
        # clear_screen()
        print(f"{Fore.BLUE}({now()}){Fore.RESET}")
        [b.print_info() for b in localizer.beacons]
        await asyncio.sleep(1)
        print()

    await scanner.stop()


if __name__ == "__main__":
    asyncio.run(main())
