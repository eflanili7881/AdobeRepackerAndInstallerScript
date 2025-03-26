# Adobe Repacker and Installer Script - Patched Binaries for ZIP-based HyperDrive Installers for Windows (for CC 2015 - present)
A repo that contains patched binaries for installing unpacked Adobe Creative Cloud *.pima assets.

# CAUTION!
Please, don't use this branch's content for piracy things. I put this patched binaries for who wants to install their unpacked RIBS-based Adobe application installers for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs.

# CAUTION!
Please, don't use this branch's content for piracy things. I put this patched binaries for who wants to install their unpacked RIBS-based Adobe application installers for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs.

# CAUTION!
Please, don't use this branch's content for piracy things. I put this patched binaries for who wants to install their unpacked RIBS-based Adobe application installers for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs.

## Why I repeated above thing 3 times?
Because I'm afraid that Adobe can copy-strike me like on archive.org. I put these instructions for **LEGITIMATE** users.

## Credits
- Mentioned on https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/blob/main/README.md#credits

## What's this repo contains?
This repo contains patched binaries for installing unpacked Adobe Creative Cloud *.pima assets.

## Special note
- Normally, HyperDrive-based installers doesn't have any verification mechanism for "products" folder. But on "packages" folder, HyperDrive-based installers enforce signature to be valid.
  - If you try patch AdobePIM.dll with Set-up.exe version **x>=4.6.0.391**, it gives error 42 or 72.

    ![image](./pictures/386967358-d2ca655d-8dfb-4f5e-aec5-b1cc7936876a.png)

    ![image](./pictures/386967428-c87e9c58-7a65-4e80-af32-073bc53daede.png)

    - When I try to launch installer via **\packages\ACC\Utils\Utils.pima\CreativeCloudSet-Up.exe (copied it Creative Cloud's install root (version x>=4.6.0.391))**, error 72 appears.

      ![image](./pictures/386968374-8e640756-e212-4ac5-ae6d-6667ebcd25c5.png)

      ![image](./pictures/386968562-fe724632-9ed8-41e5-98f9-b5432f30eea9.png)

      ![image](./pictures/386971529-2b87eb48-ac29-446e-8517-233158b0704d.png)
    
        - Both errors suggests it's signature validation error.
    - Because version **x>=4.6.0.391**, it enforces Adobe account login and file signatures to be valid.
   
      ![image](./pictures/387214046-296edddb-de81-46bb-999c-d1a97667901d.png)

      - If you try to install Adobe Creative Cloud with Set-up.exe version **x>=4.6.0.391** above errors will occur.
    - **\Set-up.exe** and **\packages\ACCC\Utils\Utils.pima\CreativeCloudSet-Up.exe**'s file sizes and hashes will be different for version **x>=4.6.0.391**.
      - File size:

        ![image](./pictures/387219171-3cee2117-732c-446a-a571-3c1a970f1c64.png)
   
        ![image](./pictures/387219426-7dc88200-0f70-4105-9504-067859d3b168.png)
   
      - Hash:
     
        ![image](./pictures/387220615-6b709c31-67f5-41ff-ad15-2bb403e9bc7b.png)
        
        ![image](./pictures/387220800-0ea73521-e721-413c-9ace-e74af1c75e78.png)

      - I think size difference comes from "login page" stuff.
        - When I try to launch installer via **\packages\ACC\Utils\Utils.pima\CreativeCloudSet-Up.exe (copied it Creative Cloud's install root (version x>=4.6.0.391))**, above errors will be occur.
  - But Set-up.exe version **x<=4.5.0.331** doesn't enforces user to login Adobe account and file signature to be valid. With this, you can patch AdobePIM.dll and use Set-up.exe version **x<=4.5.0.331**, you can install repacked *.pima archives with no issue.
 
    ![image](./pictures/387215499-fcbb09a2-c95d-4d73-822f-745addb78745.png)

    - **\Set-up.exe** and **\packages\ACCC\Utils\Utils.pima\CreativeCloudSet-Up.exe**'s file sizes and hashes will be same for version x<=4.5.0.331.
      - File size:
   
        ![image](./pictures/387217247-fb6ea80c-4a1f-4100-85d3-45f22d66672b.png)

        ![image](./pictures/387217543-4c6a2af5-60fd-4056-a933-13718b657d77.png)

      - Hash:
     
        ![image](./pictures/387218105-25cb605c-4a0e-462e-8a86-faa30e8fb9e5.png)

        ![image](./pictures/387218162-8791d289-58e0-4c83-a6e0-144586058189.png)

    - But if you try to install HyperDrive-based apps with patched AdobePIM.dll and Set-up.exe from **\packages\ACCC\HDCore\HDCore.pima\Set-up.exe (x<=4.3.0.256)** or **\packages\ADC\HDBox\HDBox.pima\Set-up.exe (x>=4.4.0.294)**, it gives error about installer file maybe damaged.
      - x<=4.3.0.256:
     
        ![image](./pictures/387224641-803a867c-3ed5-4319-9a9e-1432323765ad.png)

      - x>=4.4.0.294:
     
        ![image](./pictures/387224945-88cf4369-8422-4214-a7a0-1a92a388630a.png)

      - But if you install Creative Cloud first, reverting patch on AdobePIM.dll that I'm gonna mention on "To patch dll's" section or restoring original AdobePIM.dll and then running Set-up.exe  from **\packages\ACCC\HDCore\HDCore.pima\Set-up.exe (x<=4.3.0.256)** or **\packages\ADC\HDBox\HDBox.pima\Set-up.exe (x>=4.4.0.294)** will work as HyperDrive installer will skip already installed Adobe Creative Cloud packages.
        - You must disconnect from internet if you:
          - Get "Update your browser" notification,
         
            ![image](./pictures/387250083-92fe8d91-3c12-41e8-9208-c9cbef705392.png)
            
          - Don't want to use Adobe account.
          - Or want to prevent Adobe Creative Cloud to auto-update itself at least for installation process.
  - To patch dll's:
    - Download Cutter from https://cutter.re or https://github.com/rizinorg/cutter/releases and IDA Pro 6.5 or newer on https://hex-rays.com/ida-pro
    - Install Cutter and IDA Pro 6.5 or newer.
    # - On AdobePIM.dll (on 6.3.1.470):
      - Probably you can use this method for all versions.
        - Open AdobePIM.dll with IDA Pro 6.5 or newer with Portable executable for 80386 (PE) (pe64.dll) decompiler.
        - On IDA Pro, search for string **corrupt**.
        - Select **aFileSIsCorrupted_0** that's on bottom (In case, it's 0x100265DD)
       
          ![image](./pictures/387230754-b2b8a848-0936-4e65-a376-fc7f8092bb41.png)

          ![image](./pictures/387231324-11829fba-0ba5-4221-b276-19a7a7a38369.png)

        - Locate the end of the box that's connected before (In case, it's 0x100265BC).
       
          ![image](./pictures/387232276-7e2ba34c-9b96-4c9e-882d-e29aaa2f7530.png)

        - You've got necessary address to change on Cutter.
        - Open AdobePIM.dll on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x100265BC.
       
          ![image](./pictures/387233765-40006cde-48f1-40b2-96a1-f6cd1ef4b506.png)

        - Change **jne 0x100265c7** to **jne 0x100265be** with disabling *Fill all remaining bytes with NOP opcodes*.
        - When you reload file with same settings, graph will turn into this:
       
          ![image](./pictures/387235351-2ede9f05-90fd-4166-bbe6-64df6ff70e14.png)

        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.

