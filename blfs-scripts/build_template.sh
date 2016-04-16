#!/bin/bash -e
. ../../blfs.comm

build_src() {
    version=x.y.z
    srcfil=abc-$version.tar.bz2
    srcdir=abc-$version
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir
    
    ./configure --prefix=/usr
    make $JOBS
    make DESTDIR=$BUILDDIR install
    
    cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: xxx
Recommends:
Suggests:
Description: xxx
EOF
}

build
