@echo off

rem #####################
rem # Preparation Phase #
rem #####################
title Adobe Repacker and Installer Script v0.4.0-hd-win rc2
goto menu

:menu
echo ============================================================Menu========================================================
echo =                                                                                                                      =
echo =    1) Start Install                                                                                                  =
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
    call :compressPackages
    call :copyOtherInstallerFiles
    call :installACC
    call :installHyperDrive
    call :cleanUp
    call :menu
)

if /i %decisionMenu%==x (
    call :exit
)

:setvar
cls
echo "==> Setting Variables ..."
echo "Enter Adobe installer directory that contains packages and products folder:"
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
echo "==> Entering install media ..."
cd "%source_directory%"
exit /b

:cleanWorkspace
echo "==> Deleting Previously Failed Instance ..."
rd "%adobeworkfolder%" /s /q
rd "%adobetempinstaller%" /s /q
exit /b

:createDir
echo "==> Creating Directories ..."
mkdir %adobeworkfolder%
mkdir %adobetempinstaller%
mkdir %adobetempinstaller%\packages
mkdir %adobetempinstaller%\products
cd "%source_directory%\packages"
for /d %%a in ("*") do mkdir "%adobetempinstaller%\packages\%%a"
cd "%source_directory%\products"
for /d %%b in ("*") do mkdir "%adobetempinstaller%\products\%%b"
cd "%source_directory%"
exit /b

:createTextFiles
echo "==> Creating Exclusion & Compression Text Files ..."
cd /d "%source_directory%\packages"
for /d %%c in ("*") do for /d %%d in ("%%c\*") do for /d %%e in ("%%d\*") do @echo %%~fe >> "%adobeworkfolder%\excludepackages.txt"
cd /d "%source_directory%\products"
for /d %%f in ("*") do for /d %%g in ("%%f\*") do @echo %%~fg >> "%adobeworkfolder%\excludeproducts.txt"
cd /d "%source_directory%\packages"
for /d %%h in ("*") do for /d %%i in ("%%h\*") do for /d %%j in ("%%i\*") do @echo %%~fj >> "%adobeworkfolder%\compresspackages.txt"
cd /d "%source_directory%\products"
for /d %%k in ("*") do for /d %%l in ("%%k\*") do @echo %%~fl >> "%adobeworkfolder%\compressproducts.txt"
cls
exit /b

:editRequiredFiles
echo "==> Editing Required Files ..."
echo "+ On exclusion files:"
echo "- Remove all things before packages and payloads that not including \ before on packages and payloads folder."
echo "- Remove all folder paths that came from unpacked Adobe Acrobat MSI installer or Adobe InDesign's OEM_ folder."
echo "- Replace <spaceCharacter> with \."
echo "- Each line should like this:"
echo "-- \packages\ACCC64\ACCC64\"
echo "-- \products\AdobePrelude5AllTrial\AdobePrelude5AllTrial\"
echo "I"
echo "+ On compression files:"
echo "- Remove all things before packages and payloads that not including \ before on packages and payloads folder."
echo "- Replace <spaceCharacter> with <nothing> to remove spaces end of folder paths."
echo "- Each line should like this:"
echo "-- \packages\ACCC64\ACCC64"
echo "-- \products\AdobePrelude5AllTrial\AdobePrelude5AllTrial"
explorer "%adobeworkfolder%"
pause
exit /b

rem #####################
rem # Compression Phase #
rem #####################

:compressPackages
echo "==> Compressing Unpacked Products ..."
for /f "usebackq delims=" %%k in ("%adobeworkfolder%\compresspackages.txt") do "C:\Program Files\7-Zip\7z.exe" a -bd -tzip "%adobetempinstaller%%%k.pima" -mx%compression_level% -r "%source_directory%%%k\*"
for /f "usebackq delims=" %%l in ("%adobeworkfolder%\compressproducts.txt") do "C:\Program Files\7-Zip\7z.exe" a -bd -tzip "%adobetempinstaller%%%l.zip" -mx%compression_level% -r "%source_directory%%%l\*"
exit /b

rem ###########################
rem # Copying Installer Phase #
rem ###########################

:copyOtherInstallerFiles
echo "==> Copying Other Installer Files ..."
xcopy /q /e /h "%source_directory%\*" "%adobetempinstaller%" /exclude:%adobeworkfolder%\excludepackages.txt+%adobeworkfolder%\excludeproducts.txt
exit /b

rem ######################
rem # Installation Phase #
rem ######################

:installACC
echo "==> Installing Adobe Creative Cloud ..."
copy "%adobetempinstaller%\resources\AdobePIM_patched.dll" "%adobetempinstaller%\resources\AdobePIM.dll"
call "%adobetempinstaller%\Set-up_CC.exe"
echo "==> Waiting For Installation To Be Completed ..."
echo "After installation completed, press any key ..."
pause
exit /b

:installHyperDrive
echo "==> Installing Adobe Product ..."
del "%adobetempinstaller%\resources\AdobePIM.dll" /q
copy "%adobetempinstaller%\resources\AdobePIM_original.dll" "%adobetempinstaller%\resources\AdobePIM.dll"
call "%adobetempinstaller%\Set-up_HD.exe"
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

:exit
exit
