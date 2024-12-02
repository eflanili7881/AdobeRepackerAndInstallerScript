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
    # - On AdobePIM.dylib (version 6.0.335.0)
      - You need to use this version for DMG-based installers (CS6 (6.x.x.x) and below) as CC 2013 (7.x.x.x) and above will use ZIP-based installers.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **corrupted**
        - Search results should be contain 4 __text and 3 __cstring addresses.

          ![image](https://github.com/user-attachments/assets/715bf2d1-b930-4ac6-87b6-174170b87978)
          
        - Click the result that's on __text:0x9597

          ![image](https://github.com/user-attachments/assets/b002b72c-53fe-452a-a540-f3b98df298d5)
          
        - 2 box before connected on box that contains the result from previous step, look for string that before on **; try {**.

          ![image](https://github.com/user-attachments/assets/7891c001-d64f-4a7a-a07e-133b6736824e)
          
        - Now you got the necessary address (in case, it's 0x956D) for changing **mov [esp], eax** (on IDA Pro) to **jne 0x95D8**.
        - Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x956D on Cutter.

          ![image](https://github.com/user-attachments/assets/cea7f628-20a9-4f73-8473-9a09e7ff01bd)
          
        - Change **mov dword [esp], eax** to **jne 0x95D8** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0x9576 but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:

          ![image](https://github.com/user-attachments/assets/15f588f8-8a6a-4bcc-be63-c1cfebe691e9)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # -  On AdobePIM.dylib (version 8.0.0.73):
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **aSignaturePimaC**.
        - 3 box later connected on box that contains aSignaturePimaC (in case, sub_12D34 on version 8.0.0.73), look for value **jnz short loc_12DC1** (on address 0x12D46).

          ![image](https://github.com/user-attachments/assets/515d364e-4cf4-498e-ade5-bd23411d4a57)
          
        - Now, you got the necessary address for changing 0x12DC1 to 0x12D48.
        - Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x12D46 on Cutter.

          ![image](https://github.com/user-attachments/assets/0a9efae9-5f09-40e1-af35-d9ed1a6e43eb)
          
        - Change 0x12DC1 to 0x12D48 with disabling *Fill all remaining bytes with NOP opcodes*.
        - When you reload the file on Cutter, graph will turn into this:
        
          ![image](https://github.com/user-attachments/assets/129f8628-dc64-4229-a8a4-fca4b5834bee)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On AdobePIM.dylib (version 9.0.0.72)
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
        - Open AdobePIM.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **corrupted**.
        - Click the result on **0x14e25**
 
          ![image](https://github.com/user-attachments/assets/dc82e2b5-e7dc-4d25-8411-9535ecf93eaa)
          
        - Find the start of the function that contains the result came from the previous step (in case, it's **0x14e25**).
 
          ![image](https://github.com/user-attachments/assets/3976f246-e33a-431d-bbe9-95c2656d175c)
          
        - Now, you got the necessary address for changing **lea eax, [ebp - 0x220]** to **jne 0x14889**.
        - Open AdobePIM.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0x14E25 on Cutter.
 
          ![image](https://github.com/user-attachments/assets/fc96e4e5-68fe-4d46-a07c-fb0845fd4432)
          
        - Change **lea eax, [ebp - 0x220]** to **jne 0x14889** with disabling *Fill all remaining bytes with NOP opcodes*.
        - When you reload the file on Cutter, graph will turn into this:
       
          ![image](https://github.com/user-attachments/assets/0acb5b01-07f6-4e46-ab03-efc3db6afd4c)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On Setup.dylib (version 6.0.98.0)
      - You need to use this version for DMG-based installers (CS6 (6.x.x.x) and below) as CC 2013 (7.x.x.x) and above will use ZIP-based installers.
        - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **aSIsCorruptedFi_0**.
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
    # - On Setup.dylib (version 9.0.0.10 (from Adobe Application Manager 9.0.0.72, got from Adobe Premiere Pro CC 2015))
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
      - Also, this one is pretty hard because of absence of comments (they exist in __cstring section, but not exist in __text section). But if you understand the basics, you can perform this steps on other versions of Setup.dylib with proper hexadecimal addresses for specific versions.
        - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
        - On IDA Pro, search for string **verifying**
        - Click the result on address 0xACB51
 
          ![image](https://github.com/user-attachments/assets/e1434b32-9169-4a99-957f-fb5dd4a1cd85)
          
        - Go to address 0xACE93.
 
          ![image](https://github.com/user-attachments/assets/fa431d89-de79-4176-9429-72bd5b9b94b4)
          
          - Setup.dylib binaries on macOS most probably have verification mechanism on function that contains result from previous step. On versions that doesn't contain strings, that's the location you should look.
            - On IDA Pro, here's the required visual location to call verification mechanism. On other versions, it's generally same. 
   
              ![image](https://github.com/user-attachments/assets/c09c5502-f7ad-45a5-84c8-72e3d7c72873)
              
            - Required location to go is last call function on the box that viewed from previous step (in case, it's 0xAC182).
        - On function 0xAC182, go to this visual location.
 
          ![image](https://github.com/user-attachments/assets/25c86f99-1d2a-4800-a097-955df8e3415e)
          
        - Locate the call function that has CryptoPP in it (in case, it's 0x201B26)
 
          ![image](https://github.com/user-attachments/assets/7480b045-19d2-49f6-a68c-5e0be898df66)
          
          - Here's the visual location:
 
            ![image](https://github.com/user-attachments/assets/9d3bf77b-746a-452e-9e30-229ee01018c7)
            
        - Locate the start address of function that contains function that has CryptoPP in it (in case, it's 0xAC537).
 
          ![image](https://github.com/user-attachments/assets/d909fc63-572d-441a-a966-2e3de12f47e9)
          
        - You got the necessary location to change on Cutter from **mov [esp], ebx** to **jne 0xAC5F4**.
        - Open Setup.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
        - Jump to address 0xAC537 on Cutter.
 
          ![image](https://github.com/user-attachments/assets/1b1d6dc0-4035-49c7-853a-b0ab2adcac7a)
          
        - Change **mov [esp], ebx** to **jne 0xAC5F4** with disabling *Fill all remaining bytes with NOP opcodes*.
        - Changing will invalidate function on address 0xAC54D but it's not going to be a problem.
        - When you reload the file on Cutter, graph will turn into this:
 
          ![image](https://github.com/user-attachments/assets/6877cf80-4bf2-4344-b184-bbd2e3b659cd)
          
        - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On Setup.dylib (version 9.0.0.65 (from Adobe Application Manager 10.0.0.47, got from Adobe Premiere Elements 15 install media))
      - You need to use this version for ZIP-based installers (CC 2013 (7.x.x.x) and above) as CS6 (6.x.x.x) and below will use DMG-based installers.
        - Adobe Application Manager version 9.0.0.72 has Setup.dylib version 9.0.0.10 but required sections location was not mentioned in file.

          ![image](https://github.com/user-attachments/assets/b2ec2538-bf79-4d55-88a6-385a80ec0f8b)
          
        - But Adobe Application Manager version 10.0.0.47 has Setup.dylib version 9.0.0.65 and it mentions the required address to patch the file.

          ![image](https://github.com/user-attachments/assets/6e2b8fcf-2c72-4dbf-9348-77a146584196)
          
          - Open Setup.dylib on IDA Pro and open it with Mach-O decompiler.
          - On IDA Pro, search for string **corrupted**
          - Click on result that contains **aSIsCorruptedFi_0**.

            ![image](https://github.com/user-attachments/assets/828b572b-2e6d-4b2b-a6d9-be6fdb2b4692)
            
          - Locate the largest function that's connected to box that contains result from previous step. It's usually spans some of it's content to box that contains result from previous step.
          - Locate the largest function's start address (On version 9.0.0.65, it's 0xBDAD6).

            ![image](https://github.com/user-attachments/assets/be045a2a-9b35-49e5-8eb3-9b77cf5625d3)
            
          - You got the necessary location to change on Cutter.
          - Open Setup.dylib on Cutter with experimental (aaaa) mode and in write mode (-w).
          - Jump to address 0xBDAD6 on Cutter.

            ![image](https://github.com/user-attachments/assets/1be8a822-2d45-4c31-913d-d92b57404528)
            
          - Change **mov dword [esp], ebx** to **jne 0xBDC9E** with disabling *Fill all remaining bytes with NOP opcodes*.
          - Changing will invalidate function on address 0xBDAEC but it's not going to be a problem.
          - When you reload the file on Cutter, graph will turn into this:

            ![image](https://github.com/user-attachments/assets/0c9351a7-c9f5-44cb-8a2d-1e8e2f188be7)
            
          - As you can see, the box that contains error condition for signature verification failure is not visible anymore.
    # - On UpdaterCore.framework/Versions/A/UpdaterCore (version 9.0.0.30)
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on IDA Pro and open it with Mach-O decompiler.
      - On IDA Pro, search for string **patch is mean**
      - Click on result that contains **Patch is meant only for (very first 2 results)**.
   
        ![image](https://github.com/user-attachments/assets/f80b7b2c-3301-4015-8b45-1243699619c0)

      - Locate the very first box thats connected to result from previous step.
   
        ![image](https://github.com/user-attachments/assets/3270015b-6c21-467a-8a84-a0b8c1f8c0ad)

      - Note the address of **call $+5**.
      - Now you got necessary address to change on Cutter.
      - Open UpdaterCore.framework/Versions/A/UpdaterCore on Cutter with experimental (aaaa) mode and in write mode (-w).
      - Jump to address 0x330ff on Cutter.
   
        ![image](https://github.com/user-attachments/assets/e16f2a63-1a62-41ba-886a-2f2b2b57bc6c)

      - Change **call 0x33104** to **jmp 0x33275** with disabling *Fill all remaining bytes with NOP opcodes*.
      - When you reload the file on Cutter, graph will turn into this:

        ![image](https://github.com/user-attachments/assets/a172cf6f-d5fe-48e0-9533-3c4f6113610e)

      - With this, you can install subscription updates on perpetually licensed apps or vice versa.
