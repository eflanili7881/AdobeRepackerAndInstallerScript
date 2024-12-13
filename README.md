# Adobe Repacker and Installer Script - (for CS3 - present)
A .bat/.sh script that compresses unpacked assets of Adobe products and installs them.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## Credits
- Adobe Systems Incorporated for providing applications.
- [GitHub](https://github.com) for hosting this project.
- [Me](https://github.com/eflanili7881) for writing script and patching HyperDrive-based installers from knowledge I gained from PainteR's patched binaries.
- [Microsoft Copilot](https://copilot.microsoft.com) and [OpenAI ChatGPT](https://chat.openai.com) for helping me on generating complex scripts (I wrote this script myself, but I don't say no to little help from AI :D).
- [Internet Archive](https://archive.org) for providing [Wayback Machine](https://web.archive.org) service.
- PainteR for patching various binaries based on Windows platform (RIBS-based installers), so I can understand verification algorithm on newer or older binaries and even on macOS-based binaries and HyperDrive-based installers.
- [Rizin](https://rizin.re) for [Cutter](https://cutter.re) reverse engineering program.
- [Hex-Rays](https://hex-rays.com/) for [IDA Pro](https://hex-rays.com/ida-pro) reverse engineering program.
- [bkcrack](https://github.com/kimci86/bkcrack) by [kimci86](https://github.com/kimci86) for ZipCrypto cracking software.
- [DB Browser for SQLite](https://sqlitebrowser.org) for editing and viewing various *.db databases.
- [Maël Hörz](https://mh-nexus.de) for [HxD Hex Editor](https://mh-nexus.de/en/hxd) hexadecimal viewing program.

## What does this script do?
This script compresses all unpacked assets that present on install media folder to temporary directory set by script, copies installer engine from installation media with unpacked assets excluded via text file that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

# Latest Versions
## For RIBS-based installers on Macintosh platform - v0.4.0-ribs-mac rc2
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc2-ribs-mac-0.4.0
## For RIBS-based installers on Windows platform - v0.4.0-ribs-win rc2
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc2-ribs-win-0.4.0
## For HyperDrive-based installers on Macintosh platform - v0.4.0-hd-mac rc2
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc2-hd-mac-0.4.0
## For HyperDrive-based installers on Windows platform - v0.4.0-hd-win rc2
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc2-hd-win-0.4.0

# Branches
## For HyperDrive (HD)-based installers on Macintosh platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/HyperDrive-mac
## For patched HyperDrive binaries on Macintosh platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/HyperDrive-mac-patchedbins
## For HyperDrive (HD)-based installers on Windows platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/HyperDrive-win
## Fot patched HyperDrive binaries on Windows platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/HyperDrive-win-patchedbins
## For RIBS-based installers on Macintosh platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/RIBS-mac
## For patched RIBS binaries on Macintosh platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/RIBS-mac-patchedbins
## For RIBS-based installers on Windows platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/RIBS-win
## For patched RIBS binaries on Windows platform
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/tree/RIBS-win-patchedbins
