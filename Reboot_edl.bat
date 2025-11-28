@ECHO OFF
set storage_type=ufs
cd /d %~dp0bin

echo. & echo.waiting for edl port (9008)... & TITLE waiting for edl port (9008)...
call find_edl_port.bat
echo.device connected: %port%

echo.^<?xml version="1.0" ?^>^<data^>^<power value="reset_to_edl" /^>^</data^>>.\cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=.\cmd.xml --mainoutputdir=.\ --skip_configure --noprompt || goto FAILED
EXIT

:FAILED
echo. & echo.failed. press any key to exit... && pause>nul && EXIT
