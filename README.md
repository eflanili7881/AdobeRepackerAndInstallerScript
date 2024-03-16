# Adobe Repacker and Installer Script - RIBS for Windows (for CS5 - CC 2015)
A .bat script that compresses unpacked Adobe RIBS assets and installs them.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## What does this script do?
This script compresses all unpacked assets that present on "payloads" and "packages" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets excluded via excludepackages.txt and excludepayloads.txt that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

## Special note
- Unlike HyperDrive-based installers, with patched AdobePIM.dll, *.pima archives under "packages" folder can be repacked. With original AdobePIM.dll and repacked *.pima archive, it throws error on initializing setup phase on very beginning about Adobe Genuine Software Verification failure.
  - You'll need packages, resources folder and Setup.exe (rename this file later as Set-up.exe, only on d!akov packages.) file from one of the RIBS-based d!akov or m0nkrus (On m0nkrus, take Set-up.exe, this will be same name like original installer unlike d!akov repacks, that has Setup.exe instead of Set-up.exe.). Unfortunately, this is the currently only way to install repacked RIBS assets. Original RIBS install engine throws error about software may counterfeit. Do not take "payloads" folder from d!akov repack because it contains pirated application. But we need the only install engine of d!akov to install our repacked assets.
    - You can manually patch legit Adobe RIBS installer by replacing this files from d!akov or m0nkrus distributions on RIBS-based legit installer engine:
      | Binary Version   | Binary Path                               | Binary Purpose                                                               |
      | :--------------: | :---------------------------------------: | :--------------------------------------------------------------------------: |
      | version 8.0.0.15 | packages\DECore\DECore.pima\DE6\Setup.dll | Allows custom asset archives to be installed.                                |
      | version 8.0.0.14 | packages\UWA\UWA.pima\updatercore.dll     | (?) Allows custom asset archives to be installed (only on updates, I guess). |
      | version 8.0.0.73 | resources\AdobePIM.dll                    | Allows repacked *.pima archives from packages folder to be loaded.           |
      - You can only manually patch 8.x.x.x (CC 2014 series) installer engine and above. 7.x.x.x (CC 2013) and below gives almost instant error and when you open summary.html or htm that installer generated, there is only System Requirements wrote as a link.
        - For Creative Cloud Packager, only replacing AdobePIM.dll on resources folder is enough and it doesn't throw any error. Replacing Setup.dll and updatercore.dll isn't necessary.
      - If \payloads\Media_db.db\PayloadData\ *(any payload id that has higher version than **8.0.0.15** on **value** column)* \PayloadInfo is greater than 8.0.0.15, installer throws this error on logs in example for SpeedGrade CC 2015 with 8.x.x.x engine:
        - *ERROR: DW021: Payload {8FD7F1DB-7355-469E-A3F2-2118148D8477} DVA Adobe SpeedGrade CC 2015 9.0.0.0 of version: 9.0.0.6 is not supported by this version: 8.0.0.15 of RIBS.*
          - This can be fixed with SQLite DB Browser.
            - Download this program from https://sqlitebrowser.org/dl/
              - Or if that page isn't available, but direct links are accessible:
                - Download version 3.12.2 Windows 32-bit MSI installer from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.msi .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308102559/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.msi
                - Download version 3.12.2 Windows 32-bit portable from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.zip .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308102755/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.zip
                - Download version 3.12.2 Windows 64-bit MSI installer from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.msi .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308102852/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.msi
                - Download version 3.12.2 Windows 64-bit portable from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.zip .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308103002/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.zip
                - Download version 3.12.2 macOS Intel from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2.dmg if Windows application isn't working.
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308103609/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2.dmg
                - Download version 3.12.2 macOS Apple Silicon from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-arm64-3.12.2.dmg if Windows application isn't working.
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308104038/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-arm64-3.12.2.dmg
            - While payloads\Media_db.db is opened, go to "Execute SQL" tab.
            - Than paste these 2 commands to separate lines:
              - update PayloadData **(do not execute command here.)**
              - set Value = replace(value, '9.0.0.6', '8.0.0.15') **(execute command here.)**
            - This will replace any 9.0.0.6 with 8.0.0.15. You may change these versions depending on product you're gonna installing.
  - CS5.5 and CS5 do not require patching AdobePIM.dll to install repacked assets. Also, *.pima archives under "packages" directory can be repacked on CS5.5 and CS5 installers with original AdobePIM.dll. Because CS5.5 and below RIBS installer engines doesn't have file verification.
    - But some packages will be protected and they cannot be unpacked via 7-Zip. These packages will prompt for password if they tried to unpacked. Only RIBS installer engine can unpack these packages.
      - These packages are:
        - AdobeAfterEffects10.5ProtectedAll
        - AdobeAfterEffects10ProtectedAll
        - AdobeAfterEffects10RoyaltyAll
        - AdobeEncore5RoyaltyAll
        - AdobeOnLocation5.1ProtectedAll
        - AdobeOnLocation5ProtectedAll
        - AdobeOnLocation5RoyaltyAll
        - AdobePresenter706-AS_PC-mul
        - AdobePremierePro5ProtectedAll
        - AdobePremierePro5RoyaltyAll
        - AdobeSoundbooth3ProtectedAll
        - AdobeSoundbooth3RoyaltyAll
        - AMEDolby5All
        - AMEDolby5All_x64
        - AMEPCI5All
        - AMEPCI5All_x64
  - Despite with patched AdobePIM.dll that *.pima archives can be unpacked, minimal package set for just installing application with legit RIBS installer engine is this (with pirating, unfortunately (This package set gives error about Adobe Application Manager when application launches. If application is pirated, when you click OK, application will start with no problem.).):
    - core
    - D6
    - DECore
    - UWA
    - But if you want to use your legit license, it's all packages above with that extra package:
      - P6
