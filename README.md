# Adobe Repacker and Installer Script - RIBS for Windows (for CS5 - CC 2015)
A .bat script that compresses unpacked Adobe RIBS assets and installs them.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## Credits
- Me for writing script.
- Adobe Systems Incorporated for providing applications.
- PainteR for providing patched binaries for installing unpacked Adobe RIBS-based applications.

## What does this script do?
This script compresses all unpacked assets that present on "payloads" and "packages" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets excluded via excludepackages.txt and excludepayloads.txt that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

## Requirements
- On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip". But you can edit install.bat to change 7-Zip's location currently. I may update script to detect 7-Zip's install location by reading registry.
- Latest PowerShell for Windows XP(/x64)/Server 2003(/R2)(/x64)/Vista(/x64)/Server 2008/(/x64). Windows 7 and above comes with PowerShell by default.

## Limitations
- ZIP file must not exceed 2 GB. I tested this with HyperDrive installer engine and it throwed error. But I didn't tested this with RIBS engine. May it supports 2 GB+ files or not. Proceed with caution.
- If original Adobe CC 2015 application is installed with original RIBS engine, use install-admin-existing.bat. You need to run this file as administrator for temporarily replacing OOBE folder on C:\Program Files\Common Files\Adobe. This folder is where the installer engine is. If no Adobe application was installed before, use install-fresh.bat. You can run this file as normal user.

