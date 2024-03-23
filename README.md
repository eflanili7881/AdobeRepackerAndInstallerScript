# Adobe Repacker and Installer Script - Patched Binaries for ZIP-based RIBS Installers for Windows (for CS6 - CC 2015)
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
- Me for writing script.
- PainteR for patching specific 3 binaries for installing unpacked Adobe RIBS-based applications (veision 8.0.0.15 of RIBS to be precise).
- Adobe Systems Incorporated for providing original binaries.

## What's this repo contains?
This repo contains patched binaries for installing unpacked Adobe RIBS applications.

## Special note
- I compared all dll's with Cutter and I see what's the PainteR did. PainteR just bypassed verification mechanism. With manual patching, I able to patch 9.x.x.x engine (9.0.0.65 to be precise) and install SpeedGrade CC 2015 with modified assets in both folders without a problem.
  - To patch dll's:
    - Download Cutter from https://github.com/rizinorg/cutter
    - Install Cutter.
      - On AdobePIM.dll:
        - Open AdobePIM.dll with experimental (aaaa) mode and in write mode (-w).
        - When it's loaded switch to Search tab and search **str.Signature_pima_CheckSum** with these settings:
          - Search for: 32-bit value
          - Search in: All mapped sections
        - This will return only 1 value like this:
          ![image](https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/assets/44976117/da6c02ae-7bef-45d1-8513-0542f8066175)
        - Double click to switch to this address.
        - It will load in Disassembly mode. Change it to Graph section.
        - Then scroll slightly down to find **str.File___s__is_corrupted._OCEError:__d**
        - **str.File___s__is_corrupted._OCEError:__d**'s box is connected to one box like this:
          ![image](https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/assets/44976117/19eb7cf7-6b08-4de5-8919-ad0722fa4e2c)
        - Above picture, click right **0x1000f58c** to open menu and then click Edit > Instruction.
        - Change **0x1000f58c** to **0x1000f588** and disable *Fill all remaining bytes with NOP opcodes*. This bypasses *.pima archive verification in AdobePIM.dll.
        - When you reload file with same settings, graph will turn into this:
          ![image](https://github.com/osmankovan123/AdobeRepackerAndInstallerScript/assets/44976117/074fd6d7-8367-4dc3-8f8f-534f813c1a2b)
        - As you can see, **str.File___s__is_corrupted._OCEError:__d** is not visible in graph.
