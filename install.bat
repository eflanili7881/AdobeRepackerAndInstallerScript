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
powershell -command "start-transcript -path "%adobeworkfolder%\exclude.txt"; get-childitem -path "%~dp0products" -recurse -directory -depth 1 | foreach-object { Write-Host $_.FullName }; stop-transcript"
echo "Remove all lines but file/folder paths, remove main folders, remove all things before products that not including \ before on products folder, copy first line to one below to avoid an anomaly and save it."
notepad %adobeworkfolder%\exclude.txt
pause
rem #####################
rem # Compression Phase #
rem #####################
echo "==> Compressing Unpacked Products ..."
powershell -command "start-transcript -path %adobeworkfolder%\compress.txt; get-childitem -path .\products -recurse -directory -depth 1 | foreach-object { Write-Host $_.FullName }; stop-transcript"
echo "Remove all lines but file/folder paths, remove main folders, remove all things before products that including \ before on products folder, copy first line to one below to avoid an anomaly and save it."
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