## Special note
- Unlike HyperDrive-based installers, with patched AdobePIM.dll, *.pima archives under "packages" folder can be repacked on CS6 - CC 2015 installer engines.
  - With original AdobePIM.dll and repacked *.pima archive, it throws error Adobe Genuine Software Validation Failure on initializing setup phase.
  
    ![image](https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/assets/44976117/819a77cd-75ae-4e10-8d6b-568375aa6200)
  - You'll need packages, resources folder and Setup.exe (rename this file later as Set-up.exe, only on d!akov packages.) file from one of the RIBS-based d!akov or m0nkrus (On m0nkrus, take Set-up.exe, this will be same name like original installer unlike d!akov repacks, that has Setup.exe instead of Set-up.exe.). Unfortunately, this is the currently only way to install repacked RIBS assets. Original RIBS install engine throws error about software may counterfeit. Do not take "payloads" folder from d!akov repack because it contains pirated application. But we need the only install engine of d!akov to install our repacked assets.
    - You can manually patch legit Adobe RIBS installer by replacing this files from d!akov or m0nkrus distributions on RIBS-based legit installer engine:
      - CC 2014-era
        | Binary Version | Binary Path | Binary Purpose |
        | :-: | :-: | :-: |
        | version 8.0.0.15 | packages\DECore\DECore.pima\DE6\Setup.dll | Allows repacked asset archives to be installed. |
        | version 8.0.0.14 | packages\UWA\UWA.pima\updatercore.dll | Allows installing subscription updates on perpetual packages or vice versa. |
        | version 8.0.0.73 | resources\AdobePIM.dll | Allows repacked *.pima archives from packages folder to be loaded. |
      - CC 2013-era
        | Binary Version | Binary Path | Binary Purpose |
        | :-: | :-: | :-: |
        | version 7.0.0.103 | packages\DECore\DECore.pima\DE6\Setup.dll | Allows repacked asset archives to be installed. |
        | version 7.0.0.27 (from slightly older engine) | packages\UWA\UWA.pima\updatercore.dll | Allows installing subscription updates on perpetual packages or vice versa. |
        | version 7.0.0.324 | resources\AdobePIM.dll | Allows repacked *.pima archives from packages folder to be loaded. | 
        - When you try to replace these files with higher version on lower version RIBS engines, installation gives almost instant error and when you open summary.html or htm that installer generated, there is only System Requirements wrote as a link.
        - For Creative Cloud Packager, only replacing AdobePIM.dll on resources folder is enough and it doesn't throw any error. Replacing Setup.dll and updatercore.dll isn't necessary.
        - If \payloads\Media_db.db\PayloadData\ *(any payload id that has higher version than **8.0.0.15** on **value** column)* \PayloadInfo is greater than 8.0.0.15, installer throws this error on logs in example for SpeedGrade CC 2015 with 8.x.x.x engine:
          - *ERROR: DW021: Payload {8FD7F1DB-7355-469E-A3F2-2118148D8477} DVA Adobe SpeedGrade CC 2015 9.0.0.0 of version: 9.0.0.6 is not supported by this version: 8.0.0.15 of RIBS.*

            ![image](https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/assets/44976117/af3aecbf-3c58-46e4-add8-8e601240010e)
            - This can be fixed with SQLite DB Browser.
              - Download this program from https://sqlitebrowser.org/dl/
                - Or if that page isn't available, but direct links are accessible:
                  | Version, Platform & Install Method | Link | Wayback Machine Link
                  | :-: | :-: | :-: |
                  | 3.12.2 Windows 32-bit MSI Installer | https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.msi | https://web.archive.org/web/20240308102559/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.msi |
                  | 3.12.2 Windows 32-bit Portable | https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.zip | https://web.archive.org/web/20240308102755/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.zip |
                  | 3.12.2 Windows 64-bit MSI Installer | https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.msi | https://web.archive.org/web/20240308102852/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.msi |
                  | 3.12.2 Windows 64-bit Portable | https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.zip | https://web.archive.org/web/20240308103002/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.zip |
                  | 3.12.2 macOS Intel | https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2.dmg | https://web.archive.org/web/20240308103609/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2.dmg |
                  | 3.12.2 macOS Apple Silicon | https://download.sqlitebrowser.org/DB.Browser.for.SQLite-arm64-3.12.2.dmg | https://web.archive.org/web/20240308104038/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-arm64-3.12.2.dmg |
              - Install SQLite Browser or directly open SQLite Browser if you downloaded portable version.
              - Open **(InstallMediaRoot)**\payloads\Media_db.db.
              - While payloads\Media_db.db is opened, go to "Execute SQL" tab.
                - You only need to patch payloads\Media_db.db to install application successfully. You don't need to patch Media_db.db inside \payloads\ * (i.e. AdobeBridge5-mul).
              - Than paste these 2 commands to separate lines:
                - update PayloadData **(do not execute command here.)**
                - set Value = replace(value, '9.0.0.6', '8.0.0.15') **(execute command here.)**
              - This will replace any 9.0.0.6 with 8.0.0.15. You may change these versions depending on product you're gonna installing.
                - In example, you must replace 9.0.0.6 with 9.0.0.7 on Adobe Photoshop CC 2015.
            - Or you can replace installer engine with patched and newer version from following this guide on https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/blob/RIBS-win-patchedbins/README.md#special-note
              - With this, you don't need to edit Media_db.db to allow lower versions of RIBS to install higher version packages.
      - Or to manually patch these Adobe DLL's, view special note section of https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/blob/RIBS-win-patchedbins/README.md#special-note
  - CS5.5 and CS5 do not require patching AdobePIM.dll to install repacked assets. Also, *.pima archives under "packages" directory can be repacked on CS5.5 and CS5 installers with original AdobePIM.dll. Because CS5.5 and below RIBS installer engines doesn't have file verification.
    - But some packages will be protected and they cannot be unpacked via 7-Zip. These packages will prompt for password if they tried to unpacked. Only RIBS installer engine can unpack these packages.
      - These packages are:
        - Creative Suite 5.5 (CS5.5)
          - AdobeAfterEffects10.5ProtectedAll
          - AdobeOnLocation5.1ProtectedAll
        - Creative Suite 5 (CS5)
          - AdobeAfterEffects10ProtectedAll
          - AdobeAfterEffects10RoyaltyAll
          - AdobeEncore5RoyaltyAll
          - AdobeOnLocation5ProtectedAll
          - AdobeOnLocation5RoyaltyAll
          - AdobePremierePro5ProtectedAll
          - AdobePremierePro5RoyaltyAll
          - AdobeSoundbooth3ProtectedAll
          - AdobeSoundbooth3RoyaltyAll
          - AMEDolby5All
          - AMEDolby5All_x64
          - AMEPCI5All
          - AMEPCI5All_x64
        - Miscellaneous
          - AdobePresenter706-AS_PC-mul (from Adobe Acrobat X Suite, I don't know other suite's reaction.)
  - Despite with patched AdobePIM.dll that *.pima archives can be unpacked, minimal package set for just installing application with unpatched AdobePIM.dll and legit packed RIBS installer engine is this package set (with pirating, unfortunately (This package set gives error about Adobe Application Manager when application launches. If application is pirated, when you click OK, application will start with no problem.).):
    - core
    - D6
    - DECore
    - UWA
    - But if you want to use your legit license, it's all packages above with that extra package:
      - P6
