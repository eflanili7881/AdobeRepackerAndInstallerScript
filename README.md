# Adobe HyperDrive (HD) Unpacked Installer
A .bat script that compresses unpacked Adobe HyperDrive (HD) installers with unpacked assets and installs them.
 
I wrote this script who wants to store HyperDrive (HD) based Adobe application installers with assets unpacked for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs.

# Requirements
On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip".

# What does this script do?
This script compresses all unpacked assets that present on "products" folder to temporary directory set by script, copies HyperDrive installer engine present on unpacked assets (from installation media) with unpacked assets excluded via exclude.txt and invokes Set-up.exe on temporary directory set by script to install repacked product.
