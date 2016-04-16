#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=polkit-gnome-0.105.tar.xz
srcdir=polkit-gnome-0.105
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
mkdir -p $BUILDDIR/etc/xdg/autostart
cat > $BUILDDIR/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop << "EOF"
[Desktop Entry]
Name=PolicyKit Authentication Agent
Comment=PolicyKit Authentication Agent
Exec=/usr/libexec/polkit-gnome-authentication-agent-1
Terminal=false
Type=Application
Categories=
NoDisplay=true
OnlyShowIn=GNOME;XFCE;Unity;
AutostartCondition=GNOME3 unless-session gnome
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GTK+3 (>= 3.12.2), Polkit (>= 0.112)
Description: PolicyKit integration for the GNOME desktop
 he Polkit GNOME package provides an Authentication Agent for Polkit that
 integrates well with the GNOME Desktop environment.
EOF
}

build
