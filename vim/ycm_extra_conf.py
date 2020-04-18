import os

EXCLUDE = [".git", ".svn"]


def FlagsForFile(filename, **kwargs):
    dirs = []
    for p, d, f in os.walk("."):
        if not any(e in p for e in EXCLUDE):
            dirs.append("-I" + p)

    flags = []
    # flags = ["-W", "-Wall"]
    flags.extend(dirs)

    return {
        'flags': flags,
    }


if __name__ == "__main__":
    pass
