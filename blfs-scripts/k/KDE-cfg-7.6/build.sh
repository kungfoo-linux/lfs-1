#!/bin/bash -e
. ../../blfs.comm

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/kde.sh << "EOF"
export KDE_PREFIX=/usr
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: KDE Pre-installation Configuration
EOF
}

build
