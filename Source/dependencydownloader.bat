@ECHO OFF
REM BFCPEOPTIONSTART
REM Advanced BAT to EXE Converter www.BatToExeConverter.com
REM BFCPEEXE=
REM BFCPEICON=
REM BFCPEICONINDEX=0
REM BFCPEEMBEDDISPLAY=0
REM BFCPEEMBEDDELETE=1
REM BFCPEADMINEXE=0
REM BFCPEINVISEXE=1
REM BFCPEVERINCLUDE=0
REM BFCPEVERVERSION=1.0.0.0
REM BFCPEVERPRODUCT=Product Name
REM BFCPEVERDESC=Product Description
REM BFCPEVERCOMPANY=Your Company
REM BFCPEVERCOPYRIGHT=Copyright Info
REM BFCPEOPTIONEND
@ECHO ON

@echo on

set toolpath=C:\Axon7Development\Axon7Toolkit
set toolpath=%toolpath: =%
set name=%~1
set directory=%~2
set link=%~3

cd %toolpath%
cd %directory%



IF NOT EXIST %toolpath%\stored\limit.txt GOTO NOLIMIT 

for /f "delims=" %%a in ('type %toolpath%\stored\limit.txt') do set limit=%%a
%toolpath%\wget --output-document=%name% --limit-rate=%limit% --no-check-certificate %link%
exit

:NOLIMIT
%toolpath%\wget --output-document=%name% --no-check-certificate %link%
