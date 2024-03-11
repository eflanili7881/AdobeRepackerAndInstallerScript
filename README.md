# REPO WORK IN PROGRESS

# Adobe Repacker and Installer Script - RIBS for Macintosh (for CS5 - CC 2015)
A .sh script that compresses unpacked Adobe RIBS assets and installs them.
- NOTE: Script will be uploaded after sometime.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## What does this script do?
This script compresses all unpacked assets that present on "payloads" and "packages" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets excluded via excludepackages.txt and excludepayloads.txt that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

## Limitations
- If I correctly know, macOS doesn't have patched AdobePIM.dylib for
