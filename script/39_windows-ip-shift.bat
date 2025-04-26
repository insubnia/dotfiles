@echo off
title IP Shifter
set NIC=CCU

:MENU
cls && echo.
echo [ IP List ]
echo 1. CCU_MCU
echo 2. CCU_AP
echo 3. DEBUG
echo 4. Lidar Left
echo 5. Lidar Right
echo 6. VPU
echo 9. DHCP
echo.
set /p num=Select Config: 
if "%num%"=="1" goto CCU_MCU
if "%num%"=="2" goto CCU_AP
if "%num%"=="3" goto DEBUG
if "%num%"=="4" goto LIDAR_LEFT
if "%num%"=="5" goto LIDAR_RIGHT
if "%num%"=="6" goto VP
if "%num%"=="9" goto DHCP
goto MENU

:DHCP
netsh -c int ip set address "%NIC%" dhcp
netsh int ip set dns "%NIC%" dhcp

goto FINISH

:CCU_MCU
netsh -c int ip set address "%NIC%" static 10.0.5.0 255.0.0.0 10.0.1.0 > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo IP address setting... passed
netsh int ip set dns "%NIC%" dhcp > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo DNS address setting... passed
Powershell.exe -command " Get-NetAdapterAdvancedProperty %NIC% -RegistryKeyword "*Pri*" | Set-NetAdapterAdvancedProperty -RegistryValue 3" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo PriorityVLANTag setting... passed
if ERRORLEVEL 1 echo PriorityVLANTag setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name '%NIC%' -MacAddress '02:00:00:00:05:00'"
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo MAC address setting... passed
if ERRORLEVEL 1 echo MAC address setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name %NIC% -VlanID 129" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo VLAN ID setting... passed
if ERRORLEVEL 1 echo VLAN ID setting... failed
goto FINISH

:CCU_AP
netsh -c int ip set address "%NIC%" static 10.0.6.0 255.0.0.0 10.0.1.0
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo IP address setting... passed
netsh int ip set dns "%NIC%" dhcp > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo DNS address setting... passed
Powershell.exe -command " Get-NetAdapterAdvancedProperty %NIC% -RegistryKeyword "*Pri*" | Set-NetAdapterAdvancedProperty -RegistryValue 3" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo PriorityVLANTag setting... passed
if ERRORLEVEL 1 echo PriorityVLANTag setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name '%NIC%' -MacAddress '02:00:00:00:06:00'" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo MAC address setting... passed
if ERRORLEVEL 1 echo MAC address setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name %NIC% -VlanID 129" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo VLAN ID setting... passed
if ERRORLEVEL 1 echo VLAN ID setting... failed
goto FINISH

:DEBUG
netsh -c int ip set address "%NIC%" static 10.32.32.40 255.0.0.0 10.0.1.0
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo IP address setting... passed
netsh int ip set dns "%NIC%" dhcp > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo DNS address setting... passed
Powershell.exe -command " Get-NetAdapterAdvancedProperty %NIC% -RegistryKeyword "*Pri*" | Set-NetAdapterAdvancedProperty -RegistryValue 3" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo PriorityVLANTag setting... passed
if ERRORLEVEL 1 echo PriorityVLANTag setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name '%NIC%' -MacAddress '02:00:00:20:20:28'" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo MAC address setting... passed
if ERRORLEVEL 1 echo MAC address setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name %NIC% -VlanID 129" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo VLAN ID setting... passed
if ERRORLEVEL 1 echo VLAN ID setting... failed
goto FINISH

:VP
netsh -c int ip set address "%NIC%" static 10.16.0.0 255.0.0.0 10.0.1.0
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo IP address setting... passed
netsh int ip set dns "%NIC%" dhcp > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo DNS address setting... passed
Powershell.exe -command " Get-NetAdapterAdvancedProperty %NIC% -RegistryKeyword "*Pri*" | Set-NetAdapterAdvancedProperty -RegistryValue 3" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo PriorityVLANTag setting... passed
if ERRORLEVEL 1 echo PriorityVLANTag setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name '%NIC%' -MacAddress '02:00:00:10:00:00'" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo MAC address setting... passed
if ERRORLEVEL 1 echo MAC address setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name %NIC% -VlanID 129" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo VLAN ID setting... passed
if ERRORLEVEL 1 echo VLAN ID setting... failed
goto FINISH

:LIDAR_RIGHT
netsh -c int ip set address "%NIC%" static 10.1.0.1 255.0.0.0 10.0.1.0
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo IP address setting... passed
netsh int ip set dns "%NIC%" dhcp > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo DNS address setting... passed
Powershell.exe -command " Get-NetAdapterAdvancedProperty %NIC% -RegistryKeyword "*Pri*" | Set-NetAdapterAdvancedProperty -RegistryValue 0" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo PriorityVLANTag setting... passed
if ERRORLEVEL 1 echo PriorityVLANTag setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name '%NIC%' -MacAddress '88:96:F2:01:00:01'" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo MAC address setting... passed
if ERRORLEVEL 1 echo MAC address setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name %NIC% -VlanID 0" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo VLAN ID setting... passed
if ERRORLEVEL 1 echo VLAN ID setting... failed
goto FINISH

:LIDAR_LEFT
netsh -c int ip set address "%NIC%" static 10.2.0.1 255.0.0.0 10.0.1.0
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo IP address setting... passed
netsh int ip set dns "%NIC%" dhcp > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo DNS address setting... passed
Powershell.exe -command " Get-NetAdapterAdvancedProperty %NIC% -RegistryKeyword "*Pri*" | Set-NetAdapterAdvancedProperty -RegistryValue 0" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo PriorityVLANTag setting... passed
if ERRORLEVEL 1 echo PriorityVLANTag setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name '%NIC%' -MacAddress '88:96:F2:01:00:02'" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo MAC address setting... passed
if ERRORLEVEL 1 echo MAC address setting... failed
Powershell.exe -command "Set-NetAdapter -Confirm:$false -Name %NIC% -VlanID 0" > NUL
if ERRORLEVEL 0 if not ERRORLEVEL 1 echo VLAN ID setting... passed
if ERRORLEVEL 1 echo VLAN ID setting... failed
goto FINISH

:FINISH
PAUSE
:: PAUSE
EXIT
