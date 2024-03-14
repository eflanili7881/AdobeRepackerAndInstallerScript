# Adobe Repacker and Installer Script - RIBS for Windows (for CS5 - CC 2015)
A .bat script that compresses unpacked Adobe RIBS assets and installs them.

# CAUTION!
Please, don't use this script for piracy things. I wrote this script for who wants to store RIBS-based Adobe application installers with unpacked assets for various reasons. My reason was maximize deduplication ratings on my Windows Server Storage Spaces storage to store more programs. That's why I wrote this script. I will improve this script day by day.

## What does this script do?
This script compresses all unpacked assets that present on "payloads" and "packages" folder to temporary directory set by script, copies RIBS installer engine from installation media with unpacked assets excluded via excludepackages.txt and excludepayloads.txt that's generated via script and invokes Set-up.exe on temporary directory set by script to install repacked product.

## Special note
- Unlike HyperDrive-based installers, with patched AdobePIM.dll, *.pima archives under "packages" folder can be repacked. With original AdobePIM.dll and repacked *.pima archive, it throws error on initializing setup phase on very beginning about Adobe Genuine Software Verification failure.
  - You'll need packages, resources folder and Setup.exe (rename this file later as Set-up.exe, only on d!akov packages.) file from one of the RIBS-based d!akov or m0nkrus (On m0nkrus, take Set-up.exe, this will be same name like original installer unlike d!akov repacks, that has Setup.exe instead of Set-up.exe.). Unfortunately, this is the currently only way to install repacked RIBS assets. Original RIBS install engine throws error about software may counterfeit. Do not take "payloads" folder from d!akov repack because it contains pirated application. But we need the only install engine of d!akov to install our repacked assets.
    - You can manually patch legit Adobe RIBS installer by replacing this files from d!akov or m0nkrus distributions on RIBS-based legit installer engine:
      | Binary Version   | Binary Path                               | Binary Purpose                                                               |
      | :--------------: | :---------------------------------------: | :--------------------------------------------------------------------------: |
      | version 8.0.0.15 | packages\DECore\DECore.pima\DE6\Setup.dll | Allows custom asset archives to be installed.                                |
      | version 8.0.0.14 | packages\UWA\UWA.pima\updatercore.dll     | (?) Allows custom asset archives to be installed (only on updates, I guess). |
      | version 8.0.0.73 | resources\AdobePIM.dll                    | Allows repacked *.pima archives from packages folder to be loaded.           |
      - You can only manually patch 8.x.x.x (CC 2014 series) installer engine and above. 7.x.x.x (CC 2013) and below gives almost instant error and when you open summary.html or htm that installer generated, there is only System Requirements wrote as a link.
        - For Creative Cloud Packager, only replacing AdobePIM.dll on resources folder is enough and it doesn't throw any error. Replacing Setup.dll and updatercore.dll isn't necessary.
      - If \payloads\Media_db.db\PayloadData\ *(any payload id that has higher version than **8.0.0.15** on **value** column)* \PayloadInfo is greater than 8.0.0.15, installer throws this error on logs in example for SpeedGrade CC 2015 with 8.x.x.x engine:
        - *ERROR: DW021: Payload {8FD7F1DB-7355-469E-A3F2-2118148D8477} DVA Adobe SpeedGrade CC 2015 9.0.0.0 of version: 9.0.0.6 is not supported by this version: 8.0.0.15 of RIBS.*
          - This can be fixed with SQLite DB Browser.
            - Download this program from https://sqlitebrowser.org/dl/
              - Or if that page isn't available, but direct links are accessible:
                - Download version 3.12.2 Windows 32-bit MSI installer from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.msi .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308102559/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.msi
                - Download version 3.12.2 Windows 32-bit portable from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.zip .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308102755/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win32.zip
                - Download version 3.12.2 Windows 64-bit MSI installer from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.msi .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308102852/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.msi
                - Download version 3.12.2 Windows 64-bit portable from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.zip .
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308103002/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2-win64.zip
                - Download version 3.12.2 macOS Intel from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2.dmg if Windows application isn't working.
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308103609/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-3.12.2.dmg
                - Download version 3.12.2 macOS Apple Silicon from https://download.sqlitebrowser.org/DB.Browser.for.SQLite-arm64-3.12.2.dmg if Windows application isn't working.
                  - If this link is deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308104038/https://download.sqlitebrowser.org/DB.Browser.for.SQLite-arm64-3.12.2.dmg
            - While payloads\Media_db.db is opened, go to "Execute SQL" tab.
            - Than paste these 2 commands to separate lines:
              - update PayloadData **(do not execute command here.)**
              - set Value = replace(value, '9.0.0.6', '8.0.0.15') **(execute command here.)**
            - This will replace any 9.0.0.6 with 8.0.0.15. You may change these versions depending on product you're gonna installing.
  - CS5.5 and CS5 do not require patching AdobePIM.dll to install repacked assets. Also, *.pima archives under "packages" directory can be repacked on CS5.5 and CS5 installers with original AdobePIM.dll. Because CS5.5 and below RIBS installer engines doesn't have file verification.
    - But some packages will be protected and they cannot be unpacked via 7-Zip. These packages will prompt for password if they tried to unpacked. Only RIBS installer engine can unpack these packages.
      - These packages are:
        - AdobeAfterEffects10.5ProtectedAll
        - AdobeAfterEffects10ProtectedAll
        - AdobeAfterEffects10RoyaltyAll
        - AdobeEncore5RoyaltyAll
        - AdobeOnLocation5.1ProtectedAll
        - AdobeOnLocation5ProtectedAll
        - AdobeOnLocation5RoyaltyAll
        - AdobePresenter706-AS_PC-mul
        - AdobePremierePro5ProtectedAll
        - AdobePremierePro5RoyaltyAll
        - AdobeSoundbooth3ProtectedAll
        - AdobeSoundbooth3RoyaltyAll
        - AMEDolby5All
        - AMEDolby5All_x64
        - AMEPCI5All
        - AMEPCI5All_x64
  - Despite with patched AdobePIM.dll that *.pima archives can be unpacked, minimal package set for just installing application with legit RIBS installer engine is this (with pirating, unfortunately (This package set gives error about Adobe Application Manager when application launches. If application is pirated, when you click OK, application will start with no problem.).):
    - core
    - D6
    - DECore
    - UWA
    - But if you want to use your legit license, it's all packages above with that extra package:
      - P6
- CS4 and CS3 doesn't require this script. Payloads stored as MSI installer and no verification is present except for protected ones (?). If installer assets unpacked via "msiexec /a" and replacing packed assets with unpacked ones, installer will install our unpacked assets with an honor.

## Requirements
- On default settings, you'll need 7-Zip installed on "C:\Program Files\7-Zip". But you can edit install.bat to change 7-Zip's location currently. I may update script to detect 7-Zip's install location by reading registry.
- Latest PowerShell for Windows XP(/x64)/Server 2003(/R2)(/x64)/Vista(/x64)/Server 2008/(/x64). Windows 7 and above comes with PowerShell by default.

