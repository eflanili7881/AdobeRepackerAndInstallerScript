# Adobe Repacker and Installer Script - Patched Binaries for ZIP-based HyperDrive Installers for Windows (for CC 2015.5 - present)
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
- [Me](https://github.com/eflanili7881) for writing script.
- [Rizin](https://rizin.re) for [Cutter](https://cutter.re) reverse engineering program .
- [Hex-Rays](https://hex-rays.com/) for [IDA Pro 6.5](https://hex-rays.com/ida-pro) reverse engineering program.
- PainteR for patching AdobePIM.dll (RIBS-based installers) for understanding verification algorithm on HyperDrive-based installers.
- Adobe Systems Incorporated for providing original binaries.

## What's this repo contains?
This repo contains patched binaries for installing unpacked Adobe Creative Cloud *.pima assets.

## Special note
- Normally, HyperDrive-based installers doesn't have any verification mechanism for "products" folder. But on "packages" folder, HyperDrive-based installers enforce signature to be valid.
  - If you try patch AdobePIM.dll with Set-up.exe version **x>=4.6.0.391**, it gives error 42 or 72.

    ![image](https://github.com/user-attachments/assets/d2ca655d-8dfb-4f5e-aec5-b1cc7936876a)

    ![image](https://github.com/user-attachments/assets/c87e9c58-7a65-4e80-af32-073bc53daede)

    - When I try to launch installer via **\packages\ACC\Utils\Utils.pima\CreativeCloudSet-Up.exe (copied it Creative Cloud's install root (version x>=4.6.0.391))**, error 72 appears.

      ![image](https://github.com/user-attachments/assets/8e640756-e212-4ac5-ae6d-6667ebcd25c5)

      ![image](https://github.com/user-attachments/assets/fe724632-9ed8-41e5-98f9-b5432f30eea9)

      ![image](https://github.com/user-attachments/assets/2b87eb48-ac29-446e-8517-233158b0704d)
    
        - Both errors suggests it's signature validation error.
    - Because version **x>=4.6.0.391**, it enforces Adobe account login and file signatures to be valid.
   
      ![image](https://github.com/user-attachments/assets/296edddb-de81-46bb-999c-d1a97667901d)

      - If you try to install Adobe Creative Cloud with Set-up.exe version **x>=4.6.0.391** above errors will occur.
    - **\Set-up.exe** and **\packages\ACCC\Utils\Utils.pima\CreativeCloudSet-Up.exe**'s file sizes and hashes will be different for version **x>=4.6.0.391**.
      - File size:

        ![image](https://github.com/user-attachments/assets/3cee2117-732c-446a-a571-3c1a970f1c64)
   
        ![image](https://github.com/user-attachments/assets/7dc88200-0f70-4105-9504-067859d3b168)
   
      - Hash:
     
        ![image](https://github.com/user-attachments/assets/6b709c31-67f5-41ff-ad15-2bb403e9bc7b)
        
        ![image](https://github.com/user-attachments/assets/0ea73521-e721-413c-9ace-e74af1c75e78)

      - I think size difference comes from "login page" stuff.
        - When I try to launch installer via **\packages\ACC\Utils\Utils.pima\CreativeCloudSet-Up.exe (copied it Creative Cloud's install root (version x>=4.6.0.391))**, above errors will be occur.
  - But Set-up.exe version **x<=4.5.0.331** doesn't enforces user to login Adobe account and file signature to be valid. With this, you can patch AdobePIM.dll and use Set-up.exe version **x<=4.5.0.331**, you can install repacked *.pima archives with no issue.
 
    ![image](https://github.com/user-attachments/assets/fcbb09a2-c95d-4d73-822f-745addb78745)

    - **\Set-up.exe** and **\packages\ACCC\Utils\Utils.pima\CreativeCloudSet-Up.exe**'s file sizes and hashes will be same for version x<=4.5.0.331.
      - File size:
   
        ![image](https://github.com/user-attachments/assets/fb6ea80c-4a1f-4100-85d3-45f22d66672b)

        ![image](https://github.com/user-attachments/assets/4c6a2af5-60fd-4056-a933-13718b657d77)

      - Hash:
     
        ![image](https://github.com/user-attachments/assets/25cb605c-4a0e-462e-8a86-faa30e8fb9e5)

        ![image](https://github.com/user-attachments/assets/8791d289-58e0-4c83-a6e0-144586058189)

    - But if you try to install HyperDrive-based apps with patched AdobePIM.dll and Set-up.exe from **\packages\ACCC\HDCore\HDCore.pima\Set-up.exe (x<=4.3.0.256)** or **\packages\ADC\HDBox\HDBox.pima\Set-up.exe (x>=4.4.0.294)**, it gives error about installer file maybe damaged.
      - x<=4.3.0.256:
     
        ![image](https://github.com/user-attachments/assets/803a867c-3ed5-4319-9a9e-1432323765ad)

      - x>=4.4.0.294:
     
        ![image](https://github.com/user-attachments/assets/88cf4369-8422-4214-a7a0-1a92a388630a)

      - But if you install Creative Cloud first, reverting patch on AdobePIM.dll that I'm gonna mention on "To patch dll's" section or restoring original AdobePIM.dll and then running Set-up.exe  from **\packages\ACCC\HDCore\HDCore.pima\Set-up.exe (x<=4.3.0.256)** or **\packages\ADC\HDBox\HDBox.pima\Set-up.exe (x>=4.4.0.294)** will work as HyperDrive installer will skip already installed Adobe Creative Cloud packages.
        - You must disconnect from internet if you:
          - Get "Update your browser" notification,
         
            ![image](https://github.com/user-attachments/assets/92fe8d91-3c12-41e8-9208-c9cbef705392)
            
          - Don't wan't to use Adobe account.
  - To patch dll's:
    - Download Cutter from https://cutter.re or https://github.com/rizinorg/cutter/releases and IDA Pro 6.5 or newer on https://hex-rays.com/ida-pro
    - Install Cutter and IDA Pro 6.5 or newer.
    # - On AdobePIM.dll (on 6.3.1.470):
      - Probably you can use this method for all versions.
        - Open AdobePIM.dll with IDA Pro 6.5 or newer with Portable executable for 80386 (PE) (pe64.dll) decompiler.
        - On IDA Pro, search for string **corrupt**.
        - Select **aFileSIsCorrupted_0** that's on bottom (In case, it's 0x100265DD)
       
          ![image](https://github.com/user-attachments/assets/b2b8a848-0936-4e65-a376-fc7f8092bb41)

          ![image](https://github.com/user-attachments/assets/11829fba-0ba5-4221-b276-19a7a7a38369)

        - Locate the end of the box that's connected before (In case, it's 0x100265BC).
       
          ![image](https://github.com/user-attachments/assets/7e2ba34c-9b96-4c9e-882d-e29aaa2f7530)

        - You've got necessary address to change on Cutter.
        - Open AdobePIM.dll on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x100265BC.
       
          ![image](https://github.com/user-attachments/assets/40006cde-48f1-40b2-96a1-f6cd1ef4b506)

        - Change **jne 0x100265c7** to **jne 0x100265be** with disabling *Fill all remaining bytes with NOP opcodes*.
        - When you reload file with same settings, graph will turn into this:
       
          ![image](https://github.com/user-attachments/assets/2ede9f05-90fd-4166-bbe6-64df6ff70e14)

        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.

## How to build unpacked HyperDrive app installer?
- I assume you got:
  - **ACCCx4_5_0_331.zip** (If you're gonna use Adobe Creative Cloud version **x>=4.6.0.384**),
  - **ACCCx(version_numer_you_want).zip** (You can use only this version if you're gonna use Adobe Creative Cloud version **x<=4.5.0.331**),
  - and **products** folder for your app.
- Extract **ACCCx(version_numer_you_want).zip** to a directory.
- Delete Set-up.exe and replace Set-up.exe from **ACCCx4_5_0_331.zip**.
  - Or **ACCCx(version_numer_you_want).zip** if you're gonna use Adobe Creative Cloud version **x<=4.5.0.331**.
- Then, rename Set-up.exe to anything you want (i.e. Set-up_CC.exe (for installing Adobe Creative Cloud)).
- Put **products** folder to where you **ACCCx(version_numer_you_want).zip** is extracted.
- Get Set-up.exe from **ACCCx(version_numer_you_want).zip\packages\ADC\HDBox\HDBox.pima\Set-up.exe** and put Set-up.exe to where you extracted **ACCCx(version_numer_you_want).zip**.
- Rename Set-up.exe to anything you want (i.e. Set-up_HD.exe (for installing Adobe HyperDrive-based applications)).
- Move your original AdobePIM.dll to AdobePIM_original.dll.
- Make backup of your AdobePIM.dll.
- Patch the AdobePIM.dll.
- Move your patched AdobePIM.dll to AdobePIM_patched.dll.
