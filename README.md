# !!! SCRIPT NOT UPLOADED !!!

# Adobe Repacker and Installer Script - RIBS for Macintosh (currently for CS5 and CS5.5)
A .sh script that compresses unpacked Adobe RIBS assets and installs them.
- ~~NOTE: Script will be uploaded after sometime.~~
  - With my recent researches, it will now possible to install repacked assets. I will write a script in a near future. More information on https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/blob/RIBS-mac-patchedbins/README.md
# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## What does this script do?
This script compresses all unpacked assets that present on "payloads" and "packages" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets excluded via excludepackages.txt and excludepayloads.txt that's generated via script and invokes Install.app on temporary directory set by script to install repacked product.

- ~~I think this approach only valid for CS5 and CS5.5 if I not able to patch AdobePIM.dylib.~~
  - ~~But **maybe** I can write small installer that puts necassary files into necassary locations for CS6 - CC 2015 with **no install** support provided by Adobe's self installer.~~
  - ~~Because Macintosh versions of RIBS installers have MUCH MORE clean file structure compared to Windows.~~
  - With my recent researches, it will now possible to install repacked assets for CS6 to CC 2015 (probably, every RIBS-based Adobe applications). More information on https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/blob/RIBS-mac-patchedbins/README.md

## Limitations
- ~~If I correctly know, macOS doesn't have patched AdobePIM.dylib for installing custom assets for Adobe CS6 - CC 2015~~
  - ~~I tried to patch engine like in Windows, but it's almost impossible, but it isn't impossible, it takes too much time as they're almost no comments to parse packages.~~
  - With my recent researches, it will now possible to install repacked assets. More information on https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/blob/RIBS-mac-patchedbins/README.md
  - But like in Windows, Adobe CS5.5 and below doesn't have signature verification for *.pima (actually, they're just .dmg files with .pima extension) and *.dmg archives.

## Special note
- With Adobe CC 2013 (7.x.x.x), *.dmg format with *.pima extension in packages folder and *.dmg format in payloads folder changed to *.zip format (On *payloads* folder, extension is changed to *.zip, but in *packages* folder, extension is still *.pima).
  - DMG-based installers uses:
    - APM (Apple partition map) partition map
    - single partition
    - HFS+ format
    - UDIF read-only compressed (zlib) disk images.
  
    ![image](https://github.com/user-attachments/assets/4371811e-0cf9-4f91-b454-110e71412736)

    ![image](https://github.com/user-attachments/assets/2787a77f-5d57-4507-84cf-6d74497eb0c4)
  - On packages folder, partition labels will be equal to package folder name (i.e. DECore uses DECore).
    - To clear confusion, \packages\core\PDApp.pima uses **core** partition label.

    ![image](https://github.com/user-attachments/assets/2787a77f-5d57-4507-84cf-6d74497eb0c4)
  - On payloads folder, partition labels will be some random? generated 16 character label.

    ![1](https://github.com/user-attachments/assets/2756cf10-3dba-4592-a33c-268dd5d5541b)
    - But partition labels and sizes can be what you want as I tested DECore.pima and AdobePremierePro6.0AllTrial.dmg for the unpack test.

      ![image](https://github.com/user-attachments/assets/ad538934-5426-4bda-b9c1-01fd15feefa6)
