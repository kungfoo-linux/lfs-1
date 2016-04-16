#!/bin/bash -e
. ../../blfs.comm

build_src() {
filelst=$BLFSSRC/$PKGLETTER/$CURDIR/proto-7.7.md5
for package in $(grep -v '^#' $filelst | awk '{print $2}')
do
    srcfil=$BLFSSRC/$PKGLETTER/$CURDIR/proto/$package
    packagedir=${package%.tar.bz2}

    tar -xf $srcfil
    pushd $packagedir
    ./configure $XORG_CONFIG
    make DESTDIR=$BUILDDIR install
    popd
    rm -rf $packagedir
done
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: util-macros (= 1.19.0)
Description: Xorg Protocol Headers
 The Xorg protocol headers provide the header files required to build the
 system, and to allow other applications to build against the installed X
 Window system.
EOF
}

build
