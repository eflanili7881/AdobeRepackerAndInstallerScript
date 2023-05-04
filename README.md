# Adobe Repacker and Installer Script - HyperDrive (HD) (for CC 2015 - present)
A .bat script that compresses unpacked Adobe HyperDrive (HD) assets and installs them.
 
Please, don't use this script for piracy things. I wrote this script for who wants to store HyperDrive (HD)-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

# Requirements
- On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip". But you can edit install.bat to change 7-Zip's location currently. I may update script to detect 7-Zip's install location by reading registry.

# What does this script do?
This script compresses all unpacked assets that present on "products" folder to temporary directory set by script, copies HyperDrive installer engine from installation media with unpacked assets and script file and exclude.txt excluded via exclude.txt and invokes Set-up.exe on temporary directory set by script to install repacked product.

# Limitations
- *.pima archives under "packages" directory (for Creative Cloud itself) cannot be unpacked and repacked because Creative Cloud installer throws error 4. I think HyperDrive install engine doesn't enforces signatures to be valid on "products" directory, but enforces signatures to be valid on "packages" directory.
- ZIP file must not exceed 2 GB. I tested Premiere Pro with -mx0 flag on 7z command line and HyperDrive installer engine throws error. Maybe it's with CompressionType on Application.json or something.
- Currently, LZMA2-compressed ZIP files cannot be unpacked and repacked. They cannot be unpacked with 7-Zip itself. They may obtainable if unpacked version is copied from adobeTemp directory really fast. Because as soon as install finishes, HyperDrive installer engine deletes that files as soon as possible.
