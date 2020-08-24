#!/bin/sh
wget https://github.com/mupen64plus/mupen64plus-core/releases/download/2.5.9/mupen64plus-bundle-linux64-2.5.9.tar.gz
tar xvf ./mupen64plus-bundle-linux64-2.5.9.tar.gz
cd mupen64plus-bundle-linux64-2.5.9 
sudo ./install.sh
echo "Installation complete! To uninstall you can run ./uninstall.sh in this directory ($(pwd))"