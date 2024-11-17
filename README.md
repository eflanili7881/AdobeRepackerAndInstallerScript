# Adobe Repacker and Installer Script - HyperDrive (HD) for Windows (for CC 2015 - present)
A .bat script that compresses unpacked Adobe HyperDrive (HD) assets and installs them.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store HyperDrive (HD)-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## Credits
- [Me](https://github.com/eflanili7881) for writing script.
- Adobe Systems Incorporated for providing applications.

## Requirements
- On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip". But you can edit install.bat to change 7-Zip's location currently. I may update script to detect 7-Zip's install location by reading registry.
- Latest PowerShell for Windows. Without updating PowerShell, it may work but folder scanning may not successful.

## What does this script do?
This script compresses all unpacked assets that present on "products" folder to temporary directory set by script, copies HyperDrive installer engine from installation media with unpacked assets excluded via exclude.txt that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

## Limitations
- *.pima archives under "packages" directory (for Creative Cloud itself) cannot be unpacked and repacked because Creative Cloud installer throws error 4 with original AdobePIM.dll and modified *.pima archive.

  ![image](https://github.com/user-attachments/assets/de7aa0d0-dabf-412c-95a6-fcd584fb8ac2)

  - I can't find error code on website.
  - It mentions Adobe Genuine Validation failed with error 4 on **C:\Users\Administrator\AppData\Local\Temp\CreativeCloud\ACC\ACC.log**
 
    ![image](https://github.com/user-attachments/assets/1c714316-1c2e-42ad-baf0-2dfcf780f29c)

I think HyperDrive install engine doesn't enforces signatures to be valid on "products" directory, but enforces signatures to be valid on "packages" directory. But on HyperDrive installer engine (KpoJIuK repacks), some *.pima archives were different sizes (i.e. \packages\ADC\Runtime\Runtime.pima because KpoJIuK installers have separate Microsoft Visual Studio C++ Redistributable installer). Maybe ADC folder was excluded from signature verification or KpoJIuK may patched installer to force installing his edited *.pima assets, I don't know.
  - If I try to patch AdobePIM.dll with any patching method, error 42 occurs.

    ![image](https://github.com/user-attachments/assets/d2ca655d-8dfb-4f5e-aec5-b1cc7936876a)

    ![image](https://github.com/user-attachments/assets/c87e9c58-7a65-4e80-af32-073bc53daede)

  - When I try to launch installer via **\packages\ACC\Utils\Utils.pima\CreativeCloudSet-Up.exe (copied it Creative Cloud's install root)**, error 72 appears.

    ![image](https://github.com/user-attachments/assets/8e640756-e212-4ac5-ae6d-6667ebcd25c5)

    ![image](https://github.com/user-attachments/assets/fe724632-9ed8-41e5-98f9-b5432f30eea9)

    - Both errors suggests it's signature validation error.
  - When I examined **C:\Users\Administrator\AppData\Local\Temp\CreativeCloud\ACC\WAM.log**, it shows error about CANameChain.

    ![image](https://github.com/user-attachments/assets/8da7a518-d97d-46be-8324-54fd3544a298)

    - It also mentions error 42 below.
  - I looked into ApplicationInfo.xml and I see all packages for ACC but HDCore and some other packages were disabled. You can disable every package, except HDCore on ACC and HDBox on ADC package set in ApplicationInfo.xml. Then, all of the packages assets can be deleted, again except HDCore and HDBox. That's maybe not unpacking but you can reduce footprint of installer with this way. This is exactly what AntiCC does. Installing bare minimum packages for installing HyperDrive-based applications.
    - Uninstalling application may stuck on %100 after you want to uninstall even if uninstallation was completed. Killing Set-up.exe processes works.
      - Or you can just install full Creative Cloud desktop after installing product just to be sure the product was %100 successfully uninstalled.
- ZIP file must not exceed 2 GB. I tested Premiere Pro with -mx0 flag on 7z command line and HyperDrive installer engine throws error. Maybe it's with CompressionType on Application.json or something.
- ~~Currently, LZMA2-compressed ZIP files cannot be unpacked and repacked. They cannot be unpacked with 7-Zip itself. They may obtainable if unpacked version is copied from adobeTemp directory really fast. Because as soon as install finishes, HyperDrive installer engine deletes that files as soon as possible.~~
  - With script I wrote in https://github.com/osmankovan123/AdobeLZMA2UnpackerScript , they can now be unpacked.

## Known Issues
- On exclude.txt and compress.txt, first lines be bugged (it looks fine, but while command processes, *packages* turns into *´╗┐packages* i.e.). 
  - To solve this, copy first line just below the first line.
    - If output's like this:
      - products\AEFT
      - products\KFNT
      - products\ACR
    - After that, output should be like this:
      - products\AEFT
      - products\AEFT
      - products\KFNT
      - products\ACR
  - I think this caused by auto creation by PowerShell script. When I freshly create .txt file from New menu from right click, this bug didn't happen. I don't know what causes this. Probably invisible special ASCII or Unicode character for initiating start of text file by PowerShell.
