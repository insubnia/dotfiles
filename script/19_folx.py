#!/opt/homebrew/bin/python3
import re
import os
import glob
from colorama import Fore

# ln -sf ~/workspace/dotfiles/script/19_folx.py ~/workspace/folx/main.py

dirs = glob.glob(f'{os.path.dirname(__file__)}/*' + os.path.sep)
for d in dirs:
    print(f"{Fore.CYAN}[{d}]{Fore.RESET}")
    paths = glob.glob(f'{d}/*.mp4')
    paths = list(reversed(sorted(paths, key=lambda x: os.stat(x).st_size)))

    for path in paths:
        old = os.path.basename(path)
        if any(ord(v) > 127 for v in old):
            continue
        new = re.sub(r'^.+\.\w+@', r'', old)
        if old != new:
            print(f"\t{old} ➡️  {new}")

        new_path = f"{d}{new}"
        os.rename(path, new_path)

    os.system(f"rm -rf {d}/*.txt")


if __name__ == "__main__":
    pass