## How to build unpacked HyperDrive app installer?
Currently script doesn't repack Creative Cloud packages on **packages** folder (*.pima archives). I will update script to repack these packages as well.
- I assume you got:
  - **ACCCx4_5_0_331.zip** (If you're gonna use Adobe Creative Cloud version **x>=4.6.0.384**),
  - **ACCCx(version_numer_you_want).zip** (You can use only this version if you're gonna use Adobe Creative Cloud version **x<=4.5.0.331**),
  - **ACCCx5_3_1_470.zip** (For installing HyperDrive-based applications with same **packages** structure from Creative Cloud installer if you're gonna use **x=>5.3.5.518 (or 5.3.5.499 if you're gonna use prerelease copy of first Creative Cloud version that supports ARM64 platform natively.)**),
  - **products** folder for your app.
  - and **resources/content/images/appIcon.png** for your product.
    - (Optional) and **resources/content/images/appIcon2x.png** for your product.
- Extract **ACCCx(version_numer_you_want).zip** to a directory.
- Delete Set-up.exe and replace Set-up.exe from **ACCCx4_5_0_331.zip**.
  - Or **ACCCx(version_numer_you_want).zip** if you're gonna use Adobe Creative Cloud version **x<=4.5.0.331**.
- Then, rename Set-up.exe to anything you want (i.e. Set-up_CC.exe (for installing Adobe Creative Cloud)).
- On **packages** folder, extract every *.pima archive to same folder where original *.pima archive is located.
  - Structure should like this:
    - packages\ADC\HDBox\HDBox
      - <contentsOfHDBox.pimaArchive>
    - packages\ADC\HDBox\HDBox.sig
    - packages\ADC\HDBox\HDBox.pimx
- Delete original *.pima archives after extraction is done.
- Put **products** folder to where you **ACCCx(version_numer_you_want).zip** is extracted.
- On **products** folder, extract every *.zip archive to same folder where original *.zip archive is located.
  - Structure should like this:
    - products\AUDT\AdobeAudition10All
      - <contentsOfAdobeAudition10All.zipArchive>
    - products\AUDT\application.json
- Delete original *.zip archives after extraction is done.
- Put **resources\content\images\appIcon.png** to where you **ACCCx(version_numer_you_want).zip** is extracted.
  - (Optional) Put **resources\content\images\appIcon2x.png** to where you **ACCCx(version_numer_you_want).zip** is extracted.
- Get Set-up.exe from **ACCCx(version_numer_you_want).zip\packages\ADC\HDBox\HDBox.pima\Set-up.exe** and put Set-up.exe to where you extracted **ACCCx(version_numer_you_want).zip** if bundled version of Creative Cloud is **x<=5.3.1.470**.
  - Get Set-up.exe from **ACCCx5_3_1_470.zip\packages\ADC\HDBox\HDBox.pima\Set-up.exe** and put Set-up.exe to where you extracted **ACCCx5_3_1_470.zip** if bundled version of Creative Cloud is **x=>5.3.5.518 (or 5.3.5.499 if you're gonna use prerelease copy of first Creative Cloud version that supports ARM64 platform natively.)**.
- Rename Set-up.exe to anything you want (i.e. Set-up_HD.exe (for installing Adobe HyperDrive-based applications)).
- Move your original AdobePIM.dll to AdobePIM_original.dll.
- Make backup of your AdobePIM.dll.
- Patch the AdobePIM.dll.
- Move your patched AdobePIM.dll to AdobePIM_patched.dll.
- Copy your unpacked installer to your storage server and run deduplication right after unpacked installer is copied if you want.
