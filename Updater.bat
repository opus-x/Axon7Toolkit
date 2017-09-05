@ECHO OFF
REM BFCPEOPTIONSTART
REM Advanced BAT to EXE Converter www.BatToExeConverter.com
REM BFCPEEXE=
REM BFCPEICON=C:\Users\Ben\Google Drive\Axon7Development\Axon7Toolkit\icons\update_icon.ico
REM BFCPEICONINDEX=1
REM BFCPEEMBEDDISPLAY=0
REM BFCPEEMBEDDELETE=0
REM BFCPEADMINEXE=1
REM BFCPEINVISEXE=1
REM BFCPEVERINCLUDE=0
REM BFCPEVERVERSION=1.0.0.0
REM BFCPEVERPRODUCT=Product Name
REM BFCPEVERDESC=Product Description
REM BFCPEVERCOMPANY=Your Company
REM BFCPEVERCOPYRIGHT=Copyright Info
REM BFCPEEMBED=C:\Users\Ben\Google Drive\Output EXEs\update.tmp.exe
REM BFCPEOPTIONEND
@ECHO ON
@echo on
rem HideSelf
set toolpath=C:\Axon7Development\Axon7Toolkit
set popup=%toolpath%\bin\popup
cd %toolpath%
start balloon.exe info 2 "Checking for update"
ping localhost -n 2 >nul
IF EXIST Toolkit.ini* DEL Toolkit.ini*
%toolpath%\wget --no-check-certificate https://raw.githubusercontent.com/bennykor/Axon7Toolkit/master/Toolkit.ini
IF NOT EXIST Toolkit.ini (
start /wait balloon error 2 "Failed to connect to server!" 
taskkill /F /IM Updater.exe
exit
)
move /Y Toolkit.ini %toolpath%\stored 
set /p current=<%toolpath%\stored\version.txt

set current=%current: =%
cd stored
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest version') do set latest=%%a 

set latest=%latest: =%
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest name') do set name=%%a  
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest link') do set link=%%a 
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest size') do set size=%%a 

for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest sha256') do set sha256=%%a
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest changelog') do set "changelog=%%a"

cd %toolpath%
IF %current% EQU %latest% exit
rem Divide %size% 1000000
set psize=%result%
set psize=%psize%.
set /a pround=psize+0
set pfract=%psize:*.=%0
set /a pround=1%pround%%pfract:~,1%+5
if %pround:~,1% GTR 1 (set psize=1%pround:~1,-1%) else (set psize=%pround:~1,-1%)
IF EXIST %toolpath%\updates\%name% GOTO DOWNLOADED
for /f "delims=" %%a in ('%popup% "Update available!\n\nCurrent: %current%\nLatest: %latest%\nSize: %psize% mb\n\nChangelog:\n\n%changelog%\n\nDownload and install?" "Information" "YesNo"') do set button=%%a
if %button% equ no exit
:DOWNLOAD
cd %toolpath%
start bin\Downloader %name% updates %link% %sha256% %size% update 
:DCHECK
tasklist /FI "IMAGENAME eq Downloader.exe" | find /I /N "Downloader.exe"
IF "%ERRORLEVEL%" equ "0" ping localhost -n 1 >nul & GOTO DCHECK
IF EXIST %toolpath%\stored\downloadsuccess DEL /F %toolpath%\stored\downloadsuccess & GOTO SETUP
start %toolpath%\balloon.exe warn 2 "Download canceled!"
taskkill /F /IM wget.exe 
taskkill /F /IM dependencydownloader.exe 
taskkill /F /IM md5sum.exe
taskkill /F /IM sha256sum.exe
IF EXIST %toolpath%\updates\%name% DEL %toolpath%\updates\%name% 
taskkill /F /IM Updater.exe
exit
:DOWNLOADED
for /f "delims=" %%a in ('%popup% "Update available!\n\nCurrent: %current%\nLatest: %latest%\nSize: %psize% mb\n\nChangelog:\n\n%changelog%\n\nPackage downloaded. Install?" "Information" "YesNo"') do set button=%%a
if %button% equ no exit
:SETUP
echo( >%toolpath%\tmp
start %MYFILES%\update.tmp.exe %name% %latest%
exit