#!/bin/bash
sudo apt-get install desktop-file-utils debootstrap schroot perl git wget curl xz-utils bubblewrap autoconf coreutils
wget -q "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" -O appimagetool && chmod a+x appimagetool
wget -q "https://dl-cdn.alpinelinux.org/alpine/edge/releases/x86_64/alpine-minirootfs-20251224-x86_64.tar.gz" -O alpine.tar.gz
mkdir alp
mkdir -p ./alp/root/
tar xf alpine.tar.gz -C ./alp/root/
cp /etc/resolv.conf -t ${GITHUB_WORKSPACE}/alp/root/etc/
cd ${GITHUB_WORKSPACE}
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> ./alp/root/etc/apk/repositories
sudo chroot ./alp/root/ /bin/ash -l -c "apk update && apk upgrade && apk add sdl3 sdl3_ttf sdl3_image make cmake libarchive harfbuzz spdlog fmt libxml2 inih"
sudo git clone https://github.com/complexlogic/big-launcher.git /alp/root/big-launcher
cd /alp/root/big-launcher
sudo cmake -B ..
sudo make
ARCH=x86_64 VERSION=clean ./appimagetool -n ./alp/
