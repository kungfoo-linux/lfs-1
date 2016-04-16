#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gnome-keyring-3.12.2.tar.xz
srcdir=gnome-keyring-3.12.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-pam-dir=/lib/security
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: DBus (>= 1.8.8), Gcr (>= 3.12.2), Linux-PAM (>= 1.1.8), \
libxslt (>= 1.1.28), GnuPG (>= 2.0.26), OpenSSH (>= 6.6p1)
Description: a daemon that keeps passwords and other secrets for users
 .
 [gnome-keyring-daemon]
 is a session daemon that keeps passwords for users.
EOF
}

build
