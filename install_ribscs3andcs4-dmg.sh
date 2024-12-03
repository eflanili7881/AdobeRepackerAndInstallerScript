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
mkdir $adobetempinstaller/payloads
mkdir $adobeworkfolder
folder_payloads_create=$(ls -d "$source_directory"/payloads/*/)
echo "$folder_payloads_create" > $adobeworkfolder/folder_payloads_create.txt
while IFS= read -r line
do
  folder_payloads_name=$(basename "$line")
  mkdir "$adobetempinstaller/payloads/$folder_payloads_name"
done < $adobeworkfolder/folder_payloads_create.txt

echo "==> Creating Exclusion Files ..."
folder_payloads_exclude=$(ls -d "$source_directory"/payloads/*/*/)
echo "$folder_payloads_exclude" > $adobeworkfolder/folder_payloads_exclude.txt

echo "==> Reimaging Unpacked Products ..."
reimage_bootstrapper=$(ls -d "$source_directory"/Bootstrapper/*/)
echo "$reimage_bootstrapper" > $adobeworkfolder/reimage_bootstrapper.txt
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
  filePathBootstrapper=$(dirname "$line")
  volumeLabelBootstrapper=$(basename "$line")
  reimage_bootstrapper=$line
  read -n 1
  hdiutil create -srcfolder "$source_directory$reimage_bootstrapper" -format UDZO -fs HFS+ -volname $volumeLabelBootstrapper -layout SPUD "$adobetempinstaller$filePathBootstrapper.dmg"
done < $adobeworkfolder/reimage_bootstrapper.txt
while IFS= read -r line
do
  filePathPayloads=$(dirname "$line")
  volumeLabelPayloads=$(basename "$line")
  reimage_payloads=$line
  hdiutil create -srcfolder "$source_directory$reimage_payloads" -format UDZO -fs HFS+ -volname $volumeLabelPayloads -layout SPUD "$adobetempinstaller$filePathPayloads.dmg"
done < $adobeworkfolder/reimage_payloads.txt

echo "==> Copying Installer ..."
rsync -av --progress "$source_directory/deployment" "$adobetempinstaller"
rsync -av --progress --exclude-from="$adobeworkfolder/folder_payloads_exclude.txt" "$source_directory/payloads" "$adobetempinstaller"
rsync -av --progress "$source_directory/resources" "$adobetempinstaller"
rsync -av --progress "$source_directory/Setup.app" "$adobetempinstaller"

echo "==> Installing Product ..."
open -a "$adobetempinstaller/Setup.app"
echo "!!!DO NOT PRESS ANY BUTTON WHILE THE APPLICATION IS INSTALLING!!!"
echo "After that, press any key to continue..."
read -n 1
