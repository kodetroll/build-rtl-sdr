#!/bin/bash
# build_rtl-sdr.sh - A script to help with building the RTL SDR stuff the first time.
# This script (C) 2013 KB4OID Labs, a division of Kodetroll Heavy Industries
# Author: Kodetroll (KB4OID)
# Based on the instructions available on the web for building rtl-sdr
# depends: git, cmake, autotools, libusb-1.0-0, libusb-1.0-0-dev, etc.

# CMAKE Build
function cmake_build () {
	cd rtl-sdr/
	mkdir build
	cd build
	#cmake ../
	cmake ../ -DINSTALL_UDEV_RULES=ON
	make
	sudo make install
	sudo ldconfig
}

# Autotools build
function autotool_build () {
	cd rtl-sdr/
	autoreconf -i
	./configure
	make
	sudo make install
	sudo ldconfig
}

git clone git://git.osmocom.org/rtl-sdr.git
cmake_build
sudo make install-udev-rules
exit 0


