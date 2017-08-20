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
# list of required packages
PKGS="libusb-1.0-0-dev libportaudio2 build-essential cmake"

# Where the build will happen (this is related to the project name in git)
BUILD="rtl-sdr"

# Where to find the RTL-SDR sources via GIT
GITURL="git://git.osmocom.org/$BUILD.git"

# Whether to 'install udev rules'
UDEV="yes"

# Set default 'cmd' to 'cmake' (or 'auto')
CMD="cmake"

# Define some functions

function check_package {
#  echo "PKG: $1"
  CPKG=`dpkg --get-selections | grep -F $1`
#  echo "CPKG: $CPKG"
}

# Checks to see if package is missing
function check_package_missing {
  check_package $1
  if [ "$CPKG" == "" ]; then
    echo "$1 is missing"
    MISSING="YES"
    PLIST=${PLIST}" $1"
  fi
}

# CMAKE style Builder
function cmake_build () {
  echo "Running CMAKE Builder"
  cd $BUILD/
  echo "Creating build folder"
  mkdir build
  cd build
  if [ $UDEV == "yes" ]; then
    echo "running cmake with udev on"
    cmake ../ -DINSTALL_UDEV_RULES=ON
  else
    echo "running cmake with udev off"
    cmake ../
  fi
  echo "running make"
  make
  echo "installing"
  sudo make install
  echo "updating ld cache"
  sudo ldconfig
  echo "Done building"
}

# Autotools style builder
function autotool_build () {
  echo "Running Autotool Builder"
  cd $BUILD/
  echo "Running auto reconf"
  autoreconf -i
  echo "Running configure"
  ./configure
  echo "Running make"
  make
  echo "Installing"
  sudo make install
  echo "Updating ld cache"
  sudo ldconfig
  echo "Done building"
}

# Install udev rules if desired
function install_udev {
  if [ $UDEV == "yes" ]; then
    echo "Installing udev rules"
    sudo make install-udev-rules
  fi
}

# Clone the sources using GIT
function git_sources() {
  echo "Downloading latest source via GIT"
  git clone ${GITURL}
}

# Check for missing packages by browsing a list of packages 
# and making note if they are present. Exit if at least
# one missing package is detected.
function check_for_missing_packages {
  for PKG in $PKGS; do
    check_package_missing $PKG
  done

  # if we have missing packages, report and exit
  if [ $MISSING == "YES" ]; then
    echo "Missing Packages"
    echo " sudo apt-get install $PLIST"
    exit 1
  fi
}

# Get the make style based on cmd arg
function get_make_style_cmd {
  if [ ! -z "$1" ]; then
    CMD="$1"
  fi
}

# Check to see if there is an existing build
function check_for_previous_build {
  echo "Checking for remains of previous build"
  if [ -d "$BUILD" ]; then
    echo "Project folder ($BUILD) already exists! Please remove to re-build!"
    exit 1
  fi
}

# end of functions

#exit 0

# Start of Process

# Lets check for required packages
check_for_missing_packages

# Detect the desired make style command ('auto' or 'cmake')
get_make_style_cmd $1

# Show the detected settings, in case we stop early
echo "BUILD: $BUILD"
echo "GITURL: $GITURL"
echo "UDEV: $UDEV"
echo "CMD: $CMD"

#exit 0

# Check to see if we already built this thing before
# if so, exit
check_for_previous_build

# Check to see if we selected 'cmake'

case "$CMD" in
  # Check to see if we selected 'auto'
  auto)
    # Grab the sources from git
    echo "Grabbing Sources"
    git_sources


    echo "AUTO Build"
    autotool_build && install_udev
    ;;

  # Check to see if we selected 'cmake'
  cmake)
    # Grab the sources from git
    echo "Grabbing Sources"
    git_sources

    echo "CMAKE Build"
    cmake_build && install_udev
    ;;

  *)
    echo $"Usage: $0 {auto|cmake}"
    exit 1

esac

# we done
exit 0


