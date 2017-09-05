@echo off
set type=%~1
set duration=%~2
set message=%~3
set toolpath=C:\Axon7Development\Axon7Toolkit

%toolpath%\notifu /t %type% /d %duration% /p "Axon7Toolkit" /m "%message%" /i %toolpath%\icons\toolkit.ico