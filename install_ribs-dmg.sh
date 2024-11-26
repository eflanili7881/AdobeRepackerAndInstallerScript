#!/bin/bash

clear
echo "==> Setting Variables ..."
echo Enter Adobe media folder location:
read source_directory
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

echo "==> Reimaging Unpacked Products ..."
reimage_packages=$(ls -d "$source_directory"/packages/*/*/*/)
echo "$reimage_packages" > $adobeworkfolder/reimage_packages.txt
reimage_payloads=$(ls -d "$source_directory"/payloads/*/*/*/)
echo "$reimage_payloads" > $adobeworkfolder/reimage_payloads.txt
echo "Edit file"
echo "+ On exclusion file:"
echo "- Remove Adobe AIR and any other entries that's not coming from unpacked disk images."
echo "- Each line, remove / from start of line."
echo "- Make empty line bottom of file."
echo "Each line should like this:"
echo "packages/core/PDApp/core/"
echo "payloads/AdobeAfterEffects10.5AllTrial/406E8D0802AF10B6/"
echo "<emptyLine>"
echo "+ On reimaging files:"
echo "- Remove Adobe AIR and any other entries that's not coming from unpacked disk images."
echo "- Each line, delete everything before packages and payloads."
echo "- Make empty line bottom of file."
echo "Each line should like this:"
echo "/packages/core/PDApp/core/"
echo "/payloads/AdobeAfterEffects10.5AllTrial/406E8D0802AF10B6/"
echo "<emptyLine>"
echo "Press any key to continue after necessary changes made..."
open $adobeworkfolder
read -n 1
while IFS= read -r line
do
  filePathPackages=$(dirname "$line")
  volumeLabelPackages=$(basename "$line")
  reimage_packages=$line
  hdiutil create -srcfolder "$source_directory$reimage_packages" -format UDZO -fs HFS+ -volname $volumeLabelPackages -layout SPUD "$adobetempinstaller$filePathPackages.dmg"
  mv "$adobetempinstaller$filePathPackages.dmg" "$adobetempinstaller$filePathPackages.pima"
done < $adobeworkfolder/reimage_packages.txt
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
