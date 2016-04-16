#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
install -dv -m755 $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/xorg.sh << "EOF"
XORG_PREFIX="/usr"
XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
chmod 644 $BUILDDIR/etc/profile.d/xorg.sh
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Setting up the Xorg Build Environment
 configure file: /etc/profile.d/xorg.sh
EOF
}

build