- CS4 and CS3 doesn't require this script. Payloads stored as MSI installer and no verification is present except for protected ones (?). If installer assets unpacked via "msiexec /a" and replacing packed assets with unpacked ones, installer will install our unpacked assets with an honor.

## About MSI-based RIBS Applications
- On very big suites that contains small files or lots of files like Master Collection when MSI packages unpacked, initialization phase takes about like 10 minutes to 1 hour or longer depending on selected suite and hardware of PC that suite is going to be installed due to count of files (i.e. ~150K files alone in LS1 language group of Master Collection CS4).
  - For me, my system with these specs below, CS4 Design Premium LS1 (~110K files) took ~30 minutes to complete initialization phase:
    - CPU: Intel Core i5-3570 @ 3.40GHz (3.80GHz /w Turbo Boost)
    - RAM: 16GB (2x8GB) DDR3-1333MHz
    - MOBO: ZX-H61C/B75 V2.3
    - HDDOS: WDC WD10EZEX-08WN4A0
    - HDDInstallMedia: Same as HDDOS
  - For big packages like Master Collection, I suggest to put their install medium to very fast medium like SSD's if you can.
  - After that, installation takes much, much less time.
- MSI-based assets need to be unpacked with *.mst file if it exists.
  - This is also valid for Adobe Acrobat installers.
  - To do this, run:
    - msiexec /a X:\path\to\MSI\file.msi /qb targetdir=X:\path\to\expand transforms=X:\transform\file.mst
      - If you don't, some apps may say "source file not found" if app is tried to installed in languages other than English.
      - This may also fix bunch of CS3 packages.
