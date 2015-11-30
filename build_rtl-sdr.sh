#!/bin/bash
# build_rtl-sdr.sh - A script to help with building the RTL SDR stuff the
# first time.
#
# This script (C) 2013 KB4OID Labs, a division of Kodetroll Heavy Industries
# Author: Kodetroll (KB4OID)
# Based on the instructions available on the web for building rtl-sdr
# depends: git, cmake, autotools, libusb-1.0-0, libusb-1.0-0-dev, etc.

# Where to find the RTL-SDR sources via GIT
GITURL="git://git.osmocom.org/rtl-sdr.git"
# Whether to 'install udev rules'
UDEV="yes"

# Set default 'cmd' to 'cmake' (or 'auto')
CMD="cmake"
if [ ! -z "$1" ]; then
	CMD="$1"
fi

# Define some functions 

# CMAKE Build
function cmake_build () {
	echo "Running CMAKE Builder"
	cd rtl-sdr/
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
	cd rtl-sdr/
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

git_sources

if [ $CMD == "cmake" ]; then
  cmake_build && sudo make install-udev-rules
fi

if [ $CMD == "auto" ]; then
  autotool_build && sudo make install-udev-rules
fi

exit 0


