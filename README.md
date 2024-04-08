# REPO WORK IN PROGRESS

# Adobe Repacker and Installer Script - RIBS for Macintosh (currently for CS5 and CS5.5)
A .sh script that compresses unpacked Adobe RIBS assets and installs them.
- NOTE: Script will be uploaded after sometime.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## What does this script do?
This script compresses all unpacked assets that present on "payloads" and "packages" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets excluded via excludepackages.txt and excludepayloads.txt that's generated via script and invokes Install.app on temporary directory set by script to install repacked product.
  - I think this approach only valid for CS5 and CS5.5 if I not able to patch AdobePIM.dylib.
  - But **maybe** I can write small installer that puts necassary files into necassary locations for CS6 - CC 2015 with **no install** support provided by Adobe's self installer.

## Limitations
- If I correctly know, macOS doesn't have patched AdobePIM.dylib for installing custom assets for Adobe CS6 - CC 2015
  - I tried to patch engine like in Windows, but it's almost impossible, but it isn't impossible, it takes too much time as they're almost no comments to parse packages.
  - But like in Windows, Adobe CS5.5 and below doesn't have signature verification for .pima archives (actually, they're just .dmg files with .pima extension) and .dmg archives.

## Special note
- With Adobe CC 2013, *.pima format in packages folder changed to ZIP (extension is still .pima) and *.dmg format in payloads folder also changed to ZIP (extension also changed to .zip).
  - DMG-based installers uses **single Apple partition map-partitioned HFS+-formatted UDIF read-only compressed (zlib)** disk images:
  
    ![image](https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/assets/44976117/8040cb7d-4bd2-4ddd-a5e0-6939a43ad97e)
    
    ![image](https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/assets/44976117/93bed0fd-400b-490e-bdab-cada5dfc775d)
