@echo off

rem #####################
rem # Preparation Phase #
rem #####################

title Adobe Repacker and Installer Script v0.4.0-ribs-win rc2
goto menu

:menu
cls
echo ============================================================Menu========================================================
echo =                                                                                                                      =
echo =    1) Start Install (existing OOBE folder, administrator privileges required.)                                       =
echo =    2) Start Install (without existing OOBE folder)                                                                   =
echo =    x) Exit                                                                                                           =
echo =                                                                                                                      =
echo ========================================================================================================================

set /p decisionMenu=Enter your decision: 

if %decisionMenu%==1 (
    call :setvar
    call :cdInstMed
    call :cleanWorkspace
    call :createDir
    call :createTextFiles
    call :editRequiredFiles
    call :moveOOBEFolder
    call :compressPackages
    call :copyOtherInstallerFiles
    call :installRIBS
    call :cleanUp
    call :moveBackupOOBEFolder
    call :menu
)

if %decisionMenu%==2 (
    call :setvar
    call :cdInstMed
    call :cleanWorkspace
    call :createDir
    call :createTextFiles
    call :editRequiredFiles
    call :compressPackages
    call :copyOtherInstallerFiles
    call :installRIBS
    call :cleanUp
    call :menu
)

if /i %decisionMenu%==x (
    call :exit
)

:setvar
cls
echo "==> Setting Variables ..."
echo "Enter Adobe installer directory that contains packages and payloads folder:"
set /p source_directory=
echo "Enter 7-Zip Console binary path:"
set /p sevenzip_bin=
echo "Enter compression ratio for archive files between 0 and 9"
echo "0 (store only) ==> 9 (ultra compression)"
set /p compression_level=
set adobetempinstaller=%userprofile%\adobetempinstaller
set adobeworkfolder=%userprofile%\adobeworkfolder
exit /b

:cdInstMed
cd /d "%source_directory%"
exit /b

:cleanWorkspace
echo "==> Deleting Previously Failed Instance ..."
rd "%adobeworkfolder%" /s /q
rd "%adobetempinstaller%" /s /q
exit /b

:createDir
echo "==> Creating Directories ..."
mkdir "%adobeworkfolder%"
mkdir "%adobetempinstaller%"
mkdir "%adobetempinstaller%\packages"
cd /d "%source_directory%\packages"
for /d %%a in ("*") do mkdir "%adobetempinstaller%\packages\%%a"
mkdir "%adobetempinstaller%\payloads"
cd /d "%source_directory%\payloads"
for /d %%b in ("*") do mkdir "%adobetempinstaller%\payloads\%%b"
exit /b

:createTextFiles
echo "==> Creating Exclusion & Compression Text Files ..."
cd /d "%source_directory%\packages"
for /d %%c in ("*") do for /d %%d in ("%%c\*") do @echo %%~fd >> "%adobeworkfolder%\excludepackages.txt"
cd /d "%source_directory%\payloads"
for /d %%e in ("*") do for /d %%f in ("%%e\*") do @echo %%~ff >> "%adobeworkfolder%\excludepayloads.txt"
cd /d "%source_directory%\packages"
for /d %%g in ("*") do for /d %%h in ("%%g\*") do @echo %%~fh >> "%adobeworkfolder%\compresspackages.txt"
cd /d "%source_directory%\payloads"
for /d %%i in ("*") do for /d %%j in ("%%i\*") do @echo %%~fj >> "%adobeworkfolder%\compresspayloads.txt"
cls
exit /b

:editRequiredFiles
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
exit /b

:moveOOBEFolder
echo "==> Renaming C:\Program Files (x86)\Common Files\Adobe\OOBE Folder ..."
move "C:\Program Files (x86)\Common Files\Adobe\OOBE" "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD"
exit /b

rem #########################
rem # Preparing Files Phase #
rem #########################

:compressPackages
echo "==> Compressing Unpacked Products ..."
for /f "usebackq delims=" %%k in ("%adobeworkfolder%\compresspackages.txt") do "%sevenzip_bin%" a -bd -tzip "%adobetempinstaller%%%k.pima" -mx%compression_level% -r "%source_directory%%%k\*"
for /f "usebackq delims=" %%l in ("%adobeworkfolder%\compresspayloads.txt") do "%sevenzip_bin%" a -bd -tzip "%adobetempinstaller%%%l.zip" -mx%compression_level% -r "%source_directory%%%l\*"
exit /b

:copyOtherInstallerFiles
echo "==> Copying Installer ..."
xcopy /q /e /h "%source_directory%\*" "%adobetempinstaller%" /exclude:%adobeworkfolder%\excludepackages.txt+%adobeworkfolder%\excludepayloads.txt
exit /b

rem ######################
rem # Installation Phase #
rem ######################

:installRIBS
echo "==> Installing Product ..."
call "%adobetempinstaller%\Set-up.exe"
echo "==> Waiting For Installation To Be Completed ..."
echo "After installation completed, press any key ..."
pause
exit /b

rem ##################
rem # Clean-up Phase #
rem ##################

:cleanUp
echo "==> Cleaning Up ..."
rd %adobetempinstaller% /s /q
rd %adobeworkfolder% /s /q
exit /b

:moveBackupOOBEFolder
echo "==> Restoring C:\Program Files (x86)\Common Files\Adobe\OOBE Folder ..."
rd "C:\Program Files (x86)\Common Files\Adobe\OOBE" /s /q
move "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD" "C:\Program Files (x86)\Common Files\Adobe\OOBE"
pause
exit /b

:exit
exit
