#!/opt/homebrew/bin/python3
import glob
import os
import re
import subprocess
import sys
from colorama import Fore

# ln -sf ~/workspace/dotfiles/script/19_folx.py ~/workspace/folx/main.py


def validate_mp4(mp4_path: str):
    proc = subprocess.run(
            ['MP4Box', '-info', mp4_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
            )
    output = (proc.stdout + proc.stderr).lower()

    error_keywords = [
            "moov"
            # "error",
            # "invalid",
            # "broken",
            # "corrupt",
            # "bad",
            # "missing moov"
            ]

    if proc.returncode != 0:
        return False
    elif any(k in output for k in error_keywords):
        # print(f"{Fore.RED}{mp4_path}{Fore.RESET}")
        # print(output)
        return False
    return True


if len(sys.argv) > 1:
    target_dir = sys.argv[1]
else:
    target_dir = f'{os.path.dirname(__file__)}'

dirs = glob.glob(f'{target_dir}/*' + os.path.sep)
for d in dirs:
    print(f"{Fore.CYAN}[{d}]{Fore.RESET}")
    paths = glob.glob(f'{d}/*.mp4')
    paths = list(reversed(sorted(paths, key=lambda x: os.stat(x).st_size)))

    for path in paths:  # for searched mp4
        old = os.path.basename(path)
        if any(ord(v) > 127 for v in old):
            continue
        new = re.sub(r'^.+\.\w+@', r'', old)
        if old != new:
            print(f"\t{old} ➡️  {new}")

        new_path = f"{d}{new}"
        os.rename(path, new_path)
        if (not validate_mp4(new_path)) and True:
            new_path_underscore = new_path.replace('.mp4', '_.mp4')
            os.system(f"ffmpeg -i {new_path} -c copy {new_path_underscore}")

    os.system(f"rm -rf {d}/*.txt")
    os.system(f"rm -rf {d}/*.url")


if __name__ == "__main__":
    pass
