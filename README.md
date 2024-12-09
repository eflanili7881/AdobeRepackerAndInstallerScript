# Adobe Repacker and Installer Script - (for CS3 - present)
A .bat/.sh script that compresses unpacked assets of Adobe products and installs them.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## Credits
- Me for writing script.
- Adobe Systems Incorporated for providing applications.

## What does this script do?
This script compresses all unpacked assets that present on install media folder to temporary directory set by script, copies installer engine from installation media with unpacked assets excluded via text file that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

# Latest Versions
## For RIBS-based for DMG-based (CS3 and CS4) installers on Macintosh platform - v0.3.0-ribscs3andcs4-mac-dmg rc
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc-ribscs3andcs4-dmg-mac-0.3.0
## For RIBS-based for DMG-based (CS5<=x=<CS6) installers on Macintosh platform - v0.3.0.2-ribs-mac-dmg rc
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc-ribs-dmg-mac-0.3.0.2
## For RIBS-based for ZIP-based (x>=CC2013) installers on Macintosh platform - v0.3.0.2-ribs-mac-zip rc
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc-ribs-zip-mac-0.3.0.2
## For RIBS-based for ZIP-based (x>=CC2013) installers with DMG-based components on Macintosh platform - v0.3.0.2-ribs-mac-zipwdmgcmpnts rc
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc-ribs-zipwdmgcmpnts-mac-0.3.0.2
## For RIBS-based installers on Windows platform - v0.3.0.1-ribs-win rc
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc-ribs-win-0.3.0.1
## For HyperDrive-based installers on Macintosh platform - v0.3.0.1-hd-mac rc
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc-hd-mac-0.3.0.1
## For HyperDrive-based installers on Windows platform - v0.3.0-hd-win rc
https://github.com/eflanili7881/AdobeRepackerAndInstallerScript/releases/tag/rc-hd-win-0.3.0

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
