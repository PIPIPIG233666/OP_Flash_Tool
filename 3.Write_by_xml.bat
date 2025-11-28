@ECHO OFF
set storage_type=ufs
cd /d %~dp0bin

CLS
TITLE set read/write mode
echo. & echo.use [oplus read/write mode]? press Enter or enter 'y' to confirm, or 'n' to decline.
set /p "use_oplus_rw_mode=Enter/y/n: "
if "%use_oplus_rw_mode%"=="n" (echo.using normal read/write mode.) else (echo.using oplus read/write mode.)

:SETFILEPATH
TITLE set file path
echo. & echo.now input the xml file path. enter 'y' to confirm, or 'n' to re-enter.
set "img_dirpath="
set xml_filepath_all=
:SETFILEPATH-1
set "xml_filepath="
set /p "xml_filepath=xml path/y/n: "
if "%xml_filepath%"=="n" echo.the selected xml files have been discarded. & goto SETFILEPATH
if "%xml_filepath%"=="y" goto SETFILEPATH-2
if "%xml_filepath%"=="" goto SETFILEPATH-1
for %%a in ("%xml_filepath%") do set "img_dirpath=%%~dpa"
if "%xml_filepath_all%"=="" (set "xml_filepath_all=%xml_filepath%") else (set "xml_filepath_all=%xml_filepath_all%,%xml_filepath%") 
goto SETFILEPATH-1
:SETFILEPATH-2
echo.selected xml: %xml_filepath_all% & echo.images search path: %img_dirpath%

echo. & echo.waiting for edl port (9008)... & TITLE waiting for edl port (9008)...
call find_edl_port.bat
echo.device connected: %port%

echo. & echo.configure... & TITLE configure...
call configure.bat

if "%use_oplus_rw_mode%"=="n"     set rwmode=
if not "%use_oplus_rw_mode%"=="n" echo. & echo.test rw mode... & TITLE test rw mode...
if not "%use_oplus_rw_mode%"=="n" call test_rw_mode.bat
if not "%use_oplus_rw_mode%"=="n" echo.rw mode: %rwmode% %rwmode_gptmain_mode%

echo. & echo.write... & TITLE write...
if "%use_oplus_rw_mode%"=="n"     fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --search_path=%img_dirpath% --sendxml=%xml_filepath_all% --mainoutputdir=.\ --skip_configure --showpercentagecomplete                            --noprompt || goto FAILED
if not "%use_oplus_rw_mode%"=="n" fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --search_path=%img_dirpath% --sendxml=%xml_filepath_all% --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=%rwmode% --noprompt || goto FAILED

echo. & echo.all done & TITLE all done & pause>nul & EXIT

:FAILED
echo. & echo.failed. press any key to exit... && pause>nul && EXIT
