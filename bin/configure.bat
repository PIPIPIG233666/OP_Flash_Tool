@ECHO OFF
echo.^<?xml version="1.0" ?^>^<data^>^<configure MemoryName="%storage_type%" Verbose="0" AlwaysValidate="0" MaxDigestTableSizeInBytes="8192" MaxPayloadSizeToTargetInBytes="1048576" ZlpAwareHost="1" SkipStorageInit="0" /^>^</data^>>cmd.xml
fh_loader.exe --port=\\.\%port% --memoryname=%storage_type% --configure=cmd.xml --search_path=.\ --mainoutputdir=.\ --noprompt || exit /b 1
exit /b 0
