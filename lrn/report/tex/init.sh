cp /media/me/F881-F23F/Downloads/CascadiaCode-2111.01.zip .
mkdir temp
unzip CascadiaCode-2111.01.zip -d temp
sudo mkdir /usr/share/fonts/truetype/Cascadia_Code
sudo mv temp/ttf/*  /usr/share/fonts/truetype/Cascadia_Code
rm -r temp
rm CascadiaCode-2111.01.zip 
