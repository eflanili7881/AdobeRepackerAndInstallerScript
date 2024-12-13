#!/bin/bash

###################
#Preparation Phase#
###################

echo -n -e "\033]0;Adobe Repacker and Installer Script v0.4.0-ribs-mac rc2\007"

menu() {
    clear
    echo "================================================================================"
    echo "=                                                                              ="
    echo "=                                                                              ="
    echo "=     1) Start DMG-based Install (CS3 and CS4)                                 ="
    echo "=     2) Start DMG-based Install (CS5 and above)                               ="
    echo "=     3) Start ZIP-based Install (CC2013 and above)                            ="
    echo "=     4) Start ZIP-based with DMG Components Install (CC2013 and above)        ="
    echo "=     5) Exit                                                                  ="
    echo "=                                                                              ="
    echo "=                                                                              ="
    echo "================================================================================"
    echo "Enter your decision:"
    read decision
    case $decision in
        1)
            setvarCommon
            setvarDMGCS3andCS4
            cleanWorkspace
            createDirCS3andCS4
            createTextFilesCS3andCS4
            createReimageFilesDMGCS3andCS4
            editRequiredFiles
            reimagePackagesCS3andCS4
            copyOtherInstallerFilesCS3andCS4
            installRIBSCS3andCS4
            cleanUp
            menu
            ;;
        2)
            setvarCommon
            setvarDMG
            cleanWorkspace
            createDir
            createTextFiles
            createReimageFilesDMG
            editRequiredFiles
            reimagePackages
            copyOtherInstallerFiles
            installRIBS
            cleanUp
            menu
            ;;
        3)
            setvarCommon
            setvarZIP
            cleanWorkspace
            createDir
            createTextFiles
            createRecompressFilesZIP
            editRequiredFiles
            recompressPackages
            copyOtherInstallerFiles
            installRIBS
            cleanUp
            menu
            ;;
         4)
            setvarCommon
            setvarZIP
            cleanWorkspace
            createDir
            createTextFiles
            createRecompressAndReimageFilesZIP
            editRequiredFiles
            recompressAndReimagePackages
            copyOtherInstallerFiles
            installRIBS
            cleanUp
            menu
            ;;
         5)
            exit 0
            ;;
    esac
}

setvarCommon(){
    echo "==> Setting Variables ..."
    echo Enter Adobe media folder location:
    read source_directory
} 

setvarDMGCS3andCS4() {
    echo Enter location formatted as HFS+ for temporarily created Adobe installer:
    read tempinstallerAdobe
    adobetempinstaller=$tempinstallerAdobe/adobetempinstaller
    adobeworkfolder=~/adobeworkfolder
}

setvarDMG() {
    adobetempinstaller=~/adobetempinstaller
    adobeworkfolder=~/adobeworkfolder
}

setvarZIP() {
    echo Enter 7-Zip Console binary path:
    read sevenzip_bin
    echo Enter compression ratio for archive files between 0 and 9:
    echo "0 (store only) ==> 9 (ultra compression)"
    read compression_level
    adobetempinstaller=~/adobetempinstaller
    adobeworkfolder=~/adobeworkfolder
}

cleanWorkspace() {
    echo "==> Deleting Previously Failed Instance ..."
    rm -rf "$adobetempinstaller"
    rm -rf "$adobeworkfolder"
}

createDirCS3andCS4() {
    echo "==> Creating Directories ..."
    mkdir "$adobetempinstaller"
    mkdir "$adobetempinstaller/payloads"
    mkdir "$adobeworkfolder"
    folder_payloads_create=$(ls -d "$source_directory/payloads"/*/)
    echo "$folder_payloads_create" > "$adobeworkfolder/folder_payloads_create.txt"
    while IFS= read -r line
    do
        folder_payloads_name=$(basename "$line")
        mkdir "$adobetempinstaller"/payloads/$folder_payloads_name
    done < "$adobeworkfolder/folder_payloads_create.txt"
}

createDir() {
    echo "==> Creating Directories ..."
    mkdir "$adobetempinstaller"
    mkdir "$adobetempinstaller/packages"
    mkdir "$adobetempinstaller/payloads"
    mkdir "$adobeworkfolder"
    folder_packages_create=$(ls -d "$source_directory/packages"/*/)
    echo "$folder_packages_create" > "$adobeworkfolder/folder_packages_create.txt"
    folder_payloads_create=$(ls -d "$source_directory/payloads"/*/)
    echo "$folder_payloads_create" > "$adobeworkfolder/folder_payloads_create.txt"
    while IFS= read -r line
    do
        folder_packages_name=$(basename "$line")
        mkdir "$adobetempinstaller/packages/$folder_packages_name"
    done < "$adobeworkfolder/folder_packages_create.txt"
    while IFS= read -r line
    do
        folder_payloads_name=$(basename "$line")
        mkdir "$adobetempinstaller/payloads/$folder_payloads_name"
    done < "$adobeworkfolder/folder_payloads_create.txt"
}

createTextFilesCS3andCS4() {
    folder_payloads_exclude=$(ls -d "$source_directory/payloads"/*/*/)
    echo "$folder_payloads_exclude" > "$adobeworkfolder/folder_payloads_exclude.txt"
}

