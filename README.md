# Adobe Repacker and Installer Script - HyperDrive (HD) for Macintosh (for CC 2015 - present)
A .sh script that compresses unpacked Adobe HyperDrive (HD) assets and installs them.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store HyperDrive (HD)-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## What does this script do?
This script compresses all unpacked assets that present on "products" folder to temporary directory set by script, copies HyperDrive installer engine from installation media with unpacked assets excluded via exclude.txt that's generated via script and invokes Install.app on temporary directory set by script to install repacked product.

## Special note
- Packed assets should be unpacked on macOS due to many symbolic links inside of .app file.
  - If you try install unpacked assets that's unpacked on Windows, app won't start due to missing symbolic links inside of .app file.
    - I tested with 7-Zip, symbolic link expanded, but it has zero thing and size is zero bytes. But when I unpack packed asset on macOS via built-in Archive Utility, symbolic link expanded again, but this time, it has proper links. When I inspect them from network drive from Windows, it's also returns zero bytes, but this time, path is correct this time instead of big empty line. I tried copy this link from macOS to Windows via network drive in Windows Explorer and I still able to view actual path of symbolic link.

## Limitations
- *.pima archives under "packages" directory (for Creative Cloud itself) cannot be unpacked and repacked because Creative Cloud installer throws error 4. I think HyperDrive install engine doesn't enforce signatures to be valid on "products" directory, but enforces signatures to be valid on "packages" directory.
- Currently, LZMA2-compressed ZIP files cannot be unpacked and repacked. They cannot be unpacked with 7-Zip itself. They may obtainable if unpacked version is copied from .adobeTemp directory really fast. Because as soon as install finishes, HyperDrive installer engine deletes that files as soon as possible.