- CS4 and CS3 doesn't require this script. Payloads stored as MSI installer and no verification is present except for protected ones (?). If installer assets unpacked via "msiexec /a" and replacing packed assets with unpacked ones, installer will install our unpacked assets with an honor.

## Requirements
- On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip". But you can edit install.bat to change 7-Zip's location currently. I may update script to detect 7-Zip's install location by reading registry.
- Latest PowerShell for Windows XP(/x64)/Server 2003(/R2)(/x64)/Vista(/x64)/Server 2008/(/x64). Windows 7 and above comes with PowerShell by default.

## Limitations
- ZIP file must not exceed 2 GB. I tested this with HyperDrive installer engine and it throwed error. But I didn't tested this with RIBS engine. May it supports 2 GB+ files or not. Proceed with caution.
- If original Adobe CC 2015 application is installed with original RIBS engine, use install-admin-existing.bat. You need to run this file as administrator for temporarily replacing OOBE folder on C:\Program Files\Common Files\Adobe. This folder is where the installer engine is. If no Adobe application was installed before, use install-fresh.bat. You can run this file as normal user.

## About MSI-based RIBS Applications
- Not on standalone application, but on Master Collection and probably on other suites, from unpacked packages inside on Master Collection suite and others, initialization phase takes about like 10 minutes to 1 hour or longer depending on selected suite and hardware of PC that suite is going to be installed due to count of files (~150K files alone in LS1 language group of Master Collection CS4).
  - For big packages like Master Collection, I suggest to put their install medium to very fast medium like SSD's if you can.
  - After that, installation takes much, much less time.
- CS4 and CS3's protected content can be unpacked unlike in CS5 and above, but installer will throw error on initialization phase. If you look installer logs, you will see i.e. AdobeAfterEffects9ProtectedAll was failed error 1603. I think it's also valid for CS3.
  - Interestingly on my tests with CS4, if protected content's payload path is beyond MAX_PATH variable, initialization phase is continued like nothing happened. But installer will fail gradually when installer tries to install protected unpacked content. My theory was installer engine is so old that skips paths that beyond MAX_PATH limit on initialization phase, but on installation phase, it doesn't and it will fail.
  - With more interesting thing, above 2 statements, Adobe Premiere Pro CS4 was installed successfully, with unpacked protected contents. I think this problem was about invalid character problem that Adobe After Effects CS4 Protected Contents' unpacked assets path that contains or this problem was specifically for After Effects.
