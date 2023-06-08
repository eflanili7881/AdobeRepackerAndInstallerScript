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
powershell -command "start-transcript -path "%adobeworkfolder%\excludepackages.txt"; get-childitem -path "." -recurse -directory -depth 1 | foreach-object { Write-Host $_.FullName }; stop-transcript"
cd "%~dp0"
cd "%~dp0payloads"
powershell -command "start-transcript -path "%adobeworkfolder%\excludepayloads.txt"; get-childitem -path "." -recurse -directory -depth 1 | foreach-object { Write-Host $_.FullName }; stop-transcript"
echo "Remove all lines but file/folder paths, remove main folders, remove all things before packages and payloads that not including \ before on packages and payloads folder, put \ every end of the line, copy first line to one below to avoid an anomaly and save it."
pause
notepad %adobeworkfolder%\excludepackages.txt
notepad %adobeworkfolder%\excludepayloads.txt
echo "==> Renaming C:\Program Files (x86)\Common Files\Adobe\OOBE Folder ..."
move "C:\Program Files (x86)\Common Files\Adobe\OOBE" "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD"
rem #####################
rem # Compression Phase #
rem #####################
echo "==> Compressing Unpacked Products ..."
echo "Be sure to maximize shell window here, because get-childitem will clip directory names if you don't maximize the shell window."
pause
cd "%~dp0packages"
powershell -command "start-transcript -path "%adobeworkfolder%\compresspackages.txt"; get-childitem -path "." -recurse -directory -depth 1 | foreach-object { Write-Host $_.FullName }; stop-transcript"
cd "%~dp0"
cd "%~dp0payloads"
powershell -command "start-transcript -path "%adobeworkfolder%\compresspayloads.txt"; get-childitem -path "." -recurse -directory -depth 1 | foreach-object { Write-Host $_.FullName }; stop-transcript"
echo "Remove all lines but file/folder paths, remove main folders, remove all things before packages and payloads that not including \ before on packages and payloads folder, copy first line to one below to avoid an anomaly and save it."
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
echo "==> Restoring C:\Program Files (x86)\Common Files\Adobe\OOBE Folder ..."
move "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD" "C:\Program Files (x86)\Common Files\Adobe\OOBE.ORG"
rd "C:\Program Files (x86)\Common Files\Adobe\OOBE" /s /q
move "C:\Program Files (x86)\Common Files\Adobe\OOBE.ORG" "C:\Program Files (x86)\Common Files\Adobe\OOBE"
pause