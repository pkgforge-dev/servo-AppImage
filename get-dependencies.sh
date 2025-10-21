#!/bin/sh

set -eux
ARCH="$(uname -m)"
BINARY="https://github.com/servo/servo/releases/latest/download/servo-x86_64-linux-gnu.tar.gz"
EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

echo "Installing dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	base-devel        \
	curl              \
	git               \
	gst-plugins-bad   \
	libx11            \
	libxrandr         \
	libxss            \
	pipewire-audio    \
	pulseaudio        \
	pulseaudio-alsa   \
	wget              \
	wayland           \
	xorg-server-xvfb  \
	zsync

if ! wget --retry-connrefused --tries=30 "$BINARY" -O /tmp/tarball.tar.gz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
mkdir -p ./AppDir/bin
tar xvf /tmp/tarball.tar.gz
mv -v ./servo/* ./AppDir/bin

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-common --prefer-nano


