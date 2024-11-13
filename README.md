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
- [Me](https://github.com/eflanili7881) for writing script.
- [Rizin](https://rizin.re) for [Cutter](https://cutter.re) reverse engineering program .
- PainteR for patching specific 6 binaries for installing unpacked Adobe RIBS-based applications (version 8.0.0.15 and 7.0.0.103 of RIBS to be precise).
- Adobe Systems Incorporated for providing original binaries.

## What's this repo contains?
This repo contains patched binaries for installing unpacked Adobe RIBS applications.

## Special note
- I compared all dll's with Cutter and I see what's the PainteR did. PainteR just bypassed verification mechanism. With manual patching, I able to patch 9.x.x.x engine (9.0.0.65 to be precise) and install SpeedGrade CC 2015 with modified assets in both folders without a problem.
  - With this, you don't need modify Media_db.db to allow lower versions of RIBS to install newer packages.
  - When I traced functions, function invoking works like this:
    - On AdobePIM.dll (version 8.0.0.73, patched binary, on IDA Pro 9.0):

      ![image](https://github.com/user-attachments/assets/c338e0e5-cdb3-470d-bbcd-5c5a163186c1)
      - 1st, AdobePIM.dll invokes **_pim_installAdobeApplicationManager**. Then, inside this function, it invokes **call fcn.10010300** on address **0x10012414**.

        ![image](https://github.com/user-attachments/assets/9acbe58d-7e63-43fc-948e-417dbb620990)
      - 2nd, on **fcn.10010300**, it invokes **call fcn.1000f690** on address **0x10010394**. When you look up, you understand that this function is for validating AAM packages.

        ![image](https://github.com/user-attachments/assets/63cbd7f8-9d64-4115-b63c-02f72901197e)
      - Lastly, on **fcn.1000f690**, main magic happens on **0x100100ff**; rerouting **jne 0x10010105 (original position)** to **jne 0x10010101 (position to bypass verification mechanism)** bypasses *.pima archive integrity check.

        ![image](https://github.com/user-attachments/assets/d954489b-378f-4eca-b235-fc2e536ff87a)
    - On Setup.dll (version 8.0.0.15, original binary, on IDA Pro 9.0):

      ![image](https://github.com/user-attachments/assets/5e41fbd5-d2d0-4d6d-a436-ed427607e155)
      - 1st, **fcn.100a2080** invokes **fcn.100a9050** on **0x100a301e** or **fcn.10066d90** on **0x100a63bf**.
        |1st way|2nd way|
        |:-:|:-:|
        |**fcn.100a9050** invokes **fcn.10065b00** on **0x100a91b2** or **0x100a932a**|**fcn.10066d90** invokes **fcn.100667a0** on **0x1006781f**|
        |![image](https://github.com/user-attachments/assets/a42b72ab-3c50-4be8-892f-801f18d9610a)|![image](https://github.com/user-attachments/assets/e037507f-0509-4a88-9bdb-d99aa43db317)|
        |![image](https://github.com/user-attachments/assets/32794df1-8a1c-49cc-9f0f-baf20f5e21fb)|**fcn.100667a0** invokes **fcn.10065b00** on **0x10066b92**|
        |II|![image](https://github.com/user-attachments/assets/17532291-822d-443a-9d7e-320cf6cfeb89)|
        |V|V|
      - Lastly, on **fcn.10065b00**, main magic happens on **0x1006660c**; rerouting **jne 0x10066617** to **jne 0x1006660c** bypasses *.zip archive integrity check.

        ![image](https://github.com/user-attachments/assets/06a9f799-568f-45ea-bd6e-9370cc9a8e22)
        
  - To patch dll's:
    - Download Cutter from https://cutter.re or https://github.com/rizinorg/cutter/releases
      - macOS users also need IDA Pro 6.5 or newer to disassemble *.dylib files much more. Cutter is great tool, but it disassembles *.dylib files less good than IDA Pro. More details on https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/blob/RIBS-mac-patchedbins
    - Install Cutter.
      - On AdobePIM.dll:
        - Open AdobePIM.dll with experimental (aaaa) mode and in write mode (-w).
        - When it's loaded switch to Search tab and search **str.Signature_pima_CheckSum** with these settings:
          - Search for: 32-bit value
          - Search in: All mapped sections
        - This will return only 1 value like this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/da6c02ae-7bef-45d1-8513-0542f8066175)
        - Double click to switch to this address.
        - It will load in Disassembly mode. Change it to Graph section.
          - If it loads in Graph mode by default, skip to step below.
        - Then scroll slightly up to find **str.File___s__is_corrupted._OCEError:__d**'s connected box.
        - **str.File___s__is_corrupted._OCEError:__d**'s box is connected to one box like this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/19eb7cf7-6b08-4de5-8919-ad0722fa4e2c)
        - Above picture, click right **jne 0x1000f58c** to open menu and then click Edit > Instruction.
        - Change **0x1000f58c** to **0x1000f588** and disable *Fill all remaining bytes with NOP opcodes*. This bypasses *.pima archive verification in AdobePIM.dll.
        - When you reload file with same settings, graph will turn into this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/074fd6d7-8367-4dc3-8f8f-534f813c1a2b)
        - As you can see, **str.File___s__is_corrupted._OCEError:__d** is not visible in graph.
      - On Setup.dll:
        - Open Setup.dll with experimental (aaaa) mode and in write mode (-w).
        - When it's loaded switch to Search tab and search **str.s_is_corrupted._File___s__is_corrupted._OCEError:__d** with these settings:
          - Search for: 32-bit value
          - Search in: All mapped sections
        - This will return only 1 value like this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/fca8448f-bd55-4c03-bfd9-5f7f0030337e)
        - It will load in Disassembly mode. Change it to Graph section.
          - If it loads in Graph mode by default, skip to step below.
        - Then scroll slightly up to find **str.s_is_corrupted._File___s__is_corrupted._OCEError:__d**'s connected box.
        - **str.s_is_corrupted._File___s__is_corrupted._OCEError:__d**'s box is connected to one box like this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/4da12adf-072e-498a-a579-efd64380cf55)
        - Above picture, click right **jne 0x100bcae6** to open menu and then click Edit > Instruction.
        - Change **0x100bcae6** to **0x100bcada** and disable *Fill all remaining bytes with NOP opcodes*. This bypasses signature check of assets in Setup.dll.
        - When you reload file with same settings, graph will turn into this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/b4ffefe1-24cb-458d-a630-b593e5458d7a)
        - As you can see, **str.s_is_corrupted._File___s__is_corrupted._OCEError:__d** is not visible in graph.
      - On updatercore.dll:
        - Open Setup.dll with experimental (aaaa) mode and in write mode (-w).
        - When it's loaded switch to Search tab and search **str.CFU_Webfeed_:_Patch_is_meant_only_for_subscription_licenses__but_client_doesn_t_have_a_valid_subscription_license.** with these settings:
          - Search for: 32-bit value
          - Search in: All mapped sections
        - This will return only 1 value like this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/74bfaa30-c957-4cee-89ea-e4d48617b199)
        - It will load in Disassembly mode. Change it to Graph section.
          - If it loads in Graph mode by default, skip to step below.
        - Delete all cases (;-- **case name**:) in this graph.
          - To do that, right click ;-- **case name**:, and click Delete flag.
        - Then on picture below, right click **ja 0x1006ef1d**, click Edit > Instruction, change **ja** to **jmp** and disable *Fill all remaining bytes with NOP opcodes*. This bypasses perpetual and subscription update check on updatercore.dll:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/e7314bf4-7ab7-48ec-a7e0-24ccd5d62f8c)
        - When you reload file with same settings, graph will turn into this:

          ![image](https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/assets/44976117/465ea6e5-c3b7-440e-9f78-fb23b986a7c6)
        - As you can see, all checks for perpetual and subscription updates are bypassed.
    - PainteR versions have other small changes but bypassing only these values does trick. If you curious, you can research it further.
