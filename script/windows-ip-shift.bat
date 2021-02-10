@echo off
title IP Shifter
set NIC=Wi-Fi

:MENU
cls && echo.
echo [ IP List ]
echo 1. DHCP
echo 2. MANDO
echo.
set /p num=Select Config: 
if "%num%"=="1" goto DHCP
if "%num%"=="2" goto MANDO
goto MENU

:DHCP
netsh -c int ip set address "%NIC%" dhcp
netsh int ip set dns "%NIC%" dhcp
goto FINISH

:MANDO
netsh -c int ip set address "%NIC%" static 172.20.101.130 255.255.255.0 172.20.101.11 1
netsh int ip set dns "%NIC%" static 191.1.10.100 primary validate=no
netsh int ip add dns "%NIC%" 191.1.10.101 index=2 validate=no
goto FINISH

:FINISH
:: PAUSE
EXIT
