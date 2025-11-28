:FINDEDLPORT
set port=unknown
for /f "tokens=2 delims=()" %%a in ('lsusb.exe ^| find "Qualcomm HS-USB QDLoader 9008 (COM"') do (set port=%%a)
if "%port%"=="unknown" goto FINDEDLPORT
