#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

build_src() {
srcfil=lsb-release-1.4.tar.gz
srcdir=lsb-release-1.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# Fix a minor display problem:
sed -i "s|n/a|unavailable|" lsb_release

./help2man -N --include ./lsb_release.examples \
	--alt_version_key=program_version ./lsb_release > lsb_release.1

mkdir -pv $BUILDDIR/usr/{share/man/man1,bin}
install -v -m 644 lsb_release.1 $BUILDDIR/usr/share/man/man1/lsb_release.1
install -v -m 755 lsb_release   $BUILDDIR/usr/bin/lsb_release

cleanup_src .. $srcdir
}

configure() {
mkdir -pv $BUILDDIR/etc
cat > $BUILDDIR/etc/lsb-release << "EOF"
DISTRIB_ID="LFS"
DISTRIB_RELEASE="7.6"
DISTRIB_CODENAME="Fangxm"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
echo 7.6 > $BUILDDIR/etc/lfs-release
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: A script gives information about LSB status of the distribution
 [lsb_release] is a script to give LSB data. 
EOF
}

build
