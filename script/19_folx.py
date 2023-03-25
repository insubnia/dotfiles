#!/opt/homebrew/bin/python3
import re
import os
import glob
from colorama import Fore

# ln -sf ~/workspace/dotfiles/script/19_folx.py ~/workspace/folx/main.py

print()

dirs = glob.glob(f'{os.path.dirname(__file__)}/*' + os.path.sep)
for d in dirs:
    print(f"{Fore.BLUE}[{d}]{Fore.RESET}")
    paths = glob.glob(f'{d}/*.mp4')
    paths = list(reversed(sorted(paths, key=lambda x: os.stat(x).st_size)))

    for path in paths:
        old = os.path.basename(path)
        new = re.sub(r'^.+\.com@', r'', old)
        print(f"\t{old} ➡️  {new}")

        new_path = f"{d}{new}"
        os.rename(path, new_path)


if __name__ == "__main__":
    pass
