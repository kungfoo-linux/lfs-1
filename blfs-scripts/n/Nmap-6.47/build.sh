#!/bin/bash -e
. ../../blfs.comm

build_src() {
# This package does not support parallel build.

srcfil=nmap-6.47.tar.bz2
srcdir=nmap-6.47
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libpcap (>= 1.6.2), Lua (>= 5.2.3), PCRE (>= 8.35), \
liblinear (>= 1.94), OpenSSL (>= 1.0.1i), Python2 (>= 2.7.8), \
Subversion (>= 1.8.10)
Description: The Network Mapper
 Nmap is a utility for network exploration or security auditing. It supports
 ping scanning (determine which hosts are up), many port scanning techniques,
 version detection (determine service protocols and application versions
 listening behind ports), and TCP/IP fingerprinting (remote host OS or device
 identification). Nmap also offers flexible target and port specification,
 decoy/stealth scanning, sunRPC scanning, and more. Most Unix and Windows
 platforms are supported in both GUI and commandline modes. Several popular
 handheld devices are also supported, including the Sharp Zaurus and the iPAQ.
 .
 [ncat]
 is a utility for reading and writing data across networks from the command
 line.
 .
 [ndiff]
 is a tool to aid in the comparison of Nmap scans.
 .
 [nmap]
 is a utility for network exploration and security auditing. It supports ping
 scanning, port scanning and TCP/IP fingerprinting.
 .
 [nmapfe]
 is a symbolic link to zenmap.
 .
 [nmap-update]
 is an updater for Nmap architecture-independent files.
 .
 [xnmap]
 is a symbolic link to zenmap.
 .
 [zenmap]
 is a Python based graphical nmap frontend viewer.
EOF
}

build