## Limitations
- ZIP file must not exceed 2 GB. I tested this with HyperDrive installer engine and it throwed error. But I didn't tested this with RIBS engine. May it supports 2 GB+ files or not. Proceed with caution.
- If original Adobe CC 2015 application is installed with original RIBS engine, use install-admin-existing.bat. You need to run this file as administrator for temporarily replacing OOBE folder on C:\Program Files\Common Files\Adobe. This folder is where the installer engine is. If no Adobe application was installed before, use install-fresh.bat. You can run this file as normal user.

## About MSI-based RIBS Applications
- CS4 and CS3's protected content can be unpacked unlike in CS5 and above, but installer will throw error on initialization phase. If you look installer logs, you will see i.e. AdobeAfterEffects9ProtectedAll was failed error 1603. I think it's also valid for CS3.
  - Interestingly on my tests with CS4, if protected content's payload path is beyond MAX_PATH variable, initialization phase is continued like nothing happened. But installer will fail gradually when installer tries to install protected unpacked content. My theory was installer engine is so old that skips paths that beyond MAX_PATH limit on initialization phase, but on installation phase, it doesn't and it will fail.
- With more interesting thing, above 2 statements, Adobe Premiere Pro CS4 was installed successfully, with unpacked protected contents. I think this problem was about invalid character problem that Adobe After Effects CS4 Protected Contents' unpacked assets path that contains or this problem was specifically for After Effects. Currently not unpackable assets are:
  - CS4
    - AdobeAfterEffects9ProtectedAll
      - Package normally unpackable, but it throws error 1603 while initialization phase.
      - Not on standalone program, but on Master Collection and likely on other suites that contains this package, throws error 1304 about copying file. Even if you try to click "Retry", it throws internal error 2350 and unpack fails.
        - When I installed After Effects CS4, I guess it's unpackable, but it writes few extra bytes to every file and corrupts them.
        - I unpacked all files and manually put them in appropiate locations. But it still throws error in initialization phase. Here's the complete file list including MSI file:
        ```
        C:.
        ¦   AdobeAfterEffects9ProtectedAll.msi
        ¦   
        +---Common
        ¦   +---Adobe
        ¦       +---Keyfiles
        ¦           +---AfterEffects
        ¦               ¦   ae_app_icon.png
        ¦               ¦   ae_install_pkg_rev.ico
        ¦               ¦   ae_ribs_bgd.png
        ¦               ¦   
        ¦               +---pc
        ¦                       SystemRequirements
        ¦                       
        +---program files
            +---Adobe
                +---Adobe After Effects CS4
                    +---Mocha
                    ¦   +---bin
                    ¦   ¦       dvsoem.dll
                    ¦   ¦       Gandalf.dll
                    ¦   ¦       Isildur.dll
                    ¦   ¦       Luthien.dll
                    ¦   ¦       Mocha For After Effects.exe
                    ¦   ¦       msvcp71.dll
                    ¦   ¦       msvcr71.dll
                    ¦   ¦       Oberon.dll
                    ¦   ¦       Qt3Support4.dll
                    ¦   ¦       QtCore4.dll
                    ¦   ¦       QtDesignerComponents4.dll
                    ¦   ¦       QtGui4.dll
                    ¦   ¦       QtNetwork4.dll
                    ¦   ¦       QtOpenGL4.dll
                    ¦   ¦       QtSql4.dll
                    ¦   ¦       QtXml4.dll
                    ¦   ¦       version
                    ¦   ¦       
                    ¦   +---help
                    ¦           MochaForAfterEffectsGuide.pdf
                    ¦           MochaForAfterEffectsReleaseNotes.pdf
                    ¦           
                    +---Support Files
                        ¦   ad2mcdsmpeg.ax
                        ¦   ad2mceampeg.ax
                        ¦   ad2mcesmpeg.ax
                        ¦   ad2mcevmpeg.ax
                        ¦   ad2mcmpgdec.dll
                        ¦   ad2mcmuxmpeg.ax
                        ¦   ad2mcspmpeg.ax
                        ¦   ad2mpegin.dll
                        ¦   ad2mpgaout.dll
                        ¦   ad2mpgcap32.dll
                        ¦   ad2mpgcheck.dll
                        ¦   ad2mpgdec.dll
                        ¦   ad2mpgmux.dll
                        ¦   ad2mpgvout.001
                        ¦   ad2mpgvout.002
                        ¦   ad2mpgvout.003
                        ¦   ad2mpgvout.004
                        ¦   ad2mpgvout.dll
                        ¦   ad2mpg_dlg.dll
                        ¦   ad2pcmaout.dll
                        ¦   ad2sr_wrap.dll
                        ¦   IPPMPEGDecoder.dll
                        ¦   
                        +---(Media Core plug-ins)
                        ¦   +---Common
                        ¦           ImporterFastMPEG.prm
                        ¦           ImporterMPEG.prm
                        ¦           ImporterXDCAMEX.prm
                        ¦           ImporterXDCAMHD.prm
                        ¦           
                        +---Legal
                        ¦   +---de_DE
                        ¦   ¦       license.html
                        ¦   ¦       
                        ¦   +---en_US
                        ¦   ¦       license.html
                        ¦   ¦       
                        ¦   +---es_ES
                        ¦   ¦       license.html
                        ¦   ¦       
                        ¦   +---fr_FR
                        ¦   ¦       license.html
                        ¦   ¦       
                        ¦   +---it_IT
                        ¦   ¦       license.html
                        ¦   ¦       
                        ¦   +---ja_JP
                        ¦   ¦       license.html
                        ¦   ¦       
                        ¦   +---ko_KR
                        ¦           license.html
                        ¦           
                        +---Plug-ins
                            +---Effects
                            ¦   +---CycoreFX
                            ¦   ¦       BallAction.aex
                            ¦   ¦       Bender.aex
                            ¦   ¦       BendIt.aex
                            ¦   ¦       Blobbylize.aex
                            ¦   ¦       Bubbles.aex
                            ¦   ¦       BurnFilm.aex
                            ¦   ¦       ColorOffset.aex
                            ¦   ¦       Composite.aex
                            ¦   ¦       Cylinder.aex
                            ¦   ¦       Drizzle.aex
                            ¦   ¦       FloMotion.aex
                            ¦   ¦       ForceMB.aex
                            ¦   ¦       Glass.aex
                            ¦   ¦       GlassWipe.aex
                            ¦   ¦       GlueGun.aex
                            ¦   ¦       Griddler.aex
                            ¦   ¦       GridWipe.aex
                            ¦   ¦       Hair.aex
                            ¦   ¦       ImageWipe.aex
                            ¦   ¦       Jaws.aex
                            ¦   ¦       Kaleida.aex
                            ¦   ¦       Lens.aex
                            ¦   ¦       LightBurst.aex
                            ¦   ¦       LightRays.aex
                            ¦   ¦       LightSweep.aex
                            ¦   ¦       LightWipe.aex
                            ¦   ¦       MrMercury.aex
                            ¦   ¦       MrSmoothie.aex
                            ¦   ¦       PageTurn.aex
                            ¦   ¦       ParticleSystems.aex
                            ¦   ¦       ParticleSystemsII.aex
                            ¦   ¦       ParticleSystemsLE.aex
                            ¦   ¦       PixelPolly.aex
                            ¦   ¦       PowerPin.aex
                            ¦   ¦       PW.aex
                            ¦   ¦       RadialBlur.aex
                            ¦   ¦       RadialFastBlur.aex
                            ¦   ¦       RadialScaleWipe.aex
                            ¦   ¦       Rain.aex
                            ¦   ¦       RepeTile.aex
                            ¦   ¦       RipplePulse.aex
                            ¦   ¦       ScaleWipe.aex
                            ¦   ¦       Scatterize.aex
                            ¦   ¦       SimpleWireRemove.aex
                            ¦   ¦       Slant.aex
                            ¦   ¦       Smear.aex
                            ¦   ¦       Snow.aex
                            ¦   ¦       Sphere.aex
                            ¦   ¦       Split.aex
                            ¦   ¦       Split2.aex
                            ¦   ¦       Spotlight.aex
                            ¦   ¦       StarBurst.aex
                            ¦   ¦       Threshold.aex
                            ¦   ¦       ThresholdRGB.aex
                            ¦   ¦       Tiler.aex
                            ¦   ¦       TimeBlend.aex
                            ¦   ¦       TimeBlendFX.aex
                            ¦   ¦       Toner.aex
                            ¦   ¦       Twister.aex
                            ¦   ¦       VectorBlur.aex
                            ¦   ¦       WideTime.aex
                            ¦   ¦       
                            ¦   +---Foundry
                            ¦   ¦   ¦   Keylight.aex
                            ¦   ¦   ¦   KeylightObsolete.aex
                            ¦   ¦   ¦   Splash.bmp
                            ¦   ¦   ¦   
                            ¦   ¦   +---docs
                            ¦   ¦           Keylight.pdf
                            ¦   ¦           
                            ¦   +---Synthetic Aperture
                            ¦       ¦   SA Color Finesse 2.aex
                            ¦       ¦   
                            ¦       +---(Color Finesse 2 Support)
                            ¦           +---Color Finesse 2
                            ¦               ¦   CF2ProcessWin.dll
                            ¦               ¦   Color Finesse 2 Plug-in Users Guide.pdf
                            ¦               ¦   Preset Sample Image.png
                            ¦               ¦   Read Me.rtf
                            ¦               ¦   Register Color Finesse.pdf
                            ¦               ¦   SA Color Finesse 2 UI.exe
                            ¦               ¦   SftTree_IX86_A_50.dll
                            ¦               ¦   Software License.rtf
                            ¦               ¦   
                            ¦               +---Color Finesse Presets
                            ¦                   +---35mm Filmstocks
                            ¦                   ¦       Eastman 5222 Double-X B&W.cfpreset
                            ¦                   ¦       Eastman 5231 Plus-X B&W.cfpreset
                            ¦                   ¦       Eastman 5245 EXR 50D.cfpreset
                            ¦                   ¦       Eastman 5248 EXR 100T.cfpreset
                            ¦                   ¦       Eastman 5293 EXR 200T.cfpreset
                            ¦                   ¦       Eastman 5298 EXR 500T.cfpreset
                            ¦                   ¦       Kodak 5246 Vision 250D.cfpreset
                            ¦                   ¦       Kodak 5247 Vision 200T.cfpreset
                            ¦                   ¦       Kodak 5277 Vision 320T.cfpreset
                            ¦                   ¦       Kodak 5279 500T.cfpreset
                            ¦                   ¦       Kodak 5620 Primetime 640T.cfpreset
                            ¦                   ¦       Kodak SFX 200T.cfpreset
                            ¦                   ¦       
                            ¦                   +---Filters
                            ¦                   ¦       Coral 3 (Tiffen).cfpreset
                            ¦                   ¦       Tobacco 1 (Tiffen).cfpreset
                            ¦                   ¦       
                            ¦                   +---Gels
                            ¦                   ¦   +---GamColor
                            ¦                   ¦   ¦       GamColor_101_Lavender Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_103_Blue Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_105X_3-4 Antique Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_105_Antique Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_106_1-2 Antique Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_107_1-4 Antique Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_108_1-8 Antique Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_110_Dark Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_120_Bright Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_130_Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_135_Soft Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_140_Dark Magenta.cfpreset
                            ¦                   ¦   ¦       GamColor_150_Pink Punch.cfpreset
                            ¦                   ¦   ¦       GamColor_155_Light Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_160_Chorus Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_170_Dark Flesh Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_180_Cherry.cfpreset
                            ¦                   ¦   ¦       GamColor_190_Cold Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_195_Nymph Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_220_Pink Magenta.cfpreset
                            ¦                   ¦   ¦       GamColor_235_Pink Red.cfpreset
                            ¦                   ¦   ¦       GamColor_245_Light Red.cfpreset
                            ¦                   ¦   ¦       GamColor_250_Medium Red XT.cfpreset
                            ¦                   ¦   ¦       GamColor_260_Rosy Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_270_Red Orange.cfpreset
                            ¦                   ¦   ¦       GamColor_280_Fire Red.cfpreset
                            ¦                   ¦   ¦       GamColor_290_Fire Orange.cfpreset
                            ¦                   ¦   ¦       GamColor_305_French Rose.cfpreset
                            ¦                   ¦   ¦       GamColor_315_Autumn Glory.cfpreset
                            ¦                   ¦   ¦       GamColor_320_Peach.cfpreset
                            ¦                   ¦   ¦       GamColor_323_Indian Summer.cfpreset
                            ¦                   ¦   ¦       GamColor_324_Dark Bastard Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_325_Bastard Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_330_Sepia.cfpreset
                            ¦                   ¦   ¦       GamColor_335_Coral.cfpreset
                            ¦                   ¦   ¦       GamColor_340_Light Bastard Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_343_Honey.cfpreset
                            ¦                   ¦   ¦       GamColor_345_Deep Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_350_Dark Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_355_Amber Flame.cfpreset
                            ¦                   ¦   ¦       GamColor_360_Amber Blush.cfpreset
                            ¦                   ¦   ¦       GamColor_363_Sand.cfpreset
                            ¦                   ¦   ¦       GamColor_364_Pale Honey.cfpreset
                            ¦                   ¦   ¦       GamColor_365_Warm Straw.cfpreset
                            ¦                   ¦   ¦       GamColor_370_Spice.cfpreset
                            ¦                   ¦   ¦       GamColor_375_Flame.cfpreset
                            ¦                   ¦   ¦       GamColor_380_Golden Tan.cfpreset
                            ¦                   ¦   ¦       GamColor_382_Brass.cfpreset
                            ¦                   ¦   ¦       GamColor_385_Light Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_388_Gold Rush.cfpreset
                            ¦                   ¦   ¦       GamColor_390_Walnut.cfpreset
                            ¦                   ¦   ¦       GamColor_395_Golden Sunset.cfpreset
                            ¦                   ¦   ¦       GamColor_410_Yellow Gold.cfpreset
                            ¦                   ¦   ¦       GamColor_420_Medium Amber.cfpreset
                            ¦                   ¦   ¦       GamColor_435_Ivory.cfpreset
                            ¦                   ¦   ¦       GamColor_440_Very Light Straw.cfpreset
                            ¦                   ¦   ¦       GamColor_450_Saffron.cfpreset
                            ¦                   ¦   ¦       GamColor_455_Yellow Sun.cfpreset
                            ¦                   ¦   ¦       GamColor_460_Mellow Yellow.cfpreset
                            ¦                   ¦   ¦       GamColor_470_Pale Gold.cfpreset
                            ¦                   ¦   ¦       GamColor_475_Pale Yellow.cfpreset
                            ¦                   ¦   ¦       GamColor_480_Medium Yellow.cfpreset
                            ¦                   ¦   ¦       GamColor_510_No Color Straw.cfpreset
                            ¦                   ¦   ¦       GamColor_515_Lime Yellow.cfpreset
                            ¦                   ¦   ¦       GamColor_520_New Straw.cfpreset
                            ¦                   ¦   ¦       GamColor_525_Lime Sun.cfpreset
                            ¦                   ¦   ¦       GamColor_535_Lime.cfpreset
                            ¦                   ¦   ¦       GamColor_540_Pale Green.cfpreset
                            ¦                   ¦   ¦       GamColor_570_Light Green Yellow.cfpreset
                            ¦                   ¦   ¦       GamColor_650_Grass Green.cfpreset
                            ¦                   ¦   ¦       GamColor_655_Rich Green.cfpreset
                            ¦                   ¦   ¦       GamColor_660_Medium Green.cfpreset
                            ¦                   ¦   ¦       GamColor_680_Kelly Green.cfpreset
                            ¦                   ¦   ¦       GamColor_685_Pistachio.cfpreset
                            ¦                   ¦   ¦       GamColor_690_Bluegrass.cfpreset
                            ¦                   ¦   ¦       GamColor_710_Blue Green.cfpreset
                            ¦                   ¦   ¦       GamColor_720_Light Steel Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_725_Princess Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_730_Azure Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_740_Off Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_750_Nile Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_760_Aqua Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_770_Christel Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_780_Shark Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_790_Electric Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_810_Moon Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_815_Moody Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_820_Full Light Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_830_North Sky Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_835_Aztec Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_840_Steel Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_841_Diamond Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_842_Whisper Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_845_Cobalt.cfpreset
                            ¦                   ¦   ¦       GamColor_847_City Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_848_Bonus Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_850_Blue Primary.cfpreset
                            ¦                   ¦   ¦       GamColor_860_Sky Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_870_Winter White.cfpreset
                            ¦                   ¦   ¦       GamColor_880_Daylight Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_882_Southern Sky.cfpreset
                            ¦                   ¦   ¦       GamColor_885_Blue Ice.cfpreset
                            ¦                   ¦   ¦       GamColor_888_Blue Belle.cfpreset
                            ¦                   ¦   ¦       GamColor_890_Dark Sky Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_905_Dark Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_910_Alice Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_915_Twilight.cfpreset
                            ¦                   ¦   ¦       GamColor_920_Pale Lavender.cfpreset
                            ¦                   ¦   ¦       GamColor_925_Cosmic Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_930_Real Congo Blue.cfpreset
                            ¦                   ¦   ¦       GamColor_940_Light Purple.cfpreset
                            ¦                   ¦   ¦       GamColor_945_Royal Purple.cfpreset
                            ¦                   ¦   ¦       GamColor_948_African Violet.cfpreset
                            ¦                   ¦   ¦       GamColor_950_Purple.cfpreset
                            ¦                   ¦   ¦       GamColor_960_Medium Lavender.cfpreset
                            ¦                   ¦   ¦       GamColor_970_Special Lavender.cfpreset
                            ¦                   ¦   ¦       GamColor_980_Surprise Pink.cfpreset
                            ¦                   ¦   ¦       GamColor_985_Ripe Plum.cfpreset
                            ¦                   ¦   ¦       GamColor_987_Wild Plum.cfpreset
                            ¦                   ¦   ¦       GamColor_990_Dark Lavender.cfpreset
                            ¦                   ¦   ¦       GamColor_995_Orchid.cfpreset
                            ¦                   ¦   ¦       
                            ¦                   ¦   +---GamColor CineFilters
                            ¦                   ¦   ¦       GamColor CineFilters_1565_MTY.cfpreset
                            ¦                   ¦   ¦       GamColor CineFilters_1570_MT2.cfpreset
                            ¦                   ¦   ¦       
                            ¦                   ¦   +---Lee
                            ¦                   ¦   ¦       Lee_002_Rose Pink.cfpreset
                            ¦                   ¦   ¦       Lee_003_Lavender Tint.cfpreset
                            ¦                   ¦   ¦       Lee_004_Medium Bastard Amber.cfpreset
                            ¦                   ¦   ¦       Lee_007_Pale Yellow.cfpreset
                            ¦                   ¦   ¦       Lee_008_Dark Salmon.cfpreset
                            ¦                   ¦   ¦       Lee_009_Pale Amber Gold.cfpreset
                            ¦                   ¦   ¦       Lee_010_Medium Yellow.cfpreset
                            ¦                   ¦   ¦       Lee_013_Straw Tint.cfpreset
                            ¦                   ¦   ¦       Lee_015_Deep Straw.cfpreset
                            ¦                   ¦   ¦       Lee_017_Surprise Peach.cfpreset
                            ¦                   ¦   ¦       Lee_019_Fire.cfpreset
                            ¦                   ¦   ¦       Lee_020_Medium Amber.cfpreset
                            ¦                   ¦   ¦       Lee_021_Gold Amber.cfpreset
                            ¦                   ¦   ¦       Lee_022_Dark Amber.cfpreset
                            ¦                   ¦   ¦       Lee_024_Scarlet.cfpreset
                            ¦                   ¦   ¦       Lee_025_Sunset Red.cfpreset
                            ¦                   ¦   ¦       Lee_026_Bright Red.cfpreset
                            ¦                   ¦   ¦       Lee_027_Medium Red.cfpreset
                            ¦                   ¦   ¦       Lee_035_Light Pink.cfpreset
                            ¦                   ¦   ¦       Lee_036_Medium Pink.cfpreset
                            ¦                   ¦   ¦       Lee_046_Dark Magenta.cfpreset
                            ¦                   ¦   ¦       Lee_048_Rose Purple.cfpreset
                            ¦                   ¦   ¦       Lee_052_Light Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_053_Paler Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_058_Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_061_Mist Blue.cfpreset
                            ¦                   ¦   ¦       Lee_063_Pale Blue.cfpreset
                            ¦                   ¦   ¦       Lee_068_Sky Blue.cfpreset
                            ¦                   ¦   ¦       Lee_079_Just Blue.cfpreset
                            ¦                   ¦   ¦       Lee_085_Deeper Blue.cfpreset
                            ¦                   ¦   ¦       Lee_088_Lime Green.cfpreset
                            ¦                   ¦   ¦       Lee_089_Moss Green.cfpreset
                            ¦                   ¦   ¦       Lee_090_Dark Yellow Green.cfpreset
                            ¦                   ¦   ¦       Lee_100_Spring Yellow.cfpreset
                            ¦                   ¦   ¦       Lee_101_Yellow.cfpreset
                            ¦                   ¦   ¦       Lee_102_Light Amber.cfpreset
                            ¦                   ¦   ¦       Lee_103_Straw.cfpreset
                            ¦                   ¦   ¦       Lee_104_Deep Amber.cfpreset
                            ¦                   ¦   ¦       Lee_105_Orange.cfpreset
                            ¦                   ¦   ¦       Lee_106_Primary Red.cfpreset
                            ¦                   ¦   ¦       Lee_107_Light Rose.cfpreset
                            ¦                   ¦   ¦       Lee_108_English Rose.cfpreset
                            ¦                   ¦   ¦       Lee_109_Light Salmon.cfpreset
                            ¦                   ¦   ¦       Lee_110_Middle Rose.cfpreset
                            ¦                   ¦   ¦       Lee_111_Dark Pink.cfpreset
                            ¦                   ¦   ¦       Lee_113_Magenta.cfpreset
                            ¦                   ¦   ¦       Lee_115_Peacock Blue.cfpreset
                            ¦                   ¦   ¦       Lee_116_Medium Blue-Green.cfpreset
                            ¦                   ¦   ¦       Lee_117_Steel Blue.cfpreset
                            ¦                   ¦   ¦       Lee_118_Light Blue.cfpreset
                            ¦                   ¦   ¦       Lee_119_Dark Blue.cfpreset
                            ¦                   ¦   ¦       Lee_120_Deep Blue.cfpreset
                            ¦                   ¦   ¦       Lee_121_Lee Green.cfpreset
                            ¦                   ¦   ¦       Lee_122_Fern Green.cfpreset
                            ¦                   ¦   ¦       Lee_124_Dark Green.cfpreset
                            ¦                   ¦   ¦       Lee_126_Mauve.cfpreset
                            ¦                   ¦   ¦       Lee_127_Smokey Pink.cfpreset
                            ¦                   ¦   ¦       Lee_128_Bright Pink.cfpreset
                            ¦                   ¦   ¦       Lee_131_Marine Blue.cfpreset
                            ¦                   ¦   ¦       Lee_132_Medium Blue.cfpreset
                            ¦                   ¦   ¦       Lee_134_Golden Amber.cfpreset
                            ¦                   ¦   ¦       Lee_135_Deep Golden Amber.cfpreset
                            ¦                   ¦   ¦       Lee_136_Pale Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_137_Special Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_138_Pale Green.cfpreset
                            ¦                   ¦   ¦       Lee_139_Primary Green.cfpreset
                            ¦                   ¦   ¦       Lee_140_Summer Blue.cfpreset
                            ¦                   ¦   ¦       Lee_141_Bright Blue.cfpreset
                            ¦                   ¦   ¦       Lee_142_Pale Violet.cfpreset
                            ¦                   ¦   ¦       Lee_143_Pale Navy Blue.cfpreset
                            ¦                   ¦   ¦       Lee_144_No Colour Blue.cfpreset
                            ¦                   ¦   ¦       Lee_147_Apricot.cfpreset
                            ¦                   ¦   ¦       Lee_148_Bright Rose.cfpreset
                            ¦                   ¦   ¦       Lee_151_Gold Tint.cfpreset
                            ¦                   ¦   ¦       Lee_152_Pale Gold.cfpreset
                            ¦                   ¦   ¦       Lee_153_Pale Salmon.cfpreset
                            ¦                   ¦   ¦       Lee_154_Pale Rose.cfpreset
                            ¦                   ¦   ¦       Lee_156_Chocolate.cfpreset
                            ¦                   ¦   ¦       Lee_157_Pink.cfpreset
                            ¦                   ¦   ¦       Lee_158_Deep Orange.cfpreset
                            ¦                   ¦   ¦       Lee_159_No Colour Straw.cfpreset
                            ¦                   ¦   ¦       Lee_161_Slate Blue.cfpreset
                            ¦                   ¦   ¦       Lee_162_Bastard Amber.cfpreset
                            ¦                   ¦   ¦       Lee_164_Flame Red.cfpreset
                            ¦                   ¦   ¦       Lee_165_Daylight Blue.cfpreset
                            ¦                   ¦   ¦       Lee_166_Pale Red.cfpreset
                            ¦                   ¦   ¦       Lee_169_Lilac Tint.cfpreset
                            ¦                   ¦   ¦       Lee_170_Deep Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_172_Lagoon Blue.cfpreset
                            ¦                   ¦   ¦       Lee_174_Dark Steel Blue.cfpreset
                            ¦                   ¦   ¦       Lee_176_Loving Amber.cfpreset
                            ¦                   ¦   ¦       Lee_179_Chrome Orange.cfpreset
                            ¦                   ¦   ¦       Lee_180_Dark Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_181_Congo Blue.cfpreset
                            ¦                   ¦   ¦       Lee_182_Light Red.cfpreset
                            ¦                   ¦   ¦       Lee_183_Moonlight Blue.cfpreset
                            ¦                   ¦   ¦       Lee_192_Flesh Pink.cfpreset
                            ¦                   ¦   ¦       Lee_193_Rosy Amber.cfpreset
                            ¦                   ¦   ¦       Lee_194_Surprise Pink.cfpreset
                            ¦                   ¦   ¦       Lee_195_Zenith Blue.cfpreset
                            ¦                   ¦   ¦       Lee_196_True Blue.cfpreset
                            ¦                   ¦   ¦       Lee_197_Alice Blue.cfpreset
                            ¦                   ¦   ¦       Lee_198_Palace Blue.cfpreset
                            ¦                   ¦   ¦       Lee_200_Double CT Blue.cfpreset
                            ¦                   ¦   ¦       Lee_201_Full CT Blue.cfpreset
                            ¦                   ¦   ¦       Lee_202_1-2 CT Blue.cfpreset
                            ¦                   ¦   ¦       Lee_203_1-4 CT Blue.cfpreset
                            ¦                   ¦   ¦       Lee_204_Full CT Orange.cfpreset
                            ¦                   ¦   ¦       Lee_205_1-2 CT Orange.cfpreset
                            ¦                   ¦   ¦       Lee_206_1-4 CT Orange.cfpreset
                            ¦                   ¦   ¦       Lee_207_CT Orange Plus 3-10 Neutral Density.cfpreset
                            ¦                   ¦   ¦       Lee_208_CT Orange Plus 6-10 Neutral Density.cfpreset
                            ¦                   ¦   ¦       Lee_212_LCT Yellow.cfpreset
                            ¦                   ¦   ¦       Lee_213_White Flame Green.cfpreset
                            ¦                   ¦   ¦       Lee_218_1-8 CT Blue.cfpreset
                            ¦                   ¦   ¦       Lee_219_Fluorescent Green.cfpreset
                            ¦                   ¦   ¦       Lee_223_1-8 CTO.cfpreset
                            ¦                   ¦   ¦       Lee_230_Super Correction LCT Yellow.cfpreset
                            ¦                   ¦   ¦       Lee_232_Super White Flame.cfpreset
                            ¦                   ¦   ¦       Lee_236_HMI.cfpreset
                            ¦                   ¦   ¦       Lee_237_CID.cfpreset
                            ¦                   ¦   ¦       Lee_238_CSI.cfpreset
                            ¦                   ¦   ¦       Lee_241_Lee Fluorescent 5700 K.cfpreset
                            ¦                   ¦   ¦       Lee_242_Lee Fluorescent 4300 K.cfpreset
                            ¦                   ¦   ¦       Lee_243_Lee Fluorescent 3600 K.cfpreset
                            ¦                   ¦   ¦       Lee_244_Lee Plus Green.cfpreset
                            ¦                   ¦   ¦       Lee_245_Half Plus Green.cfpreset
                            ¦                   ¦   ¦       Lee_246_Quarter Plus Green.cfpreset
                            ¦                   ¦   ¦       Lee_247_Lee Minus Green.cfpreset
                            ¦                   ¦   ¦       Lee_248_Half Minus Green.cfpreset
                            ¦                   ¦   ¦       Lee_249_Quarter Minus Green.cfpreset
                            ¦                   ¦   ¦       Lee_278_Eighth Plus Green.cfpreset
                            ¦                   ¦   ¦       Lee_279_Eighth Minus Green.cfpreset
                            ¦                   ¦   ¦       Lee_281_3-4 CT Blue.cfpreset
                            ¦                   ¦   ¦       Lee_285_3-4 CT Orange.cfpreset
                            ¦                   ¦   ¦       Lee_328_Follies Pink.cfpreset
                            ¦                   ¦   ¦       Lee_332_Special Rose Pink.cfpreset
                            ¦                   ¦   ¦       Lee_343_Special Medium Lavender.cfpreset
                            ¦                   ¦   ¦       Lee_344_Violet.cfpreset
                            ¦                   ¦   ¦       Lee_353_Lighter Blue.cfpreset
                            ¦                   ¦   ¦       Lee_354_Special Steel Blue.cfpreset
                            ¦                   ¦   ¦       Lee_363_Special Medium Blue.cfpreset
                            ¦                   ¦   ¦       
                            ¦                   ¦   +---Rosco Calcolor
                            ¦                   ¦   ¦       Rosco Calcolor_4215_15 Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4230_30 Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4260_60 Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4290_90 Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4307_07 Cyan.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4315_15 Cyan.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4330_30 Cyan.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4360_60 Cyan.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4390_90 Cyan.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4415_15 Green.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4430_30 Green.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4460_60 Green.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4490_90 Green.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4515_15 Yellow.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4530_30 Yellow.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4560_60 Yellow.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4590_90 Yellow.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4615_15 Red.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4630_30 Red.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4660_60 Red.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4690_90 Red.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4715_15 Magenta.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4730_30 Magenta.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4760_60 Magenta.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4790_90 Magenta.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4815_15 Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4830_30 Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4860_60 Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4890_90 Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4915_15 Lavender.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4930_30 Lavender.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4960_60 Lavender.cfpreset
                            ¦                   ¦   ¦       Rosco Calcolor_4990_90 Lavender.cfpreset
                            ¦                   ¦   ¦       
                            ¦                   ¦   +---Rosco Cinegel
                            ¦                   ¦   ¦       Rosco Cinegel_3102_Tough MT2.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3106_Tough MTY.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3107_Tough Y1.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3134_Tough MT 54.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3202_Full Blue CTB.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3204_Half Blue 1-2 CTB.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3206_Third Blue 1-3 CTB.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3220_Double Blue 2x CTB.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3308_Tough Minusgreen.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3310_Fluorofilter.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3401_Roscosun 85.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3404_Roscosun N 9-10.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3405_Roscosun 85N 3-10.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3406_Roscosun 85N 6-10.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3407_Roscosun CTO.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3408_Roscosun 1-2 CTO.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3409_Roscosun 1-4 CTO.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3410_Roscosun 1-8 CTO.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3415_Rosco N 15-100.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3441_Full Straw CTS.cfpreset
                            ¦                   ¦   ¦       Rosco Cinegel_3442_Half Straw 1-2 CTS.cfpreset
                            ¦                   ¦   ¦       
                            ¦                   ¦   +---Rosco Cinelux
                            ¦                   ¦   ¦       Rosco Cinelux_02_Bastard Amber.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_06_No Color Straw.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_08_Pale Gold.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_12_Straw.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_16_Light Amber.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_17_Light Flame.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_18_Flame.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_21_Golden Amber.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_23_Orange.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_26_Light Red.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_310_Daffodil.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_316_Gallo Gold.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_318_Mayan Sun.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_321_Soft Golden Amber.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_333_Blush Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_33_No Color Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_34_Flesh Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_360_Clearwater.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_362_Tipton Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_364_Blue Bell.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_365_Tharon Delft Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_376_Bermuda Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_378_Alice Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_37_Pale Rose Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_41_Salmon.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_42_Deep Salmon.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_44_Middle Rose.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_47_Light Rose Purple.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_51_Surprise Pink.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_59_Indigo.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_60_No Color Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_62_Booster Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_65_Daylight Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_77_Green Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_80_Primary Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_83_Medium Blue.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_87_Pale Yellow Green.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_88_Light Green.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_89_Moss Green.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_91_Primary Green.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_92_Turquoise.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_93_Blue Green.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_97_Light Grey.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_98_Medium Grey.cfpreset
                            ¦                   ¦   ¦       Rosco Cinelux_99_Chocolate.cfpreset
                            ¦                   ¦   ¦       
                            ¦                   ¦   +---Rosco Storaro Selection
                            ¦                   ¦   +---Roscolux
                            ¦                   ¦           Roscolux_01_Light Bastard Amber.cfpreset
                            ¦                   ¦           Roscolux_02_Bastard Amber.cfpreset
                            ¦                   ¦           Roscolux_03_Dark Bastard Amber.cfpreset
                            ¦                   ¦           Roscolux_04_Medium Bastard Amber.cfpreset
                            ¦                   ¦           Roscolux_05_Rose Tint.cfpreset
                            ¦                   ¦           Roscolux_06_No Color Straw.cfpreset
                            ¦                   ¦           Roscolux_07_Pale Yellow.cfpreset
                            ¦                   ¦           Roscolux_08_Pale Gold.cfpreset
                            ¦                   ¦           Roscolux_09_Pale Amber Gold.cfpreset
                            ¦                   ¦           Roscolux_10_Medium Yellow.cfpreset
                            ¦                   ¦           Roscolux_11_Light Straw.cfpreset
                            ¦                   ¦           Roscolux_12_Straw.cfpreset
                            ¦                   ¦           Roscolux_13_Straw Tint.cfpreset
                            ¦                   ¦           Roscolux_14_Medium Straw.cfpreset
                            ¦                   ¦           Roscolux_15_Deep Straw.cfpreset
                            ¦                   ¦           Roscolux_16_Light Amber.cfpreset
                            ¦                   ¦           Roscolux_17_Light Flame.cfpreset
                            ¦                   ¦           Roscolux_18_Flame.cfpreset
                            ¦                   ¦           Roscolux_19_Fire.cfpreset
                            ¦                   ¦           Roscolux_20_Medium Amber.cfpreset
                            ¦                   ¦           Roscolux_21_Golden Amber.cfpreset
                            ¦                   ¦           Roscolux_22_Deep Amber.cfpreset
                            ¦                   ¦           Roscolux_23_Orange.cfpreset
                            ¦                   ¦           Roscolux_24_Scarlet.cfpreset
                            ¦                   ¦           Roscolux_25_Orange Red.cfpreset
                            ¦                   ¦           Roscolux_26_Light Red.cfpreset
                            ¦                   ¦           Roscolux_27_Medium Red.cfpreset
                            ¦                   ¦           Roscolux_304_Pale Apricot.cfpreset
                            ¦                   ¦           Roscolux_305_Rose Gold.cfpreset
                            ¦                   ¦           Roscolux_30_Light Salmon Pink.cfpreset
                            ¦                   ¦           Roscolux_310_Daffodil.cfpreset
                            ¦                   ¦           Roscolux_312_Canary.cfpreset
                            ¦                   ¦           Roscolux_316_Gallo Gold.cfpreset
                            ¦                   ¦           Roscolux_317_Apricot.cfpreset
                            ¦                   ¦           Roscolux_318_Mayan Sun.cfpreset
                            ¦                   ¦           Roscolux_31_Salmon Pink.cfpreset
                            ¦                   ¦           Roscolux_3202_Full Blue.cfpreset
                            ¦                   ¦           Roscolux_3204_Half Blue.cfpreset
                            ¦                   ¦           Roscolux_3206_Third Blue.cfpreset
                            ¦                   ¦           Roscolux_3208_Quarter Blue.cfpreset
                            ¦                   ¦           Roscolux_3216_Eighth Blue.cfpreset
                            ¦                   ¦           Roscolux_321_Soft Golden Amber.cfpreset
                            ¦                   ¦           Roscolux_32_Medium Salmon Pink.cfpreset
                            ¦                   ¦           Roscolux_3304_Tough Plusgreen.cfpreset
                            ¦                   ¦           Roscolux_3308_Tough Minusgreen.cfpreset
                            ¦                   ¦           Roscolux_3313_Tough 1-2 Minusgreen.cfpreset
                            ¦                   ¦           Roscolux_3314_Tough 1-4 Minusgreen.cfpreset
                            ¦                   ¦           Roscolux_3315_Tough 1-2 Plusgreen.cfpreset
                            ¦                   ¦           Roscolux_3316_Tough 1-4 Plusgreen.cfpreset
                            ¦                   ¦           Roscolux_3317_Tough 1-8 Plusgreen.cfpreset
                            ¦                   ¦           Roscolux_3318_Tough 1-8 Minusgreen.cfpreset
                            ¦                   ¦           Roscolux_332_Cherry Rose.cfpreset
                            ¦                   ¦           Roscolux_333_Blush Pink.cfpreset
                            ¦                   ¦           Roscolux_337_True Pink.cfpreset
                            ¦                   ¦           Roscolux_339_Broadway Pink.cfpreset
                            ¦                   ¦           Roscolux_33_No Color Pink.cfpreset
                            ¦                   ¦           Roscolux_3401_Roscosun 85.cfpreset
                            ¦                   ¦           Roscolux_3407_Roscosun CTO.cfpreset
                            ¦                   ¦           Roscolux_3408_Roscosun 1-2 CTO.cfpreset
                            ¦                   ¦           Roscolux_3409_Roscosun 1-4 CTO.cfpreset
                            ¦                   ¦           Roscolux_3410_Roscosun 1-8 CTO.cfpreset
                            ¦                   ¦           Roscolux_342_Rose Pink.cfpreset
                            ¦                   ¦           Roscolux_343_Neon Pink.cfpreset
                            ¦                   ¦           Roscolux_344_Follies Pink.cfpreset
                            ¦                   ¦           Roscolux_349_Fisher Fuchsia.cfpreset
                            ¦                   ¦           Roscolux_34_Flesh Pink.cfpreset
                            ¦                   ¦           Roscolux_355_Pale Violet.cfpreset
                            ¦                   ¦           Roscolux_356_Middle Lavender.cfpreset
                            ¦                   ¦           Roscolux_357_Royal Lavender.cfpreset
                            ¦                   ¦           Roscolux_358_Rose Indigo.cfpreset
                            ¦                   ¦           Roscolux_359_Medium Violet.cfpreset
                            ¦                   ¦           Roscolux_35_Light Pink.cfpreset
                            ¦                   ¦           Roscolux_360_Clearwater.cfpreset
                            ¦                   ¦           Roscolux_362_Tipton Blue.cfpreset
                            ¦                   ¦           Roscolux_363_Aquamarine.cfpreset
                            ¦                   ¦           Roscolux_364_Blue Bell.cfpreset
                            ¦                   ¦           Roscolux_365_Tharon Delft Blue.cfpreset
                            ¦                   ¦           Roscolux_367_Slate Blue.cfpreset
                            ¦                   ¦           Roscolux_36_Medium Pink.cfpreset
                            ¦                   ¦           Roscolux_370_Italian Blue.cfpreset
                            ¦                   ¦           Roscolux_376_Bermuda Blue.cfpreset
                            ¦                   ¦           Roscolux_378_Alice Blue.cfpreset
                            ¦                   ¦           Roscolux_37_Pale Rose Pink.cfpreset
                            ¦                   ¦           Roscolux_382_Congo Blue.cfpreset
                            ¦                   ¦           Roscolux_383_Sapphire Blue.cfpreset
                            ¦                   ¦           Roscolux_385_Royal Blue.cfpreset
                            ¦                   ¦           Roscolux_388_Gaslight Green.cfpreset
                            ¦                   ¦           Roscolux_389_Chrome Green.cfpreset
                            ¦                   ¦           Roscolux_38_Light Rose.cfpreset
                            ¦                   ¦           Roscolux_395_Teal Green.cfpreset
                            ¦                   ¦           Roscolux_397_Pale Grey.cfpreset
                            ¦                   ¦           Roscolux_39_Skelton Exotic Sangria.cfpreset
                            ¦                   ¦           Roscolux_40_Light Salmon.cfpreset
                            ¦                   ¦           Roscolux_41_Salmon.cfpreset
                            ¦                   ¦           Roscolux_42_Deep Salmon.cfpreset
                            ¦                   ¦           Roscolux_43_Deep Pink.cfpreset
                            ¦                   ¦           Roscolux_44_Middle Rose.cfpreset
                            ¦                   ¦           Roscolux_45_Rose.cfpreset
                            ¦                   ¦           Roscolux_46_Magenta.cfpreset
                            ¦                   ¦           Roscolux_47_Light Rose Purple.cfpreset
                            ¦                   ¦           Roscolux_48_Rose Purple.cfpreset
                            ¦                   ¦           Roscolux_49_Medium Purple.cfpreset
                            ¦                   ¦           Roscolux_50_Mauve.cfpreset
                            ¦                   ¦           Roscolux_51_Surprise Pink.cfpreset
                            ¦                   ¦           Roscolux_52_Light Lavender.cfpreset
                            ¦                   ¦           Roscolux_53_Pale Lavender.cfpreset
                            ¦                   ¦           Roscolux_54_Special Lavender.cfpreset
                            ¦                   ¦           Roscolux_55_Lilac.cfpreset
                            ¦                   ¦           Roscolux_56_Gypsy Lavender.cfpreset
                            ¦                   ¦           Roscolux_57_Lavender.cfpreset
                            ¦                   ¦           Roscolux_58_Deep Lavender.cfpreset
                            ¦                   ¦           Roscolux_59_Indigo.cfpreset
                            ¦                   ¦           Roscolux_60_No Color Blue.cfpreset
                            ¦                   ¦           Roscolux_61_Mist Blue.cfpreset
                            ¦                   ¦           Roscolux_62_Booster Blue.cfpreset
                            ¦                   ¦           Roscolux_63_Pale Blue.cfpreset
                            ¦                   ¦           Roscolux_64_Light Steel Blue.cfpreset
                            ¦                   ¦           Roscolux_65_Daylight Blue.cfpreset
                            ¦                   ¦           Roscolux_66_Cool Blue.cfpreset
                            ¦                   ¦           Roscolux_67_Light Sky Blue.cfpreset
                            ¦                   ¦           Roscolux_68_Sky Blue.cfpreset
                            ¦                   ¦           Roscolux_69_Brilliant Blue.cfpreset
                            ¦                   ¦           Roscolux_70_Nile Blue.cfpreset
                            ¦                   ¦           Roscolux_71_Sea Blue.cfpreset
                            ¦                   ¦           Roscolux_72_Azure Blue.cfpreset
                            ¦                   ¦           Roscolux_73_Peacock Blue.cfpreset
                            ¦                   ¦           Roscolux_74_Night Blue.cfpreset
                            ¦                   ¦           Roscolux_76_Light Green Blue.cfpreset
                            ¦                   ¦           Roscolux_77_Green Blue.cfpreset
                            ¦                   ¦           Roscolux_78_Trudy Blue.cfpreset
                            ¦                   ¦           Roscolux_79_Bright Blue.cfpreset
                            ¦                   ¦           Roscolux_80_Primary Blue.cfpreset
                            ¦                   ¦           Roscolux_81_Urban Blue.cfpreset
                            ¦                   ¦           Roscolux_82_Surprise Blue.cfpreset
                            ¦                   ¦           Roscolux_83_Medium Blue.cfpreset
                            ¦                   ¦           Roscolux_84_Zephyr Blue.cfpreset
                            ¦                   ¦           Roscolux_85_Deep Blue.cfpreset
                            ¦                   ¦           Roscolux_86_Pea Green.cfpreset
                            ¦                   ¦           Roscolux_87_Pale Yellow Green.cfpreset
                            ¦                   ¦           Roscolux_88_Light Green.cfpreset
                            ¦                   ¦           Roscolux_89_Moss Green.cfpreset
                            ¦                   ¦           Roscolux_90_Dark Yellow Green.cfpreset
                            ¦                   ¦           Roscolux_91_Primary Green.cfpreset
                            ¦                   ¦           Roscolux_92_Turquoise.cfpreset
                            ¦                   ¦           Roscolux_93_Blue Green.cfpreset
                            ¦                   ¦           Roscolux_94_Kelly Green.cfpreset
                            ¦                   ¦           Roscolux_95_Medium Blue Green.cfpreset
                            ¦                   ¦           Roscolux_96_Lime.cfpreset
                            ¦                   ¦           Roscolux_97_Light Grey.cfpreset
                            ¦                   ¦           Roscolux_98_Medium Grey.cfpreset
                            ¦                   ¦           Roscolux_99_Chocolate.cfpreset
                            ¦                   ¦           
                            ¦                   +---Misc
                            ¦                   ¦       Day for Night 1.cfpreset
                            ¦                   ¦       Faded Color Neg 1.cfpreset
                            ¦                   ¦       Sepia 1.cfpreset
                            ¦                   ¦       
                            ¦                   +---Processing
                            ¦                           Cross Processing 1.cfpreset
                           ¦                           
                            +---Format
                                +---MediaIO
                                    +---(codecs)
                                    ¦       MCmpgACodec.vca
                                    ¦       MPEGVideoCodecMPEG2.dll
                                    ¦       MPEGVideoCodecMPEG2BD.dll
                                    ¦       MPEGVideoCodecMPEG2DVD.dll
                                    ¦       PCMAudio.vca
                                    ¦       
                                    +---(writers)
                                            MCMHMPEGWriter.vwr
        ```
  - List continues from here
    - AdobeAfterEffects9FCAll
      - Unpacked version prevents installation phase to be completed and it throws error.
    - MSXML6.0
      - Normally it's unpackable, but due to conflict between x64 and ia64, I not prefer unpack this payload folder. If you try to separate folder into individual payloads, at initialization phase, nothing happens and installation not starts due to payload ID conflict I guess.
    - AdobeContribute-PDistiller-mul\de_DE
      - Throws error 2715 on unpacking.
        - You can fix this with Orca MSI Editor.
          - Download Orca MSI editor from https://www.technipages.com/downloads/OrcaMSI.zip
            - If it's deleted, you can download this package from Wayback Machine on https://web.archive.org/web/20240308101549/https://www.technipages.com/downloads/OrcaMSI.zip
          - On Orca, search Docs_DistillerS_DEU on Components table.
          - When found, replace ACROHELP.DISTS_DEU with ACROHELP_DISTS_DEU.pdf.
          - On unpacked directory, perform replace operation exact opposite directory.
    - AdobeVersionCue4All
      - Package normally unpackable, but it throws error 1603 while initialization phase.
    - AdobeAfterEffects9All
      - Not on standalone application, but on Master Collection and probably on other suites, from unpacked packages inside on Master Collection suite and others, initialization phase takes about like 10-20 minutes or longer depending on selected suite and hardware of PC that suite is going to be installed, but this package fails and gives permission error about AdobeAfterEffects9ProtectedAll directory inside of unpacked After Effects assets and throws error 1603 on logs.
    - AdobeCaptivate4*
      - Installation fails with error 1603.
    - AdobeDirector11.5*
      - Package normally unpackable, but it throws error 1603 while initialization phase.
  - CS3
    - AdobeAfterEffects8All
      - This package fails and gives permission error about AdobeAfterEffects8ProtectedAll directory inside of unpacked After Effects assets and throws error 1603 on logs.
    - AdobeAfterEffects8FCAll
      - Unpacked version prevents installation phase to be completed and it throws error.
    - AdobeAfterEffects8ProtectedAll
      - Throws error 1304 about copying file. Even if you try to click "Retry", it throws error 2350 and unpack fails.
    - AdobePremierePro3All
      - Installation fails with error 1603.
    - AdobePhotoshop10*
      - Installation fails with error 1603.
    - AdobeIllustrator13*
      - Installation fails with error 1603.
    - AdobeInDesign5*
      - Installation fails with error 1603.
    - AdobeInCopy5*
      - Installation fails with error 1603.
    - AdobeEncore3All
      - Installation fails with error 1603.
    - AdobeSoundboothAll
      - Installation fails with error 1603 on Master Collection. I don't have standalone product :(( (If somebody have standalone Adobe Soundbooth CS3 installer, you can write me :)) )
    - But some CS3 main packs can be unpacked. These are:
      - AdobeDreamweaver9*
      - AdobeFlash9*
      - AdobeFireworks9*
      - AdobeIllustrator13*
        - Only on Master Collection.
      - AdobeInDesign5*
        - Only on Master Collection.
      - AdobePhotoshop10*
        - Only on Master Collection.
      - AdobeContribute4.1*
        - On Adobe Acrobat Pro 8 (in suites), they may say C:\program files\Adobe\Acrobat 8.0\Acrobat\Xtras\AdobePDF\I386\ADOBEPDF.DLL says missing during install. Specifying \payloads\AdobeAcrobat8de_DE\program files\Adobe\Acrobat 8.0\Acrobat\Xtras\AdobePDF\I386\ADOBEPDF.DLL will solves this.
