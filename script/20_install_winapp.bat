:: replace 'choco' with 'winget' later

:: tool
choco install -y powertoys
choco install -y chocolateygui
choco install -y googlechrome
choco install -y onedrive
REM  choco install -y vlc
choco install -y adobereader
choco install -y bandizip
choco install -y vim
choco install -y neovim
choco install -y smartgit
choco install -y sourcetree
choco install -y vscode
choco install -y caffeine
choco install -y everything
choco install -y foxe
choco install -y winpcap
choco install -y wireshark
choco install -y iperf3
choco install -y ntop
@REM choco install -y tortoisegit
REM  choco install -y flashplayerplugin

:: server-client
choco install -y openssh
choco install -y telnet
choco install -y mobaxterm
choco install -y putty
REM  choco install -y teraterm
REM  choco install -y winscp

:: dev
choco install -y git
choco install -y ack
choco install -y fd
choco install -y llvm
choco install -y make
choco install -y ctags
choco install -y cmake
choco install -y python3
choco install -y lua
choco install -y nvm
choco install -y nodejs
choco install -y yarn
choco install -y jq
choco install -y wget
choco install -y dos2unix
choco install -y visualcpp-build-tools
choco install -y microsoft-windows-terminal
choco install -y gcc-arm-embedded
REM  choco install -y vcxsrv

:: font
choco install -y d2codingfont
choco install -y nerdfont-hack

:: git
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force

iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
