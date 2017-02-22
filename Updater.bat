@echo off
IF EXIST Temp.txt GOTO DOWNLOAD
IF EXIST Updater.bat DEL Updater.bat
wget\bin\wget --no-check-certificate https://raw.githubusercontent.com/bennykor/Axon7Toolkit/master/Updater.bat
rename Updater.bat.txt Updater.bat
IF EXIST Updater.bat echo Update >>Temp.txt & start Updater & exit
IF NOT EXIST Updater.bat notifu.exe /t error /d 3 /p "Axon7Toolkit" /m "Failed! No connection!" & exit
:DOWNLOAD
notifu.exe /t info /d 3 /p "Axon7Toolkit" /m "Downloading any updates to toolkit and file dependencies..."
:TWRP 
wget\bin\wget --no-clobber --directory-prefix=twrp --no-check-certificate https://dl.twrp.me/ailsa_ii/twrp-3.0.3-1-ailsa_ii.img
IF NOT EXIST twrp\twrp-3.0.3-1-ailsa_ii.img notifu.exe /t error /d 3 /p "Axon7Toolkit" /m "Failed! No connection!" & DEL Temp.txt & exit
:SignedTWRP
wget\bin\wget --no-clobber --directory-prefix=unlock_bl_mm --no-check-certificate https://github.com/bennykor/Axon7Tool/raw/master/twrp-signed-mm.img
IF NOT EXIST unlock_bl_mm\twrp-signed-mm.img notifu.exe /t error /d 3 /p "Axon7Toolkit" /m "Failed! No connection!" & DEL Temp.txt & exit
:SuperSU
wget\bin\wget --no-clobber --directory-prefix=root --no-check-certificate https://s3-us-west-2.amazonaws.com/supersu/download/zip/SuperSU-v2.79-201612051815.zip
IF NOT EXIST root\SuperSU-v2.79-201612051815.zip notifu.exe /t error /d 3 /p "Axon7Toolkit" /m "Failed! No connection!" & DEL Temp.txt & exit
:FastbootIMG
wget\bin\wget --no-clobber --directory-prefix=unlock_bl_mm --no-check-certificate http://qc4.androidfilehost.com/dl/nhb78lfuP5csxTYkwf8UGw/1488006666/745425885120705379/fbop.img
IF NOT EXIST unlock_bl_mm\fbop.img notifu.exe /t error /d 3 /p "Axon7Toolkit" /m "Failed! No connection!" &  DEL Temp.txt & exit
notifu.exe /t info /d 3 /p "Axon7Toolkit" /m "Success! All toolkit files are up to date!"
DEL Temp.txt
exit
