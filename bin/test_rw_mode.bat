::call test_rw mode.bat [y n]
::rwmode_gptmain_mode=1: 0-5 common  6 special  7-n common
::rwmode_gptmain_mode=2: 0-33 common  34-n common

@ECHO OFF
set runfulltest=%1
set rwmode=unknown& set rwmode_gptmain_mode=
if not "%storage_type%"=="emmc" (set secsize=4096) else (set secsize=512)
goto QUICKTEST

:QUICKTEST
::test oplus_gptbackup
::5-35
set result_5-35=failed
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="tmp.bin" physical_partition_number="0" label="5-35" start_sector="5" num_partition_sectors="31"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=cmd.xml --convertprogram2read --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=oplus_gptbackup --noprompt && set result_5-35=success&& set rwmode=oplus_gptbackup&& goto QUICKTEST-DONE
::test rwmode_gptmain_mode
set rwmode=oplus_gptmain
::33-35
set result_33-35=failed
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="tmp.bin" physical_partition_number="0" label="33-35" start_sector="3" num_partition_sectors="33"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=cmd.xml --convertprogram2read --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=oplus_gptmain --noprompt && set result_33-35=success&& set rwmode_gptmain_mode=1&& goto QUICKTEST-DONE
if "%rwmode_gptmain_mode%"=="" set rwmode_gptmain_mode=2
goto QUICKTEST-DONE
:QUICKTEST-DONE
echo. & echo.quick test result: %rwmode% %rwmode_gptmain_mode%
if not "%runfulltest%"=="y" goto :eof
if "%rwmode%"=="oplus_gptbackup" goto :eof
goto FULLTEST-%rwmode_gptmain_mode%

:FULLTEST-1
set result_0-5=failed
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="tmp.bin" physical_partition_number="0" label="0-5" start_sector="0" num_partition_sectors="6"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=cmd.xml --convertprogram2read --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=oplus_gptmain --noprompt && set result_0-5=success
set result_6=failed
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="tmp.bin" physical_partition_number="0" label="6" start_sector="6" num_partition_sectors="1"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=cmd.xml --convertprogram2read --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=oplus_gptmain --noprompt && set result_6=success
set result_7-4000=failed
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="tmp.bin" physical_partition_number="0" label="7-4000" start_sector="7" num_partition_sectors="3994"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=cmd.xml --convertprogram2read --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=oplus_gptmain --noprompt && set result_7-4000=success
set rwmode_gptmain_mode=unknown
if "%result_0-5%"=="success" (
    if "%result_6%"=="failed" (
        if "%result_7-4000%"=="success" set rwmode_gptmain_mode=1
    )
)
goto FULLTEST-DONE

:FULLTEST-2
set result_0-33=failed
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="tmp.bin" physical_partition_number="0" label="0-33" start_sector="0" num_partition_sectors="34"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=cmd.xml --convertprogram2read --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=oplus_gptmain --noprompt && set result_0-33=success
set result_34-4000=failed
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="tmp.bin" physical_partition_number="0" label="result_34-4000" start_sector="34" num_partition_sectors="3967"/^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --sendxml=cmd.xml --convertprogram2read --mainoutputdir=.\ --skip_configure --showpercentagecomplete --special_rw_mode=oplus_gptmain --noprompt && set result_34-4000=success
if "%result_0-33%"=="success" (
    if "%result_34-4000%"=="success" set rwmode_gptmain_mode=2
)
goto FULLTEST-DONE

:FULLTEST-DONE
echo. & echo.full test result: %rwmode% %rwmode_gptmain_mode%
echo.result_5-35    %result_5-35%
echo.result_33-35   %result_33-35%
echo.result_0-5     %result_0-5%
echo.result_6       %result_6%
echo.result_7-4000  %result_7-4000%
echo.result_0-33    %result_0-33%
echo.result_34-4000 %result_34-4000%
goto :eof
