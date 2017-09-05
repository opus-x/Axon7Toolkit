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
cd %toolpath%
start balloon info 2 "Downloading missing dependencies"
ping localhost -n 2 >nul
IF EXIST LatestFileDependencies.ini* DEL /F LatestFileDependencies.ini*
%toolpath%\wget --no-check-certificate https://raw.githubusercontent.com/bennykor/Axon7Toolkit/master/LatestFileDependencies.ini
IF NOT EXIST LatestFileDependencies.ini (
start /wait %toolpath%\balloon error 2 "Failed to connect to server!" 
taskkill /F /IM FileDependencyChecker.exe 
exit
)
move /Y LatestFileDependencies.ini %toolpath%\stored 
:TWRPCHECK
cd %toolpath%\stored
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestTWRP twrp') do (set filename=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini DownloadLinks %filename%') do (set filelink=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini FileDirectories %filename%') do (set directory=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sha256sum %filename%') do (set sha256sum=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sizes %filename%') do (set size=%%a)
IF EXIST %toolpath%\%directory%\%filename% GOTO SUPERSUCHECK
:TWRPDOWNLOAD
start %toolpath%\bin\Downloader %filename% %directory% %filelink% %sha256sum% %size% dependency
:D1CHECK
tasklist /FI "IMAGENAME eq Downloader.exe" | find /I /N "Downloader.exe"
IF "%ERRORLEVEL%" equ "0" ping localhost -n 1 >nul & GOTO D1CHECK
IF EXIST downloadsuccess DEL /F downloadsuccess & GOTO SUPERSUCHECK
start %toolpath%\balloon warn 2 "Download canceled!"
taskkill /F /IM wget.exe 
taskkill /F /IM dependencydownloader.exe 
taskkill /F /IM md5sum.exe
taskkill /F /IM sha256sum.exe
IF EXIST %toolpath%\%directory%\%filename% DEL /F %toolpath%\%directory%\%filename% 
:SUPERSUCHECK
cd %toolpath%\stored
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestSuperSU supersu') do (set filename=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini DownloadLinks %filename%') do (set filelink=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini FileDirectories %filename%') do (set directory=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sha256sum %filename%') do (set sha256sum=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sizes %filename%') do (set size=%%a)
IF EXIST %toolpath%\%directory%\%filename% exit
:SUPERSUDOWNLOAD
start %toolpath%\bin\Downloader %filename% %directory% %filelink% %sha256sum% %size% dependency
:D2CHECK
tasklist /FI "IMAGENAME eq Downloader.exe" | find /I /N "Downloader.exe"
IF "%ERRORLEVEL%" equ "0" ping localhost -n 1 >nul & GOTO D2CHECK
IF EXIST downloadsuccess DEL /F downloadsuccess & exit
start %toolpath%\balloon warn 2 "Download canceled!"
taskkill /F /IM wget.exe 
taskkill /F /IM dependencydownloader.exe
taskkill /F /IM md5sum.exe
taskkill /F /IM sha256sum.exe 
IF EXIST %toolpath%\%directory%\%filename% DEL /F %toolpath%\%directory%\%filename% 
taskkill /F /IM FileDependencyChecker.exe
exit
