#!/bin/bash
sudo apt-get install desktop-file-utils debootstrap schroot perl git wget curl xz-utils bubblewrap autoconf coreutils
wget -q "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" -O appimagetool && chmod a+x appimagetool
wget -q "https://dl-cdn.alpinelinux.org/alpine/edge/releases/x86_64/alpine-minirootfs-20251224-x86_64.tar.gz" -O alpine.tar.gz
mkdir alp
mkdir -p ./alp/root/
tar xf alpine.tar.gz -C ./alp/root/
sudo mount -t proc none ./alp/root/proc/
sudo mount --rbind /dev ./alp/root/dev/
sudo mount --rbind /sys ./alp/root/sys/
cp /etc/resolv.conf -t ${GITHUB_WORKSPACE}/alp/root/etc/
cd ${GITHUB_WORKSPACE}
echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> ./alp/root/etc/apk/repositories
sudo chroot ./alp/root/ /bin/sh -c "apk update && apk upgrade && apk add pkgconfig git build-base sdl3-dev sdl3_ttf-dev sdl3_image-dev make cmake libarchive harfbuzz spdlog fmt libxml2 libxml2-dev inih && git clone https://github.com/complexlogic/big-launcher.git && cd big-launcher && mkdir build && cd build && cmake .. && make && mkdir /app && make DESTDIR=/app install && exit"
cp ${GITHUB_WORKSPACE}/icon.png ./alp/ && cp ${GITHUB_WORKSPACE}/Big-Launcher.desktop ./alp/ && cp ${GITHUB_WORKSPACE}/AppRun ./alp/
ARCH=x86_64 VERSION=clean ./appimagetool -n ./alp/
