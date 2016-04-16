#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=lm_sensors-3.3.5.tar.bz2
srcdir=lm_sensors-3.3.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/lm_sensors-3.3.5-upstream_fixes-1.patch

make PREFIX=/usr \
	BUILD_STATIC_LIB=0 \
	MANDIR=/usr/share/man
make DESTDIR=$BUILDDIR \
	PREFIX=/usr \
	BUILD_STATIC_LIB=0 \
	MANDIR=/usr/share/man install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Which (>= 2.20)
Description: Hardware monitoring tools
 The lm_sensors package provides user-space support for the hardware
 monitoring drivers in the Linux kernel. This is useful for monitoring the
 temperature of the CPU and adjusting the performance of some hardware (such
 as cooling fans).
 .
 Kernel configuration:
 --------------------------------------------------
 Top level 
   [*] Enable loadable module support  --->
 Bus options (PCI etc.)  --->
   [*] PCI support
 Device Drivers  --->
   [*] I2C support
     [*] I2C device interface
     I2C Algorithms  --->
       <M> (configure all of them as modules)
     I2C Hardware Bus support  --->
       <M> (configure all of them as modules)
   [*] Hardware Monitoring support  --->
     <M> (configure all of them as modules)
 --------------------------------------------------
EOF
}

build
