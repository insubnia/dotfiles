#!/opt/homebrew/bin/python3
import re
import os
import sys
import glob
from colorama import Fore

# ln -sf ~/workspace/dotfiles/script/19_folx.py ~/workspace/folx/main.py

if len(sys.argv) > 1:
    target_dir = sys.argv[1]
else:
    target_dir = f'{os.path.dirname(__file__)}'

dirs = glob.glob(f'{target_dir}/*' + os.path.sep)
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
    os.system(f"rm -rf {d}/*.url")


if __name__ == "__main__":
    pass
