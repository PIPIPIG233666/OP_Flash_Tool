@ECHO OFF
cd /d %~dp0

if exist bin\cmd.xml del bin\cmd.xml
if exist bin\tmp.bin del bin\tmp.bin
if exist bin\port_trace.txt del bin\port_trace.txt

EXIT
