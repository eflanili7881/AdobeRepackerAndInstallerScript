# Adobe Repacker and Installer Script - Patched Binaries for ZIP and DMG-based RIBS Installers for macOS (for CS6 - CC 2015)
A repo that contains patched binaries for installing unpacked Adobe RIBS assets.

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
- [Rizin](https://rizin.re) for [Cutter](https://cutter.re) reverse engineering program.
- [Hex-Rays](https://hex-rays.com/) for [IDA Pro 6.5](https://hex-rays.com/ida-pro) reverse engineering program.
- PainteR for patched binaries for Windows to understand verification mechanism on macOS binaries.
- Adobe Systems Incorporated for providing original binaries.

## What's this repo contains?
This repo contains patched binaries for installing unpacked Adobe RIBS applications.

## Special note
- When I examined AdobePIM.dylib version 8.0.0.72 (got it from Adobe Premiere Pro CC 2014's Install.app file) on IDA Pro 6.5, it revealed more clues:

  ![image](./pictures/382582570-b9b2e84e-1555-41aa-8c9f-88b4678c11c5.png)
  
  - When I looked script invoke path from IDA Pro 6.5, it follows this path (on AdobePIM.dylib version 8.0.0.72):
    - _pim_installAdobeApplication
    - sub_130CA (on IDA Pro 6.5)
    - sub_124CB (on IDA Pro 6.5)
      - On sub_124CB, magic happens on 0x12D46; rerouting **jne 0x12DC1** to **jne 0x12D48** (on Cutter by Rizin) bypasses verification on ZIP-based *.pima archives.
- When I looked script invoke path from IDA Pro 9.0, it follows this path (on AdobePIM.dylib version 6.0.335.0):

  ![image](./pictures/382761533-49e3f6b3-6bde-46a1-a188-1cbcd6c392a0.png)
  
    - _pim_installPackage
    - sub_161FE
    - sub_8D28
      - On sub_8D28, magic happens on 0x956D; changing **mov [esp], eax** (on IDA Pro) to **jne 0x95D8** (on Cutter by Rizin) bypasses verification on DMG-based *.pima archives.
  - To patch dylibs:
    - Download Cutter from https://cutter.re or https://github.com/rizinorg/cutter/releases and IDA Pro 6.5 or newer on https://hex-rays.com/ida-pro
    - Install Cutter and IDA Pro 6.5 or newer.
    # - On AdobePIM.dylib (version 6.0.335.0)
      - You need to use this version for DMG-based installers (CS6 (6.x.x.x) and below) as CC 2013 (7.x.x.x) and above will use ZIP-based installers.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **corrupted**
        - Search results should be contain 4 __text and 3 __cstring addresses.

          ![image](./pictures/382758594-715bf2d1-b930-4ac6-87b6-174170b87978.png)
          
        - Click the result that's on __text:0x9597

          ![image](./pictures/386216490-b002b72c-53fe-452a-a540-f3b98df298d5.png)
          
        - 2 box before connected on box that contains the result from previous step, look for string that before on **; try {**.

          ![image](./pictures/386216749-7891c001-d64f-4a7a-a07e-133b6736824e.png)
          
        - Now you got the necessary address (in case, it's 0x956D) for changing **mov [esp], eax** (on IDA Pro) to **jne 0x95D8**.
        - Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x956D on Cutter.

          ![image](./pictures/382763183-cea7f628-20a9-4f73-8473-9a09e7ff01bd.png)
          
        - Change **mov dword [esp], eax** to **jne 0x95D8** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0x9576 but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:

          ![image](./pictures/382764940-15f588f8-8a6a-4bcc-be63-c1cfebe691e9.png)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On AdobePIM.dylib (version 8.0.0.72):
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **aSignaturePimaC**.
        - 3 box later connected on box that contains aSignaturePimaC (in case, sub_12D34 on version 8.0.0.73), look for value **jnz short loc_12DC1** (on address 0x12D46).

          ![image](./pictures/382584019-515d364e-4cf4-498e-ade5-bd23411d4a57.png)
          
        - Now, you got the necessary address for changing 0x12DC1 to 0x12D48.
        - Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x12D46 on Cutter.

          ![image](./pictures/382584238-0a9efae9-5f09-40e1-af35-d9ed1a6e43eb.png)
          
        - Change 0x12DC1 to 0x12D48 with disabling *Fill all remaining bytes with NOP opcodes*.
        - When you reload the file on Cutter, graph will turn into this:
        
          ![image](./pictures/382584567-129f8628-dc64-4229-a8a4-fca4b5834bee.png)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On AdobePIM.dylib (version 9.0.0.72)
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **corrupted**.
        - Click the result on **0x14e25**
 
          ![image](./pictures/386184090-dc82e2b5-e7dc-4d25-8411-9535ecf93eaa.png)
          
        - Find the start of the function that contains the result came from the previous step (in case, it's **0x14e25**).
 
          ![image](./pictures/386184969-3976f246-e33a-431d-bbe9-95c2656d175c.png)
          
        - Now, you got the necessary address for changing **lea eax, [ebp - 0x220]** to **jne 0x14889**.
        - Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x14E25 on Cutter.
 
          ![image](./pictures/386186705-fc96e4e5-68fe-4d46-a07c-fb0845fd4432.png)
          
        - Change **lea eax, [ebp - 0x220]** to **jne 0x14889** with disabling *Fill all remaining bytes with NOP opcodes*.
        - When you reload the file on Cutter, graph will turn into this:
       
          ![image](./pictures/386187471-0acb5b01-07f6-4e46-ab03-efc3db6afd4c.png)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On Setup.dylib (version 6.0.98.0)
      - You need to use this version for DMG-based installers (CS6 (6.x.x.x) and below) as CC 2013 (7.x.x.x) and above will use ZIP-based installers.
        - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **aSIsCorruptedFi_0**.
        - It should contain 1 __text and 1 __cstring results.

          ![image](./pictures/382784141-68a4bd77-e17f-489e-ba18-ab8bc37e010d.png)
          
        - 1 box before connected on box that contains the result from previous step, look for string that before on **; try {**.
        - Now you got the necessary address (in case, it's 0xD7CB9) for changing **mov [esp], esi** (on IDA Pro) to **jne 0xD7DC4** (on Cutter by Rizin).

          ![image](./pictures/385796032-178383df-7989-4e38-a9f5-93804de17a30.png)
          
        - Open Setup.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0xD7CB9 on Cutter.

          ![image](./pictures/382789030-bf0607bb-48ba-4cee-95f4-21fc2ca298cd.png)
          
        - Change **mov dword [esp], esi** to **jne 0xD7DC4** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0xD7CD5 but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:

          ![image](./pictures/382787946-f229aaf5-549f-475f-a22e-4cb200760c37.png)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On Setup.dylib (version 8.0.0.15)
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
      - Also, this one is pretty hard because of absence of comments (they exist in __cstring section, but not exist in __text section). But if you understand the basics, you can perform this steps on other versions of Setup.dylib with proper hexadecimal addresses for specific versions.
        - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **verifying**
        - Click the result on address 0xb7c23
       
          ![image](./pictures/393964191-6fc39d55-515e-42cd-8e63-e09bc4892199.png)
 
        - Go to address 0xb801d
       
          ![image](./pictures/393967620-cf5c66f4-b4de-4383-88f4-dbd493d294e3.png)

          - Setup.dylib binaries on macOS most probably have verification mechanism on function that contains result from previous step. On versions that doesn't contain strings, that's the location you should look.
            - On IDA Pro, here's the required visual location to call verification mechanism. On other versions, it's generally same.
              
              ![image](./pictures/393968400-ad777107-450d-4101-be07-a49f4ca864f6.png)
           
            - Required location to go is last call function on the box that viewed from previous step (in case, it's 0xb742c).
        - On function 0xb742c, go to this visual location.
         
          ![image](./pictures/393969241-a6e455ad-0f71-4ef1-b48e-af403591e09e.png)
            
        - Locate the call function that has CryptoPP in it (in case, it's 0x1861d9)
 
          ![image](./pictures/393970703-6e18d4be-f37a-4a45-bdeb-d30e638f42ac.png)
 
          - Here's the visual location.
         
            ![image](./pictures/393971132-b8601ffa-bbb1-4288-b762-4ec5a76ee65c.png)
 
        - Locate the start address of function that contains function that has CryptoPP in it (in case, it's 0xb78f7).
       
          ![image](./pictures/393971714-f0cbf602-83fc-4398-b767-78d258adac0e.png)

        - You got the necessary location to change on Cutter from **mov [esp], ebx** to **jne 0xB7AAE**.
        - Open Setup.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0xb78f7 on Cutter.
 
          ![image](./pictures/393972999-b965b3f8-b5eb-42b3-be95-7986cc93cee7.png)

        - Change **mov [esp], ebx** to **jne 0xb7aae** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0xb790e but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:
       
          ![image](./pictures/393976784-0e22ad06-494c-4044-a22d-18a5e4b0e0a6.png)

        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On Setup.dylib (version 9.0.0.10 (from Adobe Application Manager 9.0.0.72, got from Adobe Premiere Pro CC 2015))
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
      - Also, this one is pretty hard because of absence of comments (they exist in __cstring section, but not exist in __text section). But if you understand the basics, you can perform this steps on other versions of Setup.dylib with proper hexadecimal addresses for specific versions.
        - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **verifying**
        - Click the result on address 0xACB51
 
          ![image](./pictures/386202562-e1434b32-9169-4a99-957f-fb5dd4a1cd85.png)
          
        - Go to address 0xACE93.
 
          ![image](./pictures/386202954-fa431d89-de79-4176-9429-72bd5b9b94b4.png)
          
          - Setup.dylib binaries on macOS most probably have verification mechanism on function that contains result from previous step. On versions that doesn't contain strings, that's the location you should look.
            - On IDA Pro, here's the required visual location to call verification mechanism. On other versions, it's generally same. 
   
              ![image](./pictures/386204271-c09c5502-f7ad-45a5-84c8-72e3d7c72873.png)
              
            - Required location to go is last call function on the box that viewed from previous step (in case, it's 0xAC182).
        - On function 0xAC182, go to this visual location.
 
          ![image](./pictures/386206428-25c86f99-1d2a-4800-a097-955df8e3415e.png)
          
        - Locate the call function that has CryptoPP in it (in case, it's 0x201B26).
 
          ![image](./pictures/386207380-7480b045-19d2-49f6-a68c-5e0be898df66.png)
          
          - Here's the visual location:
 
            ![image](./pictures/386207670-9d3bf77b-746a-452e-9e30-229ee01018c7.png)
            
        - Locate the start address of function that contains function that has CryptoPP in it (in case, it's 0xAC537).
 
          ![image](./pictures/386209980-d909fc63-572d-441a-a966-2e3de12f47e9.png)
          
        - You got the necessary location to change on Cutter from **mov [esp], ebx** to **jne 0xAC5F4**.
        - Open Setup.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0xAC537 on Cutter.
 
          ![image](./pictures/386210794-1b1d6dc0-4035-49c7-853a-b0ab2adcac7a.png)
          
        - Change **mov [esp], ebx** to **jne 0xAC5F4** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0xAC54D but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:
 
          ![image](./pictures/386211773-6877cf80-4bf2-4344-b184-bbd2e3b659cd.png)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On Setup.dylib (version 9.0.0.65 (from Adobe Application Manager 10.0.0.47, got from Adobe Premiere Elements 15 install media))
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
        - Adobe Application Manager version 9.0.0.72 has Setup.dylib version 9.0.0.10 but required sections location was not mentioned in file.

          ![image](./pictures/385827296-b2ec2538-bf79-4d55-88a6-385a80ec0f8b.png)
          
        - But Adobe Application Manager version 10.0.0.47 has Setup.dylib version 9.0.0.65 and it mentions the required address to patch the file.

          ![image](./pictures/385841853-6e2b8fcf-2c72-4dbf-9348-77a146584196.png)
          
          - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
          - On IDA Pro, search for string **corrupted**
          - Click on result that contains **aSIsCorruptedFi_0**.

            ![image](./pictures/385825772-828b572b-2e6d-4b2b-a6d9-be6fdb2b4692.png)
            
          - Locate the largest function that's connected to box that contains result from previous step. It's usually spans some of it's content to box that contains result from previous step.
          - Locate the largest function's start address (On version 9.0.0.65, it's 0xBDAD6).

            ![image](./pictures/385826278-be045a2a-9b35-49e5-8eb3-9b77cf5625d3.png)
            
          - You got the necessary location to change on Cutter.
          - Open Setup.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
          - Jump to address 0xBDAD6 on Cutter.

            ![image](./pictures/385839032-1be8a822-2d45-4c31-913d-d92b57404528.png)
            
          - Change **mov dword [esp], ebx** to **jne 0xBDC9E** with disabling *Fill all remaining bytes with NOP opcodes*.
          - Changing will invalidate function on address 0xBDAEC but it's not going to be a problem.
          - When you reload the file on Cutter, graph will turn into this:

            ![image](./pictures/385840999-0c9351a7-c9f5-44cb-8a2d-1e8e2f188be7.png)
            
          - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On UpdaterCore.framework/Versions/A/UpdaterCore (version 9.0.0.30)
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on IDA Pro and open it with Mach-O decompiler.
      - On IDA Pro, search for string **patch is mean**
      - Click on result that contains **Patch is meant only for (very first 2 results)**.
   
        ![image](./pictures/391581571-f80b7b2c-3301-4015-8b45-1243699619c0.png)

      - Locate the very first box thats connected to result from previous step.
   
        ![image](./pictures/391582263-3270015b-6c21-467a-8a84-a0b8c1f8c0ad.png)

      - Note the address of **call $+5**.
      - Now you got necessary address to change on Cutter.
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on Cutter with experimental (aaaa) mode and in write mode (-w).
      - Jump to address 0x330ff on Cutter.
   
        ![image](./pictures/391584390-e16f2a63-1a62-41ba-886a-2f2b2b57bc6c.png)

      - Change **call 0x33104** to **jmp 0x33275** with disabling *Fill all remaining bytes with NOP opcodes*.
      - When you reload the file on Cutter, graph will turn into this:

        ![image](./pictures/391587292-a172cf6f-d5fe-48e0-9533-3c4f6113610e.png)

      - With this, you can install subscription updates on perpetually licensed apps or vice versa.
    # - On UpdaterCore.framework/Versions/A/UpdaterCore (version 8.0.0.14)
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on IDA Pro and open it with Mach-O decompiler.
      - On IDA Pro, search for string **patch is mean**
      - Click on result that contains **Patch is meant only for (very first 3 results)**.
 
        ![image](./pictures/393982288-eaadf267-29f0-44ab-892c-d75a41852590.png)

      - Locate the very first box thats connected to result from previous step.
 
        ![image](./pictures/393982603-466c5da4-8fb7-4fc6-ad27-b739ead4f328.png)
        
      - Note the address of **call $+5**.
      - Now you got necessary address to change on Cutter.
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on Cutter with experimental (aaaa) mode and in write mode (-w).
      - Jump to address 0x32c2c on Cutter.
 
        ![image](./pictures/393984051-d4f40399-0633-4802-a3e1-9c8a27ed5369.png)

      - Change **call 0x32c31** to **jmp 0x32cab** with disabling *Fill all remaining bytes with NOP opcodes*.
      - When you reload the file on Cutter, graph will turn into this:
 
        ![image](./pictures/393986337-8d7e4831-67e6-4812-a85e-1d7b23d62542.png)

      - With this, you can install subscription updates on perpetually licensed apps or vice versa.
    # - On UpdaterCore.framework/Versions/A/UpdaterCore (version 9.0.0.4)
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on IDA Pro and open it with Mach-O decompiler.
      - On IDA Pro, search for string **patch is mean**
      - Click on result that contains **Patch is meant only for (very first 2 results)**.
   
        ![image](./pictures/391608708-9fb4129b-b3cc-4414-9931-9d424f3b54bd.png)

      - Locate the very first box thats connected to result from previous step.

        ![image](./pictures/391609168-c5997033-42f5-4d45-8365-8632ef504041.png)

      - Note the address of **call $+5**.
      - Now you got necessary address to change on Cutter.
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on Cutter with experimental (aaaa) mode and in write mode (-w).
      - Jump to address 0x330bf on Cutter.

        ![image](./pictures/391610838-d1f56fc5-5257-4bbd-9851-06d3263704da.png)

      - Change **call 0x330c4** to **jmp 0x33235** with disabling *Fill all remaining bytes with NOP opcodes*.
      - When you reload the file on Cutter, graph will turn into this:
   
        ![image](./pictures/391612583-c1ca39ed-5d3b-43b9-9bcd-7fb8cd38b08c.png)

      - With this, you can install subscription updates on perpetually licensed apps or vice versa.
    # - On UpdaterCore.framework/Versions/A/UpdaterCore (version 6.0.0.67)
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on IDA Pro and open it with Mach-O decompiler.
      - On IDA Pro, search for string **patch is mean**
      - Click on result that contains **Patch is meant only for (very first 3 results)**.

        ![image](./pictures/391644502-0679b283-4f92-479b-bdf7-38cd2e4491f5.png)

      - Locate the very first box thats connected to result from previous step.

        ![image](./pictures/391644984-e4af9ddf-b32f-44dc-9a76-d9ef17545c6d.png)

      - Note the address of **call $+5**.
      - Now you got necessary address to change on Cutter.
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on Cutter with experimental (aaaa) mode and in write mode (-w).
      - Jump to address 0x2acd5 on Cutter.

        ![image](./pictures/391646064-04c80031-5c47-4816-b570-0cec0b024294.png)

      - Change **call 0x2acda** to **jmp 0x2af13** with disabling *Fill all remaining bytes with NOP opcodes*.
      - When you reload the file on Cutter, graph will turn into this:

        ![image](./pictures/391647172-1fcc10f8-2e26-4027-8d09-02af30b3b2d3.png)

      - With this, you can install subscription updates on perpetually licensed apps or vice versa.
## How to build unpacked RIBS app installer?
- I assume you got:
  - RIBS-based installer for your Adobe application.
- Extract your desired app installer to a directory.
- On **packages** folder, extract every *.pima archive or disk images to same folder where original *.pima archive or disk image is located.
  - Structure should like this:
    - packages/UWA/UWA
      - If it's *.zip archive:
        - <contentsOfUWA.pimaArchive>
      - If it's *.dmg disk image:
        - <diskLabelOfUWA.pima>
          - <contentsOfUWA.pimaDiskImage>
    - packages/UWA/UWA.sig
    - packages/UWA/UWA.pimx
- Delete original *.pima archives or disk images after extraction is done.
- On **payloads** folder, extract every *.zip archive or *.dmg disk images to same folder where original *.zip archive is located.
  - Structure should like this:
    - payloads/AdobeSpeedGrade9AllTrial/AdobeSpeedGrade9AllTrial
      - If it's *.zip archive:
        - <contentsOfAdobeSpeedGrade9AllTrial.zipArchive>
      - If it's *.dmg disk image:
        - <diskLabelOfAdobeSpeedGrade9AllTrial.dmg>
          - <contentsOfAdobeSpeedGrade9AllTrial.dmgDiskImage>
    - payloads/AdobeSpeedGrade9AllTrial/AdobeSpeedGrade9AllTrial.sig
    - <otherFilesThatDoesn'tImportant>
- Make backup of your AdobePIM.dylib.
- Patch the AdobePIM.dylib.
- Move your original AdobePIM.dylib to AdobePIM_original.dylib.
- Make backup of your packages/DECore/DECore/DE6/Setup.dylib.
- Patch the packages/DECore/DECore/DE6/Setup.dylib.
- Move your original packages/DECore/DECore/DE6/Setup.dylib to packages/DECore/DECore/DE6/Setup_original.dylib.
- Make backup of your packages/UWA/UWA/UpdaterCore.framework/Versions/A/UpdaterCore.
- Patch the packages/UWA/UWA/UpdaterCore.framework/Versions/A/UpdaterCore.
- Move your original packages/UWA/UWA/UpdaterCore.framework/Versions/A/UpdaterCore to packages/UWA/UWA/UpdaterCore.framework/Versions/A/UpdaterCore_original.
- Copy your unpacked installer to your storage server and run deduplication right after unpacked installer is copied if you want.
