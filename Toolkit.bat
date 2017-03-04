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
echo Build successfully set to %build%
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
set /p build=Choose the build you are on(1-7) :  
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
set /p theme=Choose a theme(1-6) or press enter for default :
if {%theme%}=={1} (echo color 0f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={2} (echo color 1f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={3} (echo color 2f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={4} (echo color 3f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={5} (echo color 4f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
if {%theme%}=={6} (echo color 5f >>theme.txt) & (%theme%) & (echo Theme set successfully) & (GOTO OPTIONS)
echo color 1f >>theme.txt
%theme%
echo Theme set successfully
cls
:OPTIONS
cd C:\Program Files\Axon7Toolkit\bin
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
echo USB DEBUGGING MUST BE ENABLED BEFORE CHOOSING ANY OF THE OPTIONS!
echo IF NOT ENABLED GO TO SETTINGS, ABOUT PHONE, AND TAP BUILD NUMBER
echo 7 TIMES TO ENABLE DEVELOPER OPTIONS. THEN TURN ON USB DEBUGGING
echo IN DEVELOPER OPTIONS.
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


