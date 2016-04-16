#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=st-1.9.tar.gz
srcdir=st-1.9
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make linux-optimized

mkdir -pv $BUILDDIR/usr/{lib,include}
TARGETDIR=LINUX_$(uname -r)_OPT

cp $TARGETDIR/{libst.so.1.9,libst.a} $BUILDDIR/usr/lib
cp $TARGETDIR/st.h $BUILDDIR/usr/include
ln -sv libst.so.1.9 $BUILDDIR/usr/lib/libst.so.1
ln -sv libst.so.1.9 $BUILDDIR/usr/lib/libst.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: State Threads Library
 The State Threads Library is a small application library which
 provides a foundation for writing fast and highly scalable
 Internet applications (such as web servers, proxy servers, mail
 transfer agents, and so on) on UNIX-like platforms.
EOF
}

build
