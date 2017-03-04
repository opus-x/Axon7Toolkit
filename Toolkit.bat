@ECHO OFF
title Axon7Toolkit
echo ***************************************
echo *          Axon7Toolkit v1.0.0
echo *          by @benkores
echo *          for ZTE A2017U
echo ***************************************
IF NOT EXIST stored\build.txt GOTO SETBUILD
cd C:\Program Files\Axon7Toolkit\stored
set /p theme=<theme.txt
set /p build=<build.txt
%theme%
START CMD /C "@echo off & mode con cols=80 lines=2 & set /p build=<build.txt & echo Build successfully set to %build% & ping localhost -n 2 >nul
GOTO OPTIONS
:SETBUILD
echo(
echo 1-B18
echo 2-B20
echo 3-B20_boot
echo 4-B27
echo 5-B29
echo 6-B15_N
echo 7-Custom
echo(
set /p build=Choose the build you are on(1-7):  
if {%build%}=={1} (echo B18 >>build.txt) & (GOTO SETTHEME)
if {%build%}=={2} (echo B20 >>build.txt) & (GOTO SETTHEME)
if {%build%}=={3} (echo B20_boot >>build.txt) & (GOTO SETTHEME)
if {%build%}=={4} (echo B27 >>build.txt) & (GOTO SETTHEME)
if {%build%}=={5} (echo B29 >>build.txt) & (GOTO SETTHEME)
if {%build%}=={6} (echo B15_N >>build.txt) & (GOTO SETTHEME)
if {%build%}=={7} (echo Custom >>build.txt) & (GOTO SETTHEME)
echo(
echo INVALID ENTRY! PLEASE CHOOSE ONE OF THE BUILDS!
GOTO SETBUILD
:SETTHEME
IF EXIST theme.txt GOTO OPTIONS
cls
echo(
echo 1-Black
echo 2-Blue
echo 3-Green
echo 4-Aqua
echo 5-Red
echo 6-Purple
echo(
set /p theme=Choose a theme(1-6) or press enter for default:
if {%theme%}=={1} (echo color 0f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={2} (echo color 1f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={3} (echo color 2f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={4} (echo color 3f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={5} (echo color 4f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={6} (echo color 5f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
echo color 1f >>theme.txt
%theme%
START CMD /C "@echo off & mode con cols=80 lines=4 & title Information & color f0 & set /p theme=<build.txt & echo( & echo( echo                             Theme set successfully & ping localhost -n 2 >nul
cls
:OPTIONS
cd C:\Program Files\Axon7Toolkit\bin
IF NOT EXIST debuggingprompt.txt cscript popup.vbs "USB Debugging must be enabled before choosing any of the options! If not enabled go to Settings, About Phone, and tap on build number 7 times to enable developer options. Then turn on USB Debugging in developer options."
echo                OPTIONS
echo 1-Driver Installation/Test
echo 2-Backup apps+data (ADB)
echo 3-Restore apps+data (ADB)
echo 4-OEM Unlock
echo 5-OEM Lock
echo 6-Flash TWRP and/or root
echo 7-Restore to stock
echo 8-Restore to stock (hardbrick-EDL mode)
echo 9-Flash zip(s)
echo 10-Advanced Options
echo 11-Settings
echo(
set /p option=Enter an option(1-11) :
if {%option%}=={1} (start DriverIT.exe) & (GOTO OPTIONS)
if {%option%}=={2} (GOTO BACKUP)
if {%option%}=={3} (GOTO RESTORE)
if {%option%}=={4} (GOTO UNLOCK)
if {%option%}=={5} (GOTO LOCK)
if {%option%}=={6} (GOTO TWRPFLASH)
if {%option%}=={7} (GOTO STOCKRESTORE)
if {%option%}=={8} (GOTO EDLRESTORE)
if {%option%}=={9} (GOTO ZIPFLASH)
if {%option%}=={10} (start AdvancedOptions.exe) & (GOTO OPTIONS)
if {%option%}=={11} (start Settings.exe) & (GOTO OPTIONS)
echo(
echo INVALID ENTRY! PLEASE ENTER A VALID OPTION!
GOTO OPTIONS
:BACKUP
:acheck2
echo(
START CMD /C "@echo off & mode con cols=80 lines=2 & echo Checking ADB Connectivity... & ping localhost -n 5 >nul"
set adbfail=List of devices attached
for /f "delims=" %%a in ('adb devices') do set output=%%a
if "%output%" == "%adbfail%" (cscript popup.vbs "Device was not detected! Please make sure your device is plugged in, the drivers are installed, and USB debugging is enabled in developer options. If nothing is working try plugging your device into a different USB port(preferably 2.0) or replugging it in with the OEM cable.") & (pause) & (GOTO acheck2)
echo(
start cmd /c "@echo off & mode con cols=80 lines=2 & echo Device connected! & ping localhost -n 5 >nul"
cscript popup.vbs "A screen will pop up on your device before the backup asking to allow backup to this computer. Enter a password if you want to encrypt the backup and then press Backup"
for /f %%a in ('powershell -Command "Get-Date -format yyyy_MM_dd__HH_mm_ss"') do set datetime=%%a 
IF EXIST datetime.txt DEL datetime.txt
echo %datetime% >>datetime.txt
cd C:\Program Files\Axon7Toolkit\backups
start cmd /c "@echo off & mode con cols=80 lines=2 & title Information & set /p datetime=<datetime.txt & echo                         Backing up... &  adb backup -f backup-%datetime%.ab -apk -all & DEL datetime.txt"
echo(
echo Press any key to return to options...
pause 1 >nul
GOTO OPTIONS
:RESTORE
:acheck3
echo(
start cmd /c "@echo off & mode con cols=80 lines=4 & color f0 & title Information & echo( & echo( & echo                         Checking ADB Connectivity... & ping localhost -n 5 >nul"
set adbfail=List of devices attached
for /f "delims=" %%a in ('adb devices') do set output=%%a
if "%output%" == "%adbfail%" (cscript popup.vbs "Device was not detected! Please make sure your device is plugged in, the drivers are installed, and USB debugging is enabled in developer options. If nothing is working try plugging your device into a different USB port(preferably 2.0) or replugging it in with the OEM cable.") & (pause) & (GOTO acheck3)
echo(
echo Device connected!
ping localhost -n 2 >nul
cscript popup.vbs "A Browse window will now open for you to select a backup to restore to"
rem BrowseFiles ab C:\Program Files\Axon7Toolkit\backups
IF EXIST backup.txt DEL backup.txt
echo %result% >>backup.txt
cscript popup.vbs "A screen will pop up on your device before the restore asking to allow restore from this computer. Enter a password if you encrypted the backup and then press Restore"
start cmd /c "@echo off & mode con cols=80 lines=2 & color f0 & cd C:\Program Files\Axon7Toolkit\backups & set /p result=<backup.txt & echo                         Restoring... & adb restore %result% & DEL backup.txt"
echo(
echo Press any key to return to options...
pause 1 >nul
GOTO OPTIONS
:LOCK
echo(
cscript popup.vbs "Use this option along with the restore to stock option if you need to send your phone in for warranty or reselling purposes or just want to have your phone just like it was out of the box. YOU MUST BE COMPLETELY STOCK TO USE THIS OPTION OTHERWISE YOUR PHONE WILL BE BRICKED!"
echo(
start cmd /c "@echo off & mode con cols=80 lines=4 & color f0 & echo( & echo( & echo                         Checking ADB/Fastboot Connectivity... & ping localhost -n 5 >nul"
:acheck3
set adbfail=List of devices attached
for /f "delims=" %%a in ('adb devices') do set output=%%a
if "%output%" == "%adbfail%" (GOTO fcheck3) else (ADB device connected!) & (ping localhost -n 2 >nul) & (echo( ) & (echo Rebooting to bootloader...) & (adb reboot-bootloader) & (ping localhost -n 10 >nul) & (GOTO acheck3)
:fcheck3
set fastfail=
for /f "delims" %%a in ('fastboot devices') do set output=%%a
if "%output%" == "%fastfail%" (cscript popup.vbs "Fastboot device is not connected. If your device is already in bootloader mode, try reinstalling the drivers or plugging your device into a different USB port with the OEM cable. You can also manually reboot to bootloader from recovery by choosing "Reboot to bootloader" in stock recovery with the volume down and power keys.") & (pause) & (GOTO acheck3) else (echo( ) & (echo Locking...) & (fastboot oem lock) & (echo( ) & (echo Done! Press any key to return to options...") & (pause 1 >nul) & (GOTO OPTIONS)



