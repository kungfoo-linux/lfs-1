#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=lsof_4.87.tar.bz2
srcdir=lsof_4.87
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf lsof_4.87_src.tar
cd lsof_4.87_src

./Configure -n linux
make CFGL="-L./lib -ltirpc"

mkdir -pv $BUILDDIR/usr/{bin,share/man/man8}
install -v -m0755 -o root -g root lsof $BUILDDIR/usr/bin
install -v lsof.8 $BUILDDIR/usr/share/man/man8

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libtirpc (>= 0.2.5)
Description: list open files
 Lsof is a Unix-specific diagnostic tool. Its name stands for LiSt Open Files,
 and it does just that. It lists information about any files that are open, by
 processes currently running on the system.
 .
 [lsof]
 lists open files for running processes.
EOF
}

build