createTextFiles() {
    echo "==> Creating Text Files ..."
    folder_packages_exclude=$(ls -d "$source_directory/packages"/*/*/)
    echo "$folder_packages_exclude" > "$adobeworkfolder/folder_packages_exclude.txt"
    folder_payloads_exclude=$(ls -d "$source_directory/payloads"/*/*/)
    echo "$folder_payloads_exclude" > "$adobeworkfolder/folder_payloads_exclude.txt"
}

createReimageFilesDMG() {
    echo "==> Creating Reimaging Text Files ..."
    reimage_packages=$(ls -d "$source_directory/packages"/*/*/*/)
    echo "$reimage_packages" > "$adobeworkfolder/reimage_packages.txt"
    reimage_payloads=$(ls -d "$source_directory/payloads"/*/*/*/)
    echo "$reimage_payloads" > "$adobeworkfolder/reimage_payloads.txt"
}

createReimageFilesDMGCS3andCS4() {
    echo "==> Creating Reimaging Text Files ..."
    reimage_bootstrapper=$(ls -d "$source_directory/Bootstrapper"/*/)
    echo "$reimage_bootstrapper" > "$adobeworkfolder/reimage_bootstrapper.txt"
    reimage_payloads=$(ls -d "$source_directory/payloads"/*/*/*/)
    echo "$reimage_payloads" > "$adobeworkfolder/reimage_payloads.txt"
}

createRecompressFilesZIP() {
    echo "==> Creating Recompressing Text Files ..."
    recompress_packages=$(ls -d "$source_directory/packages"/*/*/)
    echo "$recompress_packages" > "$adobeworkfolder/recompress_packages.txt"
    recompress_payloads=$(ls -d "$source_directory/payloads"/*/*/)
    echo "$recompress_payloads" > "$adobeworkfolder/recompress_payloads.txt"
}

createRecompressAndReimageFilesZIP() {
    recompress_packages=$(ls -d "$source_directory/packages"/*/*/)
    echo "$recompress_packages" > "$adobeworkfolder/recompress_packages.txt"
    recompress_payloads=$(ls -d "$source_directory/payloads"/*/*/)
    echo "$recompress_payloads" > "$adobeworkfolder/recompress_payloads.txt"
    reimage_payloads=$(ls -d "$source_directory/payloads"/*/*/*/)
    echo "$reimage_payloads" > "$adobeworkfolder/reimage_payloads.txt"
}

editRequiredFiles() {
    echo "==> Editing Required Files ..."
    echo "Edit file"
    echo "+ On exclusion file:"
    echo "- Remove Adobe AIR and any other entries that's not coming from unpacked disk images."
    echo "- Each line, remove / from start of line."
    echo "- Make empty line bottom of file."
    echo "- Each line should like this:"
    echo "-- On DMG-based distributions:"
    echo "--- packages/core/PDApp/core/"
    echo "--- payloads/AdobeAfterEffects10.5AllTrial/406E8D0802AF10B6/"
    echo "--- <emptyLine>"
    echo "-- On ZIP-based distributions:"
    echo "--- packages/DECore/DECore/"
    echo "--- payloads/AdobeAfterEffects13.5AllTrial/"
    echo "--- <emptyLine>"
    echo "+ On reimaging files (DMG-based distributions and ZIP-based installers that has small DMG-based components):"
    echo "- Remove Adobe AIR and any other entries that's not coming from unpacked disk images."
    echo "- Each line, delete everything before packages and payloads."
    echo "- Make empty line bottom of file."
    echo "- Each line should like this:"
    echo "-- /Bootstrapper/1B8EA57B98EDBF98/"
    echo "-- /packages/core/PDApp/core/"
    echo "-- /payloads/AdobeVideoProfilesAE4_0-mul/AdobeVideoProfilesAE4_0-mul/459A876A8DE8CEFD/"
    echo "-- /payloads/AdobeAfterEffects10.5AllTrial/406E8D0802AF10B6/"
    echo "-- <emptyLine>"
    echo "+ On recompressing files (ZIP-based distributions without any DMG-based components):"
    echo "- Remove Adobe AIR and any other entries that's not coming from unpacked asset archives."
    echo "- Each line, delete everything before packages and payloads."
    echo "- Each line, remove / from start and end of the line"
    echo "- Make empty line bottom of file."
    echo "- Each line should like this:"
    echo "-- packages/DECore/DECore"
    echo "-- payloads/AdobeAfterEffects13.5AllTrial"
    echo "-- <emptyLine>"
    echo "Press any key to continue after necessary changes made..."
    open "$adobeworkfolder"
    read -n 1
}

#######################
#Preparing Files Phase#
#######################

