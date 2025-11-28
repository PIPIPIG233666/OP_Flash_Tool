@ECHO OFF
set storage_type=ufs
cd /d %~dp0bin

:SETFILEPATH
CLS
TITLE set file path
set "devprg_filepath="
echo. & set /p "devprg_filepath=device programmer file path: "
if "%devprg_filepath%"=="" goto SETFILEPATH
set "digest_filepath="
echo. & set /p "digest_filepath=digest file path: "
if "%digest_filepath%"=="" goto SETFILEPATH
set "sig_filepath="
echo. & set /p "sig_filepath=sig file path: "
if "%sig_filepath%"=="" goto SETFILEPATH

:WAITEDLPORT
echo. & echo.waiting for edl port (9008)... & TITLE waiting for edl port (9008)...
call find_edl_port.bat
echo.device connected: %port%

echo. & echo.send device programmer... & TITLE send device programmer...
QSaharaServer.exe -p \\.\%port% -s 13:"%devprg_filepath%" || goto FAILED

echo. & echo.send digest... & TITLE send digest...
fh_loader.exe --port=\\.\%port% --signeddigests="%digest_filepath%" --testvipimpact --noprompt --skip_configure --mainoutputdir=.\

echo. & echo.send verify command... & TITLE send verify command...
echo.^<?xml version="1.0"?^>^<data^>^<verify value="ping" EnableVip="1"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --sendxml=cmd.xml --noprompt --skip_configure --mainoutputdir=.\ || goto FAILED

echo. & echo.send sig... & TITLE send sig...
fh_loader.exe --port=\\.\%port% --signeddigests="%sig_filepath%" --testvipimpact --noprompt --skip_configure --mainoutputdir=.\ || goto FAILED

echo. & echo.send sha256init command... & TITLE send sha256init command...
echo.^<?xml version="1.0"?^>^<data^>^<sha256init Verbose="1"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --sendxml=cmd.xml --noprompt --skip_configure --mainoutputdir=.\ || goto FAILED

echo. & echo.configure... & TITLE configure...
call configure.bat || goto FAILED

echo. & echo.all done & TITLE all done & pause>nul & EXIT

:FAILED
echo.failed. disconnect device and press any key to retry... && pause>nul && goto WAITEDLPORT
