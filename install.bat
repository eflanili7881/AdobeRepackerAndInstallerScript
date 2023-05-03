@echo off
rem #####################
rem # Preparation Phase #
rem #####################
cd %~dp0
echo "==> Setting Variables ..."
set adobetempinstaller=%temp%\adobetempinstaller
set excludefolder=%systemdrive%\excludefolder
echo "==> Deleting Previously Failed Instance ..."
rd %excludefolder% /s /q
rd %adobetempinstaller% /s /q
echo "==> Creating Directories ..."
mkdir %excludefolder%
mkdir %adobetempinstaller%
mkdir %adobetempinstaller%\products
mkdir %adobetempinstaller%\products\LTRM
mkdir %adobetempinstaller%\products\COSY
echo "==> Copying Exclusion File ..."
copy "%~dp0exclude.txt" "%excludefolder%\exclude.txt"
rem #####################
rem # Compression Phase #
rem #####################
echo "==> Compressing Unpacked Products ..."
"C:\Program Files\7-Zip\7z.exe" a -bd -tzip "%adobetempinstaller%\products\LTRM\AdobeLightroom-mul.zip" -mx5 -r "%~dp0products\LTRM\AdobeLightroom-mul\*"
"C:\Program Files\7-Zip\7z.exe" a -bd -tzip "%adobetempinstaller%\products\COSY\CoreSync-mul.zip" -mx5 -r "%~dp0products\COSY\CoreSync-mul\*"
rem ###########################
rem # Copying Installer Phase #
rem ###########################
echo "==> Copying Installer ..."
xcopy /q /e /h "%~dp0*" "%adobetempinstaller%" /exclude:%excludefolder%\exclude.txt
rem ######################
rem # Installation Phase #
rem ######################
echo "==> Installing Product ..."
call "%adobetempinstaller%\Set-up.exe"
rem ##################
rem # Clean-up Phase #
rem ##################
echo "==> Cleaning Up ..."
rd %adobetempinstaller% /s /q
rd %excludefolder% /s /q
pause