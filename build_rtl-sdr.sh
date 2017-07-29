#!/bin/bash
# build_rtl-sdr.sh - A script to help with building the RTL SDR stuff the
# first time.
#
# This script (C) 2013 KB4OID Labs, a division of Kodetroll Heavy Industries
# Author: Kodetroll (KB4OID)
# Based on the instructions available on the web for building rtl-sdr
# depends: git, cmake, autotools, libusb-1.0-0, libusb-1.0-0-dev, etc.

PLIST=""
MISSING="NO"
function check_package {
#  echo "PKG: $1"
  CPKG=`dpkg --get-selections | grep -F $1`
#  echo "CPKG: $CPKG"
}

function check_package_missing {
  check_package $PKG
  if [ "$CPKG" == "" ]; then
    echo "$PKG is missing"
    MISSING="YES"
    PLIST=${PLIST}" $PKG"
  fi
}

PKGS="libusb-1.0-0-dev libportaudio2 build-essential cmake"
for PKG in $PKGS; do
#PKG="libusb-1.0-0-dev"
  check_package_missing $PKG
done

if [ $MISSING == "YES" ]; then
  echo "Missing Packages"
  echo "sudo apt-get install $PLIST"
  exit 0
fi

exit 0

# Where the build will happen (this is related to the project name in git)
BUILD="rtl-sdr"

# Where to find the RTL-SDR sources via GIT
GITURL="git://git.osmocom.org/$BUILD.git"

# Whether to 'install udev rules'
UDEV="yes"

# Set default 'cmd' to 'cmake' (or 'auto')
CMD="cmake"
if [ ! -z "$1" ]; then
	CMD="$1"
fi

echo "BUILD: $BUILD"
echo "GITURL: $GITURL"
echo "UDEV: $UDEV"
echo "CMD: $CMD"

#exit 0

# Define some functions 

# CMAKE Build
function cmake_build () {
	echo "Running CMAKE Builder"
	cd $BUILD/
	mkdir build
	cd build
	if [ $UDEV == "yes" ]; then
		cmake ../ -DINSTALL_UDEV_RULES=ON
	else
		cmake ../
	fi
	make
	sudo make install
	sudo ldconfig
}

# Autotools build
function autotool_build () {
	echo "Running Autotool Builder"
	cd $BUILD/
	autoreconf -i
	./configure
	make
	sudo make install
	sudo ldconfig
}

function git_sources() {
	echo "Downloading latest source via GIT"
	git clone ${GITURL}
}

if [ -d "$BUILD" ]; then
	echo "BUILD Folder already exists! Please remove to re-build!"
	exit 1
fi

git_sources

if [ $CMD == "cmake" ]; then
	cmake_build && sudo make install-udev-rules
fi

if [ $CMD == "auto" ]; then
	autotool_build && sudo make install-udev-rules
fi

exit 0


