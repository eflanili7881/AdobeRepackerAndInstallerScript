# Adobe HyperDrive (HD) Unpacked Installer
A .bat script that compresses unpacked Adobe HyperDrive (HD) assets and installs them.
 
I wrote this script who wants to store HyperDrive (HD) based Adobe application installers with assets unpacked for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

# Requirements
On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip".

# What does this script do?
This script compresses all unpacked assets that present on "products" folder to temporary directory set by script, copies HyperDrive installer engine from installation media with unpacked assets and script files excluded via exclude.txt and invokes Set-up.exe on temporary directory set by script to install repacked product.

# Limitations
- *.pima archives under "packages" directory (for Creative Cloud itself) cannot be unpacked and repacked because Creative Cloud installer pushes error 4. I think HyperDrive install engine doesn't forces signatures to be valid on "products" directory, but enforces signatures must be valid on "packages" directory.
- ZIP file must not exceed 2 GB. I tested Premiere Pro with -mx0 flag on 7z command line and HyperDrive installer engine throws error. Maybe it's with CompressionType on Application.json or something.
