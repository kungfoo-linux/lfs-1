#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mdadm-3.3.2.tar.xz
srcdir=mdadm-3.3.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# fix a problem inroduced by gcc-4.9.0:
sed -i 's/Wall -Werror/Wall/' Makefile

make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a tool for managing Soft RAID under Linux
 .
 [mdadm]
 manages MD devices aka Linux Software RAID.
 .
 Kernel configuration:
 -----------------------------------------------------------
 . Device Drivers --->
 .   [*] Multiple devices driver support (RAID and LVM) --->
 .       <*> RAID support: Y or M
 .             Autodetect RAID arrays during kernel boot: Y
 .             Linear (append) mode: Y or M
 .             RAID-0 (striping) mode : Y or M
 .             RAID-1 (mirroring) mode : Y or M
 .             RAID-10 (mirrored striping) mode: Y or M
 .             RAID-4/RAID-5/RAID-6 mode : Y or M
 -----------------------------------------------------------
 .
 [mdmon]
 monitors MD external metadata arrays.
 .
 [mdassemble]
 is a tiny program that can be used to assemble MD devices inside an initial
 ramdisk (initrd) or initramfs. 
EOF
}

build
