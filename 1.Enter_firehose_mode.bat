@ECHO OFF
chcp 437 >nul
set storage_type=ufs
cd /d %~dp0bin

:START
CLS
TITLE set the auth mode
echo. & echo.use [oplus mode]? press Enter or enter 'y' to confirm, or 'n' to decline.
set /p "use_oplus_mode=Enter/y/n: "
if "%use_oplus_mode%"=="n" (
    echo.using normal mode ^(device programmer only^).
) else (
    echo.using oplus mode.
)

:SETFILEPATH
TITLE set file path
set "devprg_filepath="
echo. & set /p "devprg_filepath=device programmer file path: "
if "%devprg_filepath%"=="" goto START

if "%use_oplus_mode%"=="n" goto WAITEDLPORT

set "digest_filepath="
echo. & set /p "digest_filepath=digest file path: "
if "%digest_filepath%"=="" goto START

set "sig_filepath="
echo. & set /p "sig_filepath=sig file path: "
if "%sig_filepath%"=="" goto START


:WAITEDLPORT
echo. & echo.waiting for edl port (9008)... & TITLE waiting for edl port (9008)...
call find_edl_port.bat
echo.device connected: %port%

echo. & echo.send device programmer... & TITLE send device programmer...
QSaharaServer.exe -p \\.\%port% -s 13:"%devprg_filepath%" || goto FAILED

if "%use_oplus_mode%"=="n" goto CONFIGURE


REM ===================================================================
REM ========== SEND DIGEST ============================================
REM ===================================================================

echo. & echo.send digest... & TITLE send digest...
fh_loader.exe --port=\\.\%port% --signeddigests="%digest_filepath%" --testvipimpact --noprompt --skip_configure --mainoutputdir=.\


REM ===================================================================
REM ========== SEND VERIFY COMMAND (XML FIXED: NO BOM, CLEAN ASCII) ===
REM ===================================================================

echo. & echo.send verify command... & TITLE send verify command...

(
  echo ^<?xml version="1.0" encoding="UTF-8"?^>
  echo ^<data^>
  echo ^<verify value="ping" EnableVip="1" /^>
  echo ^</data^>
) > cmd.xml

fh_loader.exe --port=\\.\%port% --sendxml=cmd.xml --noprompt --skip_configure --mainoutputdir=.\ || goto FAILED


REM ===================================================================
REM ========== SEND SIGNED DIGEST     =================================
REM ===================================================================

echo. & echo.send sig... & TITLE send sig...
fh_loader.exe --port=\\.\%port% --signeddigests="%sig_filepath%" --testvipimpact --noprompt --skip_configure --mainoutputdir=.\ || goto FAILED


REM ===================================================================
REM ========== SEND SHA256INIT (XML FIXED: NO BOM, CLEAN ASCII) =======
REM ===================================================================

echo. & echo.send sha256init command... & TITLE send sha256init command...

(
  echo ^<?xml version="1.0" encoding="UTF-8"?^>
  echo ^<data^>
  echo ^<sha256init Verbose="1" /^>
  echo ^</data^>
) > cmd.xml

fh_loader.exe --port=\\.\%port% --sendxml=cmd.xml --noprompt --skip_configure --mainoutputdir=.\ || goto FAILED



:CONFIGURE
echo. & echo.configure... & TITLE configure...
call configure.bat || goto FAILED

echo. & echo.all done & TITLE all done & pause>nul & EXIT


:FAILED
echo.failed. disconnect device and press any key to retry...
pause>nul
goto WAITEDLPORT
