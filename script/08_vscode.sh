extension_list=(
    # Language
    ms-vscode.cpptools
    xaver.clang-format
    llvm-vs-code-extensions.vscode-clangd
    mitaki28.vscode-clang
    XadillaX.viml
    # Essential
    vscodevim.vim
    ms-vscode-remote.remote-ssh
    ms-azuretools.vscode-docker
    # Web
    ms-vscode.live-server
    # Theme
    dracula-theme.theme-dracula
    tinkertrain.theme-panda
    enkia.tokyo-night
    sdras.night-owl
    GitHub.github-vscode-theme
    felipe-mendes.slack-theme
    mariorodeghiero.vue-theme
    # etc
    PKief.material-icon-theme
)

for e in ${extension_list[@]}
do
    code --install-extension $e
done