- Currently not unpackable assets are:
  - CS4
    - AdobeAfterEffects9ProtectedAll
      - Package normally unpackable, but it throws error 1603 while initialization phase.
      - Not on standalone program, but on Master Collection and likely on other suites that contains this package, throws error 1304 about copying file. Even if you try to click "Retry", it throws internal error 2350 and unpack fails.
        - When I installed After Effects CS4, I guess it's unpackable, but it writes ~~few extra~~ 16 bytes to every file and corrupts them.
          - It isn't about this. Other unpackable packages also has this symptom. But if they're installed, they shrunk 16 bytes exactly and they're accessible again.
            - I think that 16 bytes is for protecting that file.
    - AdobeAfterEffects9FCAll
      - Unpacked version prevents installation phase to be completed and it throws error 1603 on log (Fatal error occured during installation).
    - MSXML6.0
      - Normally it's unpackable, but due to conflict between x64 and ia64, I not prefer unpack this payload folder. If you try to separate folder into individual payloads, at initialization phase, nothing happens and installation not starts due to payload ID conflict I guess.
        - You can rename DLL files by adding their architectures to end.
          - In example, msxml6.ia64.dll for IA-64 version of Microsoft XML Parser. 
    - AdobeContribute-PDistiller-mul\de_DE
      - Throws error 2715 on unpacking.
        - You can fix this with Orca MSI Editor.
          - Download Orca MSI editor from https://www.technipages.com/downloads/OrcaMSI.zip
            - If it's deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308101549/https://www.technipages.com/downloads/OrcaMSI.zip
          - On Orca, search Docs_DistillerS_DEU on Components table.
          - When found, replace ACROHELP.DISTS_DEU with ACROHELP_DISTS_DEU.pdf.
          - On unpacked directory, perform replace operation exact opposite directory.
    - AdobeVersionCue4All
      - Package normally unpackable, but it throws error 1603 (Fatal error occured during installation) on log while initialization phase.
    - AdobeAfterEffects9All
      - On Master Collection and probably on other suites, this package fails and gives permission error about AdobeAfterEffects9ProtectedAll directory inside of unpacked After Effects assets and throws error 1310 (Error writing to file: C:\Program Files (x86)\Common Files\Adobe\Installers\b2d6abde968e6f277ddbfd501383e02\payloads\AdobeAfterEffects9All\program files\Adobe\Adobe After Effects CS4\Support Files\(PCI)\Setup\payloads\AdobeAfterEffects9ProtectedAll\AdobeAfterEffects9ProtectedAll.proxy.xml. Verify that you have access to that directory.) and error 1603 on logs.
    - AdobeCaptivate4*
      - Installation fails with error 1603.
    - AdobeDirector11.5*
      - Package normally unpackable, but it throws error 1603 while initialization phase.
  - CS3
    - AdobeAfterEffects8All
      - This package fails and gives permission error about AdobeAfterEffects8ProtectedAll directory inside of unpacked After Effects assets and throws error 1603 on logs.
    - AdobeAfterEffects8FCAll
      - Unpacked version prevents installation phase to be completed and it throws error.
    - AdobeAfterEffects8ProtectedAll
      - Throws error 1304 about copying file. Even if you try to click "Retry", it throws error 2350 and unpack fails.
    - AdobePremierePro3All
      - Installation fails with error 1603.
    - AdobePhotoshop10*
      - Installation fails with error 1603.
    - AdobeIllustrator13*
      - Installation fails with error 1603.
    - AdobeInDesign5*
      - Installation fails with error 1603.
    - AdobeInCopy5*
      - Installation fails with error 1603.
    - AdobeEncore3All
      - Installation fails with error 1603.
    - AdobeSoundboothAll
      - Installation fails with error 1603 on Master Collection. I don't have standalone product :(( (If somebody have standalone Adobe Soundbooth CS3 installer, you can write me :)) )
    - But some CS3 main packs can be unpacked. These are:
      - AdobeDreamweaver9*
      - AdobeFlash9*
      - AdobeFireworks9*
      - AdobeIllustrator13*
        - Only on Master Collection.
      - AdobeInDesign5*
        - Only on Master Collection.
      - AdobePhotoshop10*
        - Only on Master Collection.
      - AdobeContribute4.1*
        - On Adobe Acrobat Pro 8 (in suites), they may say C:\program files\Adobe\Acrobat 8.0\Acrobat\Xtras\AdobePDF\I386\ADOBEPDF.DLL says missing during install. Specifying \payloads\AdobeAcrobat8de_DE\program files\Adobe\Acrobat 8.0\Acrobat\Xtras\AdobePDF\I386\ADOBEPDF.DLL will solves this.
