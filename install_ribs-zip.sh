#!/bin/bash

clear
echo "==> Setting Variables ..."
echo Enter Adobe media folder location:
read source_directory
echo Enter 7-Zip Console binary path:
read sevenzip_bin
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

echo "==> Recompressing Unpacked Products ..."
recompress_packages=$(ls -d "$source_directory"/packages/*/*/)
echo "$recompress_packages" > $adobeworkfolder/recompress_packages.txt
recompress_payloads=$(ls -d "$source_directory"/payloads/*/*/)
echo "$recompress_payloads" > $adobeworkfolder/recompress_payloads.txt
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
echo "- Each line, remove / from start and end of the line"
echo "- Make empty line bottom of file."
echo "Each line should like this:"
echo "packages/DECore/DECore"
echo "payloads/AdobeAfterEffects13.5AllTrial"
echo "<emptyLine>"
echo "Press any key to continue after necessary changes made..."
open $adobeworkfolder
read -n 1
while IFS= read -r line
do
  recompress_packages=$line
  "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_packages.pima" -mx5 -r "$source_directory/$recompress_packages/*"
done < $adobeworkfolder/recompress_packages.txt
while IFS= read -r line
do
  recompress_payloads=$line
  "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/$recompress_payloads.zip" -mx5 -r "$source_directory/$recompress_payloads/*"
done < $adobeworkfolder/recompress_payloads.txt

echo "==> Copying Installer ..."
rsync -av --progress "$source_directory/Install.app" "$adobetempinstaller"
rsync -av --progress "$source_directory/packages" "$adobetempinstaller" --exclude-from="$adobeworkfolder/folder_packages_exclude.txt"
rsync -av --progress --exclude-from="$adobeworkfolder/folder_payloads_exclude.txt" "$source_directory/payloads" "$adobetempinstaller"

echo "==> Installing Product ..."
open -a "$adobetempinstaller/Install.app"
echo "!!!DO NOT PRESS ANY BUTTON WHILE THE APPLICATION IS INSTALLING!!!"
echo "After that, press any key to continue..."
read -n 1
