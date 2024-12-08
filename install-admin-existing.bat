@echo off
rem #####################
rem # Preparation Phase #
rem #####################
echo "==> Adobe Repacker and Installer Script v0.3.0-ribs-win rc - for existing installs"

echo "==> Setting Variables ..."
echo "Enter Adobe installer directory that contains packages and payloads folder:"
set /p source_directory=
echo "Enter 7-Zip Console binary path:"
set /p sevenzip_bin=
set adobetempinstaller=%userprofile%\adobetempinstaller
set adobeworkfolder=%userprofile%\adobeworkfolder
cd /d "%source_directory%"

echo "==> Deleting Previously Failed Instance ..."
rd "%adobeworkfolder%" /s /q
rd "%adobetempinstaller%" /s /q

echo "==> Creating Directories ..."
mkdir "%adobeworkfolder%"
mkdir "%adobetempinstaller%"
mkdir "%adobetempinstaller%\packages"
cd /d "%source_directory%\packages"
for /d %%a in ("*") do mkdir "%adobetempinstaller%\packages\%%a"
mkdir "%adobetempinstaller%\payloads"
cd /d "%source_directory%\payloads"
for /d %%b in ("*") do mkdir "%adobetempinstaller%\payloads\%%b"

echo "==> Creating Exclusion Files ..."
cd /d "%source_directory%\packages"
for /d %%c in ("*") do for /d %%d in ("%%c\*") do @echo %%~fd >> "%adobeworkfolder%\excludepackages.txt"
cd /d "%source_directory%\payloads"
for /d %%e in ("*") do for /d %%f in ("%%e\*") do @echo %%~ff >> "%adobeworkfolder%\excludepayloads.txt"

echo "==> Renaming C:\Program Files (x86)\Common Files\Adobe\OOBE Folder ..."
move "C:\Program Files (x86)\Common Files\Adobe\OOBE" "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD"
rem #####################
rem # Compression Phase #
rem #####################

echo "==> Creating Compression Files ..."
cd /d "%source_directory%\packages"
for /d %%g in ("*") do for /d %%h in ("%%g\*") do @echo %%~fh >> "%adobeworkfolder%\compresspackages.txt"
cd /d "%source_directory%\payloads"
for /d %%i in ("*") do for /d %%j in ("%%i\*") do @echo %%~fj >> "%adobeworkfolder%\compresspayloads.txt"
cls

echo "==> Editing Required Files ..."
echo "+ On exclusion files:"
echo "- Remove all things before packages and payloads that not including \ before on packages and payloads folder."
echo "- Remove all folder paths that came from unpacked Adobe Acrobat MSI installer or Adobe InDesign's OEM_ folder."
echo "- Replace <spaceCharacter> with \."
echo "- Each line should like this:"
echo "-- \packages\CCM\CCM\"
echo "-- \payloads\AdobeSpeedGrade9AllTrial\Assets1_1\"
echo "I"
echo "+ On compression files:"
echo "- Remove all things before packages and payloads that not including \ before on packages and payloads folder."
echo "- Replace <spaceCharacter> with <nothing> to remove spaces end of folder paths."
echo "- Each line should like this:"
echo "-- \packages\CCM\CCM"
echo "-- \payloads\AdobeSpeedGrade9AllTrial\Assets1_1"
explorer "%adobeworkfolder%"
pause

echo "==> Compressing Unpacked Products ..."
for /f "usebackq delims=" %%k in ("%adobeworkfolder%\compresspackages.txt") do "%sevenzip_bin%" a -bd -tzip "%adobetempinstaller%%%k.pima" -mx5 -r "%source_directory%%%k\*"
for /f "usebackq delims=" %%l in ("%adobeworkfolder%\compresspayloads.txt") do "%sevenzip_bin%" a -bd -tzip "%adobetempinstaller%%%l.zip" -mx5 -r "%source_directory%%%l\*"
rem ###########################
rem # Copying Installer Phase #
rem ###########################

echo "==> Copying Installer ..."
xcopy /q /e /h "%source_directory%\*" "%adobetempinstaller%" /exclude:%adobeworkfolder%\excludepackages.txt+%adobeworkfolder%\excludepayloads.txt
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
rd "C:\Program Files (x86)\Common Files\Adobe\OOBE" /s /q
move "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD" "C:\Program Files (x86)\Common Files\Adobe\OOBE"
pause
