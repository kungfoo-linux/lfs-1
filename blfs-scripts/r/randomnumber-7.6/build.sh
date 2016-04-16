#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

build_src() {
mkdir -pv $BUILDDIR
}

configure() {
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-random
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Priority: required
Essential: yes
Description: The kernel's random number generator accessed through userspace.
EOF
}

build