- CS4 and CS3's protected content can be unpacked unlike in CS5 and above, but some packages will throw error on initialization phase. If you look installer logs, you will see i.e. AdobeAfterEffects9ProtectedAll was failed error 1603. I think it's also valid for CS3.
  - When protected MSI is unpacked, it writes 16 bytes to every file.
    - But if protected packages are installed, they shrunk 16 bytes exactly and they're accessible normally again.
      - I think that 16 bytes is for protecting that file (maybe some sort of encrypted header or something).
  - Interestingly on my tests with CS4, if protected content's payload path is beyond MAX_PATH variable, initialization phase is continued like nothing happened. But installer will fail gradually when installer tries to install protected unpacked content on specific packages. My theory was installer engine is so old that skips paths that beyond MAX_PATH limit on initialization phase. But on installation phase, it doesn't and it will fail.
    - Currently not unpackable assets are:
      - Creative Suite 4 (CS4)
        | Package Name | Caused error | Note | Fix |
        | :-: | :-: | :-: | :-: |
        | AdobeAfterEffects9All | On Master Collection, Production Premium and probably on other suites, this package fails and gives permission error about AdobeAfterEffects9ProtectedAll directory inside of unpacked After Effects assets and throws error 1310 (Error writing to file: C:\Program Files (x86)\Common Files\Adobe\Installers\b2d6abde968e6f277ddbfd501383e02\payloads\AdobeAfterEffects9All\program files\Adobe\Adobe After Effects CS4\Support Files\(PCI)\Setup\payloads\AdobeAfterEffects9ProtectedAll\AdobeAfterEffects9ProtectedAll.proxy.xml. Verify that you have access to that directory.) and error 1603 on logs. | | |
        | AdobeAfterEffects9FCAll | Unpacked version prevents installation phase to be completed and it throws error 1603 on log (Fatal error occured during installation). | | |
        | AdobeAfterEffects9ProtectedAll | Package normally unpackable, but it throws error 1603 while initialization phase. Not on standalone program, but on Master Collection and likely on other suites that contains this package, throws error 1304 about copying file. Even if you try to click "Retry", it throws internal error 2350 and unpack fails. | | |
        | AdobeCaptivate4* | Installation fails with error 1603. | | |
        | AdobeContribute-PDistiller-mul\de_DE | Throws error 2715 on unpacking. | | See note below. | 
        | AdobeDirector11.5* | Package normally unpackable, but it throws error 1603 while initialization phase. | | |
        | AdobeVersionCue4All | Package normally unpackable, but it throws error 1603 (Fatal error occured during installation) on log while initialization phase. | | |
        | MSXML6.0 | Normally it's unpackable, but due to conflict between x64 and ia64, I not prefer unpack this payload folder. If you try to separate folder into individual payloads, at initialization phase, nothing happens and installation not starts due to payload ID conflict I guess. | | See note below. |

        For `` AdobeContribute-PDistiller-mul\de_DE ``:
        - You can fix this with Orca MSI Editor.
          - Download Orca MSI editor from https://www.technipages.com/downloads/OrcaMSI.zip
            - If it's deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308101549/https://www.technipages.com/downloads/OrcaMSI.zip
          - On Orca, search Docs_DistillerS_DEU on Components table.
          - When found, replace ACROHELP.DISTS_DEU with ACROHELP_DISTS_DEU.pdf.
          - On unpacked directory, perform replace operation exact opposite directory.
        - This also happens in CS6 packages that contains this package (also de-DE language).
        
        For `` MSXML6.0 ``:
        - You can rename DLL files by adding their architectures to end.
          - In example, msxml6.ia64.dll for IA-64 version of Microsoft XML Parser.
      - Creative Suite 3 (CS3)
        | Package Name | Caused error | Note | Fix |
        | :-: | :-: | :-: | :-: |
        | AdobeAfterEffects8All | Normally unpackable but this package fails and gives permission error about AdobeAfterEffects8ProtectedAll directory inside of unpacked After Effects assets (Error 1310. Error writing to file: C:\Program Files (x86)\Common Files\Adobe\Installers\5d83aea83f5009a0d267d337e3f55fe\payloads\AdobeAfterEffects8All\program files\Adobe\Adobe After Effects CS3\Support Files\(PCI)\Setup\payloads\AdobeAfterEffects8ProtectedAll\AdobeAfterEffects8ProtectedAll.proxy.xml. Verify that you have access to that directory.) and throws error 1603 on logs. | | |
        | AdobeAfterEffects8FCAll | Unpacked version prevents installation phase to be completed and it throws error 1603 (Fatal error during installation) on logs. | | |
        | AdobeAfterEffects8ProtectedAll | Throws error 1304 about copying file. Even if you try to click "Retry", it throws error 2350 and unpack fails. | Even if you somehow unpack this package, it throws error code 1603 on log. | |
        | AdobePremierePro3All | Installation fails with error 1603. | It may caused from not unpacking .msi file without .mst transform. I will update here if it's true. | |
        | AdobePhotoshop10* | Installation fails with error 1603. | It may caused from not unpacking .msi file without .mst transform. I will update here if it's true. | |
        | AdobeIllustrator13* | Installation fails with error 1603. | It may caused from not unpacking .msi file without .mst transform. I will update here if it's true. | |
        | AdobeInDesign5* | Installation fails with error 1603. | It may caused from not unpacking .msi file without .mst transform. I will update here if it's true. | |
        | AdobeInCopy5* | Installation fails with error 1603. | It may caused from not unpacking .msi file without .mst transform. I will update here if it's true. | |
        | AdobeEncore3All | Installation fails with error 1603. | It may caused from not unpacking .msi file without .mst transform. I will update here if it's true. | |
        | AdobeSoundboothAll | Installation fails with error 1603 on Master Collection. | I don't have standalone product to test standalone product's reaction :(( (If somebody have standalone Adobe Soundbooth CS3 installer, you can write me :)) ) | |
        - But some CS3 main packs can be unpacked. These are:
          | Package Name | Note |
          | :-: | :-: |
          | AdobeDreamweaver9* | |
          | AdobeFlash9* | |
          | AdobeFireworks9* | |
          | AdobeIllustrator13* | Only on Master Collection. |
          | AdobeInDesign5* | Only on Master Collection. |
          | AdobePhotoshop10* | Only on Master Collection. |
          | AdobeContribute4.1* | On Adobe Acrobat Pro 8 (in suites), they may say **C:\program files\Adobe\Acrobat 8.0\Acrobat\Xtras\AdobePDF\I386\ADOBEPDF.DLL** is missing during install. Specifying **\payloads\AdobeAcrobat8de_DE\program files\Adobe\Acrobat 8.0\Acrobat\Xtras\AdobePDF\I386\ADOBEPDF.DLL** will solves this. |
