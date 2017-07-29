# build-rtl-sdr
A script to help build the RTL SDR stuff from osmocom git sources using
either cmake or autotools. To run, just type './build_rtl-sdr.sh'. You
can provide an argument, either 'cmake' or 'auto' to select the build
mode. The default is 'cmake'.

Note: All the proper prerequisites and dependancy packages required to build 
rtl-sdr (libusb, etc) must be installed prior to running this. It does not
try to figure this out for you (yet).

Well, sorta anyway. For the following packages:
libportaudio2, build-essential, cmake and libusb-1.0-0-dev

...~kodetroll>

