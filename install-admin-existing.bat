@echo off
rem #####################
rem # Preparation Phase #
rem #####################
cd %~dp0
echo "==> Setting Variables ..."
set adobetempinstaller=%systemdrive%\adobetempinstaller
set excludefolder=%systemdrive%\excludefolder
echo "==> Deleting Previously Failed Instance ..."
rd %excludefolder% /s /q
rd %adobetempinstaller% /s /q
echo "==> Creating Directories ..."
mkdir %excludefolder%
mkdir %adobetempinstaller%
mkdir %adobetempinstaller%\packages
cd "%~dp0packages"
for /d %%a in ("*") do mkdir "%adobetempinstaller%\packages\%%a"
cd "%~dp0"
mkdir %adobetempinstaller%\payloads
cd "%~dp0payloads"
for /d %%b in ("*") do mkdir "%adobetempinstaller%\payloads\%%b"
cd "%~dp0"
echo "==> Copying Exclusion File ..."
copy "%~dp0exclude.txt" "%excludefolder%\exclude.txt"
echo "==> Renaming C:\Program Files (x86)\Common Files\Adobe\OOBE Folder ..."
move "C:\Program Files (x86)\Common Files\Adobe\OOBE" "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD"
rem #####################
rem # Compression Phase #
rem #####################
echo "==> Compressing Unpacked Products ..."
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\CCM\CCM.pima" -mx5 -r "%~dp0\packages\CCM\CCM\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\core\PDApp.pima" -mx5 -r "%~dp0\packages\core\PDApp\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\D6\D6.pima" -mx5 -r "%~dp0\packages\D6\D6\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\DECore\DECore.pima" -mx5 -r "%~dp0\packages\DECore\DECore\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\DWA\DWA.pima" -mx5 -r "%~dp0\packages\DWA\DWA\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\IPC\IPC.pima" -mx5 -r "%~dp0\packages\IPC\IPC\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\LWA\LWA.pima" -mx5 -r "%~dp0\packages\LWA\LWA\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\P6\P6.pima" -mx5 -r "%~dp0\packages\P6\P6\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\P7\P7.pima" -mx5 -r "%~dp0\packages\P7\P7\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\packages\UWA\UWA.pima" -mx5 -r "%~dp0\packages\UWA\UWA\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9AllTrial\Assets1_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9AllTrial\Assets1_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9AllTrial\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9AllTrial\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9de_DELanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9de_DELanguagePack\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9en_USLanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9en_USLanguagePack\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9es_ESLanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9es_ESLanguagePack\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9fr_FRLanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9fr_FRLanguagePack\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9it_ITLanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9it_ITLanguagePack\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9ja_JPLanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9ja_JPLanguagePack\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9pt_BRLanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9pt_BRLanguagePack\Assets2_1\*"
"c:\program files\7-zip\7z" a -bd -tzip "%adobetempinstaller%\payloads\AdobeSpeedGrade9ru_RULanguagePack\Assets2_1.zip" -mx5 -r "%~dp0payloads\AdobeSpeedGrade9ru_RULanguagePack\Assets2_1\*"
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
echo "==> Waiting For Installation To Be Completed ..."
echo "After installation completed, press any key ..."
pause
rem ##################
rem # Clean-up Phase #
rem ##################
echo "==> Cleaning Up ..."
rd %adobetempinstaller% /s /q
rd %excludefolder% /s /q
echo "==> Restoring C:\Program Files (x86)\Common Files\Adobe\OOBE Folder ..."
move "C:\Program Files (x86)\Common Files\Adobe\OOBE.OLD" "C:\Program Files (x86)\Common Files\Adobe\OOBE.ORG"
rd "C:\Program Files (x86)\Common Files\Adobe\OOBE" /s /q
move "C:\Program Files (x86)\Common Files\Adobe\OOBE.ORG" "C:\Program Files (x86)\Common Files\Adobe\OOBE"
pause
