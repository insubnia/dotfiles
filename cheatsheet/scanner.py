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

    def get_info(self):
        return self.x, self.y, self.r

    @property
    def coord_text(self):
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
        s = f"[{self.nr}]{self.addr} {self.coord_text}<{self.rssi_1m}dB> {Fore.GREEN}{self.name:>6}{Fore.RESET} »"
        s += f" RSSIs: {self.rssis} →"
        s += f" {Fore.CYAN}{self.rssi:6.2f}dB{Fore.RESET}"
        s += f" → {Fore.RED}{self.r:.1f}m{Fore.RESET}"
        print(s)


class Localizer():
    def __init__(self, beacons: List[Beacon]):
        self.beacons = beacons
        self.x, self.y = 0, 0

    def find_beacon(self, addr: str):
        for beacon in self.beacons:
            if beacon.addr == addr:
                return beacon
        return None

    def triangulation(self):
        x0, y0, r0 = self.beacons[0].get_info()
        x1, y1, r1 = self.beacons[1].get_info()
        x2, y2, r2 = self.beacons[2].get_info()
        x3, y3, r3 = self.beacons[3].get_info()

        a = np.array(
            [[2 * (x1 - x0), 2 * (y1 - y0)],
             [2 * (x2 - x0), 2 * (y2 - y0)],
             [2 * (x3 - x0), 2 * (y3 - y0)]]
        )
        b = np.array(
            [[r0**2 - r1**2 + x1**2 + y1**2 - x0**2 - y0**2],
             [r0**2 - r2**2 + x2**2 + y2**2 - x0**2 - y0**2],
             [r0**2 - r3**2 + x3**2 + y3**2 - x0**2 - y0**2]]
        )
        c = np.linalg.inv(np.matmul(np.transpose(a), a))
        d = np.matmul(np.transpose(a), b)
        e = np.matmul(c, d)
        self.x, self.y = e[0][0], e[1][0]

    @property
    def coord_text(self):
        return f"({self.x:3.1f}, {self.y:3.1f})"

    @property
    def beacon_num(self):
        return len(self.beacons)


_beacons = [
    # Beacon('D0:15:CE:BB:7A:98', x=0, y=0, rssi_1m=-50, name='sis'),
    # Beacon('FB:D5:7C:CA:BD:CE', x=10, y=0, rssi_1m=-50, name='iron'),
    # Beacon('F7:E7:CD:96:B5:6B', x=0, y=10, rssi_1m=-50, name='table'),
    # Beacon('78:46:7D:00:C2:1F', x=10, y=10, rssi_1m=-46, name='iris'),
    Beacon('78:46:7D:00:C1:C2', x=0, y=0, rssi_1m=-58, name='iris_31'),
    Beacon('78:46:7D:00:C0:5A', x=5, y=0, rssi_1m=-58, name='iris_34'),
    Beacon('78:46:7D:00:BF:14', x=0, y=5, rssi_1m=-58, name='iris_35'),
    Beacon('78:46:7D:00:C0:7B', x=5, y=5, rssi_1m=-58, name='iris_36'),
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
        clear_screen()
        localizer.triangulation()
        print(f"\n{Fore.BLUE}({now()})  📍{localizer.coord_text}{Fore.RESET}")
        [b.print_info() for b in localizer.beacons]
        await asyncio.sleep(1)

    await scanner.stop()


if __name__ == "__main__":
    asyncio.run(main())
