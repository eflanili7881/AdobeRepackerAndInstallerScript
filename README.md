# Adobe Repacker and Installer Script - RIBS (for CS5 - CC 2015)
A .bat script that compresses unpacked Adobe RIBS assets and installs them.
 
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## Special note
- You'll need packages, resources folder and Setup.exe (rename this file later as Set-up.exe) file from one of the d!akov repacks for CS6 to CC 2015 installers. Unfortunately, this is the currently only way to install repacked RIBS assets. Original RIBS install engine throws error about software may counterfeit. Do not take "payloads" folder from d!akov repack because it contains pirated application. But we need the only install engine of d!akov to install our repacked assets.
- Unlike HyperDrive-based installers, with d!akov install engine, *.pima archives under "packages" folder can be repacked. With original engine and repacked *.pima archive, it throws error on initializing setup phase on very beginning.
- CS5.5 and CS5 do not require d!akov installer engine to install repacked assets. Also, *.pima archives under "packages" directory can be repacked on CS5.5 and CS5 installers. Because CS5.5 and before's RIBS installer engines doesn't have signature verification.
- CS4 and CS3(?) doesn't require this script. Payloads stored as MSI installer and no verification is present except for protected ones (?). If installer assets unpacked via "msiexec /a" and replacing packed assets with unpacked ones, installer will install our unpacked assets with an honor.

## Requirements
- On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip". But you can edit install.bat to change 7-Zip's location currently. I may update script to detect 7-Zip's install location by reading registry.
- Latest PowerShell for Windows XP(/x64)/Server 2003(/R2)(/x64)/Vista(/x64)/Server 2008/(/x64). Windows 7 and above comes with PowerShell by default.

## What does this script do?
This script compresses all unpacked assets that present on "payloads" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets excluded via excludepackages.txt and excludepayloads.txt that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

## Limitations
- ZIP file must not exceed 2 GB. I tested this with HyperDrive installer engine and it throwed error. But I didn't tested this with RIBS engine. May it supports 2 GB+ files or not. Proceed with caution.
- If original Adobe CC 2015 application is installed with original RIBS engine, use install-admin-existing.bat. You need to run this file as administrator for temporarily replacing OOBE folder on C:\Program Files\Adobe. This folder is where the installer engine is. If no Adobe application was installed before, use install-fresh.bat. You can run this file as normal user.
- If \payloads\Media_db.db\PayloadData\ (any payload id)\PayloadInfo is greater than 8.0.0.15, installer throws this error on logs: *ERROR: DW021: Payload {8FD7F1DB-7355-469E-A3F2-2118148D8477} DVA Adobe SpeedGrade CC 2015 9.0.0.0 of version: 9.0.0.6 is not supported by this version: 8.0.0.15 of RIBS.* This can be fixed with DB Browser from https://sqlitebrowser.org/dl/ . Edit \payloads\Media_db.db\PayloadData\ (any payload id)\PayloadInfo that's greater than 8.0.0.15 to 8.0.0.15 or lower.
- On CS5.5(?) and CS5, some packages will be protected and they cannot be unpacked via 7-Zip. These packages will prompt for password if they tried to unpacked. Only RIBS installer engine can unpack these packages.
- CS4 and CS3's protected content can be unpacked unlike in CS5 and above, but installer will throw error on initialization phase. If you look installer logs, you will see i.e. AdobeAfterEffects9ProtectedAll was failed error 1603. I think it's also valid for CS3.
- Interestingly on my tests with CS4, if protected content's payload path is beyond MAX_PATH variable, initialization phase is continued like nothing happened. But installer will fail gradually when installer tries to install protected unpacked content. My theory was installer engine is so old that skips paths that beyond MAX_PATH limit on initialization phase, but on installation phase, it doesn't and it will fail.
- With more interesting thing, above 2 statements, Adobe Premiere Pro CS4 was installed successfully, with unpacked protected contents. I think this problem was about invalid character problem that Adobe After Effects CS4 Protected Contents' unpacked assets path that contains or this problem was specifically for After Effects. Currently unpackable assets are:
  - CS4
  - AdobeAfterEffects9ProtectedAll ((Package normally unpackable, but it throws error 1603 while initialization phase.) (Not on standalone program, but on Master Collection and likely on other suites that contains this package, throws error 1304 about copying file. Even if you try to click "Retry", it throws error 2350 and unpack fails.))
  - AdobeAfterEffects9FCAll (unpacked version prevents installation phase to be completed and it throws error.)
  - MSXML6.0 (Normally it's unpackable, but due to conflict between x64 and ia64, I not prefer unpack this payload folder. If you try to separate folder into individual payloads, at initialization phase, nothing happens and installation not starts due to payload ID conflict I guess.)
  - AdobeContribute-PDistiller-mul\de_DE (throws error 2715 on unpacking.)
  - AdobeVersionCue4All (Package normally unpackable, but it throws error 1603 while initialization phase.)
  - AdobeAfterEffects9All ((Not on standalone application, but on Master Collection and probably on other suites, from unpacked packages inside on Master Collection suite and others, initialization phase takes about like 10-20 minutes or longer depending on selected suite and hardware of PC that suite is going to be installed, but this package fails and gives permission error about AdobeAfterEffects9ProtectedAll directory inside of unpacked After Effects assets and throws error 1603 on logs.))
  - CS3
  - AdobeAfterEffects8All (On CS3, this package fails and gives permission error about AdobeAfterEffects9ProtectedAll directory inside of unpacked After Effects assets and throws error 1603 on logs.)
  - AdobeAfterEffects8FCAll (unpacked version prevents installation phase to be completed and it throws error.)
  - AdobeAfterEffects8ProtectedAll (On CS3, throws error 1304 about copying file. Even if you try to click "Retry", it throws error 2350 and unpack fails.)
  - AdobePremierePro3All (Installation fails with error 1603.)
  - Probably all main packages and protected packages can't be unpacked. But optional packages like Bridge does.
