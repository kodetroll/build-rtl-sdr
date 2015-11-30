#!/bin/bash
# build_rtl-sdr.sh - A script to help with building the RTL SDR stuff the
# first time.
#
# This script (C) 2013 KB4OID Labs, a division of Kodetroll Heavy Industries
# Author: Kodetroll (KB4OID)
# Based on the instructions available on the web for building rtl-sdr
# depends: git, cmake, autotools, libusb-1.0-0, libusb-1.0-0-dev, etc.

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


