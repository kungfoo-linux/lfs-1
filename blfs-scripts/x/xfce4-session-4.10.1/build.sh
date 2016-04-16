#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfce4-session-4.10.1.tar.bz2
srcdir=xfce4-session-4.10.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-legacy-sm
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libwnck2 (>= 2.30.7), libxfce4ui (>= 4.10.0), Which (>= 2.20)
Description: a session manager for Xfce
 Xfce4 Session is a session manager for Xfce. Its task is to save the state of
 your desktop (opened applications and their location) and restore it during a
 next startup. You can create several different sessions and choose one of
 them on startup.
EOF
}

build
