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
  - When I looked script invoke path from IDA Pro 6.5, it follows this path:
    - _pim_installAdobeApplication
    - sub_130CA (on IDA Pro 6.5)
    - sub_124CB (on IDA Pro 6.5)
      - On sub_124CB, magic happens on 0x12D46; rerouting **jne 0x12DC1** to **jne 0x12D48** (on Cutter by Rizin) bypasses verification on *.pima archives.
  - To patch dylibs:
    - Download Cutter from https://cutter.re or https://github.com/rizinorg/cutter/releases and IDA Pro 6.5 or newer on https://hex-rays.com/ida-pro
    - Install Cutter and IDA Pro 6.5 or newer.
    - On AdobePIM.dylib:
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
