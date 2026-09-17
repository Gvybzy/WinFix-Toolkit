@echo off
setlocal EnableDelayedExpansion
:: ==========================================
:: Advanced Windows Network Toolkit
:: Personal Use Edition
:: ==========================================
title Advanced Windows Network Toolkit
color 0A

:: Check for Administrator Rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo ==========================================
    echo ERROR: Please Run as Administrator
    echo ==========================================
    echo.
    echo Right-click this file and select
    echo "Run as administrator"
    echo.
    pause
    exit /b 1
)

:MENU
cls
echo ==================================================
echo ADVANCED NETWORK TOOLKIT
echo ==================================================
echo.
echo --- DIAGNOSTICS ---
echo [1] Show Full IP Configuration
echo [2] Ping Google (10 packets)
echo [3] Continuous Ping (8.8.8.8)
echo [4] Ping Custom Host
echo [5] Traceroute to Google
echo [6] Display Routing Table
echo [7] Display ARP Cache
echo [8] View Active Network Sessions
echo [9] Show DNS Servers
echo.
echo --- REPAIR / RESET ---
echo [10] Flush DNS Cache
echo [11] Release IP Address
echo [12] Renew IP Address
echo [13] Reset Winsock
echo [14] Reset TCP/IP Stack
echo [15] Run Full Network Repair
echo.
echo --- TOOLS / SETTINGS ---
echo [16] Open Network Connections
echo [17] Open WiFi Settings
echo [18] Open Device Manager
echo [19] Open Network Troubleshooter
echo [20] Restart Windows Explorer
echo [21] Speed Test (opens browser)
echo [22] Show WiFi Passwords
echo [23] Scan Local Network (ARP)
echo.
echo [0] Exit
echo.
set /p choice=Select Option: 
if "%choice%"=="1" goto IPCONFIG
if "%choice%"=="2" goto PINGGOOGLE
if "%choice%"=="3" goto CONTPING
if "%choice%"=="4" goto PINGCUSTOM
if "%choice%"=="5" goto TRACEROUTE
if "%choice%"=="6" goto ROUTE
if "%choice%"=="7" goto ARP
if "%choice%"=="8" goto NETSTAT
if "%choice%"=="9" goto DNSSERVERS
if "%choice%"=="10" goto FLUSHDNS
if "%choice%"=="11" goto RELEASE
if "%choice%"=="12" goto RENEW
if "%choice%"=="13" goto WINSOCK
if "%choice%"=="14" goto TCPRESET
if "%choice%"=="15" goto FULLREPAIR
if "%choice%"=="16" goto NCPA
if "%choice%"=="17" goto WIFI
if "%choice%"=="18" goto DEVICE
if "%choice%"=="19" goto TROUBLE
if "%choice%"=="20" goto EXPLORER
if "%choice%"=="21" goto SPEEDTEST
if "%choice%"=="22" goto WIFIPASS
if "%choice%"=="23" goto SCANNET
if "%choice%"=="0" exit /b 0
echo.
echo Invalid Selection.
timeout /t 2 >nul
goto MENU

:: ==========================================
:: DIAGNOSTICS
:: ==========================================
:IPCONFIG
cls
echo ==========================================
echo FULL IP CONFIGURATION
echo ==========================================
echo.
ipconfig /all
goto END

:PINGGOOGLE
cls
echo ==========================================
echo PINGING GOOGLE.COM (10 packets)
echo ==========================================
echo.
ping google.com -n 10
goto END

:CONTPING
cls
echo ==========================================
echo CONTINUOUS PING - 8.8.8.8
echo ==========================================
echo Press CTRL+C to stop.
echo.
ping 8.8.8.8 -t
goto END

:PINGCUSTOM
cls
set /p host=Enter hostname or IP to ping: 
if "!host!"=="" goto MENU
echo.
ping "!host!" -n 10
goto END

