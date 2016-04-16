#!/bin/bash -e
. ../../blfs.comm

# This package need NASM to build.

build_src() {
srcfil=syslinux-6.03.tar.xz
srcdir=syslinux-6.03
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv $BUILDDIR/usr/bin
make installer
cp bios/linux/syslinux $BUILDDIR/usr/bin

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: collection of boot loaders
 The Syslinux Project covers lightweight bootloaders for MS-DOS FAT
 filesystems (SYSLINUX), network booting (PXELINUX), bootable "El Torito"
 CD-ROMs (ISOLINUX), and Linux ext2/ext3/ext4 or btrfs filesystems (EXTLINUX).
 The project also includes MEMDISK, a tool to boot legacy operating systems
 (such as DOS) from nontraditional media; it is usually used in conjunction
 with PXELINUX and ISOLINUX.
EOF
}

build
