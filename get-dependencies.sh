#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	gst-plugins-bad   \
	gst-plugins-good  \
	pipewire-audio    \
	pulseaudio        \
	pulseaudio-alsa   \
	wayland

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

echo "Getting binary..."
echo "---------------------------------------------------------------"
TARBALL_URL="https://github.com/servo/servo/releases/latest/download/servo-$ARCH-linux-gnu.tar.gz"
if ! wget --retry-connrefused --tries=30 "$TARBALL_URL" -O /tmp/tarball.tar.gz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

mkdir -p ./AppDir/bin
tar xvf /tmp/tarball.tar.gz
mv -v ./servo/* ./AppDir/bin
cp -v ./AppDir/bin/resources/servo_1024.png          ./AppDir
cp -v ./AppDir/bin/resources/org.servo.Servo.desktop ./AppDir

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version

