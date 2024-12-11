#!/bin/bash

###################
#Preparation Phase#
###################

echo -n -e "\033]0;Adobe Repacker and Installer Script v0.4.0-hd-mac rc2\007"

menu() {
    clear
    echo "================================================================================"
    echo "=                                                                              ="
    echo "=                                                                              ="
    echo "=     1) Start Install                                                         ="
    echo "=     2) Exit                                                                  ="
    echo "=                                                                              ="
    echo "=                                                                              ="
    echo "================================================================================"
    echo "Enter your decision:"
    read decision
    case $decision in
        1)
            setvar
            cleanWorkspace
            createDir
            createTextFiles
            editRequiredFiles
            compressPackages
            copyOtherInstallerFiles
            installACC
            installHyperDrive
            cleanUp
            menu
            ;;
         2)
            exit 0
            ;;
    esac
}

setvar() {
    echo "==> Setting Variables ..."
    echo Enter Adobe media folder location:
    read source_directory
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

createDir() {
    echo "==> Creating Directories ..."
    mkdir $adobetempinstaller
    mkdir $adobetempinstaller/packages
    mkdir $adobetempinstaller/packages/AAM
    mkdir $adobetempinstaller/packages/ACC
    mkdir $adobetempinstaller/packages/ADC
    mkdir $adobetempinstaller/products
    mkdir $adobeworkfolder
    folder_packagesAAM_create=$(ls -d "$source_directory"/packages/AAM/*/)
    echo "$folder_packagesAAM_create" > $adobeworkfolder/folder_packagesAAM_create.txt
    folder_packagesACC_create=$(ls -d "$source_directory"/packages/ACC/*/)
    echo "$folder_packagesACC_create" > $adobeworkfolder/folder_packagesACC_create.txt
    folder_packagesADC_create=$(ls -d "$source_directory"/packages/ADC/*/)
    echo "$folder_packagesADC_create" > $adobeworkfolder/folder_packagesADC_create.txt
    folder_products_create=$(ls -d "$source_directory"/products/*/)
    echo "$folder_products_create" > $adobeworkfolder/folder_products_create.txt
    while IFS= read -r line
    do
        folder_packagesAAM_name=$(basename "$line")
        mkdir "$adobetempinstaller/packages/AAM/$folder_packagesAAM_name"
    done < $adobeworkfolder/folder_packagesAAM_create.txt
    while IFS= read -r line
    do
        folder_packagesACC_name=$(basename "$line")
        mkdir "$adobetempinstaller/packages/ACC/$folder_packagesACC_name"
    done < $adobeworkfolder/folder_packagesACC_create.txt
    while IFS= read -r line
    do
        folder_packagesADC_name=$(basename "$line")
        mkdir "$adobetempinstaller/packages/ADC/$folder_packagesADC_name"
    done < $adobeworkfolder/folder_packagesADC_create.txt
    while IFS= read -r line
    do
        folder_products_name=$(basename "$line")
        mkdir "$adobetempinstaller/products/$folder_products_name"
    done < $adobeworkfolder/folder_products_create.txt
}

createTextFiles() {
    echo "==> Creating Text Files ..."
    folder_packages_exclude=$(ls -d "$source_directory"/packages/*/*/*/)
    echo "$folder_packages_exclude" > $adobeworkfolder/folder_packages_exclude.txt
    folder_products_exclude=$(ls -d "$source_directory"/products/*/*/)
    echo "$folder_products_exclude" > $adobeworkfolder/folder_products_exclude.txt
    folder_packages_compress=$(ls -d "$source_directory"/packages/*/*/*/)
    echo "$folder_packages_compress" > $adobeworkfolder/folder_packages_compress.txt
    folder_products_compress=$(ls -d "$source_directory"/products/*/*/)
    echo "$folder_products_compress" > $adobeworkfolder/folder_products_compress.txt
    clear
}

editRequiredFiles() {
    echo "==> Editing Required Files ..."
    echo "+ On compression files:"
    echo "- Leave only <folder1>/<folder2>"
    echo "- Each line should like this:"
    echo "-- packages/ACC/ACCC/ACCC"
    echo "-- products/LRCC/AdobeLightroomCC-mul"
    echo "+ On exclusion files:"
    echo "- Leave only <folder1>/<folder2>/"
    echo "- Each line should like this:"
    echo "-- packages/ACC/ACCC/ACCC/"
    echo "-- products/LRCC/AdobeLightroomCC-mul/"
    open $adobeworkfolder
    echo "Press any key to continue after necessary changes made..."
    read -n 1
}

#######################
#Preparing Files Phase#
#######################

compressPackages() {
    echo "==> Compressing Unpacked Products ..."
    while IFS= read -r line
    do
        folder_packages_compress=$line
        "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$folder_packages_compress.pima" -mx$compression_level -r "$source_directory/$folder_packages_compress/*"
    done < $adobeworkfolder/folder_packages_compress.txt
    while IFS= read -r line
    do
        folder_products_compress=$line
        "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$folder_products_compress.zip" -mx$compression_level -r "$source_directory/$folder_products_compress/*"
    done < $adobeworkfolder/folder_products_compress.txt
}

copyOtherInstallerFiles() {
    echo "==> Copying Installer ..."
    rsync -av --progress "$source_directory/Install_CC.app" "$adobetempinstaller"
    rsync -av --progress "$source_directory/Install_HD.app" "$adobetempinstaller"
    rsync -av --progress --exclude-from="$adobeworkfolder/folder_packages_exclude.txt" "$source_directory/packages" "$adobetempinstaller"
    rsync -av --progress --exclude-from="$adobeworkfolder/folder_products_exclude.txt" "$source_directory/products" "$adobetempinstaller"
    rsync -av --progress "$source_directory/resources" "$adobetempinstaller"
}

####################
#Installation Phase#
####################

installACC() {
    echo "==> Installing Adobe Creative Cloud ..."
    cp "$adobetempinstaller/resources/AdobePIM_patched/AdobePIM.dylib" "$adobetempinstaller/resources/AdobePIM.dylib"
    open -a "$adobetempinstaller/Install_CC.app"
    echo "==> Waiting For Installation To Be Completed ..."
    echo "Press any key to continue..."
    read -n 1
}

installHyperDrive() {
    echo "==> Installing Adobe Product ..."
    rm "$adobetempinstaller/resources/AdobePIM.dylib"
    cp "$adobetempinstaller/resources/AdobePIM_original/AdobePIM.dylib" "$adobetempinstaller/resources/AdobePIM.dylib"
    open -a "$adobetempinstaller/Install_HD.app"
    echo "==> Waiting For Installation To Be Completed ..."
    echo "Press any key to continue..."
    read -n 1
}

################
#Clean-up Phase#
################

cleanUp() {
    echo "==> Cleaning Up ..."
    rm -rf "$adobetempinstaller"
    rm -rf "$adobeworkfolder"
}

exit() {
    exit
}

menu
