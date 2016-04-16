#!/bin/bash -e
. ../../blfs.comm

# Setting up Video Devices
video_cfg() {
mkdir -pv $BUILDDIR/etc/X11/xorg.conf.d

cat > $BUILDDIR/etc/X11/xorg.conf.d/videocard-0.conf << "EOF"
Section "Device"
    Identifier  "radeon"
    Driver      "radeon"
    VendorName  "ATI"
    Option      "AccelMethod" "glamor"
EndSection
EOF
}

configure() {
video_cfg
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-Server (>= 1.16.0)
Description: Xorg Configuration
EOF
}

build
