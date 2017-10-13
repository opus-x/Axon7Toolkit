@ECHO OFF

:: DO NOT USE THIS BATCH FILE! IT IS FOR OPEN SOURCE PURPOSES ONLY AND MAY HAVE BROKEN OR NOT WORKING CODE!

REM BFCPEOPTIONSTART
REM Advanced BAT to EXE Converter www.BatToExeConverter.com
REM BFCPEEXE=
REM BFCPEICON=C:\Users\Ben\Google Drive\Axon7Toolkit\icons\toolkit.ico
REM BFCPEICONINDEX=1
REM BFCPEEMBEDDISPLAY=0
REM BFCPEEMBEDDELETE=1
REM BFCPEADMINEXE=1
REM BFCPEINVISEXE=0
REM BFCPEVERINCLUDE=0
REM BFCPEVERVERSION=1.0.0.0
REM BFCPEVERPRODUCT=Product Name
REM BFCPEVERDESC=Product Description
REM BFCPEVERCOMPANY=Your Company
REM BFCPEVERCOPYRIGHT=Copyright Info
REM BFCPEEMBED=C:\Users\Ben\Google Drive\Output EXEs\update.tmp.exe
REM BFCPEOPTIONEND
@ECHO ON
@echo off
title Axon7Toolkit
rem CenterSelf
mode con cols=100 lines=40
color 0b
set "toolpath=%~dp0" 
set popup=%toolpath%\utils\popup
If defined programfiles(x86) (set devcon=%toolpath%\utils\devcon_x64) else (set devcon=%toolpath%\utils\devcon_x86)
cd "%toolpath%"
:INITIATE2
cls
echo.
echo Killing existing toolkit processes...
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
taskkill /F /IM 7za.exe >nul 2>&1
taskkill /F /IM adb.exe >nul 2>&1
taskkill /F /IM fastboot.exe >nul 2>&1
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM Axon7Toolkit.exe >nul 2>&1
taskkill /F /IM update.tmp.exe >nul 2>&1
echo.
echo Starting ADB...
"%toolpath%\utils\adb" start-server
call :SUBPROCCESS_UPDATE
call :SUBPROCESS_DEPENCHECK
:INITIATE
cd "%toolpath%\stored"
IF NOT EXIST variant GOTO SETVAR
set /p variant=<variant
set variant=%variant: =%
IF NOT EXIST android_ver GOTO SET_ANDROIDVER
set /p android_ver=<android_ver
GOTO OPTIONS
:SETVAR
cls
echo ====================================================================================
echo          AXON7TOOLKIT 1.3.0
echo ====================================================================================
"%toolpath%\utils\adb" shell getprop ro.product.model 2>&1 | findstr "\<ZTE A2017\>" >nul 2>&1
if %errorlevel% equ 0 set auto_variant=A2017
"%toolpath%\utils\adb" shell getprop ro.product.model 2>&1 | findstr "\<ZTE A2017G\>" >nul 2>&1
if %errorlevel% equ 0 set auto_variant=A2017G
"%toolpath%\utils\adb" shell getprop ro.product.model 2>&1 | findstr "\<ZTE A2017U\>" >nul 2>&1
if %errorlevel% equ 0 set auto_variant=A2017U
if not defined auto_variant GOTO SETVAR_MANUAL
echo.
echo.
choice /c YN /m "Your variant is detected as %auto_variant%. Is this correct?"
if errorlevel 2 GOTO SETVAR_MANUAL
set auto_variant=%auto_variant: =%
echo %auto_variant%>variant
GOTO INITIATE
:SETVAR_MANUAL
echo.
echo.
echo                        1-A2017 (China)
echo                        2-A2017U (North America)
echo                        3-A2017G (Global)
echo.
echo.
set /p "variant=Choose your hardware variant (1-3):"
if "%variant%"=="1" (
echo A2017>variant
GOTO INITIATE
)
if "%variant%"=="2" (
echo A2017U>variant
GOTO INITIATE
)
if "%variant%"=="3" (
echo A2017G>variant
GOTO INITIATE
)
echo.
echo Invalid entry!
ping localhost -n 2 >nul
GOTO SETVAR_MANUAL
:SET_ANDROIDVER
cls
echo ====================================================================================
echo          AXON7TOOLKIT 1.3.0
echo ====================================================================================
"%toolpath%\utils\adb" shell getprop ro.build.version.release 2>&1 | find "6" >nul 2>&1
if %errorlevel% equ 0 set auto_androidver=6
"%toolpath%\utils\adb" shell getprop ro.build.version.release 2>&1 | find "7" >nul 2>&1
if %errorlevel% equ 0 set auto_androidver=7
if not defined auto_androidver GOTO SET_ANDROIDVER_MANUAL
echo.
echo.
choice /c YN /m "Your android version is detected as Android %auto_androidver%. Is this correct?"
if errorlevel 2 GOTO SET_ANDROIDVER_MANUAL
set auto_androidver=%auto_androidver: =%
echo %auto_androidver% >android_ver
GOTO INITIATE
:SET_ANDROIDVER_MANUAL
echo.
echo.
echo                        1- Android 6
echo                        2- Android 7
echo.
echo.
set /p "android_ver=Choose your android version(1-2):"
if "%android_ver%"=="1" (
echo 6 >android_ver
GOTO INITIATE
)
if "%android_ver%"=="2" (
echo 7 >android_ver
GOTO INITIATE
)
echo.
echo Invalid entry!
ping localhost -n 2 >nul
GOTO SET_ANDROIDVER_MANUAL
:OPTIONS
cd "%toolpath%\stored"
set twrp_disable=
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestTWRP twrp') do (set tversion=%%a) 
IF NOT EXIST "%toolpath%\twrp\%tversion%" (
set twrp_disable=yes
%popup% "Twrp image '%tversion%' is missing. Related options are disabled." "Information" "OK" "Warning" >nul 2>&1
)
set supersu_root_disable=
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestSuperSU supersu') do (set sversion=%%a) 
IF NOT EXIST "%toolpath%\root\%sversion%" (
set supersu_root_disable=yes
%popup% "SuperSU root file '%sversion%' is missing. SuperSU root option is disabled." "Information" "OK" "Warning" >nul 2>&1
)
set magisk_root_disable=
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestMagisk magisk') do (set magversion=%%a)
IF NOT EXIST "%toolpath%\root\%magversion%" (
set magisk_root_disable=yes
%popup% "Magisk root file '%magversion%' is missing. Magisk root option is disabled." "Information" "OK" "Warning" >nul 2>&1
)
set supersu_unroot_disable=
for /f "delims=" %a in ('call ini.cmd LatestFileDependencies.ini LatestSuperSU_unins supersu_unins') do (set s_uninsversion=%%a)
IF NOT EXIST "%toolpath%\root\%s_uninsversion" (
set supersu_unroot_disable=yes
%popup% "SuperSU unroot file '%s_suninsversion%' is missing. SuperSU unroot option is disabled." "Information" "OK" "Warning" >nul 2>&1
)
set magisk_unroot_disable=
for /f "delims=" %a in ('call ini.cmd LatestFileDependencies.ini LatestMagisk_unins magisk_unins') do (set mag_uninsversion=%%a)
IF NOT EXIST "%toolpath%\root\%mag_uninsversion" (
set magisk_unroot_disable=yes
%popup% "Magisk unroot file '%mag_uninsversion%' is missing. Magisk unroot option is disabled." "Information" "OK" "Warning" >nul 2>&1
)
cd "%toolpath%"
cls
echo ======================================================================================    			
echo                                AXON7TOOLKIT 1.3.0
echo ======================================================================================
echo.
echo Variant: %variant%
echo Android version: %android_ver%
echo.
Echo ***Make sure you have turned on USB debugging and OEM Unlock in developer options!***
echo.
echo ======================================================================================
echo                                    OPTIONS
echo ======================================================================================
echo 1. INSTALL DRIVERS
echo 2. ADB+FASTBOOT TEST
echo 3. APP+DATA BACKUP (ADB)
echo 4. APP+DATA RESTORE (ADB)
echo 5. PARTITION BACKUP (TWRP) 
echo 6. PARTITION RESTORE (TWRP)
echo 7. UNLOCK BOOTLOADER
echo 8. LOCK BOOTLOADER          
echo 9. FLASH TWRP
echo 10. ROOT
echo 11. UNROOT
echo 12. FLASH ZIPS
echo 13. SETTINGS
echo 14. FAQ AND TROUBLESHOOTING
echo 15. DONATE
IF NOT EXIST "%toolpath%\stored\debuggingprompt.txt" (
%popup% "Make sure USB debugging is enabled on your device before choosing any of the options:\n\n1-Open the Settings app. Go down to About Phone and select it.\n\n2-Go down to build number. Quickly tap it 7 times to enable developer options.\n\n3-Go back to the main Settings screen (or the Advanced Options menu on Nougat) and go into developer options.\n\n4-Turn on 'USB debugging' and 'OEM Unlock'." "Information" "OK" "Warning" >nul 2>&1 
type nul >%toolpath%\stored\debuggingprompt.txt
)
echo.
set option=
set /p "option=Choose an option(1-15):"
if "%option%"=="1" (GOTO DVINSTALL)
if "%option%"=="2" (GOTO TEST)
if "%option%"=="3" (GOTO BACKUP)
if "%option%"=="4" (GOTO RESTORE)
if "%option%"=="5" (GOTO TWRPBACKUP)
if "%option%"=="6" (GOTO TWRPRESTORE)
if "%option%"=="7" (GOTO UNLOCK)
if "%option%"=="8" (GOTO LOCK)
if "%option%"=="9" (GOTO TWRPFLASH) 
if "%option%"=="10" (GOTO ROOT)
if "%option%"=="11" (GOTO UNROOT)
if "%option%"=="12" (GOTO ZIPFLASH)
if "%option%"=="13" (GOTO SOPTIONS)
if "%option%"=="14" (start "" "https://forum.xda-developers.com/showpost.php?p=71430637&postcount=2") & (GOTO OPTIONS)
if "%option%"=="15" (start "" "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=ZW4F4MN9JSD2S&lc=US&item_name=bkores&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted") & (GOTO OPTIONS)
echo.
echo Invalid option!
ping localhost -n 2 >nul
GOTO OPTIONS
:DVINSTALL
for /f "delims=" %%a in ('%popup% "This option will install the ADB, fastboot, and Qualcomm EDL drivers. Accept any prompts that appear, otherwise the driver install will fail. If you do not get a prompt for a driver then it is already installed.\n\nPlease unplug your device before continuing." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
echo(
echo Installing ADB/Fastboot drivers...
ping localhost -n 2 >nul
"%devcon%" dp_add "%toolpath%\drivers\ADB\android_winusb.inf" >nul 2>&1
if %errorlevel% equ 2 (
%popup% "Failed to install ADB/Fastboot drivers! Check C:\Windows\Inf\setupapi.dev.log for details." "Error" "OK" "Error" >nul 2>&1
)
echo(
echo Installing Qualcomm EDL driver...
ping localhost -n 2 >nul
"%devcon%" dp_add "%toolpath%\drivers\Qualcomm\qcser.inf" >nul 2>&1
if %errorlevel% equ 2 (
%popup% "Failed to install Qualcomm driver! Check C:\Windows\Inf\setupapi.dev.log for details." "Error "OK" "Error" >nul 2>&1
)
echo(
echo(
choice /c YN /m "Test?"
if errorlevel 2 GOTO OPTIONS
:TEST
for /f "delims=" %%a in ('%popup% "This test will ensure the ADB and fastboot drivers are working properly. These are required to work for most functions including bootloader unlocking." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
cls
:acheck1
echo.
echo Checking ADB Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" GOTO aconnected1
for /f "delims=" %%a in ('%popup% "ADB device is not connected.\n\nTroubleshooting:\n\n-Make sure USB debugging is enabled in developer options\n\n-Make sure your device is connected to the PC. Use the original OEM cable and plug your device into a USB 2.0 port for best results\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Try switching from MTP(Media) to PTP(Picture) under the USB connection settings\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck1)            
:aconnected1
echo.
echo ADB device connected! 
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
:fcheck1
echo.
echo Checking Fastboot Connectivity... 
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" (
   %popup% "Test Passed!\n\nPress the power button to reboot your device." "Information" >nul 2>&1
    GOTO OPTIONS
)
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Use the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
 if %button% equ cancel (GOTO OPTIONS) else (GOTO fcheck1)
:BACKUP
cls
echo(
echo(
choice /c YN /m "Backup files on internal storage?"
if %errorlevel% equ 1 set shared=-shared
if %errorlevel% equ 2 set shared=-noshared
:BACKUPSAVE
set result=
for /f "delims=" %%a in ('%toolpath%\utils\savefile "ab files (*.ab)|*.ab" "%toolpath%\backups" "Save backup as" /F') do set "result=%%a"
if defined result GOTO acheck2
for /f "delims=" %%a in ('%popup% "No backup name was entered!" "Error" "OKCancel" "Error"') do set button=%%a
if %button% equ cancel (GOTO OPTIONS) else (GOTO BACKUPSAVE)
:acheck2
echo.
echo Checking ADB connectivity...
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 0 GOTO aconnected2
for /f "delims=" %%a in ('%popup% "ADB device is not connected.\n\nTroubleshooting:\n\n-Make sure USB debugging is enabled in developer options\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Try switching from MTP(Media) to PTP(Picture) under the USB connection settings.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck2)
:aconnected2
echo.
echo Device connected!
for /f "delims=" %%a in ('%popup% "Please unlock your device if it is not already unlocked.\n\nA screen will pop up on your device before the backup asking to allow backup to this computer. Enter a password if you want to encrypt the backup and then press 'Backup my data'." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
echo.
echo Backing up... ("%result%")
"%toolpath%\utils\adb" shell input keyevent 82 >nul 2>&1
"%toolpath%\utils\adb" backup -f "%result%" -all -apk %shared% >nul 2>&1
for %%I in ("%result%") do set backup_size=%%~zI
%popup% "A backup file with a size of %backup_size% bytes has been created at %result%. If the backup is 0 bytes and/or is not in its intended location please report the issue to the developer for troubleshooting. Otherwise your apps+data have been successfully backed up.\n\nNote: Data such as system settings, call logs, sms, alarms has not been backed up. If you need these items backed up use a third-party app from the play store." "Information" "OK" >nul 2>&1
GOTO OPTIONS
:RESTORE
:BACKUPBROWSE
set result=
for /f "delims=" %%a in ('%toolpath%\utils\openfile "*.ab" "%toolpath%\backups" "Choose a backup"') do set "result=%%a"
if defined result GOTO acheck3
for /f "delims=" %%a in ('%popup% "You have not selected a backup!" "Error" "OKCancel" "Error"') do set button=%%a
if %button% equ cancel (GOTO OPTIONS) else (GOTO BACKUPBROWSE)
:acheck3
cls
echo.
echo Checking ADB connectivity...
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 0 GOTO aconnected3
 for /f "delims=" %%a in ('%popup% "ADB device is not connected.\n\nTroubleshooting:\n\n-Make sure USB debugging is enabled in developer options\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Try switching from MTP(Media) to PTP(Picture) under the USB connection settings\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck3)
:aconnected3
echo.
echo Device connected!
for /f "delims=" %%a in ('%popup% "Please unlock your device if not already unlocked.\n\nA screen will pop up on your device before the restore asking to allow restore from this computer. Enter the backup's password if you encrypted it and then press 'Restore my data'." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
echo.
echo Restoring backup... ("%result%")
"%toolpath%\utils\adb" shell input keyevent 82 >nul 2>&1
"%toolpath%\utils\adb" restore "%result%" >nul 2>&1
%popup% "Your backup %result% should have successfully been restored. If your apps+data haven't been restored, try rebooting your device. If they still haven't been restored please report the issue to the developer with your ROM details and try the alternative restore method in the FAQ and Troubleshooting section." "Information" "OK" >nul 2>&1
GOTO OPTIONS
:UNLOCK
for /f "delims=" %%a in ('%popup% "This option will allow you to use various functions of the toolkit such as flashing a custom recovery, rooting, and flashing Custom ROMs.\n\nIt will wipe your data so make sure to make a backup first using the backup option in the toolkit!\n\nYou must also have 'OEM Unlock' turned on in developer options." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
:MCHECK
IF EXIST C:\XiaoMi\XiaoMiFlash\ GOTO acheck4
for /f "delims=" %%a in ('%popup% "MiFlash version 20161222 is not installed on your system. This is required for the bootloader unlock function of the toolkit to work. Please go through the setup. It's all in Chinese, but just keep clicking the next button at the bottom right." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
start "" "%toolpath%\MiFlashSetup.msi"
echo.
pause
GOTO MCHECK
:acheck4
cls
echo.
echo Checking ADB\EDL Connectivity...
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 1 GOTO echeck1
echo.
echo ADB device connected!
echo.
echo Rebooting to EDL mode...
"%toolpath%\utils\adb" reboot edl 
echo.
timeout /t 15
echo.
echo Checking EDL connectivity...
:echeck1
"%devcon%" rescan >nul 2>&1
"%devcon%" hwids * | find /I "USB\VID_05C6&PID_9008" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" (
echo.
echo EDL device connected!
GOTO QDVCHECK
)
For /f "delims=" %%a in ('%popup% "EDL device is not connected!\n\nTroubleshooting:\n\n-Try an alternate USB 2.0 port. Use the original OEM cable for best results\n\n-Use the install driver option\n\nBoot your device into EDL mode manually:\n\n-From the power menu, completely power off your device. Then press and hold the Volume Up+Volume Down+Power keys for 5 seconds\n\n-Reboot your PC\n\nPress 'OK' to retry.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
If %button% equ cancel (GOTO OPTIONS) else (GOTO acheck4)
:QDVCHECK
echo.
echo Searching for Qualcomm HS-USB QDLoader 9008 device...
"%devcon%" rescan >nul 2>&1
"%devcon%" find * | findstr "\<Qualcomm HS-USB QDLoader 9008\>" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" GOTO QDCONNECTED
echo.
echo Not found! Replacing driver...
"%devcon%" update "%toolpath%\drivers\Qualcomm\qcser.inf" "USB\VID_05C6&PID_9008" >nul 2>&1
IF "%ERRORLEVEL%" equ "2" (
%popup% "Failed to replace driver! Check C:\Windows\Inf\setupapi.dev.log for details." "Error" "OK" "Error" >nul 2>&1
GOTO OPTIONS
)
echo.
echo Driver replaced successfully!
%popup% "Please press the power button for 10-15 seconds to reboot your device or Power+Volume Up+Volume Down for 5 seconds to boot back into EDl mode to refresh the EDL state. Then use the option again." "Information" >nul 2>&1
GOTO OPTIONS
:QDCONNECTED
echo.
echo Qualcomm HS-USB QDLoader 9008 device connected!
for /f "delims=" %%a in ('%popup% "MiFlash will now be launched. Follow the instructions on the toolkit's screen and then return to the toolkit to finish the unlock process." "Information" "OKCancel"') do set button=%%a
If %button% equ cancel GOTO OPTIONS
if "%android_ver%"=="6 " (echo %toolpath%\edl_packages\unlock\FASTBOOT_UNLOCK_EDL_MM|clip) else (echo %toolpath%\edl_packages\unlock\FASTBOOT_UNLOCK_EDL_N|clip)
start C:\XiaoMi\XiaoMiFlash\XiaoMiFlash.exe
echo.
echo =========================================================================================
echo 							INSTRUCTIONS
echo =========================================================================================
echo 1) The path to the fastboot package has been copied to your clipboard. 
echo Paste it into the text field at the top by clicking it and then press Cltrl+V on your keyboard.
echo Ignore the "couldn't find script" error.
echo ***You may need to click 'Refresh' before your device is seen in MiFlash.***
echo 2) Press the flash button at the top right and wait for the package to flash.
echo 3) Press and hold the power button for 10-15 seconds to exit out of EDL mode.
echo.
echo If the flash fails or is unable to communicate with the device try one of the following:
echo -Use the Power, Volume Up and Volume Down key combo to restart EDL mode. 
echo -Release the keys after 5 seconds then wait another 5 seconds before using the refresh or 
echo flash buttons on MiFlash.
echo -You can also try the Reinstall option under Driver at the top left.
echo -Reboot your PC
echo -Restart MiFlash
echo -Try an earlier or later version of MiFlash at xiaomiflashtool.com
echo -Update your device's firmware if not the latest.
echo ==========================================================================================
pause
:acheck4b
echo.
echo Checking ADB\Fastboot Connectivity...
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 1 GOTO fcheck4b 
echo.
echo ADB device connected!
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity...
:fcheck4b
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF %ERRORLEVEL% equ 0 GOTO fconnected4b
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck4b)
:fconnected4b
echo.
echo Fastboot device connected! 
echo.
echo Unlocking...
echo(
"%toolpath%\utils\fastboot" oem unlock
%popup% "You should now see an Unlock bootloader? screen on your device. Use the volume up key to highlight Yes in blue and press power to select. Your device will then reboot into recovery to erase your data.\n\nYou can now use any of the options that require an unlocked bootloader!" "Information" >nul 2>&1
echo.
echo Press any key to return to options...
pause >nul
GOTO OPTIONS
:LOCK
for /f "delims=" %%a in ('%popup% "This option will lock your device's bootloader and will prevent you from using any of the options which require an unlocked bootloader. This can be used for warranty purposes or to get rid of the annoying boot warning screen.\n\nWarning: You must be completely stock to use this option otherwise your phone will be bricked! If it is not use the restore to stock option first!\n\nYour data will also be wiped so make sure to make a backup first using the backup option in the toolkit!" "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS 
cls
:acheck5
echo.
echo Checking ADB\Fastboot Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 1 GOTO fcheck5 
echo.
echo ADB device connected! 
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity... 
:fcheck5
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" GOTO fconnected5
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port.\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck5)
:fconnected5
echo.
echo Fastboot device connected!
echo.
echo Locking...
echo.
"%toolpath%\utils\fastboot" oem lock
echo.
echo Press any key to return to options...
pause >nul
GOTO OPTIONS
:ROOT
if "%twrp_disable%"=="yes" (
%popup% "Option is disabled due to missing twrp image." "Error" "OK" "Error" >nul 2>&1
GOTO OPTIONS
)
for /f "delims=" %%a in ('%popup% "This option will root your device using either SuperSU or Magisk and requires an unlocked bootloader. If your bootloader is not already unlocked, use the unlock option in the toolkit.\n\nWarning: Root will prevent your device from being able to install updates if you are using the stock ROM." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
cls
:ROOT_CHOICE
echo.
echo.
echo 1-SuperSU: Traditional systemless root
echo 2-Magisk: Root which passes Safetynet and allows protected apps such as Android Pay, Pokemon Go, Snapchat and Netflix to work. This form of root is hidden from these kind of apps. This option may not work on the stock ROM.
echo.
echo.
set /p "root_choice=Choose a root option(1-2):"
if "%root_choice%"=="1" GOTO SUPERSU_ROOT_FILE_CHECK
if "%root_choice%"=="2" GOTO MAG_ROOT_FILE_CHECK
echo.
echo Invalid option!
GOTO ROOT_CHOICE
:SUPERSU_ROOT_FILE_CHECK
if "%supersu_root_disable%"=="yes" (
%popup% "SuperSU root option is disabled due to missing SuperSU root file." "Error" "OK" "Error" >nul 2>&1
GOTO ROOT_CHOICE
)
GOTO acheck6
:MAG_ROOT_FILE_CHECK
if "%magisk_root_disable%"=="yes" (
%popup% "Magisk root option is disabled due to missing Magisk root file." "Error" "OK" "Error" >nul 2>&1
GOTO ROOT_CHOICE
)
:acheck6
echo.
echo Checking ADB\Fastboot Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF "%ERRORLEVEL%" EQU "1" GOTO fcheck6 
echo.
echo ADB device connected! 
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity...
:fcheck6
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" GOTO fconnected6
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port.\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck6)
:fconnected6
echo.
echo Fastboot device connected!
if "%android_ver%"=="6 " (
echo.
echo Flashing TWRP...
echo.
"%toolpath%\utils\fastboot" flash recovery "%toolpath%\twrp\%tversion%"
%popup% "Keep pressing the volume up key on the device until the 'Start' at the top changes to 'Recovery mode'. Then press power to select.\n\nPress 'OK' to continue when TWRP recovery has fully loaded.\n\nMake sure to tap 'Keep read-only' on startup!" "Information" >nul 2>&1
GOTO acheck6b
)
echo.
echo Booting TWRP...
echo.
"%toolpath%\utils\fastboot" boot "%toolpath%\twrp\%tversion%"
echo.
echo Tap 'Keep read-only'" on startup!
echo Press any key to continue once TWRP has fully loaded...
pause >nul
:acheck6b
echo.
echo Checking ADB Recovery Connectivity... 
"%toolpath%\utils\adb" devices | find "recovery" >nul 2>&1
if "%ERRORLEVEL%" equ "0" GOTO aconnected6b 
for /f "delims=" %%a in ('%popup% "ADB recovery device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck6b)
:aconnected6b
echo.
echo ADB recovery device connected!
echo.
echo Backing up boot image...
"%toolpath%\utils\adb" shell dd if=/dev/block/bootdevice/by-name/boot of=/sdcard/boot.img >nul 2>&1
"%toolpath%\utils\adb" pull /sdcard/boot.img "%toolpath%\root"
"%toolpath%\utils\adb" shell rm -f /sdcard/boot.img >nul 2>&1
echo.
echo Pushing root file to device...
if "%root_choice%"=="1" "%toolpath%\utils\adb" push "%toolpath%\root\%sversion%" /sdcard/
if "%root_choice%"=="2" "%toolpath%\utils\adb" push "%toolpath%\root\%magversion%" /sdcard/
echo.
echo Rooting...
if "%root_choice%"=="1" "%toolpath%\utils\adb" shell twrp install /sdcard/%sversion% >nul 2>&1
if "%root_choice%"=="2" "%toolpath%\utils\adb" shell twrp install /sdcard/%magversion% >nul 2>&1
"%toolpath%\utils\adb" shell twrp wipe cache >nul 2>&1
"%toolpath%\utils\adb" shell twrp wipe dalvik >nul 2>&1
"%toolpath%\utils\adb" shell reboot disemmcwp >nul 2>&1
if "%root_choice%"=="1" %popup% "Your device should have successfully been rooted! To make sure your device is rooted, find the SuperSU app in your app drawer and launch it. If the app is missing or the app says that no root binary is installed, try the SuperSU root option again." "Information" >nul 2>&1
if "%root_choice%"=="2" %popup% "Your device should have successfully been rooted! To make sure your device is rooted, find the Magisk Manager app in your app drawer and launch it. Run the Safetynet test. If the Safetynet test fails or Magisk Manager says magisk is not installed, try the Magisk root option agian." "Information" >nul 2>&1 
GOTO OPTIONS
:UNROOT
if "%twrp_disable%"=="yes" (
%popup% "Option is disabled due to missing twrp image." "Error" "OK" "Error" >nul 2>&1
GOTO OPTIONS
)
if not exist "%toolpath%\root\boot.img" (
%popup% "Boot image missing. Unroot may not fully complete. Information "OK" "Warning" >nul 2>&1
)
:UNROOT_CHOICE
choice /c 12 /m "Did you root with [1]SuperSU or [2]Magisk?"
if "%errorlevel%" equ "1" set unroot_choice=supersu & GOTO supersu_unroot_file_check
if "%errorlevel%" equ "2" set unroot_choice=magisk & GOTO magisk_unroot_file_check
:supersu_unroot_file_check
if "%supersu_unroot_disable%"=="yes" (
%popup% "SuperSU unroot file is missing. Option is disabled." >nul 2>&1
GOTO UNROOT_CHOICE
)
:magisk_unroot_file_check
if "%magisk_root_disable%"=="yes" (
%popup% "Magisk unroot file is missing. Option is disabled." >nul 2>&1
GOTO UNROOT_CHOICE
)
:unroot_acheck
echo.
echo Checking ADB\Fastboot Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF "%ERRORLEVEL%" EQU "1" GOTO unroot_fcheck
echo.
echo ADB device connected! 
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity...
:unroot_fcheck
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" GOTO unroot_fconnected
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port.\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel (GOTO OPTIONS) else (GOTO unroot_acheck)
:unroot_fconnected
echo.
echo Fastboot device connected!
if "%android_ver%"=="6 " (
echo.
echo Flashing TWRP...
echo.
"%toolpath%\utils\fastboot" flash recovery "%toolpath%\twrp\%tversion%"
%popup% "Keep pressing the volume up key on the device until the 'Start' at the top changes to 'Recovery mode'. Then press power to select.\n\nPress 'OK' to continue when TWRP recovery has fully loaded.\n\nMake sure to tap 'Keep read-only' on startup!" "Information" >nul 2>&1
GOTO acheck6b
)
echo.
echo Booting TWRP...
echo.
"%toolpath%\utils\fastboot" boot "%toolpath%\twrp\%tversion%"
echo.
echo Tap 'Keep read-only'" on startup!
echo Press any key to continue once TWRP has fully loaded...
pause >nul
:unroot_acheckb
echo.
echo Checking ADB Recovery Connectivity... 
"%toolpath%\utils\adb" devices | find "recovery" >nul 2>&1
if "%ERRORLEVEL%" equ "0" GOTO unroot_aconnectedb
for /f "delims=" %%a in ('%popup% "ADB recovery device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel (GOTO OPTIONS) else (GOTO unroot_acheckb)
:unroot_aconnectedb
echo.
echo ADB recovery device connected!
echo.
echo Unrooting...
if "%unroot_choice%=="supersu" (
"%toolpath%\utils\adb" push "%toolpath%\root\%s_uninsversion%" /sdcard/
"%toolpath%\utils\adb" shell twrp install /sdcard/%s_uninsversion >nul 2>&1
)
if "%unroot_choice%"=="magisk" (
"%toolpath%\utils\adb" push "%toolpath%\root\%mag_uninsversion%" /sdcard/
"%toolpath%\utils\adb" shell twrp install /sdcard/%mag_uninsversion >nul 2>&1
)
if exist "%toolpath%\root\boot.img" (
echo.
echo Restoring boot image...
"%toolpath%\utils\adb" push "%toolpath%\root\boot.img" /sdcard/
"%toolpath%\utils\adb" shell dd if=/sdcard/boot.img of=/dev/block/bootdevice/by-name/boot >nul 2>&1
"%toolpath%\utils\adb" shell rm -f /sdcard/boot.img >nul 2>&1
)
"%toolpath℅\utils\adb" reboot
echo.
echo Press any key to return to options...
pause >nul
GOTO OPTIONS
:ZIPFLASH
if "%twrp_disable%"=="yes" (
%popup% "Option is disabled due to missing twrp image." "Error" "OK" "Error" >nul 2>&1
GOTO OPTIONS
)
del /F "%toolpath%\flashzip\zips.txt" >nul 2>&1           
cd "%toolpath%"
for /f "delims=" %%a in ('%popup% "This option allows you to flash Custom ROMs, GAPPS, mods, and more. It requires an unlocked bootloader. If you do not have an unlocked bootloader, use the unlock option in the toolkit first." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
:SELECTZIP
set result=
for /f "delims=" %%a in ('%toolpath%\utils\openfile "*.zip" "%USERPROFILE%\Downloads" "Select a zip"') do set "result=%%a"
if defined result GOTO ZIPSAVE
for /f "delims=" %%a in ('%popup% "You have not selected a zip!" "Error" "OKCancel" "Error"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
GOTO SELECTZIP
:ZIPSAVE
echo "%result%">>zips.txt
:ANOTHERZIP
echo.
choice /c YN /m "Add another zip?"
if %ERRORLEVEL% equ 1 GOTO SELECTZIP
:acheck8
echo.
echo Checking ADB\Fastboot Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 1 GOTO fcheck8 
echo.
echo ADB device connected!
echo.
echo Rebooting to bootloader... 
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity... 
:fcheck8
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" GOTO fconnected8 
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port.\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for teh bootloader unlock option to fix this.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
GOTO acheck8
:fconnected8
echo.
echo Fastboot device connected!
if "%android_ver%"=="6 " (
echo.
echo Flashing TWRP...
echo.
"%toolpath%\utils\fastboot" flash recovery "%toolpath%\twrp\%tversion%"
%popup% "Keep pressing the volume up key on the device until the 'Start' at the top changes to 'Recovery mode'. Then press power to select.\n\nPress 'OK' to continue when TWRP recovery has fully loaded.\n\nMake sure to tap 'Keep read-only' on startup!" "Information" >nul 2>&1
GOTO acheck8b
)
echo.
echo Booting TWRP...
echo.
"%toolpath%\utils\fastboot" boot "%toolpath%\twrp\%tversion%"
echo.
echo Swipe to allow modifications on startup!
echo Press any key to continue once TWRP has fully loaded...
pause >nul
:acheck8b
echo.
echo Checking ADB Recovery Connectivity...
"%toolpath%\utils\adb" devices | find "recovery" >nul 2>&1
if "%ERRORLEVEL%" equ "0" GOTO aconnected8b 
for /f "delims=" %%a in ('%popup% "ADB recovery device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel (GOTO OPTIONS) else (GOTO acheck8b)
:aconnected8b
echo.
echo ADB recovery device connected!
echo.
choice /c YN /m "Wipe system and data?(required if switching ROMs)"
if %ERRORLEVEL% equ 1 (
echo. 
echo Wiping...
echo.
"%toolpath%\utils\adb" shell busybox mount /system >nul 2>&1
"%toolpath%\utils\adb" shell twrp wipe system >nul 2>&1
"%toolpath%\utils\adb" shell make_ext4fs /dev/block/bootdevice/by-name/userdata >nul 2>&1
"%toolpath%\utils\adb" shell busybox mount -o bind /data/media/0 /sdcard >nul 2>&1
)
:ZIPCONT
echo.
"%toolpath%\utils\adb" shell twrp set tw_signed_zip_verify 0
echo.
for /f "tokens=*" %%a in (zips.txt) do call :zippush %%a
"%toolpath%\utils\adb" shell twrp wipe cache >nul 2>&1
"%toolpath%\utils\adb" shell twrp wipe dalvik >nul 2>&1
"%toolpath%\utils\adb" reboot
echo.                   
echo Press any key to return to options...
pause >nul
GOTO OPTIONS
:TWRPBACKUP
if "%twrp_disable%"=="yes" (
%popup% "Option is disabled due to missing twrp image." "Error" "OK" "Error" >nul 2>&1
GOTO OPTIONS
)
for /f "delims=" %%a in ('%popup% "This option will make full backups of your device's system, data, and/or boot partitions on TWRP 3.1.0 and up. It requires an unlocked bootloader. If your bootloader is not already unlocked, use the unlock option in the toolkit." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
cls
echo.
choice /c YN /m "Backup system partition?"
if %ERRORLEVEL% equ 1 set system=system
if %ERRORLEVEL% equ 2 set system=
choice /c YN /m "Backup data partition?"
if %ERRORLEVEL% equ 1 set data=data
if %ERRORLEVEL% equ 2 set data=
choice /c YN /m "Backup boot partition?"
if %ERRORLEVEL% equ 1 set boot=boot
if %ERRORLEVEL% equ 2 set boot=
choice /c YN /m "Compress backup?"
if %ERRORLEVEL% equ 1 set compress=--compress
if %ERRORLEVEL% equ 2 set compress=
:BACKUPSAVE2
set result=
for /f "delims=" %%a in ('%toolpath%\utils\savefile "ab files (*.ab)|*.ab" "%toolpath%\backups" "Save backup as" /F') do set "result=%%a"
if defined result GOTO twrpacheck 
for /f "delims=" %%a in ('%popup% "You have not entered a backup name!" "Error" "OKCancel" "Error"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
GOTO BACKUPSAVE2
:twrpacheck
echo.
echo Checking ADB\Fastboot Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 1 GOTO twrpfcheck
echo.
echo ADB device connected! 
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity... 
:twrpfcheck
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF %ERRORLEVEL% equ 0 GOTO twrpfconnected
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
GOTO twrpacheck
:twrpfconnected
echo.
echo Fastboot device connected!
if "%android_ver%"=="6 " (
echo.
echo Flashing TWRP...
echo.
"%toolpath%\utils\fastboot" flash recovery "%toolpath%\twrp\%tversion%"
%popup% "Keep pressing the volume up key on the device until the 'Start' at the top changes to 'Recovery mode'. Then press power to select.\n\nPress 'OK' to continue when TWRP recovery has fully loaded.\n\nMake sure to swipe to allow for modifications on startup!" "Information" >nul 2>&1
GOTO twrpacheckb
)
echo.
echo Booting TWRP...
echo.
"%toolpath%\utils\fastboot" boot %toolpath%\twrp\%tversion%
echo.
echo Swipe to allow modifications on startup!
echo Press any key to continue once TWRP has fully loaded...
pause >nul
:twrpacheckb
echo.
echo Checking ADB Recovery Connectivity... 
"%toolpath%\utils\adb" devices | find "recovery" >nul 2>&1
IF %ERRORLEVEL% equ 0 GOTO twrpabconnected
for /f "delims=" %%a in ('%popup% "ADB recovery device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel GOTO OPTIONS
GOTO twrpacheckb
:twrpabconnected
echo.
echo ADB recovery device connected! 
echo.
echo Backing up partitions... ("%result%")
"%toolpath%\utils\adb" shell twrp mount system >nul 2>&1
"%toolpath%\utils\adb" backup -f "%result%" --twrp %compress% %system% %data% %boot%  >nul 2>&1
"%toolpath%\utils\adb" shell twrp unmount system >nul 2>&1
"%toolpath%\utils\adb" reboot
for %%I in ("%result%") do set backup_size=%%~zI
%popup% "A backup file with a size of %backup_size% bytes has been created at '%result%'. If the backup is 0 bytes and/or is not in its intended location please pull your device's recovery log with 'adb pull /tmp/recovery.log' and send it to the developer for troubleshooting. Otherwise your partitions have successfully been backed up." "Information" >nul 2>&1
GOTO OPTIONS
:TWRPRESTORE
if "%twrp_disable%"=="yes" (
%popup% "Option is disabled due to missing twrp image." "Error" "OK" "Error" >nul 2>&1
GOTO OPTIONS
)
for /f "delims=" %%a in ('%popup% "This option will restore your device's system, boot, and/or data partitions from a previously made ADB TWRP backup. It requires an unlocked bootloader. If your bootloader is not already unlocked, use the unlock option in the toolkit first." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
:BACKUPBROWSE2
set result=
for /f "delims=" %%a in ('%toolpath%\utils\openfile "*.ab" "%toolpath%\backups" "Select a backup to restore to"') do set "result=%%a"
if defined result GOTO twrpacheck2 
for /f "delims=" %%a in ('%popup% "You have not selected a backup!" "Error" "OKCancel" "Error"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
GOTO BACKUPBROWSE2
:twrpacheck2
cls
echo.
echo Checking ADB\Fastboot Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF %ERRORLEVEL% EQU 1 GOTO twrpfcheck2
echo.
echo ADB device connected! 
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity... 
:twrpfcheck2
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF %ERRORLEVEL% equ 0 GOTO twrpfconnected2
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port.\n\n-Use the install driver option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
GOTO twrpacheck2
:twrpfconnected2
echo.
echo Fastboot device connected!
if "%android_ver%"=="6 " (
echo.
echo Flashing TWRP...
echo.
"%toolpath%\utils\fastboot" flash recovery "%toolpath%\twrp\%tversion%"
%popup% "Keep pressing the volume up key on the device until the 'Start' at the top changes to 'Recovery mode'. Then press power to select.\n\nPress 'OK' to continue when TWRP recovery has fully loaded.\n\nMake sure to tap swipe to allow modifications on startup!" "Information" >nul 2>&1
GOTO twrpacheckb2
)
echo.
echo Booting TWRP...
echo.
"%toolpath%\utils\fastboot" boot "%toolpath%\twrp\%tversion%"
echo.
echo Swipe to allow modifications on startup!
echo Press any key to continue once TWRP recovery has fully loaded...
pause >nul
:twrpacheckb2
echo.
echo Checking ADB Recovery Connectivity... 
"%toolpath%\utils\adb" devices | find "recovery" >nul 2>&1
IF %ERRORLEVEL% equ 0 GOTO twrpab2connected
for /f "delims=" %%a in ('%popup% "ADB recovery device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install drivers option\n\nMake sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel GOTO OPTIONS
GOTO twrpacheckb2
:twrpab2connected
echo.
echo ADB Recovery device connected! 
echo. 
echo Restoring backup... ("%result%")
"%toolpath%\utils\adb" shell twrp mount system >nul 2>&1
"%toolpath%\utils\adb" restore "%result%" >nul 2>&1
"%toolpath%\utils\adb" shell twrp unmount system >nul 2>&1
"%toolpath%\utils\adb" reboot
%popup% "Your backup '%result%' should have successfully been restored. If there were any restore errors please pull your device's recovery log with 'adb pull /tmp/recovery.log' and send it to the developer." "Information" >nul 2>&1
GOTO OPTIONS
:TWRPFLASH
if "%twrp_disable%"=="yes" (
%popup% "Option is disabled due to missing twrp image." "Error" "OK" "Error" >nul 2>&1
GOTO OPTIONS
)
for /f "delims=" %%a in ('%popup% "This option flashes TWRP, a custom recovery with many features such as backups, zip flashing, etc. It requires an unlocked bootloader. If your bootloader is not already unlocked, use the unlock option in the toolkit first." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
cls
:acheck9
echo.
echo Checking ADB\Fastboot Connectivity... 
"%toolpath%\utils\adb" devices | findstr "\<device\>" >nul 2>&1
IF "%ERRORLEVEL%" equ "1" GOTO fcheck9
echo.
echo ADB device connected! 
echo.
echo Rebooting to bootloader...
"%toolpath%\utils\adb" reboot bootloader
echo.
timeout /t 15
echo.
echo Checking Fastboot Connectivity... 
:fcheck9
"%toolpath%\utils\fastboot" devices | find "fastboot" >nul 2>&1
IF "%ERRORLEVEL%" equ "0" GOTO fconnected9
for /f "delims=" %%a in ('%popup% "Fastboot device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port.\n\n-Use the install drivers option\n\n-Make sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite Bootloader Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\n-Boot your device into bootloader mode manually: Press and hold the power and volume up buttons for 10-15 seconds to boot into recovery, then use the volume down key to go down to 'Reboot to bootloader' and press power to select.\n\nIf your device rebooted normally then your device has no access to fastboot. Follow the miflash instructions for the bootloader unlock option to restore your device's fastboot mode.\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
GOTO acheck9
:fconnected9
echo.
echo Fastboot device connected! 
echo.
echo Flashing TWRP...
echo.
"%toolpath%\utils\fastboot" flash recovery "%toolpath%\twrp\%tversion%"
if "%android_ver%"=="6 " (
%popup% "Keep pressing the volume up key on the device until the 'Start' at the top changes to 'Recovery mode'. Then press power to select.\n\nPress 'OK' to continue when TWRP recovery has fully loaded.\n\nMake sure to tap 'Keep read-only' on startup!" "Information" >nul 2>&1
GOTO acheck9b
)
echo.
echo Booting TWRP...
echo.
"%toolpath%\utils\fastboot" boot "%toolpath%\twrp\%tversion%"
echo.
echo Tap 'Keep read-only' on startup!
echo Press any key to continue once TWRP has fully loaded...
pause >nul
:acheck9b
echo.
echo Checking ADB Recovery Connectivity... 
"%toolpath%\utils\adb" devices | find "recovery" >nul 2>&1
IF %ERRORLEVEL% equ 0 GOTO aconnected9b
for /f "delims=" %%a in ('%popup% "ADB recovery device is not connected.\n\nTroubleshooting:\n\n-Make sure your device is connected to the PC. For best results use the original OEM cable and plug your device into a USB 2.0 port\n\n-Use the install drivers option\n\nMake sure your drivers are properly configured. Your device should be shown as something similar to 'Android Composite ADB Interface' in Device Manager\n\n-Try an alternate USB 2.0 port\n\nYou also may just need to try again.\n\nPress 'OK' to try again.\n\nPress 'Cancel' to return to options." "Error" "OKCancel" "Stop"') do set button=%%a 
if %button% equ cancel GOTO OPTIONS
GOTO acheck9b
:aconnected9b
echo.
echo ADB recovery device connected! 
echo.
echo Mounting system...
"%toolpath%\utils\adb" shell busybox /mount system >nul 2>&1
echo.
echo Renaming files...
"%toolpath%\utils\adb" shell mv "/system/recovery-from-boot.p" "/system/recovery-from-boot.p.bak" >nul 2>&1
"%toolpath%\utils\adb" shell mv "/system/etc/install-recovery.sh" "/system/etc/install-recovery.sh.bak" >nul 2>&1
echo.
Echo Disabling dm-verity and forced encryption...
"%toolpath%\utils\adb" push %toolpath%\twrp\no-verity-opt-encrypt.zip /sdcard/
"%toolpath%\utils\adb" shell twrp install /sdcard/no-verity-opt-encrypt.zip >nul 2>&1
"%toolpath%\utils\adb" shell twrp wipe cache >nul 2>&1
"%toolpath%\utils\adb" shell twrp wipe dalvik >nul 2>&1
"%toolpath%\utils\adb" reboot 
echo.
echo Press any key to return to options...
pause >nul
GOTO OPTIONS

:SOPTIONS
cd "%toolpath%\stored"
cls
echo ================================================================================
echo 	                          AXON7TOOLKIT 1.3.0
echo ================================================================================
echo.
set /p variant=<variant
set variant=%variant: =%
set /p android_ver=<android_ver
echo Variant: %variant%
echo Android version: %android_ver%
echo(
echo ===============================================================================
echo                                SETTINGS
echo ===============================================================================
echo 1. CHANGE VARIANT
echo 2. CHANGE ANDROID VERSION
echo 3. CHECK FOR TOOLKIT/DEPENDENCY UPDATES
echo 4. SET/REMOVE DOWNLOAD RATE LIMIT
echo 5. VIEW UPDATE LOG
echo 6. UNINSTALL
echo 7. CHANGELOG
echo 8. ABOUT THIS TOOLKIT
echo(
set option=
set /p "option=Choose an option(1-8) or press enter to return to main menu:"
if "%option%"=="1" (GOTO VAR)
if "%option%"=="2" (GOTO AVER)
if "%option%"=="3" (GOTO UPDATE)
if "%option%"=="4" (GOTO LIMIT)
if "%option%"=="5" (GOTO LOG)
if "%option%"=="6" (GOTO UNINSTALL)
if "%option%"=="7" (GOTO CHANGELOG)
if "%option%"=="8" (GOTO ABOUT)
if not defined option goto options
echo(
echo Invalid option!
ping localhost -n 2 >nul
GOTO SOPTIONS
:VAR
cls
echo(
echo(
echo                     1-A2017 (China)
echo                     2-A2017U (North America)
echo                     3-A2017G (Global)
echo(
echo(
set /p "variant=Choose your hardware variant (1-3):"
if "%variant%"=="1" (
echo A2017>variant
GOTO VARCONF
)
if "%variant%"=="2" (
echo A2017U>variant
GOTO VARCONF
)
if "%variant%"=="3" (
echo A2017G>variant
GOTO VARCONF
)
echo(
echo Invalid entry!
ping localhost -n 2 >nul
GOTO VAR
:VARCONF
%popup% "Variant changed successfully!" "Information" >nul 2>&1
GOTO SOPTIONS
:AVER
cls
echo(
echo(
echo                     1- Android 6
echo                     2- Android 7
echo(
echo(
set /p "android_ver=Choose your android version (1-3):"
if "%android_ver%"=="1" (
echo 6 >android_ver
GOTO AVERCONF
)
if "%android_ver%"=="2" (
echo 7 >android_ver
GOTO AVERCONF
)
echo(
echo Invalid entry!
ping localhost -n 2 >nul
GOTO AVER
:AVERCONF
%popup% "Android version changed successfully!" "Information" >nul 2>&1
GOTO SOPTIONS
:UPDATE
call :SUBPROCCESS_UPDATE
call :SUBPROCESS_DEPENCHECK
GOTO SOPTIONS
:UNINSTALL
taskkill /F /IM sha256sum.exe >nul 2>&1
taskkill /F /IM 7za.exe >nul 2>&1
taskkill /F /IM adb.exe >nul 2>&1
taskkill /F /IM fastboot.exe >nul 2>&1
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM Axon7Toolkit.exe >nul 2>&1
taskkill /F /IM update.tmp.exe >nul 2>&1
start "" "%toolpath%\unins000.exe"
exit
:CHANGELOG
echo(
echo Press the space bar or enter key to scroll.
echo.
pause
type "%toolpath%\stored\changelog.txt" | more /E /C
GOTO SOPTIONS
:ABOUT
cd "%toolpath%\stored"
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestTWRP twrp') do set twrp=%%a
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestSuperSU supersu') do set supersu=%%a
for /f "delims=" %%a in ('type version.txt') do set version=%%a
%popup% "Version: %version%\nLanguage: Batch, C++\nDeveloper: bkores\nLatest TWRP: %twrp%\nLatest SuperSU: %supersu%" "About Axon7Toolkit" >nul 2>&1
GOTO SOPTIONS
:LOG
IF NOT EXIST "%toolpath%\updates\update.log" %popup% "No update log exists." "Error" "OK" "Error" >nul  & GOTO SOPTIONS
echo(
echo Press the space bar or enter key to scroll.
echo.
pause
type "%toolpath%\updates\update.log" | more /E /C
echo(
pause
GOTO SOPTIONS
:LIMIT
for /f "delims=" %%a in ('%popup% "This option will limit the download rate for all files downloaded through the toolkit's downloader, including updates. This is useful for when you don't want the toolkit to use up all of your available bandwidth." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel GOTO OPTIONS
cls
echo(
echo(
echo(
if exist limit.txt set /p limit=<limit.txt
if not exist limit.txt (echo Current limit: No limit set) else (Echo Current limit: %limit% /s)
set limit=
echo(
echo Enter limit value followed by 'b' for bytes, 'k' for kilobytes, or 'm' for megabytes
echo -No spaces and lowercase
echo -Decimals are allowed
echo(
echo Examples:                                  
Echo 400 bytes/sec: 400b                            
Echo 50 kilobytes/sec: 50k                          
Echo 3.5 megabytes/sec: 3.5m                            
echo(
echo Press enter to remove limit
echo(
set /p "limit="
if not defined limit (
DEL /F limit.txt >nul 2>&1
) else (
echo %limit%>limit.txt
)
if not defined limit (%popup% "Limit removed successfully" "Information" >nul) else (%popup% "Limit successfully set to %limit% per second" "Information" >nul)
GOTO SOPTIONS



rem #-------------SUBROUTINES----------------#

:zippush
set zip=%*
for /f "delims=" %%A in (%zip%) do set zipname=%%~nxA
echo.
echo Pushing '%zipname%'...
"%toolpath%\utils\adb" push %zip% /sdcard/
echo.
echo Flashing...
"%toolpath%\utils\adb" shell twrp install /sdcard/%zipname% >nul 2>&1
exit /b

:SUBPROCCESS_UPDATE
cd "%toolpath%"
echo.
echo Checking for toolkit update...
ping localhost -n 2 >nul
IF EXIST Toolkit.ini DEL Toolkit.ini
"%toolpath%\utils\wget" --quiet --no-check-certificate https://raw.githubusercontent.com/bennykor/Axon7Toolkit/master/Toolkit.ini
IF NOT EXIST Toolkit.ini (
echo.
echo Failed to connect to server!
ping localhost -n 2 >nul
exit /b
)
move /Y Toolkit.ini "%toolpath%\stored"  >nul 2>&1
cd "%toolpath%\stored"
set /p current=<version.txt
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest version') do set latest=%%a
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest name') do set name=%%a  
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest link') do set link=%%a 
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest size') do set size=%%a 
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest sha256') do set sha256=%%a
for /f "delims=" %%a in ('call ini.cmd Toolkit.ini Latest changelog') do set "changelog=%%a"
set latest=%latest: =%
cd "%toolpath%"
IF %current% EQU %latest% exit /b
rem Divide %size% 1000000
set psize=%result%
set psize=%psize%.
set /a pround=psize+0
set pfract=%psize:*.=%0
set /a pround=1%pround%%pfract:~,1%+5
if %pround:~,1% GTR 1 (set psize=1%pround:~1,-1%) else (set psize=%pround:~1,-1%)
IF EXIST "%toolpath%\updates\%name%" GOTO UPDATE_DOWNLOADED
for /f "delims=" %%a in ('%popup% "Update available!\n\nCurrent: %current%\nLatest: %latest%\nSize: %psize% mb\n\nChangelog:\n\n%changelog%\n\nDownload and install?" "Information" "YesNo"') do set button=%%a
if %button% equ no exit /b
:UPDATE_DOWNLOAD
cd "%toolpath%"
echo.
echo Downloading update...
call :Downloader %name% updates %link% %sha256% %size% update
IF "%ERRORLEVEL%" equ "1" (
echo.
echo. Update download failed. Aborting...
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
IF EXIST "%toolpath%\updates\%name%" DEL "%toolpath%\updates\%name%"
ping localhost -n 2 >nul
exit /b
)
GOTO UPDATE_INSTALL
:UPDATE_DOWNLOADED
for /f "delims=" %%a in ('%popup% "Update available!\n\nCurrent: %current%\nLatest: %latest%\nSize: %psize% mb\n\nChangelog:\n\n%changelog%\n\nPackage downloaded. Install?" "Information" "YesNo"') do set button=%%a
if %button% equ no exit /b
:UPDATE_INSTALL
echo.
echo Installing update...
ping localhost -n 2 >nul
"%toolpath%\updates\%name%" /SP- /SILENT /LOG="%toolpath%\updates\update.log" /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS /NORESTART
exit



:DOWNLOADER
set filename=%~1 
set filename=%filename: =%
set directory=%~2 
set directory=%directory: =%
set link=%~3 
set link=%link: =%
set sha256=%~4 
set sha256=%sha256: =%
set size=%~5
set type=%~6
set type=%type: =%
cd "%toolpath%"
cd %directory%
IF EXIST %filename% DEL /F %filename%
IF NOT EXIST "%toolpath%\stored\limit.txt" GOTO NOLIMIT
for /f "delims=" %%a in ('type %toolpath%\stored\limit.txt') do set limit=%%a
"%toolpath%\utils\wget" --quiet --output-document=%filename% --limit-rate=%limit% --no-check-certificate --show-progress %link%
if errorlevel 3 (
echo.
echo Download failed!
ping localhost -n 2 >nul
GOTO IMPORT
)
GOTO DOWNLOADVERIFY
:NOLIMIT
"%toolpath%\utils\wget" --quiet --show-progress --output-document=%filename% --no-check-certificate %link%
if errorlevel 3 (
echo.
echo Download failed!
ping localhost -n 2 >nul
GOTO IMPORT
)
:DOWNLOADVERIFY
echo.
echo Verifying download...
"%toolpath%\utils\sha256sum" %filename% | findstr "\<%sha256%\>" >nul 2>&1
IF %ERRORLEVEL% equ 1 (
echo.
echo sha256sum mismatch!
ping localhost -n 2 >nul
GOTO IMPORT
)
echo.
echo sha256sum match!
ping localhost -n 2 >nul
exit /b 0

:IMPORT
for /f "delims=" %%a in ('%popup% "File download/hash verification failed. This is most likely due to an unstable network connection or problems with the link/server.\n\nImport instructions:\n\nThe downloads page will be launched. Look for %filename% and download it. You will then be able to import the file." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel exit /b 1
if %type% equ dependency start "" "https://www.androidfilehost.com/?w=files&flid=160532"
if %type% equ update start "" "https://www.androidfilehost.com/?w=files&flid=160610"
echo(
pause
echo(
:IMPORTC
set result=
for /f "delims=" %%a in ('%toolpath%\utils\openfile "" "%USERPROFILE%\Downloads" "Choose file to import"') do set "result=%%a"
if not defined result (
%popup% "No file was selected!" "Error" "OK" "Error" >nul 2>&1
GOTO IMPORTC
)
for /f "delims=" %%I in ("%result%") do (set "importname=%%~nxI")
IF "%importname%"=="%filename%" GOTO CONTINUEIMPORT
for /f "delims=" %%a in ('%popup% "Filename must be %filename%!" "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ ok GOTO IMPORTC
if %button% equ cancel exit /b 1
:CONTINUEIMPORT
echo(
echo Importing...
xcopy /y /q "%result%" >nul 2>&1
set errorcode=%ERRORLEVEL%
if not %errorcode% equ 0 (
%popup% "Import failed!\nxcopy error code: %errorcode%" "Error" "OK" "Error" >nul 2>&1
GOTO IMPORTC
)
echo(
echo Verifying imported file...
echo(
"%toolpath%\utils\sha256sum" %filename% | findstr "\<%sha256%\>" >nul 2>&1
If %ERRORLEVEL% equ 1 (
echo sha256sum mismatch! 
ping localhost -n 2 >nul 
GOTO IMPORTOVERRIDE
)
echo sha256sum match!
:IMPORTDONE
ping localhost -n 2 >nul
exit /b 0
:IMPORTOVERRIDE
for /f "delims=" %%a in ('%popup% "Override file verification?\n\nOnly do this if you are completely sure of the file's integrity!!!" "Information" "YesNoCancel" "Warning"') do set button=%%a
if %button% equ yes GOTO IMPORTDONE
if %button% equ no GOTO IMPORT
if %button% equ cancel exit /b 1

:SUBPROCESS_DEPENCHECK
cd "%toolpath%"
echo.
echo Checking if all needed files are present and up to date...
ping localhost -n 2 >nul
IF EXIST LatestFileDependencies.ini DEL /F LatestFileDependencies.ini
"%toolpath%\utils\wget" --quiet --no-check-certificate https://raw.githubusercontent.com/bennykor/Axon7Toolkit/master/LatestFileDependencies.ini
IF NOT EXIST LatestFileDependencies.ini (
echo.
echo Failed to connect to server!
ping localhost -n 2 >nul
exit /b
)
move /Y LatestFileDependencies.ini "%toolpath%\stored" >nul 2>&1
:TWRP
cd "%toolpath%\stored"
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestTWRP twrp') do (set filename=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini DownloadLinks %filename%') do (set filelink=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini FileDirectories %filename%') do (set directory=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sha256sum %filename%') do (set sha256sum=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sizes %filename%') do (set size=%%a)
IF EXIST "%toolpath%\%directory%\%filename%" GOTO SUPERSU
echo.
echo Downloading TWRP recovery image...
ping localhost -n 2 >nul
call :DOWNLOADER %filename% %directory% %filelink% %sha256sum% %size% dependency
IF "%ERRORLEVEL%" equ "1" (
echo.
echo Failed to download TWRP recovery image!
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
IF EXIST "%toolpath%\%directory%\%filename%" DEL /F "%toolpath%\%directory%\%filename%"
ping localhost -n 2 >nul
)
:SUPERSU
cd "%toolpath%\stored"
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestSuperSU supersu') do (set filename=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini DownloadLinks %filename%') do (set filelink=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini FileDirectories %filename%') do (set directory=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sha256sum %filename%') do (set sha256sum=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sizes %filename%') do (set size=%%a)
IF EXIST "%toolpath%\%directory%\%filename%" GOTO MAGISK
echo.
echo Downloading SuperSU root file...
ping localhost -n 2 >nul
call :DOWNLOADER %filename% %directory% %filelink% %sha256sum% %size% dependency
IF "%ERRORLEVEL%" equ "1" (
echo.
echo Failed to download SuperSU root file!
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
IF EXIST "%toolpath%\%directory%\%filename%" DEL /F "%toolpath%\%directory%\%filename%"
ping localhost -n 2 >nul
exit /b
)
:MAGISK
cd "%toolpath%\stored"
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestMagisk magisk') do (set filename=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini DownloadLinks %filename%') do (set filelink=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini FileDirectories %filename%') do (set directory=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sha256sum %filename%') do (set sha256sum=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sizes %filename%') do (set size=%%a)
IF EXIST "%toolpath%\%directory%\%filename%" GOTO SUPERSU_UNINS
echo.
echo Downloading Magisk root file...
ping localhost -n 2 >nul
call :DOWNLOADER %filename% %directory% %filelink% %sha256sum% %size% dependency
IF "%ERRORLEVEL%" equ "1" (
echo.
echo Failed to download Magisk root file!
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
IF EXIST "%toolpath%\%directory%\%filename%" DEL /F "%toolpath%\%directory%\%filename%"
ping localhost -n 2 >nul
exit /b
)
:SUPERSU_UNINS
cd "%toolpath%\stored"
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestSuperSU_unins supersu_unins') do (set filename=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini DownloadLinks %filename%') do (set filelink=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini FileDirectories %filename%') do (set directory=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sha256sum %filename%') do (set sha256sum=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sizes %filename%') do (set size=%%a)
IF EXIST "%toolpath%\%directory%\%filename%" GOTO MAGISK_UNINS
echo.
echo Downloading SuperSU unroot file...
ping localhost -n 2 >nul
call :DOWNLOADER %filename% %directory% %filelink% %sha256sum% %size% dependency
IF "%ERRORLEVEL%" equ "1" (
echo.
echo Failed to download SuperSU unroot file!
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
IF EXIST "%toolpath%\%directory%\%filename%" DEL /F "%toolpath%\%directory%\%filename%"
ping localhost -n 2 >nul
exit /b
)
:MAGISK_UNINS
cd "%toolpath%\stored"
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini LatestMagisk_unins magisk_unins') do (set filename=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini DownloadLinks %filename%') do (set filelink=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini FileDirectories %filename%') do (set directory=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sha256sum %filename%') do (set sha256sum=%%a) 
for /f "delims=" %%a in ('call ini.cmd LatestFileDependencies.ini sizes %filename%') do (set size=%%a)
IF EXIST "%toolpath%\%directory%\%filename%" exit /b
echo.
echo Downloading Magisk unroot file...
ping localhost -n 2 >nul
call :DOWNLOADER %filename% %directory% %filelink% %sha256sum% %size% dependency
IF "%ERRORLEVEL%" equ "1" (
echo.
echo Failed to download Magisk unroot file!
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM md5sum.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
IF EXIST "%toolpath%\%directory%\%filename%" DEL /F "%toolpath%\%directory%\%filename%"
ping localhost -n 2 >nul
exit /b
)
