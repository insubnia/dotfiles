@echo off
set Wireshark=%APPDATA%\Wireshark

del /f %Wireshark%\hosts
mklink "%Wireshark%\hosts" "%cd%\hosts"

del /f %Wireshark%\dfilter_buttons
mklink "%Wireshark%\dfilter_buttons" "%cd%\dfilter_buttons"

if exist %Wireshark%\plugins (
    del /f %Wireshark%\plugins\EthDiag.lua
    del /f %Wireshark%\plugins\EthNM.lua
) else (
    mkdir %Wireshark%\plugins
)
mklink "%Wireshark%\plugins\EthDiag.lua" "%cd%\EthDiag.lua"
mklink "%Wireshark%\plugins\EthNM.lua" "%cd%\EthNM.lua"
