@ECHO OFF
REM BFCPEOPTIONSTART
REM Advanced BAT to EXE Converter www.BatToExeConverter.com
REM BFCPEEXE=
REM BFCPEICON=C:\Users\ben\Google Drive\Axon7Development\Axon7Toolkit\icons\download.ico
REM BFCPEICONINDEX=1
REM BFCPEEMBEDDISPLAY=0
REM BFCPEEMBEDDELETE=1
REM BFCPEADMINEXE=0
REM BFCPEINVISEXE=0
REM BFCPEVERINCLUDE=0
REM BFCPEVERVERSION=1.0.0.0
REM BFCPEVERPRODUCT=Product Name
REM BFCPEVERDESC=Product Description
REM BFCPEVERCOMPANY=Your Company
REM BFCPEVERCOPYRIGHT=Copyright Info
REM BFCPEEMBED=C:\Users\Ben\Google Drive\Output EXEs\dependencydownloader.exe
REM BFCPEOPTIONEND
@ECHO ON
@echo off
mode con: cols=65 lines=10 
color 70
title Axon7Toolkit Downloader
rem CenterSelf
set toolpath=C:\Axon7Development\Axon7Toolkit 
set toolpath=%toolpath: =%
set popup=%toolpath%\bin\popup
IF EXIST %toolpath%\stored\downloadsuccess DEL /F %toolpath%\stored\downloadsuccess 
IF "%~1"=="" exit
IF "%~2"=="" exit
IF "%~3"=="" exit
IF "%~4"=="" exit
IF "%~5"=="" exit
IF "%~6"=="" exit

:DOWNLOAD
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

cd %toolpath%
cd %directory%

IF EXIST %filename% DEL /F %filename% 
start %MYFILES%\dependencydownloader %filename% %directory% %link%
:PROGRESS
rem CursorHide
cls
echo(
echo Downloading: %filename%
echo Download: %percent%%% 
echo Hash verification:
echo(
for %%I in (%filename%) do set currentsize=%%~zI 
rem Divide %currentsize% %size%
set part1=%result%
rem Multiply %part1% 100
set percent=%result%
set percent=%percent%.
set /a pround=percent+0
set pfract=%percent:*.=%0
set /a pround=1%pround%%pfract:~,1%+5
if %pround:~,1% GTR 1 (set percent=1%pround:~1,-1%) else (set percent=%pround:~1,-1%)
ping localhost -n 1 >nul
tasklist /FI "IMAGENAME eq dependencydownloader.exe" | find /I /N "dependencydownloader.exe" >nul 2>&1
IF "%ERRORLEVEL%" equ "1" GOTO DOWNLOADCHECK
GOTO PROGRESS
:DOWNLOADCHECK
IF NOT EXIST %filename% GOTO DOWNLOADFAIL
cls
color 72
echo(
echo Downloading: %filename%
echo Download: %percent%%%
echo Hash verification: In progress
%toolpath%\hashcheck_extract\sha256sum %filename% | findstr "\<%sha256%\>" >nul 2>&1
IF %ERRORLEVEL% equ 1 GOTO HASHFAIL
:HASHPASS
cls 
color 72
echo(
echo Downloading: %filename%
echo Download: %percent%%%
echo Hash verification: Passed
echo( >%toolpath%\stored\downloadsuccess
ping localhost -n 2 >nul
exit
:DOWNLOADFAIL
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM dependencydownloader.exe >nul 2>&1
IF EXIST %filename% DEL /F %filename%
cls
color 74
echo(
echo Downloading: %filename%
echo Download: Failed!
echo Hash verification:
ping localhost -n 2 >nul

:IMPORT
color 70
cls
echo(
for /f "delims=" %%a in ('%popup% "File download/hash verification failed. This is most likely due to an unstable network connection or problems with the link/server.\n\nImport instructions:\n\nThe downloads page will be launched. Look for %filename% and download it. You will then be able to import the file." "Information" "OKCancel"') do set button=%%a
if %button% equ cancel exit
if %type% equ dependency start https://www.androidfilehost.com/?w=files^&flid=160532
if %type% equ update start https://www.androidfilehost.com/?w=files^&flid=160610
echo(
pause
echo(
:IMPORTC
set result=
for /f "delims=" %%a in ('%toolpath%\bin\openfile "" "%USERPROFILE%\Downloads" "Choose file to import"') do set "result=%%a"
if not defined result (
%popup% "No file was selected!" "Error" "OK" "Error" >nul 2>&1
GOTO IMPORTC
)
for /f "delims=" %%I in ("%result%") do (set "importname=%%~nxI")
IF "%importname%"=="%filename%" GOTO CONTINUEIMPORT
for /f "delims=" %%a in ('%popup% "Filename must be %filename%!" "Error" "OKCancel" "Stop"') do set button=%%a
if %button% equ ok GOTO IMPORTC
if %button% equ cancel exit
:CONTINUEIMPORT
cls
echo(
echo(
echo Importing...
xcopy /y /q "%result%" >nul 2>&1
set errorcode=%ERRORLEVEL%
if not %errorcode% equ 0 (
%popup% "Import failed!\nxcopy error code: %errorcode%" "Error" "OK" "Error" >nul 2>&1
GOTO IMPORTC
)
echo(
echo Verifying hash...
echo(
%toolpath%\hashcheck_extract\sha256sum %filename% | findstr "\<%sha256%\>" >nul 2>&1
If %ERRORLEVEL% equ 1 (
echo Failed! 
ping localhost -n 2 >nul 
GOTO IMPORTOVERRIDE
)
echo Hash verified!
:IMPORTDONE
echo( >%toolpath%\stored\downloadsuccess
ping localhost -n 2 >nul
exit
:IMPORTOVERRIDE
for /f "delims=" %%a in ('%popup% "Override hash verification?\n\nOnly do this if you are completely sure of the file's integrity!!!" "Information" "YesNoCancel" "Warning"') do set button=%%a
if %button% equ yes GOTO IMPORTDONE
if %button% equ no GOTO IMPORT
if %button% equ cancel exit

:HASHFAIL
taskkill /F /IM wget.exe >nul 2>&1
taskkill /F /IM dependencydownloader.exe >nul 2>&1
taskkill /F /IM sha256sum.exe >nul 2>&1
cls 
color 74
echo(
echo Downloading: %filename%
echo Download: %percent%%%
echo Hash verification: Failed!
IF EXIST %filename% DEL /F %filename%
ping localhost -n 2 >nul
GOTO IMPORT