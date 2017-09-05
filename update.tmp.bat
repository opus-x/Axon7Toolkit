@ECHO OFF
REM BFCPEOPTIONSTART
REM Advanced BAT to EXE Converter www.BatToExeConverter.com
REM BFCPEEXE=
REM BFCPEICON=
REM BFCPEICONINDEX=0
REM BFCPEEMBEDDISPLAY=0
REM BFCPEEMBEDDELETE=1
REM BFCPEADMINEXE=1
REM BFCPEINVISEXE=1
REM BFCPEVERINCLUDE=0
REM BFCPEVERVERSION=1.0.0.0
REM BFCPEVERPRODUCT=Product Name
REM BFCPEVERDESC=Product Description
REM BFCPEVERCOMPANY=Your Company
REM BFCPEVERCOPYRIGHT=Copyright Info
REM BFCPEEMBED=C:\Users\Ben\Google Drive\Axon7Development\Axon7Toolkit\notifu.exe
REM BFCPEEMBED=C:\Users\Ben\Google Drive\Axon7Development\Axon7Toolkit\notifu.pdb
REM BFCPEOPTIONEND
@ECHO ON
@echo on
set name=%~1
set latest=%~2
set toolpath=C:\Axon7Development\Axon7Toolkit
cd %MYFILES%
start /min notifu /p "Axon7Toolkit" /m "Installing update" /i %toolpath%\icons\toolkit.ico
taskkill /F /IM Toolkit.exe >nul 2>&1
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
taskkill /F /IM Updater.exe >nul 2>&1
taskkill /F /IM balloon.exe >nul 2>&1
cd %toolpath%
start /wait %toolpath%\updates\%name% /SP- /SILENT /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS /NORESTART /NORESTARTAPPLICATIONS /NOCANCEL /LOG="%toolpath%\updates\update.log"

cd %toolpath%
set /p current=<stored\version.txt
IF NOT %current% equ %latest% start /wait balloon error 2 "Failed! See log for details." 
start C:\Axon7Development\Axon7Toolkit.exe
exit