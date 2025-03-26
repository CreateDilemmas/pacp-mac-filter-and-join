@echo off
REM 14bb3848da295ea5c22e2a4787c9f3f6
REM Prompt for MAC address
set /p "mac=Enter MAC (e.g., 00:11:22:33:44:55): "
echo MAC entered: %mac%

REM Check for empty input
if "%mac%"=="" (
    echo ERROR: No MAC address provided.
    pause
    exit /b 1
)

REM Optional MAC format validation (uncomment to enable)
REM echo %mac%| findstr /r "^[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]:[0-9A-Fa-f][0-9A-Fa-f]$" >nul
REM if errorlevel 1 (
REM     echo ERROR: Invalid MAC format. Use xx:xx:xx:xx:xx:xx (e.g., 00:11:22:33:44:55).
REM     pause
REM     exit /b 1
REM )

REM Set tool paths
set "TSHARK=C:\Program Files\Wireshark\tshark.exe"
set "MERGECAP=C:\Program Files\Wireshark\mergecap.exe"

REM Check tools exist
if not exist "%TSHARK%" (
    echo ERROR: tshark not found at %TSHARK%. Update the path.
    pause
    exit /b 1
)
if not exist "%MERGECAP%" (
    echo ERROR: mergecap not found at %MERGECAP%. Update the path.
    pause
    exit /b 1
)

REM Filter each pcap file
echo Starting filtering...
for %%f in ("%~dp0*.pcap") do (
    echo Filtering %%f...
    "%TSHARK%" -r "%%f" -Y "eth.addr == %mac%" -w "%~dp0filtered_%%~nxf"
    if errorlevel 1 (
        echo ERROR: tshark failed for %%f.
    )
)

REM Merge filtered files
set "mac_file=%mac::=-%"
echo Merging into combined_%mac_file%.pcap...
"%MERGECAP%" -w "%~dp0combined_%mac_file%.pcap" "%~dp0filtered_*.pcap"
if errorlevel 1 (
    echo ERROR: mergecap failed.
) else (
    echo Merge successful.
)

REM Clean up
del "%~dp0filtered_*.pcap"
if errorlevel 1 (
    echo ERROR: Failed to delete filtered files.
)

REM Remove below if you want, (I kept for error checks).
echo Done.
pause