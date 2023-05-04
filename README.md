# Adobe Repacker and Installer Script - RIBS
A .bat script that compresses unpacked Adobe RIBS assets and installs them.
 
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

# Special note
- You'll need packages, resources folder and Setup.exe (rename this file later as Set-up.exe) file from one of the d!akov repacks. Unfortunately, this is the current way to install repacked RIBS assets. Original RIBS install engine throws error about software may counterfeit. Do not take "payloads" folder from d!akov repack because it contains pirated application. But we need the only install engine of d!akov to install our repacked assets.
- Unlike HyperDrive-based installers, with d!akov install engine, *.pima archives under "packages" folder can be repacked. With original engine and repacked *.pima archive, it throws error on initializing setup phase on very beginning.

# Requirements
- On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip". But you can edit install.bat to change 7-Zip's location currently. I may update script to detect 7-Zip's install location by reading registry.

# What does this script do?
This script compresses all unpacked assets that present on "payloads" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets and script file and exclude.txt excluded via exclude.txt and invokes Set-up.exe on temporary directory set by script to install repacked product.

# Limitations
- ZIP file must not exceed 2 GB. I tested this with HyperDrive installer engine and it throwed error. But I didn't tested this with RIBS engine. May it supports 2 GB+ files or not. Proceed with caution.
- If original Adobe CC 2015 application is installed with original RIBS engine, use install-admin-existing.bat. You need to run this file as administrator for temporarily replacing OOBE folder on C:\Program Files\Adobe. This folder is where the installer engine is. If no Adobe application was installed before, use install-fresh.bat. You can run this file as normal user.
- If \payloads\Media_db.db\PayloadData\(any payload id)\PayloadInfo is greater than 8.0.0.15, installer throws this error on logs: *ERROR: DW021: Payload {8FD7F1DB-7355-469E-A3F2-2118148D8477} DVA Adobe SpeedGrade CC 2015 9.0.0.0 of version: 9.0.0.6 is not supported by this version: 8.0.0.15 of RIBS.* This can be fixed with DB Browser from https://sqlitebrowser.org/dl/ . Edit \payloads\Media_db.db\PayloadData\(any payload id)\PayloadInfo that's greater than 8.0.0.15 to 8.0.0.15 or lower.
