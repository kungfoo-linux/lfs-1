#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=LVM2.2.02.111.tgz
srcdir=LVM2.2.02.111
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--exec-prefix= \
	--with-confdir=/etc \
	--enable-applib \
	--enable-cmdlib \
	--enable-pkgconfig \
	--enable-udev_sync
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Logical Volume Manager administration tools
 The LVM2 package is a package that manages logical partitions. It allows
 spanning of file systems across multiple physical disks and disk partitions
 and provides for dynamic growing or shrinking of logical partitions.
 .
 Kernel configuration:
 -----------------------------------------------------------
 . Device Drivers --->
 .   [*] Multiple devices driver support (RAID and LVM) --->
 .           Device mapper support: Y or M
 .           Crypt target support: (optional)
 .           Snapshot target: (optional)
 .           Mirror target: (optional) 
 -----------------------------------------------------------
 .
 [blkdeactivate]
 utility to deactivate block device.
 .
 [dmeventd]
 (optional) is the Device Mapper event daemon.
 .
 [dmsetup]
 is a low level logical volume management tool.
 .
 [fsadm]
 is an utility used to resize or check filesystem on a device.
 .
 [lvm]
 provides the command-line tools for LVM2. Commands are implemented via
 sympolic links to this program to manage physical devices (pv*), volume
 groups (vg*) and logical volumes (lv*).
 .
 [lvmconf]
 is a script that modifies the locking configuration in the LVM2
 configuration file.
 .
 [lvmdump]
 is a tool used to dump various information concerning LVM2.
 .
 [vgimportclone]
 is used to import a duplicated VG (e.g. hardware snapshot).
 .
 [libdevmapper.so]
 contains the Device Mapper API functions. 
EOF
}

build
