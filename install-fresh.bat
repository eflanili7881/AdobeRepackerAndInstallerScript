@echo off
rem #####################
rem # Preparation Phase #
rem #####################
cd %~dp0
echo "==> Setting Variables ..."
set adobetempinstaller=%systemdrive%\adobetempinstaller
set adobeworkfolder=%systemdrive%\adobeworkfolder
echo "==> Deleting Previously Failed Instance ..."
rd %adobeworkfolder% /s /q
rd %adobetempinstaller% /s /q
echo "==> Creating Directories ..."
mkdir %adobeworkfolder%
mkdir %adobetempinstaller%
mkdir %adobetempinstaller%\packages
cd "%~dp0packages"
for /d %%a in ("*") do mkdir "%adobetempinstaller%\packages\%%a"
cd "%~dp0"
mkdir %adobetempinstaller%\payloads
cd "%~dp0payloads"
for /d %%b in ("*") do mkdir "%adobetempinstaller%\payloads\%%b"
echo "==> Creating Exclusion File ..."
echo "Be sure to maximize shell window here, because get-childitem will clip directory names if you don't maximize the shell window."
pause
cd "%~dp0packages"
powershell -command "get-childitem -path "." -recurse -directory -depth 1 | select FullName" > %adobeworkfolder%\excludepackages.txt
cd "%~dp0"
cd "%~dp0payloads"
powershell -command "get-childitem -path "." -recurse -directory -depth 1 | select FullName" > %adobeworkfolder%\excludepayloads.txt
echo "Remove first 3 line from get-childitem, remove main folders, remove all things before packages, payloads folder that not including \ before on packages, payloads folder, remove all spaces from file, put \ every end of the line and save it."
pause
notepad %adobeworkfolder%\excludepackages.txt
notepad %adobeworkfolder%\excludepayloads.txt
rem #####################
rem # Compression Phase #
rem #####################
echo "==> Compressing Unpacked Products ..."
echo "Be sure to maximize shell window here, because get-childitem will clip directory names if you don't maximize the shell window."
pause
cd "%~dp0packages"
powershell -command "get-childitem -path "." -recurse -directory -depth 1 | select FullName" > %adobeworkfolder%\compresspackages.txt
cd "%~dp0"
cd "%~dp0payloads"
powershell -command "get-childitem -path "." -recurse -directory -depth 1 | select FullName" > %adobeworkfolder%\compresspayloads.txt
echo "Remove first 3 line from get-childitem, remove main folders, remove all things before packages, payloads folder that including \ before on packages, payloads folder, remove all spaces from file, put \ every end of the line and save it."
notepad %adobeworkfolder%\compresspackages.txt
notepad %adobeworkfolder%\compresspayloads.txt
pause
for /f "usebackq delims=" %%c in ("%adobeworkfolder%\compresspackages.txt") do "C:\Program Files\7-Zip\7z.exe" a -bd -tzip "%adobetempinstaller%\%%c.pima" -mx5 -r "%~dp0%%c\*"
for /f "usebackq delims=" %%d in ("%adobeworkfolder%\compresspayloads.txt") do "C:\Program Files\7-Zip\7z.exe" a -bd -tzip "%adobetempinstaller%\%%d.zip" -mx5 -r "%~dp0%%d\*"
rem ###########################
rem # Copying Installer Phase #
rem ###########################
echo "==> Copying Installer ..."
xcopy /q /e /h "%~dp0*" "%adobetempinstaller%" /exclude:%adobeworkfolder%\excludepackages.txt+%adobeworkfolder%\excludepayloads.txt
rem ######################
rem # Installation Phase #
rem ######################
echo "==> Installing Product ..."
call "%adobetempinstaller%\Set-up.exe"
echo "==> Waiting For Installation To Be Completed ..."
echo "After installation completed, press any key ..."
pause
rem ##################
rem # Clean-up Phase #
rem ##################
echo "==> Cleaning Up ..."
rd %adobetempinstaller% /s /q
rd %adobeworkfolder% /s /q
pause