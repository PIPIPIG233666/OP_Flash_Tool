@ECHO OFF
set storage_type=ufs
cd /d %~dp0bin

echo. & echo.waiting for edl port (9008)... & TITLE waiting for edl port (9008)...
call find_edl_port.bat
echo.device connected: %port%

echo. & echo.configure... & TITLE configure...
call configure.bat || goto FAILED

echo. & echo.test rw mode... & TITLE test rw mode...
call test_rw_mode.bat y

echo. & echo.all done & TITLE all done & pause>nul & EXIT

:FAILED
echo. & echo.failed. press any key to exit... && pause>nul && EXIT