reimagePackagesCS3andCS4() {
    echo "==> Reimaging Unpacked Products ..."
    while IFS= read -r line
    do
        filePathBootstrapper=$(dirname "$line")
        volumeLabelBootstrapper=$(basename "$line")
        reimage_bootstrapper=$line
        read -n 1
        hdiutil create -srcfolder "$source_directory$reimage_bootstrapper" -format UDZO -fs HFS+ -volname $volumeLabelBootstrapper -layout SPUD "$adobetempinstaller$filePathBootstrapper.dmg"
    done < "$adobeworkfolder/reimage_bootstrapper.txt"
    while IFS= read -r line
    do
        filePathPayloads=$(dirname "$line")
        volumeLabelPayloads=$(basename "$line")
        reimage_payloads=$line
        hdiutil create -srcfolder "$source_directory$reimage_payloads" -format UDZO -fs HFS+ -volname $volumeLabelPayloads -layout SPUD "$adobetempinstaller$filePathPayloads.dmg"
    done < "$adobeworkfolder/reimage_payloads.txt"
}

reimagePackages() {
    echo "==> Reimaging Unpacked Products ..."
    while IFS= read -r line
    do
        filePathPackages=$(dirname "$line")
        volumeLabelPackages=$(basename "$line")
        reimage_packages=$line
        hdiutil create -srcfolder "$source_directory$reimage_packages" -format UDZO -fs HFS+ -volname $volumeLabelPackages -layout SPUD "$adobetempinstaller$filePathPackages.dmg"
        mv "$adobetempinstaller$filePathPackages.dmg" "$adobetempinstaller$filePathPackages.pima"
    done < "$adobeworkfolder/reimage_packages.txt"
    while IFS= read -r line
    do
        filePathPayloads=$(dirname "$line")
        volumeLabelPayloads=$(basename "$line")
        reimage_payloads=$line
        hdiutil create -srcfolder "$source_directory$reimage_payloads" -format UDZO -fs HFS+ -volname $volumeLabelPayloads -layout SPUD "$adobetempinstaller$filePathPayloads.dmg"
    done < "$adobeworkfolder/reimage_payloads.txt"
}

recompressPackages() {
    echo "==> Recompressing Unpacked Products ..."
    while IFS= read -r line
    do
        recompress_packages=$line
        "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_packages.pima" -mx$compression_level -r "$source_directory/$recompress_packages/*"
    done < "$adobeworkfolder/recompress_packages.txt"
    while IFS= read -r line
    do
        recompress_payloads=$line
        "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_payloads.zip" -mx$compression_level -r "$source_directory/$recompress_payloads/*"
    done < "$adobeworkfolder/recompress_payloads.txt"
}

recompressAndReimagePackages() {
    echo "==> Recompressing And Reimaging Unpacked Products ..."
    while IFS= read -r line
    do
        recompress_packages=$line
        "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_packages.pima" -mx$compression_level -r "$source_directory/$recompress_packages/*"
    done < "$adobeworkfolder/recompress_packages.txt"
    while IFS= read -r line
    do
        recompress_payloads=$line
        "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_payloads.zip" -mx$compression_level -r "$source_directory/$recompress_payloads/*"
    done < "$adobeworkfolder/recompress_payloads.txt"
    while IFS= read -r line
    do
        filePathPayloads=$(dirname "$line")
        volumeLabelPayloads=$(basename "$line")
        reimage_payloads=$line
        hdiutil create -srcfolder "$source_directory$reimage_payloads" -format UDZO -fs HFS+ -volname $volumeLabelPayloads -layout SPUD "$adobetempinstaller$filePathPayloads.dmg"
    done < "$adobeworkfolder/reimage_payloads.txt"
}

copyOtherInstallerFilesCS3andCS4() {
    echo "==> Copying Installer ..."
    rsync -av --progress "$source_directory/deployment" "$adobetempinstaller"
    rsync -av --progress --exclude-from="$adobeworkfolder/folder_payloads_exclude.txt" "$source_directory/payloads" "$adobetempinstaller"
    rsync -av --progress "$source_directory/resources" "$adobetempinstaller"
    rsync -av --progress "$source_directory/Setup.app" "$adobetempinstaller"
}

copyOtherInstallerFiles() {
    echo "==> Copying Installer ..."
    rsync -av --progress "$source_directory/Install.app" "$adobetempinstaller"
    rsync -av --progress --exclude-from="$adobeworkfolder/folder_packages_exclude.txt" "$source_directory/packages" "$adobetempinstaller"
    rsync -av --progress --exclude-from="$adobeworkfolder/folder_payloads_exclude.txt" "$source_directory/payloads" "$adobetempinstaller"
}

####################
#Installation Phase#
####################

installRIBSCS3andCS4() {
    echo "==> Installing Product ..."
    open -a "$adobetempinstaller/Setup.app"
    echo "==> Waiting For Installation To Be Completed ..."
    echo "After installation completed, press any key ..."
    read -n 1
}

installRIBS() {
    echo "==> Installing Product ..."
    open -a "$adobetempinstaller/Install.app"
    echo "==> Waiting For Installation To Be Completed ..."
    echo "After installation completed, press any key ..."
    read -n 1
}

cleanUp() {
    echo "==> Cleaning Up ..."
    rm -rf "$adobetempinstaller"
    rm -rf "$adobeworkfolder"
}

exit() {
    exit
}
 
menu