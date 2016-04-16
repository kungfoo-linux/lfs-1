#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=go1.4.2.src.tar.gz
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil -C /opt

pushd /opt/go/src
#./all.bash
./make.bash
popd

mkdir -pv $BUILDDIR/opt
mv /opt/go $BUILDDIR/opt

strip_debug
}

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/go.sh << "EOF"
export GOROOT=/opt/go
export PATH=$PATH:$GOROOT/bin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: The Go Programming Language
 Go is an open source programming language that makes it easy to build simple,
 reliable, and efficient software.
EOF
}

build
