#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=openal-soft-1.16.0.tar.bz2
srcdir=openal-soft-1.16.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), PortAudio (>= 19), PulseAudio (>= 5.0)
Description: 3D Sound Library
EOF
}

build
