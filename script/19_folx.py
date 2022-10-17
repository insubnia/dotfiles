#!/opt/homebrew/bin/python3
import re
import os
import glob
from colorama import Fore

# ln -sf ~/workspace/dotfiles/script/19_folx.py ~/workspace/folx/main.py

print("\n\n")

dirs = glob.glob('./*' + os.path.sep)
for d in dirs:
    print(f"{Fore.BLUE}[{d}]{Fore.RESET}")
    files = glob.glob(f'{d}/*.mp4')
    files = list(reversed(sorted(files, key=lambda x: os.stat(x).st_size)))

    new_paths = []

    for file in files:
        old = os.path.basename(file)
        new = re.sub(r'^.+\.com@', r'', old)

        new_path = f"{d}{new}"
        os.rename(file, new_path)

        new_paths.append(new_path)

    print(files)
    print(new_paths)
    print()


if __name__ == "__main__":
    pass
