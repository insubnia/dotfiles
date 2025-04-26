#!/usr/bin/python3
import os
import sys
import shutil

extension_list = (
    # Essential
    'vscodevim.vim',
    'ms-vscode-remote.remote-ssh',
    'ms-azuretools.vscode-docker',
    # Language
    'ms-vscode.cpptools',
    'ms-vscode.cmake-tools',
    'xaver.clang-format',
    'llvm-vs-code-extensions.vscode-clangd',
    'mitaki28.vscode-clang',
    'XadillaX.viml',
    'DotJoshJohnson.xml',
    # Visual
    'SirTori.indenticator',
    'oderwat.indent-rainbow',
    # Web
    'ms-vscode.live-server',
    # Theme
    'dracula-theme.theme-dracula',
    'tinkertrain.theme-panda',
    'enkia.tokyo-night',
    'sdras.night-owl',
    'GitHub.github-vscode-theme',
    'felipe-mendes.slack-theme',
    'mariorodeghiero.vue-theme',
    # Work
    'VectorGroup.capl',
    'lauterbach.practice',
    'vrtlabs.vscode-lsl',
    'lharri73.dbc',
    # etc
    'mechatroner.rainbow-csv',
    'janisdd.vscode-edit-csv',
    'PKief.material-icon-theme',
)

if shutil.which('code') is None:
    print("command 'code' is not available")
    sys.exit()


if __name__ == '__main__':
    for e in extension_list:
        os.system(f'code --install-extension {e}')
