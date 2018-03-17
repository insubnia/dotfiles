import os

def FlagsForFile(filename, **kwargs):
    inc_dirs = []
    for i,j,k in os.walk("."):
        if ".git" in i:
            pass
        else:
            inc_dirs += ["-I" + i]

    flags = ["-W", "-Wall"]
    flags.extend(inc_dirs)

    return {
            'flags': flags,
            }
