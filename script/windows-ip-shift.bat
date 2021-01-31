@echo off
title IP Shifter
set NIC=Wi-Fi

:MENU
cls
echo 1. MANDO
echo 2. DHCP
set /p num=Select Config: 
if "%num%"=="1" goto MANDO
if "%num%"=="2" goto DHCP
goto MENU

:MANDO
netsh -c int ip set address "%NIC%" static 172.20.101.130 255.255.255.0 172.20.101.11 1
netsh int ip set dns "%NIC%" static 191.1.10.100 primary validate=no
netsh int ip add dns "%NIC%" 191.1.10.101 index=2 validate=no
goto FINISH

:DHCP
netsh -c int ip set address "%NIC%" dhcp
netsh int ip set dns "%NIC%" dhcp
goto FINISH

:FINISH
:: PAUSE
EXIT
