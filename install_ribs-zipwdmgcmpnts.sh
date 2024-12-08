#!/bin/bash

clear
echo "==> Adobe Repacker and Installer Script v0.3.0.2-ribs-mac-zipwdmgcmpnts rc"
echo "==> Setting Variables ..."
echo Enter Adobe media folder location:
read source_directory
echo Enter 7-Zip Console binary path:
read sevenzip_bin
echo Enter compression ratio for archive files between 0 and 9:
read compression_level
adobetempinstaller=~/adobetempinstaller
adobeworkfolder=~/adobeworkfolder

echo "==> Deleting Previously Failed Instance ..."
rm -rf $adobetempinstaller
rm -rf $adobeworkfolder

echo "==> Creating Directories ..."
mkdir $adobetempinstaller
mkdir $adobetempinstaller/packages
mkdir $adobetempinstaller/payloads
mkdir $adobeworkfolder
folder_packages_create=$(ls -d "$source_directory"/packages/*/)
echo "$folder_packages_create" > $adobeworkfolder/folder_packages_create.txt
folder_payloads_create=$(ls -d "$source_directory"/payloads/*/)
echo "$folder_payloads_create" > $adobeworkfolder/folder_payloads_create.txt
while IFS= read -r line
do
  folder_packages_name=$(basename "$line")
  mkdir "$adobetempinstaller/packages/$folder_packages_name"
done < $adobeworkfolder/folder_packages_create.txt
while IFS= read -r line
do
  folder_payloads_name=$(basename "$line")
  mkdir "$adobetempinstaller/payloads/$folder_payloads_name"
done < $adobeworkfolder/folder_payloads_create.txt

echo "==> Creating Exclusion Files ..."
folder_packages_exclude=$(ls -d "$source_directory"/packages/*/*/)
echo "$folder_packages_exclude" > $adobeworkfolder/folder_packages_exclude.txt
folder_payloads_exclude=$(ls -d "$source_directory"/payloads/*/*/)
echo "$folder_payloads_exclude" > $adobeworkfolder/folder_payloads_exclude.txt

echo "==> Recompressing & Reimaging Unpacked Products ..."
recompress_packages=$(ls -d "$source_directory"/packages/*/*/)
echo "$recompress_packages" > $adobeworkfolder/recompress_packages.txt
recompress_payloads=$(ls -d "$source_directory"/payloads/*/*/)
echo "$recompress_payloads" > $adobeworkfolder/recompress_payloads.txt
reimage_payloads=$(ls -d "$source_directory"/payloads/*/*/*/)
echo "$reimage_payloads" > $adobeworkfolder/reimage_payloads.txt
echo "Edit file"
echo "+ On exclusion file:"
echo "- Remove Adobe AIR and any other entries that's not coming from unpacked asset archives."
echo "- Each line, remove / from start of line."
echo "- Make empty line bottom of file."
echo "Each line should like this:"
echo "packages/DECore/DECore/"
echo "payloads/AdobeAfterEffects13.5AllTrial/"
echo "<emptyLine>"
echo "+ On recompressing files:"
echo "- Remove Adobe AIR and any other entries that's not coming from unpacked asset archives."
echo "- Each line, delete everything before packages and payloads."
echo "- Each line, remove / from start and end of the line."
echo "- Remove lines that contains unpacked *.dmg files (they're on reimaging file)."
echo "- Make empty line bottom of file."
echo "Each line should like this:"
echo "packages/DECore/DECore"
echo "payloads/AdobeAfterEffects13.5AllTrial"
echo "<emptyLine>"
echo "+ On reimaging files:"
echo "- Remove Adobe AIR and any other entries that's not coming from unpacked disk images."
echo "- Each line, delete everything before packages and payloads."
echo "- Remove lines that contains unpacked *.zip files (they're on recompressing files)."
echo "- Make empty line bottom of file."
echo "Each line should like this:"
echo "/payloads/AdobeVideoProfilesAE4_0-mul/AdobeVideoProfilesAE4_0-mul/459A876A8DE8CEFD/"
echo "Press any key to continue after necessary changes made..."
open $adobeworkfolder
read -n 1
while IFS= read -r line
do
  recompress_packages=$line
  "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_packages.pima" -mx$compression_level -r "$source_directory/$recompress_packages/*"
done < $adobeworkfolder/recompress_packages.txt
while IFS= read -r line
do
  recompress_payloads=$line
  "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_payloads.zip" -mx$compression_level -r "$source_directory/$recompress_payloads/*"
done < $adobeworkfolder/recompress_payloads.txt
while IFS= read -r line
do
  filePathPayloads=$(dirname "$line")
  volumeLabelPayloads=$(basename "$line")
  reimage_payloads=$line
  hdiutil create -srcfolder "$source_directory$reimage_payloads" -format UDZO -fs HFS+ -volname $volumeLabelPayloads -layout SPUD "$adobetempinstaller$filePathPayloads.dmg"
done < $adobeworkfolder/reimage_payloads.txt

echo "==> Copying Installer ..."
rsync -av --progress "$source_directory/Install.app" "$adobetempinstaller"
rsync -av --progress "$source_directory/packages" "$adobetempinstaller" --exclude-from="$adobeworkfolder/folder_packages_exclude.txt"
rsync -av --progress --exclude-from="$adobeworkfolder/folder_payloads_exclude.txt" "$source_directory/payloads" "$adobetempinstaller"

echo "==> Installing Product ..."
open -a "$adobetempinstaller/Install.app"
echo "!!!DO NOT PRESS ANY BUTTON WHILE THE APPLICATION IS INSTALLING!!!"
echo "After that, press any key to continue..."
read -n 1
