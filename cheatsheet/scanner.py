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

MAX_WINDOW_LEN = 10
ADDRS = (
    # '--:--:--:--:--:--',
    # 'C0:C5:42:91:6A:23',
    'D0:15:CE:BB:7A:98',
    'F7:E7:CD:96:B5:6B',
    'FB:D5:7C:CA:BD:CE',
)


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

    def __init__(self, addr, x=0, y=0):
        self.addr = addr
        self.x, self.y = x, y
        self.rssis = []

        self.nr = Beacon.num
        Beacon.num += 1

    def put_rssi(self, rssi):
        if len(self.rssis) > MAX_WINDOW_LEN:
            self.rssis.pop(0)
        self.rssis.append(rssi)

    @property
    def filtered_rssi(self):
        if len(self.rssis):
            # INFO: put filter here
            arr = np.array(self.rssis)
            return arr.mean()
        return 0

    @property
    def r(self):
        # INFO: put rssi to distance transformation here
        d = 100 - self.filtered_rssi
        return d

    def print_info(self):
        s = f"[{self.nr}]{self.addr} »"
        s += f" RSSIs: {self.rssis} ➡ {self.filtered_rssi:.2f}dB"
        s += f" ➡ {self.r:.2f}m"
        print(s)


beacons = {addr: Beacon(addr) for addr in ADDRS}


def now():
    _now = datetime.now()
    return _now - timedelta(microseconds=_now.microsecond)


def detection_callback(dev, data):
    if dev.address not in beacons:
        return
    beacon = beacons[dev.address]
    beacon.put_rssi(data.rssi)
    # print(f"{Fore.GREEN}[{beacon.nr}] {dev.address} > RSSI: {data.rssi}dB{Fore.RESET}")
    # print(f"\t{Fore.BLUE}{data}{Fore.RESET}")


async def main():
    scanner = BleakScanner(detection_callback=detection_callback)
    await scanner.start()

    loop = Loop()
    while loop:
        print(f"{Fore.BLUE}({now()}){Fore.RESET}")
        for beacon in beacons.values():
            beacon.print_info()
        await asyncio.sleep(1)
        print()

    await scanner.stop()


if __name__ == "__main__":
    asyncio.run(main())