:TRACEROUTE
cls
echo ==========================================
echo TRACEROUTE TO GOOGLE.COM
echo ==========================================
echo.
tracert google.com
goto END

:ROUTE
cls
echo ==========================================
echo ROUTING TABLE
echo ==========================================
echo.
route print
goto END

:ARP
cls
echo ==========================================
echo ARP CACHE
echo ==========================================
echo.
arp -a
goto END

:NETSTAT
cls
echo ==========================================
echo ACTIVE NETWORK SESSIONS
echo ==========================================
echo.
netstat -ano
goto END

:DNSSERVERS
cls
echo ==========================================
echo DNS SERVERS
echo ==========================================
echo.
netsh interface ip show dnsservers
goto END

:: ==========================================
:: REPAIR / RESET
:: ==========================================
:FLUSHDNS
cls
echo ==========================================
echo FLUSHING DNS CACHE
echo ==========================================
echo.
ipconfig /flushdns
goto END

:RELEASE
cls
echo ==========================================
echo RELEASING IP ADDRESS
echo ==========================================
echo.
ipconfig /release
goto END

:RENEW
cls
echo ==========================================
echo RENEWING IP ADDRESS
echo ==========================================
echo.
ipconfig /renew
goto END

:WINSOCK
cls
echo ==========================================
echo RESETTING WINSOCK
echo ==========================================
echo.
netsh winsock reset
echo.
echo [OK] Reboot Required.
goto END

:TCPRESET
cls
echo ==========================================
echo RESETTING TCP/IP STACK
echo ==========================================
echo.
netsh int ip reset
echo.
echo [OK] Reboot Required.
goto END

:FULLREPAIR
cls
echo ==========================================
echo RUNNING FULL NETWORK REPAIR
echo ==========================================
echo.
echo [1/5] Flushing DNS...
ipconfig /flushdns
echo.
echo [2/5] Releasing IP...
ipconfig /release
echo.
echo [3/5] Renewing IP...
ipconfig /renew
echo.
echo [4/5] Resetting Winsock...
netsh winsock reset
echo.
echo [5/5] Resetting TCP/IP Stack...
netsh int ip reset
echo.
echo ==========================================
echo NETWORK REPAIR COMPLETED
echo ** Reboot Recommended **
echo ==========================================
goto END

:: ==========================================
:: TOOLS / SETTINGS
:: ==========================================
:NCPA
start ncpa.cpl
goto END

:WIFI
start ms-settings:network-wifi
goto END

:DEVICE
start devmgmt.msc
goto END

:TROUBLE
msdt.exe /id NetworkDiagnosticsNetworkAdapter
goto END

:EXPLORER
cls
echo Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 >nul
start explorer.exe
echo Done.
goto END

:SPEEDTEST
cls
echo Opening Speed Test in browser...
start https://www.speedtest.net
goto END

:WIFIPASS
cls
echo ==========================================
echo SAVED WIFI PASSWORDS
echo ==========================================
echo.
for /f "skip=9 tokens=1,2 delims=:" %%a in ('netsh wlan show profiles') do (
    set "profile=%%b"
    set "profile=!profile:~1!"
    if not "!profile!"=="" (
        echo ------------------------------------------
        echo Network: !profile!
        echo ------------------------------------------
        netsh wlan show profile name="!profile!" key=clear | findstr /i "Key Content"
        echo.
    )
)
echo ==========================================
echo Done.
goto END

:SCANNET
cls
echo ==========================================
echo SCANNING LOCAL NETWORK (ARP)
echo ==========================================
echo.
echo Sending ping to all devices...
for /L %%i in (1,1,254) do (
    ping -n 1 -w 10 192.168.1.%%i >nul 2>&1
)
echo.
echo Devices found on network:
arp -a
goto END

:: ==========================================
:: END
:: ==========================================
:END
echo.
echo ==================================================
echo Press any key to return to main menu...
echo ==================================================
pause >nul
goto MENU
