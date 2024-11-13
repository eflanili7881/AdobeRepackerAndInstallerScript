# Adobe Repacker and Installer Script - Patched Binaries for ZIP and DMG-based RIBS Installers for macOS (for CS6 - CC 2015)
A repo that contains patched binaries for installing unpacked Adobe RIBS assets.

# CAUTION!
Please, don't use this branch's content for piracy things. I put this patched binaries for who wants to install their unpacked RIBS-based Adobe application installers for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs.

# CAUTION!
Please, don't use this branch's content for piracy things. I put this patched binaries for who wants to install their unpacked RIBS-based Adobe application installers for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs.

# CAUTION!
Please, don't use this branch's content for piracy things. I put this patched binaries for who wants to install their unpacked RIBS-based Adobe application installers for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs.

## Why I repeated above thing 3 times?
Because I'm afraid that Adobe can copy-strike me like on archive.org. I put these files for **LEGITIMATE** users.

## Credits
- [Me](https://github.com/eflanili7881) for writing script.
- [Rizin](https://rizin.re) for [Cutter](https://cutter.re) reverse engineering program .
- [Hex-Rays](https://hex-rays.com/) for [IDA Pro 6.5](https://hex-rays.com/ida-pro) reverse engineering program .
- PainteR for patched binaries for Windows to understand verification on macOS binary.
- Adobe Systems Incorporated for providing original binaries.

## What's this repo contains?
This repo contains patched binaries for installing unpacked Adobe RIBS applications (currently contains patch method only for AdobePIM.dylib version 8.0.0.73).

## Special note
- When I examined AdobePIM.dylib version 8.0.0.73 (got it from Adobe Premiere Pro CC 2014's Install.app file) on IDA Pro 6.5, it revealed more clues:
  ![image](https://github.com/user-attachments/assets/b9b2e84e-1555-41aa-8c9f-88b4678c11c5)
  - When I looked script invoke path from IDA Pro 6.5, it follows this path (on AdobePIM.dylib version 8.0.0.73):
    - _pim_installAdobeApplication
    - sub_130CA (on IDA Pro 6.5)
    - sub_124CB (on IDA Pro 6.5)
      - On sub_124CB, magic happens on 0x12D46; rerouting **jne 0x12DC1** to **jne 0x12D48** (on Cutter by Rizin) bypasses verification on ZIP-based *.pima archives.
- When I looked script invoke path from IDA Pro 9.0, it follows this path (on AdobePIM.dylib version 6.0.335.0):
  ![image](https://github.com/user-attachments/assets/49e3f6b3-6bde-46a1-a188-1cbcd6c392a0)
    - _pim_installPackage
    - sub_161FE
    - sub_8D28
      - On sub_8D28, magic happens on 0x956D; changing **mov [esp], eax** (on IDA Pro) to **jne 0x95D8** (on Cutter by Rizin) bypasses verification on DMG-based *.pima archives.
  - To patch dylibs:
    - Download Cutter from https://cutter.re or https://github.com/rizinorg/cutter/releases and IDA Pro 6.5 or newer on https://hex-rays.com/ida-pro
    - Install Cutter and IDA Pro 6.5 or newer.
    - On AdobePIM.dylib (version 8.0.0.73):
      - You need to use this version for ZIP-based installers (versions down to 7.x.x.x should be fine) (CC 2013 and above) as CS6 and below will use DMG-based installers.
      - CC 2015's AdobePIM.dylib (9.x.x.x) is a bit different. I'm inspecting it.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **aSignaturePimaC**.
        - 3 box later connected on box that contains aSignaturePimaC (in case, sub_12D34 on version 8.0.0.73), look for value **jnz short loc_12DC1** (on address 0x12D46).
          ![image](https://github.com/user-attachments/assets/515d364e-4cf4-498e-ade5-bd23411d4a57)
        - Now, you got the necessary address for changing 0x12DC1 to 0x12D48. Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x12D46 on Cutter.
          ![image](https://github.com/user-attachments/assets/0a9efae9-5f09-40e1-af35-d9ed1a6e43eb)
        - Change 0x12DC1 to 0x12D48 with disabling *Fill all remaining bytes with NOP opcodes*.
        - When you reload the file on Cutter, graph will turn into this:
        ![image](https://github.com/user-attachments/assets/129f8628-dc64-4229-a8a4-fca4b5834bee)
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    - On AdobePIM.dylib (version 6.0.335.0)
      - You need to use this version for DMG-based installers (CS6 and below) as CC 2013 (7.x.x.x) and CC 2017? (RIBS-based ones, 10.x.x.x) will use ZIP-based installers.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **corrupted**
        - Search results should be contain 4 __text and 3 __cstring addresses.
          ![image](https://github.com/user-attachments/assets/715bf2d1-b930-4ac6-87b6-174170b87978)
        - Click the result that's on __text:0x9597
          ![image](https://github.com/user-attachments/assets/8d56c799-bf31-42fe-9622-36819acf4548)
        - 2 box before connected on box that contains the result from previous step, look for string that before on **; try {**.
          ![image](https://github.com/user-attachments/assets/0ed0e81f-441f-450a-b15c-43a82453bcb6)
        - Now you got the necessary address (in case, it's 0x956D) for changing **mov [esp], eax** (on IDA Pro) to **jne 0x95D8**.
        - Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x956D on Cutter.
          ![image](https://github.com/user-attachments/assets/cea7f628-20a9-4f73-8473-9a09e7ff01bd)
        - Change **mov dword [esp], eax** to **jne 0x95D8** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0x9576 but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:
          ![image](https://github.com/user-attachments/assets/15f588f8-8a6a-4bcc-be63-c1cfebe691e9)
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    - On Setup.dylib (version 6.0.98.0)
      - You need to use this version for DMG-based installers (CS6 and below) as CC 2013 (7.x.x.x) and above will use ZIP-based installers.
        - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **aSIsCorruptedFi_0**
        - It should contain 1 __text and 1 __cstring results.
          ![image](https://github.com/user-attachments/assets/68a4bd77-e17f-489e-ba18-ab8bc37e010d)
        - 1 box before connected on box that contains the result from previous step, look for string that before on **; try {**.
        - Now you got the necessary address (in case, it's 0xD7CB9) for changing **mov [esp], esi** (on IDA Pro) to **jne 0xD7DC4** (on Cutter by Rizin).
          ![image](https://github.com/user-attachments/assets/178383df-7989-4e38-a9f5-93804de17a30)
        - Open Setup.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0xD7CB9 on Cutter.
          ![image](https://github.com/user-attachments/assets/bf0607bb-48ba-4cee-95f4-21fc2ca298cd)
        - Change **mov dword [esp], esi** to **jne 0xD7DC4** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0xD7CD5 but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:
          ![image](https://github.com/user-attachments/assets/f229aaf5-549f-475f-a22e-4cb200760c37)
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
