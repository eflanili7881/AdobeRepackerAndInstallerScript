#!/bin/bash

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
mkdir $adobetempinstaller/products
mkdir $adobeworkfolder
folder_create=$(ls -d "$source_directory"/products/*/)
echo "$folder_create" > $adobeworkfolder/folder_create.txt
while IFS= read -r line
do
  folder_name=$(basename "$line")
  mkdir "$adobetempinstaller/products/$folder_name"
done < $adobeworkfolder/folder_create.txt

echo "==> Creating Exclusion File ..."
folder_exclude=$(ls -d "$source_directory"/products/*/*/)
echo "$folder_exclude" > $adobeworkfolder/folder_exclude.txt

echo "==> Compressing Unpacked Products ..."
folder_compress=$(ls -d "$source_directory"/products/*/*/)
echo "$folder_compress" > $adobeworkfolder/folder_compress.txt
echo "Edit file"
echo "Leave only <AdobeSAPCode>/<FolderThat'sGonneBeCompressed>"
echo "Each line should like this:"
echo "LRCC/AdobeLightroomCC-mul"
open -e "$adobeworkfolder/folder_compress.txt"
echo "Press any key to continue after necessary changes made..."
read -n 1
while IFS= read -r line
do
  folder_compress=$line
  "$sevenzip_bin" a -bd -snh -snl -tzip "$adobetempinstaller/products/$folder_compress.zip" -mx5 -r "$source_directory/products/$folder_compress/*"
done < $adobeworkfolder/folder_compress.txt

echo "==> Copying Installer ..."
echo "Edit file"
echo "Leave only <AdobeSAPCode>/<FolderThat'sGonnaBeExcluded>/"
echo "Each line should like this:"
echo "LRCC/AdobeLightroomCC-mul/"
open -e "$adobeworkfolder/folder_exclude.txt"
echo "Press any key to continue after necessary changes made..."
read -n 1
rsync -av --progress "$source_directory/Install.app" "$adobetempinstaller"
rsync -av --progress "$source_directory/packages" "$adobetempinstaller"
rsync -av --progress --exclude-from="$adobeworkfolder/folder_exclude.txt" "$source_directory/products" "$adobetempinstaller"
rsync -av --progress "$source_directory/resources" "$adobetempinstaller"

echo "==> Installing Product ..."
open -a "$adobetempinstaller/Install.app"
echo "Press any key to continue..."
read -n 1
