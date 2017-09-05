@ECHO OFF
REM BFCPEOPTIONSTART
REM Advanced BAT to EXE Converter www.BatToExeConverter.com
REM BFCPEEXE=D:\Output EXEs\Axon7Toolkit.exe
REM BFCPEICON=C:\Users\Ben\Google Drive\Axon7Development\Axon7Toolkit\icons\toolkit.ico
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
REM BFCPEEMBED=C:\Users\Ben\Google Drive\Output EXEs\Toolkit.exe
REM BFCPEOPTIONEND
@ECHO ON
@echo on
set toolpath=C:\Axon7Development\Axon7Toolkit
set popup=%toolpath%\bin\popup

rem set preview=yes
if not defined preview goto launch

for /f "delims=" %%a in ('%popup% "This is a preview version of the toolkit that is meant for TESTING PURPOSES ONLY. No guarantees can be made about its stability or that your device will not get bricked. You are ultimately responsible for any damage to your device!\n\nPress 'OK' to continue with the launch.\n\nPress 'Cancel' to cancel launch." "Warning" "OKCancel" "Warning"') do set button=%%a
if %button% equ cancel exit

:launch

cd %toolpath%

start balloon info 2 "Killing toolkit processes"
taskkill /F /IM Toolkit.exe >nul 2>&1
taskkill /F /IM Updater.exe >nul 2>&1
taskkill /F /IM dependencydownloader.exe >nul 2>&1
taskkill /F /IM Downloader.exe >nul 2>&1
taskkill /F /IM FileDependencyChecker.exe >nul 2>&1
taskkill /F /IM Hashchecker.exe >nul 2>&1
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
taskkill /F /IM Settings.exe >nul 2>&1
taskkill /F /IM Toolkit.exe >nul 2>&1
taskkill /F /IM 7za.exe >nul 2>&1
taskkill /F /IM adb.exe >nul 2>&1
taskkill /F /IM fastboot.exe >nul 2>&1
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM Axon7Toolkit.exe >nul 2>&1
taskkill /F /IM balloon.exe >nul 2>&1
taskkill /F /IM update.tmp.exe >nul 2>&1

start balloon info 5 "Starting ADB"

adb start-server 

start C:\Axon7Development\Updater.exe 
IF EXIST tmp (
DEL /F tmp
)

:UPDATER
IF EXIST tmp (
DEL /F tmp 
exit
)
tasklist /FI "IMAGENAME eq Updater.exe" | find /I /N "Updater.exe"
IF "%ERRORLEVEL%" equ "0" GOTO UPDATER

start %toolpath%\bin\FileDependencyChecker.exe 

:DEPENDENCYCHECKER
tasklist /FI "IMAGENAME eq FileDependencyChecker.exe" | find /I /N "FileDependencyChecker.exe"
IF "%ERRORLEVEL%" equ "0" GOTO DEPENDENCYCHECKER

start %MYFILES%\Toolkit.exe 

exit