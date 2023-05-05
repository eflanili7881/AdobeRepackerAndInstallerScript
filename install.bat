@echo off
rem #####################
rem # Preparation Phase #
rem #####################
cd "%~dp0"
echo "==> Setting Variables ..."
set adobetempinstaller=%systemdrive%\adobetempinstaller
set adobeworkfolder=%systemdrive%\adobeworkfolder
echo "==> Deleting Previously Failed Instance ..."
rd %adobeworkfolder% /s /q
rd %adobetempinstaller% /s /q
echo "==> Creating Directories ..."
mkdir %adobeworkfolder%
mkdir %adobetempinstaller%
mkdir %adobetempinstaller%\products
cd "%~dp0products"
for /d %%a in ("*") do mkdir "%adobetempinstaller%\products\%%a"
cd "%~dp0"
echo "==> Creating Exclusion File ..."
echo "Be sure to maximize shell window here, because get-childitem will clip directory names if you don't maximize the shell window."
pause
powershell  -command "get-childitem -path %~dp0products -recurse -directory -depth 1 | select FullName" > %adobeworkfolder%\exclude.txt
echo "Remove first 3 line from get-childitem, remove main folders, remove all things before products that not including \ before on products folder and remove all spaces from file and save it."
notepad %adobeworkfolder%\exclude.txt
pause
rem #####################
rem # Compression Phase #
rem #####################
echo "==> Compressing Unpacked Products ..."
echo "Be sure to maximize shell window here, because get-childitem will clip directory names if you don't maximize the shell window."
pause
powershell  -command "get-childitem -path .\products -recurse -directory -depth 1 | select FullName" > %adobeworkfolder%\compress.txt
echo "Remove first 3 line from get-childitem, remove main folders, remove all things before products that including \ before on products folder and remove all spaces from file and save it."
notepad %adobeworkfolder%\compress.txt
pause
for /f "usebackq delims=" %%b in ("%adobeworkfolder%\compress.txt") do "C:\Program Files\7-Zip\7z.exe" a -bd -tzip "%adobetempinstaller%\%%b.zip" -mx5 -r "%~dp0%%b\*"
rem ###########################
rem # Copying Installer Phase #
rem ###########################
echo "==> Copying Installer ..."
xcopy /q /e /h "%~dp0*" "%adobetempinstaller%" /exclude:%adobeworkfolder%\exclude.txt
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
rd %adobeworkfolder% /s /q
pause
