#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=sg3_utils-1.39.tar.xz
srcdir=sg3_utils-1.39
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: utilities for devices using the SCSI command set
 The sg3_utils package contains low level utilities for devices that use a
 SCSI command set. Apart from SCSI parallel interface (SPI) devices, the SCSI
 command set is used by ATAPI devices (CD/DVDs and tapes), USB mass storage
 devices, Fibre Channel disks, IEEE 1394 storage devices (that use the "SBP"
 protocol), SAS, iSCSI and FCoE devices (amongst others).
EOF
}

build
